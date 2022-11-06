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

entity ControlUnit_LUT is
    port (
        clk     :   in  std_logic;
        a_rst_n :   in  std_logic;
        in_en   :   out std_logic;
        mid_sel :   out std_logic;
        out_en  :   out std_logic
    );
end entity ControlUnit_LUT;

architecture beh of ControlUnit_LUT is
    
    -- Constants
    constant CTR_CYCLES : natural := 10;  
    constant CTR_INCREMENT  :   natural := 1;

    constant PHASE_0_END    :   natural := 0;
    constant PHASE_1_END    :   natural := 2;
    constant PHASE_2_END    :   natural := 7;
    constant PHASE_3_END    :   natural := 8;
    constant PHASE_4_END    :   natural := 9;

    -- Signals
    -- output of the Counter
    signal  cntr_out_s      :   std_logic_vector(natural(ceil(log2(real(CTR_CYCLES)))) - 1 downto 0) := (others => '0');

    -- Components
    component Counter is
        generic(
            N_cycles 		: natural 	:= 10
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
            N_cycles => CTR_CYCLES
            )
        port map(
            clk         =>  clk,
            a_rst_n     =>  a_rst_n,
            increment   =>  std_logic_vector(to_unsigned(CTR_INCREMENT, natural(ceil(log2(real(CTR_CYCLES)))))),
            cntr_out    =>  cntr_out_s
        );


    drive_out_signals: process(cntr_out_s)
        variable current_count_v  :   integer := 0;
    begin
        current_count_v := to_integer(unsigned(cntr_out_s));

        -- TODO: maybe replace if, elsif,... with case?
        if current_count_v <= PHASE_0_END then -- clock 0
            -- input registers don't read from input anymore
            -- accumulator and shift register read from input
            in_en   <= '0';
            mid_sel <= '0';
            out_en  <= '0';
        elsif current_count_v <= PHASE_1_END then   -- clock 1
            -- accumulator reads from feedback and
            -- Shift register starts shifting
            mid_sel <=  '1'; 
        elsif current_count_v <= PHASE_2_END then   -- clock 2 to 7
            null;
        elsif current_count_v <= PHASE_3_END then   -- clock 8
            -- stop computation and put result into
            -- output register
            mid_sel <=  '0'; --
            out_en  <=  '1';
        elsif current_count_v <= PHASE_4_END then   -- clock 9
            -- output register stops reading from input and accumulator
            -- input registers read from input
            out_en <= '0';
            in_en <= '1';
        else
            null;
        end if;
    end process drive_out_signals;
end architecture beh;