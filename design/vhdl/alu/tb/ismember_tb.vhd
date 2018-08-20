-- ismember_tb.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.glob.all;

entity ismember_tb is
end ismember_tb;

architecture behavioral of ismember_tb is

    constant n : positive := DEGREE;

    -- component declaration for the unit under test (uut)
    component ismember
        port(
            operand     : in  std_logic_vector(n downto 0);
            mask        : in  std_logic_vector(n downto 0);
            is_not_in   : out std_logic
        );
    end component;

    -- inputs
    signal operand      : std_logic_vector(n downto 0) := (others => '0');
    signal mask         : std_logic_vector(n downto 0) := (others => '0');

    -- outputs
    signal is_not_in : std_logic;

    -- testbench clocks
    constant nums       : integer := 320;
    signal clk          : std_ulogic := '1';

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
    uut: ismember port map(
        operand => operand,
        mask => mask,
        is_not_in => is_not_in
    );

    -- stimulus process
    stim_proc: process
    begin

        -- 3-bit mask
        mask <= "000000111";

        -- 5
        operand <= "000000101";
        wait for 40 ns;

        -- 3
        operand <= "000000011";
        wait for 40 ns;

        -- 7
        operand <= "000000111";
        wait for 40 ns;

        -- 0
        operand <= "000000000";
        wait for 40 ns;

        -- 65534
        operand <= "111111110";

        wait for 40 ns;

        -- 65535
        operand <= "111111111";

        wait for 40 ns;

        -- 4-bit mask
        mask <= "000001111";

        -- 7
        operand <= "000000111";

        wait for 40 ns;

        -- 65534
        operand <= "111111110";

        wait for 40 ns;

        -- stop simulation
        assert false report "simulation ended" severity failure;

    end process;

end;
