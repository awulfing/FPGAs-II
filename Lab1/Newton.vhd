library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Newton is
	generic (W_bits : natural;
		F_bits :natural;
		N_iterations :natural);

	port (x 	: in std_logic_vector(W_bits-1 downto 0);
		y	: out std_logic_vector(W_bits-1 downto 0);
		clk	: in std_logic;
		y0	: in std_logic_vector(W_bits-1 downto 0));
end entity Newton;

architecture Newton_arch of Newton is
	component Iteration is
	generic(W_WIDTH	: natural;
		F_FRACT	: natural);
	port(clk	: in std_logic;
		x	: in std_logic_vector(W_WIDTH-1 downto 0);
		y	: out std_logic_vector(W_WIDTH-1 downto 0);
		y0	: in std_logic_vector(W_WIDTH-1 downto 0));
	end component;

type my_connection_array is array (natural range <>) of std_logic_vector(W_bits-1 downto 0);
signal yVect : my_connection_array(N_iterations downto 0);
signal xVect : my_connection_array(N_iterations*5 downto 0);

begin

---------------------------------------------------------------------
delayVect : process(clk)
	begin
	if(rising_edge(clk)) then
		xVect(0) <= x;
		for i in 1 to N_iterations*5 loop
			xVect(i) <= xVect(i-1);
		end loop;
	end if;
end process;
---------------------------------------------------------------------
	--take in lab 1 val
	yVect(0) <= y0;
	ITER_GENERATE: for j in 0 to N_iterations generate

	ZERO_GENERATE: if j=0 generate
		yVect(j) <= y0;
	end generate ZERO_GENERATE;
---------------------------------------------------------------------
	--call iteration once if N_iterations=1
	ONE_GENERATE: if j=1 generate  
		ONE_ITERATION : Iteration 
		generic map(W_WIDTH=>W_bits, F_FRACT=>F_bits) 
		port map(clk	=> clk,
			 x	=> x,
			 y0	=> yVect(j-1),
			 y	=> yVect(j));
	end generate ONE_GENERATE;
---------------------------------------------------------------------
	NUM_GENERATE: if j>1 generate
---------------------------------------------------------------------
		MAP_ITERATION: Iteration
		generic map(W_WIDTH=>W_bits, F_FRACT=>F_bits) 
		port map(clk	=> clk,
			 x	=> xVect(((j-1)*5)-1),
			 y0	=> yVect(j-1),
			 y	=> yVect(j));
---------------------------------------------------------------------	
	end generate NUM_GENERATE;
  	end generate ITER_GENERATE;
	y <= yVect(N_iterations);
end architecture;