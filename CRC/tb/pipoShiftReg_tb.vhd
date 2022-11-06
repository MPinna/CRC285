library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity PIPOShiftReg_tb is
end entity PIPOShiftReg_tb;

architecture bhv of PIPOShiftReg_tb is
    
    -- Testbench constants
    constant CLK_PERIOD     :   time        := 10 ns;
    constant T_RESET        :   time        := 25 ns;
    constant SHIFTREG_BIT   :   positive    := 8;
    constant SHIFT_LEN      :   natural     := 1;
    constant A_RST_VALUE    :   std_logic   := '0';

    -- Testbench signals
    signal  clk_tb      :   std_logic   := '0';
    signal  a_rst_n     :   std_logic   := '0';
    -- signal  en_tb       :   std_logic   := '0';
    signal  sel_tb      :   std_logic   := '0';
    signal  d_tb        :   std_logic_vector(SHIFTREG_BIT - 1 downto 0)   := (others => '0');
    signal  q_tb        :   std_logic_vector(SHIFTREG_BIT - 1 downto 0);
    signal  testing     :   boolean     := true;

    -- Components
    component PIPOShiftReg is
        generic(
            ShiftReg_size   : positive  := 8;
            ShiftLen        : natural   := 1
        );
        port(
            clk     :   in  std_logic;
            reset   :   in  std_logic;
            -- en      :   in  std_logic;  -- necessary?
            sel     :   in  std_logic;
            d       :   in  std_logic_vector(ShiftReg_size - 1 downto 0);
            q       :   out std_logic_vector(ShiftReg_size - 1 downto 0)
        );
    end component;

    begin

    clk_tb <= not clk_tb after CLK_PERIOD/2 when testing else '0';
    a_rst_n <= '1' after T_RESET;

    PIPOShiftReg_DUT: PIPOShiftReg
        generic map(
            ShiftReg_size   => SHIFTREG_BIT,
            ShiftLen        => SHIFT_LEN
        )
        port map
        (
            clk     =>  clk_tb,
            reset   =>  a_rst_n,
            -- en      =>  en_tb,
            sel     =>  sel_tb,
            d       =>  d_tb,
            q       =>  q_tb
        );

    stimuli: process(clk_tb, a_rst_n)
        variable t : integer := 0;
    begin
        if(a_rst_n = A_RST_VALUE) then
            d_tb <= (others => '0');
            t := 0;
        elsif(rising_edge(clk_tb)) then
            case(t) is
                when 1  =>
                    d_tb    <= "11001100";
                    sel_tb  <=  '0'; -- read from input, don't shift
                when 2  =>
                    d_tb    <= "00110011";
                    sel_tb  <=  '0'; -- read from input, don't shift
                when 3  =>
                    d_tb    <= "11001100";
                    sel_tb  <=  '1'; -- shift
                when 4  =>
                    d_tb    <= "11001100";
                    sel_tb  <=  '1'; -- shift
                when 5  =>
                    d_tb    <= "11111111";
                    sel_tb  <=  '1'; -- shift
                when 6  =>
                    d_tb    <= "11111111";
                    sel_tb  <=  '1'; -- shift
                when 7  =>
                    d_tb    <= "00100111";
                    sel_tb  <=  '1'; -- shift
                when 8  =>
                    d_tb    <= "00100011";
                    sel_tb  <=  '0'; -- read input
                when 9  =>
                    d_tb    <= "00100111";
                    sel_tb  <=  '0'; -- read input
                when 10  =>
                    d_tb    <= "00100111";
                    sel_tb  <=  '1'; -- shift
                when 11  =>
                    d_tb    <= "00100111";
                    sel_tb  <=  '1'; -- shift
                when 12  =>
                    d_tb    <= "00100111";
                    sel_tb  <=  '1'; -- shift
                when 13  =>
                    d_tb    <= "00100111";
                    sel_tb  <=  '1'; -- shift
                when 14  =>
                    d_tb    <= "00100111";
                    sel_tb  <=  '1'; -- shift
                when 15  =>
                    d_tb    <= "00100111";
                    sel_tb  <=  '1'; -- shift
                when 16  =>
                    d_tb    <= "00100111";
                    sel_tb  <=  '1'; -- shift
                when others =>
                    null;
            end case;

            t := t + 1;
        end if;
    end process;
 end architecture bhv;