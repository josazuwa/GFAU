--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:06:38 04/24/2018
-- Design Name:   
-- Module Name:   /home/brian/io_handler_idk/IO_Handler/deserial_test.vhd
-- Project Name:  IO_Handler
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_deserialize
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
 
ENTITY deserial_test IS
END deserial_test;
 
ARCHITECTURE behavior OF deserial_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_deserialize
    PORT(
         clk : IN  std_logic;
         enable : IN  std_logic;
         rst : IN  std_logic;
         in_data : IN  std_logic_vector(31 downto 0);
         count : IN  std_logic_vector(1 downto 0);
         bus_size : IN  std_logic_vector(1 downto 0);
         num_clks : IN  std_logic_vector(1 downto 0);
         done : OUT  std_logic;
         out_data : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal enable : std_logic := '0';
   signal rst : std_logic := '0';
   signal in_data : std_logic_vector(31 downto 0) := (others => '0');
   signal count : std_logic_vector(1 downto 0) := (others => '0');
   signal bus_size : std_logic_vector(1 downto 0) := (others => '0');
   signal num_clks : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal done : std_logic;
   signal out_data : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_deserialize PORT MAP (
          clk => clk,
          enable => enable,
          rst => rst,
          in_data => in_data,
          count => count,
          bus_size => bus_size,
          num_clks => num_clks,
          done => done,
          out_data => out_data
        );

   -- Clock process definitions
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
        wait for 5 ns;
        rst <= '1';
        wait for 10 ns;
        
        rst <= '0';
        enable <= '1';
        in_data(7 downto 0) <= "00100011";
        count <= "00";
        bus_size <= "00";
        num_clks <= "00";

        wait for 10 ns;
        
        rst <= '1';
        
        wait for 10 ns;
        
        rst <= '0';
        in_data(7 downto 0) <= "11001001";
        count <= "00";
        bus_size <= "00";
        num_clks <= "10";
        
        wait for 10 ns;
        
        in_data(7 downto 0) <= "10000111";
        count <= "01";
     
        wait for 10 ns;
        
        in_data(7 downto 0) <= "10000000";
        count <= "10";
        
        wait for 10 ns;
        
        wait;

        
      -- insert stimulus here 

      wait;
   end process;

END;
