--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: xil_cfg.vhd	VAutomation Top level ASIC configuration.
--
-- Revision: $Name: REV9911b $
--
-- Description: 
--	A configuration for the xil240hq entity that determines which
--	peripherals will be included with V8 microprocessor.
--
--------------------------------------------------------------------------------
-- Revision History
-- $Log: xil_cfg.vhd,v $
-- Revision 1.3  1998/09/15 19:47:36  chris
-- Added JTAG slave to the default build for VUSB and VUSB_HST FPGA synthesis.
--
-- Revision 1.2  1998/07/16 04:03:08  gregg
-- Removed vjtagmas
--
-- Revision 1.1  1998/06/10 13:03:30  chris
-- Initial revision
--
--------------------------------------------------------------------------------
CONFIGURATION xil_cfg of xil240hq is
  FOR struct
    FOR all:asic_v8
      use entity work.asic_v8(synth);
      FOR synth
        FOR uclk_ctl:clk_ctl
          --use entity work.clk_ctl(asic);
          use entity work.clk_ctl(fpga);
        END FOR;
        FOR deice:v8_deice
          -- use entity work.v8_deice(empty);
          use entity work.v8_deice(basic);
        END FOR;
        FOR pp:v1284
          -- use entity work.v1284(empty); -- about 1000 gates?
          use entity work.v1284(synth);
        END FOR;
        FOR timer:vtimer
          use entity work.vtimer(empty);
          -- use entity work.vtimer(synth); -- 300 gates
        END FOR;
        FOR usb:vusb_top  -- Xilinx implementation requires async, 
                          -- sync is cleanest for ASIC
          use entity work.vusb_top(async);   -- asynchronous processor
          -- use entity work.vusb_top(sync); -- synchronous processor
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
    END FOR; -- struct
  END FOR;
END xil_cfg;
