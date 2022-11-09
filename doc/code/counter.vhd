entity Counter is
	generic
	(
		N_cycles 		: natural 	:= 58
	);
  	port(
		clk       : in  std_logic;
		a_rst_n   : in  std_logic;
		increment : in  std_logic_vector(natural(ceil(log2(real(N_cycles)))) - 1 downto 0);
		cntr_out  : out std_logic_vector(natural(ceil(log2(real(N_cycles)))) - 1 downto 0)
    );
end Counter;
	
architecture struct of Counter is

	constant C_COUNTER_BITS	:	natural	:= natural(ceil(log2(real(N_cycles))));
	constant C_N_CYCLES	:	std_logic_vector := std_logic_vector(to_unsigned(N_cycles, C_COUNTER_BITS));
	constant C_A_RST_VALUE	:	std_logic	:=	'0';

	signal fullAdder_out	: std_logic_vector(C_COUNTER_BITS - 1 downto 0) 		:= (others => '0');
	signal dffn_out 		: std_logic_vector(C_COUNTER_BITS - 1 downto 0)		:= (others => '0');
	-- Needed to implement the max count check
	signal accumulator		: std_logic_vector(C_COUNTER_BITS - 1 downto 0)		:= (others => '0');
	
	component RippleCarryAdder is
		-- [...]
	end component;
	
	component DFF_N is
		-- [...]
	end component;
	
	begin

		RIPPLE_CARRY_ADDER_MAP :  RippleCarryAdder 
			generic map(RCA_N	=>	C_COUNTER_BITS)
			port map(
				a    => increment,
				b    => accumulator,
				cin  => '0',
				s    => fullAdder_out,
				cout => open
			);

		DFF_N_MAP : DFF_N 
			generic map(DFF_N_size => C_COUNTER_BITS)
			port map( 
				clk     => clk,
				a_rst_n => a_rst_n,
				d       => fullAdder_out,
				en      => '1',
				q       => dffn_out
	        );

	    accumulator <= dffn_out when dffn_out < C_N_CYCLES
					else (others => '0');
		cntr_out <= accumulator;
	   
end struct;