----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:21:59 04/07/2018 
-- Design Name: 
-- Module Name:    io_port16 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
library work;
use work.glob.all;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity io_port is
    generic(
        n       : positive := DEGREE
    );
    port(
        op      :   in      std_logic_vector(n downto 0);  --out to pad
        oe      :   in      std_logic;                     --enable pad output
        ip      :   out     std_logic_vector(n downto 0);  --in from pad
        pad     :   inout   std_logic_vector(n downto 0) --external io pad
    );
end io_port;

architecture Behavioral of io_port is

begin

    pad <= op when oe = '1' else (others => 'Z');
    ip <= pad;

end Behavioral;

