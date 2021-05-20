library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity custom is
	generic(W_WIDTH	: natural;
		F_FRACT	: natural);
	port(clk	: in std_logic;
		x	: in std_logic_vector(W_WIDTH-1 downto 0);
		y	: out std_logic_vector(W_WIDTH-1 downto 0));
	end entity;

architecture custom_arch of custom is
	signal Z	: std_logic_vector(4 downto 0);
	signal beta,z1,z2,z3,z4,z5 	: signed(5 downto 0);
	signal alpha	: signed(5 downto 0);
	signal xalpha,y1,y2	: unsigned(W_WIDTH-1 downto 0);
	signal xbeta	: unsigned(W_WIDTH-1 downto 0);
	signal actuallookup	: unsigned(W_WIDTH-1 downto 0);
	signal x1, x2, x3	: unsigned(W_WIDTH-1 downto 0);
	signal lookup_temp	: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal num     : unsigned(7 downto 0) := "01011010" ;
	signal yeven	: unsigned(W_WIDTH+W_WIDTH-1 downto 0);
	signal yodd	: unsigned(W_WIDTH+W_WIDTH+8-1 downto 0);

	component lzc is
    	port (
        clk        : in  std_logic;
        lzc_vector : in  std_logic_vector (23 downto 0);
        lzc_count  : out std_logic_vector ( 4 downto 0)
    	);
	end component;
	
	component ROM IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	end component;

	begin
	lerom : ROM port map(address => STD_LOGIC_VECTOR(xbeta(14 DOWNTO 7)), clock => clk, q => lookup_temp);
	-- #1	----------------------------------------------------------------------------
	L : lzc port map(clk => clk, lzc_vector => x, lzc_count => Z);
	
	-- #2	----------------------------------------------------------------------------
	Beta_process :process(clk)
		begin
			if(rising_edge(clk)) then
				beta <= to_signed(W_WIDTH,beta'length)-to_signed(F_FRACT, beta'length)-signed(Z)-1;
			end if;
	end process;
	-- #3	----------------------------------------------------------------------------
	
	alpha_process : process(clk)
		begin
			if(rising_edge(clk)) then
				if (beta(0) = '1') then
					--o
					alpha <= shift_right(signed(beta),1)-shift_left(signed(beta),1)+1 ;
				else
					alpha <= shift_right(signed(beta),1)-shift_left(signed(beta),1) ;
				end if;
			end if;
	end process;
	-- #4	----------------------------------------------------------------------------
	alphaShift : process(clk)
		begin
			if(rising_edge(clk)) then
				xalpha <= shift_left(unsigned(x3), to_integer(alpha));
			end if;
	end process;
	-- #5	----------------------------------------------------------------------------
	betaShift : process(clk)
		begin
			if(rising_edge(clk)) then
				xbeta <= shift_right(unsigned(x2), to_integer(beta));
			end if;
	end process;
	-- #6	----------------------------------------------------------------------------
	lookup : process(clk)
		begin
			if(rising_edge(clk)) then
				actuallookup <= "00000000" & unsigned(lookup_temp)& "00000000";
			end if;
	end process;
	-- #7	----------------------------------------------------------------------------
	FINALPROCESS : process(clk)
		begin
			if(rising_edge(clk)) then
				if (z4(0) = '1') then
					yodd <= y2 * actuallookup * num;
				else
					yeven <= y2 * actuallookup;
				end if;
		       
			end if;
	end process;
	process(clk)
		begin
			if(rising_edge(clk)) then
				if(z5(0) = '1') then
					y <= std_logic_vector(yodd(45 downto 22));
				else
					y <= std_logic_vector(yeven(38 downto 15));
				end if;
			end if;
	end process;
	--	----------------------------------------------------------------------------
	delay : process(clk)
		begin
			if(rising_edge(clk)) then
				x1 <= unsigned(x);
				x2 <= x1;
				x3 <= x2;
			end if;
		end process;

	delayRound2 : process(clk)
		begin
			if(rising_edge(clk)) then
				y1 <= xalpha;
				y2 <= y1;
			end if;
		end process;
	delayRound3 : process(clk)
		begin
			if(rising_edge(clk)) then
				z1 <= beta;
				z2 <= z1;
				z3 <= z2;
				z4 <= z3;
				z5 <= z4;
			end if;
		end process;
end architecture;