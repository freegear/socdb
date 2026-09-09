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
-- File Name           : apbslave_tb.vhd.rca 
-- File Revision       : 1.1 
-- 
-- Release Information : PrimeCell(TM)-PL131-REL1v0 
-- 
-- ---------------------------------------------------------------------
-- Purpose             : APB Slave Test Bench entity
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library common;
use     common.defs.all;

library tbench;
use     tbench.timing.all;

library bid;

library vr;

library reader;

library buswatcher;

entity apbslave_tb is
  generic
         (
          PRDATA_mask            : string;
          INFILE                 : string;
          Verbosity              : integer;
          HaltOnMismatch         : integer;
          tclks                  : time;
          tclkl                  : time;
          tclkh                  : time
          );
  port(
       PRESETn     : out std_logic;
       PCLK        : out std_logic;
       PADDR       : out std_logic_vector(31 downto 0);
       PWRITE      : out std_logic;
       PENABLE     : out std_logic;
       PSEL        : out std_logic; 
       PSELT       : out std_logic; 
       PWDATA      : out std_logic_vector(31 downto 0);
       PRDATA      : in  std_logic_vector(31 downto 0);
       VRG0        : inout std_logic_vector(31 downto 0);
       VRG1        : inout std_logic_vector(31 downto 0);
       VRG2        : inout std_logic_vector(31 downto 0);
       VRG3        : inout std_logic_vector(31 downto 0);
       VRG4        : inout std_logic_vector(31 downto 0);
       VRG5        : inout std_logic_vector(31 downto 0);
       VRG6        : inout std_logic_vector(31 downto 0);
       VRG7        : inout std_logic_vector(31 downto 0)
       );

end apbslave_tb;

architecture structural of apbslave_tb is

  constant vio_del     : t_array := (vrg0_del, vrg1_del, vrg2_del, 
                      vrg3_del, vrg4_del, vrg5_del, vrg6_del, vrg7_del);
                                       
  constant b_Verbosity      : boolean := not (Verbosity = 0);
  constant b_HaltOnMismatch : boolean := not (HaltOnMismatch = 0);
  
  component buswatch 
  generic
         (
          PRDATA_mask_str : string;
          tovpdr          : time;
          tohpdr          : time;
          SuppressOnReset : boolean;
          Mesg_enb        : boolean
          );
  port
    (
     PRESETn     : in T_line;
     PCLK        : in std_logic;
     PWRITE      : in T_line;
     PENABLE     : in T_line;
     PRDATA      : in T_data;
     PSEL        : in T_line 
    );  
  end component;
  
  component reader
  generic(
          INFILE : string;
          tclkl  : time;
          tclkh  : time
          );
  port
    (PCLK           : in std_logic;
     apb_get_line   : in T_get;
     vr_get_line    : in T_get;
     apb_packet     : out T_apb;
     vr_packet      : out T_vrbus;
     res_packet     : out T_res;
     pcyc_sel       : out T_cycle;
     vcyc_sel       : out T_cyclebus;
     rcyc_sel       : out T_cycle;
     postatI        : out std_logic
    );
  end component;
  
  component reset_driver
  generic(
          Verbosity : boolean;
          tclkl     : time;
          tisnres   : time;
          tihnres   : time;
          reset_del : time
         );
  port(
       res_sel    : in T_cycle;
       PCLK       : in T_line;
       res_packet : in T_res;       
       PRESETn    : out std_logic
       );
  end component;
  
  component buscyc_drivers
  generic(
          Verbosity : boolean
         );
  port
    (
       PCLK           : in T_line;
       PRESETn        : in T_line;
       cyc_sel        : in T_cycle;
       apb_packet     : in T_apb;
       postatO        : in std_logic;
       postatI        : in std_logic;
       apb_get_line   : out T_get;
       PADDR_sel      : out T_a_drv_sel;
       PWDATA_sel     : out T_d_drv_sel;
       PSEL_sel       : out T_a_drv_sel;
       PWRITE_sel     : out T_a_drv_sel;
       PENABLE_sel    : out T_t_drv_sel;
       cyc_count      : out T_int
       );
  end component;

  component busline_drivers
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
       PCLK          : in T_line;
       PRESETn       : in T_line;
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
       PSEL          : out std_logic;
       PSELT         : out std_logic;
       PWRITE        : out std_logic;
       PENABLE       : out std_logic
       );
  end component;

  component clockgen
  generic(
          tclks  : time;
          tclkl  : time;
          tclkh  : time
          );          
  port(
       PCLK : out std_logic
       );
  end component;

  component viregcyc_drivers
  port(
       PCLK          : in std_logic;
       cyc_sel       : in T_cyclebus;
       vr_packet     : in T_vrbus;
       cyc_count     : in T_int;
       vreg_get_line : out T_get;
       VIO_sel       : inout T_v_drv_selbus
       );
  end component;

  component vio_driver
  generic (
           vio_del        : t_array;
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
    port(
       PCLK      : in std_logic;
       VIO_sel   : in T_v_drv_selbus;
       vr_packet : in T_vrbus;
       VIO       : inout T_vio         
       );
  end component;
  
  signal I_CLK       : std_logic;
  signal I_nRES      : std_logic;
  signal I_PWRITE    : std_logic;
  signal I_PSEL      : std_logic;
  signal I_PSELT     : std_logic;
  signal I_PENABLE   : std_logic;
  signal O_PENABLE   : std_logic;

  signal pcyc_sel    : T_cycle;
  signal rcyc_sel    : T_cycle;
  signal vcyc_sel    : T_cyclebus;

  signal apb_packet  : T_apb;
  signal vr_packet   : T_vrbus;
  signal res_packet  : T_res;

  signal apb_get_line : T_get ;
  signal vr_get_line  : T_get := g_idle;

  signal postatI     : std_logic;
  signal postatO     : std_logic;

  signal cyc_count   : T_int;

begin

  O_PENABLE   <= I_PENABLE and I_nRES;

  PCLK    <= I_CLK;
  PRESETn <= I_nRES;
  PSEL    <= I_PSEL;
  PSELT   <= I_PSELT;
  PWRITE  <= I_PWRITE;
  PENABLE <= O_PENABLE;

  u_watch : buswatch
    generic map (PRDATA_mask_str => PRDATA_mask,
                 tovpdr          => tovpdr,
                 tohpdr          => tohpdr,
                 SuppressOnReset => TRUE,
                 Mesg_enb        => FALSE
                )
  port map
    (
     PRESETn     => I_nRES,
     PCLK        => I_CLK,
     PWRITE      => I_PWRITE,
     PENABLE     => O_PENABLE,
     PRDATA      => PRDATA,
     PSEL        => I_PSEL
    );
  
  u_reader : reader
  generic map (
               INFILE => INFILE,
               tclkl  => tclkl,
               tclkh  => tclkh
              )
  port map
    (PCLK           => I_CLK,
     apb_get_line   => apb_get_line,
     vr_get_line    => vr_get_line,
     apb_packet     => apb_packet,
     vr_packet      => vr_packet,
     res_packet     => res_packet,
     pcyc_sel       => pcyc_sel,
     vcyc_sel       => vcyc_sel,
     rcyc_sel       => rcyc_sel,
     postatI        => postatI
    );


  VR_BLOCK : block
                 
    signal VIO_sel    : T_v_drv_selbus;
                 
  begin
  
    u_vrcycdrv : viregcyc_drivers
    port map (
              PCLK          => I_CLK,
              cyc_sel       => vcyc_sel,
              vr_packet     => vr_packet,
              cyc_count     => cyc_count,
              vreg_get_line => vr_get_line,
              VIO_sel       => VIO_sel
             );
    
    u_viodrv : vio_driver
    generic map (
                 vio_del        => vio_del,
                 Verbosity      => b_Verbosity,
                 HaltOnMismatch => b_HaltOnMismatch
                 )
    port map (
              PCLK      => I_CLK,
              VIO_sel   => VIO_sel,
              vr_packet => vr_packet,
              VIO(0)    => VRG0,     
              VIO(1)    => VRG1,     
              VIO(2)    => VRG2,     
              VIO(3)    => VRG3,     
              VIO(4)    => VRG4,     
              VIO(5)    => VRG5,     
              VIO(6)    => VRG6,     
              VIO(7)    => VRG7    
              );

  end block VR_BLOCK;

  u_reset : reset_driver
  generic map (
               Verbosity => b_Verbosity,
               tclkl     => tclkl,
               tisnres   => tisnres,
               tihnres   => tihnres,
               reset_del => reset_del
              )
  port map
     ( res_sel    => rcyc_sel,
       PCLK       => I_CLK,
       res_packet => res_packet,
       PRESETn    => I_nRES
       );

  u_clockgen : clockgen
  generic map (
               tclks  => tclks,
               tclkl  => tclkl,
               tclkh  => tclkh
              )
  port map (
       PCLK => I_CLK
    );

BID_BLOCK : block
                  
  signal PADDR_sel   : T_a_drv_sel;
  signal PWDATA_sel  : T_d_drv_sel;
  signal PSEL_sel    : T_a_drv_sel;
  signal PWRITE_sel  : T_a_drv_sel;
  signal PENABLE_sel : T_t_drv_sel;
                  
begin
  
 u_blindrv : busline_drivers
  generic map (
               Verbosity      => b_Verbosity,
               HaltOnMismatch => b_HaltOnMismatch,
               tclkh          => tclkh,
               tclkl          => tclkl,
               tispdw         => tispdw,
               tihpdw         => tihpdw,
               tispen         => tispen,
               tihpen         => tihpen,
               tispsel        => tispsel,
               tihpsel        => tihpsel,
               tispw          => tispw,
               tihpw          => tihpw,
               tispaddr       => tispaddr,
               tihpaddr       => tihpaddr
              )
  port map
   (
       PCLK          => I_CLK,
       PRESETn       => I_nRES,
       PADDR_sel     => PADDR_sel,
       PWDATA_sel    => PWDATA_sel,
       PSEL_sel      => PSEL_sel,
       PWRITE_sel    => PWRITE_sel,
       PENABLE_sel   => PENABLE_sel,
       apb_packet    => apb_packet,
       postatI       => postatI,
       postatO       => postatO,
       cyc_sel       => pcyc_sel,
       PADDR         => PADDR,
       PRDATA        => PRDATA,
       PWDATA        => PWDATA,
       PSEL          => I_PSEL,
       PSELT         => I_PSELT,
       PWRITE        => I_PWRITE,
       PENABLE       => I_PENABLE
       );
  
  u_bcycdrv : buscyc_drivers
  generic map (
               Verbosity => b_Verbosity
              )
  port map
    (
       PCLK          => I_CLK,
       PRESETn       => I_nRES,
       cyc_sel       => pcyc_sel,
       apb_packet    => apb_packet,
       postatO       => postatO,
       postatI       => postatI,
       apb_get_line  => apb_get_line,
       PADDR_sel     => PADDR_sel,
       PWDATA_sel    => PWDATA_sel,
       PSEL_sel      => PSEL_sel,
       PWRITE_sel    => PWRITE_sel,
       PENABLE_sel   => PENABLE_sel,
       cyc_count     => cyc_count
       );

end block BID_BLOCK;

end structural;

-- --============================= End ===============================--
