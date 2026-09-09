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
-- File Name              : rem_pause.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose : RMC Reset and pause registers (APB peripheral) See RMC 
--           spec for details A microcontroller peripheral based on 
--           the APB bus.
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

--#Synth off
library common;
use     common.params.all;
--#Synth on

entity rem_pause is
  port (
        BnRES      : in     std_ulogic;

        PWRITE     : in     std_ulogic;
        PSEL       : in     std_ulogic ;
        PSTB       : in     std_ulogic;
        PA         : in     std_ulogic_vector(5 downto 0); 

        NFIQ        : in     std_ulogic;
        NIRQ        : in     std_ulogic;

        PWDATA      : in     std_ulogic_vector(15 downto 0);
        PRDATA      : out    std_ulogic_vector(15 downto 0);


        Pause       : out    std_ulogic ;
        ReMap       : out    std_ulogic
        ) ;

end rem_pause ;

------------------------------------------------------------------------
--  IDReg is specified as a constant, so that it is easy to change for
--  different implementations.
--  Note that the value has to be supplied as a 32 bit value, but 
--  IDRegSize controls the number of bits that are present. If this 
--  value changes the port above (and the instances) should also be 
--  changed.
--  The ReMap signal is latched by this block (and cannot be changed
--  back to '0' other than by reset).
------------------------------------------------------------------------

architecture Behavioural of rem_pause is
  constant IDRegSize : integer := 16 ;
  constant IDRegVal  : std_ulogic_vector( 31 downto 0 ) :=
           "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0";
  constant ResReg0 : std_logic_vector( 31 downto 0 ) :=
           "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ0";
  constant ResReg1 : std_logic_vector( 31 downto 0 ) :=
           "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ1";
  constant PauseMode        : std_ulogic_vector(5 downto 0) := "000000";
  constant Identification   : std_ulogic_vector(5 downto 0) := "010000";
  constant ClearResetMap    : std_ulogic_vector(5 downto 0) := "100000";
  constant ResetStatus      : std_ulogic_vector(5 downto 0) := "110000";
  constant ResetStatusClear : std_ulogic_vector(5 downto 0) := "110100";

  signal ResetStatusLatch  : std_ulogic ;
  signal ReMapLatch        : std_ulogic ;
  signal Readen            : std_ulogic ;
  signal Read              : std_ulogic ;
  signal IDReg             : std_ulogic_vector((IDRegSize -1) downto 0);
  signal PDi               : std_ulogic_vector((IDRegSize -1) downto 0);

--  These signal declarations are important for synthesis. They are 
--  needed to attach constants for register reads.
--  The length of these signals should be equal to the number of valid 
--  bits in the constant (in this case they are both 1-bit wide)

  signal ResReg0_out       : std_logic_vector(0 downto 0);
  signal ResReg1_out       : std_logic_vector(0 downto 0);
  
begin
  ReMap     <=  ReMapLatch after GAT2;

  Readen    <=  PSTB and PSEL and (not PWRITE) after GAT2;
  Read      <=  PSEL and (not PWRITE) after GAT2;

  Resreg0_out(0)  <= ResReg0(0);
  Resreg1_out(0)  <= ResReg1(0);

  Main : process( BnRES, PSTB)
  begin

     IDReg            <= IDRegVal( (IDRegSize-1) downto 0) after GAT1;

    if (BnRES = '0') then
      -- asynchronous reset, tr-state all outputs, reset internal values
      ResetStatusLatch <= '1' after GAT1;        -- indicates cold reset
      ReMapLatch       <= '0' after GAT1;
    else
--#Synth off
      assert (not (Is_X(PSTB) and NOW > 10 ns))
        report "Bad value on Reset Controller strobe line"
        severity error ;
--#Synth on
      if (PSTB'event and PSTB = '1') then
--#Synth off
        assert (not Is_X(std_ulogic_vector(PSEL & PA & PWRITE)))
          report "Bad value on Reset Controller inputs"
          severity error ;
--#Synth on
        if PSEL = '1' then
          if (PWRITE = '1') then
            if PA = ClearResetMap then
              ReMapLatch <= '1' after DLPG;
            elsif PA = ResetStatusClear then
              ResetStatusLatch <= (ResetStatusLatch and  
                                                       (not PWDATA(0)))
                            after DLPG;
            end if ;
          end if ;
        end if ;
      end if ;
    end if ;
  end process Main ;

  Pauser : process( BnRES, PSTB, NFIQ, NIRQ, PSEL, PA)
  variable PauseT : Std_ulogic;
  begin
    -- Combinational logic for PauseT
    if (PSEL = '1') and (PA = PauseMode) then
       PauseT := '1';
    else
       PauseT := '0';
    end if;

    -- Pause moved out to allow interrupt reset in synthesis
    if ((BnRES and NIRQ and NFIQ) = '0') then
       Pause  <= '0' after GAT2;
    elsif (PSTB'event and PSTB = '1') then
       Pause <= PauseT after DLPG;
    end if;
  end process Pauser ;

  DataOut : process (
                     PA,
                     IDReg,
                     ResReg0_out,
                     ResReg1_out,
                     Read,
                     ResetStatusLatch
                     )
  begin
   if Read = '1' then
    case PA is
      when Identification =>
      -- drive ID register onto data bus
        PDi <= IDReg after GAT2;
      when ResetStatus =>
    -- drive reset status onto bus, other bits are tri-stated
      if (ResetStatusLatch = '0') then
        PDi(0)                      <= ResReg0_out(0)  after GAT2 ;
-- If IDRegSize is no longer 16 then change the number of '-'
        PDi((IDRegSize-1) downto 1) <= "000000000000000" after GAT2 ;
      else 
        PDi(0)                      <= ResReg1_out(0)  after GAT2 ;
-- If IDRegSize is no longer 16 then change the number of '-'
        PDi((IDRegSize-1) downto 1) <= "000000000000000" after GAT2 ;
      end if ;
    when others =>
      PDi  <= (others => '0') after GAT2;
    end case;
    else 
      PDi  <= (others => '0') after GAT2;
    end if;
  end process DataOut ;

  DataDrive : process (Readen, PDi)
  begin
    if Readen = '1' then
      PRDATA  <= PDi after BUSE;                 
    else
      PRDATA  <= (others => 'Z') after BUSD;
    end if ;
  end process DataDrive;
                       
end Behavioural ;

-- --============================== End ==============================--
