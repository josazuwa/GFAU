--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   12:29:31 05/09/2018
-- Design Name:
-- Module Name:   /home/brian/gfau/design/vhdl/io/ISE/IO_Handler_Test.vhd
-- Project Name:  IO_Handler
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: IO_Handler_Top
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY IO_Handler_Test IS
END IO_Handler_Test;

ARCHITECTURE behavior OF IO_Handler_Test IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT IO_Handler_Top
    PORT(
         data : INOUT  std_logic_vector(31 downto 0);
         Start : IN  std_logic;
         t_clk_in : IN  std_logic;
         g_rst : IN  std_logic;
         ready_sig : OUT  std_logic;
         err : OUT  std_logic;
         INT : OUT  std_logic;
         INTA : IN  std_logic;
         clk : IN  std_logic;
         op_done : IN  std_logic;
         opcode_out : OUT  std_logic_vector(5 downto 0);
         rst : OUT  std_logic;
         gen_rdy : IN  std_logic;
         gfau_data : IN  std_logic_vector(15 downto 0);
         out_data : OUT  std_logic_vector(31 downto 0);
         input_size : out  std_logic_vector(3 downto 0);
          cu_start    :   out     std_logic;
         z_err : IN  std_logic;
         oob_err : IN  std_logic
        );
    END COMPONENT;

    component io_port
    generic(
        n           :   positive
    );
    port(
        op          :   in      std_logic_vector(n downto 0);
        oe          :   in      std_logic;
        ip          :   out     std_logic_vector(n downto 0);
        pad         :   inout   std_logic_vector(n downto 0)
    );
    end component;

   --Inputs
   signal Start : std_logic := '0';
   signal t_clk_in : std_logic := '0';
   signal g_rst : std_logic := '0';
   signal INTA : std_logic := '0';
   signal clk : std_logic := '0';
   signal op_done : std_logic := '0';
   signal gen_rdy : std_logic := '0';
   signal gfau_data : std_logic_vector(15 downto 0) := (others => '0');
   signal input_size : std_logic_vector(3 downto 0) := (others => '0');
   signal z_err : std_logic := '0';
   signal oob_err : std_logic := '0';

	--BiDirs
   signal data : std_logic_vector(31 downto 0);

 	--Outputs
   signal ready_sig : std_logic;
   signal err : std_logic;
   signal INT : std_logic;
   signal opcode_out : std_logic_vector(5 downto 0);
   signal rst : std_logic;
   signal out_data : std_logic_vector(31 downto 0);
   signal cu_start : std_logic;

    signal indata   :   std_logic_vector(31 downto 0) := (others => '0');
    signal outdata  :   std_logic_vector(31 downto 0) := (others => '0');
    signal wrrd     :   std_logic := '0';

   -- Clock period definitions
   constant t_clk_period : time := 13 ns;
   constant clk_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: IO_Handler_Top PORT MAP (
          data => data,
          Start => Start,
          t_clk_in => t_clk_in,
          g_rst => g_rst,
          ready_sig => ready_sig,
          err => err,
          INT => INT,
          INTA => INTA,
          clk => clk,
          op_done => op_done,
          opcode_out => opcode_out,
          rst => rst,
          gen_rdy => gen_rdy,
          gfau_data => gfau_data,
          out_data => out_data,
          input_size => input_size,
          cu_start => cu_start,
          z_err => z_err,
          oob_err => oob_err
        );

    iop     :   io_port generic map(
        n           => 31
    ) port map (
        op          => outdata,
        oe          => wrrd,
        ip          => indata,
        pad         => data
    );

   -- Clock process definitions
   t_clk_process :process
   begin
		t_clk_in <= '0';
		wait for t_clk_period/2;
		t_clk_in <= '1';
		wait for t_clk_period/2;
   end process;

   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin
      input_size <= "1101";
      gfau_data <= "0001010101010101";
      -- hold reset state for 100 ns.
      g_rst <= '1';
      wrrd <= '1';
      wait for 40 ns;
      g_rst <= '0';

      --set mode
      wait until falling_edge(t_clk_in);
      outdata(5 downto 0) <= "110000";
      Start <= '1';
      wait until falling_edge(t_clk_in);
      outdata(5 downto 0) <= "001000";
      wait until falling_edge(t_clk_in);
      Start <= '0';
      outdata(31 downto 0) <= "00000000000000000000000010000001";
      wait until falling_edge(t_clk_in);
      outdata(7 downto 0) <= "00010001";
      wait until falling_edge(t_clk_in);
      outdata(7 downto 0) <= "10000001";
      wait until falling_edge(t_clk_in);
      outdata(7 downto 0) <= "00010001";
      wait for 40 ns;
      wrrd <= '0';
      wait until rising_edge(clk);
      op_done <= '1';
      wait until falling_edge(t_clk_in);
      wait until falling_edge(t_clk_in);
      INTA <= '1';
      wait until falling_edge(t_clk_in);
      INTA <= '0';
      wait until rising_edge(ready_sig);
      wrrd <= '1';
      wait until falling_edge(t_clk_in);
      outdata(5 downto 0) <= "000000";
      Start <= '1';
      wait until falling_edge(t_clk_in);
      Start <= '0';
      outdata(12 downto 0) <= "1001100011111";
      wait until falling_edge(t_clk_in);
      wait for 40 ns;
      wait until rising_edge(clk);
      gen_rdy <= '1';
      wait until rising_edge(int);
      wait until falling_edge(t_clk_in);
      INTA <= '1';
      wait until falling_edge(t_clk_in);
      INTA <= '0';

        wait for 40 ns;
        -- stop simulation
        assert false report "simulation ended" severity failure;
      --Start <= '0';
      --wait for 26 ns;
      --deserial_d <= '1';
      --wait for 13 ns;
      --deserial_d <= '0';
      --wait for 39 ns;
      --gen_rdy <= '1';
      --wait for 13 ns;
      --gen_rdy <= '0';
      --INTA <= '1';
      --wait for 13 ns;
      --INTA <= '0';
      --data(5 downto 0) <= "001000";
      --Start <= '1';
      --wait for 13 ns;
      --Start <= '0';
      --wait for 26 ns;
      --deserial_d <= '1';
      --wait for 13 ns;
      --deserial_d <= '0';
      --wait for 13 ns;
      --op_done <= '1';
      --wait for 13 ns;
      --op_done <= '0';
      --INTA <= '1';
      --wait for 13 ns;
      --INTA <= '0';
      --serial_d <= '1';
      --wait for 13 ns;
      --serial_d <= '0';
      --wait for 13 ns;
      --data(5 downto 0) <= "001000";
      --Start <= '1';
      --wait for 13 ns;
      --Start <= '0';
      --wait for 26 ns;
      --deserial_d <= '1';
      --wait for 13 ns;
      --deserial_d <= '0';
      --wait for 13 ns;
      --op_done <= '1';
      --wait for 13 ns;
      --op_done <= '0';
      --g_rst <= '1';
      --wait for 13 ns;
      --g_rst <= '0';
      --data(5 downto 0) <= "001000";
      --Start <= '1';
      --wait for 13 ns;
      --Start <= '0';
      --wait for 26 ns;
      --deserial_d <= '1';
      --wait for 13 ns;
      --deserial_d <= '0';
      --wait for 13 ns;
      --z_err <= '1';
      --wait for 13 ns;
      --z_err <= '0';
      --INTA <= '1';
      --wait for 13 ns;
      --INTA <= '0';
      wait;
  end process stim_proc;

END;
