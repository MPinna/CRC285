library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_tb is
end entity counter_tb;

architecture beh of counter_tb is
    
    -- Testbench constants
    constant CLK_PERIOD :   time    := 10 ns;
    constant T_RESET    :   time    := 25 ns;
    constant CTR_BITS   :   natural := 6;
	constant MAX_COUNT	:	natural	:= 56;
   
    -- Testbench signals
    signal clk_tb           :   std_logic   := '0';
    signal a_rst_n_tb       :   std_logic   := '0';
    signal increment_tb     :   std_logic_vector(CTR_BITS -1 downto 0) := (others => '0');
    signal cntr_out_tb      :   std_logic_vector(CTR_BITS -1 downto 0);
    signal testing          :   boolean     := true;


    component Counter is
        generic(Counter_N 	: natural := 6;
				max			: natural := 56
			);
        port(
          clk       : in  std_logic;
          a_rst_n   : in  std_logic;
          increment : in  std_logic_vector(Counter_N - 1 downto 0);
          cntr_out  : out std_logic_vector(Counter_N - 1 downto 0)
        );
    end component;

    begin
  
    clk_tb <= not clk_tb after CLK_PERIOD/2 when testing else '0';
    a_rst_n_tb <= '1' after T_RESET;
	-- set increment to 1 (set increment LSB to 1)
    Counter_DUT: Counter
	generic map
		(
			Counter_N	=> CTR_BITS,
			max			=> MAX_COUNT
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
				increment_tb <= (0 => '1', others => '0');
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