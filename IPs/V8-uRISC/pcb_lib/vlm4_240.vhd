--------------------------------------------------------------------------------
-- Copyright 1995 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: vlm4_240.vhd
--
-- Description:
--      This file defines the VAutomation quad FPGA logic module.  The logic
--      module contains 4 interconnected PQ240 Xilinx 4000EX devices and their
--      progamming support logic.
--
-- Signals ending in _n are active low.
--
--------------------------------------------------------------------------------
-- Rough Board Layout Diagram
--
--
--
--            ,----------------------------------------------------------.
--          C |                                                          |
--          B |                          J_N                             |
--          A `----------------------------------------------------------'
--            1                                                          32
--  .----.32                                                                .----.
--  |    |          ,--------------.           ,--------------.             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |    U_NW      |           |     U_NE     |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          `--------------'           `--------------'             |    |
--  |    |                                                                  |    |
--  |    |                                                                  |    |
--  |J_W |                                                                  |J_E |
--  |    |          ,--------------.           ,--------------.             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |    U_SW      |           |    U_SE      |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          |              |           |              |             |    |
--  |    |          `--------------'           `--------------'             |    |
--  |    |                                                                  |    |
--  |    |                                                                  |    |
--  |    |                                                                  |    |
--  |    |                                                                  |    |
--  `----'1                                                                 `----'1
--  C B A    .---------.      .---------.      .---------.      .---------. C B A
--           |         | .---.|         | .---.|         | .---.|         | .---.
--  .----.   |  SW_SW  | |L_SW|  SW_NW  | |L_NW|  SW_NE  | |L_NE|  SW_SE  | |L_SE
--  |    |   `---------' `---'`---------' `---'`---------' `---'`---------' `---'
--  |    |   .----------.     .----------.     .----------.     .----------.
--  |J_XC|   |          |     |          |     |          |     |          |
--  |    |   |          |     |          |     |          |     |          |
--  |    |   |          |     |          |     |          |     |          |
--  |    |   | U_PSW1-4 |     | U_PNW1-4 |     | UPNE1-4  |     | UPSE1-4  |
--  `----'1  `----------'     `----------'     `----------'     `----------'
--
--
--

--------------------------------------------------------------------------------
-- This product is licensed to:
-- ÇÑÈ«¼· of ÅÂÀÎ½Ã½ºÅÛ
-- for use at site(s):
-- tsi
--------------------------------------------------------------------------------
-- Revision History
-- $Log: vlm4_240.vhd,v $
-- Revision 1.13  1997/10/24 22:50:12  eric
-- changed from xpq240 to asic_ios.
--
-- Revision 1.12  1997/10/20 09:25:38  chris
-- Corrected Netlist error on NE_DIN and NE_CCLK nets.
-- Note:  This changed and changes after this are not included
--        in the Rev A PCB.
--
-- Revision 1.11  1997/03/21 20:26:35  chris
-- Added 50 and 100MHz oscilators for Fire Wire and USB.
--
-- Revision 1.10 is the revision released to PCB fabrication.
--
-- Revision 1.10  1997/03/13  16:40:28  chris
-- Added nets north_b16, east_b16 and west_b16.
--
-- Revision 1.9  1997/03/13 14:07:26  chris
-- Connected all the tdi and tdo pins to 2 common nets.
--
-- Revision 1.8  1997/02/07 20:22:14  eric
-- fixed the res1206 component declaration.
--
-- Revision 1.7  1997/01/30 16:48:45  chris
-- Corrected resistor value.  Adjusted number of decoupling caps.
--
-- Revision 1.6  1997/01/28 21:18:44  chris
-- Added Comments, Layout diagram and ASCII schematic.
--
-- Revision 1.5  1997/01/28 17:10:40  chris
-- Removed the XChecker programming signals from the port list.
--
-- Revision 1.4  1997/01/23 21:01:32  chris
-- Changed port types on din96 from in to inout.
-- Changed com_clk(1 to 2) to com_clk_a com_clk_b.
--
-- Revision 1.3  1997/01/23 18:55:43  chris
--  Changed the names of the clk pins on the din96 connectors
-- to reflect the connector pin numbers.
--
-- Revision 1.2  1997/01/17 19:57:00  chris
-- Changed all of the reference designators from numeric to North, South, East, West
-- in order to make the netlist more self explainitory.
--
-- Revision 1.1  1997/01/16 19:45:05  chris
-- Initial revision
--
--
--------------------------------------------------------------------------------



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY vlm4_240 IS       -----------------------------ENTITY---------------------
  PORT( sw_ded_clk : INOUT std_logic;        -- dedicated clock inputs one
        nw_ded_clk : INOUT std_logic;        -- for each FPGA
        ne_ded_clk : INOUT std_logic;
        se_ded_clk : INOUT std_logic;
        east_b16   : INOUT std_logic;
        north_b16  : INOUT std_logic;
        west_b16   : INOUT std_logic;
        com_clk_a  : INOUT std_logic;         -- common clocks to all FPGAs
        com_clk_b  : INOUT std_logic;
        east_a     : INOUT std_logic_vector(1 TO 32);
        east_c     : INOUT std_logic_vector(1 TO 32);
        north_a    : INOUT std_logic_vector(1 TO 32);
        north_c    : INOUT std_logic_vector(1 TO 32); -- north_c[1:4] are JTAG
        west_a     : INOUT std_logic_vector(1 TO 32); -- west_a[1:8] are connected only
                                                   -- to USW
        west_c     : INOUT std_logic_vector(1 TO 32) -- west_c[1:8] are connected only
                                                   -- to UNW
--  JTAG signals.  The jtag signals have been mapped onto north_c[1:4]
--        tdi    : in std_logic;   -- north_c(1)
--        tck    : in std_logic;   -- north_c(2)
--        tms    : in std_logic;   -- north_c(3)
--        tdo    : out std_logic;  -- north_c(4)
      );


TYPE string_array IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF CHARACTER;

ATTRIBUTE pin_number: STRING;
ATTRIBUTE array_pin_number:  STRING_ARRAY;

------------------------------------------------------------------------------------
-- The pin number attributes in the logic module entity are just place holders.  The
-- actual pin number can be found in the entity statements of each of the connectors
-- that used on the board.
------------------------------------------------------------------------------------
ATTRIBUTE pin_number OF sw_ded_clk: SIGNAL IS " ";
ATTRIBUTE pin_number OF nw_ded_clk: SIGNAL IS " ";
ATTRIBUTE pin_number OF ne_ded_clk: SIGNAL IS " ";
ATTRIBUTE pin_number OF se_ded_clk: SIGNAL IS " ";

ATTRIBUTE pin_number OF east_b16 : SIGNAL IS " ";
ATTRIBUTE pin_number OF north_b16: SIGNAL IS " ";
ATTRIBUTE pin_number OF west_b16 : SIGNAL IS " ";

ATTRIBUTE pin_number OF com_clk_a: SIGNAL IS " ";
ATTRIBUTE pin_number OF com_clk_b: SIGNAL IS " ";

ATTRIBUTE array_pin_number OF east_a : SIGNAL IS (" "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," "
                                                 );
ATTRIBUTE array_pin_number OF east_c : SIGNAL IS (" "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," "
                                                 );
ATTRIBUTE array_pin_number OF north_a: SIGNAL IS (" "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," "
                                                  );
ATTRIBUTE array_pin_number OF north_c: SIGNAL IS (" "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," "
                                                  );
ATTRIBUTE array_pin_number OF west_a : SIGNAL IS (" "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," "
                                                 );
ATTRIBUTE array_pin_number OF west_c : SIGNAL IS (" "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," ",
                                                  " "," "," "," "," "," "," "," "
                                                 );
-- JTAG Boundary Scan Pins
--ATTRIBUTE pin_number OF tdi     : SIGNAL IS " ";
--ATTRIBUTE pin_number OF tck     : SIGNAL IS " ";
--ATTRIBUTE pin_number OF tms     : SIGNAL IS " ";
--ATTRIBUTE pin_number OF tdo     : SIGNAL IS " ";

END vlm4_240;

ARCHITECTURE struct OF vlm4_240 IS -------------------Architecture -----------
-- This is a structural desription of the logic module PC board.

COMPONENT asic_ios
      PORT (north_b     : INOUT std_logic;
            west_fast_1 : INOUT std_logic;
            west_fast_2 : INOUT std_logic;
            west_fast   : INOUT std_logic_vector(3 to 8);
            west_a      : INOUT std_logic_vector(9 TO 32);
            west_c      : INOUT std_logic_vector(9 TO 32);
            north_a     : INOUT std_logic_vector(1 TO 32);
            north_c     : INOUT std_logic_vector(5 TO 32);
            east_a      : INOUT std_logic_vector(1 TO 32);
            east_c      : INOUT std_logic_vector(1 TO 32);
            lcl_clk     : INOUT std_logic;
            fst_clk     : INOUT std_logic;
            ded_clk     : INOUT std_logic;
            com_clk_a   : INOUT std_logic;
            com_clk_b   : INOUT std_logic;
            m0          : IN    std_logic;
            m1          : IN    std_logic;
            m2          : IN    std_logic;
            init_n      : IN    std_logic;
            done        : IN    std_logic;
            prog_n      : IN    std_logic;
            din         : IN    std_logic;
            dout        : OUT   std_logic;
            cclk        : IN    std_logic;
            tck         : INOUT std_logic;
            tms         : INOUT std_logic;
            tdi         : INOUT std_logic;
            tdo         : INOUT std_logic
            );
END COMPONENT;

COMPONENT din96_lm
  PORT (
        a       : INOUT std_logic_vector(1 TO 32);
        c       : INOUT std_logic_vector(1 TO 32);
        clk_b8  : INOUT std_logic;
        clk_b16 : INOUT std_logic;
        clk_b24 : INOUT std_logic
       );
END COMPONENT;

COMPONENT xc17128
  PORT (data     : INOUT  std_logic;    -- to the First FPGAs DIN pin
        clk      : IN  std_logic;       -- CCLK
        reset_oe : IN  std_logic;       -- PROG_N (reset is active low)
        ce_n     : IN  std_logic;       -- DONE_N
        ceo_n    : OUT std_logic;       -- To the next xc17128 CE_N
        vpp      : IN  std_logic;       -- MUST be connected to VCC!!!
        pwr      : IN  std_logic;
        gnds     : IN  std_logic);
END COMPONENT;

COMPONENT swdip8
  PORT (a1 : IN  std_logic;  -- a1 input
        a2 : IN  std_logic;  -- a2 input
        a3 : IN  std_logic;  -- a3 input
        a4 : IN  std_logic;  -- a4 input
        a5 : IN  std_logic;  -- a5 input
        a6 : IN  std_logic;  -- a6 input
        a7 : IN  std_logic;  -- a7 input
        a8 : IN  std_logic;  -- a8 input
        b1 : IN  std_logic;  -- b1 input
        b2 : IN  std_logic;  -- b2 input
        b3 : IN  std_logic;  -- b3 input
        b4 : IN  std_logic;  -- b4 input
        b5 : IN  std_logic;  -- b5 input
        b6 : IN  std_logic;  -- b6 input
        b7 : IN  std_logic;  -- b7 input
        b8 : IN  std_logic); -- b8 input
END COMPONENT;

COMPONENT  osc
  PORT (osc_out : OUT  std_logic;
        pwr     : IN   std_logic;
        gnds    : IN   std_logic;
        enb     : IN   std_logic);
END COMPONENT;

COMPONENT  osc50
  PORT (osc_out : OUT  std_logic;
        pwr     : IN   std_logic;
        gnds    : IN   std_logic;
        enb     : IN   std_logic);
END COMPONENT;

COMPONENT  osc100
  PORT (osc_out : OUT  std_logic;
        pwr     : IN   std_logic;
        gnds    : IN   std_logic;
        enb     : IN   std_logic);
END COMPONENT;

COMPONENT xtal
  PORT (a : IN  std_logic;  -- a input
        z : OUT std_logic); -- z output
END COMPONENT;

COMPONENT res1206
  PORT (a : IN  std_logic;  -- a input
        z : INOUT std_logic); -- z output
END COMPONENT;

COMPONENT cap_tant
  PORT (plus  : INOUT std_logic;  -- If it's a polarized, cap, then this is the +
        minus : INOUT std_logic);
END COMPONENT;

COMPONENT cap1206
  PORT (plus  : INOUT std_logic;  -- If it's a polarized, cap, then this is the +
        minus : INOUT std_logic);
END COMPONENT;

COMPONENT led
  PORT (anode   : IN  std_logic;
        cathode : IN std_logic);
END COMPONENT;

COMPONENT xchecker
  PORT (power : IN std_logic;
        ground: IN std_logic;
        -- then a space
        cclk    : INOUT std_logic;
        done    : INOUT std_logic; -- labeled D/P       -- be sure to pullup!
        din     : INOUT std_logic;
        prog_n  : INOUT std_logic;      -- be sure to pullup!
        init_n  : INOUT std_logic;      -- be sure to pullup!
        rst     : INOUT std_logic;
        -- second row...
        rt      : INOUT std_logic;
        rd      : INOUT std_logic;
        trig    : INOUT std_logic;
        -- then a space
        tdi     : INOUT std_logic;
        tck     : INOUT std_logic;
        tms     : INOUT std_logic;
        clki    : INOUT std_logic;
        clko    : INOUT std_logic);
END COMPONENT;


SIGNAL vcc,gnd  : std_logic;    -- power planes
signal local    : std_logic_vector(1 TO 6);-- onboard interconnect bus
SIGNAL sw_mode, nw_mode, ne_mode, se_mode : std_logic;
SIGNAL sw_done, nw_done, ne_done, se_done : std_logic;
SIGNAL sw_din,  nw_din,  ne_din,  se_din : std_logic;
SIGNAL sw_dout, nw_dout, ne_dout, se_dout : std_logic;
SIGNAL sw_cclk, nw_cclk, ne_cclk, se_cclk : std_logic;
SIGNAL sw_sdout, nw_sdout, ne_sdout, se_sdout : std_logic;
SIGNAL           nw_init_n, ne_init_n, se_init_n : std_logic;
SIGNAL psw1_ce_n, psw2_ce_n, psw3_ce_n, psw4_ce_n,
       pnw1_ce_n, pnw2_ce_n, pnw3_ce_n, pnw4_ce_n,
       pne1_ce_n, pne2_ce_n, pne3_ce_n, pne4_ce_n,
       pse1_ce_n, pse2_ce_n, pse3_ce_n, pse4_ce_n : std_logic;
SIGNAL            pnw_ceo_n, pne_ceo_n, pse_ceo_n  : std_logic;
SIGNAL sw_lcl_clk, nw_lcl_clk, ne_lcl_clk, se_lcl_clk : std_logic;
SIGNAL sw_done_led, nw_done_led, ne_done_led, se_done_led : std_logic;

SIGNAL xc_cclk    : std_logic;  -- Xchecker cable programming signals
SIGNAL xc_done    : std_logic;
SIGNAL xc_din     : std_logic;
SIGNAL xc_prog_n  : std_logic;
SIGNAL xc_init_n  : std_logic;
SIGNAL xc_reset_n : std_logic;

BEGIN

U_SW: asic_ios
  PORT MAP (north_b     => north_b16,
            west_fast_1 => west_a(1),
            west_fast_2 => west_a(2),
            west_fast   => west_a(3 TO 8),
            west_a      => west_a(9 TO 32),
            west_c      => west_c(9 TO 32),
            north_a     => north_a,
            north_c     => north_c(5 TO 32),
            east_a      => east_a,
            east_c      => east_c,
            lcl_clk     => sw_lcl_clk,
            fst_clk     => sw_ded_clk,
            ded_clk     => sw_ded_clk,
            com_clk_a   => com_clk_a,
            com_clk_b   => com_clk_b,
            m0          => sw_mode,
            m1          => sw_mode,
            m2          => sw_mode,
            init_n      => xc_init_n,
            done        => sw_done,
            prog_n      => xc_prog_n,
            din         => sw_din,
            dout        => sw_dout,
            cclk        => sw_cclk,
            tck         => north_c(2),
            tms         => north_c(3),
            tdi         => north_c(1),
            tdo         => north_c(4)
            );

U_NW: asic_ios
  PORT MAP (north_b     => north_b16,
            west_fast_1 => west_c(1),
            west_fast_2 => west_c(2),
            west_fast   => west_c(3 TO 8),
            west_a      => west_a(9 TO 32),
            west_c      => west_c(9 TO 32),
            north_a     => north_a,
            north_c     => north_c(5 TO 32),
            east_a      => east_a,
            east_c      => east_c,
            lcl_clk     => nw_lcl_clk,
            fst_clk     => nw_ded_clk,
            ded_clk     => nw_ded_clk,
            com_clk_a   => com_clk_a,
            com_clk_b   => com_clk_b,
            m0          => nw_mode,
            m1          => nw_mode,
            m2          => nw_mode,
            init_n      => nw_init_n,
            done        => nw_done,
            prog_n      => xc_prog_n,
            din         => nw_din,
            dout        => nw_dout,
            cclk        => nw_cclk,
            tck         => north_c(2),
            tms         => north_c(3),
            tdi         => north_c(1),
            tdo         => north_c(4)
            );

U_NE: asic_ios
  PORT MAP (north_b     => north_b16,
            west_fast_1 => east_b16,
            west_fast_2 => west_b16,
            west_fast   => local(1 TO 6),
            west_a      => west_a(9 TO 32),
            west_c      => west_c(9 TO 32),
            north_a     => north_a,
            north_c     => north_c(5 TO 32),
            east_a      => east_a,
            east_c      => east_c,
            lcl_clk     => ne_lcl_clk,
            fst_clk     => ne_ded_clk,
            ded_clk     => ne_ded_clk,
            com_clk_a   => com_clk_a,
            com_clk_b   => com_clk_b,
            m0          => ne_mode,
            m1          => ne_mode,
            m2          => ne_mode,
            init_n      => ne_init_n,
            done        => ne_done,
            prog_n      => xc_prog_n,
            din         => ne_din,
            dout        => ne_dout,
            cclk        => ne_cclk,
            tck         => north_c(2),
            tms         => north_c(3),
            tdi         => north_c(1),
            tdo         => north_c(4)
            );

U_SE: asic_ios
  PORT MAP (north_b     => north_b16,
            west_fast_1 => east_b16,
            west_fast_2 => west_b16,
            west_fast   => local(1 TO 6),
            west_a      => west_a(9 TO 32),
            west_c      => west_c(9 TO 32),
            north_a     => north_a,
            north_c     => north_c(5 TO 32),
            east_a      => east_a,
            east_c      => east_c,
            lcl_clk     => se_lcl_clk,
            fst_clk     => se_ded_clk,
            ded_clk     => se_ded_clk,
            com_clk_a   => com_clk_a,
            com_clk_b   => com_clk_b,
            m0          => se_mode,
            m1          => se_mode,
            m2          => se_mode,
            init_n      => se_init_n,
            done        => se_done,
            prog_n      => xc_prog_n,
            din         => se_din,
            dout        => se_dout,
            cclk        => se_cclk,
            tck         => north_c(2),
            tms         => north_c(3),
            tdi         => north_c(1),
            tdo         => north_c(4)
           );

X_SW: osc100
  PORT MAP (osc_out=> sw_lcl_clk,
        pwr=> vcc,
        gnds=> gnd,
        enb=> vcc);
X_NW: osc100
  PORT MAP (osc_out=> nw_lcl_clk,
        pwr=> vcc,
        gnds=> gnd,
        enb=> vcc);
X_NE: osc
  PORT MAP (osc_out=> ne_lcl_clk,
        pwr=> vcc,
        gnds=> gnd,
        enb=> vcc);
X_SE: osc50
  PORT MAP (osc_out=> se_lcl_clk,
        pwr=> vcc,
        gnds=> gnd,
        enb=> vcc);

J_E: din96_lm                            -- connector on the east (right) edge of
  PORT MAP (                             -- the board
            a      => east_a,
            c      => east_c,
            clk_b8 => se_ded_clk,
            clk_b16 => east_b16,
            clk_b24 => ne_ded_clk
            );

J_N: din96_lm                            -- connector on the north (top) edge of
  PORT MAP (                             -- the board
            a      => north_a,
            c      => north_c,
            clk_b8 => com_clk_a,
            clk_b16 => north_b16,
            clk_b24 => com_clk_b
            );

J_W: din96_lm                            -- connector on the west (left) edge of
  PORT MAP (                             -- the board
            a      => west_a,
            c      => west_c,
            clk_b8 => sw_ded_clk,
            clk_b16 => west_b16,
            clk_b24 => nw_ded_clk
            );

------------------------------------------------------------------------------------
-- All of the xilinx devices on the LM can be programmed in slave mode from the
-- xchecker cable.  Using dip switches on the board, any or all of the devices can be
-- swithced out of the serial programming chain, and can be placed in master mode to
-- progam off their own set of serial PROMs.  In addition all 16 proms on the board
-- can be used to program sw, or the PROMs may be broken into 2 groups of 8. Eight
-- to program sw and 8 to program ne.
--
--       Switch Legend SW1, SW2, SW3, SW4:
--
--                Name    OPEN    CLOSED   XCHKR  Lcl Mstr
--                ----    ----    ------   -----  --------
--        1       Mode    Master  Slave    Closed Open
--        2       DONE    Local   Global   Closed Open
--        3       DIN     Local   Chain    Closed Open
--        4       CCLK    Local   Global   Closed Open
--        5       DOUT    OPEN    to Chain Closed Open
--        6       PRM_OE  OPEN    Chain    Closed Open
--        7       PRM_OE  OPEN    Local    Open   Closed
--        8       DOUT    OPEN    ByPass   Open   Closed
--                                                                   VCC
--                                                                    ^
--                                                                    |
--                                                                     /
--                      VCC                                           /sw_1
--                       ^        Previos CE OUT                      |
--                       |                 |                  .---+---+--------Rxx---.
--                      Rxx                |                  |   |   |              |
-- -------.              |                 |                62| 58| 60|              |
--        |a8            |                 |       89,--------'---'---'--------.    GND
--init_n  |--------------+---------------------------|        m[2:0]           |
--        |   Only U_SW                    |         |                         |
--        |   connected to J_XC            |         |      Xilinx  4000EX     |
--        |                                |         |         PQ 240          |
--        |                                |         |         U_xx            |
--        |                                |         |                         |
--        |                                |      122|                         |
--        |    ,-------------------------------------| prog_n                  |
--        |    |                           |         |                         |
--        |    |                           |      179|                         |
--        |    |     ,-------------------------------| cclk                    |
--        |    |     |                     |         |                         |
--        |    |     |                     |      120|                         |
--        |    |     |       ,-----------------------| done                    |
--        |    |     |       |    /sw_7    \ sw_6    |   din          dout     |
--        |    |     |       +---/ --------+\        `-------------------------'
--        |    |     |       |       ,----4'----.      177|          178|
--        |    |     |       |      2|   ce_n   |1        |             | /  sw_5
--        |    |     +-------|-------|clk   data|---------+             `/ --.
--        |    |      /       /      | oe  ceo_n|          /                 |
--        |    |     /sw_4   /sw_2   `----------'         /sw_3              |
--        |a6  |     |       |         3|   6|  U_Pxx1-4  |              /   |
--   din  |-----------------------------------------------+-------------/ ---+------
--        |a4  |     |       |          |    |                        sw_8
--  cclk  |----------+--------------------------------------------------------------
--        |a5  |             |          |    |
--  done  |------------------+------------------------------------------------------
--        |a7  |                        |    |
-- prog_n |----+------------------------+-------------------------------------------
-- -------'                                  |
--J_XC                                       |
--XChecker                              Next CE IN
--Connector                            (SE goes to NE goes to NW goes to SW)
--
--
------------------------------------------------------------------------------------

J_XC: xchecker -- Implement xchecker connector for LM -----------------
  PORT MAP ( -- the xchecker serial programs any of the xilinx devices
        power  => vcc,                   --  in a daisey chain fashion.
        ground => gnd,
        cclk   => xc_cclk,
        done   => xc_done,
        din    => xc_din,
        prog_n => xc_prog_n,
        init_n => xc_init_n,
        rst    => xc_reset_n,   -- ??? probably just resets the Xilinx devices
        rt     => OPEN,
        rd     => OPEN,
        trig   => OPEN,
        tdi    => north_c(1),
        tck    => north_c(2),
        tms    => north_c(3),
        clki   => OPEN,
        clko   => OPEN);

-- Impelment the master programming logic for U_SW

U_PSW1: xc17128
  PORT MAP (
    data     => sw_din,
    clk      => sw_cclk,
    reset_oe => xc_prog_n,
    ce_n     => psw1_ce_n,
    ceo_n    => psw2_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds     => gnd);

U_PSW2: xc17128
  PORT MAP (
    data     => sw_din,
    clk      => sw_cclk,
    reset_oe => xc_prog_n,
    ce_n     => psw2_ce_n,
    ceo_n    => psw3_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds     => gnd);

U_PSW3: xc17128
  PORT MAP (
    data     => sw_din,
    clk      => sw_cclk,
    reset_oe => xc_prog_n,
    ce_n     => psw3_ce_n,
    ceo_n    => psw4_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds     => gnd);

U_PSW4: xc17128
  PORT MAP (
    data     => sw_din,
    clk      => sw_cclk,
    reset_oe => xc_prog_n,
    ce_n     => psw4_ce_n,
    ceo_n    => OPEN,
    vpp      => vcc,
    pwr      => vcc,
    gnds     => gnd);

-- This switch switches U_SW in or out of the xchecker serial programming loop
SW_SW: swdip8
  PORT MAP (
    a1 => sw_mode,  -- Control Xilinx mode (closed = slave, open = master)
    a2 => sw_done,  -- Done switch         (closed for slave)
    a3 => sw_din,   -- Serial data in      (closed for slave)
    a4 => sw_cclk,  -- Programming clock   (closed for slave)
    a5 => sw_dout,  -- data out to next device (closed for slave)
    a6 => psw1_ce_n, -- chip enable for all proms in series (closed for slave)
    a7 => psw1_ce_n, -- chip enable for separate proms (open for slave)
    a8 => xc_din,    -- bypass U_SW           (open for slave)
    b1 => vcc,       -- Connect to mode bits vcc
    b2 => xc_done,   -- Connect to xchecker done
    b3 => xc_din,    -- Connect to xchecker din
    b4 => xc_cclk,   -- Connect to xchecker cclk
    b5 => sw_sdout, -- Serial data to next part
    b6 => pnw_ceo_n, -- Daisey Chain all PROM ce's    
    b7 => sw_done,  -- Separate this bank of 4 PROM's
    b8 => sw_sdout  -- Serial data to next part
   );
L_SW: led -- Implements LED on the done signal
  PORT MAP (
    anode   => sw_done_led,
    cathode => sw_done);

-- Impelment the master programming logic for U_NW

U_PNW1: xc17128
  PORT MAP (
    data     => nw_din,
    clk      => nw_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pnw1_ce_n,
    ceo_n    => pnw2_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds     => gnd);

U_PNW2: xc17128
  PORT MAP (
    data     => nw_din,
    clk      => nw_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pnw2_ce_n,
    ceo_n    => pnw3_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds     => gnd);

U_PNW3: xc17128
  PORT MAP (
    data     => nw_din,
    clk      => nw_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pnw3_ce_n,
    ceo_n    => pnw4_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds     => gnd);

U_PNW4: xc17128
  PORT MAP (
    data     => nw_din,
    clk      => nw_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pnw4_ce_n,
    ceo_n    => pnw_ceo_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds     => gnd);

-- This switch switches U_NW in or out of the xchecker serial programming loop
SW_NW: swdip8
  PORT MAP (
    a1 => nw_mode,  -- Control Xilinx mode (closed = slave, open = master)
    a2 => nw_done,  -- Done switch (closed for slave)
    a3 => nw_din,   -- Serial data in (closed for slave)
    a4 => nw_cclk,  -- Programming clock (closed for slave)
    a5 => nw_dout,  -- data out to next device (closed for slave)
    a6 => pnw1_ce_n, -- chip enable for all proms in series (closed for slave)
    a7 => pnw1_ce_n, -- chip enable for separate proms (open for slave)
    a8 => sw_sdout,  -- bypass U_NW (open for slave)
    b1 => vcc,       -- Connect to mode bits vcc
    b2 => xc_done,   -- Connect to xchecker done
    b3 => sw_sdout,  -- Connect to xchecker din
    b4 => xc_cclk,   -- Connect to xchecker cclk
    b5 => nw_sdout, -- Serial data to next part
    b6 => pne_ceo_n, -- Daisey Chain all PROM ce's    
    b7 => nw_done,  -- Separate this bank of 4 PROM's
    b8 => nw_sdout  -- Serial data to next part
   );

L_NW: led -- Implements LED on the done signal
  PORT MAP (
    anode   => nw_done_led,
    cathode => nw_done);

-- Impelment the master programming logic for nw

U_PNE1: xc17128
  PORT MAP (
    data     => ne_din,
    clk      => ne_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pne1_ce_n,
    ceo_n    => pne2_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds    => gnd);

U_PNE2: xc17128
  PORT MAP (
    data     => ne_din,
    clk      => ne_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pne2_ce_n,
    ceo_n    => pne3_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds    => gnd);

U_PNE3: xc17128
  PORT MAP (
    data     => ne_din,
    clk      => ne_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pne3_ce_n,
    ceo_n    => pne4_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds    => gnd);

U_PNE4: xc17128
  PORT MAP (
    data     => ne_din,
    clk      => ne_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pne4_ce_n,
    ceo_n    => pne_ceo_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds    => gnd);

-- This switch switches ne in or out of the xchecker serial programming loop
SW_NE: swdip8
  PORT MAP (
    a1 => ne_mode,  -- Control Xilinx mode (closed = slave, open = master)
    a2 => ne_done,  -- Done switch (closed for slave)
    a3 => ne_din,   -- Serial data in (closed for slave)
    a4 => ne_cclk,  -- Programming clock (closed for slave)
    a5 => ne_dout,  -- data out to next device (closed for slave)
    a6 => pne1_ce_n,-- chip enable for all proms in series (closed for slave)
    a7 => pne1_ce_n,-- chip enable for separate proms (open for slave)
    a8 => nw_sdout, -- bypass U_NE (open for slave)
    b1 => vcc,      -- Connect to mode bits vcc
    b2 => xc_done,  -- Connect to xchecker done
    b3 => nw_sdout, -- Connect serial data daisey chain
    b4 => xc_cclk,  -- Connect to xchecker cclk
    b5 => ne_sdout, -- Serial data to next part
    b6 => pse_ceo_n,-- Daisey Chain all PROM ce's    
    b7 => ne_done,  -- Separate this bank of 4 PROM's
    b8 => ne_sdout  -- Serial data to next part
   );

L_NE: led -- Implements LED on the done signal
  PORT MAP (
    anode   => ne_done_led,
    cathode => ne_done);

U_PSE1: xc17128
  PORT MAP (
    data     => se_din,
    clk      => se_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pse1_ce_n,
    ceo_n    => pse2_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds    => gnd);

U_PSE2: xc17128
  PORT MAP (
    data     => se_din,
    clk      => se_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pse2_ce_n,
    ceo_n    => pse3_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds    => gnd);

U_PSE3: xc17128
  PORT MAP (
    data     => se_din,
    clk      => se_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pse3_ce_n,
    ceo_n    => pse4_ce_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds    => gnd);

U_PSE4: xc17128
  PORT MAP (
    data     => se_din,
    clk      => se_cclk,
    reset_oe => xc_prog_n,
    ce_n     => pse4_ce_n,
    ceo_n    => pse_ceo_n,
    vpp      => vcc,
    pwr      => vcc,
    gnds     => gnd);

-- This switch switches se in or out of the xchecker serial programming loop
SW_SE: swdip8
  PORT MAP (
    a1 => se_mode,  -- Control Xilinx mode (closed = slave, open = master)
    a2 => se_done,  -- Done switch (closed for slave)
    a3 => se_din,   -- Serial data in (closed for slave)
    a4 => se_cclk,  -- Programming clock (closed for slave)
    a5 => se_dout,  -- data out to next device (closed for slave)
    a6 => pse1_ce_n,-- chip enable for all proms in series (closed for slave)
    a7 => pse1_ce_n,-- chip enable for separate proms (open for slave)
    a8 => ne_sdout, -- bypass U_SE (open for slave)
    b1 => vcc,      -- Connect to mode bits gnd
    b2 => xc_done,  -- Connect to xchecker done
    b3 => ne_sdout, -- Connect to xchecker din
    b4 => xc_cclk,  -- Connect to xchecker cclk
    b5 => se_sdout, -- Serial data to next part
    b6 => se_done,  -- Daisey Chain all PROM ce's    
    b7 => se_done,  -- Separate this bank of 4 PROM's
    b8 => se_sdout);-- Serial data to next part


LSE: led -- Implements LED on the done signal
  PORT MAP (
    anode   => se_done_led,
    cathode => se_done);

r01: res1206 PORT MAP (a => vcc, z => xc_prog_n); -- Implement pull-up on prog_n 5.1k
r02: res1206 PORT MAP (a => vcc, z => xc_done);   -- Implement pull-up on done 5.1k
  

r03: res1206 PORT MAP (a => vcc, z => sw_done_led);-- series R on LED 1.1k
r04: res1206 PORT MAP (a => gnd, z => sw_mode);    -- Implement pull-down on mode 1.1k
r05: res1206 PORT MAP (a => vcc, z => xc_init_n);  -- Implement pull-up on se_init 5.1k

r06: res1206 PORT MAP (a => vcc, z => nw_done_led);-- series R on LED 1.1k
r07: res1206 PORT MAP (a => gnd, z => nw_mode);    -- Implement pull-down on mode 1.1k
r08: res1206 PORT MAP (a => vcc, z => nw_init_n);  -- Implement pull-up on se_init 5.1k

r09: res1206 PORT MAP (a => vcc, z => ne_done_led);-- series R on LED 1.1k
r10: res1206 PORT MAP (a => gnd, z => ne_mode);    -- Implement pull-down on mode 1.1k
r11: res1206 PORT MAP (a => vcc, z => ne_init_n);  -- Implement pull-up on se_init 5.1k

r12: res1206 PORT MAP (a => vcc, z => se_done_led);-- series R on LED 1.1k
r13: res1206 PORT MAP (a => gnd, z => se_mode);    -- Implement pull-down on mode 1.1k
r14: res1206 PORT MAP (a => vcc, z => se_init_n);  -- Implement pull-up on se_init 5.1k

r15: res1206 PORT MAP ( a => vcc, z => xc_reset_n);  -- pullup - 5.1K

-- r16 was removed.

 --  thevin parralel termination for clocks
 --  MUST BE PLACED AT THE END OF SERIALLY ROUTED CLOCK TRACES
 --  NO TEE'S, NO STUBS OVER 0.5in.

r17: res1206 PORT MAP ( a => gnd, z => sw_ded_clk); -- 220
r18: res1206 PORT MAP ( a => vcc, z => sw_ded_clk); -- 330
                                              
r19: res1206 PORT MAP ( a => gnd, z => nw_ded_clk); -- 220
r20: res1206 PORT MAP ( a => vcc, z => nw_ded_clk); -- 330
                                              
r21: res1206 PORT MAP ( a => gnd, z => ne_ded_clk); -- 220
r22: res1206 PORT MAP ( a => vcc, z => ne_ded_clk); -- 330
                                              
r23: res1206 PORT MAP ( a => gnd, z => se_ded_clk); -- 220
r24: res1206 PORT MAP ( a => vcc, z => se_ded_clk); -- 330
                                              
r25: res1206 PORT MAP ( a => gnd, z => com_clk_a); -- 220
r26: res1206 PORT MAP ( a => vcc, z => com_clk_a); -- 330
                                              
r27: res1206 PORT MAP ( a => gnd, z => com_clk_b); -- 220
r28: res1206 PORT MAP ( a => vcc, z => com_clk_b); -- 330

-- decoupling caps
c01 : cap_tant PORT MAP ( minus => gnd, plus => vcc);   -- 22uf
c02 : cap_tant PORT MAP ( minus => gnd, plus => vcc);   -- 22uf
c03 : cap_tant PORT MAP ( minus => gnd, plus => vcc);   -- 22uf
c04 : cap_tant PORT MAP ( minus => gnd, plus => vcc);   -- 22uf
c05: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c06: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c07: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c08: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c09: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c10: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c11: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c12: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c13: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c14: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c15: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c16: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c17: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c18: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c19: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c20: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c21: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c22: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c23: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf
c24: cap1206 PORT MAP (minus=>gnd,      plus=>vcc       );--.1uf

END struct;                              -- architecture
