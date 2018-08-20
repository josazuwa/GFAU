--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:37:28 05/06/2018
-- Design Name:   
-- Module Name:   /media/sf_Xilinx/IO_Handler/IO_Handler_ISE/FSM_Test.vhd
-- Project Name:  IO_Handler_ISE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IO_Handler_FSM
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
 
ENTITY FSM_Test IS
END FSM_Test;
 
ARCHITECTURE behavior OF FSM_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IO_Handler_FSM
    PORT(
         opcode_in : IN  std_logic_vector(5 downto 0);
         Start : IN  std_logic;
         --Done : IN  std_logic;
         t_clk : IN  std_logic;
         g_rst : IN  std_logic;
         ready_sig : OUT  std_logic;
         INT : OUT  std_logic;
         INTA : IN  std_logic;
         clk : IN  std_logic;
         op_done : IN  std_logic;
         opcode_out : OUT  std_logic_vector(5 downto 0);
         data_ready : OUT  std_logic;
         rst : OUT  std_logic;
         gen_rdy : IN  std_logic;
         serial_e : OUT  std_logic;
         serial_r : OUT  std_logic;
         serial_d : IN  std_logic;
         deserial_e : OUT  std_logic;
         deserial_r : OUT  std_logic;
         deserial_d : IN  std_logic;
         mode_wr : OUT  std_logic;
         poly_get : OUT  std_logic;
         count_rst : OUT  std_logic;
         z_err : IN  std_logic;
         oob_err : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal opcode_in : std_logic_vector(5 downto 0) := (others => '0');
   signal Start : std_logic := '0';
   --signal Done : std_logic := '0';
   signal t_clk : std_logic := '0';
   signal g_rst : std_logic := '0';
   signal INTA : std_logic := '0';
   signal clk : std_logic := '0';
   signal op_done : std_logic := '0';
   signal gen_rdy : std_logic := '0';
   signal serial_d : std_logic := '0';
   signal deserial_d : std_logic := '0';
   signal z_err : std_logic := '0';
   signal oob_err : std_logic := '0';

 	--Outputs
   signal ready_sig : std_logic;
   signal INT : std_logic;
   signal opcode_out : std_logic_vector(5 downto 0);
   signal data_ready : std_logic;
   signal rst : std_logic;
   signal serial_e : std_logic;
   signal serial_r : std_logic;
   signal deserial_e : std_logic;
   signal deserial_r : std_logic;
   signal mode_wr : std_logic;
   signal poly_get : std_logic;
   signal count_rst : std_logic;

   -- Clock period definitions
   constant t_clk_period : time := 13 ns;
   constant clk_period : time := 5 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IO_Handler_FSM PORT MAP (
          opcode_in => opcode_in,
          Start => Start,
          --Done => Done,
          t_clk => t_clk,
          g_rst => g_rst,
          ready_sig => ready_sig,
          INT => INT,
          INTA => INTA,
          clk => clk,
          op_done => op_done,
          opcode_out => opcode_out,
          data_ready => data_ready,
          rst => rst,
          gen_rdy => gen_rdy,
          serial_e => serial_e,
          serial_r => serial_r,
          serial_d => serial_d,
          deserial_e => deserial_e,
          deserial_r => deserial_r,
          deserial_d => deserial_d,
          mode_wr => mode_wr,
          poly_get => poly_get,
          count_rst => count_rst,
          z_err => z_err,
          oob_err => oob_err
        );

   -- Clock process definitions
   t_clk_process :process
   begin
		t_clk <= '0';
		wait for t_clk_period/2;
		t_clk <= '1';
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
      -- hold reset state for 100 ns.
      g_rst <= '1';
      wait for 40 ns;
      g_rst <= '0';
      -- insert stimulus here 
      Start <= '1';
      opcode_in <= "110000";
      wait for 10 ns;
      Start <= '0';
      wait for 10 ns;
      opcode_in <= "000000";
      Start <= '1';
      wait for 13 ns;
      Start <= '0';
      wait for 26 ns;
      deserial_d <= '1';
      wait for 13 ns;
      deserial_d <= '0';
      wait for 39 ns;
      gen_rdy <= '1';
      wait for 13 ns;
      gen_rdy <= '0';
      INTA <= '1';
      wait for 13 ns;
      INTA <= '0';
      opcode_in <= "001000";
      Start <= '1';
      wait for 13 ns;
      Start <= '0';
      wait for 26 ns;
      deserial_d <= '1';
      wait for 13 ns;
      deserial_d <= '0';
      wait for 13 ns;
      op_done <= '1';
      wait for 13 ns;
      op_done <= '0';
      INTA <= '1';
      wait for 13 ns;
      INTA <= '0';
      serial_d <= '1';
      wait for 13 ns;
      serial_d <= '0';
      wait for 13 ns;
      opcode_in <= "001000";
      Start <= '1';
      wait for 13 ns;
      Start <= '0';
      wait for 26 ns;
      deserial_d <= '1';
      wait for 13 ns;
      deserial_d <= '0';
      wait for 13 ns;
      op_done <= '1';
      wait for 13 ns;
      op_done <= '0';
      g_rst <= '1';
      wait for 13 ns;
      g_rst <= '0';
      opcode_in <= "001000";
      Start <= '1';
      wait for 13 ns;
      Start <= '0';
      wait for 26 ns;
      deserial_d <= '1';
      wait for 13 ns;
      deserial_d <= '0';
      wait for 13 ns;
      z_err <= '1';
      wait for 13 ns;
      z_err <= '0';
      INTA <= '1';
      wait for 13 ns;
      INTA <= '0';
      wait;
   end process;

END;
