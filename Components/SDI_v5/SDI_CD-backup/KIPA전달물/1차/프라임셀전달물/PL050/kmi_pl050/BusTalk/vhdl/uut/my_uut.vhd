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
-- File Name           : my_uut.vhd,v
-- File Revision       : 1.1
-- 
-- Release Information : PL050-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : Dummy APB Slave entity
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

entity my_uut is
  port (

       --  The following signals are compulsory on an APB slave:

        BCLK       : in  std_logic;
        BnRES      : in  std_logic;
        PWRITE     : in  std_logic;
        PSEL       : in  std_logic;
        PENABLE    : in  std_logic;

        --  PADDR and PD size can vary;

        PADDR      : in  std_logic_vector(7 downto 0);   
            
        PWDATA     : in  std_logic_vector(31 downto 0);
        PRDATA     : out std_logic_vector(31 downto 0);

       -- Insert non-AMBA signal declarations (if any) here. The following
       -- are just an example:

       Input00     : in  std_logic;
       Input01     : in  std_logic;
       Input1      : in  std_logic_vector(3 downto 0);
       Output20    : out std_logic;
       Output21    : out std_logic;
       Output3     : out std_logic_vector(7 downto 0)

      ) ;
end  my_uut;

architecture behavioural of my_uut is

 begin
 
end behavioural;

-- --================================= End ===================================--
