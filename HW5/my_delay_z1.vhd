---------------------------------------------------------------------------
-- Description:  Delay by 1 clock cycle component. 
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

entity my_delay_z1 is
	generic (
		MY_WIDTH : natural);
	port (
		my_clk    : in  std_logic;
		my_input  : in  std_logic_vector(MY_WIDTH-1 downto 0);
		my_output : out std_logic_vector(MY_WIDTH-1 downto 0));
end my_delay_z1;


architecture my_architecture of my_delay_z1 is

begin
    --------------------------------------------------------------
	-- Delay 1 clock cycle (Z^-1 for those versed in DSP)
	-------------------------------------------------------------- 
	my_delay_process : process(my_clk)
	begin
		if rising_edge(my_clk) then
			my_output <= my_input;
		end if;
	end process;
	
end my_architecture;

