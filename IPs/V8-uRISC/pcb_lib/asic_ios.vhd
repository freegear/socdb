--------------------------------------------------------------------------------
-- Copyright 1997 VAutomation Inc. Nashua NH (603) 882-2282 ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: asic_ios.vhd
--
-- Description:
--      This is a shell for a unprogrammed Xilinx 4000EX/XL family part in
--      a 240-pin plastic quad flatpack package.  It defines how the pins
--      of the device are conneted to the board. A null architecture is included
--      in this file.
--
-- Signals ending in _n are active low.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: asic_ios.vhd,v $
-- Revision 1.2  1997/10/24 22:49:15  eric
-- removed references to xpq240.
--
-- Revision 1.1  1997/10/24 22:47:22  eric
-- Initial revision
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY asic_ios IS        --------------------------ENTITY---------------------
      PORT (north_b     : INOUT std_logic := 'Z';
            west_fast_1 : INOUT std_logic := 'Z';
            west_fast_2 : INOUT std_logic := 'Z';
            west_fast   : INOUT std_logic_vector(3 to 8) := (others => 'Z');
            west_a      : INOUT std_logic_vector(9 TO 32) := (others => 'Z');
            west_c      : INOUT std_logic_vector(9 TO 32) := (others => 'Z');
            north_a     : INOUT std_logic_vector(1 TO 32) := (others => 'Z');
            north_c     : INOUT std_logic_vector(5 TO 32) := (others => 'Z');
            east_a      : INOUT std_logic_vector(1 TO 32) := (others => 'Z');
            east_c      : INOUT std_logic_vector(1 TO 32) := (others => 'Z');
            lcl_clk     : INOUT std_logic := 'Z';
            fst_clk     : INOUT std_logic := 'Z';
            ded_clk     : INOUT std_logic := 'Z';
            com_clk_a   : INOUT std_logic := 'Z';
            com_clk_b   : INOUT std_logic := 'Z';
            m0          : IN    std_logic;
            m1          : IN    std_logic;
            m2          : IN    std_logic;
            init_n      : IN    std_logic;
            done        : IN    std_logic;
            prog_n      : IN    std_logic;
            din         : IN    std_logic;
            dout        : OUT   std_logic := 'Z';
            cclk        : IN    std_logic;
            tck         : INOUT std_logic := 'Z';
            tms         : INOUT std_logic := 'Z';
            tdi         : INOUT std_logic := 'Z';
            tdo         : INOUT std_logic := 'Z'
            );

-- Below are the pinout attributes for the Xilinx implementation

TYPE string_array IS ARRAY (NATURAL RANGE <>, NATURAL RANGE <>) OF CHARACTER;

ATTRIBUTE pin_number: STRING;
ATTRIBUTE array_pin_number:  STRING_ARRAY;

ATTRIBUTE package_type: STRING;
ATTRIBUTE package_type OF asic_ios : ENTITY is "X4000@PQ240_PIN1_CORNR_32mmx32mm_050mm";

ATTRIBUTE VCC_pins:  STRING_ARRAY;
ATTRIBUTE GND_pins:  STRING_ARRAY;
ATTRIBUTE VCC_pins OF asic_ios: ENTITY IS ("P19 ","P30 ","P40 ","P61 ",
                                         "P80 ","P90 ","P101","P121",
                                         "P140","P143","P150","P161",
                                         "P180","P201","P212","P222",
                                         "P240");
ATTRIBUTE GND_pins OF asic_ios: ENTITY IS ("P1  ","P14 ","P22 ","P29 ",
                                         "P37 ","P45 ","P59 ","P75 ",
                                         "P83 ","P91 ","P98 ","P106",
                                         "P119","P135","P151","P158",
                                         "P166","P182","P196","P204",
                                         "P211","P219","P227");
-- Xilinx config pins
ATTRIBUTE pin_number OF tdi     : SIGNAL IS "P6";   -- north_c(1)
ATTRIBUTE pin_number OF tck     : SIGNAL IS "P7";   -- north_c(2)
ATTRIBUTE pin_number OF tms     : SIGNAL IS "P17";  -- north_c(3)
ATTRIBUTE pin_number OF tdo     : SIGNAL IS "P87";  -- north_c(4)
-- using pin 181 requires instancing a special xilinx primitive, so we aren't
ATTRIBUTE pin_number OF m1      : SIGNAL IS "P58";
ATTRIBUTE pin_number OF m0      : SIGNAL IS "P60";
ATTRIBUTE pin_number OF m2      : SIGNAL IS "P62";
ATTRIBUTE pin_number OF init_n  : SIGNAL IS "P89";
ATTRIBUTE pin_number OF done    : SIGNAL IS "P120";
ATTRIBUTE pin_number OF prog_n  : SIGNAL IS "P122";
ATTRIBUTE pin_number OF din     : SIGNAL IS "P177";
ATTRIBUTE pin_number OF dout    : SIGNAL IS "P178";
ATTRIBUTE pin_number OF cclk    : SIGNAL IS "P179";
ATTRIBUTE pin_number OF lcl_clk : SIGNAL IS "P63";
ATTRIBUTE pin_number OF ded_clk : SIGNAL IS "P2";
ATTRIBUTE pin_number OF fst_clk : SIGNAL IS "P15";

ATTRIBUTE pin_number OF com_clk_a: SIGNAL is ("P124");
ATTRIBUTE pin_number OF com_clk_b: SIGNAL is ("P184");
ATTRIBUTE pin_number OF north_b  : SIGNAL IS  "P88 ";
ATTRIBUTE pin_number OF west_fast_1  : SIGNAL IS  "P25 ";
ATTRIBUTE pin_number OF west_fast_2  : SIGNAL IS  "P24 ";
ATTRIBUTE array_pin_number OF west_fast : SIGNAL IS
                (
                 "P23 ","P21 ","P20 ","P18 ","P16 ","P13 ");
                 
ATTRIBUTE array_pin_number OF west_a : SIGNAL IS
                (
                 "P86 ","P84 ","P81 ","P78 ","P76 ","P73 ","P71 ","P69 ",
                 "P67 ","P65 ","P57 ","P55 ","P53 ","P51 ","P49 ","P47 ",
                 "P44 ","P42 ","P39 ","P36 ","P34 ","P32 ","P28 ","P26 ");

ATTRIBUTE array_pin_number OF west_c : SIGNAL IS
                (
                 "P92 ","P85 ","P82 ","P79 ","P77 ","P74 ","P72 ","P70 ",
                 "P68 ","P66 ","P64 ","P56 ","P54 ","P52 ","P50 ","P48 ",
                 "P46 ","P43 ","P41 ","P38 ","P35 ","P33 ","P31 ","P27 ");
                 

ATTRIBUTE array_pin_number OF east_a : SIGNAL IS
                (
                 "P94 ","P96 ","P99 ","P102","P104","P107","P109","P111",
                 "P113","P115","P117","P123","P126","P128","P130","P132",
                 "P134","P137","P139","P142","P145","P147","P149","P153",
                 "P155","P157","P160","P163","P165","P168","P170","P172");

ATTRIBUTE array_pin_number OF east_c : SIGNAL IS
                (
                 "P93 ","P95 ","P97 ","P100","P103","P105","P108","P110",
                 "P112","P114","P116","P118","P125","P127","P129","P131",
                 "P133","P136","P138","P141","P144","P146","P148","P152",
                 "P154","P156","P159","P162","P164","P167","P169","P171");

ATTRIBUTE array_pin_number OF north_a : SIGNAL IS
                (
                 "P12 ","P10 ","P11 ","P9  ","P5  ","P3  ","P238","P236",
                 "P234","P232","P230","P228","P225","P223","P220","P217",
                 "P215","P213","P209","P207","P205","P202","P199","P197",
                 "P194","P192","P190","P188","P186","P183","P175","P173");

ATTRIBUTE array_pin_number OF north_c : SIGNAL IS
                (
                 "P8  ","P4  ","P239","P237","P235","P233","P231","P229",
                 "P226","P224","P221","P218","P216","P214","P210","P208",
                 "P206","P203","P200","P198","P195","P193","P191","P189",
                 "P187","P185","P176","P174");

end asic_ios;

architecture empty of asic_ios is -------------------Architecture -----------
-- This is an empty architecture. Create an architecture to implement your
-- application logic in this or another file.

BEGIN

east_a  <= (others => 'Z');
east_c  <= (others => 'Z');
west_a  <= (others => 'Z');
west_c  <= (others => 'Z');
north_a <= (others => 'Z');
north_c <= (others => 'Z');
west_fast_1<= 'Z';
west_fast_2 <= 'Z';
west_fast <= (others => 'Z');
tdi <= 'Z';
tms <= 'Z';
tck <= 'Z';
tck <= 'Z';
ded_clk <= 'Z';
fst_clk <= 'Z';
lcl_clk <= 'Z';
fst_clk <= 'Z';
com_clk_a <= 'Z';
com_clk_b <= 'Z';
north_b <= 'Z';
tdo <= 'Z';
tdi <= 'Z';

END empty;
