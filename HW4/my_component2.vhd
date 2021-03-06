library ieee;
use ieee.std_logic_1164.all;    -- IEEE standard for digital logic values
use ieee.std_logic_unsigned.all;

entity my_component2 is
	generic (
        MY_ROM_A_W : natural;
        MY_ROM_Q_W    : natural;
        MY_ROM_Q_F    : natural;
		MY_WORD_W     : natural;
        MY_WORD_F     : natural;
		MY_DELAY      : natural);  -- Note:  Actual delay will be two clock cycles longer
	port (
		my_clk         : in  std_logic;
        my_rom_address : in  std_logic_vector(MY_ROM_A_W-1 downto 0);
		my_input       : in  std_logic_vector(MY_WORD_W-1 downto 0);
        my_rom_value   : out  std_logic_vector(MY_ROM_Q_W-1 downto 0);
		my_output      : out std_logic_vector(MY_WORD_W-1 downto 0));
end my_component2;


architecture my_architecture of my_component2 is

	-----------------------------------------------
	-- Declarations
	-----------------------------------------------
component ROM IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (27 DOWNTO 0)
	);
END component;

	-----------------------------------------------
	-- Internal Signals
	-----------------------------------------------
    signal my_input_delayed : std_logic_vector(MY_WORD_W-1 downto 0);
    signal rom_value        : std_logic_vector(MY_ROM_Q_W-1 downto 0);
	signal my_result        : std_logic_vector(MY_WORD_W+MY_ROM_Q_W-1 downto 0);

    -- delay array
    type my_vector_array is array (natural range <>) of std_logic_vector(MY_WORD_W-1 downto 0);
    signal delay_vector : my_vector_array(MY_DELAY downto 0);
begin
 
    ------------------------------------------------
	-- Instantiate ROM
	------------------------------------------------ 
    ROM_inst : ROM PORT MAP (
		address	 => my_rom_address,
		clock	 => my_clk,
		q	     => rom_value);

    my_rom_value <= rom_value;  

    ------------------------------------------------
	-- Delay input signal
	------------------------------------------------ 
	my_delay_process : process(my_clk)
	begin
		if rising_edge(my_clk) then
            delay_vector(0) <= my_input;
            for i in 0 to MY_DELAY-1 loop
                delay_vector(i+1) <= delay_vector(i);
            end loop;
            my_input_delayed <= delay_vector(MY_DELAY);
		end if;
	end process;

    ------------------------------------------------
	-- Computation 
	------------------------------------------------ 
	my_process : process(my_clk)
	begin
		if rising_edge(my_clk) then
			my_result <= my_input_delayed * rom_value;
		end if;
	end process;
	
    ------------------------------------------------------
	-- Make the output have the same W and F as the input
    -- Keep the binary point centered in the output word
	------------------------------------------------------
    my_output <= my_result(MY_WORD_W + MY_ROM_Q_F - 1 downto MY_ROM_Q_F);


end my_architecture;

