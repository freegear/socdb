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
-- File Name              : ahbslave_tb.vhd.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           AHB Slave Test Bench entity
--
-- --=================================================================--

library IEEE;
use IEEE.std_logic_1164.all;

library common;
use common.defs.all;

library tbench;
use tbench.timing.all;

library bid;

library reader;

library buswatcher;

library vr;

-- ---------------------------------------------------------------------
entity ahbslave_tb is
  generic (
           INFILE               : string;
           Verbosity            : integer;
           HaltOnMismatch       : integer;
           XonSig               : integer;
           tclks                : time;
           tclkl                : time;
           tclkh                : time;
           Databuswidth         : integer;
           ahbslave_tb_TimingFile : string
          );
  port (
-- Inputs
        HREADY           : in    T_line;
        HRESP            : in    T_resp;
        HRDATA           : in    T_data;
        HSPLIT           : in    T_splitx;
        VRG0             : inout std_logic_vector(31 downto 0);
        VRG1             : inout std_logic_vector(31 downto 0);
        VRG2             : inout std_logic_vector(31 downto 0);
        VRG3             : inout std_logic_vector(31 downto 0);
        VRG4             : inout std_logic_vector(31 downto 0);
        VRG5             : inout std_logic_vector(31 downto 0);
        VRG6             : inout std_logic_vector(31 downto 0);
        VRG7             : inout std_logic_vector(31 downto 0);
-- Outputs
        HCLK             : out   std_ulogic;
        HRESETn          : out   T_line;
        HADDR            : out   T_addr;
        HTRANS           : out   T_trans;
        HWRITE           : out   T_line;
        HSIZE            : out   T_size;
        HBURST           : out   T_burst;
        HPROT            : out   T_prot;
        HMASTER          : out   T_master;
        HMASTLOCK        : out   T_line;
        HWDATA           : out   T_data 
       );
end ahbslave_tb;
-- ---------------------------------------------------------------------
--
--                             ahbslave_tb
--                             ===========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This module is the toplevel of Slave test bench and instantiates
-- the modules as well as define the generics of testbench.
--
-- --========================== ARCHITECTURE =========================--

architecture structural of ahbslave_tb is

-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------

constant b_Verbosity      : boolean := not (Verbosity = 0);
constant b_HaltOnMismatch : boolean := not (HaltOnMismatch = 0);
constant b_XonSig         : boolean := not (XonSig = 0);
constant VioDel           : t_array := (0 ns, 0 ns, 0 ns, 0 ns, 0 ns,
                                        0 ns, 0 ns, 0 ns);

-- ---------------------------------------------------------------------
-- Component declarations
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- AHB Slave Buswatcher
-- ---------------------------------------------------------------------
component buswatch
  generic (
           Tclkl            : time;
           Tclkh            : time;
           tovdr            : time;
           tohdr            : time;
           tovrsp           : time;
           tohrsp           : time;
           tohsplt          : time;
           tovsplt          : time;
           tovrdy           : time;
           tohrdy           : time;
           Verbosity        : boolean;
           SuppressOnReset  : boolean
          );
  port (
        HADDR            : in T_addr;
        HRESETn          : in T_line;
        HCLK             : in std_logic;
        HRDATA           : in T_data;
        DelHWRITE        : in T_line;
        HTRANS           : in T_trans;
        HMASTER          : in T_master;
        HSPLIT           : in T_splitx;
        HREADY           : in T_line;
        HRESP            : in T_resp
       );
end component;

-- ---------------------------------------------------------------------
-- INFILE Reader
-- ---------------------------------------------------------------------
component reader
  generic (
           INFILE           : string;
           tclkl            : time;
           tclkh            : time
          );
  port (
        HCLK             : in std_logic;
        Bidgetline       : in T_get;
        Vrgetline        : in T_get;
        Bidpacket        : out T_bid;
        Respacket        : out T_res;
        Vrpacket         : out T_vrbus;
        Endianpacket     : out T_endian;
        Splitpacket      : out T_split;
        Bcycsel          : out T_cycle;
        Rcycsel          : out T_cycle;
        Vrcycsel         : out T_cyclebus;
        Encycsel         : out T_cycle;
        Spcycsel         : out T_cycle;
        Last             : in T_line
       );
end component;

-- ---------------------------------------------------------------------
-- AHB Reset signal Driver
-- ---------------------------------------------------------------------
component Resetdriver
  generic (
           Verbosity        : boolean;
           tclkh            : time;
           tclkl            : time;
           tisrst           : time;
           tihrst           : time;
           Resetdel         : time
         );
  port (
        Ressel           : in T_cycle;
        HCLK             : in std_logic;
        Respacket        : in T_res;
        HRESETn          : out std_logic
       );
end component;

-- ---------------------------------------------------------------------
-- AHB Cycle Driver
-- ---------------------------------------------------------------------
component cyc_drivers
  generic (
           tclkl          : time;
           tclkh          : time;
           tiha           : time;
           tisa           : time;
           tihmst         : time;
           tihmlck        : time;
           tismst         : time;
           tismlck        : time;
           tihctl         : time;
           tisctl         : time;
           tihtr          : time;
           tistr          : time;
           tihwd          : time;
           tiswd          : time;
           Verbosity      : boolean;
           HaltOnMismatch : boolean;
           XonSig         : boolean;
           Databuswidth   : integer
          );
  port (
        HCLK             : in  std_logic;
        HRESETn          : in  std_logic;
        HADDR            : out T_addr;
        HTRANS           : out T_trans;
        HWRITE           : out T_line;
        HSIZE            : out T_size;
        HBURST           : out T_burst;
        HPROT            : out T_prot;
        HWDATA           : out T_data;
        HMASTER          : out T_master;
        HMASTLOCK        : out T_line;
        HRDATA           : in  T_data;
        HREADY           : in  T_line;
        HRESP            : in  T_resp;
        DelHWRITE        : out T_line;
        Bidpacket        : in  T_bid;
        Bidgetline       : out T_get;
        Endiansel        : in T_cycle;
        Vendianpacket    : in T_endian;
        TogEndian        : out std_logic_vector(1 downto 0);  
        Cycsel           : in  T_cycle;
        Cyccount         : out T_int;
        Simend           : out T_line
       );
end component;

-- ---------------------------------------------------------------------
-- HCLK Generator
-- ---------------------------------------------------------------------
component clockgen
  generic (
           tclks : time;
           tclkl : time;
           tclkh : time
          );
  port (
        HCLK             : out std_logic
       );
  end component;

-- ---------------------------------------------------------------------
-- Virtual Registers' Cycle Driver
-- ---------------------------------------------------------------------
component VRCycDrivers
  port (
        HCLK             : in std_logic;
        Cycsel           : in T_cyclebus;
        Vrpacket         : in T_vrbus;
        CycCount         : in T_int;
        VrgetLine        : out T_get;
        Viosel           : out T_v_drv_selbus
       );
end component;

-- ---------------------------------------------------------------------
-- VIO Driver
-- ---------------------------------------------------------------------
component VIODriver
  generic (
           VIODel         : t_array;
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
  port (
        HCLK             : in std_logic;
        Viosel           : in T_v_drv_selbus;
        Vrpacket         : in T_vrbus;
        Vio              : inout T_vio
       );
end component;

-- ---------------------------------------------------------------------
-- HSPLITx Checker
-- ---------------------------------------------------------------------
component Split
  generic (
           Verbosity      : boolean;
           HaltOnMismatch : boolean
          );
  port (
        HCLK             : in std_logic;
        HSPLIT           : in std_logic_vector(15 downto 0);
        Splitsel         : in T_cycle;
        Vsplitpacket     : in T_split
       );
end component;

-- ---------------------------------------------------------------------
-- These Cycsel signals are passed to the ahb, vr and res blocks. There
-- are three because a VR, BnRES and AHB signal may have to be driven in
-- the same cycle.
-- ---------------------------------------------------------------------
signal Bcycsel          : T_cycle;
signal Rcycsel          : T_cycle;
signal Vrcycsel         : T_cyclebus;
signal Encycsel         : T_cycle;
signal Spcycsel         : T_cycle;

-- ---------------------------------------------------------------------
-- The get line signals come from the ahb and vr blocks, but one in not
-- needed for the reset line, as this operates on its own. It is
-- implicitly assumed the user will not issue another reset until the
-- Last one has finished. The reader samples these in the low phase and
-- decides on this whether to drive signals in the high phase.
-- ---------------------------------------------------------------------
signal Bidgetline       : T_get;
signal Vrgetline        : T_get;

-- ---------------------------------------------------------------------
-- the packets make the design more re-usable since the contents can be
-- changed in one place to port the design to a different
-- test bench.
-- ---------------------------------------------------------------------
signal Bidpacket        : T_bid;
signal Respacket        : T_res;
signal Endianpacket     : T_endian;
signal Splitpacket      : T_split;
signal Cyccount         : T_int;
-- indicates the 'current-cycle-number' of the transfer being driven
       

signal Vrpacket         : T_vrbus;
-- packet containing info about values to be driven on virtual reg lines

signal Last             : T_line;
signal DelHWRITE        : T_line;
signal iHTRANS          : T_trans;
signal iHMASTER         : T_master;
signal iHADDR           : T_addr;

signal iHCLK            : std_logic;
signal iHRESETn         : T_line;
signal iHWRITE          : T_line;
signal I_SEL            : T_line;
signal iHPROT           : T_prot;
signal iHSIZE           : T_size;
signal TogEndian        : std_logic_vector(1 downto 0) := "00";
signal Viosel           : T_v_drv_selbus;
-- Signal enumerations for legibility

signal BSIZE_S          : SIZE_S;

begin

-- ---------------------------------------------------------------------
-- The architecture is merely the instantiation of the component blocks
-- with connections between them. The ahb, reset and vr blocks have
-- within them two components, cycle drivers - one for each cycle type,
-- and line drivers - one for each o/p line.
-- ---------------------------------------------------------------------
HCLK             <= iHCLK;
HWRITE           <= iHWRITE;
HRESETn          <= iHRESETn;
HPROT            <= iHPROT;
HSIZE            <= iHSIZE;
HTRANS           <= iHTRANS;
HMASTER          <= iHMASTER;
HADDR            <= iHADDR;

-- ---------------------------------------------------------------------
-- AHB Slave BusWatcher Instantiation
-- ---------------------------------------------------------------------
ubuswatch : buswatch
  generic map (
               Tclkl           => tclkl,
               Tclkh           => tclkh,
               tovdr           => tovdr,
               tohdr           => tohdr,
               tovrsp          => tovrsp,
               tohrsp          => tohrsp,
               tovrdy          => tovrdy,
               tohrdy          => tohrdy,
               tovsplt         => tovsplt,
               tohsplt         => tohsplt,
               Verbosity       => b_Verbosity,
               SuppressOnReset => TRUE
              )
  port map (
            HADDR            => iHADDR,
            HRESETn          => iHRESETn,
            HCLK             => iHCLK,
            HRDATA           => HRDATA,
            DelHWRITE        => DelHWRITE,
            HTRANS           => iHTRANS,
            HMASTER          => iHMASTER,
            HSPLIT           => HSPLIT,
            HREADY           => HREADY,
            HRESP            => HRESP
           );

-- ---------------------------------------------------------------------
-- INFILE Reader Instantiation
-- ---------------------------------------------------------------------
ureader : reader
  generic map (
               INFILE => INFILE,
               tclkl  => tclkl,
               tclkh  => tclkh
              )
  port map (
            HCLK             => iHCLK,
            Bidgetline       => Bidgetline,
            Vrgetline        => Vrgetline,
            Bidpacket        => Bidpacket,
            Respacket        => Respacket,
            Vrpacket         => Vrpacket,
            Endianpacket     => Endianpacket,
            Splitpacket      => Splitpacket,
            Bcycsel          => Bcycsel,
            Rcycsel          => Rcycsel,
            Vrcycsel         => Vrcycsel,
            Encycsel         => Encycsel,
            Spcycsel         => Spcycsel,
            Last             => Last
           );

-- ---------------------------------------------------------------------
-- AHB Reset Driver Instantiation
-- ---------------------------------------------------------------------
uresdrv : Resetdriver
  generic map (
               Verbosity => b_Verbosity,
               tclkh     => tclkh,
               tclkl     => tclkl,
               tisrst    => tisrst,
               tihrst    => tihrst,
               Resetdel  => Resetdel
              )
  port map (
            Ressel           => Rcycsel,
            HCLK             => iHCLK,
            Respacket        => Respacket,       
            HRESETn          => iHRESETn
           );

-- ---------------------------------------------------------------------
-- HCLK Generator Instantiation
-- ---------------------------------------------------------------------
uclockgen : clockgen
  generic map (
               tclks => tclks,
               tclkl => tclkl,
               tclkh => tclkh
              )
  port map (
            HCLK             => iHCLK
           );

-- ---------------------------------------------------------------------
-- AHB Cycle Driver Instantiation
-- ---------------------------------------------------------------------
ucyc_drivers : cyc_drivers
  generic map (
               tclkl          => tclkl,
               tclkh          => tclkh,
               tiha           => tiha,
               tisa           => tisa,
               tihmst         => tihmst,
               tihmlck        => tihmlck,
               tismst         => tismst,
               tismlck        => tismlck,
               tihctl         => tihctl,
               tisctl         => tisctl,
               tihtr          => tihtr,
               tistr          => tistr,
               tihwd          => tihwd,
               tiswd          => tiswd,
               Verbosity      => b_Verbosity,
               HaltOnMismatch => b_HaltOnMismatch,
               XonSig         => b_XonSig,
               Databuswidth   => Databuswidth
              )
  port map (
            HCLK             => iHCLK,
            HRESETn          => iHRESETn,
            HADDR            => iHADDR,
            HTRANS           => iHTRANS,
            HWRITE           => iHWRITE,
            HSIZE            => iHSIZE,
            HBURST           => HBURST,
            HPROT            => iHPROT,
            HWDATA           => HWDATA,
            HMASTER          => iHMASTER,
            HMASTLOCK        => HMASTLOCK,
            HRDATA           => HRDATA,
            HREADY           => HREADY,
            HRESP            => HRESP,
            DelHWRITE        => DelHWRITE,
            TogEndian        => TogEndian,
            Endiansel        => Encycsel,
            Vendianpacket    => Endianpacket,
            Bidpacket        => Bidpacket,
            Bidgetline       => Bidgetline,
            Cycsel           => Bcycsel,
            Cyccount         => Cyccount,
            Simend           => Last
           );

-- ---------------------------------------------------------------------
-- VR Cycle Driver Instantiation
-- ---------------------------------------------------------------------
uvrcycdrv : VRCycDrivers
  port map (
            HCLK             => iHCLK,
            Cycsel           => Vrcycsel,
            Vrpacket         => Vrpacket,
            CycCount         => Cyccount,
            VrgetLine        => Vrgetline,
            Viosel           => Viosel
           );

-- ---------------------------------------------------------------------
-- VIO Driver Instantiation
-- ---------------------------------------------------------------------
uviodrv : VIODriver
  generic map (
               VioDel         => VioDel,
               Verbosity      => b_Verbosity,
               HaltOnMismatch => b_HaltOnMismatch
              )
  port map (
            HCLK             => iHCLK,
            Viosel           => Viosel,
            Vrpacket         => Vrpacket,
            Vio(0)           => VRG0,
            Vio(1)           => VRG1,
            Vio(2)           => VRG2,
            Vio(3)           => VRG3,
            Vio(4)           => VRG4,
            Vio(5)           => VRG5,
            Vio(6)           => VRG6,
            Vio(7)           => VRG7
           );

-- ---------------------------------------------------------------------
-- HSPLITx Checker Instantiation
-- ---------------------------------------------------------------------
uSplit : Split
  generic map (
               Verbosity      => b_Verbosity,
               HaltOnMismatch => b_HaltOnMismatch
              )
  port map (
            HCLK             => iHCLK,
            HSPLIT           => HSPLIT,
            Splitsel         => Spcycsel,
            Vsplitpacket     => Splitpacket
           );

-- ---------------------------------------------------------------------
--  debugging aids - translate bus values to symbols
-- ---------------------------------------------------------------------
BSIZE_S          <= To_SIZE_S(iHSIZE);

end structural;

-- ============================== End =============================== --
