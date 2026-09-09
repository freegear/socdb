--------------------------------------------------------------------------------
-- TITLE :                 I2C Master Core For FPGA
-- FILE NAME :             i2cm_fpga_top.vhd
-- AUTHER :                Jinil Chung (jichung@konkuk.ac.kr)
-- ORGANIZATION :          Konkuk Univ. VLSI Design Lab.
-- CREATED :               Februray 15, 2002
-- LAST UPDATED :          Februray 15, 2002
-- PLATFORM :              MS Windows 2000 professional
-- SIMULATOR :             ModelSim SE 5.5c
-- SYNTHESIZER :           Synplify pro 7.0
-- TARGET :                FPGA (ALTERA EPF10K10TC144-3)
-- DISCRIPTION :           This module defines I2C Master Core for FPGA
-- REVISION NUMBER :       -
-- VERSION NUMBER :        1.0
-- DATE OF CHANGE :        -
-- MODIFIEER :             -
-- DESCRIPTION OF CHANGE : -
-- NOTICE :                -
--------------------------------------------------------------------------------

library IEEE ;
use IEEE.std_logic_1164.all ;
use IEEE.std_logic_arith.all ;
use IEEE.std_logic_unsigned.all ;


entity i2cm_fpga_top is
  port (
        clk      : in  std_logic ; -- system clock
        rst_n    : in  std_logic ; -- asychronous reset, active low
        rst_sn   : in  std_logic ; -- sychronous reset,  active high
        addr     : in  std_logic_vector (2 downto 0) ; -- lower address bits
        dat_i    : in  std_logic_vector (7 downto 0) ; -- databus input
        we_i     : in  std_logic ; -- write enable input
        stb_i    : in  std_logic ; -- strobe signals / core select signal
        cyc_i    : in  std_logic ; -- valid bus cycle input

        dat_o    : out std_logic_vector (7 downto 0) ; -- databus output
        ack_o    : out std_logic ; -- bus cycle acknowledge output
        inta_o   : out std_logic ; -- interrupt request output signal
        tst_led  : out std_logic ; -- led for test

        scl      : inout std_logic ;
        sda      : inout std_logic 
  ) ;
end i2cm_fpga_top ;


architecture rtl of i2cm_fpga_top is
  component i2cm_top
    port (
          clk      : in  std_logic ; -- system clock
          rst_n    : in  std_logic ; -- asychronous reset, active low
          rst_sn   : in  std_logic ; -- sychronous reset,  active high
          addr     : in  std_logic_vector (2 downto 0) ; -- lower address bits
          dat_i    : in  std_logic_vector (7 downto 0) ; -- databus input
          we_i     : in  std_logic ; -- write enable input
          stb_i    : in  std_logic ; -- strobe signals / core select signal
          cyc_i    : in  std_logic ; -- valid bus cycle input
          scl_i    : in  std_logic ; -- SCL input
          sda_i    : in  std_logic ; -- SDA input

          dat_o    : out std_logic_vector (7 downto 0) ; -- databus output
          ack_o    : out std_logic ; -- bus cycle acknowledge output
          inta_o   : out std_logic ; -- interrupt request output signal
          scl_o    : out std_logic ; -- SCL output
          scl_oen  : out std_logic ; -- SCL output enable, active low
          sda_o    : out std_logic ; -- SDA output
          sda_oen  : out std_logic   -- SDA output enable, active low
    ) ;
  end component ;

  component i2cm_led
    port (
        clk     : in  std_logic ;
        rst_n   : in  std_logic ;

        tst_led : out std_logic
    ) ;
  end component ;

  signal scl_i_a   : std_logic ;
  signal sda_i_a   : std_logic ;
  signal dat_o_a   : std_logic_vector (7 downto 0) ;
  signal ack_o_a   : std_logic ;
  signal inta_o_a  : std_logic ;
  signal scl_o_a   : std_logic ;
  signal scl_oen_a : std_logic ;
  signal sda_o_a   : std_logic ;
  signal sda_oen_a : std_logic ;
  signal tst_led_a : std_logic ;
begin


--------------------------------------------------------------------------------
-- 01_Blocks -------------------------------------------------------------------
--------------------------------------------------------------------------------

  U0_I2CM_TOP : i2cm_top
    port map (
              clk     => clk,
              rst_n   => rst_n,
              rst_sn  => rst_sn,
              addr    => addr,
              dat_i   => dat_i,
              we_i    => we_i,
              stb_i   => stb_i,
              cyc_i   => cyc_i,
              scl_i   => scl_i_a,
              sda_i   => sda_i_a,

              dat_o   => dat_o_a,
              ack_o   => ack_o_a,
              inta_o  => inta_o_a,
              scl_o   => scl_o_a,
              scl_oen => scl_oen_a,
              sda_o   => sda_o_a,
              sda_oen => sda_oen_a
    ) ;

  U1_I2CM_LED : i2cm_led
    port map (
              clk     => clk,
              rst_n   => rst_n,

              tst_led => tst_led_a
    ) ;


--------------------------------------------------------------------------------
-- 02_Pads ---------------------------------------------------------------------
--------------------------------------------------------------------------------
  dat_o   <= dat_o_a ;
  ack_o   <= ack_o_a ;
  inta_o  <= inta_o_a ;

  scl     <= scl_o_a when scl_oen_a = '0' else 'Z' ;
  sda     <= sda_o_a when sda_oen_a = '0' else 'Z' ;
  scl_i_a <= scl ;
  sda_i_a <= sda ;

  tst_led <= tst_led_a ;


end rtl ;
