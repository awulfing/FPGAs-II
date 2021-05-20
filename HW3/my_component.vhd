library ieee;
use ieee.std_logic_1164.all;    -- IEEE standard for digital logic values
use ieee.std_logic_unsigned.all;

entity my_component is
	generic (
		MY_WIDTH : natural);
	port (
		my_clk    : in  std_logic;
		my_input  : in  std_logic_vector(MY_WIDTH-1 downto 0);
		my_output : out std_logic_vector(MY_WIDTH-1 downto 0)
	);
end my_component;


architecture my_architecture of my_component is

	-----------------------------------------------
	-- Internal Signals
	-----------------------------------------------
	signal my_result         : std_logic_vector(MY_WIDTH-1 downto 0);
	signal my_delay_signal_1 : std_logic_vector(MY_WIDTH-1 downto 0);
	signal my_delay_signal_2 : std_logic_vector(MY_WIDTH-1 downto 0);

begin
 
    ------------------------------------------------
	-- Computation (simply Add 1)
	------------------------------------------------ 
	my_process : process(my_clk)
	begin
		if rising_edge(my_clk) then
			my_result <= my_input + 1;
		end if;
	end process;
	
    ------------------------------------------------
	-- Delay 3 Additional Clock Cycles
	------------------------------------------------ 
	my_delay_process : process(my_clk)
	begin
		if rising_edge(my_clk) then
            my_delay_signal_1 <= my_result;
			my_delay_signal_2 <= my_delay_signal_1;
			my_output         <= my_delay_signal_2;
		end if;
	end process;

end my_architecture;

