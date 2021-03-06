library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity fxp_rsqrt is
	generic (W_bits : natural;
		F_bits :natural;
		N_iterations :natural);

	port (x : in std_logic_vector(W_bits-1 downto 0);
		y :out std_logic_vector(W_bits-1 downto 0);
		clk : in std_logic);
end entity fxp_rsqrt;

architecture fxp_rsqrtarch of fxp_rsqrt is
component custom is
	generic(W_WIDTH	: natural;
		F_FRACT	: natural);
	port(	clk	: in std_logic;
		x	: in std_logic_vector(W_WIDTH-1 downto 0);
		y	: out std_logic_vector(W_WIDTH-1 downto 0));
	end component;
component Newton is
	generic (W_bits : natural;
		F_bits :natural;
		N_iterations :natural);

	port (x 	: in std_logic_vector(W_bits-1 downto 0);
		y	: out std_logic_vector(W_bits-1 downto 0);
		clk	: in std_logic;
		y0	: in std_logic_vector(W_bits-1 downto 0));
	end component;

signal yNewton			: std_logic_vector(W_bits-1 downto 0);
signal x1,x2,x3,x4,x5,x6,x7,x8	: std_logic_vector(W_bits-1 downto 0);

begin
	y1 : custom generic map(W_WIDTH => W_bits,
		F_FRACT => F_bits)
	port map(clk 	=> clk,
		x	=> x,
		y	=> yNewton);
yn : Newton generic map(W_bits => W_bits,
		F_bits => F_bits,
		N_iterations => N_iterations)
	port map(clk 	=> clk,
		x	=> x8,
		y	=> y,
		y0	=> yNewton);
delay : process(clk)
		begin
			if(rising_edge(clk)) then
				x1 <= x;
				x2 <= x1;
				x3 <= x2;
				x4 <= x3;
				x5 <= x4;
				x6 <= x5;
				x7 <= x6;
				x8 <= x7;
				
			end if;
		end process;

end architecture;