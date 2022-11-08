library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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

    -- ##### Components #####
    component DFF is
        port( 
            clk     : in std_logic;
            a_rst_n : in std_logic;
            en      : in std_logic;
            d       : in std_logic;
            q       : out std_logic
        );
    end component DFF;

    component DFF_N is
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
    end component DFF_N;

    component D2FF_N is
        generic(
            D2FF_N_size : positive := 8
        );
        port(
            clk     :   in  std_logic;
            a_rst_n :   in  std_logic;
            en      :   in  std_logic;
            sel     :   in  std_logic;
            d0      :   in  std_logic_vector(D2FF_N_size - 1 downto 0);
            d1      :   in  std_logic_vector(D2FF_N_size - 1 downto 0);
            q       :   out std_logic_vector(D2FF_N_size - 1 downto 0)
        );
    end component D2FF_N;

    component PIPOShiftReg is
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
    end component PIPOShiftReg;

    
    component XOR_logical is
        generic(
            XOR_input_size : positive := 9
            );
            port (
                d_in    : in    std_logic_vector(XOR_input_size - 1 downto 0);
                d_out   : out   std_logic_vector(XOR_input_size - 2 downto 0)
                );
    end component XOR_logical;
            
    component ControlUnit_bitwise is
        port(
            clk     :   in  std_logic;
            a_rst_n :   in  std_logic;
            in_en   :   out std_logic;
            mid_sel :   out std_logic;
            out_en  :   out std_logic
        );
    end component ControlUnit_bitwise;

    -- ##### Constants #####
    constant C_MSG_SIZE       :   natural := msg_size;
    constant C_CRC_SIZE       :   natural := CRC_size;
    constant C_ACCUM_SIZE     :   natural := 9;
    constant C_SHIFT_REG_SIZE :   natural := 55;
    constant C_SHIFT_LEN      :   natural := 1;
    constant C_OUT_SIZE       :   natural := 64;

    constant C_XOR_INPUT_SIZE  :  natural := 9;
    constant C_XOR_OUTPUT_SIZE :  natural := C_XOR_INPUT_SIZE - 1;
    
    constant A_RST_VALUE        : std_logic := '0';

    -- ##### Signals #####
    signal  msg_reg_out     :   std_logic_vector(C_MSG_SIZE - 1 downto 0)  := (others => '0');
    signal  crc_reg_out     :   std_logic_vector(C_CRC_SIZE - 1 downto 0)  := (others => '0');
    signal  md_reg_out      :   std_logic   := '0';

    signal mux_out      :   std_logic_vector(C_CRC_SIZE - 1 downto 0)  := (others => '0');

    signal  accum_d1   :   std_logic_vector(C_ACCUM_SIZE - 1 downto 0) := (others => '0');
    signal  accum_out   :   std_logic_vector(C_ACCUM_SIZE - 1 downto 0) := (others => '0');

    signal xor_out      :   std_logic_vector(C_XOR_OUTPUT_SIZE - 1 downto 0) := (others => '0');

    signal shift_reg_in  :  std_logic_vector(C_SHIFT_REG_SIZE - 1 downto 0) := (others => '0');
    signal shift_reg_out :  std_logic_vector(C_SHIFT_REG_SIZE - 1 downto 0) := (others => '0');
    
    signal out_reg_in :  std_logic_vector(C_OUT_SIZE - 1 downto 0) := (others => '0');


    signal  CU_in_en    :   std_logic   := '0';
    signal  CU_mid_sel  :   std_logic   := '0';
    signal  CU_out_en   :   std_logic   := '0';

    -- ######### BEGIN ##########
    begin

    msg_reg : DFF_N
        generic map(
            DFF_N_size  =>  C_MSG_SIZE
        )
        port map(
            clk     =>  clk,
            a_rst_n => a_rst_n,
            en      => CU_in_en,
            d       => d_in(C_MSG_SIZE + C_CRC_SIZE - 1 downto C_CRC_SIZE),
            q       => msg_reg_out
        );

    crc_reg : DFF_N
        generic map(
            DFF_N_size  =>  C_CRC_SIZE
        )
        port map(
            clk     =>  clk,
            a_rst_n => a_rst_n,
            en      => CU_in_en,
            d       => d_in(C_CRC_SIZE - 1 downto 0),
            q       => crc_reg_out
        );

    md_reg : DFF
        port map(
            clk     =>  clk,
            a_rst_n => a_rst_n,
            en      => CU_in_en,
            d       => md,
            q       => md_reg_out
        );
    
    accumulator : D2FF_N
        generic map(
            D2FF_N_size => C_ACCUM_SIZE
        )
        port map(
            clk     => clk,
            a_rst_n => a_rst_n,
            en      => '1', -- enable not needed in this implementation
            sel     => CU_mid_sel,
            d0      => msg_reg_out(C_MSG_SIZE - 1 downto C_MSG_SIZE - C_ACCUM_SIZE),
            d1      => accum_d1,
            q       => accum_out
        );


    -- check if size of d is consistent
    assert C_MSG_SIZE - C_ACCUM_SIZE = C_SHIFT_REG_SIZE report "Shift register input size conflict" severity Warning;

    shift_register : PIPOShiftReg
        generic map(
            ShiftReg_size   => C_SHIFT_REG_SIZE,
            ShiftLen        => C_SHIFT_LEN
        )
        port map(
            clk     =>  clk,
            reset   =>  a_rst_n,
            sel     =>  CU_mid_sel,
            d       =>  shift_reg_in,
            q       =>  shift_reg_out
        );

    xor_log : XOR_logical
        generic map(
            XOR_input_size  =>  C_XOR_INPUT_SIZE
        )
        port map(
            d_in    =>  accum_out,
            d_out   =>  xor_out
        );

    CU : ControlUnit_bitwise
        port map(
            clk     => clk,
            a_rst_n => a_rst_n,
            in_en   => CU_in_en,
            mid_sel => CU_mid_sel,
            out_en  => CU_out_en
        );

    out_reg : DFF_N
        generic map(
            DFF_N_size => C_OUT_SIZE
        )
        port map(
            clk     =>  clk,
            a_rst_n => a_rst_n,
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