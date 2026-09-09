--------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : decoder.vhd.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose          : To provide the DSELxxx module select outputs from the 
--                     the address bus. This block is specific to a particular
--                     implementation.
-- 
--                     When the dselen signal is asserted, this block should 
--                     decode the address and assert the appropriate DSEL signal
--
--------------------------------------------------------------------------------
         
library ieee;
use     ieee.std_logic_1164.all;

-- include the Synopsys library when using Synopsys
--library synopsys;
--use     synopsys.attributes.all;

library common;
use     common.defs.all;
--#synth off
use     common.params.all;
--#synth on

entity Decoder is
  port(
       BCLK         : in     std_ulogic;                    -- ASB system clock
       BTRAN        : in     std_logic_vector(1 downto 0);  -- ASB transaction
       BSIZE        : in     std_logic_vector(1 downto 0);  -- ASB transfer size
       BnRES        : in     std_ulogic;                    -- ASB reset status
       BA           : in     std_logic_vector(31 downto 0); -- ASB address
       Remap        : in     std_ulogic;  -- Address map reconfiguration signal
       
       BWAIT        : inout  std_logic;   -- ASB wait slave response 
       BLAST        : inout  std_logic;   -- ASB break burst slave response
       BERROR       : inout  std_logic;   -- ASB error slave response

       -- Decoder selects
       DSELIntMem   : out    std_ulogic;  -- On chip memory
       DSELExtMem   : out    std_ulogic;  -- External memory
       DSELIntCn    : out    std_ulogic;  -- Buxton Int Cont.
       DSELPeri     : out    std_ulogic;  -- APB peripherals
       DSELARMTest  : out    std_ulogic   -- ARM test controller
       );
end Decoder;


architecture behavioural of Decoder is

-- include this attribute to get resettable latches when using Synopsys
--  attribute async_set_reset of BnRES : signal is "true";

  type   DECODE_STATE is (ADDRONLY, DECODE, SLAVESEL, ERROR);
       
  signal decstate      : DECODE_STATE;
  signal nextstate     : DECODE_STATE;
  signal LBWAIT        : std_ulogic;
  signal LBLAST        : std_ulogic;
  signal LBERROR       : std_ulogic;
  signal resp_en       : std_ulogic;
  signal WAITI         : std_ulogic;
  signal LAST          : std_ulogic;
  signal dseli         : std_ulogic;
  signal dselen        : std_ulogic;
  signal DecLast       : std_ulogic;
  signal lDecLast      : std_ulogic;

  signal BWAITi         : std_ulogic;     -- Input to BWAIT tristate driver
  signal BLASTi         : std_ulogic;
  signal BERRORi        : std_ulogic;

  signal DSELExtMem_i   : std_ulogic;
  signal DSELIntMem_i   : std_ulogic;
  signal DSELIntCn_i    : std_ulogic;
  signal DSELARMTEST_i  : std_ulogic;
  signal DSELPeri_i     : std_ulogic;
  signal lDSELExtMem_i  : std_ulogic;
  signal lDSELIntMem_i  : std_ulogic;
  signal lDSELIntCn_i   : std_ulogic;
  signal lDSELARMTest_i : std_ulogic;
  signal lDSELPeri_i    : std_ulogic;
  signal DecError       : std_ulogic;

begin

  AddrDecode : process(BA, Remap) 
  begin

--  Address map is
--  0x00000000 - 0x000003FF Intmem (Only when remap is HIGH)
--  0x00000000 - 0x7FFFFFFF External Memory (remap LOW)
--  0x00000400 - 0x7FFFFFFF External Memory (remap HIGH)
--  0x80000000 - 0xBFFFFFFF Peripherals
--  0xC0000000 - 0xCFFFFFFF ASB Slaves
--  0xD0000000 - 0xDFFFFFFF ARM Test
--  0xE0000000 - 0xFFFFFFFF undefined

    -- Default setting for all decodes is '0'.
    DSELIntMem_i  <= '0' after GAT3;
    DSELExtMem_i  <= '0' after GAT3;
    DSELIntCn_i   <= '0' after GAT3;
    DSELARMTest_i <= '0' after GAT3;
    DSELPeri_i    <= '0' after GAT3;
    DecError      <= '0' after GAT3;

    if (BA(31 downto 10) = "0000000000000000000000" and Remap = '1') then
        DSELIntMem_i  <= '1' after GAT3;    --  Internal Memory
    elsif (BA(31) = '0') then
        DSELExtMem_i  <= '1' after GAT3;    --  External Memory
    elsif (BA(31 downto 30) = "10") then
        DSELPeri_i    <= '1' after GAT3;    --  APB Peripherals
    elsif (BA(31 downto 28) = "1100") then
        DSELIntCn_i <= '1' after GAT3;      --  Buxton Int Controller
    elsif (BA(31 downto 28) = "1101") then
        DSELARMTest_i <= '1' after GAT3;    --  ARM Test
    else
        DecError      <= '1' after GAT3;    --  undefined (berror assertion)
    end if;
  end process AddrDecode;

-- address decoding of 1K boundaries
  Decode1KBound : process(BA, BSIZE) 
  begin

    if (BA(9 downto 2) = "11111111") and 
       ((BSIZE(1) = '1') or                -- last word transfer before boundary
       (BA(1) = '1' and BSIZE(0) = '1') or -- last half word transfer before
                                           -- boundary
       (BA(1 downto 0) = "11" and BSIZE(1 downto 0) = "00")) then 
                                           -- last byte transfer before boundary
       DecLast <= '1' after GAT3;
    else
       DecLast <= '0' after GAT3;
    end if;
  end process Decode1KBound;

-- Latch to hold select signal valid during a burst of sequential transfers
  sellat : process (dselen, BnRES, DSELIntMem_i, DSELExtMem_i, DSELARMTest_i,
                   DSELPeri_i)
  begin
    if BnRES = '0' then
        lDSELIntMem_i   <= '0' after TLPG;
        lDSELExtMem_i   <= '0' after TLPG;
        lDSELIntCn_i    <= '0' after TLPG;
        lDSELARMTest_i  <= '0' after TLPG;
        lDSELPeri_i     <= '0' after TLPG;
    elsif (dselen = '1') then
        lDSELIntMem_i   <= DSELIntMem_i  after TLPG;
        lDSELExtMem_i   <= DSELExtMem_i  after TLPG;
        lDSELIntCn_i    <= DSELIntCn_i   after TLPG;
        lDSELARMTest_i  <= DSELARMTest_i after TLPG;
        lDSELPeri_i     <= DSELPeri_i    after TLPG;
    end if;
  end process sellat;

-- The slave select signals are de-asserted at the end of a burst of 
-- sequential transfers
  DSELIntMem  <= (lDSELIntMem_i  and dseli) after GAT2;
  DSELExtMem  <= (lDSELExtMem_i  and dseli) after GAT2;
  DSELIntCn   <= (lDSELIntCn_i   and dseli) after GAT2;
  DSELARMTest <= (lDSELARMTest_i and dseli) after GAT2;
  DSELPeri    <= (lDSELPeri_i    and dseli) after GAT2;

--  Latch to delay DecLast so that the state machine does not go to the
--  decode state before the transfer has completed 
  dellat : process (BCLK, BnRES, DecLast)
  begin
    if BnRES = '0' then
        lDecLast <= '0' after TLPG;
    elsif (BCLK = '0') then
        lDecLast <= DecLast after TLPG;
    end if;
  end process dellat;

--  Latch to hold BWAIT ,BLAST, BERROR valid through clock HIGH phase
  waitlatch : process(BCLK, BLAST, BWAIT, BERROR) 
  begin
    if (BCLK = '0') then
      LBWAIT  <= BWAIT  after TLPG;
      LBLAST  <= BLAST  after TLPG;
      LBERROR <= BERROR after TLPG;
    end if;
  end process waitlatch;

  LAST  <= (not LBWAIT) and LBLAST and (not LBERROR)       after GAT2;
                                         -- Complete, Cannot continue with burst
  WAITI <= LBWAIT;                       -- Alias WAITI = LBWAIT
    
  -- Next state logic for decoder state machine
  -- The following constants are used (defined in defs.vhd)
  --     TRAN_ATRAN - "00"
  --     TRAN_NTRAN - "10"
  --     TRAN_STRAN - "11"
  nextstatep : process (BnRES, BTRAN, WAITI, LAST, decstate, lDecLast, DecError)
  begin
    if (BnRES = '0') then                -- sync reset, deselect all slaves
      nextstate <= ADDRONLY after GAT3;
    else
      case decstate is
        when ADDRONLY =>                 -- No transaction, no slaves selected
          if BTRAN = TRAN_NTRAN then -- Non-sequential transfer, perform decode
            nextstate <= DECODE after GAT3;
          elsif (BTRAN = TRAN_STRAN and DecError = '1') then
            nextstate <= ERROR after GAT3;
          elsif (BTRAN = TRAN_STRAN and DecError = '0') then 
                                         -- Sequential transfer, slave cycle
            nextstate <= SLAVESEL after GAT3;
          else                           
            nextstate <= ADDRONLY after GAT3;
          end if;
        when DECODE =>                   -- Decode cycle, wait for address
                                         -- decode to complete
          if DecError = '1' then
            nextstate <= ERROR after GAT3;
          else
            nextstate <= SLAVESEL after GAT3;
          end if;
        when SLAVESEL =>                -- Slave cycle, select slave
          if (WAITI = '1') then 
            nextstate <= SLAVESEL after GAT3;     -- Transfer not complete
          elsif (BTRAN = TRAN_ATRAN) then
            nextstate <= ADDRONLY after GAT3;     -- No transfer
          elsif (BTRAN = TRAN_NTRAN or 
                (BTRAN = TRAN_STRAN and (lDecLast = '1' or LAST = '1'))) then
            nextstate <= DECODE after GAT3;       -- New decode cycle required
          else
            nextstate <= SLAVESEL after GAT3;     -- Sequential burst
          end if;
        when ERROR =>
          if (BTRAN = TRAN_ATRAN) then
            nextstate <= ADDRONLY after GAT3;
          elsif (BTRAN = TRAN_STRAN and lDecLast = '1') or 
                (BTRAN = TRAN_NTRAN) then
            nextstate <= DECODE after GAT3;
          else 
            nextstate <= ERROR after GAT3; 
          end if;
        when others =>
            nextstate <= ADDRONLY after GAT3;
      end case;
    end if;
  end process nextstatep;

  -- Decoder state machine
  decodersmp : process (BCLK, BnRES)
  begin
    if (BnRES = '0') then
      decstate <= ADDRONLY after GAT2;    -- Asynch reset
    elsif (BCLK'event and BCLK = '0') then
      decstate <= nextstate after DLPG;
    end if;
  end process decodersmp;

  -- Use state machine next state to generate dselect signal (phase 2 latch)
  dselip : process (BnRES, BCLK, nextstate)
  begin
    if (BnRES = '0') then
      -- asynchr reset
      dseli <= '0' after TLPG;
    elsif (BCLK = '1') then
      if nextstate = SLAVESEL then
        dseli <= '1' after TLPG;
      else
        dseli <= '0' after TLPG;
      end if;
    end if;
  end process dselip ;

-- Enable signal used to latch the slave select signals when in the decode state
-- or in the addronly state and the next state is slavesel.
  dselen <= '1' after GAT2 when (BCLK = '1' and 
            (decstate = DECODE or (decstate = ADDRONLY and 
            nextstate = SLAVESEL))) else
            '0' after GAT2; 

  -- Slave response generation
  slaverespondp : process (decstate) 
  begin
    if (decstate = ADDRONLY) then
      BWAITi  <= '0';
      BLASTi  <= '0';
      BERRORi <= '0';
    elsif (decstate = DECODE) then   -- This case will only be enabled 
                                     -- when decstate = DECODE
      BWAITi  <= '1';
      BLASTi  <= '0';
      BERRORi <= '0';
    elsif (decstate = ERROR) then
      BWAITi  <= '0';
      BLASTi  <= '0';
      BERRORi <= '1';
    else                             -- don't care
      BWAITi  <= '-';
      BLASTi  <= '-';
      BERRORi <= '-';      
    end if;
  end process slaverespondp;

  resp_en <= dseli nor BCLK;
  
  -- Slave response tristate drivers
  slaveresdriv : process(resp_en, BWAITi, BLASTi, BERRORi)
  begin
    if (resp_en = '1') then
      --  Decoder only drives slave response when no other slave
      --  is selected
      BWAIT  <= BWAITi after BUSE;
      BLAST  <= BLASTi after BUSE;
      BERROR <= BERRORi after BUSE;     
    else
      BWAIT  <= 'Z' after BUSD;
      BLAST  <= 'Z' after BUSD;
      BERROR <= 'Z' after BUSD;
    end if;   
  end process slaveresdriv;
 
end behavioural;
