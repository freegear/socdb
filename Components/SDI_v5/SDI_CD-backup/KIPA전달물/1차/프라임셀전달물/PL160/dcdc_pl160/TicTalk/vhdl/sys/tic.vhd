-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1999 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
-- 
-- Version and Release Control Information:
-- 
-- File Name              : tic.vhd,v
-- File Revision          : 1.2
--  
-- Release Information    : PL160-REL1v1
--  
-- --=========================================================================--

-- -----------------------------------------------------------------------------
-- Purpose : Test Interface Controller for an AMBA system.
-- 
-- -----------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;

-- include the Synopsys library when using Synopsys
--library synopsys;
--use     synopsys.attributes.all;

library common ;
use     common.Defs.all ;
--#synth off
use     common.params.all ;
--#synth on

entity tic is
  port(
       AGNTtic       : in    std_ulogic;
       BCLK          : in    std_ulogic;
       BD            : in    std_logic_vector( 31 downto 0 ) ;
       BnRES         : in    std_ulogic;
       BWAIT         : in    std_logic;
       BERROR        : in    std_logic;
       BLAST         : in    std_logic;

       -- Signals from the test port
       TREQA         : in    std_ulogic;
       TREQB         : in    std_ulogic;
         
       AREQtic       : out   std_ulogic;
       
       TACK          : out   std_ulogic;
      
       TestMode      : out  std_ulogic; -- overide normal operation
       TicoutLen     : out  std_ulogic;
       Ticouten      : out  std_ulogic;   -- was TestRead
       Ticinen       : out  std_ulogic;   -- was TestMode

       BA            : out   std_logic_vector( 31 downto 0 ) ;
       BTRAN         : out   std_logic_vector(1 downto 0);
       BLOK          : inout std_logic;
       BSIZE         : out   std_logic_vector(1 downto 0);
       BPROT         : out   std_logic_vector(1 downto 0);
       BWRITE        : out   std_logic
       );
end tic ;

architecture Behavioural of tic is

-- include this attribute to get resettable latches when using Synopsys
--  attribute async_set_reset of BnRES : signal is "true";

  function To_StdULogic(X : boolean)
    return std_ulogic is
  begin
    if X then
      return ('1');
    else
      return ('0');
    end if;
  end To_StdULogic;
  
  type t_mstate is (idlehld, idlegnt, xfergnt, xferhld, 
                     xferact, xferret, illegal);

  signal currentState    : t_mstate;
  signal nextState       : t_mstate;

  signal TREQA_R        : std_ulogic;
  signal TREQB_R        : std_ulogic;

  signal TMode           : std_ulogic;
  
  signal Granted         : std_ulogic;
  signal nextGranted     : std_ulogic;
  
  signal TACKint        : std_ulogic;
  signal TACKcom        : std_ulogic;
  signal TestModeint     : std_ulogic;
  signal B_TRANint       : std_logic_vector(1 downto 0);

  signal WRITE_REQ       : std_logic;
  signal HOLDcond       : std_logic;
  signal WRITE           : std_logic;
  signal READ_REQ        : std_logic;
  signal READ            : std_logic;
 
  signal B_WAITT1   : std_logic;
  signal B_ERRORT1  : std_logic;
  signal B_LASTT1   : std_logic; 

  signal addrv      : std_logic;
  signal addrl      : std_logic;
  signal address    : std_logic_vector( 31 downto 0 );
  signal Ticinenint : std_ulogic;
  signal Ticoutenint : std_ulogic;
         
begin

-------------------------------------------------------------------------------
-- Local signals to out mode ports
-------------------------------------------------------------------------------
  
  TACK           <= TACKint;
  TestMode        <= TestModeint;
  Ticinen         <= Ticinenint;
  Ticouten        <= Ticoutenint;
  
----------------------------------------
--  Test Port Synchronisation
----------------------------------------
  tport_sync : process(BCLK, BnRES)
  begin
    if (BnRES = '0') then
      TREQA_R <= '0' after DLPG;
      TREQB_R <= '0' after DLPG;
    elsif rising_edge(BCLK) then
      TREQA_R <= TREQA  after DLPG;
      TREQB_R <= TREQB  after DLPG;
    end if;
  end process tport_sync;

----------------------------------------
--  AREQ and TMode generation
----------------------------------------
  mode_gen : process(BCLK, BnRES)
  begin
    if (BnRES = '0') then
      TMode <= '0' after GAT2;
    elsif rising_edge(BCLK) then
      if TMode = '0' then
        TMode <= TREQA and (not TREQB) after DLPG;
      else
        TMode <= TREQA or TREQB after DLPG;
      end if;
    end if;
  end process mode_gen;

  AREQtic <= TMode;

----------------------------------------
-- latch slave response
----------------------------------------
  slave_latch : process(BCLK, BWAIT, BERROR, BLAST)
  begin
    if(BCLK = '0') then
      B_WAITT1  <= BWAIT  after TLPG;
      B_ERRORT1 <= BERROR after TLPG;
      B_LASTT1  <= BLAST  after TLPG;
    end if;
  end process slave_latch;

----------------------------------------
-- granted state machine
----------------------------------------
  granted_sm : process(BCLK, BnRES, AGNTtic)
  begin
    if((BnRES or AGNTtic) = '0') then
      Granted <= '0' after DLPG;
    elsif((BnRES or (not AGNTtic)) = '0') then
      Granted <= '1' after DLPG;
    elsif rising_edge(BCLK) then
      Granted <= nextGranted after DLPG;
    end if;
  end process granted_sm;

 nextGranted <= (((not Granted) and (not BWAIT) and (not BLOK) and AGNTtic)
                   or (Granted and (BWAIT or AGNTtic or BLOK))) after GAT3;

-------------------------------------------------------------------------------
-- Test Mode (clock and EBI control)
-------------------------------------------------------------------------------

  test_gen : process (BCLK, BnRES)
  begin
    if (BnRES = '0') then
      TestModeint <= '0' after GAT2;
    elsif falling_edge(BCLK) then
      TestModeint <= Granted and TMode after DLPG;
    end if;
  end process;
     
----------------------------------------
-- bus master state machine
----------------------------------------
    master_sm : process(BCLK, BnRES, AGNTtic)
  begin
    if((BnRES or AGNTtic) = '0') then
      currentState <= idlehld after DLPG;
    elsif((BnRES or (not AGNTtic)) = '0') then
      currentState <= idlegnt after DLPG;
    elsif falling_edge(BCLK) then
      currentState <= nextState after DLPG;
    end if;
  end process master_sm;

  msm_comb : process(BCLK, Granted, currentState, TMode,
                     B_WAITT1, B_LASTT1, B_ERRORT1)
  begin
     case currentState is
       when idlehld =>
         if (not TMode and not Granted) = '1' then
           nextState <= idlehld;
         elsif (not TMode and Granted) = '1' then
           nextState <= idlegnt;
         elsif (TMode and Granted) = '1' then
           nextState <= xfergnt;
         elsif (TMode and not Granted) = '1' then
           nextState <= xferhld;
         else
           nextState <= illegal;
         end if;
       when idlegnt =>
         if (not TMode and Granted) = '1' then
           nextState <= idlegnt;
         elsif (not Granted and not TMode) = '1' then
           nextState <= idlehld;
         elsif (Granted and TMode) = '1' then
           nextState <= xferact;
         elsif (not Granted and TMode) = '1' then
           nextState <= xferhld;
         else
           nextState <= illegal;
         end if;
       when xferhld =>
         if(not Granted) = '1' then
           nextState <= xferhld;
         elsif (Granted) = '1' then
           nextState <= xfergnt;
         else
           nextState <= illegal;
         end if;
       when xfergnt =>
         if (not Granted) = '1' then
           nextState <= xferhld;
         elsif (Granted) = '1' then
           nextState <= xferact;
         else
           nextState <= illegal;
         end if;
       when xferact =>
         if (Granted and B_WAITT1 and B_ERRORT1 and B_LASTT1) = '1' then
           nextState <= xferret;
         elsif (Granted and B_WAITT1 and (not B_LASTT1 or not B_ERRORT1)) = '1' then
           nextState <= xferact;
         elsif (Granted and not B_WAITT1 and TMode) = '1' then
           nextState <= xferact;
         elsif (Granted and not B_WAITT1 and not TMode) = '1' then
           nextState <= idlegnt;
         elsif (not Granted and not B_WAITT1 and TMode) = '1' then
           nextState <= xferhld;
         elsif (not Granted and not TMode) = '1' then
           nextState <= idlehld;
         else
           nextState <= illegal;
         end if;
       when xferret =>
         if (not Granted) = '1' then
           nextState <= xferhld;
         elsif (Granted) = '1' then
           nextState <= xfergnt;
         else
           nextState <= illegal;
         end if;
       when others =>
         -- Illegal state, should never happen
         nextState <= currentState;
     end case;
  end process msm_comb;

----------------------------------------
-- generate & drive BTRAN
----------------------------------------
  B_TRANint <= TRAN_ATRAN when (   currentState = idlehld
                                or currentState = idlegnt
                                or currentState = xferhld
                                or currentState = xferret
                                or (currentState = xferact
                                    and (not WRITE and not READ) = '1')) else
               TRAN_STRAN when ((currentState = xfergnt
                                 and ((WRITE or READ) = '1'))
                                or (currentState = xferact
                                    and ((WRITE or READ) = '1')
                                         )
                                )
               else
               TRAN_ATRAN;

  btran_drive : process(AGNTtic, BCLK, B_TRANint)
  begin
    if(AGNTtic and BCLK) = '1' then
      BTRAN <= B_TRANint after BUSE;
    else
      BTRAN <= (others => 'Z') after BUSD;
    end if;
  end process btran_drive;


----------------------------------------
-- BA/address latch etc control
----------------------------------------
  addr_gen : process(BCLK, BnRES)
  begin
    if (BnRES = '0') then
      addrv <= '0';
    elsif rising_edge(BCLK) then
      addrv <= (TREQA_R and TREQB_R and (not READ)) after DLPG;
      -- The (not READ) term blocks address and bus drive during
      -- bus turn around cycles (after reads).
    end if;
  end process addr_gen;

  addrl <= addrv and TREQA_R and TREQB_R and TACKint;

  adrl_hold : process (addrl, BCLK, BD, BnRES)
  begin
    if (BnRES = '0') then
      address <= (others => '0') after TLPG;
    elsif (BCLK or (not addrl)) = '0' then
      address <= BD after TLPG;
    end if;
  end process adrl_hold;                 -- 32 transparent latches with reset
  
  addr_drive : process(Granted, nextState, WRITE, address)
  begin
    if (Granted = '1' and nextState /= xfergnt) then
      BA <= address after BUSE;
      BLOK <= '0' after BUSE;
      BPROT <= "11" after BUSE;
      BSIZE <= SIZE_WORD after BUSE;
      BWRITE <= WRITE after BUSE;
    else
      BA <= (others => 'Z') after BUSD;
      BLOK <= 'Z' after BUSD;
      BPROT <= (others => 'Z') after BUSD;
      BSIZE <= (others => 'Z') after BUSD;
      BWRITE <= 'Z' after BUSD;
    end if;
  end process addr_drive;
  
----------------------------------------
-- TBUS --> BD : Write data into AMBA bus from outside world
----------------------------------------

  WRITE_REQ <= (TREQA and not TREQB and not READ and Testmodeint) after GAT3;

--  HOLDcond <= (To_StdULogic(currentstate /= xferret)) after GAT2;
  HOLDcond <= (To_StdULogic(currentstate /= xferret)) and
              (To_StdULogic(currentstate /= xferhld)) and
              (To_StdULogic(currentstate /= xfergnt)) after GAT2;

  write_state : process (BCLK, BnRES)
  begin
    if (BnRES = '0') then
      WRITE <= '0' after GAT2;
    elsif rising_edge(BCLK) then
      if BWAIT = '1' then
        WRITE <= WRITE after DLPG;
      else
        WRITE <= (WRITE_REQ and HOLDcond) or
                 (WRITE and not HOLDcond) after DLPG;
      end if;
    end if;
  end process write_state;
      
  bddrive : process(BCLK, BnRES)
  begin
    if (BnRES = '0') then
      Ticinenint <= '1';
    elsif falling_edge(BCLK) then
      if (WRITE = '1')
         or ((addrv and TREQA_R and TREQB_R and TACKint) = '1') then
        Ticinenint <= '0';
      else
        Ticinenint <= '1';
      end if;
    end if;
  end process bddrive;

----------------------------------------
-- BD --> TBUS : Read data from AMBA bus to outside world
----------------------------------------

  READ_REQ <= ( not TREQA and TREQB and Testmodeint) after GAT2;

  read_state : process (BCLK, BnRES)
  begin
    if (BnRES = '0') then
      READ <= '0' after GAT2;
    elsif rising_edge(BCLK) then
      if BWAIT = '1' then
        READ <= READ after DLPG;
      else
        READ <= (READ_REQ and HOLDcond) or
                (READ and not HOLDcond) after DLPG;
      end if;
    end if;
  end process read_state;
  
  tbdrive : process(BCLK, BnRES)
  begin
    if (BnRES = '0') then
      Ticoutenint <= '1';
    elsif rising_edge(BCLK) then
      Ticoutenint <= not((READ and TACKint) or (not Ticoutenint and not TACKint))
                  after DLPG;
     end if;      
  end process tbdrive;

  tbdriveb : process(BCLK, BnRES)
  begin
    if (BnRES = '0') then
      TicoutLen <= '1';
    elsif falling_edge(BCLK) then
      Ticoutlen <= not READ;
    end if;
  end process tbdriveb;

----------------------------------------
-- TACK generation
----------------------------------------

  TACKcom <= (TestModeint and To_StdULogic(currentState = xferact)
                   and ((not READ and not WRITE) or not b_waitt1)) after GAT3;

  tackgen : process(BCLK, BnRES)
  begin
    if (BnRES = '0') then
      TACKint    <= '0' after DLPG;
    elsif rising_edge(BCLK) then
      TACKint <= TACKcom after DLPG;
    end if;
  end process tackgen;

end Behavioural;

-- --================================= End ===================================--
