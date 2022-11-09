entity CRC_LUT is
    -- [...]
end entity CRC_LUT;

architecture struct of CRC_LUT is

    -- declaration of the following components: DFF, DFF_N, D2FF_N
    -- PIPOShiftReg, XOR_logical, ControlUnit
    
    -- ... declarations of constants and signals ...

begin
    -- instatiation and map of various components
    -- ...
    
    accumulator : D2FF_N
        generic map(
            D2FF_N_size => C_ACCUM_SIZE -- 8
        )
        port map(
            -- [...]
        );

    shift_register : PIPOShiftReg
        generic map(
            ShiftReg_size   => C_SHIFT_REG_SIZE, -- 56
            ShiftLen        => C_SHIFT_LEN -- 8
        )
        port map(
            -- [...]
        );

    lut : XOR_LUT
        generic map(
            XOR_LUT_input_size  =>  C_LUT_INPUT_SIZE -- 8
        )
        port map(
            d_in    =>  accum_out,
            d_out   =>  lut_out
        );

    CU : ControlUnit
        generic map(
            CU_cycles => C_N_CYCLES -- 10
        )
        port map(
            -- [...]
        );
        
    mux_proc: process(clk, md_reg_out, crc_reg_out)
        -- [...]
    end process mux_proc;

    shift_reg_in    <= msg_reg_out(C_MSG_SIZE - C_ACCUM_SIZE - 1 downto 0) & mux_out;
    accum_d1        <= lut_out xor shift_reg_out(C_SHIFT_REG_SIZE - 1 downto C_SHIFT_REG_SIZE - C_ACCUM_SIZE);
    out_reg_in      <= msg_reg_out & accum_out;

end architecture struct;