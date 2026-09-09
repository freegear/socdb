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
-- File Name              : reader.vhd.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v2
--
-- ---------------------------------------------------------------------
-- Purpose :
--           This block reads infile.bif and drives the corresponding
--           packets.
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;

library common;
use     common.defs.all;
use     common.funcs.all;

library reader;
use     reader.readline.all;

-- ---------------------------------------------------------------------
entity reader is
  generic(
          INFILE : string;
          Tclkl  : time;
          Tclkh  : time
          );          
  port (
        HCLK          : in  std_logic;  -- System Clock
        Bidgetline    : in  T_get;      -- Get nxt command issued 
        Vrgetline     : in  T_get; -- Get nxt virtual Reg. command
                                   -- issued
        Bidpacket     : out T_bid; -- Packet determining signals driven
                                   -- on AHB
        Respacket     : out T_res; -- Packet determining signals driven
                                   -- on reset
        Vrpacket      : out T_vrbus;  -- Packet determining signals
                                      -- driven on VR
        Endianpacket  : out T_endian; -- Packet determining  endianness 
        Splitpacket   : out T_split; -- Packet determining expected
                                     -- split master
        Bcycsel       : out T_cycle; -- Read/Write cycle
        Rcycsel       : out T_cycle; -- Reset cycle
        Vrcycsel      : out T_cyclebus; -- Virtual Register operation
                                        -- select
        Encycsel      : out T_cycle;    -- Endianness cycle
        Spcycsel      : out T_cycle;    -- Split cycle
        Last          : in  T_line      -- End of simulation
      );
end reader;

-- ---------------------------------------------------------------------
--
--                             reader
--                             ======
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   This block looks at get line requests and drives packets out at the
-- correct time. Get line requests are issued from blocks when all
-- elements in it are idle. The request stays high until idle once more.
-- When the bid block requests a line, the assumption is that all vr
-- commands have finished and therefore the next line will be a Bus
-- command. However, when the VR block requests a line, it does not mean
-- that the next line is a VR command - it could be bid and in this case
-- the line is buffered until get_line = g_get.
-- Buffering is also required in the case that a line from infile is
-- read and there are no vr commands to execute in that cycle. The
-- reader must look at the next line to see whether it is VR. If it
-- isn't, it will be buffered.
--
-- ---------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==========================--

architecture behavioural of reader is

-- ---------------------------------------------------------------------
--  Test vector input filename (.bif = "bus interface format")
file iINFILE               : ascii_text is in "../../bustest/invec/infile.bif";

-- ---------------------------------------------------------------------
-- Signal declarations
-- ---------------------------------------------------------------------
signal ICLK         : std_logic;
-- Delayed version of HCLK, required for clever scheduling

-- These flags are set in the low phase and read in the high phase  to
-- indicate which lines have to be driven
signal Bidstored    : boolean := FALSE;
-- This flag indicates whether the bid_line is to be driven or not

signal Resstored    : boolean := FALSE;
-- This flag indicates whether the reset line is to be driven or not

signal Endianstored : boolean := FALSE;
-- This flag indicates whether the endianness line is to be driven or
-- not

signal Splitstored  : boolean := FALSE;
-- This flag indicates whether the split line is to be checked or not

signal Vrstored     : T_boolbus := (others => FALSE); 
-- This flag indicates whether the vr line is to be driven or not

-- These w signals are for IPC as write storage
signal Wbidpacket   : T_bid;
-- The "writable" BidPacket, which is driven if stored_flag is set
 
signal Wrespacket   : T_res;
-- The "writable" ResetPacket, which is driven if stored_flag is set
 
signal Wvrpacket    : T_vrbus;
-- The "writable" VRPacket, which is driven if stored_flag is set
 
signal Wsplitpacket : T_split;
-- The "writable" SPLITPacket, which is driven if stored_flag is set
 
signal Wenpacket    : T_endian;
-- The "writable" EndiannessPacket, which is driven if stored_flag is
-- set

signal Wbcycsel     : T_cycle;
-- Buffered variable denoting the cycle(e.g Csw, Csr etc.) being driven

signal Wrcycsel     : T_cycle;
-- Buffered variable denoting the cycle(e.g Cres) being driven

signal Wvcycsel     : T_cyclebus;
-- Buffered variable denoting virtual reg cycle(e.g Cvr, Cvw ) being
-- driven

signal Wencycsel    : T_cycle;
-- Buffered variable denoting (Cendian) being driven

signal Wspcycsel    : T_cycle;
-- Buffered variable denoting (Csplit) being driven

signal Testend      : boolean := FALSE;
-- Denoting end of simulation

signal Simend       : boolean := FALSE;
-- Denotes testing is over

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- Delayed HCLK is necessary as Bidgetline is assigned  at negedge HCLK
-- ---------------------------------------------------------------------
  ICLK   <= HCLK after Read_setup_delay;
  Simend <= TRUE when (Last = '1' and HCLK = '0') 
          else
            FALSE;  
-- ---------------------------------------------------------------------
-- The read process does the clever scheduling.  It shouldn't be
-- neccessary to change any of this when porting to other test benches.
-- ---------------------------------------------------------------------
p_read : process (ICLK)
-- ---------------------------------------------------------------------
-- variables for use in readcommand procedure
variable Vcycsel      : T_cycle;
-- Denotes the cycle(e.g vr, vw etc.) being driven

variable Vbidpacket   : T_bid;
-- The variable BidPacket, containing info about bid_signals to be
-- driven

variable Vrespacket   : T_res;
-- The variable ResPacket, containing info about reset signals to be
-- driven

variable Vvrpacket    : T_vr;
-- Variable VRPacket, containing info about virtual reg signals to be
-- driven

variable Vsplitpacket : T_split;
-- Variable SplitPacket, containing info about virtual reg signals to be
-- driven

variable Venpacket    : T_endian;
-- Variable EndianPacket, containing info about virtual reg signals to
-- be driven
    
-- buffer variables
variable Bbidpacket   : T_bid;
-- Buffered variable BidPacket, containing info about bid_signals to be
-- driven

variable Bvrpacket    : T_vr;
-- Buffered VRPacket, containing info about virtual reg signals to be
-- driven

variable Bsplitpacket : T_split;
-- Buffered SPLITPacket, containing info about virtual reg signals to be
-- driven

variable Benpacket    : T_endian;
-- Buffered EndianPacket, containing info about virtual reg signals to
-- be driven

variable Bcycsel      : T_cycle;
-- Buffered variable denoting the cycle(e.g Csw, Csr etc.) being driven

variable Bvcycsel     : T_cycle;
-- Buffered variable denoting virtual reg cycle(e.g Cvr, Cvw ) being
-- driven

variable Bencycsel    : T_cycle;
-- Buffered variable denoting Endianness cycle(Cendian ) being driven

variable Bspcycsel    : T_cycle;
-- Buffered variable denoting SPLIT cycle(Csplit ) being driven

-- flag to say whether an Bus command has been buffered
variable Bidbuffered  : boolean := FALSE;
-- Flag to say whether a bid command has been buffered

variable Endbuffered  : boolean := FALSE;
-- Flag to say whether a testend command has been buffered

variable Vrbuffered   : boolean := FALSE;
-- Flag to say whether a virtual register command has been buffered

variable VRStoredVar  : T_boolbus := (others => FALSE);
-- Denotes if a single virtual reg out of eight, has been stored or not

variable Storeddelay  : T_int := 1;
-- For VR cycle seting a default delay

-- ---------------------------------------------------------------------
-- If bidbuffered then the active packet is bbidpacket
-- else, read a new packet from infile.bif
-- ---------------------------------------------------------------------
begin

  if (ICLK = '0') then

    -- All the stored variables are initialized to FALSE so that no
    -- "residual variables" can drive the lines
    if Bidstored then Bidstored <= FALSE;
    end if;
    if Resstored then Resstored <= FALSE;
    end if;
    for i in 0 to 7 loop
      if Vrstored(i) then Vrstored(i) <= FALSE;
      end if;
    end loop;
    if Endianstored then Endianstored <= FALSE;
    end if;
    if Splitstored then Splitstored   <= FALSE;
    end if;

    -- Fetching data to drive signals in nxt pos-edge 
    if (Bidgetline = Gget  and Vcycsel /= Cvr and Vcycsel /= Cvw) then
      -- Checking whether simulation is over
      if Endbuffered then
        Vcycsel := Cend;
      -- Checking whether any packet is bufferred
      elsif (not Bidbuffered)then
        readcommand (iINFILE, Vbidpacket, Vrespacket, Vvrpacket, 
                     Vsplitpacket, Venpacket, Vcycsel);
      else 
        Vbidpacket  := Bbidpacket;
        Vcycsel     := Bcycsel;
        Bidbuffered := FALSE;
      end if;
 
      if Vrbuffered then
        Wvrpacket(Bvrpacket.vregno)   <= Bvrpacket;
        Vrstored(Bvrpacket.vregno)    <= TRUE;
        Vrstoredvar(Bvrpacket.vregno) := TRUE;
        Wvcycsel(Bvrpacket.vregno)    <= Bvcycsel;
        Vrbuffered                    := FALSE;
      else
        for i in 0 to 7 loop
          Vrstoredvar(i) := FALSE;
        end loop;
      end if;

      case Vcycsel is
        -- Storing the packet to be driven 
        when Csw | Csr | Csp => -- Csp is for the poll command
          Wbidpacket  <= Vbidpacket;
          Wbcycsel    <= Vcycsel;
          Bidstored   <= TRUE;
          -- Fetching next packet to bbid_packet if it is a read/write
          -- op.
          -- Else perform virtual register operations/reset parallely 
          -- If it's reset/VW/VR, then get the next bid packet also 
          loop
            readcommand(iINFILE,Vbidpacket,Vrespacket,Vvrpacket, 
                        Vsplitpacket, Venpacket, Vcycsel);
            case Vcycsel is
              when  Csw | Csr | Csp => -- Csp is for the poll command
                Bbidpacket  := Vbidpacket;
                Bcycsel     := Vcycsel;
                Bidbuffered := TRUE;
                Storeddelay := 1;
                exit;
              when Cvr | Cvw =>
                if  (not Vrstoredvar(Vvrpacket.vregno)) and
                     Vvrpacket.delay = Storeddelay then
                  Wvrpacket(Vvrpacket.vregno)   <= Vvrpacket;
                  Vrstored(Vvrpacket.vregno)    <= TRUE;
                  Vrstoredvar(Vvrpacket.vregno) := TRUE;
                  Storeddelay                   := Vvrpacket.delay;
                  Wvcycsel(Vvrpacket.vregno)    <= Vcycsel;
                else
                  Bvrpacket                     := Vvrpacket;
                  Bvcycsel                      := Vcycsel;
                  Vrbuffered                    := TRUE;
                  Storeddelay                   := Vvrpacket.delay;
                  for i in 0 to 7 loop
                  Vrstoredvar(i) := FALSE;
                  end loop;
                  exit;
                end if;
              when Cendian => 
                Wenpacket    <= Venpacket;
                Wencycsel    <= Vcycsel;
                Endianstored <= TRUE;
              when Csplit =>
                Wsplitpacket <= Vsplitpacket;
                Wspcycsel    <= Vcycsel;
                Splitstored  <= TRUE;  
              when Cres =>
                Wrcycsel    <= Vcycsel;
                Wrespacket  <= Vrespacket;
                Resstored   <= TRUE;
              when Cend =>
                Endbuffered  := TRUE;
                exit;
              when others =>
                null;
                exit;
            end case;
          end loop;
        when Cend =>
          Testend <= TRUE;
        when others =>
          null;
      end case;
    -- VR block issues a get next command
    elsif Vrgetline = Gget then
        if Vrbuffered then
          Wvrpacket(Bvrpacket.vregno)   <= Bvrpacket;
          Vrstored(Bvrpacket.vregno)    <= TRUE;
          Vrstoredvar(Bvrpacket.vregno) := TRUE;
          Wvcycsel(Bvrpacket.vregno)    <= Bvcycsel;
          Vrbuffered                    := FALSE;
        end if;
 
        if not Bidbuffered then
          loop
          readcommand(iINFILE,Vbidpacket,Vrespacket,Vvrpacket, 
                      Vsplitpacket, Venpacket, Vcycsel);
 
          case Vcycsel is
            when Csw | Csr | Csp=> --Csp is for the poll command
              Bbidpacket  := Vbidpacket;
              Bcycsel     := Vcycsel;
              Bidbuffered := TRUE;
              Storeddelay := 1;
              exit;
            when Cvr | Cvw =>
                if  (not Vrstoredvar(Vvrpacket.vregno))  and
                     Vvrpacket.delay = Storeddelay then
                  Wvrpacket(Vvrpacket.vregno)   <= Vvrpacket;
                  Vrstored(Vvrpacket.vregno)    <= TRUE;
                  Vrstoredvar(Vvrpacket.vregno) := TRUE;
                  Storeddelay                   := Vvrpacket.delay;
                  Wvcycsel(Vvrpacket.vregno)    <= Vcycsel;
                else
                  Bvrpacket                     := Vvrpacket;
                  Bvcycsel                      := Vcycsel;
                  Vrbuffered                    := TRUE;
                  Storeddelay                   := Vvrpacket.delay;
                  for i in 0 to 7 loop
                  Vrstoredvar(i) := FALSE;
                  end loop;
                  exit;
                end if;
            when Cres =>
              Wrcycsel   <= Vcycsel;
              Wrespacket <= Vrespacket;
              Resstored  <= TRUE;
            when Cendian =>
              Benpacket    := Venpacket;
              Bencycsel    := Vcycsel;
              Endianstored <= TRUE;
            when Csplit =>
              Bsplitpacket := Vsplitpacket;
              Bspcycsel    := Vcycsel;
              Splitstored  <= TRUE;
            when Cend =>
              Testend      <= TRUE;
             exit;
            when others =>
              null;
             exit;
          end case;
          end loop;
        end if;
    end if;
  end if;
end process p_read;

-- ---------------------------------------------------------------------
-- This drive process looks at the stored flags and then drives the w
-- signals onto the output in the high phase of HCLK.
-- Note that info is only reliably sampled in the first high phase
-- since the cycle select signals will go to idle in the low phase.
-- ---------------------------------------------------------------------
p_drive : process (HCLK, Wbidpacket, Wrespacket, Wvrpacket)
begin
  if (HCLK = '0') then
    if (Bidstored and Wbidpacket'event)  then        
      Bidpacket <= Wbidpacket;
      Bcycsel   <= Wbcycsel;
    else
      Bcycsel <= Cidle;
    end if;
    if (Resstored) then
      Respacket <= Wrespacket;
      Rcycsel   <= Wrcycsel;
    elsif (HCLK'event) then
      Rcycsel <= Cidle;
    end if;
    for i in 0 to 7 loop
    if (Vrstored(i) and Wvrpacket'event)  then
      Vrpacket(i) <= Wvrpacket(i);
      Vrcycsel(i) <= Wvcycsel(i);
    elsif (HCLK'event) then
      Vrcycsel(i) <= Cidle;
    end if;
    end loop;
    if (Endianstored) then
      Endianpacket <= Wenpacket;
      Encycsel     <= Wencycsel;
    elsif (HCLK'event) then
      Encycsel <= Cidle;
    end if;
    if (Splitstored) then
      Splitpacket <= Wsplitpacket;
      Spcycsel    <= Wspcycsel;
    elsif (HCLK'event) then
      Spcycsel <= Cidle;
    end if;
  elsif rising_edge(HCLK) then
    Bcycsel  <= Cidle;
    Rcycsel  <= Cidle;
    Encycsel <= Cidle;
    Spcycsel <= Cidle;
    for i in 0 to 7 loop
      Vrcycsel(i) <= Cidle;
    end loop;
  end if;
end process p_drive;

-- ---------------------------------------------------------------------
-- Simulation completion by asserting severity to failure when testend
-- is set
-- ---------------------------------------------------------------------
p_finish : process 
begin
 wait until Testend;
 wait until Simend;
 -- wait for one clock period
 wait for Tclkl + Tclkh;              
 assert false report "End of test" severity failure;
end process p_finish;

-- ---------------------------------------------------------------------
end behavioural;

-- --============================== End ==============================--
