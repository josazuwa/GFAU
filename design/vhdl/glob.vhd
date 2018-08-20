library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;

package glob is

    -------- glob constants --------

    -- maximum degree of polynomial
    constant DEGREE : positive := 15;

    -- ceil(log2(degree))
    constant CEILLGN : positive := 4;

    -- ceil(log2(degree - 1))
    constant CEILLGN1 : positive := 3;

    -------- state types --------

    type op_state_type is (op1_state, op2_state);
    type gen_state_type is (auto_elem_state, gen_elem_state);
    type debounce_state_type is (rst_state, en_state);

    -- memory states
    type rd_state_type is (send_addr, get_data);
    type wr_state_type is (wr_mem1, wr_mem2, wr_mem3);
    type setup_type is (addr_setup, wr);

end glob;
