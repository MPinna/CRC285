library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity D2FF_N is
    generic( 
        Nbit        : positive  := 8
    );
    port(
        clk     :   in  std_logic;
        a_rst_n :   in  std_logic;
        en      :   in  std_logic;
        sel     :   in  std_logic;
        d0      :   in  std_logic_vector(Nbit - 1 downto 0);
        d1      :   in  std_logic_vector(Nbit - 1 downto 0);
        q       :   out std_logic_vector(Nbit - 1 downto 0)
    );
end entity D2FF_N;

architecture struct of D2FF_N is
    constant A_RST_VALUE : std_logic := '0';
begin

    d2ff_n_proc: process(clk, a_rst_n)
    begin
        if(a_rst_n = A_RST_VALUE) then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if(en = '1') then
                if(sel = '0') then
                    q <= d0;
                else
                    q <= d1;
                end if;
            end if;
        end if;

    end process d2ff_n_proc;
end architecture struct;