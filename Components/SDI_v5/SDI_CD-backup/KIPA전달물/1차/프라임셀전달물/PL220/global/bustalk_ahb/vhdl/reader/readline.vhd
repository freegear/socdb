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
-- File Name              : readline.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Reads a line from infile.bif and forms the corresponding
--           packets.
--
-- --=================================================================--

library IEEE;
use     IEEE.std_logic_1164.all;
use     IEEE.std_logic_arith.all;

library   std;
use       std.textio.all;

library common;
use     common.defs.all;
use     common.funcs.all;

-- ---------------------------------------------------------------------

package readline is

  procedure readcommand (
                         variable iINFILE    : in  ascii_text;
                         -- the .bif ascii text file
                         variable Bidpacket : out T_bid;
                         -- packet containing info about values to be
                         -- driven on businterface lines
                         variable Respacket : out T_res;
                         -- packet containing info about values to be
                         -- driven on reset lines
                         variable Vrpacket  : out T_vr;
                         -- packet containing info about values to be
                         -- driven on Virtual Register lines
                         variable Splitpacket : out T_split;
                         -- Packet containing info about values to be
                         -- driven on SPLITx lines 
                         variable Endianpacket : out T_endian;
                         -- Packet containing info about endianness
                         -- behaviour
                         variable Cycsel    : out T_cycle
                         -- indicates the cycle being driven
                         -- e.g, cidl,cmw, cvr, cres etc.
                        );
end readline;

-- ---------------------------------------------------------------------
--
--                             readline
--                             ========
--
-- ---------------------------------------------------------------------
--
-- Overview
-- ========
--   When called, this procedure will pass out a message string, a cycle
-- type and three packets (only one of which will be relevant). The
-- packet can be defined in config.vhd and then the assignments made can
-- be tailored for each test type depending on the cycle-type it is.
--
-- ---------------------------------------------------------------------
 
-- --========================= ARCHITECTURE ==========================--

package body readline is
procedure readcommand (
                       variable iINFILE      : in  ascii_text;
                       variable Bidpacket    : out T_bid;
                       variable Respacket    : out T_res;
                       variable Vrpacket     : out T_vr;
                       variable Splitpacket  : out T_split;
                       variable Endianpacket : out T_endian;
                       variable Cycsel       : out T_cycle
                      ) is 
 
-- ---------------------------------------------------------------------
-- Constant declarations
-- ---------------------------------------------------------------------
constant ENDOFSTR : character:= NUL;
 
-- ---------------------------------------------------------------------
-- Variable declarations
-- ---------------------------------------------------------------------
variable Linestr       : string(1 to 256);
-- Represents one entire line read from infile.bif

variable Cycstr        : string(1 to 2);
-- Represents the command in the line i,e HSW or VR etc

variable header           : string(1 to 2000);
-- the copyright header
 
variable countv1          : integer;
-- counter variable used for tracking the header string
 
variable countv2          : integer;
-- counter variable used for tracking the header string
 
variable strend           : character;
-- used for displaying header

variable Datastr       : string(1 to 16);
-- Represents Data driven

variable Maskstr       : string(1 to 16);
-- Represents the expected data-bit-mask

variable Addrstr       : string(1 to 8);
-- Represents address driven on bus

variable Limstr        : string(1 to 8);
-- Represents the maximum limit to which transfer can proceed

variable Pollstr       : string(1 to 8);
-- Represents time out for poll command

variable Masterstr     : string(1 to 8);
-- Represents Master number

variable Masterlockstr : string(1 to 1);
-- Represents whether Master has locked the bus

variable Rslimstr      : string(1 to 8);
-- Represents the max. number of reissues of a RETRY/SPLIT transfer

variable Idlstr        : string(1 to 8);
-- Represents number of idle cycles introduced after Retry/SPLIT

variable Expstr        : string(1 to 16);
-- Represents expected Data

variable ExpVrstr      : string(1 to 8);
-- Represents expected VR Data

variable Respstr       : string(1 to 2);
-- Represents expected HRESP

variable Sizestr       : string(1 to 1);
-- Represents HSIZE

variable Protstr       : string(1 to 1);
-- Represents HPROT signal

variable Counterstr    : string(1 to 8);
-- Represents number of clocks to wait for HSPLIT

variable Countstr      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count0str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count1str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count2str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count3str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count4str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count5str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count6str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count7str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count8str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count9str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count10str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count11str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count12str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count13str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count14str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Count15str      : string(1 to 8);
-- Represents number of clocks to wait for current transfer to be over 

variable Expmasterstr      : string(1 to 4);
-- Represents expected SPLITx line 

variable Burststr      : string(1 to 3);
-- Represents HBURST signal

variable Transtr       : string(1 to 1);
-- Represents HTRANS signal

variable Suppmsgstr    : string(1 to 1);
-- Represents Suppress message signal

variable Phasestr      : string(1 to 1);
-- Represents phase at which reset is to be asserted

variable Edgestr       : string(1 to 1);
-- Represents edge at which VR is active

variable Delaystr      : string(1 to 2);
-- Represents delay to be inserted before asserting reset

variable Regstr        : string(1 to 2);
-- Represents VR number

variable Tagstr        : string(1 to 20); 
-- Represents string which the user can "flash" in case of error 

variable Resp          : std_logic_vector(1 downto 0);
-- Represents HRESP signal

variable Prot          : std_logic_vector(3 downto 0);
-- Represents HPROT signal

variable Regnum        : string(1 to 1);
-- Represents Register number 

variable Endianstr     : string(1 to 1);
-- Represents Endianness of testbench

-- bit vector variables for intermediate use when converting string
-- into std_logic types
    
variable Countbv : bit_vector(7 downto 0);
-- Bit vector variable corresponding to numcycle Count

variable Delaybv : bit_vector(7 downto 0);
-- Bit vector variable corresponding to Delaystr 

variable Databv  : bit_vector(63 downto 0);
-- Bit vector variable corresponding to Datastr

variable Maskbv  : bit_vector(63 downto 0);
-- Bit vector variable corresponding to Maskstr

variable Addrbv  : bit_vector(31 downto 0);
-- Bit vector variable corresponding to Address string

variable Pollbv  : bit_vector(31 downto 0);
-- Bit vector variable corresponding to Poll string

variable Limbv   : bit_vector(31 downto 0);
-- Bit vector variable corresponding to Limit string

variable Masterbv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to Master number

variable Masterlockbv : bit_vector(3 downto 0);
-- Bit vector variable corresponding to Master lock signal

variable Rslimbv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to Rslimit string

variable Idlbv   : bit_vector(31 downto 0);
-- Bit vector variable corresponding to Idlecycle count

variable Expbv   : bit_vector(63 downto 0);
-- Bit vector variable corresponding to expected data

variable ExpVrbv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to expected data in VR

variable Protbv  : bit_vector(3 downto 0);
-- Bit vector variable corresponding to Protstr

variable Vdatabv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to VR data

variable Vmaskbv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to VR mask string

variable Vexpbv  : bit_vector(31 downto 0);
-- Bit vector variable corresponding to expected data

variable Expmasterbv : bit_vector(15 downto 0);
-- Bit vector variable corresponding to expected HMASTER value

variable Counterbv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter0bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter1bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter2bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter3bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter4bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter5bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter6bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter7bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter8bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter9bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter10bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter11bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter12bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter13bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter14bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

variable Counter15bv : bit_vector(31 downto 0);
-- Bit vector variable corresponding to HSPLITx count string

-- ---------------------------------------------------------------------
--
-- Main body of code
-- =================
--
-- ---------------------------------------------------------------------

begin

-- ---------------------------------------------------------------------
-- this bit at the front strips out extra comments to give the one
-- preceeding a command
-- ---------------------------------------------------------------------
  if not endfile(iINFILE) then
    fgetline (linestr,iINFILE);
    fscan (linestr,"%s",cycstr);
    if (cycstr = ";-") then
      assert false report linestr severity note;
    elsif (cycstr = "--") then
       StrCpy(header, linestr);
    end if;
 
    while (cycstr = "--") loop
      fgetline (linestr, iINFILE);
      fscan (linestr,"%s", cycstr);
      countv1 := 1;
      countv2 := 1;
      strend := header(countv1);
      if (cycstr = "--") then
        while strend /= ENDOFSTR loop
          countv1 := countv1 + 1;
          strend  := header(countv1);
        end loop;
 
        countv1 := countv1 - 1;
        strend  := linestr(countv2);
 
        while strend /= ENDOFSTR loop
          header(countv1 + countv2) := linestr(countv2);
          countv2                   := countv2 + 1;
          strend                    := linestr(countv2);
        end loop;
      elsif (cycstr = ";-") then
        assert false report LF & header severity note;
        assert false report linestr severity note;
      else
        assert false report LF & header severity note;
      end if;
    end loop;
 
    while cycstr = ";-" loop
      fgetline (linestr, iINFILE);
      fscan (linestr,"%s", cycstr);
      if (cycstr = ";-") then
        assert false report linestr severity note;
      elsif (cycstr = "--") then
        StrCpy(header, linestr);
      end if;
    end loop;

-- ---------------------------------------------------------------------
-- A big if-elsif structure to look at the cycle types and write output
-- ---------------------------------------------------------------------
--  AHB Cycle commands
-- ---------------------------------------------------------------------

    if Cycstr = "SW" or cycstr = "SR" or cycstr = "PO" then 
      if Cycstr = "SW" then
        Cycsel := Csw;
        fscan(linestr,"%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s",
              Cycstr, Datastr, Addrstr, Transtr, Burststr, Respstr,
              Sizestr, Limstr, Masterstr, Masterlockstr, Countstr,
              Idlstr, Rslimstr, Suppmsgstr, Protstr, Tagstr);
 
        -- Assigning the default values during a write
        Bidpacket.write := '1';
        Bidpacket.exp := (others => '0');
        Bidpacket.mask := (others => '0');
        Bidpacket.timeout := (others => '0');


        -- Assigning Data field of Bidpacket
        if Datastr = "ZZZZZZZZZZZZZZZZ" then
          Bidpacket.data := (others => 'Z');
        else
          Databv := from_hexstring(Datastr); 
          Bidpacket.data := to_stdlogicvector(Databv);
        end if;

      -- Read Cycle
      elsif (Cycstr = "SR") then        --  Command is SR
        Cycsel := Csr;    
        fscan(Linestr,
              "%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s",
              Cycstr, Expstr, Maskstr, Addrstr, Transtr, Burststr,
              Respstr, Sizestr, Limstr,  Masterstr, Masterlockstr,
              Countstr, Idlstr, Rslimstr, Suppmsgstr, Protstr, Tagstr);
        
        -- Clearing write field in a read cycle
        Bidpacket.write := '0';
 
        -- Assigning the expected-data field of the BidPacket 
        if Expstr = "ZZZZZZZZZZZZZZZZ" then
          Bidpacket.exp := (others => 'Z');
        else
          Expbv := from_hexstring(Expstr); 
          Bidpacket.exp := to_stdlogicvector(Expbv);
        end if;
 
        -- Assigning the mask field of the BidPacket 
        if Maskstr = "ZZZZZZZZZZZZZZZZ" then
          Bidpacket.mask := (others => 'Z');
        else
          Maskbv := from_hexstring(Maskstr); 
          Bidpacket.mask := to_stdlogicvector(Maskbv);
        end if;
        -- Clearing Write data bus field during read cycle 
        Bidpacket.data := (others => '0');

      -- Poll Command Cycle
      elsif (Cycstr = "PO") then        --  Command is PO
        Cycsel := Csp;
        fscan(Linestr,
              "%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s",
              Cycstr, Expstr, Maskstr, Addrstr, Transtr, Burststr,
              Respstr, Sizestr, Limstr,  Masterstr, Masterlockstr,
              Countstr, Idlstr, Rslimstr, Suppmsgstr, Protstr, Pollstr,
              Tagstr);

        -- Clearing write field in a read cycle
        Bidpacket.write := '0';

        -- Assigning the expected-data field of the BidPacket
        if Expstr = "ZZZZZZZZZZZZZZZZ" then
          Bidpacket.exp := (others => 'Z');
        else
          Expbv := from_hexstring(Expstr);
          Bidpacket.exp := to_stdlogicvector(Expbv);
        end if;
        
        -- Assigning the timeout value for poll command to the BidPacket
        Pollbv := from_hexstring(Pollstr);
        Bidpacket.timeout := to_stdlogicvector(Pollbv);

        -- Assigning the mask field of the BidPacket
        if Maskstr = "ZZZZZZZZZZZZZZZZ" then
          Bidpacket.mask := (others => 'Z');
        else
          Maskbv := from_hexstring(Maskstr);
          Bidpacket.mask := to_stdlogicvector(Maskbv);
        end if;
        -- Clearing Write data bus field during read cycle
        Bidpacket.data := (others => '0');
      end if;

  
      -- Assigning control fields for read and write cycle 
      if Respstr = "ok" then 
        Bidpacket.resp := "00";   
      elsif Respstr = "er" then
        Bidpacket.resp := "01";
      elsif Respstr = "re" then
        Bidpacket.resp := "10";
      elsif Respstr = "sp" then
        Bidpacket.resp := "11";
      end if;

      if Transtr = "i" then
        Bidpacket.trans := "00";
      elsif Transtr = "b" then
        Bidpacket.trans := "01";
      elsif Transtr = "n" then
        Bidpacket.trans := "10";
      elsif Transtr = "s" then
        Bidpacket.trans := "11";
      end if;
         
      if Burststr = "sin" then
        Bidpacket.burst := "000";
      elsif Burststr = "inc" then
        Bidpacket.burst := "001";
      elsif Burststr = "wr4" then
        Bidpacket.burst := "010";
      elsif Burststr = "in4" then
        Bidpacket.burst := "011";
      elsif Burststr = "wr8" then
        Bidpacket.burst := "100";
      elsif Burststr = "in8" then
        Bidpacket.burst := "101";
      elsif Burststr = "w16" then
        Bidpacket.burst := "110";
      elsif Burststr = "i16" then
        Bidpacket.burst := "111";
      end if;

      -- Assigning numcycle value field of Bidpacket
      Counterbv := from_hexstring(Countstr);
      Bidpacket.numcyc := to_integer(Counterbv,normal);
      
      -- Assigning tag string in Bidpacket
      Bidpacket.tag := Tagstr;
      
      -- Assigning Address field in bidpacket 
      Addrbv := from_hexstring(Addrstr);
      Bidpacket.addr := to_stdlogicvector(Addrbv);

      -- Assigning Limit field in bidpacket            
      Limbv := from_hexstring(Limstr);
      Bidpacket.limit := to_integer(Limbv,normal);

      -- Assigning Master number in bidpacket     
      Masterbv := from_hexstring(Masterstr);
      Bidpacket.masternum := (to_stdlogicvector(Masterbv)(3 downto 0));

      -- Assigning number of idle cycles in bidpacket 
      Idlbv := from_hexstring(Idlstr);
      Bidpacket.idlcyc := to_integer(Idlbv,normal);

      -- Assigning Retry/SPLIT reissues in bidpacket
      Rslimbv := from_hexstring(Rslimstr);
      Bidpacket.rslimit := to_integer(Rslimbv,normal);

      -- Assigning Suppress message field in bidpacket
      if Suppmsgstr = "f" then
        Bidpacket.suppmsg := FALSE;
      elsif Suppmsgstr = "t" then
        Bidpacket.suppmsg := TRUE; 
      end if;
 
      -- Assigning size in bidpacket
      if Sizestr = "b" then
        Bidpacket.size := "000";
      elsif Sizestr = "h" then
        Bidpacket.size := "001";
      elsif Sizestr = "w" then
        Bidpacket.size := "010";
      elsif Sizestr = "d" then
        Bidpacket.size := "011";
      elsif Sizestr = "f" then
        Bidpacket.size := "100";
      elsif Sizestr = "e" then
        Bidpacket.size := "101";
      elsif Sizestr = "s" then
        Bidpacket.size := "110";
      elsif Sizestr = "t" then
        Bidpacket.size := "111";
      end if;
    
      -- Assigning Masterlock in bidpacket 
      Masterlockbv := from_hexstring(Masterlockstr);
      if (Masterlockbv = "0001") then
        Bidpacket.masterlock := '1';
      else
        Bidpacket.masterlock := '0';
      end if; 

      -- Assigning PROT in bidpacket 
      Protbv := from_hexstring(Protstr);
      Bidpacket.prot := to_stdlogicvector(Protbv);
  
-- ---------------------------------------------------------------------
--  Bus Reset command
-- ---------------------------------------------------------------------
    elsif Cycstr = "RE" then
      Cycsel := Cres;
      fscan(Linestr,"%s %s %s %s",Cycstr,Phasestr,Delaystr,Countstr);
 
      -- Assigning Delay in resetpacket 
      Delaybv := from_hexstring(Delaystr);
      Respacket.delay := to_integer(Delaybv,normal);
 
      -- Assigning reset cycle count in reset packet 
      Countbv := from_hexstring(Countstr);
      Respacket.numcyc := to_integer(Countbv,normal);
 
      -- Assigning phase vlaue in resetpacket 
      if Phasestr = "L" then
        Respacket.phase := '0';
      elsif Phasestr = "H" then
        Respacket.phase := '1';
      end if;

-- ---------------------------------------------------------------------
--  Virtual Register commands
-- ---------------------------------------------------------------------
    elsif Cycstr = "VW" or Cycstr = "VR" then

      if Cycstr = "VR" then
        Cycsel := Cvr;
 
        fscan(Linestr,"%s %s %s %s %s %s %s",Cycstr,Regstr,ExpVrstr,
              Maskstr, Edgestr, Delaystr, Tagstr);
        -- VR Read cycle 
        Vrpacket.write := '0';
        -- Assigning expected count value 
        ExpVrbv      := from_hexstring(ExpVrstr);
        Vexpbv       := ExpVrbv(31 downto 0);
        Vrpacket.exp := to_stdlogicvector(Vexpbv);
 
        if Edgestr = "/" then
          Vrpacket.edge := '1';
        elsif Edgestr = "\" then -- to make the fontify right below
                                 -- this line
          Vrpacket.edge := '0';
        end if;
 
      else         --  Then the command is VW
        Cycsel := Cvw;
        -- VR Write cycle 
        fscan(Linestr,"%s %s %s %s %s %s",Cycstr,Regstr,Datastr,Maskstr,
              Phasestr, Delaystr);
 
        Vrpacket.write := '1';
        -- Data to be written in VR cycle 
        Vdatabv := from_hexstring(Datastr);
        Vrpacket.data := to_stdlogicvector(Vdatabv);
        -- Assigning phase information in VR packet 
        if phasestr = "L" then
          Vrpacket.phase := '0';
        elsif Phasestr = "H" then
          Vrpacket.phase := '1';
        end if;
 
       end if;
 
      --  The remaining packet information  is common to the two
      -- commands
      Delaybv := from_hexstring(Delaystr);
      Vrpacket.delay := to_integer(Delaybv,normal);
      Vrpacket.tag := Tagstr;
 
 
      -- Register number assignment. Up to 8 registers can be defined.
      Regnum := Regstr(2 to 2);
      Vrpacket.vregno := From_string(Regnum);
      -- Assigning mask vlaue in VR packet 
      Vmaskbv := from_hexstring(Maskstr);
      Vrpacket.mask := to_stdlogicvector(Vmaskbv);

-- ---------------------------------------------------------------------
--  SPLIT Master command
-- ---------------------------------------------------------------------
    elsif Cycstr = "SP" then
      Splitpacket.exphsplit := (others => '0');
      Cycsel := Csplit;
      fscan(Linestr,
            "%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s ",
            Cycstr,Expmasterstr,Count0str,Count1str,Count2str,Count3str,
            Count4str,Count5str,Count6str,Count7str,Count8str,Count9str,
            Count10str,Count11str,Count12str,Count13str,Count14str,
            Count15str,Limstr);

      -- Assigning Expected Master in splitpacket
      if Expmasterstr = "ZZZZ" then
        Splitpacket.exphsplit := (others => 'Z');
      else
        Expmasterbv := from_hexstring(Expmasterstr);
        Splitpacket.exphsplit := to_stdlogicvector(Expmasterbv);
      end if;

      -- Assigning numcycle value in splitpacket 
      Counter0bv := from_hexstring(Count0str);
      Splitpacket.numcyc0 := to_integer(Counter0bv,normal);
 
      Counter1bv := from_hexstring(Count1str);
      Splitpacket.numcyc1 := to_integer(Counter1bv,normal);

      Counter2bv := from_hexstring(Count2str);
      Splitpacket.numcyc2 := to_integer(Counter2bv,normal);

      Counter3bv := from_hexstring(Count3str);
      Splitpacket.numcyc3 := to_integer(Counter3bv,normal);

      Counter4bv := from_hexstring(Count4str);
      Splitpacket.numcyc4 := to_integer(Counter4bv,normal);

      Counter5bv := from_hexstring(Count5str);
      Splitpacket.numcyc5 := to_integer(Counter5bv,normal);

      Counter6bv := from_hexstring(Count6str);
      Splitpacket.numcyc6 := to_integer(Counter6bv,normal);

      Counter7bv := from_hexstring(Count7str);
      Splitpacket.numcyc7 := to_integer(Counter7bv,normal);

      Counter8bv := from_hexstring(Count8str);
      Splitpacket.numcyc8 := to_integer(Counter8bv,normal);

      Counter9bv := from_hexstring(Count9str);
      Splitpacket.numcyc9 := to_integer(Counter9bv,normal);

      Counter10bv := from_hexstring(Count10str);
      Splitpacket.numcyc10 := to_integer(Counter10bv,normal);

      Counter11bv := from_hexstring(Count11str);
      Splitpacket.numcyc11 := to_integer(Counter11bv,normal);

      Counter12bv := from_hexstring(Count12str);
      Splitpacket.numcyc12 := to_integer(Counter12bv,normal);

      Counter13bv := from_hexstring(Count13str);
      Splitpacket.numcyc13 := to_integer(Counter13bv,normal);

      Counter14bv := from_hexstring(Count14str);
      Splitpacket.numcyc14 := to_integer(Counter14bv,normal);

      Counter15bv := from_hexstring(Count15str);
      Splitpacket.numcyc15 := to_integer(Counter15bv,normal);

     -- Assigning Limit field in bidpacket
      Limbv := from_hexstring(Limstr);
      Splitpacket.limit := to_integer(Limbv,normal);
 
-- ---------------------------------------------------------------------
--  Slave Endianness command
-- ---------------------------------------------------------------------
    elsif Cycstr = "EN" then
      Cycsel := Cendian;
      fscan(Linestr,"%s %s",Cycstr,Endianstr);

      -- Assigning Endianness in Endianpacket 
      if (Endianstr = "b") then
        Endianpacket.endian := "01";
      elsif (Endianstr = "d") then
        Endianpacket.endian := "10";
      elsif (Endianstr = "l") then
        Endianpacket.endian := "00";
      end if;
-- ---------------------------------------------------------------------
--  Test End command
-- ---------------------------------------------------------------------
    elsif Cycstr = "TE" then
      Cycsel := Cend;
    end if;    
  end if;
end readcommand;

end readline;

-- --============================== End ==============================--
