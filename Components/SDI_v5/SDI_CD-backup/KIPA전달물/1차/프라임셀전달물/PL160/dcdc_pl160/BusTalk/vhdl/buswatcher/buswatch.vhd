-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1999 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : buswatch.vhd,v 
-- File Revision       : 1.2 
-- 
-- Release Information : PL160-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : Buswatcher for the APB Slave Test Bench.
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library Std_DevelopersKit;
use     std_developerskit.std_IOpak.all;


library common;
use     common.defs.all;

library buswatcher;
use buswatcher.busw_pck.all;

entity buswatch is
  generic
    (
     PRDATA_mask_str     : string;
     tovpdr          : time;
     tohpdr          : time;
     SuppressOnReset : boolean
    );
  port
    (
     BnRES       : in T_line;
     BCLK        : in std_logic;
     PWRITE      : in T_line;
     PENABLE     : in T_line;
     PRDATA          : in T_data;
     PSEL        : in T_line 
    );  
end buswatch;

architecture behavioural of buswatch is

signal SEL            : std_logic_vector(1 downto 0);
signal PRDATA_mask_bv : bit_vector(31 downto 0);
signal PRDATA_mask    : std_logic_vector(31 downto 0);

begin

  SEL <= PSEL & PWRITE;
  
  PRDATA_mask_bv <= from_hexstring(PRDATA_mask_str);
  PRDATA_mask    <= to_stdlogicvector(PRDATA_mask_bv);
  
-------------------------------------------------------------------------------
--  APB Checking:
--        *  All output timing parameters are controlled
--        *  PRDATA driven to a known value on the falling edge of PENABLE
--        *  PRDATA driven to high impedance on the rising edge of PENABLE (writes)
-------------------------------------------------------------------------------
      
  Check_apbtim : process (PRDATA, BCLK)
        
   begin
 
   ----------------------------------------------------------------------
   --  APB Slave Output Parameters Data Reads
   ----------------------------------------------------------------------

    if PWRITE = '0' and PSEL = '1' and 
       ( BnRES = '1' or SuppressOnReset = FALSE) then
      tim_chk_toh(PRDATA'event, BCLK, BCLK'last_event, rising, Tohpdr, msg_Tohpdr);
      if PENABLE = '1' then
       tim_chk_tov(PRDATA'event, BCLK, BCLK'last_event, rising, Tovpdr, msg_Tovpdr);
      end if;

    end if;
    
  end process Check_apbtim;

  Check_PRDATA_Valid : process(PENABLE)
        
    begin

      if (PENABLE'event and PENABLE = '0') then
--        case SEL is
--            when "00" =>
--             if not(IsZ(PRDATA)) then
--               errhandler("PDZF00: PRDATA not tri-stated on read when UUT not selected",
--                           error);
--             end if;
--            when "01" =>
--             if not(IsZ(PRDATA)) then
--               errhandler("PDZF01: PRDATA not tri-stated on write when UUT not selected",
--                           error);
--             end if;
--            when "10" =>
--             if (IsZ(PRDATA and PRDATA_mask)) then
--               errhandler("PDZF10: PRDATA tri-stated on falling edge of PENABLE during read",
--                     error);
--             end if;
--            when "11" =>
--             if not(IsZ(PRDATA)) then
--               errhandler("PDZF11: PRDATA not tri-stated on falling edge of PENABLE during write",
--                     error);
--             end if;
--            when others => null;
--          end case;
      elsif (PENABLE'event and PENABLE = '1') then
--        case SEL is
--            when "00" =>
--             if not(IsZ(PRDATA)) then
--               errhandler("PDZR00: PRDATA not tri-stated on read when UUT not selected",
--                           error);
--             end if;
--            when "01" =>
--             if not(IsZ(PRDATA)) then
--               errhandler("PDZR01: PRDATA not tri-stated on write when UUT not selected",
--                           error);
--             end if;
--            when "10" =>
--             if not(IsZ(PRDATA)) then
----               errhandler("PDZR10: PRDATA not tri-stated on rising edge of PENABLE during read",
----                   error);
--             end if;
--            when "11" =>
--             if not(IsZ(PRDATA)) then
----               errhandler("PDZR11: PRDATA not tri-stated on rising edge of PENABLE during write",
----                     error);
--             end if;
--            when others => null;
--          end case;
      end if;

  end process Check_PRDATA_Valid ;

end behavioural;

-- --================================= End ===================================--
 
