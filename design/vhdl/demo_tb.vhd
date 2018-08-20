-- demo_tb.vhd
--
-- Sabbir Ahmed
-- 2018-03-30
--
-- Package for the GFAU demo containing all global vectors and constants
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;

package demo_tb is

    -------- timing constants --------

    constant TNUMS : integer := 320;
    constant CLK_PER : time := 10 ns;
    constant TCLK_PER : time := 40 ns;

end demo_tb;
