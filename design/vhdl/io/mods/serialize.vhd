----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:08:56 04/27/2018 
-- Design Name: 
-- Module Name:    serialize - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity serialize is
port(
    enable      :   in  std_logic;
    in_data     :   in  std_logic_vector(15 downto 0); --from gfau
    count       :   in  std_logic_vector(1 downto 0);
    bus_size    :   in  std_logic_vector(1 downto 0);
    num_clks    :   in  std_logic_vector(1 downto 0);
    done        :   out std_logic;
    count_rst   :   out std_logic;
    out_data    :   out std_logic_vector(15 downto 0) := (others => '0') --to extern device
);
end serialize;

architecture Behavioral of serialize is

    --signal output_reg   :   std_logic_vector(15 downto 0); --reg to extern dev

begin

    --out_data <= output_reg;
    count_rst <= not enable;

    ser :   process(bus_size, count, num_clks, in_data)
    begin
        --if (rising_edge(clk) and (enable = '1') and (rst = '0')) then
        
            --count_rst <= '0';
            if (bus_size = "00") then -- 8 bit bus
                out_data(15 downto 8) <= (others => '0');
                if (num_clks = "00") then -- 8 bit data, 1 clock
                
                    out_data(7 downto 0) <= in_data(7 downto 0);
                  
                    --count_rst <= '1';
                    done <= '1'; --finished taking input
                    
                else -- 8 bit data, 2 clocks
                
                    if (count = "00") then -- part 1
                        done <= '0';
                        --count_rst <= '0';
                        out_data(7 downto 0) <= in_data(7 downto 0);
                    else  -- part 2
                        out_data(7 downto 0) <= in_data(15 downto 8);
                        --count_rst <= '1';
                        done <= '1';
                    end if;
                    
                end if;
                
            else --16 bit bus or bigger
                
                out_data <= in_data;
                --count_rst <= '1';
                done <= '1';
                
            end if;
            
        --elsif rising_edge(clk) and (rst = '1') then -- synchronous reset
        --
        --    count_rst <= '1';
        --    done <= '0';
            
        --end if;
    end process ser;
end Behavioral;

