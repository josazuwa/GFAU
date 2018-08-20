-- div.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--
-- Computes the Galois division of two elements.
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
    use work.glob.all;

entity div is
    generic(
        n       : positive := DEGREE;
        clgn    : positive := CEILLGN
    );
    port(
        i       : in std_logic_vector(n downto 0); -- first element
        j       : in std_logic_vector(n downto 0); -- second element
        size    : in std_logic_vector(clgn downto 0);  -- size of element
        quot    : out std_logic_vector(n downto 0) -- quotient of elements
    );
end div;

architecture behavioral of div is

    constant HIVEC : std_logic_vector(n downto 0) := (others => '1');

    signal sumij : std_logic_vector((n + 1) downto 0);
    signal sumij1 : std_logic_vector((n + 1) downto 0);

begin

    sumij <= std_logic_vector(unsigned('0' & i) + unsigned(j));
    sumij1 <= std_logic_vector(unsigned(sumij) + unsigned(HIVEC));

    process (size, sumij, sumij1)
    begin

        -- if OF(i + two's-comp(j)) == 1
        if (sumij(to_integer(unsigned(size))) = '1') then

            -- quot = i + two's-cmp(j)
            quot <= sumij(n downto 0);

        else

            -- quot = i + two's-cmp(j) + two's-cmp(1)
            quot <= sumij1(n downto 0);

        end if;

    end process;

end behavioral;
