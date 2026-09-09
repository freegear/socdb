--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: asic_cfg.vhd	VAutomation Top level ASIC configuration.
--
-- Revision: $Name: REV9911b $
--
-- Description: 
--	A configuration for the ASIC_IOS entity that determines which
--	peripherals will be included with V8 microprocessor.
--
-- Revision History
-- $Log: asic_cfg.vhd,v $
-- Revision 1.9  1998/12/08 18:23:01  chris
-- Made asic_ios default to a JTAG slave w/no timers or parallel port.
--
-- Revision 1.8  1998/09/15 19:37:58  chris
-- Added configuration information to support clk_ctl and the empty usb_hub in asic_v8.vhd
--
-- Revision 1.7  1998/07/14 22:09:56  chris
-- Removed vjtagmas configuration.
--
-- Revision 1.6  1998/04/24 16:01:09  chris
-- Set up for V8 with USB and 1284.  Added comments.
--
-- Revision 1.5  1998/03/13 23:11:44  chris
-- Added Revision name.
--
-- Revision 1.4  1998/03/12 19:34:50  chris
-- Added configuration for Xilinx RAM and V8_DEICE.
--
-- Revision 1.3  1998/01/19 22:54:54  chris
-- Removed vjtag module from the configuration.
--
-- Revision 1.2  1997/12/23 01:13:04  eric
-- changed v8 DPRAM to match the latest...
--
-- Revision 1.1  1997/11/20 15:53:13  chris
-- Initial revision
--
--------------------------------------------------------------------------------
CONFIGURATION asic_cfg of asic_ios is
  FOR asiciov8
    FOR all:asic_v8
      use entity work.asic_v8(synth);
      FOR synth
        FOR uclk_ctl:clk_ctl
          --use entity work.clk_ctl(asic);
          use entity work.clk_ctl(fpga);
        END FOR;
        FOR deice:v8_deice
          -- use entity work.v8_deice(empty);
          use entity work.v8_deice(basic); -- about 2500 gates.
        END FOR;
        FOR pp:v1284
          -- use entity work.v1284(empty); -- about 1000 gates?
          use entity work.v1284(synth);
        END FOR;
        FOR timer:vtimer
          use entity work.vtimer(empty);
          -- use entity work.vtimer(synth); -- 300 gates
        END FOR;
        FOR usb:vusb_top  -- Xilinx implementatoin requires async, 
                          -- hi_perf is cleanest for ASIC
          use entity work.vusb_top(async);   -- 12MHz processor
          -- use entity work.vusb_top(low_pwr); -- 12 +/- 4MHz (DPLL output)
          -- use entity work.vusb_top(hi_perf); -- 48MHz processor
        END FOR;
        FOR all:vusb_hub 
          use entity work.vusb_hub(empty);   -- pass usb signals
          -- use entity work.vusb_hub(synth); -- implement hub
        END FOR;
        FOR cpu:v8_top
          use entity work.v8_top(synth);
	  FOR synth
	    FOR r:v8_regs
	      -- use entity work.v8_regs(synth);  -- register based
	      use entity work.v8_regs(xilinx); -- uses Xilinx RAMD cell
	    END FOR;
	  END FOR;
        END FOR;
      END FOR;
    END FOR;
  END FOR;
END asic_cfg;
