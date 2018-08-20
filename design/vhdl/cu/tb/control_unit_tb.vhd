-- control_unit_tb.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
    use work.glob.all;
    use work.demo_tb.all;

entity control_unit_tb is
end control_unit_tb;

architecture behavior of control_unit_tb is

    constant n : positive := DEGREE;

    -- component declaration for the unit under test (uut)
    component control_unit
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
    end component;

    -- inputs
    signal opcode : std_logic_vector(5 downto 1);   -- op code
    signal opand1 : std_logic_vector(n downto 0);   -- operand 1
    signal opand2 : std_logic_vector(n downto 0);   -- operand 2
    signal start : std_logic := '0';
    signal rst : std_logic := '0';

    -- outputs
    signal ops_rdy : std_logic;
    signal rdy_gen : std_logic;
    signal rst_gen : std_logic;
    signal en_gen : std_logic;  -- poly generation
    signal i : std_logic_vector(n downto 0);  -- address in memory
    signal j : std_logic_vector(n downto 0);  -- address in memory
    signal err_b : std_logic;
    signal opand1_null : std_logic;
    signal opand2_null : std_logic;

    -- memory signals
    signal mem_rdy : std_logic := '1';  -- read signal to memory
    signal id_cu : std_logic;  -- read signal to memory
    signal addr_cu : std_logic_vector((n + 1) downto 0);  -- address in memory
    signal dout_cu : std_logic_vector(n downto 0) := "00000000";  -- data

    -- clocks
    signal clk : std_ulogic := '1';

begin

    -- instantiate the unit under test (uut)
    uut: control_unit port map(
        clk => clk,
        opcode => opcode,
        opand1 => opand1,
        opand2 => opand2,
        start => start,
        rst => rst,
        ops_rdy => ops_rdy,
        en_gen => en_gen,
        rst_gen => rst_gen,
        rdy_gen => rdy_gen,
        i => i,
        j => j,
        id_cu => id_cu,
        mem_rdy => mem_rdy,
        addr_cu => addr_cu,
        dout_cu => dout_cu
    );

    -- clock process
    clk_proc: process
    begin

        for i in 1 to TNUMS loop
            clk <= not clk;
            wait for (CLK_PER / 2);
        end loop;

    end process;

    -- data process
    data_proc: process
    begin

        for i in 1 to TNUMS loop
            dout_cu <= std_logic_vector(unsigned(dout_cu) + 1);
            wait for (CLK_PER * 4);
        end loop;

    end process;

    mem_proc: process
    begin

        for i in 1 to TNUMS loop
            mem_rdy <= not mem_rdy;
            wait for (CLK_PER / 2);
        end loop;

    end process;

    -- stimulus process
    test : process
    begin

        start <= '1';
        opand1 <= "00000101";
        opand2 <= "00000011";
        opcode <= "00100";  -- add/sub, operands in polynomial

        rdy_gen <= '0';
        wait for (CLK_PER * 1);

        start <= '0';

        wait for (CLK_PER * 8);

        start <= '1';

        opand1 <= "00000111";  -- 2^n-1
        opand2 <= "11111111";  -- zero in element
        opcode <= "01011";  -- division, operands in element

        wait for (CLK_PER * 1);

        start <= '0';

        wait for (CLK_PER * 8);

        opcode <= "000XX";  -- generator
        wait for (CLK_PER * 2);

        -- stop simulation
        assert false report "simulation ended" severity failure;

        wait;

    end process;

end;
