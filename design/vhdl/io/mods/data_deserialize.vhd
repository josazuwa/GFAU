----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:56:24 04/24/2018
-- Design Name:
-- Module Name:    data_deserialize - Behavioral
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

entity data_deserialize is
port(
    clk         :   in  std_logic;
    enable      :   in  std_logic;
    rst         :   in  std_logic;
    poly_gen    :   in  std_logic;
    in_data     :   in  std_logic_vector(31 downto 0);
    count       :   in  std_logic_vector(1 downto 0);
    bus_size    :   in  std_logic_vector(1 downto 0);
    num_clks    :   in  std_logic_vector(1 downto 0);
    done        :   out std_logic;
    count_rst   :   out std_logic;
    out_data    :   out std_logic_vector(31 downto 0)
);
end data_deserialize;

architecture Behavioral of data_deserialize is

    signal output_reg   :   std_logic_vector(31 downto 0);

begin

    out_data <= output_reg;

    deserialize :   process(clk)
    begin
        if rising_edge(clk) then
            if (enable = '1') and (rst = '0') then
                if (bus_size = "00") then -- 8 bit bus
                    if (num_clks = "00") then -- 8 bit data, 1 clock

                        if(poly_gen = '1') then
                            output_reg(7 downto 0) <= in_data(7 downto 0);
                            output_reg(31 downto 8) <= (others => '0');
                            count_rst <= '1';
                            done <= '1';
                        else
                            output_reg(3 downto 0) <= in_data(3 downto 0);
                            output_reg(19 downto 16) <= in_data(7 downto 4);
                            count_rst <= '1';
                            done <= '1'; --finished taking input
                        end if;

                    elsif (num_clks = "01") then -- 8 bit data, 2 clocks

                        if (poly_gen = '1') then

                            if (count = "00") then
                                count_rst <= '0';
                                output_reg(7 downto 0) <=  in_data(7 downto 0);
                            else
                                count_rst <= '1';
                                output_reg(15 downto 8) <= in_data(7 downto 0);
                                output_reg(31 downto 16) <= (others => '0');
                                done <= '1';
                            end if;

                        else

                            if (count = "00") then -- clock 1, in1
                                count_rst <= '0';
                                output_reg(7 downto 0) <= in_data(7 downto 0);
                            else  -- clock 2, in2
                                output_reg(23 downto 16) <= in_data(7 downto 0);
                                count_rst <= '1';
                                done <= '1';
                            end if;

                        end if;

                    elsif (num_clks = "10") then -- 8 bit data, 3 clocks

                        if (count = "00") then -- clock 1, in1 part 1
                            count_rst <= '0';
                            output_reg(7 downto 0) <= in_data(7 downto 0);
                        elsif (count = "01") then --clock 2, in1 part2, in2 part 1
                            output_reg(11 downto 8) <= in_data(3 downto 0);
                            output_reg(19 downto 16) <= in_data(7 downto 4);
                        else -- clock 3, in2 part 2
                            output_reg(27 downto 20) <= in_data(7 downto 0);
                            count_rst <= '1';
                            done <= '1';
                        end if;

                    else -- 8 bit data, 4 clocks

                        if (count = "00") then -- clock 1, in1 part 1
                            count_rst <= '0';
                            output_reg(7 downto 0) <= in_data(7 downto 0);
                        elsif (count = "01") then -- clock 2, in1 part 2
                            output_reg(15 downto 8) <= in_data(7 downto 0);
                        elsif (count = "10") then -- clock 3, in2 part 1
                            output_reg(23 downto 16) <= in_data(7 downto 0);
                        else -- clock 4, in2 part 2
                            output_reg(31 downto 24) <= in_data(7 downto 0);
                            count_rst <= '1';
                            done <= '1';
                        end if;

                    end if;
                elsif (bus_size = "01") then --16 bit bus

                    if (num_clks = "00") then -- 16 bit data, 1 clock

                        if(poly_gen = '1') then

                            output_reg(15 downto 0) <= in_data(15 downto 0);
                            output_reg(31 downto 16) <= (others => '0');
                            done <= '1';

                        else

                            output_reg(7 downto 0) <= in_data(7 downto 0);
                            output_reg(15 downto 8) <= in_data(15 downto 8);
                            done <= '1';

                        end if;

                    else --(num_clks = "01") then -- 16 bit bus, 2 clocks
                        if (count = "00") then -- clock 1, in 1
                            count_rst <= '0';
                            output_reg(15 downto 0) <= in_data(15 downto 0);
                        else -- clock 2, in 2
                            output_reg(31 downto 16) <= in_data(15 downto 0);
                            count_rst <= '1';
                            done <= '1';
                        end if;
                    end if;
                else --32 bit bus, always in 1 clock
                    output_reg <= in_data;
                    count_rst <= '1';
                    done <= '1';
                end if;
            elsif (rst = '1') then -- synchronous reset
                count_rst <= '1';
                done <= '0';
            else
                -- do nothing
            end if;
        end if;
    end process deserialize;
end Behavioral;

