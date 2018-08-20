-- operators.vhd
--
-- Sabbir Ahmed
-- 2018-01-16
--
-- Controller for the Galois operators.
--

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_misc.all;
library work;
    use work.glob.all;

entity operators is
    generic(
        n           : positive := DEGREE;
        clgn        : positive := CEILLGN
    );
    port(
        -- clock
        clk         : in std_logic;

        -- control signals
        ops_rdy     : in std_logic;
        rst         : in std_logic;

        -- opcode
        opcode      : in std_logic_vector(5 downto 0);

        -- operands
        i           : in std_logic_vector(n downto 0);
        j           : in std_logic_vector(n downto 0);

        -- registers
        size        : in std_logic_vector(clgn downto 0);  -- size
        mask        : in std_logic_vector(n downto 0);  -- mask

        -- memory types and methods
        mem_t       : out std_logic; -- memory type

        -- memory wrapper control signals
        id_con      : out std_logic;
        mem_rdy     : in std_logic;

        -- memory address and data signals
        addr_con    : out std_logic_vector(n downto 0);
        dout_con    : inout std_logic_vector(n downto 0);

        result      : out std_logic_vector(n downto 0) := (others => '-'); -- selected output
        err_b       : out std_logic; -- membership exception
        err_z       : out std_logic; -- null exception
        rdy_out     : out std_logic; -- result ready interrupt

        out_sel_o   : out std_logic_vector(n downto 0)

    );
end operators;

architecture behavioral of operators is

    component ismember is
        port(
            opand1      : in std_logic_vector(n downto 0);  -- operand
            opand2      : in std_logic_vector(n downto 0);  -- operand
            mask        : in std_logic_vector(n downto 0);  -- mask
            is_not_in   : out std_logic
        );
    end component;

    -- two's complement
    component maskedtwoscmp
        port(
            num         : in std_logic_vector(n downto 0);
            mask        : in std_logic_vector(n downto 0);
            maskedtc    : out std_logic_vector(n downto 0)
        );
    end component;

    ---------------- Galois operators ----------------

    -- addition / subtraction
    component addsub
        port(
            i       : in std_logic_vector(n downto 0);
            j       : in std_logic_vector(n downto 0);
            i_null  : in std_logic;
            j_null  : in std_logic;
            bitxor  : out std_logic_vector(n downto 0)
        );
    end component;

    -- multiplication
    component mul
        port(
            i       : in std_logic_vector(n downto 0);
            j       : in std_logic_vector(n downto 0);
            size    : in std_logic_vector(clgn downto 0);
            prod    : out std_logic_vector(n downto 0)
        );
    end component;

    -- division
    component div
        port(
            i       : in std_logic_vector(n downto 0);
            j       : in std_logic_vector(n downto 0);
            size    : in std_logic_vector(clgn downto 0);
            quot    : out std_logic_vector(n downto 0)
        );
    end component;


    ---------------- output multiplexers ----------------

    component outselect
        port(
            op      : in std_logic_vector(2 downto 0);
            out_t   : in std_logic;
            bitxor  : in std_logic_vector(n downto 0);
            prod    : in std_logic_vector(n downto 0);
            quot    : in std_logic_vector(n downto 0);
            lg      : in std_logic_vector(n downto 0);
            i_null  : in std_logic;
            j_null  : in std_logic;
            out_sel : out std_logic_vector(n downto 0);
            mem_t   : out std_logic;
            convert : out std_logic;
            en_con  : out std_logic;
            err_z   : out std_logic
        );
    end component;

    -- output converter
    component outconvert
        port(
            clk         : in std_logic;
            en          : in std_logic;
            rst         : in std_logic;
            ops_rdy     : in std_logic;
            convert     : in std_logic;
            mask        : in std_logic_vector(n downto 0);
            out_sel     : in std_logic_vector(n downto 0);
            id_con      : out std_logic;
            mem_rdy     : in std_logic;
            addr_con    : out std_logic_vector(n downto 0);
            dout_con    : inout std_logic_vector(n downto 0);
            result      : out std_logic_vector(n downto 0);
            rdy_out     : out std_logic -- result ready interrupt
        );
    end component;

    -- operand null flags
    signal i_null : std_logic;
    signal j_null : std_logic;

    signal neg_j : std_logic_vector(n downto 0);

    signal bitxor : std_logic_vector(n downto 0);
    signal prod : std_logic_vector(n downto 0);
    signal quot : std_logic_vector(n downto 0);

    signal out_sel : std_logic_vector(n downto 0);
    signal convert : std_logic;
    signal en_con : std_logic;

begin

    ismember_unit: ismember port map(
        opand1 => i,
        opand2 => j,
        mask => mask,
        is_not_in => err_b
    );

    out_sel_o <= out_sel;

    ---------------- Two's Compliment ----------------

    maskedtwoscmp_unit: maskedtwoscmp port map(
        num => j,
        mask => mask,
        maskedtc => neg_j
    );

    ---------------- Galois operator units ----------------

    -- addition / subtraction
    addsub_unit: addsub port map(
        i => i,
        j => j,
        i_null => i_null,
        j_null => j_null,
        bitxor => bitxor
    );

    -- multiplication
    mul_unit: mul port map(
        i => i,
        j => j,
        size => size,
        prod => prod
    );

    -- division
    div_unit: div port map(
        i => i,
        j => neg_j,
        size => size,
        quot => quot
    );

    ---------------- Multiplexers ----------------

    -- output selector
    outselect_unit: outselect port map(
        op => opcode(5 downto 3),
        out_t => opcode(0),
        bitxor => bitxor,
        prod => prod,
        quot => quot,
        lg => i,
        i_null => i_null,
        j_null => j_null,
        out_sel => out_sel,
        mem_t => mem_t,
        convert => convert,
        en_con => en_con,
        err_z => err_z
    );

    -- output converter
    outconvert_unit : outconvert port map(
        clk => clk,
        en => en_con,
        rst => rst,
        ops_rdy => ops_rdy,
        convert => convert,
        mask => mask,
        out_sel => out_sel,
        id_con => id_con,
        mem_rdy => mem_rdy,
        addr_con => addr_con,
        dout_con => dout_con,
        result => result,
        rdy_out => rdy_out
    );

    process(opcode(1 downto 0), i, j)
    begin

        if (opcode(2) = '0') then

            i_null <= and_reduce(i);

        elsif (opcode(2) = '1') then

            i_null <= not or_reduce(i);

        end if;

        if (opcode(1) = '0') then

            j_null <= and_reduce(j);

        elsif (opcode(1) = '1') then

            j_null <= not or_reduce(j);

        end if;

    end process;


end behavioral;
