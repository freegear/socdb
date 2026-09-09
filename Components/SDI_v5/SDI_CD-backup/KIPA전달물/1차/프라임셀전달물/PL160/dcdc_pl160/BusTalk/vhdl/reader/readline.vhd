-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 1998 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
-- 
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
-- 
-- File Name           : readline.vhd,v 
-- File Revision       : 1.2 
-- 
-- Release Information : PL160-REL1v1 
-- 
-- -----------------------------------------------------------------------------
-- Purpose             : When called, this procedure will pass out a message
--                       string, a cycle type and three packets (only one of
--                       which will be relevant).
--                       The packet can be defined in defs.vhd and then the
--                       assignments made depending on the cycle type can be
--                       tailored for each test type.
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library Std_DevelopersKit;
use     std_DevelopersKit.Std_Regpak.all;
use     std_developerskit.std_IOpak.all;

library common;
use     common.defs.all;
use     common.funcs.all;

package readline is

procedure readline (
                    variable iINFILE    : in  ascii_text;
                    variable apb_packet : out T_apb;
                    variable vr_packet  : out T_vr;
                    variable res_packet : out T_res;
                    variable cyc_sel    : out T_cycle
                    );
end readline;

package body readline is
  
  procedure readline (
                      variable iINFILE    : in  ascii_text;
                      variable apb_packet : out T_apb;
                      variable vr_packet  : out T_vr;
                      variable res_packet : out T_res;
                      variable cyc_sel    : out T_cycle
                     ) is
    
  -- there is a string variable for each argument type. This should be extended
  -- for further test benches to include argument strings for every occasion so
  -- that this readline procedure can be generic to any test bench.
    
    variable linestr  : string(1 to 256);
    variable cycstr   : string(1 to 2);
    variable header   : string(1 to 2000);
    variable strend   : character;
    constant endofstr : character:= NUL;
    variable countv1  : integer;
    variable countv2  : integer;
    
    variable addrstr  : string(1 to 8);
    variable countstr : string(1 to 2);    
    variable datastr  : string(1 to 8);
    variable maskstr  : string(1 to 8);
    variable expstr   : string(1 to 8);
    variable limitstr : string(1 to 8);
    variable phasestr : string(1 to 1);
    variable edgestr  : string(1 to 1);
    variable delaystr : string(1 to 2);
    variable regstr   : string(1 to 2);
    variable tagstr   : string(1 to 20);

    variable regnum   : string(1 to 1);

    -- bit vector variables for intermediate use when converting string
    -- into std_logic types
    
    variable count_bv : bit_vector(7 downto 0);
    variable delay_bv : bit_vector(7 downto 0);
    variable addr_bv  : bit_vector(31 downto 0);

    variable data_bv  : bit_vector(31 downto 0);
    variable mask_bv  : bit_vector(31 downto 0);
    variable exp_bv   : bit_vector(31 downto 0);
    variable limit_bv : bit_vector(31 downto 0);

    variable sel_bv   : bit_vector(3 downto 0);
    variable printstr : string(1 to 255);
                      
    variable vdata_bv : bit_vector(31 downto 0);
    variable vmask_bv : bit_vector(31 downto 0);
    variable vexp_bv  : bit_vector(31 downto 0);
 
  begin
  -- This bit at the front strips out extra comments to give the one
  -- preceeding a command

  -- This procedure interprets the ";-" character sequence as the start
  -- of a single comment. The body of the comment will be displayed using
  -- the VHDL assert statement.
  --  
  -- This procedure also interprets the "--" character sequence as the start
  -- of a header. A header is constructed using a sequence of C() commands
  -- with the tag field set to "header". All these C() commands will be
  -- concatenated and printed on screen using a single VHDL assert statement.  
  -- eg: C("This is the first line of the header",header);
  --     C("This is second line of the header",header);
  -- 
  -- Note : There should NOT be any white space between the , and the tag.
  --        The spacing should be exactly as shown in the example above.

  if not endfile(iINFILE) then    
    fgetline (linestr,iINFILE);
    fscan (linestr,"%s",cycstr);
    if (cycstr = ";-") then
      assert false report linestr severity note;
    elsif (cycstr = "--") then
       StrCpy(header, linestr);
    end if;
   
    while cycstr = "--" loop
      fgetline (linestr, iINFILE);
      fscan (linestr,"%s", cycstr);
      countv1 := 1;
      countv2 := 1;
      strend := header(countv1);
      if (cycstr = "--") then
           while strend /= endofstr loop
            countv1 := countv1 + 1;
            strend := header(countv1);
           end loop;
 
           countv1 := countv1 - 1;
           strend := linestr(countv2);
 
           while strend /= endofstr loop
            header(countv1 + countv2) := linestr(countv2);
            countv2 := countv2 + 1;
            strend := linestr(countv2);
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
    
    -- A big if-elsif structure to look at the cycle types and write output

-------------------------------------------------------------------------------
--  APB Cycle commands
-------------------------------------------------------------------------------

      if cycstr = "NW" or cycstr = "LW" then
        apb_packet.write := '1';
        apb_packet.num_cyc := 2;
        if cycstr = "NW" then
          cyc_sel := c_pnw;
          apb_packet.sel := '0';
        else 
          cyc_sel := c_psw;
          apb_packet.sel := '1';
        end if;
   
        fscan(linestr,"%s %s %s %s",cycstr,datastr,addrstr,tagstr);

        apb_packet.tag      := tagstr;
        addr_bv := from_hexstring(addrstr);
        apb_packet.addr := to_stdlogicvector(addr_bv);

        if datastr = "ZZZZZZZZ" then
          apb_packet.data := (others => 'Z');
        else
          data_bv := from_hexstring(datastr);
          apb_packet.data := to_stdlogicvector(data_bv);
        end if;
  
      elsif cycstr = "NR"  then
        cyc_sel := c_pnr;
        apb_packet.sel := '0';
        apb_packet.write := '0';
        apb_packet.num_cyc := 2;
    
        fscan(linestr," %s %s %s",cycstr,addrstr,tagstr);

        apb_packet.tag      := tagstr;      
        addr_bv := from_hexstring(addrstr);
        apb_packet.addr := to_stdlogicvector(addr_bv);
     
      elsif cycstr = "LR"  then
        cyc_sel := c_psr;
        apb_packet.sel := '1';
        apb_packet.write := '0';
        apb_packet.num_cyc := 2;
    
        fscan(linestr,"%s %s %s %s %s",cycstr,expstr,maskstr,addrstr,tagstr);

        apb_packet.tag      := tagstr;      

        if expstr = "ZZZZZZZZ" then
          apb_packet.exp := (others => 'Z');
        else
          exp_bv := from_hexstring(expstr); 
          apb_packet.exp := to_stdlogicvector(exp_bv);
        end if;
 
        if maskstr = "ZZZZZZZZ" then
          apb_packet.exp := (others => 'Z');
        else
          mask_bv := from_hexstring(maskstr); 
          apb_packet.mask := to_stdlogicvector(mask_bv);
        end if;

        addr_bv := from_hexstring(addrstr);
        apb_packet.addr := to_stdlogicvector(addr_bv);

      elsif cycstr = "PI"  then
        apb_packet.sel := '0';
        cyc_sel := c_pi;

        fscan(linestr," %s %s %s",cycstr,countstr,tagstr);

        apb_packet.tag      := tagstr;      
        count_bv := from_hexstring(countstr);
        apb_packet.num_cyc := to_integer(count_bv, unsigned);

-------------------------------------------------------------------------------
-- Poll command
-------------------------------------------------------------------------------
      elsif cycstr = "PO" then
        cyc_sel := c_po;
        apb_packet.sel := '1';
        apb_packet.write := '0';
        apb_packet.num_cyc := 2;

        fscan(linestr,"%s %s %s %s %s %s",cycstr,expstr,maskstr,addrstr,
              limitstr, tagstr); 

        apb_packet.tag      := tagstr;

        if expstr = "ZZZZZZZZ" then
          apb_packet.exp := (others => 'Z');
        else
          exp_bv := from_hexstring(expstr);
          apb_packet.exp := to_stdlogicvector(exp_bv);
        end if;

        if maskstr = "ZZZZZZZZ" then
          apb_packet.exp := (others => 'Z');
        else
          mask_bv := from_hexstring(maskstr); 
          apb_packet.mask := to_stdlogicvector(mask_bv);
        end if;

        addr_bv := from_hexstring(addrstr);
        apb_packet.addr := to_stdlogicvector(addr_bv);

        limit_bv := from_hexstring(limitstr);
        apb_packet.limit := to_stdlogicvector(limit_bv);

-------------------------------------------------------------------------------
--  Virtual Register commands
-------------------------------------------------------------------------------

      elsif cycstr = "VW" or cycstr = "VR" then

        if cycstr = "VR" then
          cyc_sel := c_vr;
          fscan(linestr,"%s %s %s %s %s %s %s",cycstr,regstr,expstr,maskstr,
                edgestr, delaystr, tagstr);         
  
          vr_packet.write := '0';
    
          if expstr = "ZZZZZZZZ" then
            vr_packet.exp := (others => 'Z');
          else
            exp_bv := from_hexstring(expstr); 
            vexp_bv := exp_bv(31 downto 0);
            vr_packet.exp := to_stdlogicvector(vexp_bv);
          end if;
    
          if edgestr = "/" then
            vr_packet.edge := '1';
          elsif edgestr = "\" then -- "to make the fontify right below this line
            vr_packet.edge := '0';
          end if;
  
        else         --  Then the command is VW
  
          cyc_sel := c_vw;
      
          fscan(linestr,"%s %s %s %s %s %s",cycstr,regstr,datastr,maskstr,
                phasestr, delaystr);
    
          vr_packet.write := '1';
  
          if datastr = "ZZZZZZZZ" then
            vr_packet.data := (others => 'Z');
          else
            data_bv := from_hexstring(datastr); 
            vdata_bv := data_bv(31 downto 0);
            vr_packet.data := to_stdlogicvector(vdata_bv);
          end if;
  
          if phasestr = "L" then
            vr_packet.phase := '0';
          elsif phasestr = "H" then
            vr_packet.phase := '1';
          end if;
    
        end if;

  --  The remaining packet information  is common to the two commands

        delay_bv := from_hexstring(delaystr);
        vr_packet.delay := to_integer(delay_bv,unsigned);
        vr_packet.tag := tagstr;


   --  Register number assignment. Up to 8 registers can be defined.

        regnum := regstr(2 to 2);
        vr_packet.vregno := From_string(regnum);
  
        if maskstr = "ZZZZZZZZ" then
          vr_packet.mask := (others => 'Z');
        else
          mask_bv := from_hexstring(maskstr); 
          vmask_bv := mask_bv(31 downto 0); 
          vr_packet.mask := to_stdlogicvector(vmask_bv);
        end if;
  
-------------------------------------------------------------------------------
--  Bus Reset command
-------------------------------------------------------------------------------

      elsif cycstr = "RE" then
  
        cyc_sel := c_res;
      
        fscan(linestr,"%s %s %s %s",cycstr,phasestr,delaystr,countstr);
  
        delay_bv := from_hexstring(delaystr);
        res_packet.delay := to_integer(delay_bv,unsigned);
  
        count_bv := from_hexstring(countstr);
        res_packet.num_cyc := to_integer(count_bv,unsigned);
  
        if phasestr = "L" then
          res_packet.phase := '0';
        elsif phasestr = "H" then
          res_packet.phase := '1';
        end if;

-------------------------------------------------------------------------------
--  Test End command
-------------------------------------------------------------------------------

      elsif cycstr = "TE" then

        cyc_sel := c_end;

      end if;    
    end if;
 
  end readline;

end readline;

-- --================================= End ===================================--
