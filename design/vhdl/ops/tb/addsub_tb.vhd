-- addsub_tb.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.glob.all;

entity addsub_tb is
end addsub_tb;

architecture behavioral of addsub_tb is

    constant n : positive := DEGREE;

    -- component declaration for the unit under test (uut)
    component addsub
        port(
            i       : in std_logic_vector (n downto 0);
            j       : in std_logic_vector (n downto 0);
            i_null  : in std_logic;
            j_null  : in std_logic;
            bitxor  : out std_logic_vector (n downto 0)
        );
    end component;

    -- inputs
    signal i, j     : std_logic_vector(n downto 0) := (others => '0');
    signal i_null   : std_logic;
    signal j_null   : std_logic;

    -- outputs
    signal bitxor   : std_logic_vector(n downto 0);

    -- testbench clocks
    constant nums   : integer := 320;
    signal clk      : std_ulogic := '1';

begin

    -- instantiate the unit under test (uut)
    uut: addsub port map(
        i => i,
        j => j,
        i_null => i_null,
        j_null => j_null,
        bitxor => bitxor
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
    stim_proc: process
    begin

        -- hold reset state for 20 ns.
        wait for 40 ns;

        i_null <= '0';
        j_null <= '0';

        -- (2 ^ 3) = 1
        i <= "000000010";
        j <= "000000011";

        -- hold reset state for 40 ns.
        wait for 40 ns;

        -- (6 ^ 5) = 3
        i <= "000000110";
        j <= "000000101";

        -- hold reset state for 40 ns.
        wait for 40 ns;

        -- (0 ^ 6) = 6
        i_null <= '1';
        i <= "111111111";
        j <= "000000110";

        -- hold reset state for 40 ns.
        wait for 40 ns;

        -- (6 ^ 1) = 7
        i_null <= '0';
        i <= "000000110";
        j <= "000000001";

        -- hold reset state for 40 ns.
        wait for 40 ns;

        -- (11 ^ 12) = 7
        i <= "000001011";
        j <= "000001100";

        wait for 40 ns;

        -- stop simulation
        assert false report "simulation ended" severity failure;

    end process;

end;
