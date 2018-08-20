-- generator_tb.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.glob.all;
    use work.demo_tb.all;

entity generator_tb is
end generator_tb;

architecture test of generator_tb is

    constant n : positive := DEGREE;
    constant clgn : positive := CEILLGN;
    constant clgn1 : positive := CEILLGN1;

    -- component declaration for the unit under test (uut)
    component generator
        port(
            clk         : in std_logic;
            en          : in std_logic;
            rst         : in std_logic;

            -- polynomial data
            poly_bcd    : in std_logic_vector((n - 1) downto 0);
            mask        : in std_logic_vector(n downto 0);
            msb         : in std_logic_vector(clgn1 downto 0);
            poly_bcd_reg : out std_logic_vector((n - 1) downto 0);

            -- memory wrapper control signals
            id_gen      : out std_logic := '0';
            mem_rdy     : in std_logic;

            -- memory signals
            rdy_gen     : out std_logic := '0';
            addr_gen    : out std_logic_vector((n + 1) downto 0) := (others => '-');
            elem        : out std_logic_vector(n downto 0) := (others => '-')
        );
    end component;

    -- inputs
    signal poly_bcd : std_logic_vector((n - 1) downto 0);
    signal mask : std_logic_vector(n downto 0);
    signal msb : std_logic_vector(clgn1 downto 0);
    signal mem_rdy : std_logic := '1';

    -- outputs
    signal rdy_gen : std_logic;
    signal id_gen : std_logic;
    signal addr_gen : std_logic_vector((n + 1) downto 0);
    signal elem : std_logic_vector(n downto 0);
    signal poly_bcd_reg: std_logic_vector((n - 1) downto 0);

    -- testbench clocks
    constant nums : integer := 640;
    signal clk : std_logic := '1';
    signal rst : std_logic := '1';
    signal en : std_logic := '0';

begin

    -- instantiate the unit under test (uut)
    uut: generator port map(
        clk => clk,
        en => en,
        rst => rst,
        poly_bcd => poly_bcd,
        mask => mask,
        msb => msb,
        poly_bcd_reg => poly_bcd_reg,
        id_gen => id_gen,
        mem_rdy => mem_rdy,
        rdy_gen => rdy_gen,
        addr_gen => addr_gen,
        elem => elem
    );

    -- clock process
    clk_proc: process
    begin

        for i in 1 to nums loop
            clk <= not clk;
            wait for (CLK_PER / 2);
            -- clock period = 50 MHz
        end loop;

    end process;

    -- clock process
    mem_proc: process
    begin

        for i in 1 to nums loop
            mem_rdy <= not mem_rdy;
            wait for (CLK_PER * 2);
        end loop;

    end process;

    -- stimulus process
    stim_proc: process
    begin

        mask <= "00000111";
        msb <= "010";
        poly_bcd <= "0000110";
        rst <= '1';

        -- hold reset state for 10 ns.
        wait for (CLK_PER * 1);

        en <= '1';
        rst <= '0';

        wait for (CLK_PER * 35);

        -- stop simulation
        assert false report "simulation ended" severity failure;

    end process;

end;
