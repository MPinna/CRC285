entity PIPOShiftReg is
    generic( 
        ShiftReg_size   : positive  := 8;
        ShiftLen        : natural   := 1
    );
    port(
        clk     :   in  std_logic;
        reset   :   in  std_logic;
        sel     :   in  std_logic;
        d       :   in  std_logic_vector(ShiftReg_size - 1 downto 0);
        q       :   out std_logic_vector(ShiftReg_size - 1 downto 0)
    );
end entity PIPOShiftReg;

architecture struct of PIPOShiftReg is
    
    component D2FF
        -- [...]
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
                a_rst_n     =>  reset,
                en          =>  '1',
                sel         =>  sel,
                d0          =>  d(i),
                d1          =>  '0',
                q           =>  q_s(i)
            );
        end generate FIRST;

        LAST: if i >= ShiftLen generate
            FF_I: D2FF
            port map(
                clk         =>  clk,
                a_rst_n     =>  reset,
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