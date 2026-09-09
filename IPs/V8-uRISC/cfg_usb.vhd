--------------------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603)882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: cfg_usb.vhd	USB Configuration file.
--
-- Revision: $Name: REV9911b $
--
-- Description: A Package file for the usb core that defines global usb constants
--     that contol how the VUSB core is synthesised.
--
-- Revision History
-- $Log: cfg_usb.vhd,v $
-- Revision 1.15  2000/01/03 16:32:46  chris
-- Removed the HOST_WITHOUT_HUB constant.  This control is now a Endpt0
-- control register bit in up_int.vhd.
--
-- Revision 1.14  1999/11/10 15:25:21  gregg
-- Removed ^M's
--
-- Revision 1.13  1999/11/09 14:13:58  mark
-- ulogicified source - no functional changes
--
-- Revision 1.12  1999/09/13 20:29:33  chris
-- Change type of HOST_WITHOUT_HUB from std_ulogic to integer so that it
-- could be used to initialize a synopsys compatible generic.
--
-- Revision 1.11  1999/09/10 21:55:28  chris
-- Set constant to support Host to Low Speed device thru a hub.
--
-- Revision 1.10  1999/06/24 13:15:38  chris
-- Changed LOW_SPEED_DEV constant to type integer to support generics.
--
-- Revision 1.9  1999/04/02 19:34:26  meyers
-- removed ASIC_IMPLEMENTATION constant
--
-- Revision 1.8  1998/10/19 20:51:50  chris
-- Remove ^M's.  No functional changes.
--
-- Revision 1.7  1998/09/15 14:38:54  chris
-- Added HOST_WITHOUT_HUB constant to support new code in the DPLLNRZI.
--
-- Revision 1.6  1998/03/26 21:10:18  chris
-- Turned host mode back on.
--
-- Revision 1.5  1998/03/14 00:04:24  chris
-- Reverted to device only implementation.
--
-- Revision 1.4  1998/03/13 19:50:00  chris
-- Added revision string.
--
-- Revision 1.3  1998/02/24 15:23:05  chris
-- Enabled implementation of embedded host functions.
--
-- Revision 1.2  1998/02/17 21:12:34  chris
-- Added IMPLEMENT_EMBEDED_HOST constant.
--
-- Revision 1.1  1997/10/31 21:05:23  chris
-- Initial revision
--
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package cfg_usb is

  -- LOW_SPEED_DEVICE is used by the DPLLNRZI module in the testbench
  -- host controller to determine the polarity of the dplus and dminus
  -- signals for the J, K and SE0 USB states.  When set to 1 it
  -- configures the logic as a low speed device:
  --   K state = {dminus low, dplus high}
  --   J state = {dminus high, dplus low}
  -- Note that for a low speed device the input clock (usbclkx4) needs
  -- to be 6MHz.
  --When set to 0 it configures the logic for a high speed device.
  --   K state = {dminus high, dplus low}
  --   J state = {dminus low, dplus high}
  -- Note that for a high speed device the input clock (usbclkx4) needs
  -- to be 48MHz.
  CONSTANT LOW_SPEED_DEV	: integer := 0; -- high speed device
  -- The LOW_SPEED_DEV is separate from the low_speed_en signal that allows 
  -- A full speed host or target to take on the signalling of a low speed
  -- device dynamically.

  -- IMPLEMENT_EMBEDED_HOST is used within the VUSB core in the usb_sie, and the
  -- up_int to automatically allow or remove gates associated with the embeded
  -- host controller function.  When this constant is set to '1' the host
  -- embeded host controller functions are implemented.  When set to '0' this
  -- constant will cause most of the gates associated with the embeded host
  -- functoin to be removed by your synthesizer.
  CONSTANT IMPLEMENT_EMBEDED_HOST : std_ulogic := '0'; -- implement embeded host 

  -- These two constants control the number of endpoints the up_int will
  -- implement.  When set to zero the enpoints won't be implemented.
  -- When set to 1 the enpoints will be implemented.
  CONSTANT EN_EP_CTL_4_7  : std_ulogic := '0'; -- Enables endpoints 4-7
  CONSTANT EN_EP_CTL_8_15 : std_ulogic := '0'; -- Enables endpoints 8-15

  -- This constant is used to enable the DMA controller within the 
  -- uProcessor interface to write the entire BDT back to memory.
  -- Normally the DMA controller will only write back the first two
  -- bytes of the BDT when EN_BDT_4_BYTE_WRITE equals 0. When set to 1 
  -- the DMA controller will write back the entire four bytes of the BDT.
  CONSTANT EN_BDT_4_BYTE_WRITE : std_ulogic := '0';

end cfg_usb;

