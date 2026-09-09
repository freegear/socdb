-- --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--  ----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : CLTrProtCheck.vhd.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
--  ----------------------------------------------------------------------------

--  ----------------------------------------------------------------------------
--  Purpose : CLCD Trickbox Panel Protocol Checker
--
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_arith.all;

library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_developerskit.std_IOpak.all;


-- -----------------------------------------------------------------------------

entity CLTrProtCheck is
  port (
        CLCLK             : in std_logic;  
        -- CLCD Clock
        HRESETN           : in std_logic;  
        -- AHB System reset (active low)
        CLTrEn            : in std_logic;  
        -- CLCD Trickbox Enable
        CLTrIntrTest      : in std_logic;
        -- CLCD Trickbox interupt test bit
        CLTrFUFIntrTst    : in std_logic;
        -- CLCD Trickbox interupt test bit
        CLPOWER           : in std_logic;  
        -- From CLCD Contr. Power enable
        LcdEn             : in std_logic;  
        -- CLCD enalbe signal
        CLFP              : in std_logic;  
        -- From CLCD Contr. : Frame Sync Pulse
        CLLP              : in std_logic;  
        -- From CLCD Contr. : Line Sync Pulse
        CLCP              : in std_logic;  
        -- From CLCD Contr. : Pixel Clock
        CLAC              : in std_logic;  
        -- From CLCD Contr. : STN AC bias drive or TFT data Enable output
        CLLE              : in std_logic;  
        -- From CLCD Contr. : Line End Signal
        TFT               : in std_logic;  
        -- If 1 denotes TFT mode, else STN mode
        PCD               : in std_logic_vector(9 downto 0); 
        -- Panel Clock Divisor
        HSW               : in std_logic_vector(7 downto 0); 
        -- Horizontal Sync Pulse Width
        HFP               : in std_logic_vector(7 downto 0); 
        -- Horizontal Front Porch
        HBP               : in std_logic_vector(7 downto 0); 
        -- Horizontal Back Porch
        LPP               : in std_logic_vector(9 downto 0); 
        -- Line Per Panel
        VSW               : in std_logic_vector(5 downto 0); 
        -- Vertical Sync Pulse Width
        VFP               : in std_logic_vector(7 downto 0); 
        -- Vertical Front Porch
        VBP               : in std_logic_vector(7 downto 0); 
        -- Vertical Back Porch
        ACB               : in std_logic_vector(4 downto 0); 
        -- AC Bias Pin Frequency
        IVS               : in std_logic; 
        -- Invert VSync
        IHS               : in std_logic; 
        -- Invert HSync
        IPC               : in std_logic; 
        -- Invert Panel Clock
        IEO               : in std_logic; 
        -- Invert Output Enable
        CPL               : in std_logic_vector(9 downto 0); 
        -- Clocks Per Line
        BCD               : in std_logic; 
        -- ByPass Pixel Clock Divisor
        LED               : in std_logic_vector(6 downto 0); 
        -- Line End Delay
        LEE               : in std_logic; 
        -- Line End Enable
        Check             : out std_logic; 
        -- CLCP at Active Region : To provide Data Checking module a clock 
        -- trigger to check the CLCD Data
        CLTrBaseUpdate    : out std_logic; 
        -- CLCD Trickbox Base Update Request Signal
        -- Loads the Address Counters in CLCDIf module by their respective base
        -- addresses for Address Check up.
        VCOMPINTRout      : in std_logic;  
        -- From Reg block
        LNBUINTRout       : in std_logic;         
        -- From Reg block
        VSYNCState : out std_logic_vector(2 downto 0);
        -- state variable fo VSYNC
        VComp             : in std_logic_vector(1 downto 0)  
        -- From Reg block
       );
end CLTrProtCheck;

-- -----------------------------------------------------------------------------
--
--                             CLTrProtCheck
--                             =============
--
-- -----------------------------------------------------------------------------
--
-- Overview:
-- ========
-- This module is responsible for Protocol Checking of the CLCD Panel Signals.
-- This module includes:
-- - Input signal formating block
-- - VSync, HSync and CLCP check Block
-- - CLLE Check Block
-- - CLAC Check Block
-- - Free-running PCLK Check Block in TFT mode
-- - Check (for CLD Check) Signal generation
-- -----------------------------------------------------------------------------

--============================== ARCHITECTURE ================================--
--
--------------------------------------------------------------------------------
-- Architecture Packages
--------------------------------------------------------------------------------
 
architecture behavioural of CLTrProtCheck is
 
-- -----------------------------------------------------------------------------
-- Constant declarations
-- -----------------------------------------------------------------------------
-- States in the State Machine
constant ST_IDL          : std_logic_vector(2 downto 0) :="000";
constant ST_VSW          : std_logic_vector(2 downto 0) :="001";
constant ST_VBP          : std_logic_vector(2 downto 0) :="010";
constant ST_VACTIVE      : std_logic_vector(2 downto 0) :="011";
constant ST_VFP          : std_logic_vector(2 downto 0) :="100";
constant ST_HSW          : std_logic_vector(2 downto 0) :="001";
constant ST_HBP          : std_logic_vector(2 downto 0) :="010";
constant ST_HACTIVE      : std_logic_vector(2 downto 0) :="011";
constant ST_HFP          : std_logic_vector(2 downto 0) :="100";
constant ST_PCLKON       : std_logic_vector(2 downto 0) :="001";
constant ST_PCLKOFF      : std_logic_vector(2 downto 0) :="010";
constant ST_LED          : std_logic_vector(2 downto 0) :="001";
constant ST_CLLE         : std_logic_vector(2 downto 0) :="010";
constant ST_CLACON       : std_logic_vector(2 downto 0) :="001";
constant ST_CLACOFF      : std_logic_vector(2 downto 0) :="010";

-- Width of counters
constant HCOUNTSIZ       : integer := 11;
constant CCOUNTSIZ1      : integer := 23;
constant CCOUNTSIZ       : integer := 11;
constant CPLSIZ          : integer := 11;
constant LECOUNTSIZ      : integer := 8;
constant ACCOUNTSIZ      : integer := 32;

-- What to do on ERROR : Exit or Continue
-- --------------------------------------
constant ERR_EXIT        : std_logic                    := '0';
-- If this is defined as 1 it will exit simulation when error occures
-- or else it will just display error messege as Error Exit

constant IMAGE           : std_logic                    := '0';
-- If this is defined as 1 it will test for image test

constant ALLZEROS        : std_logic_vector(31 downto 0) 
                            := "00000000000000000000000000000000";
-- This declares the all zeros in the 32 bits

-- -----------------------------------------------------------------------------
-- Signal declarations
-- -----------------------------------------------------------------------------
-- Internal Wires:
-- --------------
signal iVSYNCState       : std_logic_vector(2 downto 0);
-- 

signal VSYNC             : std_logic;
-- Vertical Sync : Active HIGH version CLFP

signal HSYNC             : std_logic;
-- Horizontal Sync : Active HIGH version CLLP

signal PCLK              : std_logic;
-- Panel Clock : Active HIGH version CLCP

signal AC                : std_logic;
-- CLCD AC Signal : Active HIGH version CLAC

-- Values to compare
-- -----------------

signal HSWValue           : std_logic_vector((CCOUNTSIZ1 - 1) downto 0);
-- HSW Value

signal HBPValue           : std_logic_vector((CCOUNTSIZ1 - 1) downto 0);
-- HBP Value

signal HACTIVEValue       : std_logic_vector((CCOUNTSIZ1 - 1) downto 0);
-- HACTIVE Value

signal HFPValue           : std_logic_vector((CCOUNTSIZ1 - 1) downto 0);
-- HFP Value

signal PCLKValue          : std_logic_vector((CCOUNTSIZ - 1) downto 0);
-- Panel Clock Period

signal CPLValue           : std_logic_vector((CPLSIZ - 1) downto 0);
-- Clocks per line counter

signal CLACValue          : std_logic_vector((ACCOUNTSIZ - 1) downto 0);
-- CLAC half period Value

-- Internal Signal
-- ---------------
signal Active             : std_logic;
-- Denotes the Active region of display = VACTIVE AND HACTIVE

signal IntActive          : std_logic;
-- Denotes the Internal version of the Active signal

signal IntCheck           : std_logic;
-- Denotes the the Internal version of the check signal  

signal CLLECheck          : std_logic;
-- Denotes the time when CLLE checking can be started.

-- -----------------------------------------------------------------------------
-- Register declarations
-- -----------------------------------------------------------------------------

-- State Variables
-- ---------------

signal HSYNCState         : std_logic_vector(2 downto 0);
-- HSYNC State Variable

signal PCLKState          : std_logic_vector(2 downto 0);
-- PCLK State Variable in TFT mode 

signal PCLKState1         : std_logic_vector(2 downto 0);
-- PCLK State Variable 1 in Active region

signal CLLEState          : std_logic_vector(2 downto 0);
-- CLLE State Variable 

signal CLACState          : std_logic_vector(2 downto 0);
-- CLAC State Variable

signal CLLEFlag           : std_logic;
-- CLLE Check flag

-- Counters
-- --------

signal HSYNCCount         : std_logic_vector((HCOUNTSIZ - 1) downto 0);
-- HSYNC Counter to count in VSYNC States

signal CLCLKCount1        : std_logic_vector((CCOUNTSIZ1 - 1) downto 0);
-- CLCLK Counter 1 to count in HSYNC States

signal CLCLKCount2        : std_logic_vector((CCOUNTSIZ - 1) downto 0);
-- CLCLK Counter 2 to count in PCLK States in TFT mode

signal CLCLKCount3        : std_logic_vector((CCOUNTSIZ - 1) downto 0);
-- CLCLK Counter 3 to count in PCLK States in Active region

signal CPLCount           : std_logic_vector(CPLSIZ downto 0);
-- Panel Clock per line counter

signal CLLECount          : std_logic_vector((LECOUNTSIZ - 1) downto 0);
-- Counter to check CLLE

signal CLACCount          : std_logic_vector((ACCOUNTSIZ - 1) downto 0);
-- CLAC Counter

signal LineWidth          : std_logic_vector(31 downto 0);
-- Line Pulse Width in terms of CLCLK

-- -----------------------------------------------------------------------------
-- Main body of code
-- =================
-- -----------------------------------------------------------------------------

begin

LineWidth <= ((HSWValue) + (HBPValue) + (HFPValue) 
               + ("000000000" & HACTIVEValue) + 4);

-- -----------------------------------------------------------------------------
-- Assigning local copy to the output
-- -----------------------------------------------------------------------------
VSYNCState <= iVSYNCState;


-- -----------------------------------------------------------------------------
-- Logic resolver of CLFP, CLLP, CLCP and CLAC
-- This Block will resolve the inverted logic, i.e. if CLFP is active LOW,
-- this will generate active high version of CLFP as VSYNC. So, VSYNC will be
-- connected directly to CLFP for IVS = 0, and to the inverted version of
-- CLFP for IVS = 1. Same for CLLP, CLCP and CLAC. But, if LcdEn is low, all
-- the logics should be low.
-- -----------------------------------------------------------------------------
VSYNC <= not(CLFP) and (CLPOWER or CLTrFUFIntrTst) when (IVS = '1')
      else
         CLFP and (CLPOWER or CLTrFUFIntrTst);
HSYNC <= not(CLLP) and (CLPOWER or CLTrFUFIntrTst) when (IHS = '1')
      else
         CLLP and (CLPOWER or CLTrFUFIntrTst);
PCLK  <= not(CLCP) and (CLPOWER or CLTrFUFIntrTst) when (IPC = '1')
      else
         CLCP and (CLPOWER or CLTrFUFIntrTst);
AC    <= not(CLAC) and (CLPOWER or CLTrFUFIntrTst) when ((IEO = '1') and (TFT = '1'))
      else
         CLAC and (CLPOWER or CLTrFUFIntrTst); 

-- -----------------------------------------------------------------------------
-- Duration Values Generation
-- -----------------------------------------------------------------------------
HSWValue     <= (("000000000000000" & HSW) + 1) * (PCLKValue) - 1;
HBPValue     <= (("000000000000000" & HBP) + 1) * (PCLKValue) - 1;
HACTIVEValue <= (("0000000000000" & CPL)+ 1) * (PCLKValue) - 1;
HFPValue     <= (("000000000000000" & HFP) + 1) * (PCLKValue) - 1;
PCLKValue    <= ALLZEROS((CCOUNTSIZ - 2) downto 0) & '1' when (BCD = '1') 
                else ('0' & PCD) + 2;
CLACValue    <= ((ACB) + 1) * (LineWidth) - 1;

-- -----------------------------------------------------------------------------
-- VSYNC TEST
-- -----------------------------------------------------------------------------
p_VSYNCCheck : process (HSYNC, HRESETN, CLTrEn)
variable printstr : string(1 to 255); 
variable IntVSYNCState           : std_logic_vector(2 downto 0);
begin
  if ((HRESETN = '0') or (CLTrEn = '0')) then
    IntVSYNCState := ST_IDL;
    HSYNCCount <= ALLZEROS((HCOUNTSIZ - 1) downto 0);
  elsif(HSYNC'event and HSYNC = '0') then
    if (iVSYNCState = ST_IDL) then
      IntVSYNCState := ST_VSW;
      HSYNCCount <= ALLZEROS((HCOUNTSIZ - 1) downto 0);
    elsif (iVSYNCState = ST_VSW and HSYNCCount(5 downto 0) = VSW) then
      IntVSYNCState := ST_VBP;
      HSYNCCount <= ALLZEROS((HCOUNTSIZ  - 1)downto 0);
    elsif ((iVSYNCState = ST_VBP) and (HSYNCCount(7 downto 0) = (VBP - 1))) then
      IntVSYNCState := ST_VACTIVE;
      HSYNCCount <= ALLZEROS((HCOUNTSIZ  - 1)downto 0);
    elsif ((iVSYNCState = ST_VACTIVE) and
           (HSYNCCount(9 downto 0) = LPP (9 downto 0))) then
      IntVSYNCState := ST_VFP;
      HSYNCCount <= ALLZEROS((HCOUNTSIZ  - 1)downto 0);
    elsif ((iVSYNCState = ST_VFP) and (HSYNCCount(7 downto 0) = (VFP - 1))) then
      IntVSYNCState := ST_VSW;
      HSYNCCount <= ALLZEROS((HCOUNTSIZ  - 1)downto 0);
    else
      HSYNCCount <= (HSYNCCount) + '1';
    end if;

    if (TFT = '1') then
      if (IntVSYNCState = ST_VSW) then
        if ((VSYNC = '0') and (CLTrIntrTest = '0')) then
          fprint(printstr, "ERROR : IN TFT MODE VSYNC LOW IN VSW\n");
          assert false
          report printstr
          severity error;
          fprint(printstr, "Error Exit");
          if (ERR_EXIT = '0') then
            assert false
            report printstr
            severity error;
          else
            assert false
            report printstr
            severity failure;
          end if;
        end if;
      elsif ((VSYNC = '1') and (CLTrIntrTest = '0') and (LcdEn = '1')) then
        fprint(printstr, "ERROR : TFT MODE VSYNC HIGH IN NON VSW_REGION\n");
        assert false
        report printstr
        severity error;
        fprint(printstr, "Error Exit");
        if (ERR_EXIT = '0') then
          assert false
          report printstr
          severity error;
        else
          assert false
          report printstr
          severity failure;
        end if;
      end if;
    end if;
  end if;
  iVSYNCState <= IntVSYNCState;
end process p_VSYNCCheck;

-- -----------------------------------------------------------------------------
-- To check VSYNC signal in 1st active period after HSYNC in STN mode
-- -----------------------------------------------------------------------------
process (Active)
variable printstr : string (1 to 255);
begin  
  if (Active'event and Active = '0') then
    if (CLTrIntrTest = '0') then
      if (TFT = '0') then
        if (iVSYNCState = ST_VACTIVE  and 
            HSYNCCount = ALLZEROS((HCOUNTSIZ - 1) downto 0)) then
          if (VSYNC = '0' and (LcdEn = '1')) then
            fprint(printstr, "ERROR : STN MODE VSYNC LOW IN ACTIVE REGN\n");
            assert false
            report printstr
            severity error;    
            fprint(printstr, "Error Exit");
            if (ERR_EXIT = '0') then
              assert false
              report printstr
              severity error;
            else
              assert false
              report printstr
              severity failure;
            end if; 
          end if; 
        elsif (VSYNC = '1' and (LcdEn = '1')) then
          fprint(printstr, "ERROR : VSYNC HIGH STN MODE NONACTIVE REGN\n");
          assert false
          report printstr
          severity error;
          fprint(printstr, "Error Exit");
          if (ERR_EXIT = '0') then
            assert false
            report printstr
            severity error;
          else
            assert false
            report printstr
            severity failure;
          end if;
        end if;
      end if;
    end if;
  end if;
end process;

-- -----------------------------------------------------------------------------
-- OCCURENCE of VCOMP interupt checking
-- -----------------------------------------------------------------------------
p_VComp_test : process (VCOMPINTRout)
variable printstr : string (1 to 255);
begin
  if (VCOMPINTRout'event and VCOMPINTRout = '1') then
    if (not( (VComp = "00" and ((iVSYNCState = ST_VFP and HSYNCCount(7 downto 0) 
              = (VFP - 1) ) or (iVSYNCState = ST_IDL)))
       or (VComp = "01" and (iVSYNCState = ST_VSW) and
           HSYNCCount(5 downto 0) = VSW)
       or (VComp = "10" and (iVSYNCState = ST_VBP) and
           ("00" & HSYNCCount(5 downto 0)) = VBP-1)
       or (VComp = "11" and (iVSYNCState = ST_VACTIVE) and
           HSYNCCount(9 downto 0) = LPP))) then
      fprint(printstr, "ERROR : IN OCCURENCE OF VCOMP INTERUPT\n");
      assert false
      report printstr
      severity error;
    end if;
  end if;
end process p_VComp_test;

-- -----------------------------------------------------------------------------
-- OCCURENCE of   LNBU interupt checking
-- -----------------------------------------------------------------------------
p_LNBU_Test : process (LNBUINTRout)
variable printstr : string (1 to 255);
begin
  if (LNBUINTRout'event and LNBUINTRout = '1') then
    if (not(iVSYNCState = ST_VSW and HSYNCCount(5 downto 0) = VSW and
       (HSYNCState = ST_HACTIVE or HSYNCState = ST_HBP))) then
      fprint(printstr, "ERROR : IN OCCURENCE OF LNBU INTERUPT\n");
      assert false
      report printstr
      severity error;
    end if;
  end if;
end process p_LNBU_Test;
 
-- -----------------------------------------------------------------------------
-- HSYNC TEST
-- -----------------------------------------------------------------------------
p_HSYNCCheck : process (CLCLK, HRESETN, CLTrEn, HSYNC) 
variable printstr : string (1 to 255);
begin
  if (HSYNC'event and HSYNC = '1') then
    HSYNCState  <= ST_HSW;
    CLCLKCount1 <= ALLZEROS((CCOUNTSIZ1 - 1) downto 0);
  end if;
  if ((HRESETn = '0') or (CLTrEn = '0')) then
    HSYNCState <= ST_IDL;
    CLCLKCount1 <= ALLZEROS((CCOUNTSIZ1 - 1) downto 0);
  elsif (CLCLK'event and CLCLK = '0') then
    if (HSYNCState = ST_HSW) then
      if ((HSYNC = '0') and (CLTrIntrTest = '0') and (LcdEn = '1')) then
        fprint(printstr, "ERROR : HSYNC LOW IN HSW REGION\n");
        assert false
        report printstr
        severity error;
        fprint(printstr, "Error Exit");
        if (ERR_EXIT = '0') then
          assert false
          report printstr
          severity error;
        else
          assert false
          report printstr
          severity failure;
        end if;
      end if;
    elsif ((HSYNC = '1') and (CLTrIntrTest = '0') and (LcdEn = '1')) then
      fprint(printstr, "ERROR : HSYNC HIGH IN NON_HSW REGION\n");
      assert false
      report printstr
      severity error;
      fprint(printstr, "Error Exit");
      if (ERR_EXIT = '0') then
        assert false
        report printstr
        severity error;
      else
        assert false
        report printstr
        severity failure;
      end if;
    end if;
    if (HSYNCState = ST_IDL and HSYNC = '1') then
      HSYNCState  <= ST_HSW;
      CLCLKCount1 <= ALLZEROS((CCOUNTSIZ1 - 1) downto 0);
    elsif (HSYNCState = ST_HSW and CLCLKCount1 = HSWValue) then
      HSYNCState  <= ST_HBP;
      CLCLKCount1 <= ALLZEROS((CCOUNTSIZ1 - 1) downto 0);
    elsif (HSYNCState = ST_HBP and CLCLKCount1 = HBPValue) then
      HSYNCState  <= ST_HACTIVE;
      CLCLKCount1 <= ALLZEROS((CCOUNTSIZ1 - 1) downto 0);
    elsif (HSYNCState = ST_HACTIVE and CLCLKCount1 = HACTIVEValue) then
      HSYNCState  <= ST_HFP;
      CLCLKCount1 <= ALLZEROS((CCOUNTSIZ1 - 1) downto 0);
    elsif (HSYNCState = ST_HFP and CLCLKCount1 = HFPValue) then
      HSYNCState  <= ST_HSW;
      CLCLKCount1 <= ALLZEROS((CCOUNTSIZ1 - 1) downto 0);
    else
      CLCLKCount1 <= CLCLKCount1 + '1';
    end if;
  end if;
end process p_HSYNCCheck;

-- -----------------------------------------------------------------------------
-- Internal Active Signal Generation:
-- -----------------------------------------------------------------------------
CPLValue <= ('0' & CPL) + 1;
IntActive <= '1' when (((iVSYNCState = ST_VACTIVE) and ((HSYNCState = ST_HACTIVE) 
                   or ((HSYNCState = ST_HFP) and (CLCLKCount1 
                       = ALLZEROS((CCOUNTSIZ1 - 1) downto 0)) 
                   and (CLCLK = '0')))) and not((iVSYNCState = ST_VACTIVE) 
                   and (HSYNCState = ST_HACTIVE) and 
                       (CLCLKCount1 = ALLZEROS((CCOUNTSIZ1 - 1) downto 0)) 
                   and (CLCLK = '0')))
      else
         '0';
-- ----------------------------------------------------------------------------
-- Generation of  active signal
-- ---------------------------------------------------------------------------
p_ActActive : process 
begin
  wait until (IntActive'event); 
  if (IntActive = '1') then
    wait for 100 ps;
    if (IntActive = '1') then
      Active <= '1';
    end if;
  else
    wait for 100 ps;
    if (IntActive = '0') then
      Active <= '0';
    end if;
  end if;
end process p_ActActive;
-- -----------------------------------------------------------------------------
-- PCLK TEST in TFT mode
-- -----------------------------------------------------------------------------
p_TFTPCLKCheck : process (CLCLK, HRESETN, CLTrEn) 
variable printstr : string (1 to 255);
begin
  if (CLTrIntrTest = '0') then
    if ((HRESETn = '0') or (CLTrEn = '0') or
        TFT = '0') then
      PCLKState   <= ST_IDL;
      CLCLKCount2 <= ALLZEROS((CCOUNTSIZ - 1) downto 0);
    else
      if (PCLKState = ST_IDL and PCLK = '1') then
        PCLKState   <= ST_PCLKON;
        CLCLKCount2 <= ALLZEROS((CCOUNTSIZ - 1) downto 0);
      elsif (PCLKState = ST_PCLKON and PCLK = '0') then
        if ((CLCLKCount2 /= PCLKValue - 1) and (LcdEn = '1')) then
          fprint(printstr, "ERROR: IN TFT MODE CLCP period is not equal to" &
                 " PCD * CLCLK ");
          assert false
          report printstr
          severity error;
          fprint(printstr, "Error Exit");
          if (ERR_EXIT = '0') then
            assert false
            report printstr
            severity error;
          else
            assert false
            report printstr
            severity failure;
          end if;
        end if;
        PCLKState   <= ST_PCLKOFF;
        CLCLKCount2 <= ALLZEROS((CCOUNTSIZ - 1) downto 0);
      elsif (PCLKState = ST_PCLKOFF and PCLK = '1') then
        if ((CLCLKCount2 /= PCLKValue - 1) and (LcdEn = '1')) then
          fprint(printstr, "ERROR: IN TFT MODE CLCP period is not equal to" &
                 " PCD * CLCLK ");
          assert false
          report printstr
          severity error;
          fprint(printstr, "Error Exit");
          if (ERR_EXIT = '0') then
            assert false
            report printstr
            severity error;
          else
            assert false
            report printstr
            severity failure;
          end if;
        end if;
        PCLKState <= ST_PCLKON;
        CLCLKCount2 <= ALLZEROS((CCOUNTSIZ - 1) downto 0);
      else 
        CLCLKCount2 <= CLCLKCount2 + '1';
      end if;
    end if;
  end if;
end process p_TFTPCLKCheck;

-- -----------------------------------------------------------------------------
-- PCLK TEST in Active region
-- -----------------------------------------------------------------------------
p_ActivePCLKCheck : process (CLCLK, HRESETN, CLTrEn) 
variable printstr : string (1 to 255);
begin
  if (CLTrIntrTest = '0') then
    if ((HRESETN'event and HRESETn = '0') or (CLTrEn'event and CLTrEn = '0') or
        Active = '0') then
      PCLKState1  <= ST_IDL;
      CLCLKCount3 <= ALLZEROS((CCOUNTSIZ - 1) downto 0);
      CPLCount    <= ALLZEROS(CPLSIZ downto 0);
    else
      if (PCLKState1 = ST_IDL and PCLK = '1') then
        PCLKState1 <= ST_PCLKON;
        CLCLKCount3 <= ALLZEROS((CCOUNTSIZ - 1) downto 0);
      elsif (PCLKState1 = ST_PCLKON and PCLK = '0') then
        if ((CLCLKCount3 /= PCLKValue - 1) and (LcdEn = '1'))then
          fprint(printstr, "ERROR:In STN Mode in Active region CLCP ON period" &
                 " is not equal to PCD * CLCLK \n");
          assert false
          report printstr
          severity error;
          fprint(printstr, "Error Exit");
          if (ERR_EXIT = '0') then
            assert false
            report printstr
            severity error;
          else
            assert false
            report printstr
            severity failure;
          end if;
        end if;
        PCLKState1 <= ST_PCLKOFF;
        CLCLKCount3 <= ALLZEROS((CCOUNTSIZ - 1) downto 0);
        CPLCount    <= CPLCount + '1';
      elsif (PCLKState1 = ST_PCLKOFF) then
        if (CPLCount = CPL + 1) then
          PCLKState1 <= ST_IDL;
          CLCLKCount3 <= ALLZEROS((CCOUNTSIZ - 1) downto 0);
          CPLCount  <= ALLZEROS(CPLSIZ downto 0);
        elsif (PCLK = '1') then
          if ((CLCLKCount3 /= PCLKValue - 1) and (LcdEn = '1'))then
            fprint(printstr, "ERROR:In STN Mode in Active region CLCP ON" &
                   " period is not equal to PCD * CLCLK \n");
            assert false
            report printstr
            severity error;
            fprint(printstr, "Error Exit");
            if (ERR_EXIT = '0') then
              assert false
              report printstr
              severity error;
            else
              assert false
              report printstr
              severity failure;
            end if;
          end if;
          PCLKState1  <= ST_PCLKON;
          CLCLKCount3 <= ALLZEROS((CCOUNTSIZ - 1)  downto 0);
        else
          CLCLKCount3 <= CLCLKCount3 + '1';
        end if;
      else
        CLCLKCount3 <= CLCLKCount3 + '1';
      end if;
    end if;
  end if;
end process p_ActivePCLKCheck;

-- -----------------------------------------------------------------------------
-- CLLE Check Start Signal generation:
-- -----------------------------------------------------------------------------
CLLECheck <= '1' when ((CPLCount(9 downto 0) = CPL) and PCLK  = '1' and 
                       CLLEFlag = '1')
          else
             '0';

-- -----------------------------------------------------------------------------
-- CLLE TEST
-- -----------------------------------------------------------------------------
p_CLLECheck : process (CLCLK, HRESETN, CLTrEn) 
variable printstr : string (1 to 255);
begin
 if (CLTrIntrTest = '0') then
   if ((HRESETN = '0') or (LEE = '0') or (CLTrEn = '0')) then
     CLLEState <= ST_IDL;
     CLLECount <= (others => '0');
   elsif ((CLLEState = ST_IDL) and (CLLECheck = '1')) then
     CLLEState <= ST_LED;
     CLLECount <= (others => '0');
   elsif ((CLLEState = ST_LED) and (CLLE = '1')) then
     if(CLLECount /= LED and (LcdEn = '1')) then
       fprint(printstr, "ERROR: IN LINE END DELAY : LED Value");
       assert false
       report printstr
       severity error;
       fprint(printstr, "Error Exit");
       if (ERR_EXIT = '0') then
         assert false
         report printstr
         severity error;
       else
         assert false
         report printstr
         severity failure;
       end if;
     end if;
     CLLEState <= ST_CLLE;
     CLLECount <= (others => '0');
   elsif ((CLLEState = ST_CLLE) and (CLLE = '0')) then
     if (CLLECount /= 3 and (LcdEn = '1')) then
       fprint(printstr, " ERROR:CLLE NOT HIGH FOR 4 CYCLES");
       assert false
       report printstr
       severity error;
       fprint(printstr, "Error Exit");
       if (ERR_EXIT = '0') then
         assert false
         report printstr
         severity error;
       else
         assert false
         report printstr
         severity failure;
       end if;

     end if;
     CLLEState <= ST_IDL;
     CLLECount <= (others => '0');
   else
      CLLECount <= CLLECount + 1;
   end if;
 end if;
end process p_CLLECheck;
-------------------------------------------------------------------------------
--    Setting the CLLE check flag
-------------------------------------------------------------------------------
process (CLCLK)
begin
  if (CLCLK'event and CLCLK = '1' and BCD = '0') then
    CLLEFlag <= '0';
  end if;
end process;
 
process (PCLK)
begin
  if (PCLK'event and PCLK = '1') then
    CLLEFlag <= '1';
  end if;
end process;
-- -----------------------------------------------------------------------------
-- CLAC TEST
-- -----------------------------------------------------------------------------
p_CLACCheck : process (CLCLK, HRESETN, CLTrEn) 
variable printstr : string (1 to 255);
begin
  if (CLTrIntrTest ='0') then
    if ((HRESETn = '0') or (CLTrEn = '0') or
        (LEE = '0')) then
      CLACState <= ST_IDL;
      CLACCount <= ALLZEROS((ACCOUNTSIZ - 1) downto 0);
    elsif (TFT = '1') then
      if (Active = '1') then
        if (AC = '0' and (LcdEn = '1')) then
          fprint(printstr, "ERROR : IN TFT MODE CLAC LOW IN ACTIVE REGION\n");
          assert false
          report printstr
          severity error;
          fprint(printstr, "Error Exit");
          if (ERR_EXIT = '0') then
            assert false
            report printstr
            severity error;
          else
            assert false
            report printstr
            severity failure;
          end if;
        end if;
      elsif (AC = '1' and (LcdEn = '1')) then
        fprint(printstr, "ERROR : TFT MODE CLAC HIGH IN NONACTIVE REGION\n");
        assert false
        report printstr
        severity error;
        fprint(printstr, "Error Exit");
        if (ERR_EXIT = '0') then
          assert false
          report printstr
          severity error;
        else
          assert false
          report printstr
          severity failure;
        end if;
      end if;
    elsif (CLCLK'event and CLCLK = '1') then
      if (CLACState = ST_IDL and AC = '1') then
        CLACState <= ST_CLACON;
        CLACCount <= ALLZEROS((ACCOUNTSIZ - 1) downto 0);
      elsif (CLACState = ST_CLACON and AC = '0') then
        if ((CLACCount /= CLACValue) and (LcdEn = '1'))then
          fprint(printstr, "ERROR : In STN MODE CLAC ON period " &
                 "not equal to ACB VALUE\n");
          assert false
          report printstr
          severity error;
          fprint(printstr, "Error Exit");
          if (ERR_EXIT = '0') then
            assert false
            report printstr
            severity error;
          else
            assert false
            report printstr
            severity failure;
          end if;
        end if;
        CLACState <= ST_CLACOFF;
        CLACCount <= ALLZEROS((ACCOUNTSIZ - 1) downto 0);
      elsif (CLACState = ST_CLACOFF and AC = '1') then
        if ((CLACCount /= CLACValue) and (LcdEn = '1')) then
          fprint(printstr, "ERROR : STN MODE ACB VALUE in Off State\n");
          assert false
          report printstr
          severity error;
          fprint(printstr, "Error Exit");
          if (ERR_EXIT = '0') then
            assert false
            report printstr
            severity error;
          else
            assert false
            report printstr
            severity failure;
          end if;
        end if;
        CLACState <= ST_CLACON;
        CLACCount <= ALLZEROS((ACCOUNTSIZ - 1) downto 0);
      else
        CLACCount <= CLACCount + '1';
      end if;
    end if;
  end if;
end process p_CLACCheck;

-- -----------------------------------------------------------------------------
-- CLTrBaseUpdate and Check Signal Generation
-- -----------------------------------------------------------------------------
CLTrBaseUpdate <= '1' when (iVSYNCState = ST_VSW)
               else
                  '0';
IntCheck <= PCLK and Active and CLTrEn;
p_IntCheck : process
begin
  wait until (IntCheck'event);
  if (IntCheck = '1') then
    wait for 200 ps;
    if (IntCheck = '1') then
      Check <= '1';
    end if;
  else
    wait for 200 ps;
    if (IntCheck = '0') then
      Check <= '0';
    end if;
  end if;
end process p_IntCheck;


end behavioural;

-- --================================== End ==================================--

