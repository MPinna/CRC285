library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real."log2";
use IEEE.math_real."ceil";

--
--     │         <─┐
--     │           │in_en
--     │  ┌────────┴──────────┐
--     └─>│rst                │
--  │     │                   │
--  │     │   Control Unit    │
--  │     │                   │
--  └────>│clk                │
--        └──────┬──────┬─────┘
--        mid_sel│      │out_en
--               │      │
--             <─┘      │
--                      │
--                   <──┘
--

entity ControlUnit is
    generic(
        CU_cycles   :   natural := 58
    );
    port(
        clk     :   in  std_logic;
        a_rst_n :   in  std_logic;
        in_en   :   out std_logic;
        mid_sel :   out std_logic;
        out_en  :   out std_logic
    );
end entity ControlUnit;

architecture beh of ControlUnit is

    -- Constants
    constant C_CTR_INCREMENT  :   natural :=  1;
    constant C_CTR_CYCLES     :   natural :=  CU_cycles;

    constant C_PHASE_0_END    :   natural :=  0;
    constant C_PHASE_1_END    :   natural :=  2;
    constant C_PHASE_2_END    :   natural :=  C_CTR_CYCLES - 3;
    constant C_PHASE_3_END    :   natural :=  C_CTR_CYCLES - 2;
    constant C_PHASE_4_END    :   natural :=  C_CTR_CYCLES - 1;

    constant A_RST_VALUE    :   std_logic := '0';

    -- Signals
    -- output of the Counter
    signal  cntr_out_s      :   std_logic_vector(natural(ceil(log2(real(C_CTR_CYCLES)))) -1 downto 0) := (others => '0');

    -- Components
    component Counter is
        generic(
            N_cycles 		: natural 	:= 58
        );
        port(
            clk       : in  std_logic;
            a_rst_n   : in  std_logic;
            increment : in  std_logic_vector(natural(ceil(log2(real(N_cycles)))) - 1 downto 0);
            cntr_out  : out std_logic_vector(natural(ceil(log2(real(N_cycles)))) - 1 downto 0)
        );
    end component;
    
begin

    COUNTER_MAP : Counter
        generic map(
            N_cycles => C_CTR_CYCLES
            )
        port map(
            clk         =>  clk,
            a_rst_n     =>  a_rst_n,
            increment   =>  std_logic_vector(to_unsigned(C_CTR_INCREMENT, natural(ceil(log2(real(C_CTR_CYCLES)))))),
            cntr_out    =>  cntr_out_s
        );


    drive_out_signals: process(clk, cntr_out_s, a_rst_n)
        variable current_count_v  :   integer := 0;
    begin
        if(a_rst_n = A_RST_VALUE) then
            null;
        elsif(rising_edge(clk)) then
            current_count_v := to_integer(unsigned(cntr_out_s));

            if current_count_v <= C_PHASE_0_END then -- clock 0
                -- input registers don't read from input anymore
                -- accumulator and shift register read from input
                in_en   <= '0';
                mid_sel <= '0';
                out_en  <= '0';
            elsif current_count_v <= C_PHASE_1_END then   -- clock 1
                -- accumulator reads from feedback and
                -- Shift register starts shifting
                mid_sel <=  '1'; 
            elsif current_count_v <= C_PHASE_2_END then   -- clock 2 to 55
                null;
            elsif current_count_v <= C_PHASE_3_END then   -- clock 56
                -- stop computation and put result into
                -- output register
                mid_sel <=  '0'; --
                out_en  <=  '1';
            elsif current_count_v <= C_PHASE_4_END then   -- clock 57
                -- output register stops reading from input and accumulator
                -- input registers read from input
                out_en <= '0';
                in_en <= '1';
            else
                null;
            end if;
        end if;
    end process drive_out_signals;
end architecture beh;