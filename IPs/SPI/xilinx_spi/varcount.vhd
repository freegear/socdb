-------------------------------------------------------------------------------- 
-- Copyright (c) 2003 Xilinx, Inc. 
-- All Rights Reserved 
-------------------------------------------------------------------------------- 
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /   Vendor: Xilinx 
-- \   \   \/    Version: 6.1i SP3
--  \   \        Filename: varcount.vhd 
--  /   /        Date Last Modified:  12/15/2003 
-- /___/   /\    Date Created: 12/15/2003 
-- \   \  /  \ 
--  \___\/\___\ 
-- 
--	Device:	Xilinx 
--
--	Library:	IEEE 
--
--	Purpose:	Implements a variable bit width up counter as defined by the
--				generic WIDTH
--
--	Revision History: 
--				Rev 1.0	-Initial Release	JRH
-------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------
--	This software may not be reproduced or transmitted without the
--	written permission of Xilinx Incorporated. Xilinx does not assume
--	any liability arising out of the application or use of its software;
--	nor does it convey any license under its patents, copyrights, or any
--	rights of others. Xilinx reserves the right to make changes, at any
--	time, in order to improve reliability, function, or design and to
--	supply the best product possible.
--	
--	Xilinx assumes no obligation to correct any errors contained herein
--	or to advise any user of this software of any correction if such be
--	made. Xilinx will not assume any liability for the accuracy or
--	correctness of any engineering or software support or assistance
--	provided to a user.
--	
--	Xilinx products and software are not intended for use in life
--	support appliances, devices, or systems. Use of a Xilinx product or
--	software in such applications without the written consent of the
--	appropriate Xilinx officer is prohibited.
--	
--	(c) Copyright 2003 Xilinx, Inc. All rights reserved.
--	------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity varcount is
	generic(WIDTH	: integer);
	port(	cnt_en       : in STD_LOGIC;	-- Count enable
			clr          : in STD_LOGIC;	-- Active low clear
			clk          : in STD_LOGIC;	-- Clock
			qout         : out STD_LOGIC_VECTOR ((WIDTH-1) downto 0)
			);
end varcount;


architecture DEFINITION of varcount is

constant RESET_ACTIVE : std_logic := '0';

signal q_int : UNSIGNED ((WIDTH-1) downto 0);

begin

	process(clk, clr)
	begin
          
		-- Clear output register
		if (clr = RESET_ACTIVE) then
			q_int <= (others => '0');
	       
		-- On rising edge of clock count
		elsif (clk'event) and clk = '1' then
			if cnt_en = '1' then
				q_int <= q_int + 1;
				
			end if;
			
		end if;

	end process;

	qout <= STD_LOGIC_VECTOR(q_int);

end DEFINITION;
  

