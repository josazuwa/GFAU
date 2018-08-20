-- outconvert_tb.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--

library ieee;
    use ieee.std_logic_1164.all;
library work;
    use work.glob.all;
    use work.demo_tb.all;

entity outconvert_tb is
end outconvert_tb;

architecture behavioral of outconvert_tb is

    constant n : positive := DEGREE;

    -- component declaration for the unit under test (uut)
    component outconvert
        port(
            clk         : in std_logic;

            convert     : in std_logic;  -- convert flag
            mask        : in std_logic_vector(n downto 0);  -- operand mask

            -- result
            out_sel     : in std_logic_vector(n downto 0);

            -- memory wrapper control signals
            id_con      : out std_logic;
            mem_rdy     : in std_logic;

            -- memory address and data signals
            addr_con    : out std_logic_vector(n downto 0);
            dout_con    : inout std_logic_vector(n downto 0) := (others => 'Z');

            -- final output
            result      : out std_logic_vector(n downto 0);
            rdy_out     : out std_logic -- result ready interrupt
        );
    end component;

    -- inputs
    signal convert : std_logic;  -- convert flag
    signal mask : std_logic_vector(n downto 0);  -- operand mask
    signal out_sel : std_logic_vector(n downto 0);
    signal mem_rdy : std_logic;

    -- outputs
    signal id_con : std_logic;
    signal rdy_out : std_logic;
    signal result : std_logic_vector(n downto 0);
    signal addr_con : std_logic_vector(n downto 0);
    signal dout_con : std_logic_vector(n downto 0);

    -- testbench clocks
    signal clk : std_ulogic := '1';

begin

    -- instantiate the unit under test (uut)
    uut: outconvert port map(
        clk => clk,
        convert => convert,
        mask => mask,
        out_sel => out_sel,
        id_con => id_con,
        mem_rdy => mem_rdy,
        addr_con => addr_con,
        dout_con => dout_con,
        result => result,
        rdy_out => rdy_out
    );

    -- clock process
    clk_proc: process
    begin

        for i in 1 to TNUMS loop
            clk <= not clk;
            wait for (CLK_PER / 2);
            -- clock period = 50 MHz
        end loop;

    end process;

    -- stimulus process
    stim_proc : process
    begin

        mask <= "000000111";
        out_sel <= "010000011";
        dout_con <= "111110011";

        convert <= '0';
        wait for (CLK_PER * 1);

        convert <= '1';
        wait for (CLK_PER * 2);
        mem_rdy <= '1';
        wait for (CLK_PER * 3);

        -- stop simulation
        assert false report "simulation ended" severity failure;

    end process;

end;