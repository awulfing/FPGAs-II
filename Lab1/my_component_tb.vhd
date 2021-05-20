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
entity my_component_tb is
   -- nothing here to see, i.e. no signal i/o
end my_component_tb;
 
 
-------------------------------------------------------------------------------
-- Architecture of this test bench file
-- Note: We don't care the this VHDL is not synthesizable.
------------------------------------------------------------------------------- 
architecture behavioral of my_component_tb is
 
    -----------------------------------------------------------------------------
    -- Internal Signals
    -----------------------------------------------------------------------------
    constant W_WIDTH : natural := 34;     -- width of input signal for DUT
    constant clk_half_period : time := 10 ns;  -- clk frequency is 1/(clk_half_period * 2)
    signal clk : std_logic   := '0';  -- clock starts at zero
    signal input_signal  : std_logic_vector(W_WIDTH-1 downto 0) := (others => '0');
    signal output_signal : std_logic_vector(W_WIDTH-1 downto 0) := (others => '0');

    function to_std_logic_vector(s: string) return std_logic_vector is
        variable slv: std_logic_vector(s'high-s'low downto 0);
        variable k: integer;
    begin
        k := s'high-s'low;
        for i in s'range loop
            slv(k) := to_std_logic(s(i));
            k := k - 1;
        end loop;
        return slv;
    end to_std_logic_vector;


    -----------------------------------------------------------------------------
    -- Declaration for Device Under Test Declaration
    -- Declare the component you are testing here 
    -- (e.g. my_component.vhd)
    -----------------------------------------------------------------------------
    component my_component is
       generic (
            MY_WIDTH : natural);
        port (
            my_clk    : in  std_logic;
            my_input  : in  std_logic_vector(MY_WIDTH-1 downto 0);
            my_output : out std_logic_vector(MY_WIDTH-1 downto 0)
      );
    end component my_component;

   
begin
    -----------------------------------------------------------------------------
    -- Instantiate the DUT
    -----------------------------------------------------------------------------
    DUT : my_component
    generic map (
        MY_WIDTH => W_WIDTH)
    port map (
        my_clk    => clk,
        my_input  => input_signal,
        my_output => output_signal
    );
 
    -----------------------------------------------------------------------------
    -- Create Clock
    -----------------------------------------------------------------------------
    clk <= not clk after clk_half_period;
 


    ---------------------------------------------------------------------------
    -- File Reading and Writing Process
    ---------------------------------------------------------------------------
    process
        file read_file_pointer   : text;
        file write_file_pointer  : text;
        variable line_in         : line;
        variable line_out        : line;
        variable input_string    : string(W_WIDTH downto 1);
        variable input_vector    : std_logic_vector(W_WIDTH-1 downto 0);
        --variable input_variable  : std_logic_vector(W_WIDTH-1 downto 0);
    begin
        file_open(read_file_pointer,  "input.txt",  read_mode);
        file_open(write_file_pointer, "output.txt", write_mode);
        while not endfile(read_file_pointer) loop
            readline(read_file_pointer, line_in);
            read(line_in, input_string);
            input_vector := to_std_logic_vector(input_string);
            report "line in = " & line_in.all & " value in = " & integer'image(to_integer(unsigned(input_vector)));
            input_signal <= input_vector; 
            write(line_out, output_signal, right, W_WIDTH);
            writeline(write_file_pointer, line_out);
            wait until rising_edge(clk);
        end loop; 
        file_close(read_file_pointer);
        file_close(write_file_pointer);
        wait;
   end process;
 
end behavioral;