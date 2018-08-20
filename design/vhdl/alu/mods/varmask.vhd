library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
    use work.glob.all;

entity varmask is
    generic(
        n           : positive := DEGREE
    );
    port(
        poly_bcd    : in std_logic_vector(n downto 1);  -- BCD polynomial
        mask        : out std_logic_vector(n downto 0) := (others => '0')
   );
end varmask;

architecture behavioral of varmask is
begin

    mask <= "1111111111111111" when (poly_bcd(15) = '1') else
            "0111111111111111" when (poly_bcd(14) = '1') else
            "0011111111111111" when (poly_bcd(13) = '1') else
            "0001111111111111" when (poly_bcd(12) = '1') else
            "0000111111111111" when (poly_bcd(11) = '1') else
            "0000011111111111" when (poly_bcd(10) = '1') else
            "0000001111111111" when (poly_bcd(9) = '1') else
            "0000000111111111" when (poly_bcd(8) = '1') else
            "0000000011111111" when (poly_bcd(7) = '1') else
            "0000000001111111" when (poly_bcd(6) = '1') else
            "0000000000111111" when (poly_bcd(5) = '1') else
            "0000000000011111" when (poly_bcd(4) = '1') else
            "0000000000001111" when (poly_bcd(3) = '1') else
            "0000000000000111" when (poly_bcd(2) = '1') else
            "0000000000000011" when (poly_bcd(1) = '1') else
            (others => '-');

end behavioral;
