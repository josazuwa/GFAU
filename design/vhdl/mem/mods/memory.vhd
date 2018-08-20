-- memory.vhd
--
-- Sabbir Ahmed, Brian Weber
-- 2018-03-30
--
-- Wrapper for the CY7C1020DV33 memory chips.
--
-- CY7C1020DV33 truth table
--------------------------------------
-- signal   read    write   stand-by
-- nCE      0       0       1
-- nOE      0       -       -
-- nWE      1       0       -
-- nBLE     0       0       -
-- nBHE     0       0       -
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
    use work.glob.all;

entity memory is
    generic(
        n           : positive := DEGREE
    );
    port(
        -- clock
        clk         : in std_logic;

        -- memory types and methods
        mem_t_con   : in std_logic;
        --mem_t_gen   : in std_logic;
        mem_rdy     : out std_logic;  -- ready

        -- module signals
        id_cu       : in std_logic;
        addr_cu     : in std_logic_vector((n + 1) downto 0);
        dout_cu     : out std_logic_vector(n downto 0);
        id_con      : in std_logic;
        addr_con    : in std_logic_vector(n downto 0);
        dout_con    : out std_logic_vector(n downto 0);
        id_gen      : in std_logic;
        addr_gen    : in std_logic_vector((n + 1) downto 0);
        din_gen     : in std_logic_vector(n downto 0);

        -- memory control signals
        nCE         : out std_logic;
        nWE         : out std_logic;
        nOE         : out std_logic;
        nBLE        : out std_logic;
        nBHE        : out std_logic;

        -- memory address and data signals
        A           : out std_logic_vector((n + 1) downto 0);
        DQ          : inout std_logic_vector(n downto 0)
    );
end memory;

architecture behavioral of memory is

    -- define the states for reading data
    signal rd_state     : rd_state_type;

    -- define the states for writing data
    signal wr_state     : wr_state_type;

    --used for setting up address before writing
    signal setup        : setup_type;
    signal ioport_oe    : std_logic;

	--internal DQ signals
	signal DQ_in		: std_logic_vector(n downto 0);
	signal DQ_out		: std_logic_vector(n downto 0);
	signal wr_rd		: std_logic;

    component io_port
        port(
            op  : in std_logic_vector(n downto 0);  --out to pad
            oe  : in std_logic;                         --enable pad output
            ip  : out std_logic_vector(n downto 0);  --in from pad
            pad : inout std_logic_vector(n downto 0)   --external io pad
        );
    end component;

begin

    io_port_unit : io_port port map(
        op      => DQ_in,
        oe      => wr_rd,
        ip      => DQ_out,
        pad     => DQ
    );

    process (clk) begin

        if (rising_edge(clk)) then

            -- control unit
            if (id_cu = '1' and id_gen = '0' and id_con = '0') then

                dout_con <= (others => '-');

                -- memory read control signals
                nCE <= '0';
                nOE <= '0';
                nWE <= '1';
                nBLE <= '0';
                nBHE <= '0';

                wr_rd <= '0'; -- set iobus mode to read

                -- send output converter's address to memory
                A <= addr_cu;

                case rd_state is

                    when send_addr =>

                        mem_rdy <= '0';

                        rd_state <= get_data;

                    when get_data =>

                        -- send dout to output converter
                        dout_cu <= DQ_out; --read from iobus in

                        mem_rdy <= '1';

                        rd_state <= send_addr;

                    when others =>

                        -- stand-by control signals
                        nCE <= '1';
                        nWE <= '-';

                        -- data outs are don't care
                        dout_con <= (others => '-');
                        dout_cu <= (others => '-');

                        mem_rdy <= '0';

                        rd_state <= send_addr;

                end case;

            -- output converter
            elsif (id_gen = '0' and id_con = '1') then

                dout_cu <= (others => '-');

                -- memory read control signals
                nCE <= '0';
                nOE <= '0';
                nWE <= '1';
                nBLE <= '0';
                nBHE <= '0';

                wr_rd <= '0'; --set iobus mode to read

                -- send output converter's address to memory
                A <= mem_t_con & addr_con;

                case rd_state is

                    when send_addr =>

                        mem_rdy <= '0';

                        rd_state <= get_data;

                    when get_data =>

                        -- send dout to output converter
                        dout_con <= DQ_out; --read from iobus in

                        mem_rdy <= '1';

                        rd_state <= send_addr;

                    when others =>

                        -- stand-by control signals
                        nCE <= '1';
                        nWE <= '-';

                        -- data outs are don't care
                        dout_con <= (others => '-');

                        mem_rdy <= '0';

                        rd_state <= send_addr;

                end case;

            -- generator
            elsif (id_cu = '0' and id_gen = '1' and id_con = '0') then

                -- data outs are don't care
                dout_con <= (others => '-');
                dout_cu <= (others => '-');
                wr_rd <= '1'; -- sets the io port to output mode

                --hold address, data, and bus control signals
                A <= addr_gen;
                DQ_in <= din_gen(n downto 0);

                -- send control unit's address to memory
                nOE <= '1';
                nCE <= '0';
                nBLE <= '0';
                nBHE <= '0';

                case setup is

                    when addr_setup =>

                        -- memory read control signals
                        nWE <= '1'; -- don't write yet
                        mem_rdy <= '0'; -- data not ready

                        setup <= wr;

                    when wr =>

                        nWE <= '0';
                        mem_rdy <= '1'; -- data not ready

                        setup <= addr_setup;

                end case;

            else

                -- stand-by control signals
                nCE <= '1';
                nWE <= '-';
                nOE <= '-';
                nBLE <= '0';
                nBHE <= '0';

                mem_rdy <= '0';

                -- data outs are don't care
                dout_con <= (others => '-');
                dout_cu <= (others => '-');

            end if;

        end if;

    end process;

end behavioral;
