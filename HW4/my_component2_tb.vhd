-------------------------------------------------------------------------------
-- Example VHDL Test Bench using File I/O and a clock
-- % Author: Ross K. Snider, Ph.D., Montana State University
-- Jan 18, 2021; 
-------------------------------------------------------------------------------
-- Use the appropriate library packages
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;    -- IEEE standard for digital logic values
use ieee.numeric_std.all;       -- arithmetic functions for vectors
use std.textio.all;             -- Needed for file functions
use ieee.std_logic_textio.all;  -- Needed for std_logic_vector
use work.txt_util.all;
 
-------------------------------------------------------------------------------
-- Entity of this test bench file
-- (It's a blank entity)
------------------------------------------------------------------------------- 
entity my_component2_tb is
   -- nothing here to see, i.e. no signal i/o
end my_component2_tb;
 
 
-------------------------------------------------------------------------------
-- Architecture of this test bench file
-- Note: We don't care the this VHDL is not synthesizable.
------------------------------------------------------------------------------- 
architecture behavioral of my_component2_tb is
 
    -----------------------------------------------------------------------------
    -- Internal Signals
    -----------------------------------------------------------------------------
    constant W_WIDTH : natural := 52;     -- width of input signal for DUT
    constant F_WIDTH : natural := 26;      -- number of fraction bits in input word
    constant ROM_A_W : natural := 6;      -- size of ROM address bus
    constant ROM_Q_W : natural := 28;      -- size of ROM word
    constant ROM_Q_F : natural := 27;      -- number of fraction bits in ROM word
    constant DELAY : natural   := 2;     -- Note:  Actual delay will be two clock cycles longer
    constant clk_half_period : time := 10 ns;  -- clk frequency is 1/(clk_half_period * 2)
    signal clk : std_logic   := '0';  -- clock starts at zero
    signal input_signal_1  : std_logic_vector(W_WIDTH-1 downto 0) := (others => '0');
    signal output_signal_1 : std_logic_vector(W_WIDTH-1 downto 0) := (others => '0');
    signal input_signal_2  : std_logic_vector(ROM_A_W-1 downto 0) := (others => '0');
    signal output_signal_2 : std_logic_vector(ROM_Q_W-1 downto 0) := (others => '0');

    -----------------------------------------------------------------------------
    -- Declaration for Device Under Test Declaration
    -- Declare the component you are testing here 
    -- (e.g. my_component.vhd)
    -----------------------------------------------------------------------------
    component my_component2 is
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
    end component my_component2;
   
begin
    -----------------------------------------------------------------------------
    -- Instantiate the DUT
    -----------------------------------------------------------------------------
    DUT : my_component2
    generic map (
        MY_ROM_A_W => ROM_A_W,
        MY_ROM_Q_W => ROM_Q_W,
        MY_ROM_Q_F => ROM_Q_F,
        MY_WORD_W  => W_WIDTH,
        MY_WORD_F  => F_WIDTH,
        MY_DELAY   => DELAY)
    port map (
        my_clk         => clk,
        my_input       => input_signal_1,
        my_output      => output_signal_1,
        my_rom_address => input_signal_2,
        my_rom_value   => output_signal_2);
 
    -----------------------------------------------------------------------------
    -- Create Clock
    -----------------------------------------------------------------------------
    clk <= not clk after clk_half_period;
 
    ---------------------------------------------------------------------------
    -- File Reading and Writing Process
    ---------------------------------------------------------------------------
    process
        file read_file_pointer1   : text;
        file read_file_pointer2   : text;
        file write_file_pointer1  : text;
        file write_file_pointer2  : text;
        variable line_in1         : line;
        variable line_in2         : line;
        variable line_out1        : line;
        variable line_out2        : line;
        variable input_string1    : string(W_WIDTH downto 1);
        variable input_string2    : string(ROM_A_W downto 1);
        variable input_vector1    : std_logic_vector(W_WIDTH-1 downto 0);
        variable input_vector2    : std_logic_vector(ROM_A_W-1 downto 0);
    begin
        file_open(read_file_pointer1,  "input1.txt",  read_mode);
        file_open(read_file_pointer2,  "input2.txt",  read_mode);
        file_open(write_file_pointer1, "output1.txt", write_mode);
        file_open(write_file_pointer2, "output2.txt", write_mode);
        while not endfile(read_file_pointer1) loop  -- make sure input2.txt is as long as input1.txt
            -- input 1
            readline(read_file_pointer1, line_in1);
            read(line_in1, input_string1);
            input_vector1 := to_std_logic_vector(input_string1);
            report "line in 1 = " & line_in1.all & " value in 1 = " & integer'image(to_integer(unsigned(input_vector1)));
            input_signal_1 <= input_vector1; 
           -- input 2
            readline(read_file_pointer2, line_in2);
            read(line_in2, input_string2);
            input_vector2 := to_std_logic_vector(input_string2);
            report "line in 2 = " & line_in2.all & " value in 2 = " & integer'image(to_integer(unsigned(input_vector2)));
            input_signal_2 <= input_vector2; 
            -- output 1
            write(line_out1, output_signal_1, right, W_WIDTH);
            writeline(write_file_pointer1, line_out1);
            -- output 2
            write(line_out2, output_signal_2, right, ROM_Q_W);
            writeline(write_file_pointer2, line_out2);
            wait until rising_edge(clk);
        end loop; 
        file_close(read_file_pointer1);
        file_close(read_file_pointer2);
        file_close(write_file_pointer1);
        file_close(write_file_pointer2);
        wait;
   end process;
 
end behavioral;