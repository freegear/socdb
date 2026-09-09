-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1998 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : buswatch.vhd,v 
-- File Revision       : 1.3 
-- 
-- Release Information : PL050-REL1v1 
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
     PRDATA_mask_str : string;
     tovpdr          : time;
     tohpdr          : time;
     SuppressOnReset : boolean;
     Mesg_enb        : boolean
    );
  port
    (
     BnRES       : in T_line;
     BCLK        : in std_logic;
     PWRITE      : in T_line;
     PENABLE     : in T_line;
     PRDATA      : in T_data;
     PSEL        : in T_line 
    );  
end buswatch;

architecture behavioural of buswatch is

signal Res_sig        : std_logic := '0';
signal Res_stored     : std_logic;
constant ZERO         : std_logic_vector(31 downto 0) 
                        := "00000000000000000000000000000000" ;

begin

  -- The Res_sig flag is set to '1' after a low to high transition on
  -- the BnRES signal has been seen. 'X' and 'Z' checking on the PRDATA
  -- lines is done only after this flag has been set to '1'.
  Res_store : process (BnRES)
  begin
    Res_stored <= BnRES;
    if (BnRES'event and BnRES = '1' and Res_stored = '0') then
      Res_sig <= '1';
    end if;
  end process Res_store; 
    
-------------------------------------------------------------------------------
--  APB Checking:
--        *  All output timing parameters are controlled
--        *  PRDATA never driven to an unknown value
--        *  PRDATA driven to zero when UUT not selected
-------------------------------------------------------------------------------
      
  Check_apbtim : process (PRDATA, BCLK)
  begin
 
   ----------------------------------------------------------------------
   --  APB Slave Output Parameters Data Reads
   ----------------------------------------------------------------------

    if PWRITE = '0' and PSEL = '1' and 
       ( BnRES = '1' or SuppressOnReset = FALSE) then
      tim_chk_toh(PRDATA'event, BCLK, BCLK'last_event, rising, Tohpdr,
                  msg_Tohpdr);
      if PENABLE = '1' then
        tim_chk_tov(PRDATA'event, BCLK, BCLK'last_event, rising, Tovpdr,
                    msg_Tovpdr);
      end if;
    end if;
  end process Check_apbtim;

  -- This process checks whether the PRDATA has been driven to zero
  -- after the UUT is de-selected. Note that checks are being made only
  -- on clock edges to avoid false warnings being flagged in netlist 
  -- simulations. The "Mesg_enb" generic enables or disables flagging of
  -- error messages if this check fails. This generic will have to be 
  -- set to FALSE in testbenches which include more than one APB slave.
  
  Check_PRDATA_Zero : process(BCLK)
  begin
    if ( Mesg_enb and PSEL /= '1' and PRDATA /= ZERO) then
      if (BCLK'event and BCLK = '1' ) then
        errhandler("PDR0: PRDATA non-zero on rising BCLK when UUT not selected",
                   error);
      elsif (BCLK'event and BCLK = '0') then
       errhandler("PDF0: PRDATA non-zero on falling BCLK when UUT not selected",
                  error);
      end if;
    end if;
  end process Check_PRDATA_Zero;

  -- Commence 'X' and 'Z' checking on the PRDATA lines once the 
  -- bus reset has been deactivated following an assertion.
  Check_PRDATA_XZ : process(PRDATA)
  begin
    if (Res_sig = '1') then
      X_chk (PRDATA, "PDXZ: PRDATA unknown");
    end if;
  end process Check_PRDATA_XZ;

 end behavioural;

 -- --================================= End ===================================--
 
