-- operators_tb.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.glob.all;
    use work.demo_tb.all;

entity operators_tb is
end operators_tb;

architecture behavioral of operators_tb is

    constant n : positive := DEGREE;
    constant clgn : positive := CEILLGN;

    -- component declaration for the unit under test (uut)
    component operators
        port(
            -- clock
            clk         : in std_logic;

            ops_rdy      : in std_logic;
            rst         : in std_logic;

            -- opcode
            opcode      : in std_logic_vector(5 downto 0);

            -- operands
            i           : in std_logic_vector(n downto 0);
            j           : in std_logic_vector(n downto 0);

            -- registers
            size        : in std_logic_vector(clgn downto 0);  -- size
            mask        : in std_logic_vector(n downto 0);  -- mask

            -- memory types and methods
            mem_t       : out std_logic; -- memory type

            -- memory wrapper control signals
            id_con      : out std_logic;
            mem_rdy     : in std_logic;

            -- memory address and data signals
            addr_con    : out std_logic_vector(n downto 0);
            dout_con    : inout std_logic_vector(n downto 0);

            result      : out std_logic_vector(n downto 0); -- selected output
            err_z       : out std_logic; -- zero exception
            rdy_out     : out std_logic -- result ready interrupt
        );
    end component;

    -- inputs
    signal opcode : std_logic_vector(5 downto 0);
    signal ops_rdy : std_logic := '0';
    signal rst : std_logic := '0';
    signal i : std_logic_vector(n downto 0);
    signal j : std_logic_vector(n downto 0);
    signal size : std_logic_vector(clgn downto 0);
    signal mask : std_logic_vector(n downto 0);

    -- outputs
    signal addr_con : std_logic_vector(n downto 0);
    signal dout_con : std_logic_vector(n downto 0);
    signal id_con : std_logic;
    signal mem_t : std_logic;
    signal mem_rdy : std_logic := '1';
    signal err_z : std_logic;
    signal rdy_out : std_logic;
    signal result : std_logic_vector(n downto 0);

    -- testbench clocks
    signal clk : std_ulogic := '1';

begin

    -- instantiate the unit under test (uut)
    uut: operators port map(
        clk => clk,
        opcode => opcode,
        ops_rdy => ops_rdy,
        rst => rst,
        i => i,
        j => j,
        size => size,
        mask => mask,
        mem_t => mem_t,
        id_con => id_con,
        mem_rdy => mem_rdy,
        addr_con => addr_con,
        dout_con => dout_con,
        result => result,
        err_z => err_z,
        rdy_out => rdy_out
    );

    -- clock process
    clk_proc: process
    begin

        for i in 1 to TNUMS loop
            clk <= not clk;
            wait for (CLK_PER / 2);
        end loop;

    end process;

    -- stimulus process
    stim_proc: process
    begin

        i <= "00000101";
        j <= "11111111";
        size <= "0011";
        mask <= "00000111";

        -- hold state for 10 ns
        wait for (CLK_PER * 1);
        ops_rdy <= '1';

        -- generator
        opcode <= "000000";

        -- hold state for 10 ns
        wait for (CLK_PER * 1);

        -- add/sub, poly
        opcode <= "011000";

        -- hold state for 10 ns
        wait for (CLK_PER * 1);

        ---- mul, elem
        --opcode <= "010";

        ---- hold state for 10 ns
        --wait for (CLK_PER * 1);

        --dout_con <= "00000100";
        --mem_rdy <= '1';
        ---- div, elem
        --opcode <= "011";

        ---- hold state for 10 ns
        --wait for (CLK_PER * 3);

        ---- log, elem
        --i_null <= '1';
        --opcode <= "100";

        --wait for (CLK_PER * 1);

        ---- log, elem
        --i_null <= '0';

        wait for (CLK_PER * 1);

        -- stop simulation
        assert false report "simulation ended" severity failure;

    end process;

end;
