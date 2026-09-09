--============================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  
--  ----------------------------------------------------------------------------
--  Version and Release Control Information:
--  
--  File Name           : Inport0.vhd,v
--  File Revision       : 1.14
--  
--  Release Information : ADK_REL1v1
--  
--  ----------------------------------------------------------------------------
--  Purpose             : Structural sub-block architecture of Example Amba 
--                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
--                        Inport 0. The module contains the following AHB 
--                        devices:
--                       
--                          - ARM922T with Test Interface (Local master 1)
--                          - 1Kbyte Internal Memory SRAM (Local slave)
--                          - Local Slave-to-Master multiplexor
--                          - Local Address Decoder
--                       
--                        The ARM922T Test Interface is an AHB slave. The Test 
--                        Interface is connected directly to the TIC, which is
--                        contained within Outport0 module.
--============================================================================--

library ieee;
use     ieee.std_logic_1164.all;

-- pragma translate_off
library A922T;
use A922T.all;
library InternalMemory;
use InternalMemory.all;
library ElementsAHB;
use ElementsAHB.all;
-- pragma translate_on

entity Inport0 is
  -- pragma synthesis_off
  generic(
    -- Width of the address bus of the Internal Memory block
    IntMemAddrWidth : integer := 10;
    -- Internal Memory initialisation file
    IntMemInitFile  : string  := "intram.dat"
    );
  -- pragma synthesis_on
  port(
    -- Common AHB signals
    HCLK         : in  std_logic;
    HRESETn      : in  std_logic;

    -- Matrix AHB connections
    HADDR        : out std_logic_vector(31 downto 0);
    HBURST       : out std_logic_vector(2 downto 0);
    HMASTLOCK    : out std_logic;
    HPROT        : out std_logic_vector(3 downto 0);
    HSIZE        : out std_logic_vector(2 downto 0);
    HTRANS       : out std_logic_vector(1 downto 0);
    HWDATA       : out std_logic_vector(31 downto 0);
    HWRITE       : out std_logic;
    HSELmtrx     : out std_logic;
    HREADYOUT    : out std_logic;

    HRDATAmtrx   : in  std_logic_vector(31 downto 0);
    HREADYmtrx   : in  std_logic;
    HRESPmtrx    : in  std_logic_vector(1 downto 0);

    -- ARM922T Test Slave connections
    HADDRtst     : in  std_logic_vector(11 downto 2);
    HSELtst      : in  std_logic;
    HTRANStst    : in  std_logic_vector(1 downto 0);
    HWRITEtst    : in  std_logic;
    HWDATAtst    : in  std_logic_vector(31 downto 0);

    HRDATAtst    : out std_logic_vector(31 downto 0);
    HREADYOUTtst : out std_logic;
    HRESPtst     : out std_logic_vector(1 downto 0);

    -- ARM922T interrupts
    nFIQ         : in  std_logic;
    nIRQ         : in  std_logic;

    -- ARM922T comms channel debug lines
    COMMRX       : out std_logic;
    COMMTX       : out std_logic;

    -- ARM922T Fast Cache clock
    FCLK         : in  std_logic;

    -- JTAG connections
    nTRST        : in  std_logic;
    TCK          : in  std_logic;
    TDI          : in  std_logic;
    TMS          : in  std_logic;
    nTDOEN       : out std_logic;
    TDO          : out std_logic;

    -- Remap/Pause control signals
    Remap        : in std_logic;
    Pause        : in std_logic;

    -- Scan test dummy signals; not connected until scan insertion 
    SCANENABLE   : in  std_logic; -- Scan Test Mode Enbl
    SCANINHCLK   : in  std_logic; -- Scan Chain Input
    SCANOUTHCLK  : out std_logic  -- Scan Chain Output
    );
end Inport0;

architecture structural of Inport0 is

--------------------------------------------------------------------------------
-- Components: Module specific (AHB)
--------------------------------------------------------------------------------

-- ARM922T core wrapper (master)
  component A922T
    port(
      -- Signals used during normal operation and test mode
      HCLK       : in  std_logic;
      HRESETn    : in  std_logic;

      -- Signals from AMBA bus used during normal operation
      HRDATAM    : in  std_logic_vector(31 downto 0);
      HREADYM    : in  std_logic;
      HRESPM     : in  std_logic_vector(1 downto 0);
      HGRANTM    : in  std_logic;

      -- Signals to AMBA bus used during normal operation
      HADDRM     : out std_logic_vector(31 downto 0);
      HTRANSM    : out std_logic_vector(1 downto 0);
      HWRITEM    : out std_logic;
      HSIZEM     : out std_logic_vector(2 downto 0);
      HBURSTM    : out std_logic_vector(2 downto 0);
      HPROTM     : out std_logic_vector(3 downto 0);
      HWDATAM    : out std_logic_vector(31 downto 0);
      HBUSREQM   : out std_logic;
      HLOCKM     : out std_logic;

      -- Signals from AMBA bus used during test mode
      HADDRS     : in  std_logic_vector(11 downto 2);
      HTRANS1S   : in  std_logic;
      HWRITES    : in  std_logic;
      HWDATAS    : in  std_logic_vector(31 downto 0);
      HSELS      : in  std_logic;
      HREADYS    : in  std_logic;

      -- Signals to AMBA bus used during test mode
      HRDATAS    : out std_logic_vector(31 downto 0);
      HREADYOUTS : out std_logic;
      HRESPS     : out std_logic_vector(1 downto 0);

      -- Fast Cache clock
      FCLK       : in  std_logic;

      -- ARM interrupts
      ARMNFIQ    : in  std_logic;
      ARMNIRQ    : in  std_logic;

      -- Comms channel signals
      COMMRX     : out std_logic;
      COMMTX     : out std_logic;

      -- JTAG connections
      nTRST      : in  std_logic;
      TCK        : in  std_logic;
      TDI        : in  std_logic;
      TMS        : in  std_logic;
      nTDOEN     : out std_logic;
      TDO        : out std_logic;

      -- ATPG scan connections
      SCANENABLE  : in  std_logic;
      SCANINHCLK  : in  std_logic;
      SCANOUTHCLK : out std_logic 
      );
  end component;

-- Internal Memory slave
  component IntMem
    -- pragma synthesis_off
    generic(
      MemBits    : integer := 10; -- Memory size in address bits
      FileName   : string  := "intram.dat" -- Input filename
      );
    -- pragma synthesis_on
    port(
      HCLK       : in  std_logic;
      HRESETn    : in  std_logic;

      HSELIntMem : in  std_logic;

      HADDR      : in  std_logic_vector(31 downto 0);
      HTRANS     : in  std_logic_vector(1 downto 0);
      HWRITE     : in  std_logic;
      HSIZE      : in  std_logic_vector(2 downto 0);
      HWDATA     : in  std_logic_vector(31 downto 0);
      HREADY     : in  std_logic;
      
      HRDATA     : out std_logic_vector(31 downto 0);
      HREADYOUT  : out std_logic;
      HRESP      : out std_logic_vector(1 downto 0)
      );
  end component;


--------------------------------------------------------------------------------
-- Components: Common AHB Infrastructure
--------------------------------------------------------------------------------

-- Local Address Decoder
  component Decoder
    port(
      HADDR   : in  std_logic_vector(31 downto 20); 
      
      Remap   : in  std_logic;
      
      HSELS0B : out std_logic;
      HSELS0R : out std_logic;
      HSELS0  : out std_logic;
      HSELS1  : out std_logic;
      HSELS2  : out std_logic;
      HSELS3  : out std_logic;
      HSELS4  : out std_logic;
      HSELS5  : out std_logic;
      HSELS6  : out std_logic;
      HSELS7  : out std_logic;
      HSELS8  : out std_logic;
      HSELS9  : out std_logic;
      HSELS10 : out std_logic;
      HSELS11 : out std_logic;
      HSELS12 : out std_logic;
      HSELS13 : out std_logic;
      HSELS14 : out std_logic;
      HSELS15 : out std_logic
      );
  end component;

-- Local multiplexer - slaves to masters
  component MuxS2M
    port(
      HCLK          : in  std_logic;
      HRESETn       : in  std_logic;
      
      HSELS0        : in  std_logic;
      HSELS1        : in  std_logic;
      HSELS2        : in  std_logic;
      HSELS3        : in  std_logic;
      HSELS4        : in  std_logic;
      HSELS5        : in  std_logic;
      HSELS6        : in  std_logic;
      HSELS7        : in  std_logic;
      HSELDefault   : in  std_logic;
      
      HRDATAS0      : in  std_logic_vector(31 downto 0);
      HREADYS0      : in  std_logic;
      HRESPS0       : in  std_logic_vector(1 downto 0);
      
      HRDATAS1      : in  std_logic_vector(31 downto 0);
      HREADYS1      : in  std_logic;
      HRESPS1       : in  std_logic_vector(1 downto 0);
      
      HRDATAS2      : in  std_logic_vector(31 downto 0);
      HREADYS2      : in  std_logic;
      HRESPS2       : in  std_logic_vector(1 downto 0);
      
      HRDATAS3      : in  std_logic_vector(31 downto 0);
      HREADYS3      : in  std_logic;
      HRESPS3       : in  std_logic_vector(1 downto 0);
      
      HRDATAS4      : in  std_logic_vector(31 downto 0);
      HREADYS4      : in  std_logic;
      HRESPS4       : in  std_logic_vector(1 downto 0);
      
      HRDATAS5      : in  std_logic_vector(31 downto 0);
      HREADYS5      : in  std_logic;
      HRESPS5       : in  std_logic_vector(1 downto 0);
      
      HRDATAS6      : in  std_logic_vector(31 downto 0);
      HREADYS6      : in  std_logic;
      HRESPS6       : in  std_logic_vector(1 downto 0);
      
      HRDATAS7      : in  std_logic_vector(31 downto 0);
      HREADYS7      : in  std_logic;
      HRESPS7       : in  std_logic_vector(1 downto 0);
      
      HREADYDefault : in  std_logic;
      HRESPDefault  : in  std_logic_vector(1 downto 0);
      
      HRDATA        : out std_logic_vector(31 downto 0);
      HREADY        : out std_logic;
      HRESP         : out std_logic_vector(1 downto 0);

      -- Scan test dummy signals; not connected until scan insertion 
      SCANENABLE    : in  std_logic; -- Scan Test Mode Enbl
      SCANINHCLK    : in  std_logic; -- Scan Chain Input
      SCANOUTHCLK   : out std_logic  -- Scan Chain Output
      );
  end component;


--------------------------------------------------------------------------------
-- Signal declarations: AHB
--------------------------------------------------------------------------------

-- Local AHB backbone
  signal iHADDR    : std_logic_vector(31 downto 0);
  signal iHTRANS   : std_logic_vector(1 downto 0);
  signal iHWRITE   : std_logic;
  signal iHSIZE    : std_logic_vector(2 downto 0);
  signal iHBURST   : std_logic_vector(2 downto 0);
  signal iHPROT    : std_logic_vector(3 downto 0);
  signal iHWDATA   : std_logic_vector(31 downto 0);
  signal iHLOCK    : std_logic;

-- Multiplexed Local slave output signals
  signal iHREADY   : std_logic;
  signal iHRESP    : std_logic_vector(1 downto 0);
  signal iHRDATA   : std_logic_vector(31 downto 0);

-- Local Slave specific output signals
  signal HSELS0B   : std_logic;
  signal HSELS0R   : std_logic;

  signal HSELS0    : std_logic;
  signal HRDATAS0  : std_logic_vector(31 downto 0);
  signal HREADYS0  : std_logic;
  signal HRESPS0   : std_logic_vector(1 downto 0);

  signal HSELS1    : std_logic;
  signal HRDATAS1  : std_logic_vector(31 downto 0);
  signal HREADYS1  : std_logic;
  signal HRESPS1   : std_logic_vector(1 downto 0);

  signal HSELS2    : std_logic;
  signal HRDATAS2  : std_logic_vector(31 downto 0);
  signal HREADYS2  : std_logic;
  signal HRESPS2   : std_logic_vector(1 downto 0);

  signal HSELS3    : std_logic;
  signal HRDATAS3  : std_logic_vector(31 downto 0);
  signal HREADYS3  : std_logic;
  signal HRESPS3   : std_logic_vector(1 downto 0);

  signal HSELS4    : std_logic;
  signal HRDATAS4  : std_logic_vector(31 downto 0);
  signal HREADYS4  : std_logic;
  signal HRESPS4   : std_logic_vector(1 downto 0);

  signal HSELS5    : std_logic;
  signal HRDATAS5  : std_logic_vector(31 downto 0);
  signal HREADYS5  : std_logic;
  signal HRESPS5   : std_logic_vector(1 downto 0);

  signal HSELS6    : std_logic;
  signal HRDATAS6  : std_logic_vector(31 downto 0);
  signal HREADYS6  : std_logic;
  signal HRESPS6   : std_logic_vector(1 downto 0);

  signal HSELS7    : std_logic;
  signal HRDATAS7  : std_logic_vector(31 downto 0);
  signal HREADYS7  : std_logic;
  signal HRESPS7   : std_logic_vector(1 downto 0);

  signal HSELS8    : std_logic;
  signal HSELS9    : std_logic;
  signal HSELS10   : std_logic;
  signal HSELS11   : std_logic;
  signal HSELS12   : std_logic;
  signal HSELS13   : std_logic;
  signal HSELS14   : std_logic;
  signal HSELS15   : std_logic;

  signal HSELDefault   : std_logic;
  signal HREADYDefault : std_logic;
  signal HRESPDefault  : std_logic_vector(1 downto 0);

-- Miscellaneous signals

  signal HSELSmi    : std_logic;
  signal HSELIntMem : std_logic;

  signal iHBUSREQ : std_logic; -- Not used
  signal iHGRANTM : std_logic; -- Grants the core when not paused

  signal iHREADYOUTtst : std_logic; -- HREADY for TIC port


--------------------------------------------------------------------------------
-- Signal declarations: Scan chain
--------------------------------------------------------------------------------

  signal SCANINmuxs2m  : std_logic;
  signal SCANOUTmuxs2m : std_logic;

  signal SCANINa922t   : std_logic;
  signal SCANOUTa922t  : std_logic;


--------------------------------------------------------------------------------
-- Signal declarations: Tie-offs
--------------------------------------------------------------------------------

  signal TieOffHi1  : std_logic;
  signal TieOffLo1  : std_logic;
  signal TieOffLo2  : std_logic_vector(1 downto 0);
  signal TieOffLo32 : std_logic_vector(31 downto 0);


--------------------------------------------------------------------------------
-- Beginning of main code
--------------------------------------------------------------------------------

begin

-- The TieOff signals must be assigned explicitly within the body of the VHDL.
-- Using initial values (in the signal declaration, above) will not work in
--  Synopsys. Signals are used rather than constants as constants can not be 
--  connected directly to sub-component instantiations
  TieOffHi1  <= '1';
  TieOffLo1  <= '0';
  TieOffLo2  <= "00";
  TieOffLo32 <= (others => '0');


-- ARM922T core wrapper, instantiated as Local AHB master 1 (lowest priority).
-- The Test interface is connected to the TIC via a seperate AHB test bus
  uARM922T : A922T
    port map(
      -- Signals used during normal operation and test mode
      HCLK       => HCLK,
      HRESETn    => HRESETn,

      -- Signals from AMBA bus used during normal operation
      HRDATAM    => iHRDATA,
      HREADYM    => iHREADY,
      HRESPM     => iHRESP,
      HGRANTM    => iHGRANTM,

      -- Signals to Local AMBA bus used during normal operation
      HADDRM     => iHADDR,
      HTRANSM    => iHTRANS,
      HWRITEM    => iHWRITE,
      HSIZEM     => iHSIZE,
      HBURSTM    => iHBURST,
      HPROTM     => iHPROT,
      HWDATAM    => iHWDATA,
      HBUSREQM   => iHBUSREQ,  -- Not used (no other master)
      HLOCKM     => iHLOCK,

      -- Signals from AMBA bus used during test mode
      HADDRS     => HADDRtst,
      HTRANS1S   => HTRANStst(1),
      HWRITES    => HWRITEtst,
      HWDATAS    => HWDATAtst,
      HSELS      => HSELtst,
      HREADYS    => iHREADYOUTtst,  -- HREADYOUT (test) is fed-back

      -- Signals to AMBA bus used during test mode
      HRDATAS    => HRDATAtst,
      HREADYOUTS => iHREADYOUTtst,
      HRESPS     => HRESPtst,

      -- Fast Cache clock
      FCLK       => FCLK,

      -- ARM interrupts
      ARMNFIQ    => nFIQ,
      ARMNIRQ    => nIRQ,

      -- Comms channel signals
      COMMRX     => COMMRX,
      COMMTX     => COMMTX,

      -- JTAG connections
      nTRST      => nTRST,
      TCK        => TCK,
      TDI        => TDI,
      TMS        => TMS,
      nTDOEN     => nTDOEN,
      TDO        => TDO,

      -- Scan signals
      SCANENABLE    => SCANENABLE,
      SCANINHCLK    => SCANINa922t,
      SCANOUTHCLK   => SCANOUTa922t
      );

  -- Connect internal signal to port
  HREADYOUTtst <= iHREADYOUTtst;

  -- ARM922T is the only bus master, so provide grant when not paused
  iHGRANTM <= not Pause;


-- Internal Memory instantiated as Local AHB slave 0
  uIntMem : IntMem
    -- pragma synthesis_off
    generic map(
      -- These map to the top level generics      
      MemBits    => IntMemAddrWidth,
      FileName   => IntMemInitFile
      )
    -- pragma synthesis_on
    port map(
      HCLK       => HCLK,
      HRESETn    => HRESETn,

      HSELIntMem => HSELIntMem,

      HADDR      => iHADDR,
      HTRANS     => iHTRANS,
      HWRITE     => iHWRITE,
      HSIZE      => iHSIZE,
      HWDATA     => iHWDATA,
      HREADY     => iHREADY,

      HRDATA     => HRDATAS0,
      HREADYOUT  => HREADYS0,
      HRESP      => HRESPS0
      );


-- Local Address Decoder
  uDecoder : Decoder
    port map(
      HADDR   => iHADDR(31 downto 20),

      Remap   => Remap,

      HSELS0B => HSELS0B,
      HSELS0R => HSELS0R,
      HSELS0  => HSELS0,
      HSELS1  => HSELS1,
      HSELS2  => HSELS2,
      HSELS3  => HSELS3,
      HSELS4  => HSELS4,
      HSELS5  => HSELS5,
      HSELS6  => HSELS6,
      HSELS7  => HSELS7,
      HSELS8  => HSELS8,
      HSELS9  => HSELS9,
      HSELS10 => HSELS10,
      HSELS11 => HSELS11,
      HSELS12 => HSELS12,
      HSELS13 => HSELS13,
      HSELS14 => HSELS14,
      HSELS15 => HSELS15
      );

  -- SMI occupies Slot 3 or Slot 0 (at boot) 
  HSELSmi <= HSELS0B or HSELS3;

  -- Internal Memory occupies Slot 7 and Slot 0 (after re-map)
  HSELIntMem <= HSELS7 or HSELS0R;

  -- Drive the BusMatrix select signal accordingly when the Default Slave,
  --  SMI, APB Peripherals, Retry Slave or Interrupt Controller is accessed 
  HSELmtrx <= HSELDefault or HSELSmi or HSELS12 or HSELS13 or HSELS15;

  -- Default Slave (the BusMatrix) selected by all unused HSEL lines
  HSELDefault <=
    -- HSELS0B or
    -- HSELS0R or                      -- IntMem alias
    HSELS0 or
    HSELS1 or
    HSELS2 or
    -- HSELS3 or                       -- SMI
    HSELS4 or
    HSELS5 or
    HSELS6 or
    -- HSELS7 or                       -- IntMem
    HSELS8 or
    HSELS9 or
    HSELS10 or
    HSELS11 or
    -- HSELS12 or                      -- APB Peripherals
    -- HSELS13 or                      -- Retry Slave
    HSELS14
    -- or HSELS15                      -- Interrupt Controller
    ;


-- Local multiplexer - slaves to masters
--  This 8-input multiplexor is used in place of the 16-input version 
--  because it is faster to synthesise. However, in this application,
--  the input channel names do not always match the names of the signals
--  they are assigned to, though the multiplexor operation is unaffected.
  uMuxS2M : MuxS2M
    port map(
      HCLK          => HCLK,
      HRESETn       => HRESETn,

      HSELS0        => HSELIntMem,     -- Decoder slots 0 (re-map) and 7
      HSELS1        => HSELS12,        -- Decoder slot 12
      HSELS2        => HSELS13,        -- Decoder slot 13
      HSELS3        => HSELS15,        -- Decoder slot 15
      HSELS4        => HSELSmi,        -- Decoder slots 0 (boot) and 3
      HSELS5        => TieOffLo1,
      HSELS6        => TieOffLo1,
      HSELS7        => TieOffLo1,
      HSELDefault   => HSELDefault,

      HRDATAS0      => HRDATAS0,       -- Internal Memory (Local slave)
      HREADYS0      => HREADYS0,
      HRESPS0       => HRESPS0,

      HRDATAS1      => HRDATAS1,       -- AHB to APB Bridge
      HREADYS1      => HREADYS1,       --  (via matrix Outport 2)
      HRESPS1       => HRESPS1,

      HRDATAS2      => HRDATAS2,       -- Retry Slave
      HREADYS2      => HREADYS2,       --  (via matrix Outport 0)
      HRESPS2       => HRESPS2,

      HRDATAS3      => HRDATAS3,       -- Interrupt Controller
      HREADYS3      => HREADYS3,       --  (via matrix Outport 1) 
      HRESPS3       => HRESPS3,

      HRDATAS4      => HRDATAS4,       -- SMI
      HREADYS4      => HREADYS4,       --  (via matrix Outport 0)
      HRESPS4       => HRESPS4,

      HRDATAS5      => HRDATAS5,
      HREADYS5      => HREADYS5,
      HRESPS5       => HRESPS5,

      HRDATAS6      => HRDATAS6,
      HREADYS6      => HREADYS6,
      HRESPS6       => HRESPS6,

      HRDATAS7      => HRDATAS7,
      HREADYS7      => HREADYS7,
      HRESPS7       => HRESPS7,

      HREADYDefault => HREADYDefault,
      HRESPDefault  => HRESPDefault,

      HRDATA        => iHRDATA,        -- Connected to the ARM922T core
      HREADY        => iHREADY,
      HRESP         => iHRESP,

      -- Scan signals
      SCANENABLE    => SCANENABLE,
      SCANINHCLK    => SCANINmuxs2m,
      SCANOUTHCLK   => SCANOUTmuxs2m
      );


-- The following slaves are external to this module and must be connected
--  to the BusMatrix

  HRDATAS1 <= HRDATAmtrx;              -- APB Peripherals
  HREADYS1 <= HREADYmtrx;              --  (via matrix Outport 2)
  HRESPS1  <= HRESPmtrx;

  HRDATAS2 <= HRDATAmtrx;              -- Response slave 
  HREADYS2 <= HREADYmtrx;              --  (via matrix Outport 0)
  HRESPS2  <= HRESPmtrx;

  HRDATAS3 <= HRDATAmtrx;              -- Interrupt controller
  HREADYS3 <= HREADYmtrx;              --  (via matrix Outport 1)
  HRESPS3  <= HRESPmtrx;

  HRDATAS4 <= HRDATAmtrx;              -- SMI
  HREADYS4 <= HREADYmtrx;              --  (via matrix Outport 0)
  HRESPS4  <= HRESPmtrx;


-- The BusMatrix is also the Default Slave
  HREADYDefault <= HREADYmtrx;
  HRESPDefault  <= HRESPmtrx;


-- Tie-off the unused channels of MuxS2M

  -- Tie off HRDATA for unused slave ports
  -- HRDATAS0 <= TieOffLo32;           -- IntMem
  -- HRDATAS1 <= TieOffLo32;           -- APB Peripherals
  -- HRDATAS2 <= TieOffLo32;           -- Retry Slave
  -- HRDATAS3 <= TieOffLo32;           -- Interrupt Controller
  -- HRDATAS4 <= TieOffLo32;           -- SMI
  HRDATAS5 <= TieOffLo32;
  HRDATAS6 <= TieOffLo32;
  HRDATAS7 <= TieOffLo32;

  -- Tie off HREADY for unused slave ports
  -- HREADYS0 <= TieOffHi1;            -- IntMem
  -- HREADYS1 <= TieOffHi1;            -- APB Peripherals
  -- HREADYS2 <= TieOffHi1;            -- Retry Slave
  -- HREADYS3 <= TieOffHi1;            -- Interrupt Controller
  -- HREADYS4 <= TieOffHi1;            -- SMI
  HREADYS5 <= TieOffHi1;
  HREADYS6 <= TieOffHi1;
  HREADYS7 <= TieOffHi1;

  -- Tie off HRESP for unused slave ports
  -- HRESPS0 <= TieOffLo2;             -- IntMem
  -- HRESPS1 <= TieOffLo2;             -- APB Peripherals
  -- HRESPS2 <= TieOffLo2;             -- Retry Slave
  -- HRESPS3 <= TieOffLo2;             -- Interrupt Controller
  -- HRESPS4 <= TieOffLo2;             -- SMI
  HRESPS5 <= TieOffLo2;
  HRESPS6 <= TieOffLo2;
  HRESPS7 <= TieOffLo2;


-- Connect the Local AHB backbone to the module interface
  HADDR     <= iHADDR;
  HTRANS    <= iHTRANS;
  HWRITE    <= iHWRITE;
  HSIZE     <= iHSIZE;
  HBURST    <= iHBURST;
  HPROT     <= iHPROT;
  HWDATA    <= iHWDATA;
  HMASTLOCK <= iHLOCK;
  HREADYOUT <= iHREADY;


end structural;

-- --================================= End ===================================--

