library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CRC_tb is
end entity CRC_tb;

architecture rtl of CRC_tb is
    
    -- comment out the appropriate line to change implementation under test
    -- component CRC_bitwise is
    component CRC_LUT is
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
    end component;

    -- Constants
    constant C_CLK_PERIOD   :   time    := 10 ns;
    constant C_T_RESET      :   time    := 25 ns;
    constant C_MSG_SIZE     :   natural := 56;
    constant C_CRC_SIZE     :   natural := 8;
        -- comment out the appropriate line to change implementation under test
    -- constant C_CYCLES       :   natural := 58; -- bitwise
    constant C_CYCLES       :   natural := 10; -- LUT
    
    
    type longs_t is array (0 to 9) of std_logic_vector(C_MSG_SIZE + C_CRC_SIZE - 1 downto 0);
    
    constant messages_m: longs_t := (
        -- x"0000000000686800",
        x"0526abfa59289d00",
        x"1ad743298a5b0c00",
        x"49dbf2d3fca77800",
        x"58de7943c3b4e100",
        x"7a32768bdb8fb400",
        x"8d73243271fdf200",
        x"c387f7b71ddd5000",
        x"d8c6662579109800",
        x"e34a300fa4c34500",
        x"f9e70f4d2b6ed300"
        );
        
    constant messages_d: longs_t := (
        x"0526abfa59289d75",
        -- x"00000000006868b9",
        x"1ad743298a5b0c13",
        x"49dbf2d3fca7787a",
        x"58de7943c3b4e1f7",
        x"7a32768bdb8fb458",
        x"8d73243271fdf286",
        x"c387f7b71ddd502e",
        x"d8c66625791098b7",
        x"e34a300fa4c3451d",
        x"f9e70f4d2b6ed389"
    );

    constant messages_w: longs_t := (
        x"0526aafa59289d75",
        x"1ad744298a5b0c13",
        x"49dbf3d3fca7787a",
        x"58de7843c3b4e1f7",
        x"7a32758bdb8fb458",
        x"8d73233271fdf286",
        x"c387f6b71ddd502e",
        x"d8c66525791098b7",
        x"e34a310fa4c3451d",
        x"f9e70e4d2b6ed389"
    );

    

    signal  clk_tb      :   std_logic   := '0';
    signal  a_rst_n_tb  :   std_logic   := '0';
    signal  d_in_tb     :   std_logic_vector(C_MSG_SIZE + C_CRC_SIZE - 1 downto 0)   := (others => '0');
    signal  md_tb       :   std_logic   :=  '0';
    signal  d_out_tb    :   std_logic_vector(C_MSG_SIZE + C_CRC_SIZE - 1 downto 0);
    signal  testing     :   boolean     := true;

    begin
    clk_tb <= not clk_tb after C_CLK_PERIOD when testing else '0';
    a_rst_n_tb <= '1' after C_T_RESET;

    -- comment out the appropriate line to change implementation under test
    -- CRC_dut: CRC_bitwise
    CRC_dut: CRC_LUT
        generic map(
            msg_size    => C_MSG_SIZE,
            CRC_size    => C_CRC_SIZE
        )
        port map(
            clk     => clk_tb,
            a_rst_n => a_rst_n_tb,
            d_in    => d_in_tb,
            md      => md_tb,
            d_out   => d_out_tb
        );

    stimuli: process(clk_tb, a_rst_n_tb)
        variable t : integer := 0;
    begin
        if(a_rst_n_tb = '0') then
            d_in_tb <= (others => '0');
        elsif(rising_edge(clk_tb)) then
            case(t) is
                -- sender mode
                when 0*C_CYCLES =>
                    -- md_tb <= '0';
                when 1*C_CYCLES - 5 =>
                    md_tb <= '0';
                    d_in_tb <= messages_m(0);
                when 2*C_CYCLES - 5 =>
                    d_in_tb <= messages_m(1);
                when 3*C_CYCLES - 5 =>
                    d_in_tb <= messages_m(2);
                when 4*C_CYCLES - 5 =>
                    d_in_tb <= messages_m(3);
                when 5*C_CYCLES - 5 =>
                    d_in_tb <= messages_m(4);
                when 6*C_CYCLES - 5 =>
                    d_in_tb <= messages_m(5);
                when 7*C_CYCLES - 5 =>
                    d_in_tb <= messages_m(6);
                when 8*C_CYCLES - 5 =>
                    d_in_tb <= messages_m(7);
                when 9*C_CYCLES - 5 =>
                    d_in_tb <= messages_m(8);
                when 10*C_CYCLES - 5 =>
                    d_in_tb <= messages_m(9);

                -- received mode with correct messages and CRCs
                when 11*C_CYCLES - 5 =>
                    md_tb <= '1';
                    d_in_tb <= messages_d(0);
                when 12*C_CYCLES - 5 =>
                    d_in_tb <= messages_d(1);
                when 13*C_CYCLES - 5 =>
                    d_in_tb <= messages_d(2);
                when 14*C_CYCLES - 5 =>
                    d_in_tb <= messages_d(3);
                when 15*C_CYCLES - 5 =>
                    d_in_tb <= messages_d(4);
                when 16*C_CYCLES - 5 =>
                    d_in_tb <= messages_d(5);
                when 17*C_CYCLES - 5 =>
                    d_in_tb <= messages_d(6);
                when 18*C_CYCLES - 5 =>
                    d_in_tb <= messages_d(7);
                when 19*C_CYCLES - 5 =>
                    d_in_tb <= messages_d(8);
                when 20*C_CYCLES - 5 =>
                    d_in_tb <= messages_d(9);

                -- receiver mode with corrupted messages 
                when 21*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(0);
                when 22*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(1);
                when 23*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(2);
                when 24*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(3);
                when 25*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(4);
                when 26*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(5);
                when 27*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(6);
                when 28*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(7);
                when 29*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(8);
                when 30*C_CYCLES - 5 =>
                    d_in_tb <= messages_w(9);

                when 32*C_CYCLES - 5 =>
                    testing <= false;
                when others =>
                    null;
            end case;
            t := t + 1;
        end if;
    end process;
end architecture rtl;