----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:38:41 04/24/2018 
-- Design Name: 
-- Module Name:    clk_counter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_counter is
port(
    clk     :   in  std_logic;
    rst     :   in  std_logic;
    count   :   out std_logic_vector(1 downto 0)
);
end clk_counter;

architecture Behavioral of clk_counter is

signal count_reg    :   unsigned(1 downto 0);

begin

    count <= std_logic_vector(count_reg);

    inc :   process(clk)
    begin
        if falling_edge(clk) then
            if (rst = '1') then
                count_reg <= "00";
            else
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process inc;

end Behavioral;

