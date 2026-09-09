--------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : RtcTrick.vhd.rca
--  File Revision          : 1.9
--  
--  Release Information    : PrimeCell(TM)-PL031-REL1v0
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose  : The Rtc trickbox module performs the following functions: 
--             - Generates the CLK1HZ signal to the Rtc.
--             - Generates the ScanMode signal to the Rtc.
--
--------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

entity RtcTrick is
  port (
       -- APB bus signals
        PCLK        : in    std_logic;    -- APB Clock
        PRESETn     : in    std_logic;    -- AMBA reset
        PENABLE     : in    std_logic;    -- APB enable 
        PSELT       : in    std_logic;    -- Trickbox select 
        PWRITE      : in    std_logic;    -- APB write 
        PADDR       : in    std_logic_vector(7 downto 2);
                                          -- APB address bus
        PWData      : in    std_logic_vector(15 downto 0);
                                          -- APB write databus
        RTCINTR     : in    std_logic;    -- RTC interrupt from UUT
        PRData      : out   std_logic_vector(15 downto 0);
                                          -- APB read databus
        CLK1HZ      : out   std_logic;    -- CLK1HZ signal
        nRTCRST     : out   std_logic;    -- RTC reset signal
        nPOR        : out   std_logic;    -- RTC power on reset signal
        SCANMODE    : out   std_logic     -- SCANMODE control
       );
end RtcTrick;

-- -----------------------------------------------------------------------------
--
--                             RtcTrick
--                             ========
--
-- -----------------------------------------------------------------------------
--
-- Overview
-- ========
-- CLK1HZ and SCANMODE, the external inputs to the RTC, are generated in this
-- module. The width of the high phase of the CLK1HZ signal is programmable
-- through the RTCLK1HZH register and the width of the low phase is programmable
-- through the RTCLK1HZL register. The SCANMODE signal can be set by writing a 1
-- into the bit 0 of RTCR register. The CLK1HZ signal is enabled by setting the
-- bit 1 of the RTCR register. The Synchronized CLK1HZ signal can be read at the
-- bit position 0 of the RTSR register.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--   RTC Trickbox Registers
--   ======================
--   RTCR       0x00    2  R/W  Control Register
--   RTSR       0x04    1  R    CLK1HZ Status Register
--   RTCLK1HZH  0x08   16  R/W  CLK1HZ High Phase Control Register
--   RTCLK1HZL  0x0C   16  R/W  CLK1HZ Low Phase Control Register 
-- 
--===========================ARCHITECTURE=======================================
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------

architecture synth of RtcTrick is

--------------------------------------------------------------------------------
-- Signal declarations
--------------------------------------------------------------------------------

-- Decodes for internal registers
signal RTCRdec           : std_logic;
-- Decode for Trickbox Control Register

signal RTSRdec           : std_logic;
-- Decode for Trickbox Status Register

signal RTCLK1HZHdec      : std_logic;
-- Decode for RTCLK1HZH register

signal RTCLK1HZLdec      : std_logic;
-- Decode for RTCLK1HZL register

signal RTCRrd            : std_logic;
-- Read enable for RTCR

signal RTCRwr            : std_logic;
-- Write enable for RTCR

signal RTSRrd            : std_logic;
-- Read enable for RTSR


signal RTCLK1HZHrd       : std_logic;
-- Read enable for RTCLK1HZH register

signal RTCLK1HZHwr       : std_logic;
-- Write enable for RTCLK1HZH register

signal RTCLK1HZLrd       : std_logic;
-- Read enable for RTCLK1HZL register

signal RTCLK1HZLwr       : std_logic;
-- Write enable for RTCLK1HZL register

signal NextRTCR          : std_logic_vector(1 downto 0);
-- D-input for RTCR

signal RTCR              : std_logic_vector(1 downto 0);
-- Trickbox Control Register

signal NextRTCLK1HZH     : std_logic_vector(15 downto 0);
-- D-input for RTCLK1HZH

signal RTCLK1HZH         : std_logic_vector(15 downto 0) := "0000000000000001";
-- RTCLK1HZH register

signal NextRTCLK1HZL     : std_logic_vector(15 downto 0);
-- D-input for RTCLK1HZL

signal RTCLK1HZL         : std_logic_vector(15 downto 0) := "0000000000000000";
-- RTCLK1HZL register

signal NextSyncCLK1HZ    : std_logic;
-- D-input for SyncCLK1HZ 

signal SyncCLK1HZ        : std_logic;
-- SyncCLK1HZ register

signal iCLK1HZ           : std_logic;
-- Internal CLK1HZ

signal CLK1HZH           : time := 2 ns;
-- CLK1HZ high phase width in ns

signal CLK1HZL           : time := 2 ns;
-- CLK1HZ low phase width in ns

signal RTINTRrd          : std_logic;
-- Read enable for RTINTR, interrupt identification register

signal RTINTRdec         : std_logic;
-- Decode signal for RTINTR register

signal RTINTR            : std_logic_vector(15 downto 0);
-- Trickbox INTR Reg

signal NextRTINTR        : std_logic_vector(15 downto 0);
-- D-input for Trickbox Interrupt Reg

signal Sync1PRESETn      : std_logic;
-- Single delayed PRESETn

signal Sync2PRESETn      : std_logic;
-- Double delayed PRESETn

signal iSCANMODE         : std_logic;
-- Local copy of SCANMODE

signal ReadFill          : std_logic_vector(15 downto 0);
-- Read Fill Vector
  
--------------------------------------------------------------------------------
-- Function declaration 
--------------------------------------------------------------------------------
-- Function to convert a std_ulogic_vector value into an integer. This is 
-- required to convert the programmed CLK1HZ phase values into integers.
--------------------------------------------------------------------------------
function to_integer (val : std_ulogic_vector; x : integer := 0)
  return integer is
   variable return_int, x_tmp : integer;
begin
  return_int := 0;
  x_tmp := 0;
  if x /= 0 then
    x_tmp := 1;
  end if;
  for i in val'range loop
    return_int := return_int + return_int;
    case val(i) is
      when '0' =>     null;
      when '1' =>     return_int := return_int + 1;
      when others =>  return_int := return_int + x_tmp;
    end case;
  end loop;
  return return_int;
end to_integer;

--------------------------------------------------------------------------------
--
-- Main body of code 
-- =================
--
--------------------------------------------------------------------------------

begin

-- Assign Read Fill Vector
ReadFill <= (others => '0');
  
-- -----------------------------------------------------------------------------
-- CLK1HZ signal generation based on status of bit 1 of RTCR register
-- -----------------------------------------------------------------------------
CLK1HZ   <= iCLK1HZ when (RTCR(1) = '1') 
         else
            '0';

-- -----------------------------------------------------------------------------
-- Conversion of values written into RTCLK1HZH and RTCLK1HZL into nanoseconds
-- -----------------------------------------------------------------------------
CLK1HZH  <= (to_integer(to_stdulogicvector(RTCLK1HZH))) * 1 ns;
CLK1HZL  <= (to_integer(to_stdulogicvector(RTCLK1HZL))) * 1 ns;

-- -----------------------------------------------------------------------------
-- Address Decodes
-- -----------------------------------------------------------------------------
RTCRdec      <= '1' when (PADDR(4 downto 2) = "000") 
             else
                '0';
RTCRrd       <= PSELT and PENABLE and (not PWRITE) and RTCRdec;
RTCRwr       <= PSELT and PENABLE and (PWRITE) and RTCRdec;

RTSRdec      <= '1' when (PADDR(4 downto 2) = "001") 
             else
                '0';
RTSRrd       <= PSELT and PENABLE and (not PWRITE) and RTSRdec;

RTCLK1HZHdec <= '1' when (PADDR(4 downto 2) = "010")
             else
                '0';
RTCLK1HZHrd  <= PSELT and PENABLE and (not PWRITE) and RTCLK1HZHdec;
RTCLK1HZHwr  <= PSELT and PENABLE and (PWRITE) and RTCLK1HZHdec;

RTCLK1HZLdec <= '1' when (PADDR(4 downto 2) = "011")
             else
                '0';
RTCLK1HZLrd  <= PSELT and PENABLE and (not PWRITE) and RTCLK1HZLdec;
RTCLK1HZLwr  <= PSELT and PENABLE and (PWRITE) and RTCLK1HZLdec;

RTINTRdec    <= '1' when (PADDR(4 downto 2) = "100")
             else
                '0';

RTINTRrd     <= PSELT and PENABLE and (not PWRITE) and RTINTRdec;

NextRTINTR   <= "000000000000000" & RTCINTR;

-- -----------------------------------------------------------------------------
-- Implementation of TrickBox Control Register (RTCR)
-- -----------------------------------------------------------------------------
p_RTCRComb : process (RTCR, PWData, RTCRwr)
begin
  if (RTCRwr = '1') then
    NextRTCR <= PWData(1 downto 0);
  else
    NextRTCR <= RTCR;
  end if;
end process p_RTCRComb;

p_RTCRSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    RTCR <= (others => '0');
  elsif (PCLK'event and PCLK = '1') then
    RTCR <= NextRTCR;
  end if;
end process p_RTCRSeq;

-- -----------------------------------------------------------------------------
-- Implementation of TrickBox CLK1HZ High-phase Register (RTCLK1HZH)
-- -----------------------------------------------------------------------------
p_RTCLK1HZHComb : process (RTCLK1HZH, PWData, RTCLK1HZHwr)
begin
  if (RTCLK1HZHwr = '1') then
    NextRTCLK1HZH <= PWData;
  else
    NextRTCLK1HZH <=RTCLK1HZH;
  end if;
end process p_RTCLK1HZHComb;

p_RTCLK1HZHSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    RTCLK1HZH <= "0000000000000001"; 
  elsif (PCLK'event and PCLK = '1') then
    RTCLK1HZH <= NextRTCLK1HZH;
  end if;
end process p_RTCLK1HZHSeq;

-- -----------------------------------------------------------------------------
-- Implementation of TrickBox CLK1HZ Low-phase Register (RTCLK1HZL)
-- -----------------------------------------------------------------------------
p_RTCLK1HZLComb : process (RTCLK1HZL, PWData, RTCLK1HZLwr)
begin
  if (RTCLK1HZLwr = '1') then
    NextRTCLK1HZL <= PWData;
  else
    NextRTCLK1HZL <= RTCLK1HZL;
  end if;
end process p_RTCLK1HZLComb;

p_RTCLK1HZLSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    RTCLK1HZL <= "0000000000000001"; 
  elsif (PCLK'event and PCLK = '1') then
    RTCLK1HZL <= NextRTCLK1HZL;
  end if;
end process p_RTCLK1HZLSeq;

-- -----------------------------------------------------------------------------
-- Synchronize CLK1HZ to the posedge edge of the PCLK 
-- to create SyncCLK1HZ. This signal will be readable at
-- bit position 0 of the RTSR.
-- -----------------------------------------------------------------------------
p_SyncCLK1HZComb : process (RTCR, iCLK1HZ)
begin
  if (RTCR(1) = '1') then
    NextSyncCLK1HZ <= iCLK1HZ;
  else
    NextSyncCLK1HZ <= '0';
  end if;
end process p_SyncCLK1HZComb;

p_SyncCLK1HZSeq : process (PCLK, PRESETn)
begin
  if (PRESETn = '0') then
    SyncCLK1HZ <= '0';
  elsif (PCLK'event and PCLK = '1') then
    SyncCLK1HZ <= NextSyncCLK1HZ;
  end if;
end process p_SyncCLK1HZSeq;

-- -----------------------------------------------------------------------------
-- Generate the CLK1HZ signal using the programmed phase values
-- -----------------------------------------------------------------------------
p_CLockGenComb : process
begin
  iCLK1HZ <= '0';
  wait for CLK1HZL;
  iCLK1HZ <= '1';
  wait for CLK1HZH;
end process p_ClockGenComb;

-- -----------------------------------------------------------------------------
-- Output register. THis register stores the current status of UUT interrupt
-- pin.
-- -----------------------------------------------------------------------------
p_IntSeq : process (PCLK, PRESETn)
  begin
    if(PRESETn = '0') then
      RTINTR   <= (others => '0');
    elsif(PCLK'event and PCLK = '1') then
      RTINTR   <= NextRTINTR;
    end if;
  end process p_IntSeq;

  
-- -----------------------------------------------------------------------------
-- The SCANMODE pin is controlled via writes to bit 0 of the RTCR.
-- -----------------------------------------------------------------------------
iSCANMODE <= RTCR(0) ;
SCANMODE  <= iSCANMODE;
  
-- -----------------------------------------------------------------------------
-- RTC Reset signal generation
-- -----------------------------------------------------------------------------
p_ResetComb : process (iSCANMODE, PRESETn, Sync2PRESETn)
  begin
    if(iSCANMODE = '1') then
      nRTCRST <= PRESETn;
    else
      nRTCRST <= Sync2PRESETn;
   end if;
end process p_ResetComb;

p_ResetSeq : process (iCLK1HZ, PRESETn)
  begin
    if(PRESETn = '0') then
      Sync1PRESETn <= '0';
      Sync2PRESETn <= '0';
    elsif(iCLK1HZ'event and iCLK1HZ = '1') then
      Sync1PRESETn <= PRESETn;
      Sync2PRESETn <= Sync1PRESETn;
    end if;
end process p_ResetSeq;

-- -----------------------------------------------------------------------------
-- RTC Power on Reset signal generation
-- -----------------------------------------------------------------------------
p_nPORComb : process (iSCANMODE, PRESETn, Sync2PRESETn)
  begin
    if(iSCANMODE = '1') then
      nPOR <= PRESETn;
    else
      nPOR <= Sync2PRESETn;
    end if;
end process p_nPORComb;

-- -----------------------------------------------------------------------------
-- Mux out Read Data onto the APB
-- -----------------------------------------------------------------------------
PRData  <= (ReadFill(15 downto 2) & RTCR)        when (RTCRrd = '1')
        else
           (ReadFill(15 downto 1) & SyncCLK1HZ)  when (RTSRrd = '1')
        else
           RTCLK1HZH                             when (RTCLK1HZHrd = '1')
        else 
           RTCLK1HZL                             when (RTCLK1HZLrd = '1')
        else
           RTINTR                                when (RTINTRrd = '1')
        else   
            ReadFill;


end synth;

--============================ End of RtcTrick ===============================--
