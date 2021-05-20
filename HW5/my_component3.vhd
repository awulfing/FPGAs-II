---------------------------------------------------------------------------
-- Description:  Delay component where the delay is specified by the
--               MY_DELAY generic 
--               Used to illustrate the VHDL generate statement
---------------------------------------------------------------------------
-- Author:       Ross K. Snider
-- Company:      Montana State University
-- Create Date:  January 31, 2021
-- Revision:     1.0
---------------------------------------------------------------------------
-- Copyright (c) 2021 Ross K. Snider.
-- All rights reserved. Redistribution and use in source and binary forms 
-- are permitted provided that the above copyright notice and this paragraph 
-- are duplicated in all such forms and that any documentation, advertising 
-- materials, and other materials related to such distribution and use 
-- acknowledge that the software was developed by Montana State University 
-- (MSU).  The name of MSU may not be used to endorse or promote products 
-- derived from this software without specific prior written permission.
-- THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
-- IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;    
use ieee.std_logic_unsigned.all;

entity my_component3 is
	generic (
		MY_WIDTH : natural;
        MY_DELAY : natural);
	port (
		my_clk    : in  std_logic;
		my_input  : in  std_logic_vector(MY_WIDTH-1 downto 0);
		my_output : out std_logic_vector(MY_WIDTH-1 downto 0));
end my_component3;


architecture my_architecture of my_component3 is

	-----------------------------------------------------------------
	-- Component Declaration where component my_delay_z1
    -- delays signal by 1 clock cycle (Z^-1 for those versed in DSP)
	-----------------------------------------------------------------
    component my_delay_z1 
        generic (
            MY_WIDTH : natural);
        port (
            my_clk    : in  std_logic;
            my_input  : in  std_logic_vector(MY_WIDTH-1 downto 0);
            my_output : out std_logic_vector(MY_WIDTH-1 downto 0));
    end component;

begin
 
    ---------------------------------------------------------------
	-- Generate the appropriate number of my_delay_z1 components.
    -- using the generate statement
	--------------------------------------------------------------- 

    ----------------------------------------------
    -- Generate a single component if delay = 1
    -- and connect directly to input and output
    ----------------------------------------------
    gen_z1 : if MY_DELAY = 1 generate   
        delay : my_delay_z1 
        generic map (
            MY_WIDTH => MY_WIDTH)
        port map (
            my_clk         => my_clk,
            my_input       => my_input,   -- connect directly to my_input
            my_output      => my_output); -- connect directly to my_output
    end generate;

    ------------------------------------------------------------------
    -- Generate a two delay components if delay = 2
    -- and connect the input to the input of delay component 1
    -- and connect the output to the output of delay compenent 2
    -- and connect the delay components with the connection vector
    ------------------------------------------------------------------
    gen_z2 : if MY_DELAY = 2 generate
        signal connection_vector : std_logic_vector(MY_WIDTH-1 downto 0);
    begin -- begin statement is needed if you are declaring signals
        delay1 : my_delay_z1 
        generic map (
            MY_WIDTH => MY_WIDTH)
        port map (
            my_clk         => my_clk,
            my_input       => my_input,  -- connect directly to my_input
            my_output      => connection_vector);  -- connection to next delay
        
        delay2 : my_delay_z1 
        generic map (
            MY_WIDTH => MY_WIDTH)
        port map (
            my_clk         => my_clk,
            my_input       => connection_vector,  -- connection to previous delay
            my_output      => my_output); -- connect directly to my_output
    end generate;

    ------------------------------------------------------------------
    -- Generate the delay components if delay is 3 or greater
    -- and connect the input to the input of delay component 1
    -- and connect the output to the output of delay compenent N
    -- and connect the middle delay components with the connection vectors
    ------------------------------------------------------------------
    gen_z3g : if MY_DELAY > 2 generate
        -- create the connection vectors using an array of std_logic_vectors
        type my_connection_array is array (natural range <>) of std_logic_vector(MY_WIDTH-1 downto 0);
        signal connection_vector : my_connection_array(MY_DELAY-2 downto 0);
    begin -- begin statement is needed if you are declaring signals  
        -- generate first delay
        delay1 : my_delay_z1
        generic map (
            MY_WIDTH => MY_WIDTH)
        port map (
            my_clk         => my_clk,
            my_input       => my_input,  -- connect directly to my_input
            my_output      => connection_vector(0)); -- connection to next delay
          
        -- generate the middle delay components
        gen_z_middle : for i in 0 to MY_DELAY-3 generate
            delay_i : my_delay_z1 
            generic map (
                MY_WIDTH => MY_WIDTH)
            port map (
                my_clk         => my_clk,
                my_input       => connection_vector(i),    -- connection to previous delay
                my_output      => connection_vector(i+1)); -- connection to next delay
        end generate;
	  
        -- generate last delay
        delayN : my_delay_z1 
        generic map (
            MY_WIDTH => MY_WIDTH)
        port map (
            my_clk         => my_clk,
            my_input       => connection_vector(MY_DELAY-2), -- connection to previous delay
            my_output      => my_output);  -- connect directly to my_output

    end generate;

end my_architecture;

