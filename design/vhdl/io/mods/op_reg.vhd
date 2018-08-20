library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity op_reg is
port(
    op_in   :   in  std_logic_vector(5 downto 0);
    clk     :   in  std_logic;
    start   :   in  std_logic;
    n_busy  :   in  std_logic;
    reset   :   in  std_logic;
    op_out  :   out std_logic_vector(5 downto 0)
);
end op_reg;

architecture structural of op_reg is

    component dff_reset
    port(
        d       :   in  std_logic;
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        q       :   out std_logic    
    );
    end component;

    component and3
    port(
        in1     :   in  std_logic;
        in2     :   in  std_logic;
        in3     :   in  std_logic;
        out1    :   out std_logic
    );
    end component;

    signal  and_out :   std_logic;

    for and1    :   and2 use entity work.and2(structural);
    for dff0    :   dff_reset use entity work.dff_reset(structural);
    for dff1    :   dff_reset use entity work.dff_reset(structural);
    for dff2    :   dff_reset use entity work.dff_reset(structural);
    for dff3    :   dff_reset use entity work.dff_reset(structural);
    for dff4    :   dff_reset use entity work.dff_reset(structural);
    for dff5    :   dff_reset use entity work.dff_reset(structural);

begin

    and1    :   and2        port map(clk,       start,      n_busy, and_out);
    dff0    :   dff_reset   port map(op_in(0),  and_out,    reset,  op_out(0));
    dff1    :   dff_reset   port map(op_in(1),  and_out,    reset,  op_out(1));
    dff2    :   dff_reset   port map(op_in(2),  and_out,    reset,  op_out(2));
    dff3    :   dff_reset   port map(op_in(3),  and_out,    reset,  op_out(3));
    dff4    :   dff_reset   port map(op_in(4),  and_out,    reset,  op_out(4));
    dff5    :   dff_reset   port map(op_in(5),  and_out,    reset,  op_out(5));

end structural;    
