--------------------------------------------------------------------------------
-- Copyright 1998 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: alt_cfg.vhd	VAutomation Top level ASIC configuration.
--
-- Revision: $Name: REV9910 $
--
-- Description: 
--	A configuration for the ASIC_IOS entity that determines which
--	peripherals will be included with V8 microprocessor.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: alt_cfg.vhd,v $
-- Revision 1.3  1999/09/17 12:09:07  eric
-- updated with the latest architecture names and removed USB.
--
-- Revision 1.2  1999/04/02 02:10:53  eric
-- remove the jtag master for shipment.
--
-- Revision 1.1  1998/09/17 20:36:40  eric
-- Initial revision
--
--------------------------------------------------------------------------------
CONFIGURATION alt_cfg of a10k240 is
  FOR rtl
    FOR all:asic_v8
      use entity work.asic_v8(rtl);
      FOR rtl
        FOR all:v8_deice
          --use entity work.v8_deice(empty);
          use entity work.v8_deice(basic);
        END FOR;
        FOR all:v1284
          --use entity work.v1284(empty); -- about 1000 gates?
          use entity work.v1284(rtl);
        END FOR;
        FOR all:vtimer
          --use entity work.vtimer(empty);
          use entity work.vtimer(rtl); -- 300 gates
        END FOR;
        FOR all:v8_top
          use entity work.v8_top(rtl);
	  FOR rtl
	    FOR all:v8_regs
	      use entity work.v8_regs(rtl);  -- register based
	      -- use entity work.v8_regs(xilinx); -- uses Xilinx RAMD cell
	    END FOR;
	  END FOR;
        END FOR;
      END FOR;
    END FOR;
  END FOR;
END alt_cfg;
