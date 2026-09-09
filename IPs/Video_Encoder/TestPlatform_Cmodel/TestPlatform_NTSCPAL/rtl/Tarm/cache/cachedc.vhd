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
-- Entity:      cachedc
-- File:        cachedc.vhd
-- Author:      Injo Hwang - Daewoo Electronics
-- Description: This unit implements the data cache controller
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_misc.all;
library work;
    use work.cachepkg.all;

entity cachedc is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    -- processor interface
    dnmreq   : in  std_logic;
    dseq     : in  std_logic;
    dmas     : in  std_logic_vector ( 1 downto  0);
    dnrw     : in  std_logic;
    da       : in  std_logic_vector (31 downto  0);
    dnm      : in  std_logic_vector ( 4 downto  0);
    dntrans  : in  std_logic;
    dmore    : in  std_logic;
    dlock    : in  std_logic;
    dden     : in  std_logic;
    dd       : in  std_logic_vector (31 downto  0);
    dabe     : out std_logic;
    dabort   : out std_logic;
    dnwait   : out std_logic;
    ddbe     : out std_logic;
    ddin     : out std_logic_vector (31 downto  0);
    -- cachectl interface
    paddr    : in  std_logic_vector (11 downto  0);
    psel     : in  std_logic;
    penable  : in  std_logic;
    pwrite   : in  std_logic;
    pwdata   : in  std_logic_vector (31 downto  0);
    crreg    : in  std_logic_vector (31 downto  0);
    -- dcachepu interface
    dpaddr   : out std_logic_vector (31 downto  0);
    dpc      : in  std_logic;
    dpb      : in  std_logic;
    dpap     : in  std_logic_vector ( 1 downto  0);
    -- cachemem interface
    dmaddr   : out std_logic_vector (31 downto  0);
    dmcen    : out std_logic;
    dmten    : out std_logic;
    dmden    : out std_logic;
    dmwset   : out std_logic_vector ( 1 downto  0);
    dmwvalid : out std_logic;
    dmwdirty : out std_logic;
    dmwdata  : out std_logic_vector (31 downto  0);
    dmrcam0  : in  std_logic_vector (31 downto  9);
    dmrcam1  : in  std_logic_vector (31 downto  9);
    dmrdata0 : in  std_logic_vector (31 downto  0);
    dmrdata1 : in  std_logic_vector (31 downto  0);
    -- cachewb interface
    dwwrite  : out std_logic;
    dwaddr   : out std_logic_vector (31 downto  0);
    dwsize   : out std_logic_vector ( 1 downto  0);
    dwdata   : out std_logic_vector (31 downto  0);
    dwcount  : in  std_logic_vector ( 3 downto  0);
    -- acache interface
    dacpreq  : out std_logic;
    dagrant  : in  std_logic;
    daready  : in  std_logic;
    daresp   : in  std_logic_vector ( 1 downto  0);
    dardata  : in  std_logic_vector (31 downto  0);
    dabusreq : out std_logic;
    dalock   : out std_logic;
    datrans  : out std_logic_vector ( 1 downto  0);
    daaddr   : out std_logic_vector (31 downto  0);
    dawrite  : out std_logic;
    dasize   : out std_logic_vector ( 2 downto  0);
    daburst  : out std_logic_vector ( 2 downto  0);
    daprot   : out std_logic_vector ( 3 downto  0);
    dawdata  : out std_logic_vector (31 downto  0)
  );
end cachedc;

architecture behavioral of cachedc is
 
  type cpstate_type is
  (
    s_cpstate_idle,
    s_cpstate_iureq,
    s_cpstate_cmwrite,
    s_cpstate_invalidateentire,
    s_cpstate_invalidate,
    s_cpstate_clean,
    s_cpstate_cleaninvalidate
  );
  type cmstate_type is
  (
    s_cmstate_idle,
    s_cmstate_iureq,
    s_cmstate_iuwrite,
    s_cmstate_invalidate,
    s_cmstate_clean,
    s_cmstate_fetch
  );
  type wbstate_type is
  (
    s_wbstate_idle,
    s_wbstate_iuwrite,
    s_wbstate_cmwrite
  );
  type acstate_type is
  (
    s_acstate_idle,
    s_acstate_external,
    s_acstate_fetch
  );

  -- dcache register
  signal cpstate_r : cpstate_type;
  signal cpaddr_r  : std_logic_vector (31 downto  0);
  signal cmgrant_r : std_logic;
  signal iugrant_r : std_logic_vector ( 1 downto  0);
  signal iureadm_r : std_logic;
  signal iulock_r  : std_logic;
  signal iutrans_r : std_logic_vector ( 1 downto  0);
  signal iupriv_r  : std_logic;
  signal iuaddr_r  : std_logic_vector (31 downto  0);
  signal iusize_r  : std_logic_vector ( 1 downto  0);
  signal iuwrite_r : std_logic;
  signal iuprot_r  : std_logic_vector ( 3 downto  0);
  signal iuwset_r  : std_logic_vector ( 1 downto  0);
  signal iuvalid_r : std_logic;
  signal iudirty_r : std_logic;
  signal iurtag_r  : std_logic_vector (31 downto 11);
  signal iurdata_r : std_logic_vector (31 downto  0);
  signal cmlru_r   : std_logic_vector (0 to 127);
  signal cmstate_r : cmstate_type;
  signal cmreadm_r : std_logic;
  signal cmcount_r : std_logic_vector ( 6 downto  0);
  signal cmaddr_r  : std_logic_vector (31 downto  0);
  signal cmwset_r  : std_logic_vector ( 1 downto  0);
  signal cmvalid_r : std_logic;
  signal cmrdata_r : std_logic_vector (31 downto  0);
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

  -- dcache internal signal
  signal gcd_i     : std_logic;
  signal gbd_i     : std_logic;
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
  signal fclean_i  : std_logic;
  signal fcmread_i : std_logic;
  signal fwbwrite_i : std_logic;
  signal fcmwrite_i : std_logic;
  signal cmreq_i   : cpstate_type;
  signal acreq_i   : acstate_type;
  signal iuwset_i  : std_logic_vector ( 1 downto  0);
  signal iuvalid_i : std_logic;
  signal iudirty_i : std_logic;
  signal iurtag_i  : std_logic_vector (31 downto 11);
  signal iurdata_i : std_logic_vector (31 downto  0);
  signal cmstate_i : cmstate_type;
  signal cmaddr_i  : std_logic_vector (31 downto  0);
  signal cmwset_i  : std_logic_vector ( 1 downto  0);
  signal cmvalid_i : std_logic;
  signal cmrdata_i : std_logic_vector (31 downto  0);
  signal wbstate_i : wbstate_type;
  signal advalid_i : std_logic_vector ( 3 downto  0);

begin

  process (iuaddr_r, iuwrite_r, iupriv_r,
           dpc, dpb, dpap, crreg)
  begin
    dpaddr <= iuaddr_r;
    gcd_i  <= dpc and crreg(2) and crreg(0);
    gbd_i  <= dpb and crreg(3) and crreg(0);
    case dpap is
    when "00"   => gap_i <= not crreg(0);
    when "01"   => gap_i <= iupriv_r or not crreg(0);
    when "10"   => gap_i <= not iuwrite_r or iupriv_r or not crreg(0);
    when "11"   => gap_i <= '1';
    when others => gap_i <= '0';
--  if (dmrcam0(31 downto 11) = dmrcam1(31 downto 11) and
--      dmrcam0(10 = '1' and dmrcam1(10) = '1') then
--    gap_i <= '0';
--  end if;
    end case;
  end process;

  process (iuaddr_r, iuwrite_r, cmlru_r, cmstate_r, cmcount_r, cmaddr_r,
           adstate_r, acready_r, adaddr_r, adwset_r, advalid_r, advalid_i,
           gcd_i, gbd_i, ghitac_i, iuvalid_i, iudirty_i,
           dmrcam0, dmrcam1, dwcount, daready)
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
    if (iuaddr_r(31 downto 11)=dmrcam0(31 downto 11) and dmrcam0(10)='1') then
      ghitm0_i <= '1';
    else
      ghitm0_i <= '0';
    end if;
    if (iuaddr_r(31 downto 11)=dmrcam1(31 downto 11) and dmrcam1(10)='1') then
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
       (cmstate_r=s_cmstate_clean and cmcount_r="0000000" and dwcount(3)='0') or
       (cmstate_r = s_cmstate_iureq) or
       (cmstate_r = s_cmstate_idle) then
      gcminit_i <= '1';
    else
      gcminit_i <= '0';
    end if;
    if (adstate_r = s_acstate_external) then 
      gextern_i <= acready_r and daready;
    else
      gextern_i <= '0';
    end if;
    if (adstate_r = s_acstate_fetch) then 
      gfetch_i <= acready_r and daready;
    else
      gfetch_i <= '0';
    end if;
    -- =============================================================
    -- |write|gcd_i|gbd_i|valid|dirty|count|acfet|                 |
    -- =============================================================
    -- |  0     0     x     x     x     x     x  | external        |
    -- |  0     1     x     0     x     x     1  | wait            |
    -- |  0     1     x     0     0     x     0  | fetch           |
    -- |  0     1     x     0     1     x     0  | clean           |
    -- |  0     1     x     1     x     x     x  | cmread          |
    -- |  1     0     0     x     x     x     x  | external        |
    -- |  1     0     1     x     x     0     x  | wait            |
    -- |  1     0     1     x     x     1     x  | wbwrite         |
    -- |  1     1     x     0     x     0     x  | wait            |
    -- |  1     1     x     0     x     1     1  | wait            |
    -- |  1     1     0     1     x     0     x  | wait            |
    -- |  1     1     x     0     x     1     0  | wbwrite         |
    -- |  1     1     0     1     x     1     x  | cmwrite/wbwrite |
    -- |  1     1     1     1     x     x     x  | cmwrite         |
    -- =============================================================
    fextern_i <= (not iuwrite_r and not gcd_i)
              or (iuwrite_r and not gcd_i and not gbd_i);
    ffetch_i  <= not iuwrite_r and gcd_i and not iuvalid_i and not iudirty_i and
                 not ghitac_i;
    fclean_i  <= not iuwrite_r and gcd_i and not iuvalid_i and iudirty_i and
                 not ghitac_i;
    fcmread_i <= not iuwrite_r and gcd_i and iuvalid_i;
    fwbwrite_i <= iuwrite_r and not dwcount(3) and
                  ((not gcd_i and gbd_i) or
                   (gcd_i and not iuvalid_i and not ghitac_i) or
                   (gcd_i and not gbd_i and iuvalid_i));
    fcmwrite_i <= iuwrite_r and gcd_i and iuvalid_i and
                  ((not gbd_i and not dwcount(3)) or (gbd_i and not ghitac_i));
  end process;

  process (iureadm_r, iuwset_r, iuvalid_r, iudirty_r, iurtag_r, iurdata_r,
           cmreadm_r, cmwset_r, cmrdata_r,
           gcmlru_i, ghitm0_i, ghitm1_i, gvalam_i, gextern_i,
           dmrcam0, dmrcam1, dmrdata0, dmrdata1, dardata)
  begin
    if (iureadm_r = '1') then
      if    (ghitm0_i = '1' or gvalam_i = "01") then
        iuwset_i  <= "01";
        iuvalid_i <= '1';
        iudirty_i <= dmrcam0(9);
        iurtag_i  <= dmrcam0(31 downto 11);
        iurdata_i <= dmrdata0;
      elsif (ghitm1_i = '1' or gvalam_i = "10") then 
        iuwset_i  <= "10";
        iuvalid_i <= '1';
        iudirty_i <= dmrcam1(9);
        iurtag_i  <= dmrcam1(31 downto 11);
        iurdata_i <= dmrdata1;
      elsif (gcmlru_i = '1') then
        iuwset_i  <= "01";
        iuvalid_i <= '0';
        iudirty_i <= dmrcam0(10) and dmrcam0(9);
        iurtag_i  <= dmrcam0(31 downto 11);
        iurdata_i <= dmrdata0;
      else -- (gcmlru_i = '0')
        iuwset_i  <= "10";
        iuvalid_i <= '0';
        iudirty_i <= dmrcam1(10) and dmrcam1(9);
        iurtag_i  <= dmrcam1(31 downto 11);
        iurdata_i <= dmrdata1;
      end if;
    else
      iuwset_i  <= iuwset_r;
      iuvalid_i <= iuvalid_r;
      iudirty_i <= iudirty_r;
      iurtag_i  <= iurtag_r;
      if (gextern_i = '1') then
        iurdata_i <= dardata;
      else
        iurdata_i <= iurdata_r;
      end if;
    end if;
    if (cmreadm_r = '1') then
      if (cmwset_r(0) = '1') then
        cmrdata_i <= dmrdata0;
      else
        cmrdata_i <= dmrdata1;
      end if;
    else
      cmrdata_i <= cmrdata_r;
    end if;
  end process;

  process (cpstate_r, cmgrant_r, iugrant_r, iutrans_r,
           gap_i, gextern_i,
           fextern_i, fclean_i, ffetch_i, fcmwrite_i, fwbwrite_i, fcmread_i)
  begin
    if (cpstate_r /= s_cpstate_idle) then
      cmreq_i <= cpstate_r;
    elsif (iutrans_r(1) = '0') or (gap_i = '0') or
          (gextern_i = '1') or (fcmread_i = '1') then
      cmreq_i <= s_cpstate_iureq;
    elsif (fcmwrite_i = '1') then
      cmreq_i <= s_cpstate_cmwrite;
    elsif (fwbwrite_i = '1') then
      cmreq_i <= s_cpstate_iureq;
    elsif (fclean_i = '1' and cmgrant_r = '0') then
      cmreq_i <= s_cpstate_cleaninvalidate;
    else
      cmreq_i <= s_cpstate_idle;
    end if;
    if (cpstate_r=s_cpstate_idle and iutrans_r(1)='1' and gap_i='1') then
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

  process (cpstate_r, cpaddr_r, iuaddr_r,
           iuvalid_r, cmstate_r, cmaddr_r, cmwset_r,
           gextern_i, gfetch_i, gcminit_i,
           cmreq_i, iuwset_i, iurtag_i, dwcount)
  begin
    if (gextern_i = '1') then
      cmstate_i <= s_cmstate_iureq;
    elsif (gfetch_i = '1') then
      cmstate_i <= s_cmstate_fetch;
    elsif (gcminit_i = '1') then
      case cmreq_i is
      when s_cpstate_invalidateentire | s_cpstate_invalidate =>
        cmstate_i <= s_cmstate_invalidate;
      when s_cpstate_clean | s_cpstate_cleaninvalidate =>
        cmstate_i <= s_cmstate_clean;
      when s_cpstate_cmwrite =>
        cmstate_i <= s_cmstate_iuwrite;
      when s_cpstate_iureq =>
        cmstate_i <= s_cmstate_iureq;
      when others =>
        cmstate_i <= s_cmstate_idle;
      end case;
    elsif (cmstate_r = s_cmstate_clean) and (dwcount(3) = '1') then
      cmstate_i <= s_cmstate_idle;
    elsif (cmreq_i = s_cpstate_iureq) and (iuvalid_r = '1') then
      cmstate_i <= s_cmstate_iureq;
    else
      cmstate_i <= cmstate_r;
    end if;
    if (gfetch_i = '0') and (gcminit_i = '1') then
      case cmreq_i is
      when s_cpstate_invalidateentire =>
        cmaddr_i <= (others => '0');
        cmwset_i <= "11";
      when s_cpstate_invalidate | s_cpstate_clean | s_cpstate_cleaninvalidate =>
        if (cpstate_r /= s_cpstate_idle) then
          cmaddr_i <= x"00000" & '0' & cpaddr_r(31 downto 25) & "0000";
          cmwset_i <= not cpaddr_r(4) & cpaddr_r(4);
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
    elsif (gfetch_i='0' and cmstate_r=s_cmstate_clean and dwcount(3)='0') then
      cmaddr_i <= cmaddr_r(31 downto 4) & (cmaddr_r(3 downto 2)+1) & "00";
      cmwset_i <= cmwset_r;
    else
      cmaddr_i  <= (others => '0');
      cmwset_i  <= "00";
    end if;
    if (gfetch_i = '0' and gcminit_i = '1' and cmreq_i = s_cpstate_clean) then
      cmvalid_i <= '1';
    else
      cmvalid_i <= '0';
    end if;
  end process;

  process (cmstate_r, cmstate_i, gfetch_i, fwbwrite_i, dwcount)
  begin
    if (gfetch_i='0' and cmstate_r=s_cmstate_clean and dwcount(3)='0') then
      wbstate_i <= s_wbstate_cmwrite;
    elsif (gfetch_i='0' and cmstate_i=s_cmstate_iureq and fwbwrite_i='1') then
      wbstate_i <= s_wbstate_iuwrite;
    else
      wbstate_i <= s_wbstate_idle;
    end if;
  end process;

  dabe <= '0';
  ddbe <= '0';

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
      dabort <= iutrans_r(1) and not gap_i;
      dnwait <= '1';
    when others =>
      dabort <= '0';
      dnwait <= '0';
    end case;
    ddin <= iurdata_i;
  end process;

  process (iuaddr_r, iusize_r, adaddr_r, adwset_r, advalid_i,
           iuwset_i, iurdata_i, cmstate_i, cmaddr_i, cmwset_i, cmvalid_i, gbd_i,
           da, dd, dardata)
  begin
    case cmstate_i is
    when s_cmstate_iureq =>
      dmaddr   <= da;
      dmcen    <= '1';
      dmten    <= '0';
      dmden    <= '0';
      dmwset   <= (others => '0');
      dmwvalid <= '0';
      dmwdirty <= '0';
      dmwdata  <= (others => '0');
    when s_cmstate_iuwrite =>
      dmaddr   <= iuaddr_r;
      dmcen    <= '1';
      dmten    <= '1';
      dmden    <= '1';
      dmwset   <= iuwset_i;
      dmwvalid <= '1';
      dmwdirty <= gbd_i;
      dmwdata  <= merge(iurdata_i, dd, lanemask(iuaddr_r, iusize_r));
    when s_cmstate_invalidate | s_cmstate_clean =>
      dmaddr   <= cmaddr_i;
      dmcen    <= '1';
      dmten    <= '1';
      dmden    <= '0';
      dmwset   <= cmwset_i;
      dmwvalid <= cmvalid_i;
      dmwdirty <= '0';
      dmwdata  <= (others => '0');
    when s_cmstate_fetch =>
      dmaddr   <= adaddr_r;
      dmcen    <= '1';
      dmten    <= '1';
      dmden    <= '1';
      dmwset   <= adwset_r;
      if (advalid_i="1111") then dmwvalid <= '1'; else dmwvalid <= '0'; end if;
      dmwdirty <= '0';
      dmwdata  <= dardata;
    when others =>
      dmaddr   <= (others => '0');
      dmcen    <= '0';
      dmten    <= '0';
      dmden    <= '0';
      dmwset   <= (others => '0');
      dmwvalid <= '0';
      dmwdirty <= '0';
      dmwdata  <= (others => '0');
    end case;
  end process;

  process (iuaddr_r, iusize_r, cmaddr_r, cmrdata_i, wbstate_i, dd)
  begin
    case wbstate_i is
    when s_wbstate_iuwrite =>
      dwwrite <= '1';
      dwaddr  <= iuaddr_r;
      dwsize  <= iusize_r;
      dwdata  <= dd;
    when s_wbstate_cmwrite =>
      dwwrite <= '1';
      dwaddr  <= cmaddr_r;
      dwsize  <= HSIZE_WORD(1 downto 0);
      dwdata  <= cmrdata_i;
    when others =>
      dwwrite <= '0';
      dwaddr  <= (others => '0');
      dwsize  <= HSIZE_BYTE(1 downto 0);
      dwdata  <= (others => '0');
    end case;
  end process;

  process (iuaddr_r, iuwrite_r, iusize_r, iulock_r,
           acstate_r, account_r, acaddr_r,
           acreq_i, dd)
  begin
    if (iuaddr_r(31 downto 12) = cp15base) then
      dacpreq <= '1';
    else
      dacpreq <= '0';
    end if;
    if (acstate_r = s_acstate_fetch and account_r /= "00") or
       (acreq_i = s_acstate_external or acreq_i = s_acstate_fetch) then
      dabusreq <= '1';
    else
      dabusreq <= '0';
    end if;
    if (acstate_r = s_acstate_fetch and account_r /= "00") or
       (acreq_i = s_acstate_external and iulock_r = '1') or
       (acreq_i = s_acstate_fetch) then
      dalock <= '1';
    else
      dalock <= '0';
    end if;
    case acstate_r is
    when s_acstate_external =>
      datrans <= HTRANS_NONSEQ;
      dawrite <= iuwrite_r;
      dasize  <= '0' & iusize_r;
      daburst <= HBURST_SINGLE;
    when s_acstate_fetch =>
      if (account_r = "11") then
        datrans <= HTRANS_NONSEQ;
      else
        datrans <= HTRANS_SEQ;
      end if;
      dawrite <= '0';
      dasize  <= HSIZE_WORD;
      daburst <= HBURST_WRAP4;
    when others =>
      datrans <= HTRANS_IDLE;
      dawrite <= '0';
      dasize  <= HSIZE_BYTE;
      daburst <= HBURST_SINGLE;
    end case;
    daaddr  <= acaddr_r;
    daprot  <= (others => '0');
    dawdata <= dd;
  end process;

  process (clk, rst)
  begin
    if (rst = '0') then
      cpstate_r <= s_cpstate_invalidateentire;
      cpaddr_r  <= (others => '0');
    elsif rising_edge(clk) then
      if (cpstate_r = s_cpstate_idle) then
        if (psel = '1') and (penable = '1') and (pwrite = '1') then
          case paddr is
          when x"71c" => -- Flush DCache
            cpstate_r <= s_cpstate_invalidateentire;
            cpaddr_r  <= (others => '0');
          when x"724" => -- Flush DCache single entry
            cpstate_r <= s_cpstate_invalidate;
            cpaddr_r  <= pwdata;
          when x"73c" => -- Clean DCache single entry
            cpstate_r <= s_cpstate_clean;
            cpaddr_r  <= pwdata;
          when x"754" => -- Clean and flush DCache single entry
            cpstate_r <= s_cpstate_cleaninvalidate;
            cpaddr_r  <= pwdata;
          when others =>
            cpstate_r <= s_cpstate_idle;
            cpaddr_r  <= (others => '0');
          end case;
        end if;
      elsif (cmreq_i /= s_cpstate_idle) then
        cpstate_r <= s_cpstate_idle;
        cpaddr_r  <= (others => '0');
      end if;
    end if;
  end process;

  process (clk, rst)
    variable v_dnmreq : std_logic_vector (31 downto 0);
  begin
    if (rst = '0') then
      cmgrant_r <= '0';
      iugrant_r <= "00";
      iureadm_r <= '0';
      iulock_r  <= '0';
      iutrans_r <= (others => '0');
      iupriv_r  <= '0';
      iuaddr_r  <= (others => '0');
      iuwrite_r <= '0';
      iusize_r  <= (others => '0');
      iuprot_r  <= (others => '0');
      iuwset_r  <= (others => '0');
      iuvalid_r <= '0';
      iudirty_r <= '0';
      iurtag_r  <= (others => '0');
      iurdata_r <= (others => '0');
    elsif rising_edge(clk) then
      if (cmstate_i = s_cmstate_iureq) then
        cmgrant_r <= '0';
      elsif (cmgrant_r = '0' and
             cmstate_r = s_cmstate_clean and fclean_i = '1') then
        cmgrant_r <= '1';
      end if;
      if (cmstate_i = s_cmstate_iureq) then
        if (acstate_r = s_acstate_idle) or (account_r = "00") or
           (account_r = "01" and daready = '1' and dagrant = '1') then
          iugrant_r <= "00";
        else
          iugrant_r <= "01";
        end if;
      else
        case iugrant_r is
        when "00" => if (daready = '1' and dagrant = '1') then
                       iugrant_r <= "11";
                     end if;
        when "01" => if (acstate_r = s_acstate_idle) or (account_r = "00") or
                        (account_r="01" and daready='1' and dagrant='1') then
                       iugrant_r <= "00";
                     end if;
        when others => null;
        end case;
      end if;
      if (cmstate_i = s_cmstate_iureq) then
        iureadm_r <= not dnmreq;
      else
        iureadm_r <= '0';
      end if;
      case cmstate_i is
      when s_cmstate_iureq =>
        v_dnmreq := (others => dnmreq);
        iulock_r  <= not dnmreq and dlock;
        iutrans_r <= not dnmreq & dseq;
        iupriv_r  <= not dnmreq and dntrans;
        iuaddr_r  <= not v_dnmreq and da;
        iusize_r  <= not v_dnmreq(1 downto 0) and dmas;
        iuwrite_r <= not dnmreq and dnrw;
        iuprot_r  <= (others => '0');
      when s_cmstate_iuwrite =>
        iutrans_r <= "00";
      when others => null;
      end case;
      if (cmstate_i = s_cmstate_fetch) and (ghitac_i = '1') then
        iuwset_r  <= adwset_r;
      else
        iuwset_r  <= iuwset_i;
      end if;
      if (cmstate_i = s_cmstate_clean) then
        iuvalid_r <= '0';
      elsif (cmstate_i = s_cmstate_fetch) and
            (ghitac_i = '1' and gvalac_i = '1') then
        iuvalid_r <= '1';
      else
        iuvalid_r <= iuvalid_i;
      end if;
      if (cmstate_r = s_cmstate_clean and
          cmcount_r = "0000000" and dwcount(3) = '0') then
        iudirty_r <= '0';
      else
        iudirty_r <= iudirty_i;
      end if;
      iurtag_r  <= iurtag_i;
      if (cmstate_i = s_cmstate_fetch) and (ghitac_i = '1') and
         (iuaddr_r(3 downto 2) = adaddr_r(3 downto 2)) then
        iurdata_r <= dardata;
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
      cmreadm_r <= '0';
      cmlru_r   <= (others => '0');
      cmcount_r <= "0000000";
      cmaddr_r  <= (others => '0');
      cmwset_r  <= "11";
      cmvalid_r <= '0';
      cmrdata_r <= (others => '0');
    elsif rising_edge(clk) then
      if (cmstate_i = s_cmstate_clean) then
        cmreadm_r <= '1';
      else
        cmreadm_r <= '0';
      end if;
      case cmstate_i is
      when s_cmstate_iureq =>
        if (fcmread_i = '1' or fcmwrite_i = '1') then
-- pragma translate_off
          if not is_x(iuaddr_r) then
-- pragma translate_on
          iuaddr_v := conv_integer(iuaddr_r(10 downto 4));
          cmlru_r(iuaddr_v) <= iuwset_i(1);
-- pragma translate_off
          end if;
-- pragma translate_on
        end if;
      when s_cmstate_invalidate | s_cmstate_clean =>
-- pragma translate_off
        if not is_x(cmaddr_i) then
-- pragma translate_on
        cmlru_r(conv_integer(cmaddr_i(10 downto 4))) <= cmwset_i(0);
-- pragma translate_off
        end if;
-- pragma translate_on
      when others => null;
      end case;
      if (gfetch_i = '0') then
        if (gcminit_i = '1') then
          case cmreq_i is
          when s_cpstate_invalidateentire =>
            cmstate_r <= cmstate_i; cmcount_r <= "1111111";
          when s_cpstate_invalidate =>
            cmstate_r <= cmstate_i; cmcount_r <= "0000000";
          when s_cpstate_clean =>
            cmstate_r <= cmstate_i; cmcount_r <= "0000011";
          when s_cpstate_cleaninvalidate =>
            cmstate_r <= cmstate_i; cmcount_r <= "0000011";
          when others =>
            cmstate_r <= s_cmstate_idle; cmcount_r <= "0000000";
          end case;
          cmaddr_r  <= cmaddr_i;
          cmwset_r  <= cmwset_i;
          cmvalid_r <= cmvalid_i;
        elsif (cmstate_r /= s_cmstate_clean or dwcount(3) = '0') and
              (cmcount_r /= "0000000") then
          cmcount_r <= cmcount_r-'1';
          cmaddr_r  <= cmaddr_i;
        end if;
      end if;
      if (cmreadm_r = '1') then
        cmrdata_r <= cmrdata_i;
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
      if (daready = '1') then
        acgrant_r <= dagrant;
        acready_r <= acgrant_r;
      end if;
      if (daready = '1') then
        if (dagrant = '1') then
          if (acstate_r = s_acstate_fetch and account_r /= "00") then
            account_r <= account_r-'1';
            acaddr_r  <= acaddr_r(31 downto 4)&(acaddr_r(3 downto 2)+1)&"00";
          else
            case acreq_i is
            when s_acstate_external =>
              acstate_r <= s_acstate_external;
              account_r <= "00";
              case iusize_r is
              when "00"   => acaddr_r <= iuaddr_r(31 downto 0);
              when "01"   => acaddr_r <= iuaddr_r(31 downto 1) & "0";
              when "10"   => acaddr_r <= iuaddr_r(31 downto 2) & "00";
              when others => acaddr_r <= (others => '0');
              end case;
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
      if (daready = '1') then
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

configuration cfg_cachedc of cachedc is
  for behavioral
  end for;
end cfg_cachedc;
