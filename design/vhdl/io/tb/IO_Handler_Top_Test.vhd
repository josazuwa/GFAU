----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:44:31 05/07/2018 
-- Design Name: 
-- Module Name:    IO_Handler_Top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IO_Handler_Top is
port(
--============================================================================--
    --***External Signals***--
--============================================================================--

    --signals from/to external devices
    data        :   inout   std_logic_vector(31 downto 0); --external data bus
    Start       :   in      std_logic;
    t_clk       :   in      std_logic; --external device clock < 200MHz
    g_rst       :   in      std_logic; --global reset. 1 cycle of both clks
    ready_sig   :   out     std_logic; --gfau is ready for input
    err         :   out     std_logic; --error signal
    
    --interrupt signals to/from external device
    INT         :   out     std_logic; --generate an interrupt
    INTA        :   in      std_logic; --interrupt acknowledge
    
    --signals to/from gfau
    clk         :   in      std_logic; --internal 50MHz clock
    op_done     :   in      std_logic; --normal operation completed
    opcode_out  :   out     std_logic_vector(5 downto 0); --for internal use
    rst         :   out     std_logic; --propogation of g_rst
    gen_rdy     :   in      std_logic; --field generation complete
    --gfau_data   :   in      std_logic_vector(15 downto 0); --gfau result
    out_data    :   out     std_logic_vector(31 downto 0);
    input_size  :   out     std_logic_vector(3 downto 0);
    cu_start    :   out     std_logic;
    
    --error signals
    z_err       :   in      std_logic;
    oob_err     :   in      std_logic
);
end IO_Handler_Top;

architecture Behavioral of IO_Handler_Top is

--============================================================================--
    --***Component Modules***--
--============================================================================--

    component clk_counter
    port(
        clk     :   in  std_logic;
        rst     :   in  std_logic;
        count   :   out std_logic_vector(1 downto 0)
    );
    end component;
    
    component count_decoder
    port(
        bus_size    :   in  std_logic_vector(1 downto 0);
        input_size  :   in  std_logic_vector(3 downto 0);
        gen_poly    :   in  std_logic;
        num_clks    :   out std_logic_vector(1 downto 0)
    );
    end component;
    
    component data_deserialize
    port(
        clk         :   in  std_logic;
        enable      :   in  std_logic;
        rst         :   in  std_logic;
        in_data     :   in  std_logic_vector(31 downto 0);
        count       :   in  std_logic_vector(1 downto 0);
        bus_size    :   in  std_logic_vector(1 downto 0);
        num_clks    :   in  std_logic_vector(1 downto 0);
        done        :   out std_logic;
        count_rst   :   out std_logic;
        out_data    :   out std_logic_vector(31 downto 0)
    );
    end component;
    
    component IO_Handler_FSM
    port(
        opcode_in   :   in      std_logic_vector(5 downto 0);
        Start       :   in      std_logic;
        t_clk       :   in      std_logic;
        g_rst       :   in      std_logic;
        ready_sig   :   out     std_logic; --ready1 xnor ready2
        INT         :   out     std_logic; --generate interrupt
        INTA        :   in      std_logic; --interrupt accepted
        clk         :   in      std_logic;
        op_done     :   in      std_logic; --data from gfau ready
        opcode_out  :   out     std_logic_vector(5 downto 0);
        rst         :   out     std_logic; --internal reset
        gen_rdy     :   in      std_logic; --field finished generating
        mode        :   out     std_logic_vector(1 downto 0);
        serial_e    :   out     std_logic := '0'; --serializer enable 
        serial_d    :   in      std_logic; --serialization of data done
        deserial_e  :   out     std_logic := '0'; --deserializer enable
        deserial_r  :   out     std_logic := '1'; --deserializer reset
        deserial_d  :   in      std_logic; --deserialization of data done
        poly_get    :   out     std_logic; --signal for mux that lets it know only 
        err         :   out     std_logic;
        err_type    :   out     std_logic;
        wr_rd       :   out     std_logic;
        z_err       :   in      std_logic; --zero error
        insize_in   :   in      std_logic_vector(3 downto 0);
        insize_out  :   out     std_logic_vector(3 downto 0);
        oob_err     :   in      std_logic  --out of bounds error
    );
    end component;
    
    component serialize
    port(
        enable      :   in  std_logic;
        in_data     :   in  std_logic_vector(15 downto 0); --from gfau
        count       :   in  std_logic_vector(1 downto 0);
        bus_size    :   in  std_logic_vector(1 downto 0);
        num_clks    :   in  std_logic_vector(1 downto 0);
        done        :   out std_logic;
        count_rst   :   out std_logic;
        out_data    :   out std_logic_vector(15 downto 0) --to extern device
    );
    end component;
    
    component io_port
    generic(
        n           :   positive
    );
    port(
        op          :   in      std_logic_vector((n - 1) downto 0);
        oe          :   in      std_logic;
        ip          :   out     std_logic_vector((n - 1) downto 0);
        pad         :   inout   std_logic_vector((n - 1) downto 0)
    );
    end component;
        

--============================================================================--
    --***IO Handler internal signals***--
--============================================================================--

    --serialize/deserialize--
    signal serial_e     :   std_logic;
    signal serial_d     :   std_logic;
    signal deserial_e   :   std_logic;
    signal deserial_r   :   std_logic;
    signal deserial_d   :   std_logic;
    
    --mode write--
    signal mode         :   std_logic_vector(1 downto 0);
    
    --count_decoder--   
    signal poly_get     :   std_logic;
    signal num_clks     :   std_logic_vector(1 downto 0); --clks to input/outp
    
    --counter--
    signal count_rst    :   std_logic;
    signal count_rst1   :   std_logic; --reset from serialize
    signal count_rst2   :   std_logic; --reset from deserialize
    signal count        :   std_logic_vector(1 downto 0); --clk_count
    
    --io port--
    signal in_data_ext  :   std_logic_vector(31 downto 0);
    signal out_data_ext :   std_logic_vector(15 downto 0); --data sent to ext
    signal wr_rd        :   std_logic; --rd or write from io port?

    --error handing--
    signal err_type     :   std_logic;
    signal err_out      :   std_logic; --allows internal reading of err

    --output selection--
    signal data_vec     :   std_logic_vector(15 downto 0); 
    signal err_vec      :   std_logic_vector(15 downto 0);
    
    signal input_size_s :   std_logic_vector(3 downto 0);
    
begin

    input_size <= input_size_s;
    count_rst <= count_rst1 and count_rst2; --start counting if either goes low
    err <= err_out;
    err_vec(0) <= err_type;
    err_vec(15 downto 1) <= (others => '0');
    cu_start <= deserial_d;

    FSM     :   IO_Handler_FSM port map(
        --external signals--
        opcode_in   => data(5 downto 0),
        insize_in   => data(3 downto 0),
        Start       => Start,
        t_clk       => t_clk,
        g_rst       => g_rst,
        ready_sig   => ready_sig,
        INT         => INT,
        INTA        => INTA,
        clk         => clk,
        op_done     => op_done,
        opcode_out  => opcode_out,
        rst         => rst,
        gen_rdy     => gen_rdy,
        mode        => mode,
        err         => err_out,
        err_type    => err_type,
        
        --internal signals--
        serial_e    => serial_e,
        serial_d    => serial_d,
        deserial_e  => deserial_e,
        deserial_r  => deserial_r,
        deserial_d  => deserial_d,
        poly_get    => poly_get,
        z_err       => z_err,
        oob_err     => oob_err,
        insize_out  => input_size_s,
        wr_rd       => wr_rd
    );
    
    deser   :   data_deserialize port map(
        clk         => t_clk,
        enable      => deserial_e,
        rst         => deserial_r,
        count       => count(1 downto 0),
        in_data     => in_data_ext,
        bus_size    => mode,
        num_clks    => num_clks,
        done        => deserial_d,
        count_rst   => count_rst2,
        out_data    => out_data
    );
    
    serial  :   serialize port map(
        enable      => serial_e,
        in_data     => gfau_data,
        count       => count(1 downto 0),
        bus_size    => mode,
        num_clks    => num_clks,
        done        => serial_d,
        count_rst   => count_rst1,
        out_data    => data_vec
    );
    
    countd  :   count_decoder port map(
        bus_size    => mode,
        input_size  => input_size_s,
        gen_poly    => poly_get,
        num_clks    => num_clks
    );
    
    counter :   clk_counter port map(
        clk         => t_clk,
        rst         => count_rst,
        count       => count
    );
    
    iop     :   io_port generic map(
        n           => 32
    ) port map (
        op(15 downto 0) => out_data_ext,
        op(31 downto 16)=> "0000000000000000",    
        oe          => wr_rd,
        ip          => in_data_ext,
        pad         => data
    );

    outmux  :   process(err_out, err_vec, data_vec)
    begin
        if err_out = '1' then
            out_data_ext <= err_vec;
        else    
            out_data_ext <= data_vec;
        end if;
    end process outmux;
        
end Behavioral;

