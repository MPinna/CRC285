library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity XOR_lut_tb is
end entity XOR_lut_tb;

architecture beh of XOR_lut_tb is
    
    constant XOR_BITS       :   natural := 8;
    constant CLK_PERIOD     :   time    := 100 ns;

    signal clk	    :   std_logic := '0';
    signal d_in_tb  :   std_logic_vector(XOR_BITS - 1 downto 0) :=(others => '0');
    signal d_out_tb :   std_logic_vector(XOR_BITS - 1 downto 0);
    signal testing  :   boolean := true;
    
    component XOR_lut is
        generic(Nbit : natural := XOR_BITS);
        port
            (
                d_in    :   in  std_logic_vector(Nbit - 1 downto 0);
                d_out   :   out std_logic_vector(Nbit - 1 downto 0)
                );
            end component;
            
        begin
            clk <= not clk after CLK_PERIOD/2 when testing else '0';
                
                
    XOR_lut_DUT: XOR_LUT
        generic map(Nbit => XOR_BITS)
        port map(
            d_in    =>  d_in_tb,
            d_out   =>  d_out_tb
        );
    
    stimulus: process
    begin
        d_in_tb <= "00000000";
        wait for 100 ns;
        d_in_tb <= "11111111";
        wait for 100 ns;
        d_in_tb <= "00000001";
        wait for 100 ns;
        d_in_tb <= "00000010";
        wait for 100 ns;
        d_in_tb <= "00000011";
        wait for 100 ns;
        d_in_tb <= "00000100";
        wait for 100 ns;
        d_in_tb <= "00011101";
        wait for 100 ns;
        d_in_tb <= "11100010";
        wait for 100 ns;
        d_in_tb <= "11111101";
        wait for 100 ns;
        d_in_tb <= "11111110";
        wait for 100 ns;
        testing <= false;
    end process;
end architecture beh;