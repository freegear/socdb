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
--  File Name              : ticbox.vhd,v
--  File Revision          : 1.1.1.1
--  
--  Release Information    : PL050-REL1v1
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose          : External AMBA TIC testbox
--
--------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--   Features : Reads data from input file and ouptuts AMBA test interface
--              signal TREQA, TREQB and the data bus TBUS.
--              When performing reads, a comparison is made between the read
--              value and the expected value (both previously masked by a
--              mask value) and a result message is broadcasted
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--  INPUT FILE FORMAT
--
-- ; at beginning of line implies a comment
-- Vector Type    Data    Mask
--
-- Vector Type
--    A   - Address
--    W   - Write (also used for burst writes)
--    R   - Read
--    B   - Burst Read
-- 
-- Data (In hex)
-- 
-- 
-- Mask (In hex)   - only used in read cycles
-- 
-------------------------------------------------------------------------------
  
library ieee;
use     ieee.std_logic_1164.all;

library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_developerskit.std_IOpak.all;

library common;
use     common.params.all;
use     common.Defs.all ;

entity ticbox is

  generic(
          FileName : string := "infile.tif";
          HaltOnMismatch : boolean := FALSE;
          Verbosity : integer := 0 
          ) ;
  port
    (
     START   : in     std_ulogic;
     TCLK    : in     std_ulogic;
     TACK    : in     std_ulogic;

     TBUS    : inout  std_logic_vector(31 downto 0);

     TREQA   : out    std_ulogic := '0';
     TREQB   : out    std_ulogic := '0'
    );
end ticbox;

architecture behavioural of ticbox is

    
  file INFILE     : ascii_text is in FileName ;


  procedure readline ( reqa      : inout std_logic;
                       reqb      : inout std_logic;
                       data      : inout std_logic_vector(31 downto 0);
                       mask      : inout std_logic_vector(31 downto 0);
                       compare   : inout std_logic;
                       loopon    : inout std_logic;
                       count     : inout integer) is
    variable linestr   : string(1 to 256);
    variable cycstr    : string(1 to 1);
    variable datastr   : string(1 to 8);
    variable maskstr   : string(1 to 8);
    variable countstr  : string(1 to 8);
    variable data_bv   : bit_vector(31 downto 0);
    variable mask_bv   : bit_vector(31 downto 0);

  begin
    if not endfile(INFILE) and loopon = '0' then
      fgetline (linestr, INFILE);   -- read complete line
      fscan (linestr,"%s", cycstr); -- read cycle type
      if (Verbosity = 1) then
      assert cycstr /= ";"          -- assert comment if ; as first character
        report linestr
        severity note;
      end if;
      while cycstr = ";" loop                -- junk comment line
        fgetline (linestr, INFILE);          -- read complete line
        fscan (linestr,"%s", cycstr);        -- read cycle type
      end loop;
        
      if cycstr = "A" then                   -- perform conversion to bits
        reqa := '1';
        reqb := '1';
      compare := '0';
      fscan (linestr,"%s %s", cycstr, datastr);
        if datastr = "ZZZZZZZZ" then
        data := (others => 'Z');
        else
        data_bv := from_hexstring(datastr);  -- convert value to bus signals
        data := to_stdlogicvector(data_bv);
        end if;        
      
      elsif cycstr = "W" then
        reqa := '1';
        reqb := '0';
      compare := '0';
      fscan (linestr,"%s %s", cycstr, datastr);
      data_bv := from_hexstring(datastr);    -- convert value to bus signals
      data := to_stdlogicvector(data_bv);
        
      elsif cycstr = "R" then                -- perform conversion to bit
        reqa := '0';
        reqb := '1';
        compare := '1';
       fscan(linestr,"%s %s %s ", cycstr, datastr, maskstr);  -- read data
        data_bv := from_hexstring(datastr);  -- convert value to bus signals
        data := to_stdlogicvector(data_bv);
        mask_bv := from_hexstring(maskstr);  -- convert to bus signals
        mask := to_stdlogicvector(mask_bv);      
        
      elsif cycstr = "L"  then
         fscan (linestr, "%s %s ", cycstr, countstr); 
         count := from_string(countstr);     -- convert to bus signals
         count := count - 1;
         if count <= 0 then
         loopon := '0';
         else
         loopon := '1';
         end if;
           

      elsif cycstr = "E" then
        reqa := '0';
        reqb := '0';
      compare := '0';
      else
      end if;        

    elsif loopon = '1' then
           count := count - 1;
         if count <= 0 then
         loopon := '0';
         end if;         
    else                  -- If end of file, drive reqa and reqb LOW.
         reqa := '0';
         reqb := '0';
         data := (others => 'Z');
    end if;

  end readline;
  
  function StrLengthHex( constant x : in integer )
    return integer is
      variable result : integer ;
  begin
    if (x mod 4 = 0) then
      result := (x / 4) ;
    else
      result := (x/4) + 1 ;
    end if ;
    return (result) ;
  end StrLengthHex ;

  function To_HexString( constant val : in std_ulogic_vector )
    return string is
    constant ResLength : integer := StrLengthHex(val'length) ;
    variable result    : string (1 to ResLength) ;
    variable temp      : std_ulogic_vector(3 downto 0) ;
  begin
    for i in (ResLength-1) downto 0 loop
      result(ResLength-i) := ' ' ;
      for j in 3 downto 0 loop
        if (i = (ResLength-1)) then
          if (i*4)+j >= val'length then
            temp(j) := '0' ;
          else
            temp(j) := val( (i*4)+j ) ;
          end if ;
        else
          temp(j) := val( (i*4)+j ) ;
        end if ;
      end loop ;
      case temp(3 downto 0) is
        when "0000" => result(ResLength-i) := '0'; 
        when "0001" => result(ResLength-i) := '1'; 
        when "0010" => result(ResLength-i) := '2'; 
        when "0011" => result(ResLength-i) := '3'; 
        when "0100" => result(ResLength-i) := '4'; 
        when "0101" => result(ResLength-i) := '5'; 
        when "0110" => result(ResLength-i) := '6'; 
        when "0111" => result(ResLength-i) := '7'; 
        when "1000" => result(ResLength-i) := '8'; 
        when "1001" => result(ResLength-i) := '9'; 
        when "1010" => result(ResLength-i) := 'A'; 
        when "1011" => result(ResLength-i) := 'B'; 
        when "1100" => result(ResLength-i) := 'C'; 
        when "1101" => result(ResLength-i) := 'D'; 
        when "1110" => result(ResLength-i) := 'E'; 
        when "1111" => result(ResLength-i) := 'F';
        when others  => result(ResLength-i) := 'X';
      end case ;
    end loop ;
    return result ;
  end To_HexString ;

    signal dataD1    : std_logic_vector(31 downto 0)    := (others => '0') ;
    signal maskD1    : std_logic_vector(31 downto 0)    := (others => '0') ;
    signal maskD2    : std_logic_vector(31 downto 0)    := (others => '0') ;
    signal readD1    : std_logic_vector(31 downto 0)    := (others => '0') ;
    signal readD2    : std_logic_vector(31 downto 0)    := (others => '0') ;
    signal compareD1 : std_logic := '0';
    signal compareD2 : std_logic := '0';

begin 

  Main : process (TCLK)

    variable reqa      : std_logic := '0';
    variable reqb      : std_logic := '0';
    variable data      : std_logic_vector(31 downto 0)    := (others => 'Z') ;
    variable mask      : std_logic_vector(31 downto 0)    := (others => '1') ;
    variable compare   : std_logic := '0';
    variable loopon    : std_logic := '0';
    variable count     : integer;

    variable errorstr  : string(1 to 255);
  begin

      if rising_edge( TCLK ) and TACK = '0' and  START = '1'
      and ((REQA or REQB) = '0') then
        TREQA <= '1';
        TREQB <= '0';
      elsif falling_edge( TCLK ) and TACK = '1' then

        readD2    <= readD1;
        maskD2    <= maskD1;
        compareD2 <= compareD1;
        
        compareD1 <= compare;
        
        if compare = '1' then        -- Read cycle, latch info in other buses.         
        readD1   <= data;
        maskD1   <= mask;
        TBUS    <= (others => 'Z') after BUSD;
        elsif compareD1 = '1' then
        TBUS    <= (others => 'Z') after BUSD;
        else
        TBUS    <= data after BUSE ;
        end if;
        
        readline (reqa, reqb, data, mask, compare, loopon, count);
        TREQA  <= reqa after BUSE;
        TREQB  <= reqb after BUSE;

        assert (not (((reqa or reqb) = '0') and HaltOnMismatch))
          report "Vector run completed : halting simulation"
          severity failure;
      end if ;

      if rising_edge(TCLK) and compareD2 = '1' then
        -- Compare read value with expected value
        if ((TBUS and maskD2) /= (readD2 and maskD2)) then
      fprint(errorstr, "Error on vector read. Expected: %s Actual: %s Mask: %s",
                 To_HexString(To_StdULogicVector(readD2)),
                 To_HexString(To_StdULogicVector(TBUS)),
                 To_HexString(To_StdULogicVector(maskD2)));

          if HaltOnMismatch then
            assert false
              report errorstr
              severity failure;
          else
            assert false
              report errorstr
              severity warning;
          end if;
        end if;
        compareD2 <= '0';
      end if ;
        
  end process Main ;
  
end Behavioural ;
