-- ismember.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--
-- Generates the non-membership flag when the operand exceeds 2^n-2.
--

library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
library work;
    use work.glob.all;

entity ismember is
    generic(
        n           : positive := DEGREE
    );
    port(
        opand1      : in std_logic_vector(n downto 0);  -- operand 1
        opand2      : in std_logic_vector(n downto 0);  -- operand 2
        mask        : in std_logic_vector(n downto 0);  -- mask
        is_not_in   : out std_logic
    );
end ismember;

architecture behavioral of ismember is

    signal is_same_mask1 : std_ulogic;
    signal is_same_mask2 : std_ulogic;
    signal is_below_bd1 : std_ulogic;
    signal is_below_bd2 : std_ulogic;

begin

    is_same_mask1 <= and_reduce(not opand1 or mask);

    is_below_bd1 <= and_reduce(not mask or opand1);

    is_same_mask2 <= and_reduce(not opand2 or mask);

    is_below_bd2 <= and_reduce(not mask or opand2);

    is_not_in <= (not is_same_mask1 or is_below_bd1) or (not is_same_mask2 or is_below_bd2);

end behavioral;
