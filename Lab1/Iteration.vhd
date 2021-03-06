library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Iteration is
	generic(W_WIDTH	: natural;
		F_FRACT	: natural);
	port(	clk	: in std_logic;
		x	: in std_logic_vector(W_WIDTH-1 downto 0);
		y	: out std_logic_vector(W_WIDTH-1 downto 0);
		y0	: in std_logic_vector(W_WIDTH-1 downto 0));
	end entity;

architecture Iteration_arch of Iteration is

signal temp1		:	unsigned(W_WIDTH*2-1 downto 0);
signal temp2, temp3	:	unsigned(W_WIDTH*3-1 downto 0);
signal three		:	unsigned(W_WIDTH*3-1 downto 0):= "000000000000000000000000011000000000000000000000000000000000000000000000";
signal temp4,final	:	unsigned(W_WIDTH*4-1 downto 0);
signal x1, y1, y2, y3	:	unsigned(W_WIDTH-1 downto 0);


begin
	process(clk)
		begin
			if(rising_edge(clk)) then
				temp1 <= unsigned(y0)*unsigned(y0);
				temp2 <= x1*temp1;
				temp3 <= three - temp2;
				temp4 <= y3*temp3;
				final <= shift_right(temp4,1);
			end if;
	end process;	

delay : process(clk)
		begin
			if(rising_edge(clk)) then
				x1 <= unsigned(x);
				y1 <= unsigned(y0);
				y2 <= y1;
				y3 <= y2;

			end if;
		end process;
	y <= std_logic_vector(final(68 downto 45));
	
end architecture;
