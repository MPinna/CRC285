library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity XOR_log_tb is
end entity XOR_log_tb;

architecture beh of XOR_log_tb is
    
    constant XOR_BITS       :   natural := 9;
    constant CLK_PERIOD     :   time    := 100ns;

    signal clk_tb	    :   std_logic := '0';
    signal d_in_tb  :   std_logic_vector(XOR_BITS - 1 downto 0) :=(others => '0');
    signal d_out_tb :   std_logic_vector(XOR_BITS - 2 downto 0);
    signal testing  :   boolean := true;
    
    component XOR_logical is
        generic(Nbit : natural := XOR_BITS);
        port
            (
                d_in    :   in  std_logic_vector(Nbit - 1 downto 0);
                d_out   :   out std_logic_vector(Nbit - 2 downto 0)
        );
    end component;
            
begin
    clk_tb <= not clk_tb after CLK_PERIOD/2 when testing else '0';
                
    XOR_logical_DUT: XOR_logical
        generic map(Nbit => XOR_BITS)
        port map(
            d_in    =>  d_in_tb,
            d_out   =>  d_out_tb
        );
    
    stimulus: process
    begin
        d_in_tb <= "000000000";
        wait for 100 ns;
        d_in_tb <= "111111111";
        wait for 100 ns;
        d_in_tb <= "100000001";
        wait for 100 ns;
        d_in_tb <= "000000010";
        wait for 100 ns;
        d_in_tb <= "100000011";
        wait for 100 ns;
        d_in_tb <= "000000100";
        wait for 100 ns;
        d_in_tb <= "100011101";
        wait for 100 ns;
        d_in_tb <= "011100010";
        wait for 100 ns;
        d_in_tb <= "111111101";
        wait for 100 ns;
        d_in_tb <= "011111110";
        wait for 100 ns;
        testing <= false;
    end process;
end architecture beh;