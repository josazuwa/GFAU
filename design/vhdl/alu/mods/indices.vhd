library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
    use work.glob.all;

entity indices is
    generic(
        n           : positive := DEGREE;
        clgn        : positive := CEILLGN;  -- ceil(log2(n))
        clgn1       : positive := CEILLGN1   -- ceil(log2(n - 1))
    );
    port(
        poly_bcd    : in std_logic_vector(n downto 1);  -- BCD polynomial
        size        : out std_logic_vector(clgn downto 0);  -- size
        msb         : out std_logic_vector(clgn1 downto 0)  -- msb
    );
end indices;

architecture behavioral of indices is

    signal prio_enc : std_logic_vector(clgn downto 0) := (others => '-');

begin

    prio_enc <= "10000" when (poly_bcd(15) = '1') else
                "01111" when (poly_bcd(14) = '1') else
                "01110" when (poly_bcd(13) = '1') else
                "01101" when (poly_bcd(12) = '1') else
                "01100" when (poly_bcd(11) = '1') else
                "01011" when (poly_bcd(10) = '1') else
                "01010" when (poly_bcd(9) = '1') else
                "01001" when (poly_bcd(8) = '1') else
                "01000" when (poly_bcd(7) = '1') else
                "00111" when (poly_bcd(6) = '1') else
                "00110" when (poly_bcd(5) = '1') else
                "00101" when (poly_bcd(4) = '1') else
                "00100" when (poly_bcd(3) = '1') else
                "00011" when (poly_bcd(2) = '1') else
                "00010" when (poly_bcd(1) = '1') else
                (others => '-');

    size <= prio_enc;
    msb <= std_logic_vector(unsigned(prio_enc(clgn1 downto 0)) - 1);

end behavioral;
