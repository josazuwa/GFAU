-- control_unit.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--
-- Control unit to parse the opcode and validate operands.
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
library work;
    use work.glob.all;

entity control_unit is
    generic(
        n           : positive := DEGREE
    );
    port(
        clk         : in std_logic;
        opcode      : in std_logic_vector(5 downto 1);   -- op code
        opand1      : in std_logic_vector(n downto 0);   -- operand 1
        opand2      : in std_logic_vector(n downto 0);   -- operand 2

        start       : in std_logic;  -- control unit enable
        rst         : in std_logic; -- global reset

        -- generation signals
        en_gen      : out std_logic;  -- polynomial generator enable
        rst_gen     : out std_logic;  -- polynomial generator reset
        rdy_gen     : in std_logic;  -- generation done

        -- operation signals
        ops_rdy     : out std_logic;  -- operators enable
        rst_ops     : out std_logic;
        i           : out std_logic_vector(n downto 0) := (others => '-');  -- i
        j           : out std_logic_vector(n downto 0) := (others => '-');  -- j

        -- memory wrapper control signals
        id_cu       : out std_logic := '0';
        mem_rdy     : in std_logic;

        -- memory address and data signals
        addr_cu     : out std_logic_vector((n + 1) downto 0);  -- address in memory
        dout_cu     : in std_logic_vector(n downto 0)  -- data from memory
    );
end control_unit;

architecture behavioral of control_unit is

    signal en : std_logic;
    signal ij : std_logic;
    signal came_from_both : std_logic;
    signal ops_rdy_sig    :   std_logic;

    type cu_state_type is (ready, convi, convj, both, gen, memrd);
    signal cu_state : cu_state_type := ready;

    signal rd_state : rd_state_type := send_addr;

begin

    ops_rdy <= ops_rdy_sig;

    process (clk) begin

        if (falling_edge(clk)) then

            if (rst = '1') then

                -- reset operators
                rst_ops <= '1';

                -- disable generator
                rst_gen <= '1';
                en_gen <= '0';

                -- disable memory lookup
                id_cu <= '0';
                addr_cu <= (others => '-');
                cu_state <= ready;
                rd_state <= send_addr;

            else

            case (cu_state) is

                when ready =>
                    rst_ops <= '0';
                    if(ops_rdy_sig = '1') then
                        ops_rdy_sig <= '0';
                    end if;
                    if (start = '1') then
                        en <= '1';
                        case (opcode) is

                            when "00000" | "00001" | "00010" | "00011" =>

                                cu_state <= gen;

                            when "00101" | "01010" | "01110" | "10010" | "10011" =>

                                cu_state <= convi;

                            when "00110" | "01001" | "01101" =>

                                cu_state <= convj;

                            when "00100" | "01011" | "01111" =>

                                cu_state <= both;

                        ----end no memory lookup
                            when "00111" | "01000" | "01100" | "10000" =>

                                i <= opand1;
                                j <= opand2;

                                addr_cu <= (others => '-');
                                ops_rdy_sig <= '1';

                                cu_state <= ready;
                            when others =>

                            ----end try again
                                cu_state <= ready;

                        end case;
                    else
                        en_gen <= '0';
                        rst_gen <= '1';
                    end if;
                    came_from_both <= '0';

                when gen =>

                    if (en = '1') then

                        -- start generator
                        en_gen <= '1';
                        rst_gen <= '0';

                        -- disable memory lookup
                        id_cu <= '0';

                        cu_state <= gen;

                        if (rdy_gen = '1') then

                            -- turn off generator
                            en_gen <= '0';
                            rst_gen <= '0';

                            -- disable memory lookup
                            id_cu <= '0';

                            cu_state <= ready;

                        end if;

                    end if;

                    ops_rdy_sig <= '0';

                when convi =>

                    if (en = '1') then

                        -- came from convi
                        ij <= '0';

                        j <= opand2;

                        ops_rdy_sig <= '0';

                        cu_state <= memrd;

                    end if;

                when convj =>

                    if (en = '1') then

                        -- came from convj
                        ij <= '1';
                        came_from_both <= '0';

                        i <= opand1;

                        ops_rdy_sig <= '0';

                        cu_state <= memrd;

                    end if;

                when memrd =>

                    case (rd_state) is

                        when send_addr =>

                            ops_rdy_sig <= '0';

                            if (ij = '0') then

                                addr_cu <= (not opcode(2)) & opand1;
                                id_cu <= '1';

                            else

                                addr_cu <= (not opcode(1)) & opand2;
                                id_cu <= '1';

                            end if;

                            rd_state <= get_data;

                        when get_data =>

                            if (mem_rdy = '1') then

                                if (ij = '0') then

                                    i <= dout_cu;

                                else

                                    j <= dout_cu;

                                end if;

                                id_cu <= '1';

                                rd_state <= send_addr;

                                if (came_from_both = '1') then

                                    came_from_both <= '0';

                                    cu_state <= memrd;
                                    ij <= '1';

                                else

                                    cu_state <= ready;
                                    ops_rdy_sig <= '1';
                                    en <= '0';

                                end if;

                            end if;

                        end case;

                    when both =>

                        if (en = '1') then

                            came_from_both <= '1';
                            ops_rdy_sig <= '0';

                            cu_state <= convi;

                        end if;

                    end case;  -- control unit state
                end if;

        end if;

    end process;

end behavioral;
