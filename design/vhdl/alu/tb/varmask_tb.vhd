-- varmask_tb.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.glob.all;
    use work.demo_tb.all;

entity varmask_tb is
end varmask_tb;

architecture behavioral of varmask_tb is

    constant n : positive := DEGREE;

    -- component declaration for the unit under test (uut)
    component varmask
        port(
            poly_bcd    : in  std_logic_vector(n downto 1);
            mask        : out std_logic_vector(n downto 0)
        );
    end component;

    -- inputs
    signal poly_bcd : std_logic_vector(n downto 1) := (others => '0');

    -- outputs
    signal mask    : std_logic_vector(n downto 0);

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
    uut: varmask port map(
        poly_bcd => poly_bcd,
        mask => mask
    );

    -- stimulus process
    stim_proc: process
    begin

        -- hold reset state for 100 ns.
        wait for (CLK_PER * 2);

        -- x^3 + x^2 + 1
        poly_bcd <= "0000011";
        wait for (CLK_PER * 2);

        -- x^7
        poly_bcd <= "0100001";
        wait for (CLK_PER * 2);

        -- x^8
        poly_bcd <= "1111111";

        wait for (CLK_PER * 2);

        -- stop simulation
        assert false report "simulation ended" severity failure;

    end process;

end;
