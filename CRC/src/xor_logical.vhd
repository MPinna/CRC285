library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity XOR_logical is
    generic( Nbit : positive := 8);
    port (
        d_in    : in    std_logic_vector(Nbit - 1 downto 0);
        d_out   : out   std_logic_vector(Nbit - 1 downto 0)
    );
end entity XOR_logical;

architecture rtl of XOR_logical is

    constant GENERATOR_LEN  :   natural := 8;
    
    -- Generator polynomial is 100011101, but the XOR operation during the
    -- division procedure will only involve the 8 least significant bits
    constant GENERATOR      :   std_logic_vector(GENERATOR_LEN - 1 downto 0) := "00011101";

begin
    do_xor: for i in GENERATOR_LEN - 1 downto 0 generate
        d_out(i) <= d_in(i) xor GENERATOR(i);
    end generate;
end architecture rtl;