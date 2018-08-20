library ieee;
library std;
use ieee.std_logic_1164.all;

entity and4 is
port(
    in1     :   in  std_logic;
    in2     :   in  std_logic;
    in3     :   in  std_logic;
    in4     :   in  std_logic;
    out1    :   out std_logic
);
end entity and4;

architecture structural of and4 is

begin

    out1 <= in1 and in2 and in3 and in4;

end structural;
