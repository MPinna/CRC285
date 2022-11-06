library ieee;
use ieee.std_logic_1164.all;


entity DFF is
  port( 
    clk     : in std_logic;
	a_rst_n : in std_logic;
	en      : in std_logic;
    d       : in std_logic;
	q       : out std_logic
	);
			
end DFF;

architecture beh of DFF is   
  begin
   
  ddf_proc: process(clk, a_rst_n)
		begin
			if(a_rst_n = '0') then
				q <= '0';
			elsif(rising_edge(clk)) then
				if(en = '1') then
					q <= d;
				end if;
			end if;
		end process;
end beh;
    