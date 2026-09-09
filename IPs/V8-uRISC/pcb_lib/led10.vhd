--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and 
-- confidential material which is the property of VAutomation Inc.
--
-- File: led10.vhd
--
-- Description: 
--	Entity for 10 position LED bar graph
--	For PCB generation use only.
--
--                |\  |
--                | \ |
--        An -----|  >|---->Cn
--                | / |
--                |/  |

--------------------------------------------------------------------------------
-- Revision History
-- $Log: led10.vhd,v $
-- Revision 1.1  1996/11/11 19:50:21  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity led10 is
  port (a1   : inout std_logic:='Z';
        a2   : inout std_logic:='Z';
        a3   : inout std_logic:='Z';
        a4   : inout std_logic:='Z';
        a5   : inout std_logic:='Z';
        a6   : inout std_logic:='Z';
        a7   : inout std_logic:='Z';
        a8   : inout std_logic:='Z';
        a9   : inout std_logic:='Z';
        a10  : inout std_logic:='Z';
        c1   : inout std_logic:='Z';
        c2   : inout std_logic:='Z';
        c3   : inout std_logic:='Z';
        c4   : inout std_logic:='Z';
        c5   : inout std_logic:='Z';
        c6   : inout std_logic:='Z';
        c7   : inout std_logic:='Z';
        c8   : inout std_logic:='Z';
        c9   : inout std_logic:='Z';
        c10  : inout std_logic:='Z');
attribute PIN_NUMBER : string;
attribute PIN_NUMBER of a1 : SIGNAL is "1";
attribute PIN_NUMBER of a2 : SIGNAL is "2";
attribute PIN_NUMBER of a3 : SIGNAL is "3";
attribute PIN_NUMBER of a4 : SIGNAL is "4";
attribute PIN_NUMBER of a5 : SIGNAL is "5";
attribute PIN_NUMBER of a6 : SIGNAL is "6";
attribute PIN_NUMBER of a7 : SIGNAL is "7";
attribute PIN_NUMBER of a8 : SIGNAL is "8";
attribute PIN_NUMBER of a9 : SIGNAL is "9";
attribute PIN_NUMBER of a10: SIGNAL is "10";
attribute PIN_NUMBER of c10: SIGNAL is "11";
attribute PIN_NUMBER of c9 : SIGNAL is "12";
attribute PIN_NUMBER of c8 : SIGNAL is "13";
attribute PIN_NUMBER of c7 : SIGNAL is "14";
attribute PIN_NUMBER of c6 : SIGNAL is "15";
attribute PIN_NUMBER of c5 : SIGNAL is "16";
attribute PIN_NUMBER of c4 : SIGNAL is "17";
attribute PIN_NUMBER of c3 : SIGNAL is "18";
attribute PIN_NUMBER of c2 : SIGNAL is "19";
attribute PIN_NUMBER of c1 : SIGNAL is "20";
attribute package_type : string;
attribute package_type of led10 : ENTITY is "LED10@DIP20";
end led10;

architecture behavioral of led10 is

begin
-- Empty
end behavioral;
