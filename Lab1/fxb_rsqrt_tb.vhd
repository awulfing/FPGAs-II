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
entity fxb_rsqrt_tb is
   -- nothing here to see, i.e. no signal i/o
end fxb_rsqrt_tb;
 
 
-------------------------------------------------------------------------------
-- Architecture of this test bench file
-- Note: We don't care the this VHDL is not synthesizable.
------------------------------------------------------------------------------- 

architecture fxb_rsqrt_tb_arch of fxb_rsqrt_tb is
	constant W_WIDTH : natural := 24;
	constant F_FRACT : natural := 15;
	constant N_TIMES : natural := 5;
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

component fxp_rsqrt is
	generic (W_bits : natural;
		F_bits : natural;
		N_iterations : natural);
	port (x : in std_logic_vector(W_bits-1 downto 0);
		y :out std_logic_vector(W_bits-1 downto 0);
		clk : in std_logic);
end component fxp_rsqrt;

begin
    -----------------------------------------------------------------------------
    -- Instantiate the DUT
    -----------------------------------------------------------------------------
    DUT : fxp_rsqrt
    generic map (
        W_bits => W_WIDTH,
	F_bits	=> F_FRACT,
	N_iterations => N_TIMES)
	
	
    port map (
        clk    => clk,
        x  => input_signal,
        y => output_signal
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
end architecture;
	