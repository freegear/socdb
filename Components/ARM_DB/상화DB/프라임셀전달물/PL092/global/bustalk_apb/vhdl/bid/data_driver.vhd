-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : data_driver.vhd.rca 
-- File Revision       : 1.1
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v3 
-- 
-- ---------------------------------------------------------------------
-- Purpose : 
--           To drive internal information onto the APB with timing
--           associated with the data bus
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;

library common;
use     common.defs.all;
use     common.funcs.all;

entity data_driver is
  generic (
           Verbosity      : boolean;
           HaltOnMismatch : boolean;
           tclkh          : time;
           tispdw         : time;
           tihpdw         : time
          );
  port(
       PCLK       : in std_logic;
       data_sel   : in T_d_drv_sel;
       apb_packet : in T_apb;
       postatI    : in std_logic;
       postatO    : out std_logic;
       PENABLE    : in T_line;
       rdata_bus  : in  T_data;
       wdata_bus  : out T_data
       );
end data_driver;

architecture behavioural of data_driver is

  constant ONE     : std_logic_vector(31 downto 0) 
                    := "00000000000000000000000000000001";
  signal count     : std_logic_vector(31 downto 0) := (others => '0');
  signal nextcount : std_logic_vector(31 downto 0) := (others => '0');
  signal countflag : boolean := TRUE; 
  signal d_sel     : T_int;
  signal limit     : std_logic_vector(31 downto 0);

begin
  
   -- When the number of Polls becomes equal to the parameter "limit",
   -- countflag becomes FALSE and Polling is stopped. Otherwise, polling
   -- continues until countflag becomes FALSE or the required value is 
   -- polled. Counter for number of polls.
   count_seq : process (postatI, data_sel) 
     begin
        if (rising_edge(postatI)) then
          limit <= apb_packet.limit;
          count <= (others => '0');
          if (not(countflag)) then
            countflag <= TRUE;
          end if ;
        elsif ((postatI = '1') and (data_sel = d_read)) then
          count <= nextcount;
          if (count = limit - 1) then 
            countflag <= FALSE;
          end if;  
        end if;
     end process;

   count_comb : process (data_sel, PCLK, postatI) 
     begin
      if (rising_edge(postatI)) then
        nextcount <= ONE; 
      elsif (rising_edge(PCLK) and (data_sel = d_read) and 
                                                   (postatI = '1')) then
        nextcount <= (count + ONE);
      end if;
     end process;

   line_driver : process (data_sel,PCLK)
     variable i_r_data   : T_data;
     variable i_exp      : T_data;
     variable i_mask     : T_data;
     variable i_tagstr   : string(1 to 20);
   begin

     case data_sel is
       when d_idle =>
         null;                           --  keep previous data in idle
       when  dr_idle =>
         i_mask := apb_packet.mask;
         i_exp := apb_packet.exp;
         i_tagstr := apb_packet.tag;
       when d_write =>
          wdata_bus <= apb_packet.data after (Tclkh - Tispdw);
       when d_read =>
         i_r_data := rdata_bus ;
         postatO <= postatI;
         if (rising_edge(PCLK) and PENABLE = '1') then
           ReportRead(Verbosity, HaltOnMismatch, i_r_data, i_mask, 
                       i_exp, i_tagstr,postatI,postatO,countflag);
         end if;
       when others =>
         null;
       end case;
   end process;
end behavioural;

-- --============================= End ===============================--
