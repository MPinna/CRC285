library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity XOR_logical_tb is
end entity XOR_logical_tb;

architecture beh of XOR_logical_tb is
    
    constant CLK_PERIOD     :   time        := 10 ns;
    constant XOR_BITS       :   natural     := 9;

    signal clk_tb       :   std_logic := '0';
    signal d_in_tb      :   std_logic_vector(XOR_BITS - 1 downto 0) :=(others => '0');
    signal d_out_tb     :   std_logic_vector(XOR_BITS - 2 downto 0) :=(others => '0');
    signal testing      :   boolean := true;
    
    component XOR_logical is
        generic(
            Nbit : natural := XOR_BITS
        );
        port(
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
    
    stimulus: process(clk_tb)
        variable t : integer := 0;
    begin
        case(t) is 
            when 1 =>
                d_in_tb <= "000000000";
            when 2 =>
                d_in_tb <= "111111111";
            when 3 =>
                d_in_tb <= "100000001";
            when 4 =>
                d_in_tb <= "000000010";
            when 5 =>
                d_in_tb <= "100000011";
            when 6 =>
                d_in_tb <= "000000100";
            when 7 =>
                d_in_tb <= "100011101";
            when 8 =>
                d_in_tb <= "011100010";
            when 9 =>
                d_in_tb <= "111111101";
            when 10 =>
                d_in_tb <= "011111110";
            when 15 =>
                testing <= false;
            when others =>
                null;
        end case;

        t := t + 1;
    end process;
end architecture beh;