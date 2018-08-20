-- memory_tb.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.glob.all;
    use work.demo_tb.all;

entity memory_tb is
end memory_tb;

architecture behavioral of memory_tb is

    constant n : positive := DEGREE;

    -- component declaration for the unit under test (uut)
    component mem
        port(
            -- clock
            clk         : in std_logic;

            -- memory types and methods
            mem_t_cu    : in std_logic;
            mem_t_con   : in std_logic;
            mem_rdy     : out std_logic;  -- ready

            -- module signals
            id_cu       : in std_logic;
            addr_cu     : in std_logic_vector(n downto 0);
            dout_cu     : out std_logic_vector(n downto 0);
            id_con      : in std_logic;
            addr_con    : in std_logic_vector(n downto 0);
            dout_con    : out std_logic_vector(n downto 0);
            id_gen      : in std_logic;
            addr_gen    : in std_logic_vector(n downto 0);
            din_gen     : in std_logic_vector(n downto 0);

            -- memory control signals
            nCE         : out std_logic;
            nWE         : out std_logic;
            nOE         : out std_logic;

            -- memory address and data signals
            A           : out std_logic_vector((n + 1) downto 0);
            DQ          : inout std_logic_vector(n downto 0)
        );
    end component;

    -- memory types and methods
    signal mem_t_cu    : std_logic;
    signal mem_t_con   : std_logic;
    signal mem_rdy     : std_logic;  -- ready

    -- module signals
    signal id_cu       : std_logic;
    signal addr_cu     : std_logic_vector(n downto 0);
    signal dout_cu     : std_logic_vector(n downto 0);
    signal id_con      : std_logic;
    signal addr_con    : std_logic_vector(n downto 0);
    signal dout_con    : std_logic_vector(n downto 0);
    signal id_gen      : std_logic;
    signal addr_gen    : std_logic_vector(n downto 0);
    signal din_gen     : std_logic_vector(n downto 0);

    -- memory control signals
    signal nCE         : std_logic;
    signal nWE         : std_logic;
    signal nOE         : std_logic;

    -- memory address and data signals
    signal A           : std_logic_vector((n + 1) downto 0);
    signal DQ          : std_logic_vector(n downto 0)

    -- testbench clocks
    constant nums   : integer := 320;
    signal clk      : std_ulogic := '1';

begin

    -- clock process
    clk_proc: process
    begin

        for i in 1 to nums loop
            clk <= not clk;
            wait for (CLK_PER / 2);
        end loop;

    end process;


    -- instantiate the unit under test (uut)
    uut: mem port map(
        clk <= clk,
        mem_t_cu <= mem_t_cu,
        mem_t_con <= mem_t_con,
        mem_rdy <= mem_rdy,
        id_cu <= id_cu,
        addr_cu <= addr_cu,
        dout_cu <= dout_cu,
        id_con <= id_con,
        addr_con <= addr_con,
        dout_con <= dout_con,
        id_gen <= id_gen,
        addr_gen <= addr_gen,
        din_gen <= din_gen,
        nCE <= nCE,
        nWE <= nWE,
        nOE <= nOE,
        A <= A,
        DQ <= DQ
    );

    -- stimulus process
    stim_proc: process
    begin

        -- hold reset state for 100 ns.
        wait for (CLK_PER * 2);

        wait for (CLK_PER * 2);

        wait for (CLK_PER * 2);

        wait for (CLK_PER * 4);

        -- stop simulation
        assert false report "simulation ended" severity failure;

    end process;

end;
