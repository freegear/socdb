----------------------------------------------------------------------------
--  This file is a part of the ToyARM cache model
--  Copyright (C) 2003  Injoh
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2 of the License, or (at your option) any later version.
--
--  See the file COPYING.LGPL for the full details of the license.


-----------------------------------------------------------------------------   
-- Entity:      cacheic
-- File:        cacheic.vhd
-- Author:      Injo Hwang - Daewoo Electronics
-- Description: This unit implements the instruction cache controller
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
library work;
    use work.cachepkg.all;

entity cacheic is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    -- processor interface
    inmreq   : in  std_logic;
    iseq     : in  std_logic;
    ia       : in  std_logic_vector (31 downto  0);
    inm      : in  std_logic_vector ( 4 downto  0);
    intrans  : in  std_logic;
    id       : out std_logic_vector (31 downto  0);
    iabort   : out std_logic;
    inwait   : out std_logic;
    -- cachectl interface
    paddr    : in  std_logic_vector (11 downto  0);
    psel     : in  std_logic;
    penable  : in  std_logic;
    pwrite   : in  std_logic;
    pwdata   : in  std_logic_vector (31 downto  0);
    crreg    : in  std_logic_vector (31 downto  0);
    -- icachepu interface
    ipaddr   : out std_logic_vector (31 downto  0);
    ipc      : in  std_logic;
    ipap     : in  std_logic_vector ( 1 downto  0);
    -- cachemem interface
    imaddr   : out std_logic_vector (31 downto  0);
    imcen    : out std_logic;
    imten    : out std_logic;
    imden    : out std_logic;
    imwset   : out std_logic_vector ( 1 downto  0);
    imwvalid : out std_logic;
    imwdata  : out std_logic_vector (31 downto  0);
    imrcam0  : in  std_logic_vector (31 downto 10);
    imrcam1  : in  std_logic_vector (31 downto 10);
    imrdata0 : in  std_logic_vector (31 downto  0);
    imrdata1 : in  std_logic_vector (31 downto  0);
    -- acache interface
    iagrant  : in  std_logic;
    iaready  : in  std_logic;
    iaresp   : in  std_logic_vector ( 1 downto  0);
    iardata  : in  std_logic_vector (31 downto  0);
    iabusreq : out std_logic;
    ialock   : out std_logic;
    iatrans  : out std_logic_vector ( 1 downto  0);
    iaaddr   : out std_logic_vector (31 downto  0);
    iawrite  : out std_logic;
    iasize   : out std_logic_vector ( 2 downto  0);
    iaburst  : out std_logic_vector ( 2 downto  0);
    iaprot   : out std_logic_vector ( 3 downto  0);
    iawdata  : out std_logic_vector (31 downto  0)
  );
end cacheic;

architecture behavioral of cacheic is

  type cpstate_type is
  (
    s_cpstate_idle,
    s_cpstate_iureq,
    s_cpstate_invalidateentire,
    s_cpstate_invalidate,
    s_cpstate_prefetch
  );
  type cmstate_type is
  (
    s_cmstate_idle,
    s_cmstate_iureq,
    s_cmstate_invalidate,
    s_cmstate_fetch
  );
  type acstate_type is
  (
    s_acstate_idle,
    s_acstate_external,
    s_acstate_fetch
  );

  -- icache register
  signal cpstate_r : cpstate_type;
  signal cpaddr_r  : std_logic_vector (31 downto  0);
  signal iugrant_r : std_logic_vector ( 1 downto  0);
  signal iureadm_r : std_logic;
  signal iutrans_r : std_logic_vector ( 1 downto  0);
  signal iupriv_r  : std_logic;
  signal iuaddr_r  : std_logic_vector (31 downto  0);
  signal iuprot_r  : std_logic_vector ( 3 downto  0);
  signal iuwset_r  : std_logic_vector ( 1 downto  0);
  signal iuvalid_r : std_logic;
  signal iurtag_r  : std_logic_vector (31 downto 11);
  signal iurdata_r : std_logic_vector (31 downto  0);
  signal cmlru_r   : std_logic_vector (0 to 127);
  signal cmstate_r : cmstate_type;
  signal cmcount_r : std_logic_vector ( 6 downto  0);
  signal cmaddr_r  : std_logic_vector (31 downto  0);
  signal cmwset_r  : std_logic_vector ( 1 downto  0);
  signal acstate_r : acstate_type;
  signal adstate_r : acstate_type;
  signal acgrant_r : std_logic;
  signal acready_r : std_logic;
  signal account_r : std_logic_vector ( 1 downto  0);
  signal acaddr_r  : std_logic_vector (31 downto  0);
  signal adaddr_r  : std_logic_vector (31 downto  0);
  signal acwset_r  : std_logic_vector ( 1 downto  0);
  signal adwset_r  : std_logic_vector ( 1 downto  0);
  signal advalid_r : std_logic_vector ( 3 downto  0);

  -- icache internal signal
  signal gcd_i     : std_logic;
  signal gap_i     : std_logic;
  signal gcmlru_i  : std_logic;
  signal ghitm0_i  : std_logic;
  signal ghitm1_i  : std_logic;
  signal ghitcm_i  : std_logic;
  signal ghitac_i  : std_logic;
  signal gvalac_i  : std_logic;
  signal gvalam_i  : std_logic_vector ( 1 downto  0);
  signal gcminit_i : std_logic;
  signal gextern_i : std_logic;
  signal gfetch_i  : std_logic;
  signal fextern_i : std_logic;
  signal ffetch_i  : std_logic;
  signal fcmread_i : std_logic;
  signal cmreq_i   : cpstate_type;
  signal acreq_i   : acstate_type;
  signal iuwset_i  : std_logic_vector ( 1 downto  0);
  signal iuvalid_i : std_logic;
  signal iurtag_i  : std_logic_vector (31 downto 11);
  signal iurdata_i : std_logic_vector (31 downto  0);
  signal cmstate_i : cmstate_type;
  signal cmaddr_i  : std_logic_vector (31 downto  0);
  signal cmwset_i  : std_logic_vector ( 1 downto  0);
  signal advalid_i : std_logic_vector ( 3 downto  0);

begin

  process (iuaddr_r, iupriv_r, ipc, ipap, crreg)
  begin
    ipaddr <= iuaddr_r;
    gcd_i  <= ipc and crreg(12) and crreg(0);
    case ipap is
    when "00"   => gap_i <= not crreg(0);
    when "01"   => gap_i <= iupriv_r or not crreg(0);
    when "10"   => gap_i <= '1';
    when "11"   => gap_i <= '1';
    when others => gap_i <= '0';
    end case;
--  if (imrcam0(31 downto 11) = imrcam1(31 downto 11) and
--      imrcam0(10) = '1' and imrcam1(10) = '1') then
--    gap_i <= '0';
--  end if;
  end process;

  process (iuaddr_r, cmlru_r, cmstate_r, cmaddr_r, cmcount_r,
           adstate_r, acready_r, adaddr_r, adwset_r, advalid_r, advalid_i,
           gcd_i, ghitac_i, iuvalid_i, imrcam0, imrcam1, iaready)
  begin
-- pragma translate_off
    if not is_x(iuaddr_r) then
-- pragma translate_on
    gcmlru_i <= cmlru_r(conv_integer(iuaddr_r(10 downto 4)));
-- pragma translate_off
    else
    gcmlru_i <= '0';
-- pragma translate_on
-- pragma translate_off
    end if;
-- pragma translate_on
    if (iuaddr_r(31 downto 11)=imrcam0(31 downto 11) and imrcam0(10)='1') then
      ghitm0_i <= '1';
    else
      ghitm0_i <= '0';
    end if;
    if (iuaddr_r(31 downto 11)=imrcam1(31 downto 11) and imrcam1(10)='1') then
      ghitm1_i <= '1';
    else
      ghitm1_i <= '0';
    end if;
    if (iuaddr_r(31 downto 4) = cmaddr_r(31 downto 4)) then
      ghitcm_i <= '1';
    else
      ghitcm_i <= '0';
    end if;
    if (adstate_r = s_acstate_fetch) and
       (iuaddr_r(31 downto 4) = adaddr_r(31 downto 4)) then
      ghitac_i <= '1';
    else
      ghitac_i <= '0';
    end if;
    if ((advalid_i and linemask(iuaddr_r(3 downto 2))) /= "0000") then
      gvalac_i <= '1';
    else
      gvalac_i <= '0';
    end if;
    if (adstate_r = s_acstate_fetch) and
       (iuaddr_r(31 downto 4) = adaddr_r(31 downto 4)) and
       ((advalid_r and linemask(iuaddr_r(3 downto 2))) /= "0000") then
      gvalam_i <= adwset_r;
    else
      gvalam_i <= "00";
    end if;
    if (cmstate_r = s_cmstate_invalidate and cmcount_r = "0000000") or
       (cmstate_r = s_cmstate_iureq) then
      gcminit_i <= '1';
    else
      gcminit_i <= '0';
    end if;
    if (adstate_r = s_acstate_external) then
      gextern_i <= acready_r and iaready;
    else
      gextern_i <= '0';
    end if;
    if (adstate_r = s_acstate_fetch) then
      gfetch_i <= acready_r and iaready;
    else
      gfetch_i <= '0';
    end if;
    fextern_i <= not gcd_i;
    ffetch_i  <= gcd_i and not iuvalid_i and not ghitac_i;
    fcmread_i <= gcd_i and iuvalid_i;
  end process;

  process (iureadm_r, iuwset_r, iuvalid_r, iurtag_r, iurdata_r,
           gcmlru_i, ghitm0_i, ghitm1_i, gvalam_i, gextern_i,
           imrcam0, imrcam1, imrdata0, imrdata1, iardata)
  begin
    if (iureadm_r = '1') then
      if    (ghitm0_i = '1' or gvalam_i = "01") then
        iuwset_i  <= "01";
        iuvalid_i <= '1';
        iurtag_i  <= imrcam0(31 downto 11);
        iurdata_i <= imrdata0;
      elsif (ghitm1_i = '1' or gvalam_i = "10") then
        iuwset_i  <= "10";
        iuvalid_i <= '1';
        iurtag_i  <= imrcam1(31 downto 11);
        iurdata_i <= imrdata1;
      elsif (gcmlru_i = '1') then
        iuwset_i  <= "01";
        iuvalid_i <= '0';
        iurtag_i  <= imrcam0(31 downto 11);
        iurdata_i <= imrdata0;
      else -- (gcmlru_i = '0')
        iuwset_i  <= "10";
        iuvalid_i <= '0';
        iurtag_i  <= imrcam1(31 downto 11);
        iurdata_i <= imrdata1;
      end if;
    else
      iuwset_i  <= iuwset_r;
      iuvalid_i <= iuvalid_r;
      iurtag_i  <= iurtag_r;
      if (gextern_i = '1') then
        iurdata_i <= iardata;
      else
        iurdata_i <= iurdata_r;
      end if;
    end if;
  end process;

  process (cpstate_r, iugrant_r, iutrans_r,
           gap_i, gextern_i, fextern_i, ffetch_i, fcmread_i)
  begin
    if (cpstate_r = s_cpstate_invalidateentire) or
       (cpstate_r = s_cpstate_invalidate) then
      cmreq_i <= cpstate_r;
    elsif (iutrans_r(1) = '0') or (gap_i = '0') or
          (gextern_i = '1') or (fcmread_i = '1') then
      cmreq_i <= s_cpstate_iureq;
    else
      cmreq_i <= s_cpstate_idle;
    end if;
    if (cpstate_r = s_cpstate_prefetch) then
      acreq_i <= s_acstate_fetch;
    elsif (cpstate_r=s_cpstate_idle and iutrans_r(1)='1' and gap_i='1') then
      if (fextern_i = '1') and (iugrant_r = "00") then
        acreq_i <= s_acstate_external;
      elsif (ffetch_i = '1') and (iugrant_r = "00") then
        acreq_i <= s_acstate_fetch;
      else
        acreq_i <= s_acstate_idle;
      end if;
    else
      acreq_i <= s_acstate_idle;
    end if;
  end process;

  process (cpstate_r, cpaddr_r, iuaddr_r, iuvalid_r,
           cmstate_r, cmaddr_r, cmwset_r,
           gextern_i, gfetch_i, gcminit_i, cmreq_i, iuwset_i, iurtag_i)
  begin
    if (gextern_i = '1') then
      cmstate_i <= s_cmstate_iureq;
    elsif (gfetch_i = '1') then
      cmstate_i <= s_cmstate_fetch;
    elsif (gcminit_i = '1') then
      case cmreq_i is
      when s_cpstate_invalidateentire | s_cpstate_invalidate =>
        cmstate_i <= s_cmstate_invalidate;
      when s_cpstate_iureq =>
        cmstate_i <= s_cmstate_iureq;
      when others =>
        cmstate_i <= s_cmstate_idle;
      end case;
    elsif (cmreq_i = s_cpstate_iureq and iuvalid_r = '1') then
      cmstate_i <= s_cmstate_iureq;
    else
      cmstate_i <= cmstate_r;
    end if;
    if (gfetch_i = '0') and (gcminit_i = '1') then
      case cmreq_i is
      when s_cpstate_invalidateentire =>
        cmaddr_i <= (others => '0');
        cmwset_i <= "11";
      when s_cpstate_invalidate =>
        if (cpstate_r /= s_cpstate_idle) then
          cmaddr_i <= x"00000" & '0' & cpaddr_r(31 downto 25) & "0000";
          cmwset_i <= cpaddr_r(4) & not cpaddr_r(4);
        else
          cmaddr_i <= iurtag_i & iuaddr_r(10 downto 2) & "00";
          cmwset_i <= iuwset_i;
        end if;
      when others =>
        cmaddr_i <= (others => '0');
        cmwset_i <= "00";
      end case;
    elsif (gfetch_i = '0') and (cmstate_r = s_cmstate_invalidate) then
      cmaddr_i <= cmaddr_r(31 downto 11)&(cmaddr_r(10 downto 4)+1)&"0000";
      cmwset_i <= cmwset_r;
    else
      cmaddr_i <= (others => '0');
      cmwset_i <= "00";
    end if;
  end process;

  process (adaddr_r, advalid_r, gfetch_i)
  begin
    if (gfetch_i = '1') then
      advalid_i <= advalid_r or linemask(adaddr_r(3 downto 2));
    else
      advalid_i <= advalid_r;
    end if;
  end process;

  process (iutrans_r, iurdata_i, cmstate_i, gap_i)
  begin
    case cmstate_i is
    when s_cmstate_iureq =>
      iabort <= iutrans_r(1) and not gap_i;
      inwait <= '1';
    when others =>
      iabort <= '0';
      inwait <= '0';
    end case;
    id <= iurdata_i;
  end process;

  process (adaddr_r, adwset_r, advalid_i, cmstate_i, cmaddr_i, cmwset_i,
           ia, iardata)
  begin
    case cmstate_i is
    when s_cmstate_iureq =>
      imaddr   <= ia;
      imcen    <= '1';
      imten    <= '0';
      imden    <= '0';
      imwset   <= (others => '0');
      imwvalid <= '0';
      imwdata  <= (others => '0');
    when s_cmstate_invalidate =>
      imaddr   <= cmaddr_i;
      imcen    <= '1';
      imten    <= '1';
      imden    <= '0';
      imwset   <= cmwset_i;
      imwvalid <= '0';
      imwdata  <= (others => '0');
    when s_cmstate_fetch =>
      imaddr   <= adaddr_r;
      imcen    <= '1';
      imten    <= '1';
      imden    <= '1';
      imwset   <= adwset_r;
      if (advalid_i="1111") then imwvalid <= '1'; else imwvalid <= '0'; end if;
      imwdata  <= iardata;
    when others =>
      imaddr   <= (others => '0');
      imcen    <= '0';
      imten    <= '0';
      imden    <= '0';
      imwset   <= (others => '0');
      imwvalid <= '0';
      imwdata  <= (others => '0');
    end case;
  end process;

  process (acstate_r, account_r, acaddr_r, acreq_i)
  begin
    if (acstate_r = s_acstate_fetch and account_r /= "00") or
       (acreq_i = s_acstate_external or acreq_i = s_acstate_fetch) then
      iabusreq <= '1';
    else
      iabusreq <= '0';
    end if;
    if (acstate_r = s_acstate_fetch and account_r /= "00") or
       (acreq_i = s_acstate_fetch) then
      ialock <= '1';
    else
      ialock <= '0';
    end if;
    case acstate_r is
    when s_acstate_external =>
      iatrans <= HTRANS_NONSEQ;
      iaburst <= HBURST_SINGLE;
    when s_acstate_fetch =>
      if (account_r = "11") then
        iatrans <= HTRANS_NONSEQ;
      else
        iatrans <= HTRANS_SEQ;
      end if;
      iaburst <= HBURST_WRAP4;
    when others =>
      iatrans <= HTRANS_IDLE;
      iaburst <= HBURST_SINGLE;
    end case;
    iaaddr  <= acaddr_r;
    iawrite <= '0';
    iasize  <= HSIZE_WORD;
    iaprot  <= (others => '0');
    iawdata <= (others => '0');
  end process;

  process (clk, rst)
  begin
    if (rst = '0') then
      cpstate_r <= s_cpstate_invalidateentire;
      cpaddr_r  <= (others => '0');
    elsif rising_edge(clk) then
      if (cpstate_r = s_cpstate_idle) then
        if (psel = '1' and penable = '1' and pwrite = '1') then
          case paddr is
          when x"704" => -- Flush ICache
            cpstate_r <= s_cpstate_invalidateentire;
            cpaddr_r  <= (others => '0');
          when x"70c" => -- Flush ICache single entry
            cpstate_r <= s_cpstate_invalidate;
            cpaddr_r  <= pwdata;
          when x"74c" => -- Prefetch ICache line
            cpstate_r <= s_cpstate_prefetch;
            cpaddr_r  <= pwdata;
          when others =>
            cpstate_r <= s_cpstate_idle;
            cpaddr_r  <= (others => '0');
          end case;
        end if;
      elsif (cmreq_i /= s_cpstate_idle or acreq_i /= s_acstate_idle) then
        cpstate_r <= s_cpstate_idle;
        cpaddr_r  <= (others => '0');
      end if;
    end if;
  end process;

  process (clk, rst)
    variable v_inmreq : std_logic_vector (31 downto 0);
  begin
    if (rst = '0') then
      iugrant_r <= "00";
      iureadm_r <= '0';
      iutrans_r <= (others => '0');
      iupriv_r  <= '0';
      iuaddr_r  <= (others => '0');
      iuprot_r  <= (others => '0');
      iuwset_r  <= (others => '0');
      iuvalid_r <= '0';
      iurtag_r  <= (others => '0');
      iurdata_r <= (others => '0');
    elsif rising_edge(clk) then
      if (cmstate_i = s_cmstate_iureq) then
        if (acstate_r = s_acstate_idle) or (account_r = "00") or
           (account_r = "01" and iaready = '1' and iagrant = '1') then
          iugrant_r <= "00";
        else
          iugrant_r <= "01";
        end if;
      else
        case iugrant_r is
        when "00" => if (iaready = '1' and iagrant = '1') then
                       iugrant_r <= "11";
                     end if;
        when "01" => if (acstate_r = s_acstate_idle) or (account_r = "00") or
                        (account_r="01" and iaready='1' and iagrant='1') then
                       iugrant_r <= "00";
                     end if;
        when others => null;
        end case;
      end if;
      case cmstate_i is
      when s_cmstate_iureq =>
        v_inmreq := (others => inmreq);
        iureadm_r <= not inmreq;
        iutrans_r <= not inmreq & iseq;
        iupriv_r  <= not inmreq and intrans;
        iuaddr_r  <= not v_inmreq and ia;
        iuprot_r  <= (others => '0');
      when others =>
        iureadm_r <= '0';
      end case;
      iuwset_r  <= iuwset_i;
      if (cmstate_i = s_cmstate_fetch) and
         ((ghitac_i and gvalac_i) = '1') then
        iuvalid_r <= '1';
      else
        iuvalid_r <= iuvalid_i;
      end if;
      iurtag_r  <= iurtag_i;
      if (cmstate_i = s_cmstate_fetch) and (ghitac_i = '1') and
         (iuaddr_r(3 downto 2) = adaddr_r(3 downto 2)) then
        iurdata_r <= iardata;
      else
        iurdata_r <= iurdata_i;
      end if;
    end if;
  end process;

  process (clk, rst)
    variable iuaddr_v : integer range 0 to 127;
  begin
    if (rst = '0') then
      cmstate_r <= s_cmstate_iureq;
      cmlru_r   <= (others => '0');
      cmcount_r <= "0000000";
      cmaddr_r  <= (others => '0');
      cmwset_r  <= (others => '0');
    elsif rising_edge(clk) then
      if (cmstate_i = s_cmstate_iureq and fcmread_i = '1') then
-- pragma translate_off
        if not is_x(iuaddr_r) then
-- pragma translate_on
          iuaddr_v := conv_integer(iuaddr_r(10 downto 4));
          cmlru_r(iuaddr_v) <= iuwset_i(1);
-- pragma translate_off
        end if;
-- pragma translate_on
      end if;
      if (gfetch_i = '0') then
        cmstate_r <= cmstate_i;
        if (gcminit_i = '1') then
          case cmreq_i is
          when s_cpstate_invalidateentire => cmcount_r <= "1111111";
          when s_cpstate_invalidate       => cmcount_r <= "0000000";
          when others                     => cmcount_r <= "0000000";
          end case;
          cmaddr_r  <= cmaddr_i;
          cmwset_r  <= cmwset_i;
        elsif (cmstate_r = s_cmstate_invalidate) then
          cmcount_r <= cmcount_r-'1';
          cmaddr_r  <= cmaddr_i;
        end if;
      end if;
    end if;
  end process;

  process (clk, rst)
  begin
    if (rst = '0') then
      acstate_r <= s_acstate_idle;
      adstate_r <= s_acstate_idle;
      acgrant_r <= '0';
      acready_r <= '0';
      account_r <= "00";
      acaddr_r  <= (others => '0');
      adaddr_r  <= (others => '0');
      acwset_r  <= (others => '0');
      adwset_r  <= (others => '0');
      advalid_r <= (others => '0');
    elsif rising_edge(clk) then
      if (iaready = '1') then
        acgrant_r <= iagrant;
        acready_r <= acgrant_r;
      end if;
      if (iaready = '1') then
        if (iagrant = '1') then
          if (acstate_r = s_acstate_fetch and account_r /= "00") then
            account_r <= account_r-'1';
            acaddr_r  <= acaddr_r(31 downto 4)&(acaddr_r(3 downto 2)+1)&"00";
          else
            case acreq_i is
            when s_acstate_external =>
              acstate_r <= s_acstate_external;
              account_r <= "00";
              acaddr_r  <= iuaddr_r(31 downto 2) & "00";
              acwset_r  <= (others => '0');
            when s_acstate_fetch =>
              acstate_r <= s_acstate_fetch;
              account_r <= "11";
              acaddr_r  <= iuaddr_r(31 downto 2) & "00";
              acwset_r  <= iuwset_i;
            when others =>
              acstate_r <= s_acstate_idle;
              account_r <= "00";
              acaddr_r  <= (others => '0');
              acwset_r  <= (others => '0');
            end case;
          end if;
        else
          acstate_r <= s_acstate_idle;
          account_r <= "00";
          acaddr_r  <= (others => '0');
          acwset_r  <= (others => '0');
        end if;
      end if;
      if (iaready = '1') then
        adstate_r <= acstate_r;
        adaddr_r  <= acaddr_r;
        adwset_r  <= acwset_r;
        if (acstate_r = s_acstate_idle or account_r = "11") then
          advalid_r <= (others => '0');
        else
          advalid_r <= advalid_i;
        end if;
      end if;
    end if;
  end process;
  
end behavioral;

configuration cfg_cacheic of cacheic is
  for behavioral
  end for;
end cfg_cacheic;
