library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real."log2";
use IEEE.math_real."ceil";

--     ┌─────────────────────┐
--     │     ┌────────────┐  │
--     │     │    ┌───┐   │  │
-- incr│    ┌┴┐   │   │   │  │Out
--   ──┼───►│+├──►│   ├───┴──┼───►
--     │    └─┘   │   │      │
--     │          └───┘      │
--     └─────────────────────┘

entity Counter is
	generic
	(
		Counter_N 		: natural 	:= 6;
		N_cycles 		: natural 	:= 56
	);
  	port(
		clk       : in  std_logic;
		a_rst_n   : in  std_logic;
		-- move incremenet to generic() ?
		increment : in  std_logic_vector(natural(ceil(log2(real(N_cycles)))) - 1 downto 0);
		cntr_out  : out std_logic_vector(natural(ceil(log2(real(N_cycles)))) - 1 downto 0)
    );
end Counter;
	
architecture struct of Counter is
	
	-- Constants
	constant COUNTER_BITS	:	natural	:= natural(ceil(log2(real(N_cycles))));
	constant NUM_OF_CYCLES	:	std_logic_vector := std_logic_vector(to_unsigned(N_cycles, COUNTER_BITS));
	constant A_RST_VALUE	:	std_logic	:=	'0';

	-- Signals

	-- Output of the fullAdder_N
	signal fullAdder_out	: std_logic_vector(COUNTER_BITS - 1 downto 0) 		:= (others => '0');
	-- Output of the DFF_N
	signal dffn_out 		: std_logic_vector(COUNTER_BITS - 1 downto 0)		:= (others => '0');
	-- Second signal needed to implement the max count check
	signal accumulator		: std_logic_vector(COUNTER_BITS - 1 downto 0)		:= (others => '0');
	
	-- Components declaration
	component RippleCarryAdder is
	generic (RCA_N : integer := 8);
		port (
			a    : in std_logic_vector(RCA_N - 1 downto 0);
			b    : in std_logic_vector(RCA_N - 1 downto 0);
			cin  : in std_logic;
			s    : out std_logic_vector(RCA_N - 1 downto 0);
			cout : out std_logic
		);
	end component;
	
	component DFF_N is
	generic( DFF_bit : natural := 8);
		port( 
			clk     : in std_logic;
			a_rst_n : in std_logic;
			en      : in std_logic;
			d       : in std_logic_vector(DFF_bit - 1 downto 0);
			q       : out std_logic_vector(DFF_bit - 1 downto 0)
		);
	end component;
	
	begin
   
		RIPPLE_CARRY_ADDER_MAP :  RippleCarryAdder 
			generic map(RCA_N	=>	COUNTER_BITS)
			port map(
				a    => increment,
				b    => accumulator,
				cin  => '0',
				s    => fullAdder_out,
				cout => open
			);
			
		DFF_N_MAP : DFF_N 
			generic map(DFF_bit => COUNTER_BITS)
			port map( 
				clk     => clk,
				a_rst_n => a_rst_n,
				d       => fullAdder_out,
				en      => '1',
				q       => dffn_out
	        );

	    -- Mapping the output
	    accumulator <= dffn_out when dffn_out < NUM_OF_CYCLES
					else (others => '0');
		cntr_out <= accumulator;
	   
end struct;