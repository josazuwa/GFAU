-- maskedtwoscmp_tb.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.glob.all;

entity maskedtwoscmp_tb is
end maskedtwoscmp_tb;

architecture behavioral of maskedtwoscmp_tb is

    constant n : positive := DEGREE;

    -- component declaration for the unit under test (uut)
    component maskedtwoscmp
        port(
            num         : in std_logic_vector(n downto 0);
            mask        : in std_logic_vector(n downto 0);
            maskedtc    : out std_logic_vector(n downto 0)
        );
    end component;

    -- inputs
    signal num  : std_logic_vector(n downto 0) := (others => '0');
    signal mask : std_logic_vector(n downto 0) := (others => '0');

    -- outputs
    signal maskedtc : std_logic_vector(n downto 0);

    -- testbench clocks
    constant nums   : integer := 320;
    signal clk      : std_ulogic := '1';

begin

    -- clock process
    clk_proc: process
    begin

        for i in 1 to nums loop
            clk <= not clk;
            wait for 20 ns;
            -- clock period = 50 MHz
        end loop;

    end process;

    -- instantiate the unit under test (uut)
    uut: maskedtwoscmp port map(
        num => num,
        mask => mask,
        maskedtc => maskedtc
    );

    -- stimulus process
    stim_proc: process
    begin

        -- hold reset state for 100 ns.
        wait for 40 ns;
        mask <= "000000111";

        -- 5
        num <= "000000101";
        wait for 40 ns;

        -- 511
        num <= "111111111";
        wait for 40 ns;

        -- 1
        num <= "000000001";
        wait for 40 ns;

        -- 3
        num <= "000000011";
        wait for 40 ns;

        -- 0
        num <= "000000000";

        wait for 40 ns;

        -- stop simulation
        assert false report "simulation ended" severity failure;

    end process;

end;
