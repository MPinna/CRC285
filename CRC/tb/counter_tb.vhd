library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real."log2";
use IEEE.math_real."ceil";

entity counter_tb is
end entity counter_tb;

architecture beh of counter_tb is
    
    -- Testbench constants
    constant CLK_PERIOD :   time    := 10 ns;
    constant T_RESET    :   time    := 25 ns;
	constant N_CYCLES	:	natural	:= 58;
    constant CTR_BITS   :   natural := natural(ceil(log2(real(N_CYCLES))));
	constant INCREMENT 	:	natural := 2;
    -- Testbench signals
    signal clk_tb           :   std_logic   := '0';
    signal a_rst_n_tb       :   std_logic   := '0';
    signal increment_tb     :   std_logic_vector(CTR_BITS -1 downto 0) := (others => '0');
    signal cntr_out_tb      :   std_logic_vector(CTR_BITS -1 downto 0);
    signal testing          :   boolean     := true;


    component Counter is
        generic(
			N_cycles : natural := 58
		);
        port(
          clk       : in  std_logic;
          a_rst_n   : in  std_logic;
          increment : in  std_logic_vector(CTR_BITS - 1 downto 0);
          cntr_out  : out std_logic_vector(CTR_BITS - 1 downto 0)
        );
    end component;

    begin
  
    clk_tb <= not clk_tb after CLK_PERIOD/2 when testing else '0';
    a_rst_n_tb <= '1' after T_RESET;
    Counter_DUT: Counter
	generic map
		(
			N_cycles => N_CYCLES
			)
			port map
				(
					clk         =>  clk_tb,
					a_rst_n     =>  a_rst_n_tb,
					increment   =>  increment_tb,
					cntr_out    =>  cntr_out_tb
					);
					
					stimuli: process(clk_tb, a_rst_n_tb)
						variable t  : integer := 0;
					begin
						if(a_rst_n_tb = '0') then
				increment_tb <= (others => '0');
				t := 0;
			elsif(rising_edge(clk_tb)) then
				increment_tb <= std_logic_vector(to_unsigned(INCREMENT, CTR_BITS));
				-- increment_tb <= (0 => '1', others => '0');
				case(t) is
					when 120 =>
						testing <= false;
					when others	=>
						null;
				end case;
				t := t + 1;
			end if;
		end process;
end architecture beh;