--*******************************************************************--
-- Copyright (c) 2001-2003  Evatronix SA                             --
--*******************************************************************--
-- Please review the terms of the license agreement before using     --
-- this file. If you are not an authorized user, please destroy this --
-- source code file and notify Evatronix SA immediately that you     --
-- inadvertently received an unauthorized copy.                      --
--*******************************************************************--

-----------------------------------------------------------------------
-- Project name         : MAC-1G AMBA
-- Project description  : Gigabit Ethernet Media Access Controller
--
-- File name            : tris.vhd
-- File contents        : Entity TRIS
--                        Architecture SIM of TRIS
-- Purpose              : Tristate buffer for MAC
--
-- Destination library  : MAC_1G_AMBA_LIB
-- Dependencies         : IEEE.STD_LOGIC_1164
--
-- Design Engineer      : T.K.
-- Quality Engineer     : M.B.
-- Version              : 2.00.E00
-- Last modification    : 2003-11-27
-----------------------------------------------------------------------

--*******************************************************************--
-- Modifications with respect to Version 2.00.E00:
--*******************************************************************--

library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  
  
  entity TRIS is
    port (
           -- input port
           inp          : in    STD_LOGIC;
           -- output enable
           enable       : in    STD_LOGIC;
           -- output port
           outp         : out   STD_LOGIC;
           -- tristate input / output port
           io           : inout STD_LOGIC
         );
  end TRIS;

--*******************************************************************--
  architecture SIM of TRIS is
  begin  
    -------------------------------------------------------------------
    -- io driver
    -------------------------------------------------------------------
    io_drv:
      io <= inp when enable='1' else 'Z';
    
    -------------------------------------------------------------------
    -- output driver
    -------------------------------------------------------------------
    outp_drv:
      outp <= io;
  end SIM;
--*******************************************************************--
