--------------------------------------------------------------------------------
-- Copyright 1996 VAutomation Inc. Nashua NH ALL RIGHTS RESERVED.
-- This software is provided under license and contains proprietary and
-- confidential material which is the property of VAutomation Inc.
--
-- File: con_pin.vhd
--
-- Description:
--	Model for a connector pin that passes signals bidirectionally.
--

--------------------------------------------------------------------------------
-- Revision History
-- $Log: con_pin.vhd,v $
-- Revision 1.1  1997/10/15 13:17:56  chris
-- Initial revision
--
--
--------------------------------------------------------------------------------
library ieee, std;
use ieee.std_logic_1164.all;

entity con_pin is
  port (pin : inout std_logic:='Z';
        contact : inout std_logic:='Z');
end con_pin;

architecture behavioral of con_pin is

  TYPE std_logic_table IS ARRAY(std_logic, std_logic) OF std_logic;
  
  -------------------------------------------------------------------
  -- tables for logical operations
  -------------------------------------------------------------------

  -- truth table for driving the pin
  CONSTANT dpin_table : std_logic_table := (
  --                      drive_c
  --      ----------------------------------------------------
  --      |  U    X    0    1    Z    W    L    H    -         |   |
  --      ----------------------------------------------------
          ( 'Z', 'Z', 'Z', 'Z', 'U', 'U', 'U', 'U', 'Z' ),  -- | U |
          ( 'Z', 'Z', '1', '0', 'X', 'X', 'X', 'X', 'Z' ),  -- | X |
          ( 'Z', 'Z', 'Z', 'Z', '0', '0', '0', '0', 'Z' ),  -- | 0 |
          ( 'Z', 'Z', 'Z', 'Z', '1', '1', '1', '1', 'Z' ),  -- | 1 |
          ( 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z' ),  -- | Z | c
          ( 'Z', 'Z', 'Z', 'Z', 'W', 'Z', 'H', 'L', 'Z' ),  -- | W |
          ( 'Z', 'Z', 'Z', 'Z', 'L', 'Z', 'Z', 'Z', 'Z' ),  -- | L |
          ( 'Z', 'Z', 'Z', 'Z', 'H', 'Z', 'Z', 'Z', 'Z' ),  -- | H |
          ( 'Z', 'Z', 'Z', 'Z', '-', 'Z', 'Z', 'Z', 'Z' )   -- | - |
  );

  FUNCTION drive_pin  ( c : std_logic; drive_c : std_logic ) RETURN STD_LOGIC IS
        VARIABLE result : STD_LOGIC ;
    BEGIN
        result := (dpin_table(c, drive_c));
        RETURN result ;
    END drive_pin;


  -- truth table for driving the con
  CONSTANT dcon_table : std_logic_table := (
  --                      drive_p
  --      ----------------------------------------------------
  --      |  U    X    0    1    Z    W    L    H    -         |   |
  --      ----------------------------------------------------
          ( 'Z', 'Z', 'Z', 'Z', 'X', 'X', 'X', 'X', 'Z' ),  -- | U |
          ( 'Z', 'Z', '1', '0', 'X', 'X', 'X', 'X', 'Z' ),  -- | X |
          ( 'Z', 'Z', 'Z', 'Z', '0', '0', '0', '0', 'Z' ),  -- | 0 |
          ( 'Z', 'Z', 'Z', 'Z', '1', '1', '1', '1', 'Z' ),  -- | 1 |
          ( 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z', 'Z' ),  -- | Z | p
          ( 'Z', 'Z', 'Z', 'Z', 'W', 'Z', 'H', 'L', 'Z' ),  -- | W |
          ( 'Z', 'Z', 'Z', 'Z', 'L', 'Z', 'Z', 'Z', 'Z' ),  -- | L |
          ( 'Z', 'Z', 'Z', 'Z', 'H', 'Z', 'Z', 'Z', 'Z' ),  -- | H |
          ( 'Z', 'Z', 'Z', 'Z', '-', 'Z', 'Z', 'Z', 'Z' )   -- | - |
  );

  FUNCTION drive_con  ( p : std_logic; drive_p : std_logic ) RETURN std_logic IS
        VARIABLE result : std_logic ;
    BEGIN
        result := (dcon_table(p, drive_p));
        RETURN result ;
    END drive_con;

  SIGNAL drive_contact, drive_pcb_pin : std_logic;
  SIGNAL check_pcb_pin, check_contact : std_logic;

begin

  c1: process (pin, check_pcb_pin)
    variable nxt_drive_contact : std_logic := 'Z';
    begin
      nxt_drive_contact := drive_con(p => pin, drive_p => drive_pcb_pin);
      if ((drive_contact = 'X' AND         -- if transitioning from X to Value
          (nxt_drive_contact = '1' OR nxt_drive_contact = '0')) OR
         (drive_contact = 'W' AND         -- if transitioning from W to Value
          (nxt_drive_contact = 'L' OR nxt_drive_contact = 'H')) OR
          ((drive_contact = '0' OR drive_contact = '1') AND -- if turning connector around
           (nxt_drive_contact = 'H' OR nxt_drive_contact = 'L' OR
            nxt_drive_contact = 'W' OR nxt_drive_contact = 'Z')) OR
          ((drive_contact = 'L' OR drive_contact = 'H') AND -- if turning connector around
            nxt_drive_contact = 'Z')) then
        
        if check_contact = '1' then      -- toggle check contact process trigger
          check_contact <= transport '0' after 1 ns;
        else
          check_contact <= transport '1' after 1 ns;
        end if;               
      end if;
      drive_contact <= nxt_drive_contact;
    end process c1;
    contact <=  drive_contact after 1 ns;
    
  p1: process(contact, check_contact)
    variable nxt_drive_pcb_pin  : std_logic := 'Z';
    begin
      nxt_drive_pcb_pin  := drive_pin(c => contact, drive_c => drive_contact);
      if ((drive_pcb_pin = 'X' AND         -- if transitioning from X to Value
           (nxt_drive_pcb_pin = '1' OR nxt_drive_pcb_pin = '0')) OR
          (drive_pcb_pin = 'W' AND         -- if transitioning from W to Value
           (nxt_drive_pcb_pin = 'L' OR nxt_drive_pcb_pin = 'H')) OR
          ((drive_pcb_pin = '0' OR drive_pcb_pin = '1') AND -- if turning connector around
           (nxt_drive_pcb_pin = 'H' OR nxt_drive_pcb_pin = 'L' OR
            nxt_drive_pcb_pin = 'W' OR nxt_drive_pcb_pin = 'Z')) OR
          ((drive_pcb_pin = 'L' OR drive_pcb_pin = 'H') AND -- if turning connector around
            nxt_drive_pcb_pin = 'Z')) then          
        if check_pcb_pin = '1' then      -- toggle check pcb_pin process trigger
          check_pcb_pin <= transport '0' after 1 ns;
        else
          check_pcb_pin <= transport '1' after 1 ns;
        end if;
      end if;
      drive_pcb_pin <= nxt_drive_pcb_pin;
    end process p1;
    pin <=  drive_pcb_pin after 1 ns;

    
end behavioral;



