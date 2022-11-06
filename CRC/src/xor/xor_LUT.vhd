library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity XOR_LUT is
    generic(
        XOR_LUT_input_size : positive := 8
    );
    port(
        d_in    : in    std_logic_vector(XOR_LUT_input_size - 1 downto 0);
        d_out   : out   std_logic_vector(XOR_LUT_input_size - 1 downto 0)
    );
end entity XOR_LUT;

architecture rtl of XOR_LUT is
    
    constant GENERATOR_LEN  :   natural := 8;

    signal  addr_int     :   integer range 0 to 255;
    
    type lut_t is array (0 to 255) of std_logic_vector(GENERATOR_LEN -1 downto 0);
    
    constant lut: lut_t :=
    (
    --    .0     .1     .2     .3     .4     .5     .6     .7     .8     .9     .A     .B     .C     .D    .E     .F
        x"00", x"1D", x"3A", x"27", x"74", x"69", x"4E", x"53", x"E8", x"F5", x"D2", x"CF", x"9C", x"81", x"A6", x"BB", -- 0.
        x"CD", x"D0", x"F7", x"EA", x"B9", x"A4", x"83", x"9E", x"25", x"38", x"1F", x"02", x"51", x"4C", x"6B", x"76", -- 1.
        x"87", x"9A", x"BD", x"A0", x"F3", x"EE", x"C9", x"D4", x"6F", x"72", x"55", x"48", x"1B", x"06", x"21", x"3C", -- 2.
        x"4A", x"57", x"70", x"6D", x"3E", x"23", x"04", x"19", x"A2", x"BF", x"98", x"85", x"D6", x"CB", x"EC", x"F1", -- 3.
        x"13", x"0E", x"29", x"34", x"67", x"7A", x"5D", x"40", x"FB", x"E6", x"C1", x"DC", x"8F", x"92", x"B5", x"A8", -- 4.
        x"DE", x"C3", x"E4", x"F9", x"AA", x"B7", x"90", x"8D", x"36", x"2B", x"0C", x"11", x"42", x"5F", x"78", x"65", -- 5.
        x"94", x"89", x"AE", x"B3", x"E0", x"FD", x"DA", x"C7", x"7C", x"61", x"46", x"5B", x"08", x"15", x"32", x"2F", -- 6.
        x"59", x"44", x"63", x"7E", x"2D", x"30", x"17", x"0A", x"B1", x"AC", x"8B", x"96", x"C5", x"D8", x"FF", x"E2", -- 7.
        x"26", x"3B", x"1C", x"01", x"52", x"4F", x"68", x"75", x"CE", x"D3", x"F4", x"E9", x"BA", x"A7", x"80", x"9D", -- 8.
        x"EB", x"F6", x"D1", x"CC", x"9F", x"82", x"A5", x"B8", x"03", x"1E", x"39", x"24", x"77", x"6A", x"4D", x"50", -- 9.
        x"A1", x"BC", x"9B", x"86", x"D5", x"C8", x"EF", x"F2", x"49", x"54", x"73", x"6E", x"3D", x"20", x"07", x"1A", -- A.
        x"6C", x"71", x"56", x"4B", x"18", x"05", x"22", x"3F", x"84", x"99", x"BE", x"A3", x"F0", x"ED", x"CA", x"D7", -- B.
        x"35", x"28", x"0F", x"12", x"41", x"5C", x"7B", x"66", x"DD", x"C0", x"E7", x"FA", x"A9", x"B4", x"93", x"8E", -- C.
        x"F8", x"E5", x"C2", x"DF", x"8C", x"91", x"B6", x"AB", x"10", x"0D", x"2A", x"37", x"64", x"79", x"5E", x"43", -- D.
        x"B2", x"AF", x"88", x"95", x"C6", x"DB", x"FC", x"E1", x"5A", x"47", x"60", x"7D", x"2E", x"33", x"14", x"09", -- E.
        x"7F", x"62", x"45", x"58", x"0B", x"16", x"31", x"2C", x"97", x"8A", x"AD", x"B0", x"E3", x"FE", x"D9", x"C4"  -- F.
    );
begin
    addr_int    <= TO_INTEGER(unsigned(d_in));
    d_out       <= lut(addr_int);
end architecture rtl;