-- outselect_tb.vhd
--
-- Sabbir Ahmed, Jeffrey Osazuwa
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.glob.all;

entity outselect_tb is
end outselect_tb;

architecture behavioral of outselect_tb is

    constant n : positive := DEGREE;

    -- component declaration for the unit under test (uut)
    component outselect
        port(
            convert : in std_logic;
            mask    : in std_logic_vector(n downto 0);
            out_sel : in std_logic_vector(n downto 0);
            out_mem : in std_logic_vector(n downto 0);
            result  : out std_logic_vector(n downto 0)
        );
    end component;

    -- inputs
    signal convert : std_logic;
    signal mask : std_logic_vector(n downto 0) := (others => '0');
    signal out_sel : std_logic_vector(n downto 0) := (others => '0');
    signal out_mem : std_logic_vector(n downto 0) := (others => '0');

    -- outputs
    signal result : std_logic_vector(n downto 0) := (others => '0');

    -- testbench clocks
    constant nums : integer := 320;
    signal clk : std_ulogic := '1';

begin

    -- instantiate the unit under test (uut)
    uut: outselect port map(
        convert => convert,
        mask => mask,
        out_sel => out_sel,
        out_mem => out_mem,
        result => result
    );

    -- clock process
    clk_proc: process
    begin

        for i in 1 to nums loop
            clk <= not clk;
            wait for 20 ns;
            -- clock period = 50 MHz
        end loop;

    end process;

    -- stimulus process
    stim_proc : process
    begin

        -- hold reset state for 20 ns.
        wait for 40 ns;

        -- addsub
        opcode <= "001010";
        out_as <= "1111111111111110";
        out_m <= "0111111111111111";
        out_d <= "0011111111111111";
        out_l <= "0001111111111111";
        i_null <= '1';
        j_null <= '1';

        -- hold reset state for 40 ns.
        wait for 40 ns;

        -- mul
        opcode <= "010010";

        -- hold reset state for 40 ns.
        wait for 40 ns;

        -- div
        opcode <= "011010";

        -- hold reset state for 40 ns.
        wait for 40 ns;

        -- log
        opcode <= "100010";

        -- hold reset state for 40 ns.
        wait for 40 ns;

        -- convert
        opcode <= "000111";

        wait for 40 ns;

        -- stop simulation
        assert false report "simulation ended" severity failure;

    end process;

end;