--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:34:11 04/24/2018
-- Design Name:   
-- Module Name:   /home/brian/io_handler_idk/IO_Handler/count_decoder_tb.vhd
-- Project Name:  IO_Handler
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: count_decoder
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
 
ENTITY count_decoder_tb IS
END count_decoder_tb;
 
ARCHITECTURE behavior OF count_decoder_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT count_decoder
    PORT(
         bus_size : IN  std_logic_vector(1 downto 0);
         input_size : IN  std_logic_vector(3 downto 0);
         num_clks : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal bus_size : std_logic_vector(1 downto 0) := (others => '0');
   signal input_size : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal num_clks : std_logic_vector(1 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: count_decoder PORT MAP (
          bus_size => bus_size,
          input_size => input_size,
          num_clks => num_clks
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
        -- hold reset state for 100 ns.
        bus_size <= "00";
        input_size <= "0100"; -- 1 clock
        wait for 10 ns;
        input_size <= "0101"; -- 2 clocks
        wait for 10 ns;
        bus_size <= "01";
        input_size <= "1000"; -- 1 clock
        wait for 10 ns;
        input_size <= "1001"; -- 2 clocks
        wait for 10 ns;
        bus_size <= "10"; --1 clock
        input_size <= "1111";
        wait for 10 ns;
        bus_size <= "00"; -- 2 clocks
        input_size  <= "1000";
        wait for 10 ns;
        input_size <= "1001"; -- 3 clocks
        wait for 10 ns;
        bus_size <= "01"; -- 2 clocks
        input_size  <= "1001";
        wait for 10 ns;
        input_size <= "1111"; -- 2 clocks
        wait for 10 ns;
        bus_size <= "00"; -- 3 clocks
        input_size  <= "1100";
        wait for 10 ns;
        input_size <= "1101"; -- 4 clocks
        

      -- insert stimulus here 

      wait;
   end process;

END;
