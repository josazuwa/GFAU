-- generator.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--
-- Controller for the automatic and generated elements.
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_misc.all;
library work;
    use work.glob.all;

entity generator is
    generic(
        n           : positive := DEGREE;
        clgn1       : positive := CEILLGN1
    );
    port(
        clk         : in std_logic;
        en          : in std_logic;
        rst         : in std_logic;

        -- polynomial data
        poly_bcd    : in std_logic_vector(n downto 0);
        mask        : in std_logic_vector(n downto 0);
        msb         : in std_logic_vector(clgn1 downto 0);
        poly_bcd_reg : out std_logic_vector(n downto 1);

        -- memory wrapper control signals
        id_gen      : out std_logic := '0';
        mem_rdy     : in std_logic;

        -- memory signals
        rdy_gen     : out std_logic := '0';
        addr_gen    : out std_logic_vector((n + 1) downto 0) := (others => '-');
        elem        : out std_logic_vector(n downto 0) := (others => '-')
    );
end generator;

architecture fsm of generator is

    signal counter : std_logic_vector(n downto 0);
    signal temp_elem : std_logic_vector(n downto 0);
    signal temp_elem_f : std_logic_vector(n downto 0);
    signal nth_elem : std_logic_vector(n downto 0);
    signal full : std_logic := '0';

    type flip_state is (e2p, p2e);
    signal flippy_flop : flip_state;

begin

    process (clk) begin

        if rising_edge(clk) then

            if (rst = '1') then

                -- generator control signals
                rdy_gen <= '0';
                id_gen <= '1';

                -- start element register at 2 for second element
                temp_elem <= (0 => '1', others => '0');

                -- start flip element register at 1 for second element
                temp_elem_f <= (0 => '1', others => '0');

                -- start counter at 1
                counter <= (others => '0');
                -- first address
                addr_gen <= (others => '-');
                -- first element
                elem <= (others => '-');

            end if;

            if (en = '1' and rst = '0') then

                -- save this for later :)
                poly_bcd_reg <= poly_bcd(n downto 1);

                -- elem^n
                nth_elem <= (poly_bcd((n - 1) downto 0) & '1') and mask;

                case flippy_flop is

                    when e2p =>

                        if (mem_rdy = '1') then

                            id_gen <= '1';

                            -- when the generator is done
                            if (counter = mask) then

                                -- generator control signals
                                rdy_gen <= '0';

                                -- finish writing
                                full <= '0';

                                -- addr and data of NULL
                                addr_gen <= ((n + 1) => '0', others => '1');
                                elem <= (others => '0');

                            else


                                -- if elem^(n+(m-1))[msb] = 1
                                if (temp_elem(to_integer(unsigned(msb))) = '1') then

                                    -- (elem^(n+(m-1)) << 1) xor elem^n
                                    temp_elem <= (temp_elem(n - 1 downto 0) & '0')
                                     xor nth_elem;

                                else
                                    -- (elem^(n+(m-1)) << 1)
                                    temp_elem <= (temp_elem(n - 1 downto 0) & '0');

                                end if;

                                -- generator control signals
                                rdy_gen <= '0';
                                id_gen <= '1';

                                -- address is counter, element is the temp element
                                -- register
                                addr_gen <= '0' & counter;
                                elem <= temp_elem and mask;
                                temp_elem_f <= temp_elem and mask;

                            end if;

                            flippy_flop <= p2e;

                        end if;

                    when p2e =>

                        if (mem_rdy = '1') then

                            if (full = '1') then

                                -- addr and data of NULL
                                addr_gen <= (others => '-');
                                elem <= (others => '-');

                                -- generator control signals
                                rdy_gen <= '1';
                                id_gen <= '0';

                            else

                                -- when the generator is done
                                if (counter = mask) then

                                    -- generator control signals
                                    rdy_gen <= '0';
                                    id_gen <= '1';

                                    -- finish writing
                                    full <= '1';

                                    -- addr and data of NULL
                                    addr_gen <= ((n + 1) => '1', others => '0');
                                    elem <= (others => '1');

                                else

                                    addr_gen <= '1' & (temp_elem_f and mask);
                                    elem <= counter;

                                    -- increment counter
                                    counter <= std_logic_vector(unsigned(counter) + 1);

                                    flippy_flop <= e2p;

                                end if;

                            end if;

                        end if;  -- memory ready

                    end case;

            end if;

        end if;  -- clk

    end process;

end fsm;
