library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity D2FF_N_tb is
end entity D2FF_N_tb;

architecture beh of D2FF_N_tb is

    -- components
    component D2FF_N
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
    end component D2FF_N;

    -- constants
    constant NBIT           :   natural     := 8;
    constant CLK_PERIOD     :   time        := 10 ns;
    constant T_RESET        :   time        := 25 ns;
    constant A_RST_VALUE    :   std_logic   := '0';
            
    -- signals
    signal  clk_tb     :   std_logic   := '0';
    signal  a_rst_n_tb :   std_logic   := '0';
    signal  en_tb      :   std_logic   := '0';
    signal  sel_tb     :   std_logic   := '0';
    signal  d0_tb      :   std_logic_vector(Nbit - 1 downto 0)   := (others => '0');
    signal  d1_tb      :   std_logic_vector(Nbit - 1 downto 0)   := (others => '0');
    signal  q_tb       :   std_logic_vector(Nbit - 1 downto 0);
    signal  testing    :   boolean     := true;

    begin
    clk_tb <= not clk_tb after CLK_PERIOD/2 when testing else '0';
    a_rst_n_tb <= '1' after T_RESET;

    D2FF_N_DUT: D2FF_N
    generic map(
        Nbit => NBIT
    )
    port map
    (
        clk => clk_tb,
        a_rst_n => a_rst_n_tb,
        en  => en_tb,
        sel => sel_tb,
        d0  => d0_tb,
        d1  => d1_tb,
        q   => q_tb
    );

    stimuli: process(clk_tb, a_rst_n_tb)
        variable t : integer := 0;
    begin
        if(a_rst_n_tb = A_RST_VALUE) then
            en_tb  <=  '0';
            sel_tb <=  '0';
            d0_tb  <= (others => '0');
            d1_tb  <= (others => '0');
            t := 0;
        elsif(rising_edge(clk_tb)) then
            case(t) is
                when 1  =>
                    en_tb   <=  '1';
                    d0_tb   <= "00110011";
                    d1_tb   <= "00000000";
                    sel_tb  <=  '0'; -- read from d0
                when 2  =>
                    d0_tb   <= "00001111";
                    d1_tb   <= "00000000";
                    sel_tb  <=  '0'; -- read from d0
                when 3  =>
                    d0_tb   <= "00000000";
                    d1_tb   <= "11110000";
                    sel_tb  <=  '1'; -- read from d1
                when 4  =>
                    d0_tb   <= "00000000";
                    d1_tb   <= "11111111";
                    sel_tb  <=  '1'; -- read from d1
                when 5  =>
                    en_tb   <= '0'; -- don't read from input
                    d0_tb   <= "01010101";
                    d1_tb   <= "10101010";
                    sel_tb  <=  '1';
                when 6  =>
                    en_tb   <= '1'; -- read from input
                    d0_tb   <= "01010101";
                    d1_tb   <= "10101010";
                    sel_tb  <=  '1'; -- shift
                when 7  =>
                    testing <= false;
                when others =>
                    null;
            end case;

            t := t + 1;
        end if;
    end process stimuli;
    
end architecture beh;