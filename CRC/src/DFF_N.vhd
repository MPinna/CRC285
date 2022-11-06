library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DFF_N is
    generic(
        DFF_N_size : natural := 8
    );

    port(
        clk     :   in  std_logic;
        a_rst_n :   in  std_logic;
        en      :   in  std_logic;
        d       :   in  std_logic_vector(DFF_N_size - 1 downto 0);
        q       :   out std_logic_vector(DFF_N_size - 1 downto 0)
    );

end entity DFF_N;

architecture struct of DFF_N is
    constant A_RST_VALUE : std_logic := '0';
begin
    
    ddf_n_proc: process(clk, a_rst_n)
    begin
       if(a_rst_n = A_RST_VALUE) then
            q   <=  (others => '0');
       elsif rising_edge(clk) then
            if (en = '1') then
                q   <=  d;
            end if;
       end if;
   end process ddf_n_proc;
end architecture struct;