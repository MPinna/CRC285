library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity D2FF is
    port (
        clk     :   in  std_logic;
        a_rst_n :   in  std_logic;
        en      :   in  std_logic;
        sel     :   in  std_logic;
        d0      :   in  std_logic;
        d1      :   in  std_logic;
        q       :   out std_logic
    );
end entity D2FF;

architecture rtl of D2FF is
    
    constant RST_VAL    :   std_logic   := '0'; -- reset is active low

begin
    
   d2ff_p: process(clk, a_rst_n)
   begin
        if a_rst_n = RST_VAL then -- asynch reset
            q    <=  '0';
        elsif rising_edge(clk) then
            if en = '1' then      -- 
                if sel = '0' then
                    q <= d0;
                elsif sel = '1' then
                    q <= d1;
                end if;
            end if;
       end if;
   end process d2ff_p;
    
end architecture rtl;