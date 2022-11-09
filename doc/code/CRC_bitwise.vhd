entity CRC_bitwise is
    generic(
        msg_size    : natural := 56;
        CRC_size    : natural := 8
    );
    port(
        clk     :   in  std_logic;
        a_rst_n :   in  std_logic;
        d_in    :   in  std_logic_vector(msg_size + CRC_size - 1 downto 0);
        md      :   in  std_logic;
        d_out   :   out std_logic_vector(msg_size + CRC_size - 1 downto 0)
    );
end entity CRC_bitwise;

architecture struct of CRC_bitwise is

    -- declaration of the following components: DFF, DFF_N, D2FF_N
    -- PIPOShiftReg, XOR_logical, ControlUnit
    -- declarations of constants...

    signal  msg_reg_out     :   std_logic_vector(C_MSG_SIZE - 1 downto 0)  := (others => '0');
    signal  crc_reg_out     :   std_logic_vector(C_CRC_SIZE - 1 downto 0)  := (others => '0');
    signal  md_reg_out      :   std_logic   := '0';

    signal  mux_out         :   std_logic_vector(C_CRC_SIZE - 1 downto 0)  := (others => '0');

    signal  accum_d1        :   std_logic_vector(C_ACCUM_SIZE - 1 downto 0) := (others => '0');
    signal  accum_out       :   std_logic_vector(C_ACCUM_SIZE - 1 downto 0) := (others => '0');

    signal  xor_out         :   std_logic_vector(C_XOR_OUTPUT_SIZE - 1 downto 0) := (others => '0');

    signal  shift_reg_in  :  std_logic_vector(C_SHIFT_REG_SIZE - 1 downto 0) := (others => '0');
    signal  shift_reg_out :  std_logic_vector(C_SHIFT_REG_SIZE - 1 downto 0) := (others => '0');
     
    signal  out_reg_in :  std_logic_vector(C_OUT_SIZE - 1 downto 0) := (others => '0');

    signal  CU_in_en    :   std_logic   := '0';
    signal  CU_mid_sel  :   std_logic   := '0';
    signal  CU_out_en   :   std_logic   := '0';

    begin

    msg_reg : DFF_N
        generic map(
            DFF_N_size  =>  C_MSG_SIZE
        )
        port map(
            en      => CU_in_en,
            d       => d_in(C_MSG_SIZE + C_CRC_SIZE - 1 downto C_CRC_SIZE),
            q       => msg_reg_out
        );

    crc_reg : DFF_N
        generic map(
            DFF_N_size  =>  C_CRC_SIZE
        )
        port map(
            en      => CU_in_en,
            d       => d_in(C_CRC_SIZE - 1 downto 0),
            q       => crc_reg_out
        );

    md_reg : DFF
        port map(
            en      => CU_in_en,
            d       => md,
            q       => md_reg_out
        );
    
    accumulator : D2FF_N
        generic map(
            D2FF_N_size => C_ACCUM_SIZE -- 9
        )
        port map(
            en      => '1',
            sel     => CU_mid_sel,
            d0      => msg_reg_out(C_MSG_SIZE - 1 downto C_MSG_SIZE - C_ACCUM_SIZE),
            d1      => accum_d1,
            q       => accum_out
        );

    shift_register : PIPOShiftReg
        generic map(
            ShiftReg_size   => C_SHIFT_REG_SIZE, -- 55
            ShiftLen        => C_SHIFT_LEN -- 1
        )
        port map(
            sel     =>  CU_mid_sel,
            d       =>  shift_reg_in,
            q       =>  shift_reg_out
        );

    xor_log : XOR_logical
        generic map(
            XOR_input_size  =>  C_XOR_INPUT_SIZE -- 9
        )
        port map(
            d_in    =>  accum_out,
            d_out   =>  xor_out
        );

    CU : ControlUnit
        generic map(
            CU_cycles => C_N_CYCLES -- 58
        )
        port map(
            in_en   => CU_in_en,
            mid_sel => CU_mid_sel,
            out_en  => CU_out_en
        );

    out_reg : DFF_N
        generic map(
            DFF_N_size => C_OUT_SIZE
        )
        port map(
            en      => CU_out_en,
            d       => out_reg_in,
            q       => d_out
        );

        
    mux_proc: process(clk, md_reg_out, crc_reg_out)
    begin
        if(md_reg_out = '1') then
            mux_out <= crc_reg_out;
        else
            mux_out <= (others => '0');
        end if;
    end process mux_proc;

    shift_reg_in    <= msg_reg_out(C_MSG_SIZE - C_ACCUM_SIZE - 1 downto 0) & mux_out;
    accum_d1        <= xor_out & shift_reg_out(C_SHIFT_REG_SIZE - 1);
    out_reg_in      <= msg_reg_out & xor_out;

    end architecture struct;