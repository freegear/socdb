--        ____________________________________ 
--       /                                    |
--      |                                     |
--      |      __________________   __________|
--      |     |                 |   |
--       \     \                |   |   _______________________________________________________
--        \     \               |   |
--         \     \              |   |                                                
--          \     \             |   |                                                NAND512W3A   
--           \     \            |   |      
--            \     \           |   |                                               512Gbit (x8)       
--             \     \          |   |                    528 Byte Page, 3V, NAND Flash Memories
--              \     \         |   |       
--               \     \        |   |                                     VHDL Behavioral Model
--                |     \       |   |                                               Version 1.0
--                |     |       |   |                                               
--  ______________|     |       |   |                     Copyright (c) 2005 STMicroelectronics
-- |                    |       |   |  
-- |                    |       |   |  _________________________________________________________
-- |___________________/        |___|
-- 
-- 
-- ********************************************************************************************* 
-- 
-- String Package Utility  
-- Author: Giampaolo Giacopelli
-- beta release 0.4 28/10/2002


LIBRARY IEEE;
   Use IEEE.std_logic_1164.all;
   Use IEEE.std_logic_TextIO.all;
   Use IEEE.Std_Logic_Arith.conv_std_logic_vector;

Library Std;
   Use STD.TextIO.right;
   Use STD.TextIO.WRITE;
   Use STD.TextIO.LINE;
   Use STD.TextIO.OUTPUT;
   Use STD.TextIO.DEALLOCATE;

Package StringLib is

 Constant MAXCHARTIME       : Integer := 64;
 Constant MAXCHARINTEGER    : Integer := 20;
 Constant MAXCHARIDENTIFIER : Integer := 32;
 Constant MAXCHARSUBSTRING  : Integer := 80;

   -- Numer of minimal char for rappresent Address Bus;

   -- Numer of minimal char for rappresent Data Bus;
 Function SpaceString(size: Natural) Return string;
 Procedure PrintString(str: string);
 Function StrLen(str: String) Return Integer;
 Function StrPos(str: String; i: Integer) Return Character;
Procedure StrCat(str: String; substr: inout String; l: Integer; r: Integer);
 Function CharNoCase(c: Character) Return Character;
 Function StrCmpNoCase(d: String; s: String) Return Integer;
 Function StrCmp(d: String; s: String) Return Integer;

 Function SearchChar(Str:String; Init: Integer; ch: Character) Return Integer;
 Function SearchBackChar(Str:String; Init: Integer; ch: Character) Return Integer;

 Function SearchPosNumber(Str:String; Init: Integer) Return Integer;
 Function SearchBackPosNumber(Str:String; Init: Integer) Return Integer;

 Function SearchPosIdentifier(Str:String; Init: Integer) Return Integer;
 Function SearchBackPosIdentifier(Str:String; Init: Integer) Return Integer;
 
 Procedure SearchNumber(Str:string; Sout: inout string;Init: integer);
 Procedure SearchIdentifier(Str:string; Sout: inout string;Init: integer);

 Function Slv2Str(value : Std_Logic_Vector) return String;

 Function Str2Hex(value : String) return String;
 Function Slv2Hex(value :Std_Logic_Vector) return String;
 Function Hex2Slv(str : String) Return Std_Logic_Vector;
 
 Function Time2Str(value: Time) Return String;
 Function Str2Time(str: String) Return Time;
 
 Function Int2Str(value: Integer) Return String;
 Function Str2Int(str: String) Return Integer;

 Function int2bit(value: integer) return bit;
 Function bit2int(b: bit) return integer;

 Function int2vbit(value: integer; size: Integer) return bit_vector;
 Function vbit2int(b: bit_vector) return integer;

--------------------------------------------------------------------------------
   -- Utility Function
   Function int2charHex(i: Integer)  return character;
   Function char2quad_bits(c: character) return std_logic_vector;
   Function slv2int(value: std_logic_vector) return integer;
   Function Int2Hex(Value: Integer) return string;
   Function Int2Hexdata(Value: Integer) return string;
--------------------------------------------------------------------------------





Procedure Line2String (Variable L: in line; Variable s: out string);

End StringLib; -- Declaritive Parte of StringUtil


Package body StringLib is 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  Function int2charHex(i: Integer)  return character  is
     Variable result : character ;
  Begin
     case i is
        when 0 => result :=  '0'; 
        when 1 => result :=  '1';
        when 2 => result :=  '2';
        when 3 => result :=  '3';
        when 4 => result :=  '4';
        when 5 => result :=  '5';
        when 6 => result :=  '6';
        when 7 => result :=  '7';
        when 8 => result :=  '8';
        when 9 => result :=  '9';
        when 10 => result :=  'A';
        when 11 => result :=  'B';
        when 12 => result :=  'C';
        when 13 => result :=  'D';
        when 14 => result :=  'E';
        when 15 => result :=  'F';
        when others => result := 'X';
     end case;
   return result;
  end int2charHex;


  --This function converts ascii-hex character into a std_logic_vector--
  function char2quad_bits(c: character) return std_logic_vector is
     variable result : std_logic_vector(3 downto 0);
  begin
     case c is
	when '0' => result :=  "0000";
	when '1' => result :=  "0001";
	when '2' => result :=  "0010";
	when '3' => result :=  "0011";
	when '4' => result :=  "0100";
	when '5' => result :=  "0101";
	when '6' => result :=  "0110";
	when '7' => result :=  "0111";
	when '8' => result :=  "1000";
	when '9' => result :=  "1001";
	when 'A' => result :=  "1010";
	when 'B' => result :=  "1011";
	when 'C' => result :=  "1100";
	when 'D' => result :=  "1101";
	when 'E' => result :=  "1110";
	when 'F' => result :=  "1111";
	when 'a' => result :=  "1010";
	when 'b' => result :=  "1011";
	when 'c' => result :=  "1100";
	when 'd' => result :=  "1101";
	when 'e' => result :=  "1110";
	when 'f' => result :=  "1111";
        when 'x' => result :=  "XXXX";
        when 'X' => result :=  "XXXX";
        when 'z' => result :=  "ZZZZ";
        when 'Z' => result :=  "ZZZZ";
        
	when others => result := "0000";
     end case;
   return result;
  end char2quad_bits;

  -- This function converts std_logic_vector into integer value.
  function slv2int(value: std_logic_vector) return integer is
     variable sum :      integer := 0;
  begin
    sum := 0;
    for i in value'range loop
       if value(i) = '1'  then
           sum := (sum * 2) + 1;
       elsif value(i) = '0'  then
           sum:= sum*2;
       end if;
    end loop;
    return (sum);
  end slv2int;

 Function Int2Hex(Value: Integer) return string  is
    Constant NUMCHARHEXADDR : Natural  := (Value / 16) + 1;
    Variable divValue, modValue, i: Integer;
    Variable HexString: String(1 to NUMCHARHEXADDR):=(Others => '0' );
    Variable revHexString: String(1 to NUMCHARHEXADDR);
    Variable HexLine: Line;
  begin
    divValue := Value;
    while (divValue>15) loop
                    modValue := divValue mod 16;
                    Std.TextIO.WRITE(HexLine, int2charHex(modValue),right);
                    divValue := divValue / 16;
                    end loop;

    Std.TextIO.WRITE(HexLine, int2charHex(divValue));

    HexString(HexLine.all'Range) := HexLine.all;
    i:=1;
    while (i<=HexString'length) loop
        revHexString(i):=HexString(HexString'length - i + 1);
        i := i + 1;
    end loop;

    Deallocate(HexLine);
    Return revHexString;

  end Int2Hex;

 Function Int2Hexdata(Value: Integer) return string  is
  
    Constant NUMCHARHEXDATA : Natural  := (Value / 16) + 1;
    Variable divValue, modValue, i: Integer;
    Variable HexString: String(1 to NUMCHARHEXDATA):=(Others => '0' );
    Variable revHexString: String(1 to NUMCHARHEXDATA);
    Variable HexLine: Line;
  begin
    divValue := Value;
    while (divValue>15) loop
                    modValue := divValue mod 16;
                    Std.TextIO.WRITE(HexLine, int2charHex(modValue),right);
                    divValue := divValue / 16;
                    end loop;

    Std.TextIO.WRITE(HexLine, int2charHex(divValue));

    HexString(HexLine.all'Range) := HexLine.all;
    i:=1;
    while (i<=HexString'length) loop
        revHexString(i):=HexString(HexString'length - i + 1);
        i := i + 1;
    end loop;

    Deallocate(HexLine);
    Return revHexString;

  end Int2Hexdata;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

 Function SpaceString(size: Natural) Return string is
 Variable str: string(1 to size);
 begin
 str:=(Others => ' ');
 Return str;
   
 end SpaceString;

  Procedure PrintString(str: String) is
  Variable OutLine: Line;
  Begin
        Std.TextIO.WRITE(OutLine, str);
	Std.TextIO.WriteLine(Output, OutLine);
	deallocate(OutLine);
  End PrintString;
  
  Function StrLen(str: String) Return Integer is
  Variable i:Integer;
          Begin 
          i:=str'length;
          if (str(i)/=NUL) then Return i;end if;
          i:=1;
          while (str(i) /= NUL) loop
                      i := i + 1;
                      end loop;
          Return i-1;
  End StrLen;


  Function StrPos(str: String; i: Integer) Return Character is
  Begin
        if (i>=str'left) and (i<=str'right) then Return str(i);
                        else Return NUL;
                        -- PrintString(String'("Error in StrPos: index out of range"));
        End If;
  end StrPos;

 Procedure StrCat(str: String; substr: inout String; l: Integer; r: Integer) is 
  Variable i,li,ri: Integer;
  Begin 
        li:=l;ri:=r;
        if (li < str'left)  then li := str'left; end if;
        if (ri > str'right) then ri := str'right; end if;
        if (ri > li) then 
                     i := li;
                     while (i<=ri) loop
                                   if i-li+1 > substr'right then exit; end if; 
                                   substr(i - li + 1):=str(i);
                                   i:=i+1;
                     end loop;
                     if ri-li+1 < substr'right then 
                                               substr(ri-li+2) := NUL;
                     end if;
         
        end if;
  end StrCat;

  Function CharNoCase (c: Character) Return Character is 
    Begin 
        If character'pos(c) >= character'pos('A') and character'pos(c) <= character'pos('Z') Then 
           Return character'val(character'pos(c) + (character'pos('a') - character'pos('A')));
        End If;
    Return c;
  End CharNoCase;
  
  Function StrCmpNoCase(d: String; s: String) Return Integer is
   Variable i: integer:=1; 
   Variable dc,sc: Character  ;
   Begin
   
   Loop

      If i<=d'right  Then dc:=d(i); Else dc:=NUL; End If;
      If i<=s'right  Then sc:=s(i); Else sc:=NUL; End If;

      If CharNoCase(dc)/=CharNoCase(sc)  or dc=NUL Then
        Return (character'pos(dc) - character'pos(sc));
      Else
        i:=i+1;
      End If;

   End Loop;       
  End StrCmpNoCase;

  Function StrCmp(d: String; s: String) Return Integer is
   Variable i: integer:=1; 
   Variable dc,sc: Character  ;
   Begin
   
   Loop

      If i<=d'right  Then dc:=d(i); Else dc:=NUL; End If;
      If i<=s'right  Then sc:=s(i); Else sc:=NUL; End If;

      If dc/=sc  or dc=NUL Then
        Return (character'pos(dc) - character'pos(sc));
      Else
        i:=i+1;
      End If;

   End Loop;       
  End StrCmp;


  Function SearchChar(Str:String; Init: Integer; ch: Character) Return Integer is 
  Variable Len : Integer;
  Variable i   : Integer;
  begin 
           Len:=StrLen(Str);
           i:=Init;
           while (i<=Len) loop
                          if Str(i)=ch then return i;  -- found
                          end if;
                          i:=i+1;
                      end loop;
           return 0;   -- not found
  end SearchChar;
  
  
-- Search Char into a String from position Init downto position 1
  Function SearchBackChar(Str:String; Init: Integer; ch: Character) Return Integer is 
  Variable i   : Integer;
  begin 
           if Init<=StrLen(Str) 
                        then 
                        i:=Init;
                        while (i>=1) loop
                                     if Str(i)=ch then return i; end if; -- found
                                     i:=i-1;
                        end loop;
           end if;
           Return 0;
  end SearchBackChar;

 Function SearchPosNumber(Str:String; Init: Integer) Return Integer is 
  Variable Len : Integer;
  Variable i   : Integer;
  begin 
           Len:=StrLen(Str);
           i:=Init;
           while (i<=Len) loop
                          if (character'pos(Str(i))>=character'pos('0') and character'pos(Str(i))<=character'pos('9')) then Return i; end if;
                          i:=i+1;
           end loop;
           return 0;   -- not found
  end SearchPosNumber;

 Function SearchBackPosNumber(Str:String; Init: Integer) Return Integer is 
  Variable i   : Integer;
  begin 
           if Init<=StrLen(Str) then 
                        i:=Init;
                        while (i>=1) loop
                          if (character'pos(Str(i))>=character'pos('0') and character'pos(Str(i))<=character'pos('9')) then Return i; end if;
                          i:=i-1;
                        end loop;
           end if;
           Return 0; -- not found
  end SearchBackPosNumber;

 Function SearchPosIdentifier(Str:String; Init: Integer) Return Integer is 
  Variable Len : Integer;
  Variable i   : Integer;
  begin 
           Len:=StrLen(Str);
           i:=Init;
           while (i<=Len) loop
                          if (character'pos(Str(i))>=character'pos('a') and character'pos(Str(i))<=character'pos('z')) or
                             (character'pos(Str(i))>=character'pos('A') and character'pos(Str(i))<=character'pos('Z')) or
                             (character'pos(Str(i))>=character'pos('_')) then Return i; End If;
                          i:=i+1;
           end loop;
           return 0;   -- not found
  end SearchPosIdentifier;


 Function SearchBackPosIdentifier(Str:String; Init: Integer) Return Integer is 
  Variable i   : Integer;
  begin 
           if Init<=StrLen(Str) then 
                        i:=Init;
                        while (i>=1) loop
                          if (character'pos(Str(i))>=character'pos('a') and character'pos(Str(i))<=character'pos('z')) or
                             (character'pos(Str(i))>=character'pos('A') and character'pos(Str(i))<=character'pos('Z')) or
                             (character'pos(Str(i))>=character'pos('_')) then Return i; End If;
                          i:=i-1;
                        end loop;
           end if;
           Return 0; -- not found
  end SearchBackPosIdentifier;

-- Search Number in a String
-- non considera gli spazi trovati all'inizio e si ferma quando trova un carattere diverso 
-- da  un numero
  Procedure SearchNumber(Str:string; Sout: inout string;Init: integer) is
  Variable i, iSout : Integer;
  Variable Len : Integer;
  Begin
           Len:=StrLen(Str);
           iSout:=0;
           If Len>0 then
                    i:=Init;
                    While i<Len loop 
                                if character'pos(Str(i)) = character'pos(' ') then i := i + 1;
                                                                              else exit;
                                end if;
                    End Loop;
                    While i<=Len loop
                                 if (character'pos(Str(i))>=character'pos('0') and character'pos(Str(i))<=character'pos('9'))
                                    then 
                                        iSout := iSout + 1; 
                                        if iSout>Sout'right then exit;end if;
                                        Sout(iSout) := Str(i);
                                        i:=i+1;
                                        else exit;
                                 end if;
                    End Loop;
                    If (iSout>0 and iSout<Sout'right) then Sout(iSout+1):=NUL;
                    End If;
           End if;
  End SearchNumber;


-- Search Identifier in a String
-- non considera gli spazi trovati all'inizio e si ferma quando trova un carattere diverso 
-- dall'identificatore
  Procedure SearchIdentifier(Str:string; Sout: inout string;Init: integer) is
  Variable i, iSout : Integer;
  Variable Len : Integer;
  Begin
           Len:=StrLen(Str);
           iSout:=0;
           If Len>0 then
                    i:=Init;
                    While i<Len loop 
                                if character'pos(Str(i)) = character'pos(' ') then i := i + 1;
                                                                              else exit;
                                end if;
                    End Loop;
                    While i<=Len loop
                                 if (character'pos(Str(i))>=character'pos('a') and character'pos(Str(i))<=character'pos('z')) or
                                    (character'pos(Str(i))>=character'pos('A') and character'pos(Str(i))<=character'pos('Z')) or
                                    (character'pos(Str(i))>=character'pos('_')) then 
                                                                                iSout := iSout + 1; 
                                                                                if iSout>Sout'right then exit;end if;
                                                                                Sout(iSout) := Str(i);
                                                                                i:=i+1;
                                                                                else exit;
                                 end if;
                    End Loop;
                    If (iSout>0 and iSout<Sout'right) then Sout(iSout+1):=NUL;
                    End If;
           End if;
  End SearchIdentifier;


  Function Slv2Str(Value : Std_Logic_Vector) return String is
    variable L : Line;  -- access type
    variable W : String(1 to value'length) := (others => ' ');
  begin
     IEEE.Std_Logic_TextIO.WRITE(L, value);
     W(L.all'range) := L.all;
     Deallocate(L);
     return W;
  end Slv2Str;

  function Str2Hex(value  : String) return String is
    subtype Int03_Typ is Integer range 0 to 3;
    variable Result : string(1 to ((value'length - 1)/4)+1) :=
        (others => '0');
    variable StrTo4 : string(1 to Result'length * 4) := 
        (others => '0');
    variable MTspace : Int03_Typ;  --  Empty space to fill in
    variable Str4    : String(1 to 4);
    variable Group_v   : Natural := 0; 
  begin
    MTspace := Result'length * 4  - value'length; 
    StrTo4(MTspace + 1 to StrTo4'length) := value; -- padded with '0'
    Cnvrt_Lbl : for I in Result'range loop
      Group_v := Group_v + 4;  -- identifies end of bit # in a group of 4 
      Str4 := StrTo4(Group_v - 3 to Group_v); -- get next 4 characters 
      case Str4 is
        when "0000"  => Result(I) := '0';
        when "0001"  => Result(I) := '1'; 
        when "0010"  => Result(I) := '2';
        when "0011"  => Result(I) := '3';
        when "0100"  => Result(I) := '4';
        when "0101"  => Result(I) := '5';
        when "0110"  => Result(I) := '6';
        when "0111"  => Result(I) := '7';
        when "1000"  => Result(I) := '8';
        when "1001"  => Result(I) := '9';
        when "1010"  => Result(I) := 'A';
        when "1011"  => Result(I) := 'B';
        when "1100"  => Result(I) := 'C';
        when "1101"  => Result(I) := 'D';
        when "1110"  => Result(I) := 'E';
        when "1111"  => Result(I) := 'F';
        when others  => Result(I) := 'X';
      end case;                          --  Str4
    end loop Cnvrt_Lbl;
    return Result; 
  end Str2Hex;

  Function Hex2Slv(str: string) return Std_Logic_vector is 
  Constant Len : Natural := str'length;
  Variable Result: Std_Logic_vector(Len * 4 - 1 downto 0);
  begin 
   for i in Len downto 1 loop
       Result(3 +(Len - i)*4  downto (Len-i)*4) := char2quad_bits(str(i));
   end loop;
   return Result;
  end;

  Function Slv2Hex(value :Std_Logic_Vector) return String is 
  begin 
  return Str2Hex(Slv2Str(value));
  end Slv2Hex;
  
  Function Time2Str(value: Time) Return String is
  	Variable L: Line;
  	Variable W: String(1 to MAXCHARTIME):= (Others => ' '); 
  Begin
  	Std.TextIO.WRITE(L, value);
  	W(L.all'range) := L.all;
  	DeAllocate(L);
  	Return W;
  End Time2Str;

  Function Str2Time(str: String) Return Time is
  	Variable T: time;
  Begin
        if StrLen(str)>0 then 
                         T:=time'value(str);      -- Only VHDL version 93
                         Return T;
                     end if;
  End Str2Time;


  Function Str2Int(str: String) Return Integer is
        Variable i:Integer;
  Begin
        if StrLen(str)>0 then 
                         i:=Integer'value(str);
                         Return i;
                         end if;
        Return 0;
  End Str2Int;
  
  Function  Int2Str(value: Integer) Return String is 
  	Variable L: Line;
        Variable W: String(1 to MAXCHARINTEGER):= (Others => ' '); 

  Begin 
   	Std.TextIO.WRITE(L, value);
  	W(L.all'range) := L.all;
  	DeAllocate(L);
        return W;
        
  End Int2Str;
  
  Procedure Line2String( 
                         Variable L: in     Line;
                         Variable S: out    String
                       ) is 

  Begin 
        if (L.all'length > 0) then S(L.all'range) := L.all; end if;
  End Line2String;
  
  
  
  Function int2bit(value: integer) return bit is 
  begin 
  if value=0 then return '0';
             else return '1';
  end if;
  end int2bit;
  
  Function bit2int(b: bit) return integer is
  begin 
  if b='0' then return 0;
           else return 1;
  end if;
  end bit2Int;
  

  
  Function int2vbit(value: Integer; size :Integer) Return bit_vector is
  begin
           Return to_bitvector(conv_std_logic_vector(value,size));
  end int2vbit;

  Function vbit2int(b: bit_vector) Return Integer is
  begin
           Return slv2int(to_stdlogicvector(b));
  end vbit2int;
   
 
End StringLib;
