entity XOR_logical is
    generic(
        XOR_input_size : positive := 9
    );
    port (
        d_in    : in    std_logic_vector(XOR_input_size - 1 downto 0);
        d_out   : out   std_logic_vector(XOR_input_size - 2 downto 0)
    );
end entity XOR_logical;

architecture rtl of XOR_logical is    
    constant C_GENERATOR_LEN  :   natural := 8;
    constant C_GENERATOR      :   std_logic_vector(C_GENERATOR_LEN - 1 downto 0) := "00011101";

begin
    do_xor: for i in C_GENERATOR_LEN - 1 downto 0 generate
        d_out(i) <= d_in(i) xor (C_GENERATOR(i) and d_in(XOR_INPUT_SIZE - 1));
    end generate;
end architecture rtl;