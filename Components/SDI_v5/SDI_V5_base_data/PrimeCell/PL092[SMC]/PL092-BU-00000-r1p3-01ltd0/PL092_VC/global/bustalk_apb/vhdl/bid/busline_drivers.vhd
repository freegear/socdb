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
-- File Name           : busline_drivers.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-GLOBAL-REL1v7 
-- 
-- ---------------------------------------------------------------------
-- Purpose : 
--           This instantiates a generic width line driver for each APB
--           signal and passes in the cycle information and select 
--           signals. In order for true generic width, the to_vec and 
--           from_vec functions have to be used to convert single bit 
--           signals into unit width vectors.
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;
use     common.funcs.all;

library bid;

entity busline_drivers is
  generic (
           Verbosity      : boolean;
           HaltOnMismatch : boolean;
           tclkh          : time;
           tclkl          : time;
           tispdw         : time;
           tihpdw         : time;
           tispen         : time;
           tihpen         : time;
           tispsel        : time;
           tihpsel        : time;
           tispw          : time;
           tihpw          : time;
           tispaddr       : time;
           tihpaddr       : time
          );
  port(
       PCLK          : in std_logic;
       PRESETn       : in std_logic;
       PADDR_sel     : in T_a_drv_sel;
       PWDATA_sel    : in T_d_drv_sel;
       PSEL_sel      : in T_a_drv_sel;
       PWRITE_sel    : in T_a_drv_sel;
       PENABLE_sel   : in T_t_drv_sel;
       apb_packet    : in T_apb;
       postatI       : in std_logic;
       postatO       : out std_logic;
       cyc_sel       : in T_cycle;
       PADDR         : out std_logic_vector(31 downto 0);
       PWDATA        : out T_data;
       PRDATA        : in T_data;
       PSEL          : out T_line;
       PSELT         : out T_line;
       PWRITE        : out T_line;
       PENABLE       : out T_line
       );
end busline_drivers;

architecture structural of busline_drivers is
  
 component data_driver
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
 end component;
 
  component addrctl_driver
    generic( width : T_int;
             Tclkh : time;
             Tis   : time;
             Tih   : time );
    port(
         PRESETn     : in std_logic;
         addrctl_sel : in T_a_drv_sel;
         in_sig      : in std_logic_vector((width-1) downto 0);
         out_sig     : out std_logic_vector((width-1) downto 0)
         );
  end component;

  component  penable_driver
    generic(
             Tclkl : time;
             Tis   : time;
             Tih   : time );
    port(
         penable_sel : in T_t_drv_sel;
         out_sig     : out std_logic
         );
  end component;
     
  -- these signals are required for single bit address timed lines so 
  -- that the same driver can be used throughout.  It is only a type 
  -- conversion.
  
  signal vec_write  : std_logic_vector(0 downto 0);
  signal vec_PWRITE : std_logic_vector(0 downto 0);
  signal vec_sel    : std_logic_vector(0 downto 0);
  signal vec_PSEL   : std_logic_vector(0 downto 0);

  signal vec_PADDR  : T_addr;
  signal TrickBoxSel: T_line;
  signal i_PENABLE  : T_line;
  signal i_PSEL     : T_line;
  signal i_PSELT    : T_line;

begin

  vec_write <= to_vec(apb_packet.write);
  vec_sel   <= "0" when (postatI = '1' and PWData_sel = d_idle) 
            else
               to_vec(apb_packet.sel);
  PWRITE    <= from_vec(vec_PWRITE);
  PSEL      <= i_PSEL;
  PSELT     <= i_PSELT;

  TrickBoxSel <= '1' when (apb_packet.addr(31 downto 8) = TrickBoxAddr)
              else
                 '0';
 
  i_PSEL      <= '1' when (vec_PSEL'event and (vec_PSEL = "1")
                           and (TrickBoxSel = '0'))
              else
                 '0' when (vec_PSEL'event and (vec_PSEL = "0" or
                           (vec_PSEL = "1" and TrickBoxSel = '1')))
              else
                 'X' when (vec_PSEL'event and vec_PSEL = "X")
              else
                 i_PSEL;
 
  i_PSELT     <= '1' when (vec_PSEL'event and (vec_PSEL = "1")
                           and (TrickBoxSel = '1'))
              else
                 '0' when (vec_PSEL'event and (vec_PSEL = "0" or
                           (vec_PSEL = "1" and TrickBoxSel = '0')))
              else
                 'X' when (vec_PSEL'event and vec_PSEL = "X")
              else
                 i_PSELT;

  PADDR     <= vec_PADDR;
  PENABLE   <= i_PENABLE;

  u_PWDATA_DRIVER : data_driver
  generic map (
               Verbosity      => Verbosity,
               HaltOnMismatch => HaltOnMismatch,
               tclkh          => tclkh,
               tispdw         => tispdw,
               tihpdw         => tihpdw 
              )
  port map (
       PCLK        => PCLK,
       data_sel    => PWDATA_sel,
       apb_packet  => apb_packet,
       postatI     => postatI,
       postatO     => postatO,
       PENABLE     => i_PENABLE,
       rdata_bus   => PRDATA,
       wdata_bus   => PWDATA
    );

  u_PADDR_DRIVER : addrctl_driver
    generic map (
                 width => T_addr'length,
                 Tclkh => tclkh,
                 Tis   => Tispaddr,
                 Tih   => Tihpaddr
                )
    port map (
       PRESETn     => PRESETn,
       addrctl_sel => PADDR_sel,
       in_sig      => apb_packet.addr,
       out_sig     => vec_PADDR
    );

  u_PWRITE_DRIVER : addrctl_driver
    generic map (
                 width => 1,
                 Tclkh => tclkh,
                 Tis   => Tispw,
                 Tih   => Tihpw
                )
    port map (
       PRESETn     => PRESETn,
       addrctl_sel => PWRITE_sel,
       in_sig      => vec_write,
       out_sig     => vec_PWRITE
    );

  u_PSEL_DRIVER : addrctl_driver
    generic map (
                 width => 1,
                 Tclkh => tclkh,
                 Tis   => Tispsel,
                 Tih   => Tihpsel
                )
    port map (
       PRESETn     => PRESETn,
       addrctl_sel => PSEL_sel,
       in_sig      => vec_sel,
       out_sig     => vec_PSEL
    );
  
   u_PENABLE_DRIVER : penable_driver
     generic map (
                  Tclkl => tclkl,
                  Tis   => Tispen,
                  Tih   => Tihpen
                 )
     port map (
       penable_sel => PENABLE_sel,
       out_sig     => i_PENABLE
    );

end structural;

-- --============================= End ===============================--
