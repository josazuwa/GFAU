library STD;
library IEEE;
use IEEE.std_logic_1164.all;

--less than or equal to 4
entity gt4 is
port(
    
    input   :   in  std_logic_vector(3 downto 0);
    output  :   out std_logic --boolean output

);
end gt4;

architecture structural of gt4 is

begin

    output <= (not input(3) and input(2) and (input(1) or input(0))) or (input(3));

end structural;    
