library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PIPOShiftReg is
    generic( 
        ShiftReg_size   : positive  := 8;
        ShiftLen        : natural   := 1
    );
    port(
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        -- uncomment next line if enable is needed
        --
        -- en      :   in  std_logic;
        sel     :   in  std_logic;
        d       :   in  std_logic_vector(ShiftReg_size - 1 downto 0);
        q       :   out std_logic_vector(ShiftReg_size - 1 downto 0)
    );
end entity PIPOShiftReg;

architecture struct of PIPOShiftReg is
    
    component D2FF
        port(
            clk         :   in  std_logic;
            a_rst_n     :   in  std_logic;
            en          :   in  std_logic;
            sel         :   in  std_logic;
            d0          :   in  std_logic;
            d1          :   in  std_logic;
            q           :   out std_logic
        );
        end component D2FF;
        
    signal q_s  : std_logic_vector(ShiftReg_size - 1 downto 0);
        
begin
    -- generation of N instances of the Double Data flip-flop
    GEN: for i in 0 to ShiftReg_size - 1 generate
        -- first D2FF, d1 is always '0'
        FIRST: if i < ShiftLen generate
            FF_1: D2FF
            port map(
                clk         =>  clk,
                a_rst_n   =>  reset,
                -- en          =>  en,
                en          =>  '1',
                sel         =>  sel,
                d0          =>  d(i),
                d1          =>  '0',
                q           =>  q_s(i)
            );
        end generate FIRST;

        INTERNAL: if i >= ShiftLen  and i < ShiftReg_size - 1 generate
            FF_I: D2FF
            port map(
                clk     =>  clk,
                a_rst_n =>  reset,
                -- en      =>  en,
                en      =>  '1',
                sel     =>  sel,
                d0      =>  d(i),
                d1      =>  q_s(i-ShiftLen),
                q       =>  q_s(i)                
            );
        end generate INTERNAL;
        
        LAST: if i = ShiftReg_size - 1 generate
            FF_N: D2FF
            port map(
                clk         =>  clk,
                a_rst_n     =>  reset,
                -- en          =>  en,
                en          =>  '1',
                sel         =>  sel,
                d0          =>  d(i),
                d1          =>  q_s(i-ShiftLen),
                q           =>  q_s(i)
            );
        end generate LAST;

    end generate GEN;
    q <= q_s;
    
end architecture struct;