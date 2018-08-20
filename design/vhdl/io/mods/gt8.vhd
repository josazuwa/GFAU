library STD;
library IEEE;
use IEEE.std_logic_1164.all;

--less than or equal to 4
entity gt8 is
port(
    
    input   :   in  std_logic_vector(3 downto 0);
    output  :   out std_logic --boolean output

);
end gt8;

architecture structural of gt8 is

begin

    output <= input(3) and (input(2) or input(1) or input(0));

end structural;    
