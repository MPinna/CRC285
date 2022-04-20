library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity D2FF_TB is
end entity D2FF_TB;

architecture beh of D2FF_TB is

    constant clk_period :   time    :=  100 ns;
    
    component D2FF
    port(
        clk     :   in  std_logic;
        a_rst_n :   in  std_logic;
        en      :   in  std_logic;
        sel     :   in  std_logic;
        d0      :   in  std_logic;
        d1      :   in  std_logic;
        q       :   out std_logic
    );
    end component;

    signal  clk_ext     :   std_logic   := '0';
    signal  a_rst_n_ext :   std_logic   := '0';
    signal  en_ext      :   std_logic   := '0';
    signal  sel_ext     :   std_logic   := '0';
    signal  d0_ext      :   std_logic   := '0';
    signal  d1_ext      :   std_logic   := '0';
    signal  q_ext       :   std_logic;
    signal  testing     :   boolean     := true;

begin
    
    clk_ext <= not clk_ext after clk_period/2 when testing else '0';

    dut: D2FF
    port map
    (
        clk     =>  clk_ext,
        a_rst_n =>  a_rst_n_ext,
        en      =>  en_ext,
        sel     =>  sel_ext,
        d0      =>  d0_ext,
        d1      =>  d1_ext,
        q       =>  q_ext
    );

    stimulus: process
    begin
        a_rst_n_ext <=  '0';
        en_ext      <=  '0';
        sel_ext     <=  '0'; 
        d0_ext      <=  '0';
        d1_ext      <=  '0';
        wait for 250 ns;
        
        a_rst_n_ext  <=  '1';
        -- enable ON
        -- select 0
        en_ext      <=  '1';
        sel_ext     <=  '0'; 
        d0_ext      <=  '0';
        d1_ext      <=  '1';
        wait for 200 ns;
        
        en_ext      <=  '1';
        sel_ext     <=  '0'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 200 ns;
        
        en_ext      <=  '1';
        sel_ext     <=  '0'; 
        d0_ext      <=  '0';
        d1_ext      <=  '1';
        wait for 200 ns;
        
        en_ext      <=  '1';
        sel_ext     <=  '0'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 200 ns;

        -- enable OFF
        en_ext      <=  '0';
        sel_ext     <=  '0'; 
        d0_ext      <=  '0';
        d1_ext      <=  '0';
        wait for 200 ns;
        
        en_ext      <=  '0';
        sel_ext     <=  '1'; 
        d0_ext      <=  '1';
        d1_ext      <=  '1';
        wait for 200 ns;

        en_ext      <=  '0';
        sel_ext     <=  '0'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 200 ns;

        en_ext      <=  '0';
        sel_ext     <=  '1'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 70 ns;

        a_rst_n_ext  <= '1';
 
        -- enable ON
        -- select 1
        en_ext      <=  '1';
        sel_ext     <=  '1'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 200 ns;
        
        en_ext      <=  '1';
        sel_ext     <=  '1'; 
        d0_ext      <=  '0';
        d1_ext      <=  '1';
        wait for 200 ns;
        
        en_ext      <=  '1';
        sel_ext     <=  '1'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 200 ns;
        
        en_ext      <=  '1';
        sel_ext     <=  '1'; 
        d0_ext      <=  '0';
        d1_ext      <=  '1';
        wait for 200 ns;
        


        a_rst_n_ext  <= '1';

        -- enable ON
        en_ext      <=  '1';
        sel_ext     <=  '0'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 200 ns;
        
        en_ext      <=  '1';
        sel_ext     <=  '1'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 200 ns;
        
        en_ext      <=  '1';
        sel_ext     <=  '0'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 200 ns;
        
        en_ext      <=  '1';
        sel_ext     <=  '1'; 
        d0_ext      <=  '1';
        d1_ext      <=  '0';
        wait for 200 ns;
        
        testing     <= false;
    end process stimulus;
    
end architecture beh;