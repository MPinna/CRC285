library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ControlUnit_bitwise_tb is
end entity ControlUnit_bitwise_tb;

architecture beh of ControlUnit_bitwise_tb is
    
    -- Components
    component ControlUnit_bitwise
        port (
            clk     :   in  std_logic;
            a_rst_n :   in  std_logic;
            in_en   :   out std_logic;
            mid_sel :   out std_logic;
            out_en  :   out std_logic
        );
    end component;
    
    -- Constants
    constant CU_BITS_TB     :   natural     := 6;
    constant CLK_PERIOD     :   time        := 10 ns;
    constant A_RST_VALUE    :   std_logic   := '0'; -- async reset is active low
    constant T_RESET        :   time        := 25 ns;
    
    -- Signals
    signal  clk_tb      :   std_logic   := '0';
    signal  a_rst_n_tb  :   std_logic   := '0';
    signal  in_en_tb    :   std_logic   := '0';
    signal  mid_sel_tb  :   std_logic   := '0';
    signal  out_en_tb   :   std_logic   := '0';
    signal  testing     :   boolean     := true;
    
    begin
    
    clk_tb <= not clk_tb after CLK_PERIOD/2 when testing else '0';
    a_rst_n_tb <= '1' after T_RESET;
    
    ControlUnit_bitwise_DUT: ControlUnit_bitwise
        port map(
            clk     =>  clk_tb,
            a_rst_n =>  a_rst_n_tb,
            in_en   =>  in_en_tb,
            mid_sel =>  mid_sel_tb,
            out_en  =>  out_en_tb
        );

    stimuli: process(clk_tb, a_rst_n_tb)
        variable t : integer := 0;
    begin
        if(a_rst_n_tb = '0') then
            t := 0;
        elsif(rising_edge(clk_tb)) then
            case(t) is
                when (180) =>
                    testing <= false;
                when others =>
                    null;
            end case;
            t := t+1;
        end if;
    end process stimuli;
end architecture beh;