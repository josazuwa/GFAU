#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import unicode_literals

GLOB_STR = \
    ("library ieee;\n"
     "    use ieee.std_logic_1164.all;\n"
     "    use ieee.std_logic_unsigned.all;\n\n"
     "package glob is\n\n"
     "    -------- glob constants --------\n\n"
     "    -- maximum degree of polynomial\n"
     "    constant DEGREE : positive := {deg};\n\n"
     "    -- ceil(log2(degree))\n"
     "    constant CEILLGN : positive := {ceillgn};\n\n"
     "    -- ceil(log2(degree - 1))\n"
     "    constant CEILLGN1 : positive := {ceillgn1};\n\n"
     "    -------- state types --------\n\n"
     "    type op_state_type is (op1_state, op2_state);\n"
     "    type gen_state_type is (auto_elem_state, gen_elem_state);\n"
     "    type debounce_state_type is (rst_state, en_state);\n\n"
     "    -- memory states\n"
     "    type rd_state_type is (send_addr, get_data);\n"
     "    type wr_state_type is (wr_mem1, wr_mem2, wr_mem3);\n"
     "    type setup_type is (addr_setup, wr);\n\n"
     "end glob;\n")

VARMASK_STR = \
    ("library ieee;\n"
     "    use ieee.std_logic_1164.all;\n"
     "    use ieee.numeric_std.all;\n"
     "library work;\n"
     "    use work.glob.all;\n\n"
     "entity varmask is\n"
     "    generic(\n"
     "        n           : positive := DEGREE\n"
     "    );\n"
     "    port(\n"
     "        poly_bcd    : in std_logic_vector(n downto 1);  -- BCD polynomial\n"
     "        mask        : out std_logic_vector(n downto 0) := (others => '0')\n"
     "   );\n"
     "end varmask;\n\n"
     "architecture behavioral of varmask is\n"
     "begin\n\n"
     "    mask <= {0}"
     "            (others => '-');\n\n"
     "end behavioral;\n")

INDICES_STR = \
    ("library ieee;\n"
     "    use ieee.std_logic_1164.all;\n"
     "    use ieee.numeric_std.all;\n"
     "library work;\n"
     "    use work.glob.all;\n\n"
     "entity indices is\n"
     "    generic(\n"
     "        n           : positive := DEGREE;\n"
     "        clgn        : positive := CEILLGN;  -- ceil(log2(n))\n"
     "        clgn1       : positive := CEILLGN1   -- ceil(log2(n - 1))\n"
     "    );\n"
     "    port(\n"
     "        poly_bcd    : in std_logic_vector(n downto 1);  -- BCD polynomial\n"
     "        size        : out std_logic_vector(clgn downto 0);  -- size\n"
     "        msb         : out std_logic_vector(clgn1 downto 0)  -- msb\n"
     "    );\n"
     "end indices;\n\n"
     "architecture behavioral of indices is\n\n"
     "    signal prio_enc : std_logic_vector(clgn downto 0) := (others => '-');\n\n"
     "begin\n\n"
     "    prio_enc <= {0}"
     "                (others => '-');\n\n"
     "    size <= prio_enc;\n"
     "    msb <= std_logic_vector(unsigned(prio_enc(clgn1 downto 0)) - 1);\n\n"
     "end behavioral;\n")
