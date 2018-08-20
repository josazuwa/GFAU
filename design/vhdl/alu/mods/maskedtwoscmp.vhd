-- maskedtwoscmp.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--
-- Generates the two's complement of the operand, masked with n 1's.
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library work;
    use work.glob.all;

entity maskedtwoscmp is
    generic(
        n           : positive := DEGREE
    );
    port(
        num         : in std_logic_vector(n downto 0);
        mask        : in std_logic_vector(n downto 0);
        maskedtc    : out std_logic_vector(n downto 0)
   );
end maskedtwoscmp;

architecture behavioral of maskedtwoscmp is

    -- twoscmp component
    component twoscmp
        port(
            num     : in  std_logic_vector(n downto 0);
            tcnum   : out  std_logic_vector(n downto 0)
        );
    end component;

    signal tcnum: std_logic_vector(n downto 0);

begin

    tc: twoscmp port map(
        num,
        tcnum
    );

    maskedtc <= std_logic_vector(mask) and tcnum;

end behavioral;
