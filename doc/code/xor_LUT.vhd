entity XOR_LUT is
    generic(
        XOR_LUT_input_size : positive := 8
    );
    port(
        d_in  : in  std_logic_vector(XOR_LUT_input_size - 1 downto 0);
        d_out : out std_logic_vector(XOR_LUT_input_size - 1 downto 0)
    );
end entity XOR_LUT;

architecture rtl of XOR_LUT is
    
    constant GENERATOR_LEN  :   natural := 8;

    signal  addr_int     :   integer range 0 to 255;
    
    type lut_t is array (0 to 255) of std_logic_vector(GENERATOR_LEN -1 downto 0);
    
    constant lut: lut_t :=
    (
        x"00", x"1D", x"3A", x"27", x"74", x"69", x"4E" -- [etc...]
    );
begin
    addr_int    <= TO_INTEGER(unsigned(d_in));
    d_out       <= lut(addr_int);
end architecture rtl;