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
-- Entity:      cachereg
-- File:        cachereg.vhd
-- Author:      Injo Hwang - Daewoo Electronics
-- Description: Cache controller and register
------------------------------------------------------------------------------  

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.conv_integer;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_misc.all;
library work;
    use work.cachepkg.all;

entity cachereg is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    -- acache interface
    paddr    : in  std_logic_vector (11 downto  0);
    psel     : in  std_logic;
    penable  : in  std_logic;
    pwrite   : in  std_logic;
    pwdata   : in  std_logic_vector (31 downto  0);
    prdata   : out std_logic_vector (31 downto  0);
    -- cachectl interface
    caddr    : out std_logic_vector (11 downto  0);
    cselip   : out std_logic;
    cseldp   : out std_logic;
    cselic   : out std_logic;
    cseldc   : out std_logic;
    cselwb   : out std_logic;
    cenable  : out std_logic;
    cwrite   : out std_logic;
    cwdata   : out std_logic_vector (31 downto  0);
    crdataip : in  std_logic_vector (31 downto  0);
    crdatadp : in  std_logic_vector (31 downto  0);
    crreg    : out std_logic_vector (31 downto  0)
  );
end cachereg;

architecture behavioral of cachereg is

  -- main id register
  signal mid_implementor_r : std_logic_vector (31 downto 24);
  signal mid_variant_r     : std_logic_vector (23 downto 20);
  signal mid_arch_r        : std_logic_vector (19 downto 16);
  signal mid_primarypn_r   : std_logic_vector (15 downto  4);
  signal mid_revision_r    : std_logic_vector ( 3 downto  0);

  -- cache type register
  signal ct_ctype_r : std_logic_vector (28 downto 25);
  signal ct_s_r     : std_logic;
  signal ct_dsize_r : std_logic_vector (23 downto 12);
  signal ct_isize_r : std_logic_vector (11 downto  0);

  -- control register
  signal ctl_i_r    : std_logic;
  signal ctl_b_r    : std_logic;
  signal ctl_w_r    : std_logic;
  signal ctl_c_r    : std_logic;
  signal ctl_m_r    : std_logic;

begin

  process (mid_implementor_r, mid_variant_r, mid_arch_r,
           mid_primarypn_r, mid_revision_r,
           ct_ctype_r, ct_s_r, ct_dsize_r, ct_isize_r,
           ctl_i_r, ctl_b_r, ctl_w_r, ctl_c_r, ctl_m_r,
           paddr, psel, penable, pwrite, pwdata, crdataip, crdatadp)
  begin
    if (psel = '1' and pwrite = '0') then
      case paddr(11 downto 0) is
      when x"000" =>
        prdata(31 downto 24) <= mid_implementor_r;
        prdata(23 downto 20) <= mid_variant_r;
        prdata(19 downto 16) <= mid_arch_r;
        prdata(15 downto  4) <= mid_primarypn_r;
        prdata( 3 downto  0) <= mid_revision_r;
      when x"004" =>
        prdata(31 downto 29) <= (others => '0');
        prdata(28 downto 25) <= ct_ctype_r;
        prdata(24)           <= ct_s_r;
        prdata(23 downto 12) <= ct_dsize_r;
        prdata(11 downto  0) <= ct_isize_r;
      when x"100" =>
        prdata(31 downto 13) <= (others => '0');
        prdata(12) <= ctl_i_r;
        prdata(11 downto 8)  <= (others => '0');
        prdata(7)  <= ctl_b_r;
        prdata(6 downto 4)   <= (others => '0');
        prdata(3)  <= ctl_w_r;
        prdata(2)  <= ctl_c_r;
        prdata(1)  <= '0';
        prdata(0)  <= ctl_m_r;
      when x"200"|x"300"|x"500"|
           x"600"|x"604"|x"608"|x"60c"|x"610"|x"614"|x"618"|x"61c" =>
        prdata <= crdatadp;
      when x"204"|x"504"|
           x"620"|x"624"|x"628"|x"62c"|x"630"|x"634"|x"638"|x"63c" =>
        prdata <= crdataip;
      when others =>
        prdata <= (others => '0');
      end case;
    else
      prdata <= (others => '0');
    end if;

    case paddr(11 downto 0) is
    when x"200"|x"300"|x"500"|
         x"600"|x"604"|x"608"|x"60c"|x"610"|x"614"|x"618"|x"61c" =>
      cseldp <= psel;
    when others =>
      cseldp <= '0';
    end case;
    case paddr(11 downto 0) is
    when x"204"|x"504"|
         x"620"|x"624"|x"628"|x"62c"|x"630"|x"634"|x"638"|x"63c" =>
      cselip <= psel;
    when others =>
      cselip <= '0';
    end case;
    case paddr(11 downto 0) is
    when x"704"|x"708"|x"70c"|x"74c" =>
      cselic <= psel;
    when others =>
      cselic <= '0';
    end case;
    case paddr(11 downto 0) is
    when x"71c"|x"720"|x"724"|x"738"|x"73c"|x"750"|x"754" =>
      cseldc <= psel;
    when others =>
      cseldc <= '0';
    end case;
    case paddr(11 downto 0) is
    when x"740" =>
      cselwb <= psel;
    when others =>
      cselwb <= '0';
    end case;
    caddr   <= paddr;
    cenable <= penable;
    cwrite  <= pwrite;
    cwdata  <= pwdata;

    crreg(31 downto 13) <= (others => '0');
    crreg(12) <= ctl_i_r;
    crreg(11 downto 8)  <= (others => '0');
    crreg(7)  <= ctl_b_r;
    crreg(6 downto 4)   <= (others => '0');
    crreg(3)  <= ctl_w_r;
    crreg(2)  <= ctl_c_r;
    crreg(1)  <= '0';
    crreg(0)  <= ctl_m_r;
  end process;

  mid_implementor_r <= (others => '0');
  mid_variant_r     <= (others => '0');
  mid_arch_r        <= "0001"; -- Architecture 4
  mid_primarypn_r   <= (others => '0');
  mid_revision_r    <= (others => '0');
  ct_ctype_r <= "0010"; -- Write-back/Cache cleaning
  ct_s_r     <= '1';    -- Separate instruction and data cache
  ct_dsize_r <= "000" &
                "011" & -- 4KB
                "001" & -- 2-way
                '0'   & -- M=0
                "01";   -- 4 words
  ct_isize_r <= "000" &
                "011" & -- 4KB
                "001" & -- 2-way
                '0'   & -- M=0
                "01";   -- 4 words

  ctl_b_r <= '0';    -- Configured for little-endian memory system
  ctl_w_r <= '1';    -- Write buffer enabled
  process (clk, rst)
  begin
    if (rst = '0') then
      ctl_i_r <= '1';    -- Instruction cache enabled
--    ctl_b_r <= '0';    -- Configured for little-endian memory system
--    ctl_w_r <= '1';    -- Write buffer enabled
      ctl_c_r <= '1';    -- Data Cache enabled
      ctl_m_r <= '0';    -- Protection Unit disabled
    elsif rising_edge(clk) then
      if (psel = '1' and penable = '1' and pwrite = '1') then
        case paddr(11 downto 0) is
        when x"100" =>
          ctl_i_r <= pwdata(12);
--        ctl_b_r <= pwdata(7);
--        ctl_w_r <= pwdata(3);
          ctl_c_r <= pwdata(2);
          ctl_m_r <= pwdata(0);
        when others =>
        end case;
      end if;
    end if;
  end process;

end behavioral;

configuration cfg_cachereg of cachereg is
  for behavioral
  end for;
end cfg_cachereg;
