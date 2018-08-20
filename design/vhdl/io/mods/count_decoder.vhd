library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity count_decoder is
port(
    bus_size    :   in  std_logic_vector(1 downto 0);
    input_size  :   in  std_logic_vector(3 downto 0);
    gen_poly    :   in  std_logic;
    num_clks    :   out std_logic_vector(1 downto 0)
);

end count_decoder;

architecture structural of count_decoder is

    component gt4 
    port(
        input   :   in  std_logic_vector(3 downto 0);
        output  :   out std_logic
    );
    end component;

    component gt8
    port(
        input   :   in  std_logic_vector(3 downto 0);
        output  :   out std_logic
    );
    end component;

    component gt12 
    port(
        input   :   in  std_logic_vector(3 downto 0);
        output  :   out std_logic
    );
    end component;

    for comp1   :   gt4  use entity work.gt4(structural);
    for comp2   :   gt8  use entity work.gt8(structural);
    for comp3   :   gt12 use entity work.gt12(structural);

    signal  g4      :   std_logic;
    signal  g8      :   std_logic;
    signal  g12     :   std_logic;

    signal b8       :   std_logic;
    signal b16      :   std_logic;
    signal b32      :   std_logic;

begin

    comp1   :   gt4     port map(input_size,    g4);
    comp2   :   gt8     port map(input_size,    g8);
    comp3   :   gt12    port map(input_size,    g12);

    b8          <=  bus_size(1) nor bus_size(0);
    b16         <=  not bus_size(1) and bus_size(0);

    num_clks(0) <=  (not gen_poly and (((b8 and ((g4 and not g8) or g12))) or (b16 and g8))) or (gen_poly and (b8 and g8));
    num_clks(1) <=  not gen_poly and (b8 and g8);

end structural;    
