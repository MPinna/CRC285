library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity XORLogical is
    generic( Nbit : positive := 9);
    port (
        -- 9 bits as input, MSB is some sort of "enable"
        -- 8 LSBs are used for the XOR
        d_in    : in    std_logic_vector(Nbit - 1 downto 0);

        -- 8 bits as output
        d_out   : out   std_logic_vector(Nbit - 2 downto 0)
    );
end entity XORLogical;

architecture rtl of XORLogical is

    constant GENERATOR_LEN  :   natural := 8;
    
    -- Generator polynomial is 100011101
    constant GENERATOR      :   std_logic_vector(GENERATOR_LEN - 1 downto 0) := "00011101";

begin
    do_xor: for i in GENERATOR_LEN - 1 downto 0 generate
        -- using the MSB of d_in as enable 
        -- (if MSB is 0 the 'and' will be 0 and 0 is the neutral element of xor)
        d_out(i) <= d_in(i) xor (GENERATOR(i) and d_in(Nbit - 1));
    end generate;
end architecture rtl;