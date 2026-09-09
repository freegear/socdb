-- Xilinx Vhdl netlist produced by netgen application (version G.26)
-- Command       : -rpw 100 -ar Structure -xon true -w -ofmt vhdl -sim spi_cpld.nga spi_cpld_timesim.vhd 
-- Input file    : spi_cpld.nga
-- Output file   : spi_cpld_timesim.vhd
-- Design name   : spi_cpld.nga
-- # of Entities : 1
-- Xilinx        : C:/Xilinx_WP_61
-- Device        : XC2C32-4-VQ44 (Speed File: Version 8.1 Advance Product Specification)

-- This vhdl netlist is a simulation model and uses simulation 
-- primitives which may not represent the true implementation of the 
-- device, however the netlist is functionally correct and should not 
-- be modified. This file cannot be synthesized and should only be used 
-- with supported simulation tools.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library SIMPRIM;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

entity spi_cpld is
  port (
    ext_spi : in STD_LOGIC := 'X'; 
    fpga_cclk : in STD_LOGIC := 'X'; 
    spi_q : in STD_LOGIC := 'X'; 
    fpga_init : in STD_LOGIC := 'X'; 
    fpga_done : in STD_LOGIC := 'X'; 
    fpga_io_clk : in STD_LOGIC := 'X'; 
    fpga_io_holdn : in STD_LOGIC := 'X'; 
    fpga_io_sn : in STD_LOGIC := 'X'; 
    fpga_io_wn : in STD_LOGIC := 'X'; 
    fpga_din : out STD_LOGIC; 
    spi_c : out STD_LOGIC; 
    spi_d : out STD_LOGIC; 
    spi_holdn : out STD_LOGIC; 
    spi_sn : out STD_LOGIC; 
    spi_wn : out STD_LOGIC 
  );
end spi_cpld;

architecture Structure of spi_cpld is
  signal ext_spi_II_UIM : STD_LOGIC; 
  signal ext_spi_II_FOE_Q : STD_LOGIC; 
  signal fpga_cclk_II_UIM : STD_LOGIC; 
  signal fpga_cclk_II_FCLK : STD_LOGIC; 
  signal spi_q_II_UIM : STD_LOGIC; 
  signal fpga_init_II_UIM : STD_LOGIC; 
  signal fpga_done_II_UIM : STD_LOGIC; 
  signal fpga_io_clk_II_UIM : STD_LOGIC; 
  signal fpga_io_holdn_II_UIM : STD_LOGIC; 
  signal fpga_io_sn_II_UIM : STD_LOGIC; 
  signal fpga_io_wn_II_UIM : STD_LOGIC; 
  signal fpga_din_MC_Q : STD_LOGIC; 
  signal fpga_din_MC_OE : STD_LOGIC; 
  signal spi_c_MC_Q : STD_LOGIC; 
  signal spi_c_MC_OE : STD_LOGIC; 
  signal spi_d_MC_Q : STD_LOGIC; 
  signal spi_d_MC_OE : STD_LOGIC; 
  signal spi_holdn_MC_Q : STD_LOGIC; 
  signal spi_sn_MC_Q : STD_LOGIC; 
  signal spi_sn_MC_OE : STD_LOGIC; 
  signal spi_wn_MC_Q : STD_LOGIC; 
  signal fpga_din_MC_Q_tsimrenamed_net_Q : STD_LOGIC; 
  signal fpga_din_MC_BUFOE_OUT : STD_LOGIC; 
  signal fpga_din_MC_D : STD_LOGIC; 
  signal fpga_din_MC_D1 : STD_LOGIC; 
  signal fpga_din_MC_D2 : STD_LOGIC; 
  signal dummybits : STD_LOGIC; 
  signal dummybits_MC_Q : STD_LOGIC; 
  signal dummybits_MC_D : STD_LOGIC; 
  signal dummybits_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal dummybits_MC_SETF : STD_LOGIC; 
  signal PRLD : STD_LOGIC; 
  signal Vcc : STD_LOGIC; 
  signal dummybits_MC_D1 : STD_LOGIC; 
  signal dummybits_MC_D2 : STD_LOGIC; 
  signal pres_state_FFD1 : STD_LOGIC; 
  signal pres_state_FFD3 : STD_LOGIC; 
  signal dummybits_MC_D2_PT_0 : STD_LOGIC; 
  signal pres_state_FFD2 : STD_LOGIC; 
  signal dummybits_MC_D2_PT_1 : STD_LOGIC; 
  signal pres_state_FFD1_MC_Q : STD_LOGIC; 
  signal FOOBAR1_ctinst_5 : STD_LOGIC; 
  signal pres_state_FFD1_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal pres_state_FFD1_MC_D : STD_LOGIC; 
  signal Gnd : STD_LOGIC; 
  signal pres_state_FFD1_MC_D1 : STD_LOGIC; 
  signal pres_state_FFD1_MC_D2 : STD_LOGIC; 
  signal pres_state_FFD1_MC_D2_PT_0 : STD_LOGIC; 
  signal pres_state_FFD1_MC_D2_PT_1 : STD_LOGIC; 
  signal pres_state_FFD1_MC_D2_PT_2 : STD_LOGIC; 
  signal pres_state_FFD3_MC_Q : STD_LOGIC; 
  signal pres_state_FFD3_MC_RSTF : STD_LOGIC; 
  signal pres_state_FFD3_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal pres_state_FFD3_MC_D : STD_LOGIC; 
  signal pres_state_FFD3_MC_D1 : STD_LOGIC; 
  signal pres_state_FFD3_MC_D2 : STD_LOGIC; 
  signal pres_state_FFD3_MC_D2_PT_0 : STD_LOGIC; 
  signal pres_state_FFD3_MC_D2_PT_1 : STD_LOGIC; 
  signal pres_state_FFD2_MC_Q : STD_LOGIC; 
  signal pres_state_FFD2_MC_D : STD_LOGIC; 
  signal pres_state_FFD2_MC_tsimcreated_xor_Q : STD_LOGIC; 
  signal pres_state_FFD2_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal pres_state_FFD2_MC_D1 : STD_LOGIC; 
  signal pres_state_FFD2_MC_D2 : STD_LOGIC; 
  signal pres_state_FFD2_MC_D2_PT_0 : STD_LOGIC; 
  signal pres_state_FFD2_MC_D2_PT_1 : STD_LOGIC; 
  signal s_count_0_MC_Q : STD_LOGIC; 
  signal s_count_0_MC_D : STD_LOGIC; 
  signal s_count_0_MC_tsimcreated_xor_Q : STD_LOGIC; 
  signal FOOBAR2_ctinst_5 : STD_LOGIC; 
  signal s_count_0_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_count_0_MC_D1 : STD_LOGIC; 
  signal s_count_0_MC_D2 : STD_LOGIC; 
  signal s_count_1_MC_Q : STD_LOGIC; 
  signal s_count_1_MC_D : STD_LOGIC; 
  signal s_count_1_MC_tsimcreated_xor_Q : STD_LOGIC; 
  signal s_count_1_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_count_1_MC_D1 : STD_LOGIC; 
  signal s_count_1_MC_D2 : STD_LOGIC; 
  signal s_count_2_MC_Q : STD_LOGIC; 
  signal s_count_2_MC_D : STD_LOGIC; 
  signal s_count_2_MC_tsimcreated_xor_Q : STD_LOGIC; 
  signal s_count_2_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_count_2_MC_D1 : STD_LOGIC; 
  signal s_count_2_MC_D2 : STD_LOGIC; 
  signal s_count_3_MC_Q : STD_LOGIC; 
  signal s_count_3_MC_D : STD_LOGIC; 
  signal s_count_3_MC_tsimcreated_xor_Q : STD_LOGIC; 
  signal s_count_3_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_count_3_MC_D1 : STD_LOGIC; 
  signal s_count_3_MC_D2 : STD_LOGIC; 
  signal s_count_4_MC_Q : STD_LOGIC; 
  signal s_count_4_MC_D : STD_LOGIC; 
  signal s_count_4_MC_tsimcreated_xor_Q : STD_LOGIC; 
  signal s_count_4_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_count_4_MC_D1 : STD_LOGIC; 
  signal s_count_4_MC_D2 : STD_LOGIC; 
  signal s_count_5_MC_Q : STD_LOGIC; 
  signal s_count_5_MC_D : STD_LOGIC; 
  signal s_count_5_MC_tsimcreated_xor_Q : STD_LOGIC; 
  signal s_count_5_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_count_5_MC_D1 : STD_LOGIC; 
  signal s_count_5_MC_D2 : STD_LOGIC; 
  signal spi_c_MC_Q_tsimrenamed_net_Q : STD_LOGIC; 
  signal spi_c_MC_BUFOE_OUT : STD_LOGIC; 
  signal spi_c_MC_D : STD_LOGIC; 
  signal spi_c_MC_D1 : STD_LOGIC; 
  signal spi_c_MC_D2 : STD_LOGIC; 
  signal spi_c_MC_D2_PT_0 : STD_LOGIC; 
  signal spi_c_MC_D2_PT_1 : STD_LOGIC; 
  signal spi_d_MC_Q_tsimrenamed_net_Q : STD_LOGIC; 
  signal spi_d_MC_BUFOE_OUT : STD_LOGIC; 
  signal spi_d_MC_D : STD_LOGIC; 
  signal spi_d_MC_D1 : STD_LOGIC; 
  signal spi_d_MC_D2 : STD_LOGIC; 
  signal spi_d_MC_D2_PT_0 : STD_LOGIC; 
  signal s_cmd_data : STD_LOGIC; 
  signal spi_d_MC_D2_PT_1 : STD_LOGIC; 
  signal s_cmd_data_MC_Q : STD_LOGIC; 
  signal s_cmd_data_MC_RSTF : STD_LOGIC; 
  signal FOOBAR1_ctinst_6 : STD_LOGIC; 
  signal s_cmd_data_MC_tsimcreated_set_and_noreset_Q : STD_LOGIC; 
  signal s_cmd_data_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_cmd_data_MC_D : STD_LOGIC; 
  signal s_cmd_data_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_cmd_data_MC_D1 : STD_LOGIC; 
  signal s_cmd_data_MC_D2 : STD_LOGIC; 
  signal s_cmd_data_MC_D2_PT_0 : STD_LOGIC; 
  signal s_cmd_data_MC_D2_PT_1 : STD_LOGIC; 
  signal s_cmd_data_MC_D2_PT_2 : STD_LOGIC; 
  signal s_cmd_data_MC_D2_PT_3 : STD_LOGIC; 
  signal s_cmd_data_MC_D2_PT_4 : STD_LOGIC; 
  signal s_cmd_data_MC_D2_PT_5 : STD_LOGIC; 
  signal s_instcode_7_MC_Q : STD_LOGIC; 
  signal s_instcode_7_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_instcode_7_MC_D : STD_LOGIC; 
  signal s_instcode_7_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_instcode_7_MC_CE : STD_LOGIC; 
  signal s_instcode_7_MC_D1 : STD_LOGIC; 
  signal s_instcode_7_MC_D2 : STD_LOGIC; 
  signal s_instcode_6_MC_Q : STD_LOGIC; 
  signal s_instcode_6_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_instcode_6_MC_D : STD_LOGIC; 
  signal s_instcode_6_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_instcode_6_MC_CE : STD_LOGIC; 
  signal s_instcode_6_MC_D1 : STD_LOGIC; 
  signal s_instcode_6_MC_D2 : STD_LOGIC; 
  signal s_instcode_5_MC_Q : STD_LOGIC; 
  signal s_instcode_5_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_instcode_5_MC_D : STD_LOGIC; 
  signal s_instcode_5_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_instcode_5_MC_CE : STD_LOGIC; 
  signal s_instcode_5_MC_D1 : STD_LOGIC; 
  signal s_instcode_5_MC_D2 : STD_LOGIC; 
  signal s_instcode_4_MC_Q : STD_LOGIC; 
  signal s_instcode_4_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_instcode_4_MC_D : STD_LOGIC; 
  signal s_instcode_4_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_instcode_4_MC_CE : STD_LOGIC; 
  signal s_instcode_4_MC_D1 : STD_LOGIC; 
  signal s_instcode_4_MC_D2 : STD_LOGIC; 
  signal s_instcode_3_MC_Q : STD_LOGIC; 
  signal s_instcode_3_MC_D : STD_LOGIC; 
  signal s_instcode_3_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_instcode_3_MC_SETF : STD_LOGIC; 
  signal s_instcode_3_MC_CE : STD_LOGIC; 
  signal s_instcode_3_MC_D1 : STD_LOGIC; 
  signal s_instcode_3_MC_D2 : STD_LOGIC; 
  signal s_instcode_2_MC_Q : STD_LOGIC; 
  signal s_instcode_2_MC_tsimcreated_prld_Q : STD_LOGIC; 
  signal s_instcode_2_MC_D : STD_LOGIC; 
  signal s_instcode_2_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_instcode_2_MC_CE : STD_LOGIC; 
  signal s_instcode_2_MC_D1 : STD_LOGIC; 
  signal s_instcode_2_MC_D2 : STD_LOGIC; 
  signal s_instcode_1_MC_Q : STD_LOGIC; 
  signal s_instcode_1_MC_D : STD_LOGIC; 
  signal s_instcode_1_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_instcode_1_MC_SETF : STD_LOGIC; 
  signal s_instcode_1_MC_CE : STD_LOGIC; 
  signal s_instcode_1_MC_D1 : STD_LOGIC; 
  signal s_instcode_1_MC_D2 : STD_LOGIC; 
  signal s_instcode_0_MC_Q : STD_LOGIC; 
  signal s_instcode_0_MC_D : STD_LOGIC; 
  signal s_instcode_0_MC_tsimcreated_xor_Q : STD_LOGIC; 
  signal s_instcode_0_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_instcode_0_MC_SETF : STD_LOGIC; 
  signal s_instcode_0_MC_D1 : STD_LOGIC; 
  signal s_instcode_0_MC_D2 : STD_LOGIC; 
  signal spi_holdn_MC_Q_tsimrenamed_net_Q : STD_LOGIC; 
  signal spi_holdn_MC_D : STD_LOGIC; 
  signal spi_holdn_MC_D1 : STD_LOGIC; 
  signal spi_holdn_MC_D2 : STD_LOGIC; 
  signal spi_sn_MC_Q_tsimrenamed_net_Q : STD_LOGIC; 
  signal spi_sn_MC_BUFOE_OUT : STD_LOGIC; 
  signal spi_sn_MC_D : STD_LOGIC; 
  signal spi_sn_MC_D1 : STD_LOGIC; 
  signal spi_sn_MC_D2 : STD_LOGIC; 
  signal spi_sn_MC_D2_PT_0 : STD_LOGIC; 
  signal s_spi_sn : STD_LOGIC; 
  signal spi_sn_MC_D2_PT_1 : STD_LOGIC; 
  signal s_spi_sn_MC_Q : STD_LOGIC; 
  signal s_spi_sn_MC_D : STD_LOGIC; 
  signal s_spi_sn_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK : STD_LOGIC; 
  signal s_spi_sn_MC_SETF : STD_LOGIC; 
  signal s_spi_sn_MC_D1 : STD_LOGIC; 
  signal s_spi_sn_MC_D2 : STD_LOGIC; 
  signal s_spi_sn_MC_D2_PT_0 : STD_LOGIC; 
  signal s_spi_sn_MC_D2_PT_1 : STD_LOGIC; 
  signal spi_wn_MC_Q_tsimrenamed_net_Q : STD_LOGIC; 
  signal spi_wn_MC_D : STD_LOGIC; 
  signal spi_wn_MC_D1 : STD_LOGIC; 
  signal spi_wn_MC_D2 : STD_LOGIC; 
  signal NlwInverterSignal_fpga_din_MC_D_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_fpga_din_MC_D1_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_fpga_din_MC_D1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_dummybits_MC_D2_PT_0_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_dummybits_MC_D2_PT_1_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_dummybits_MC_D2_PT_1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_dummybits_MC_SETF_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_dummybits_MC_SETF_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD1_MC_D2_PT_0_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD1_MC_D2_PT_1_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD1_MC_D2_PT_2_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD1_MC_D2_PT_2_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD1_MC_D2_PT_2_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD3_MC_D2_PT_1_IN5 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD3_MC_D2_PT_1_IN6 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD3_MC_RSTF_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD3_MC_RSTF_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD2_MC_D2_PT_0_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD2_MC_D2_PT_0_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN6 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN7 : STD_LOGIC; 
  signal NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN8 : STD_LOGIC; 
  signal NlwInverterSignal_s_count_0_MC_D1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_count_1_MC_D1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_count_2_MC_D1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_count_3_MC_D1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_count_4_MC_D1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_count_5_MC_D1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_spi_c_MC_D_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_c_MC_D2_PT_0_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_c_MC_D2_PT_0_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_spi_c_MC_D2_PT_1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_spi_d_MC_D_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_d_MC_D2_PT_0_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_d_MC_D2_PT_1_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_d_MC_D2_PT_1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_tsimcreated_set_and_noreset_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_D2_PT_0_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_D2_PT_1_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_D2_PT_4_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_D2_PT_4_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_D2_PT_5_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_D2_PT_5_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_RSTF_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_RSTF_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_cmd_data_MC_RSTF_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_7_MC_CE_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_7_MC_CE_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_6_MC_CE_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_6_MC_CE_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_5_MC_CE_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_5_MC_CE_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_4_MC_CE_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_4_MC_CE_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_3_MC_SETF_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_3_MC_SETF_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_3_MC_CE_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_3_MC_CE_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_2_MC_CE_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_2_MC_CE_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_1_MC_SETF_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_1_MC_SETF_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_1_MC_CE_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_1_MC_CE_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_0_MC_D1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_0_MC_D1_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_0_MC_SETF_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_instcode_0_MC_SETF_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_spi_holdn_MC_D_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_holdn_MC_D1_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_holdn_MC_D1_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_spi_sn_MC_D_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_sn_MC_D2_PT_0_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_spi_sn_MC_D2_PT_1_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_sn_MC_D2_PT_1_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_spi_sn_MC_D_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_spi_sn_MC_D2_PT_0_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_s_spi_sn_MC_SETF_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_s_spi_sn_MC_SETF_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_spi_wn_MC_D_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_wn_MC_D1_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_spi_wn_MC_D1_IN2 : STD_LOGIC; 
  signal NlwInverterSignal_FOOBAR1_ctinst_5_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_FOOBAR1_ctinst_5_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_FOOBAR1_ctinst_6_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_FOOBAR1_ctinst_6_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_FOOBAR2_ctinst_5_IN0 : STD_LOGIC; 
  signal NlwInverterSignal_FOOBAR2_ctinst_5_IN1 : STD_LOGIC; 
  signal NlwInverterSignal_FOOBAR2_ctinst_5_IN2 : STD_LOGIC; 
  signal s_count : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal s_instcode : STD_LOGIC_VECTOR ( 7 downto 0 ); 
begin
  ext_spi_II_UIM_0 : X_BUF
    port map (
      I => ext_spi,
      O => ext_spi_II_UIM
    );
  ext_spi_II_FOE_Q_1 : X_INV
    port map (
      I => ext_spi,
      O => ext_spi_II_FOE_Q
    );
  fpga_cclk_II_UIM_2 : X_BUF
    port map (
      I => fpga_cclk,
      O => fpga_cclk_II_UIM
    );
  fpga_cclk_II_FCLK_3 : X_BUF
    port map (
      I => fpga_cclk,
      O => fpga_cclk_II_FCLK
    );
  spi_q_II_UIM_4 : X_BUF
    port map (
      I => spi_q,
      O => spi_q_II_UIM
    );
  fpga_init_II_UIM_5 : X_BUF
    port map (
      I => fpga_init,
      O => fpga_init_II_UIM
    );
  fpga_done_II_UIM_6 : X_BUF
    port map (
      I => fpga_done,
      O => fpga_done_II_UIM
    );
  fpga_io_clk_II_UIM_7 : X_BUF
    port map (
      I => fpga_io_clk,
      O => fpga_io_clk_II_UIM
    );
  fpga_io_holdn_II_UIM_8 : X_BUF
    port map (
      I => fpga_io_holdn,
      O => fpga_io_holdn_II_UIM
    );
  fpga_io_sn_II_UIM_9 : X_BUF
    port map (
      I => fpga_io_sn,
      O => fpga_io_sn_II_UIM
    );
  fpga_io_wn_II_UIM_10 : X_BUF
    port map (
      I => fpga_io_wn,
      O => fpga_io_wn_II_UIM
    );
  fpga_din_11 : X_TRI
    port map (
      I => fpga_din_MC_Q,
      CTL => fpga_din_MC_OE,
      O => fpga_din
    );
  spi_c_12 : X_TRI
    port map (
      I => spi_c_MC_Q,
      CTL => spi_c_MC_OE,
      O => spi_c
    );
  spi_d_13 : X_TRI
    port map (
      I => spi_d_MC_Q,
      CTL => spi_d_MC_OE,
      O => spi_d
    );
  spi_holdn_14 : X_BUF
    port map (
      I => spi_holdn_MC_Q,
      O => spi_holdn
    );
  spi_sn_15 : X_TRI
    port map (
      I => spi_sn_MC_Q,
      CTL => spi_sn_MC_OE,
      O => spi_sn
    );
  spi_wn_16 : X_BUF
    port map (
      I => spi_wn_MC_Q,
      O => spi_wn
    );
  fpga_din_MC_Q_17 : X_BUF
    port map (
      I => fpga_din_MC_Q_tsimrenamed_net_Q,
      O => fpga_din_MC_Q
    );
  fpga_din_MC_OE_18 : X_BUF
    port map (
      I => fpga_din_MC_BUFOE_OUT,
      O => fpga_din_MC_OE
    );
  fpga_din_MC_BUFOE_OUT_19 : X_BUF
    port map (
      I => ext_spi_II_FOE_Q,
      O => fpga_din_MC_BUFOE_OUT
    );
  fpga_din_MC_Q_tsimrenamed_net_Q_20 : X_BUF
    port map (
      I => fpga_din_MC_D,
      O => fpga_din_MC_Q_tsimrenamed_net_Q
    );
  fpga_din_MC_D_21 : X_XOR2
    port map (
      I0 => NlwInverterSignal_fpga_din_MC_D_IN0,
      I1 => fpga_din_MC_D2,
      O => fpga_din_MC_D
    );
  fpga_din_MC_D1_22 : X_AND2
    port map (
      I0 => NlwInverterSignal_fpga_din_MC_D1_IN0,
      I1 => NlwInverterSignal_fpga_din_MC_D1_IN1,
      O => fpga_din_MC_D1
    );
  fpga_din_MC_D2_23 : X_ZERO
    port map (
      O => fpga_din_MC_D2
    );
  dummybits_24 : X_BUF
    port map (
      I => dummybits_MC_Q,
      O => dummybits
    );
  dummybits_MC_REG : X_FF
    port map (
      I => dummybits_MC_D,
      CE => Vcc,
      CLK => dummybits_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => dummybits_MC_SETF,
      RST => PRLD,
      O => dummybits_MC_Q
    );
  dummybits_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_25 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => dummybits_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  Vcc_26 : X_ONE
    port map (
      O => Vcc
    );
  dummybits_MC_D_27 : X_XOR2
    port map (
      I0 => dummybits_MC_D1,
      I1 => dummybits_MC_D2,
      O => dummybits_MC_D
    );
  dummybits_MC_D1_28 : X_ZERO
    port map (
      O => dummybits_MC_D1
    );
  dummybits_MC_D2_PT_0_29 : X_AND2
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_dummybits_MC_D2_PT_0_IN1,
      O => dummybits_MC_D2_PT_0
    );
  dummybits_MC_D2_PT_1_30 : X_AND2
    port map (
      I0 => NlwInverterSignal_dummybits_MC_D2_PT_1_IN0,
      I1 => NlwInverterSignal_dummybits_MC_D2_PT_1_IN1,
      O => dummybits_MC_D2_PT_1
    );
  dummybits_MC_D2_31 : X_OR2
    port map (
      I0 => dummybits_MC_D2_PT_0,
      I1 => dummybits_MC_D2_PT_1,
      O => dummybits_MC_D2
    );
  dummybits_MC_SETF_32 : X_AND2
    port map (
      I0 => NlwInverterSignal_dummybits_MC_SETF_IN0,
      I1 => NlwInverterSignal_dummybits_MC_SETF_IN1,
      O => dummybits_MC_SETF
    );
  pres_state_FFD1_33 : X_BUF
    port map (
      I => pres_state_FFD1_MC_Q,
      O => pres_state_FFD1
    );
  pres_state_FFD1_MC_tsimcreated_prld_Q_34 : X_OR2
    port map (
      I0 => FOOBAR1_ctinst_5,
      I1 => PRLD,
      O => pres_state_FFD1_MC_tsimcreated_prld_Q
    );
  pres_state_FFD1_MC_REG : X_FF
    port map (
      I => pres_state_FFD1_MC_D,
      CE => Vcc,
      CLK => fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => pres_state_FFD1_MC_tsimcreated_prld_Q,
      O => pres_state_FFD1_MC_Q
    );
  Gnd_35 : X_ZERO
    port map (
      O => Gnd
    );
  pres_state_FFD1_MC_D_36 : X_XOR2
    port map (
      I0 => pres_state_FFD1_MC_D1,
      I1 => pres_state_FFD1_MC_D2,
      O => pres_state_FFD1_MC_D
    );
  pres_state_FFD1_MC_D1_37 : X_ZERO
    port map (
      O => pres_state_FFD1_MC_D1
    );
  pres_state_FFD1_MC_D2_PT_0_38 : X_AND2
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_0_IN1,
      O => pres_state_FFD1_MC_D2_PT_0
    );
  pres_state_FFD1_MC_D2_PT_1_39 : X_AND3
    port map (
      I0 => pres_state_FFD1,
      I1 => pres_state_FFD2,
      I2 => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_1_IN2,
      O => pres_state_FFD1_MC_D2_PT_1
    );
  pres_state_FFD1_MC_D2_PT_2_40 : X_AND3
    port map (
      I0 => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_2_IN0,
      I1 => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_2_IN1,
      I2 => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_2_IN2,
      O => pres_state_FFD1_MC_D2_PT_2
    );
  pres_state_FFD1_MC_D2_41 : X_OR3
    port map (
      I0 => pres_state_FFD1_MC_D2_PT_0,
      I1 => pres_state_FFD1_MC_D2_PT_1,
      I2 => pres_state_FFD1_MC_D2_PT_2,
      O => pres_state_FFD1_MC_D2
    );
  pres_state_FFD3_42 : X_BUF
    port map (
      I => pres_state_FFD3_MC_Q,
      O => pres_state_FFD3
    );
  pres_state_FFD3_MC_tsimcreated_prld_Q_43 : X_OR2
    port map (
      I0 => pres_state_FFD3_MC_RSTF,
      I1 => PRLD,
      O => pres_state_FFD3_MC_tsimcreated_prld_Q
    );
  pres_state_FFD3_MC_REG : X_FF
    port map (
      I => pres_state_FFD3_MC_D,
      CE => Vcc,
      CLK => fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => pres_state_FFD3_MC_tsimcreated_prld_Q,
      O => pres_state_FFD3_MC_Q
    );
  pres_state_FFD3_MC_D_44 : X_XOR2
    port map (
      I0 => pres_state_FFD3_MC_D1,
      I1 => pres_state_FFD3_MC_D2,
      O => pres_state_FFD3_MC_D
    );
  pres_state_FFD3_MC_D1_45 : X_ZERO
    port map (
      O => pres_state_FFD3_MC_D1
    );
  pres_state_FFD3_MC_D2_PT_0_46 : X_AND2
    port map (
      I0 => pres_state_FFD3,
      I1 => pres_state_FFD2,
      O => pres_state_FFD3_MC_D2_PT_0
    );
  pres_state_FFD3_MC_D2_PT_1_47 : X_AND8
    port map (
      I0 => pres_state_FFD1,
      I1 => pres_state_FFD2,
      I2 => s_count(0),
      I3 => s_count(1),
      I4 => s_count(2),
      I5 => NlwInverterSignal_pres_state_FFD3_MC_D2_PT_1_IN5,
      I6 => NlwInverterSignal_pres_state_FFD3_MC_D2_PT_1_IN6,
      I7 => s_count(5),
      O => pres_state_FFD3_MC_D2_PT_1
    );
  pres_state_FFD3_MC_D2_48 : X_OR2
    port map (
      I0 => pres_state_FFD3_MC_D2_PT_0,
      I1 => pres_state_FFD3_MC_D2_PT_1,
      O => pres_state_FFD3_MC_D2
    );
  pres_state_FFD3_MC_RSTF_49 : X_AND2
    port map (
      I0 => NlwInverterSignal_pres_state_FFD3_MC_RSTF_IN0,
      I1 => NlwInverterSignal_pres_state_FFD3_MC_RSTF_IN1,
      O => pres_state_FFD3_MC_RSTF
    );
  pres_state_FFD2_50 : X_BUF
    port map (
      I => pres_state_FFD2_MC_Q,
      O => pres_state_FFD2
    );
  pres_state_FFD2_MC_tsimcreated_xor_Q_51 : X_XOR2
    port map (
      I0 => pres_state_FFD2_MC_D,
      I1 => pres_state_FFD2_MC_Q,
      O => pres_state_FFD2_MC_tsimcreated_xor_Q
    );
  pres_state_FFD2_MC_tsimcreated_prld_Q_52 : X_OR2
    port map (
      I0 => FOOBAR1_ctinst_5,
      I1 => PRLD,
      O => pres_state_FFD2_MC_tsimcreated_prld_Q
    );
  pres_state_FFD2_MC_REG : X_FF
    port map (
      I => pres_state_FFD2_MC_tsimcreated_xor_Q,
      CE => Vcc,
      CLK => fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => pres_state_FFD2_MC_tsimcreated_prld_Q,
      O => pres_state_FFD2_MC_Q
    );
  pres_state_FFD2_MC_D_53 : X_XOR2
    port map (
      I0 => pres_state_FFD2_MC_D1,
      I1 => pres_state_FFD2_MC_D2,
      O => pres_state_FFD2_MC_D
    );
  pres_state_FFD2_MC_D1_54 : X_ZERO
    port map (
      O => pres_state_FFD2_MC_D1
    );
  pres_state_FFD2_MC_D2_PT_0_55 : X_AND3
    port map (
      I0 => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_0_IN0,
      I1 => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_0_IN1,
      I2 => pres_state_FFD2,
      O => pres_state_FFD2_MC_D2_PT_0
    );
  pres_state_FFD2_MC_D2_PT_1_56 : X_AND16
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN1,
      I2 => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN2,
      I3 => s_count(0),
      I4 => s_count(1),
      I5 => s_count(2),
      I6 => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN6,
      I7 => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN7,
      I8 => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN8,
      I9 => Vcc,
      I10 => Vcc,
      I11 => Vcc,
      I12 => Vcc,
      I13 => Vcc,
      I14 => Vcc,
      I15 => Vcc,
      O => pres_state_FFD2_MC_D2_PT_1
    );
  pres_state_FFD2_MC_D2_57 : X_OR2
    port map (
      I0 => pres_state_FFD2_MC_D2_PT_0,
      I1 => pres_state_FFD2_MC_D2_PT_1,
      O => pres_state_FFD2_MC_D2
    );
  s_count_0_Q : X_BUF
    port map (
      I => s_count_0_MC_Q,
      O => s_count(0)
    );
  s_count_0_MC_tsimcreated_xor_Q_58 : X_XOR2
    port map (
      I0 => s_count_0_MC_D,
      I1 => s_count_0_MC_Q,
      O => s_count_0_MC_tsimcreated_xor_Q
    );
  s_count_0_MC_tsimcreated_prld_Q_59 : X_OR2
    port map (
      I0 => FOOBAR2_ctinst_5,
      I1 => PRLD,
      O => s_count_0_MC_tsimcreated_prld_Q
    );
  s_count_0_MC_REG : X_FF
    port map (
      I => s_count_0_MC_tsimcreated_xor_Q,
      CE => Vcc,
      CLK => fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_count_0_MC_tsimcreated_prld_Q,
      O => s_count_0_MC_Q
    );
  s_count_0_MC_D_60 : X_XOR2
    port map (
      I0 => s_count_0_MC_D1,
      I1 => s_count_0_MC_D2,
      O => s_count_0_MC_D
    );
  s_count_0_MC_D1_61 : X_AND2
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_count_0_MC_D1_IN1,
      O => s_count_0_MC_D1
    );
  s_count_0_MC_D2_62 : X_ZERO
    port map (
      O => s_count_0_MC_D2
    );
  s_count_1_Q : X_BUF
    port map (
      I => s_count_1_MC_Q,
      O => s_count(1)
    );
  s_count_1_MC_tsimcreated_xor_Q_63 : X_XOR2
    port map (
      I0 => s_count_1_MC_D,
      I1 => s_count_1_MC_Q,
      O => s_count_1_MC_tsimcreated_xor_Q
    );
  s_count_1_MC_tsimcreated_prld_Q_64 : X_OR2
    port map (
      I0 => FOOBAR2_ctinst_5,
      I1 => PRLD,
      O => s_count_1_MC_tsimcreated_prld_Q
    );
  s_count_1_MC_REG : X_FF
    port map (
      I => s_count_1_MC_tsimcreated_xor_Q,
      CE => Vcc,
      CLK => fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_count_1_MC_tsimcreated_prld_Q,
      O => s_count_1_MC_Q
    );
  s_count_1_MC_D_65 : X_XOR2
    port map (
      I0 => s_count_1_MC_D1,
      I1 => s_count_1_MC_D2,
      O => s_count_1_MC_D
    );
  s_count_1_MC_D1_66 : X_AND3
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_count_1_MC_D1_IN1,
      I2 => s_count(0),
      O => s_count_1_MC_D1
    );
  s_count_1_MC_D2_67 : X_ZERO
    port map (
      O => s_count_1_MC_D2
    );
  s_count_2_Q : X_BUF
    port map (
      I => s_count_2_MC_Q,
      O => s_count(2)
    );
  s_count_2_MC_tsimcreated_xor_Q_68 : X_XOR2
    port map (
      I0 => s_count_2_MC_D,
      I1 => s_count_2_MC_Q,
      O => s_count_2_MC_tsimcreated_xor_Q
    );
  s_count_2_MC_tsimcreated_prld_Q_69 : X_OR2
    port map (
      I0 => FOOBAR2_ctinst_5,
      I1 => PRLD,
      O => s_count_2_MC_tsimcreated_prld_Q
    );
  s_count_2_MC_REG : X_FF
    port map (
      I => s_count_2_MC_tsimcreated_xor_Q,
      CE => Vcc,
      CLK => fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_count_2_MC_tsimcreated_prld_Q,
      O => s_count_2_MC_Q
    );
  s_count_2_MC_D_70 : X_XOR2
    port map (
      I0 => s_count_2_MC_D1,
      I1 => s_count_2_MC_D2,
      O => s_count_2_MC_D
    );
  s_count_2_MC_D1_71 : X_AND4
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_count_2_MC_D1_IN1,
      I2 => s_count(0),
      I3 => s_count(1),
      O => s_count_2_MC_D1
    );
  s_count_2_MC_D2_72 : X_ZERO
    port map (
      O => s_count_2_MC_D2
    );
  s_count_3_Q : X_BUF
    port map (
      I => s_count_3_MC_Q,
      O => s_count(3)
    );
  s_count_3_MC_tsimcreated_xor_Q_73 : X_XOR2
    port map (
      I0 => s_count_3_MC_D,
      I1 => s_count_3_MC_Q,
      O => s_count_3_MC_tsimcreated_xor_Q
    );
  s_count_3_MC_tsimcreated_prld_Q_74 : X_OR2
    port map (
      I0 => FOOBAR2_ctinst_5,
      I1 => PRLD,
      O => s_count_3_MC_tsimcreated_prld_Q
    );
  s_count_3_MC_REG : X_FF
    port map (
      I => s_count_3_MC_tsimcreated_xor_Q,
      CE => Vcc,
      CLK => fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_count_3_MC_tsimcreated_prld_Q,
      O => s_count_3_MC_Q
    );
  s_count_3_MC_D_75 : X_XOR2
    port map (
      I0 => s_count_3_MC_D1,
      I1 => s_count_3_MC_D2,
      O => s_count_3_MC_D
    );
  s_count_3_MC_D1_76 : X_AND5
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_count_3_MC_D1_IN1,
      I2 => s_count(0),
      I3 => s_count(1),
      I4 => s_count(2),
      O => s_count_3_MC_D1
    );
  s_count_3_MC_D2_77 : X_ZERO
    port map (
      O => s_count_3_MC_D2
    );
  s_count_4_Q : X_BUF
    port map (
      I => s_count_4_MC_Q,
      O => s_count(4)
    );
  s_count_4_MC_tsimcreated_xor_Q_78 : X_XOR2
    port map (
      I0 => s_count_4_MC_D,
      I1 => s_count_4_MC_Q,
      O => s_count_4_MC_tsimcreated_xor_Q
    );
  s_count_4_MC_tsimcreated_prld_Q_79 : X_OR2
    port map (
      I0 => FOOBAR2_ctinst_5,
      I1 => PRLD,
      O => s_count_4_MC_tsimcreated_prld_Q
    );
  s_count_4_MC_REG : X_FF
    port map (
      I => s_count_4_MC_tsimcreated_xor_Q,
      CE => Vcc,
      CLK => fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_count_4_MC_tsimcreated_prld_Q,
      O => s_count_4_MC_Q
    );
  s_count_4_MC_D_80 : X_XOR2
    port map (
      I0 => s_count_4_MC_D1,
      I1 => s_count_4_MC_D2,
      O => s_count_4_MC_D
    );
  s_count_4_MC_D1_81 : X_AND6
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_count_4_MC_D1_IN1,
      I2 => s_count(0),
      I3 => s_count(1),
      I4 => s_count(2),
      I5 => s_count(3),
      O => s_count_4_MC_D1
    );
  s_count_4_MC_D2_82 : X_ZERO
    port map (
      O => s_count_4_MC_D2
    );
  s_count_5_Q : X_BUF
    port map (
      I => s_count_5_MC_Q,
      O => s_count(5)
    );
  s_count_5_MC_tsimcreated_xor_Q_83 : X_XOR2
    port map (
      I0 => s_count_5_MC_D,
      I1 => s_count_5_MC_Q,
      O => s_count_5_MC_tsimcreated_xor_Q
    );
  s_count_5_MC_tsimcreated_prld_Q_84 : X_OR2
    port map (
      I0 => FOOBAR2_ctinst_5,
      I1 => PRLD,
      O => s_count_5_MC_tsimcreated_prld_Q
    );
  s_count_5_MC_REG : X_FF
    port map (
      I => s_count_5_MC_tsimcreated_xor_Q,
      CE => Vcc,
      CLK => fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_count_5_MC_tsimcreated_prld_Q,
      O => s_count_5_MC_Q
    );
  s_count_5_MC_D_85 : X_XOR2
    port map (
      I0 => s_count_5_MC_D1,
      I1 => s_count_5_MC_D2,
      O => s_count_5_MC_D
    );
  s_count_5_MC_D1_86 : X_AND7
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_count_5_MC_D1_IN1,
      I2 => s_count(0),
      I3 => s_count(1),
      I4 => s_count(2),
      I5 => s_count(3),
      I6 => s_count(4),
      O => s_count_5_MC_D1
    );
  s_count_5_MC_D2_87 : X_ZERO
    port map (
      O => s_count_5_MC_D2
    );
  spi_c_MC_Q_88 : X_BUF
    port map (
      I => spi_c_MC_Q_tsimrenamed_net_Q,
      O => spi_c_MC_Q
    );
  spi_c_MC_OE_89 : X_BUF
    port map (
      I => spi_c_MC_BUFOE_OUT,
      O => spi_c_MC_OE
    );
  spi_c_MC_BUFOE_OUT_90 : X_BUF
    port map (
      I => ext_spi_II_FOE_Q,
      O => spi_c_MC_BUFOE_OUT
    );
  spi_c_MC_Q_tsimrenamed_net_Q_91 : X_BUF
    port map (
      I => spi_c_MC_D,
      O => spi_c_MC_Q_tsimrenamed_net_Q
    );
  spi_c_MC_D_92 : X_XOR2
    port map (
      I0 => NlwInverterSignal_spi_c_MC_D_IN0,
      I1 => spi_c_MC_D2,
      O => spi_c_MC_D
    );
  spi_c_MC_D1_93 : X_ZERO
    port map (
      O => spi_c_MC_D1
    );
  spi_c_MC_D2_PT_0_94 : X_AND2
    port map (
      I0 => NlwInverterSignal_spi_c_MC_D2_PT_0_IN0,
      I1 => NlwInverterSignal_spi_c_MC_D2_PT_0_IN1,
      O => spi_c_MC_D2_PT_0
    );
  spi_c_MC_D2_PT_1_95 : X_AND2
    port map (
      I0 => fpga_done_II_UIM,
      I1 => NlwInverterSignal_spi_c_MC_D2_PT_1_IN1,
      O => spi_c_MC_D2_PT_1
    );
  spi_c_MC_D2_96 : X_OR2
    port map (
      I0 => spi_c_MC_D2_PT_0,
      I1 => spi_c_MC_D2_PT_1,
      O => spi_c_MC_D2
    );
  spi_d_MC_Q_97 : X_BUF
    port map (
      I => spi_d_MC_Q_tsimrenamed_net_Q,
      O => spi_d_MC_Q
    );
  spi_d_MC_OE_98 : X_BUF
    port map (
      I => spi_d_MC_BUFOE_OUT,
      O => spi_d_MC_OE
    );
  spi_d_MC_BUFOE_OUT_99 : X_BUF
    port map (
      I => ext_spi_II_FOE_Q,
      O => spi_d_MC_BUFOE_OUT
    );
  spi_d_MC_Q_tsimrenamed_net_Q_100 : X_BUF
    port map (
      I => spi_d_MC_D,
      O => spi_d_MC_Q_tsimrenamed_net_Q
    );
  spi_d_MC_D_101 : X_XOR2
    port map (
      I0 => NlwInverterSignal_spi_d_MC_D_IN0,
      I1 => spi_d_MC_D2,
      O => spi_d_MC_D
    );
  spi_d_MC_D1_102 : X_ZERO
    port map (
      O => spi_d_MC_D1
    );
  spi_d_MC_D2_PT_0_103 : X_AND2
    port map (
      I0 => NlwInverterSignal_spi_d_MC_D2_PT_0_IN0,
      I1 => fpga_done_II_UIM,
      O => spi_d_MC_D2_PT_0
    );
  spi_d_MC_D2_PT_1_104 : X_AND2
    port map (
      I0 => NlwInverterSignal_spi_d_MC_D2_PT_1_IN0,
      I1 => NlwInverterSignal_spi_d_MC_D2_PT_1_IN1,
      O => spi_d_MC_D2_PT_1
    );
  spi_d_MC_D2_105 : X_OR2
    port map (
      I0 => spi_d_MC_D2_PT_0,
      I1 => spi_d_MC_D2_PT_1,
      O => spi_d_MC_D2
    );
  s_cmd_data_106 : X_BUF
    port map (
      I => s_cmd_data_MC_Q,
      O => s_cmd_data
    );
  s_cmd_data_MC_tsimcreated_set_and_noreset_Q_107 : X_AND2
    port map (
      I0 => NlwInverterSignal_s_cmd_data_MC_tsimcreated_set_and_noreset_IN0,
      I1 => FOOBAR1_ctinst_6,
      O => s_cmd_data_MC_tsimcreated_set_and_noreset_Q
    );
  s_cmd_data_MC_tsimcreated_prld_Q_108 : X_OR2
    port map (
      I0 => s_cmd_data_MC_RSTF,
      I1 => PRLD,
      O => s_cmd_data_MC_tsimcreated_prld_Q
    );
  s_cmd_data_MC_REG : X_FF
    port map (
      I => s_cmd_data_MC_D,
      CE => Vcc,
      CLK => s_cmd_data_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => s_cmd_data_MC_tsimcreated_set_and_noreset_Q,
      RST => s_cmd_data_MC_tsimcreated_prld_Q,
      O => s_cmd_data_MC_Q
    );
  s_cmd_data_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_109 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_cmd_data_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_cmd_data_MC_D_110 : X_XOR2
    port map (
      I0 => s_cmd_data_MC_D1,
      I1 => s_cmd_data_MC_D2,
      O => s_cmd_data_MC_D
    );
  s_cmd_data_MC_D1_111 : X_ZERO
    port map (
      O => s_cmd_data_MC_D1
    );
  s_cmd_data_MC_D2_PT_0_112 : X_AND3
    port map (
      I0 => NlwInverterSignal_s_cmd_data_MC_D2_PT_0_IN0,
      I1 => fpga_init_II_UIM,
      I2 => s_cmd_data,
      O => s_cmd_data_MC_D2_PT_0
    );
  s_cmd_data_MC_D2_PT_1_113 : X_AND3
    port map (
      I0 => NlwInverterSignal_s_cmd_data_MC_D2_PT_1_IN0,
      I1 => fpga_done_II_UIM,
      I2 => s_cmd_data,
      O => s_cmd_data_MC_D2_PT_1
    );
  s_cmd_data_MC_D2_PT_2_114 : X_AND3
    port map (
      I0 => pres_state_FFD3,
      I1 => fpga_init_II_UIM,
      I2 => s_cmd_data,
      O => s_cmd_data_MC_D2_PT_2
    );
  s_cmd_data_MC_D2_PT_3_115 : X_AND3
    port map (
      I0 => pres_state_FFD3,
      I1 => fpga_done_II_UIM,
      I2 => s_cmd_data,
      O => s_cmd_data_MC_D2_PT_3
    );
  s_cmd_data_MC_D2_PT_4_116 : X_AND3
    port map (
      I0 => NlwInverterSignal_s_cmd_data_MC_D2_PT_4_IN0,
      I1 => NlwInverterSignal_s_cmd_data_MC_D2_PT_4_IN1,
      I2 => s_instcode(7),
      O => s_cmd_data_MC_D2_PT_4
    );
  s_cmd_data_MC_D2_PT_5_117 : X_AND4
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_cmd_data_MC_D2_PT_5_IN1,
      I2 => NlwInverterSignal_s_cmd_data_MC_D2_PT_5_IN2,
      I3 => s_instcode(7),
      O => s_cmd_data_MC_D2_PT_5
    );
  s_cmd_data_MC_D2_118 : X_OR6
    port map (
      I0 => s_cmd_data_MC_D2_PT_0,
      I1 => s_cmd_data_MC_D2_PT_1,
      I2 => s_cmd_data_MC_D2_PT_2,
      I3 => s_cmd_data_MC_D2_PT_3,
      I4 => s_cmd_data_MC_D2_PT_4,
      I5 => s_cmd_data_MC_D2_PT_5,
      O => s_cmd_data_MC_D2
    );
  s_cmd_data_MC_RSTF_119 : X_AND3
    port map (
      I0 => NlwInverterSignal_s_cmd_data_MC_RSTF_IN0,
      I1 => NlwInverterSignal_s_cmd_data_MC_RSTF_IN1,
      I2 => NlwInverterSignal_s_cmd_data_MC_RSTF_IN2,
      O => s_cmd_data_MC_RSTF
    );
  s_instcode_7_Q : X_BUF
    port map (
      I => s_instcode_7_MC_Q,
      O => s_instcode(7)
    );
  s_instcode_7_MC_tsimcreated_prld_Q_120 : X_OR2
    port map (
      I0 => FOOBAR1_ctinst_5,
      I1 => PRLD,
      O => s_instcode_7_MC_tsimcreated_prld_Q
    );
  s_instcode_7_MC_REG : X_FF
    port map (
      I => s_instcode_7_MC_D,
      CE => s_instcode_7_MC_CE,
      CLK => s_instcode_7_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_instcode_7_MC_tsimcreated_prld_Q,
      O => s_instcode_7_MC_Q
    );
  s_instcode_7_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_121 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_instcode_7_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_instcode_7_MC_D_122 : X_XOR2
    port map (
      I0 => s_instcode_7_MC_D1,
      I1 => s_instcode_7_MC_D2,
      O => s_instcode_7_MC_D
    );
  s_instcode_7_MC_D1_123 : X_ZERO
    port map (
      O => s_instcode_7_MC_D1
    );
  s_instcode_7_MC_D2_124 : X_AND2
    port map (
      I0 => s_instcode(6),
      I1 => s_instcode(6),
      O => s_instcode_7_MC_D2
    );
  s_instcode_7_MC_CE_125 : X_AND3
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_instcode_7_MC_CE_IN1,
      I2 => NlwInverterSignal_s_instcode_7_MC_CE_IN2,
      O => s_instcode_7_MC_CE
    );
  s_instcode_6_Q : X_BUF
    port map (
      I => s_instcode_6_MC_Q,
      O => s_instcode(6)
    );
  s_instcode_6_MC_tsimcreated_prld_Q_126 : X_OR2
    port map (
      I0 => FOOBAR1_ctinst_5,
      I1 => PRLD,
      O => s_instcode_6_MC_tsimcreated_prld_Q
    );
  s_instcode_6_MC_REG : X_FF
    port map (
      I => s_instcode_6_MC_D,
      CE => s_instcode_6_MC_CE,
      CLK => s_instcode_6_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_instcode_6_MC_tsimcreated_prld_Q,
      O => s_instcode_6_MC_Q
    );
  s_instcode_6_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_127 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_instcode_6_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_instcode_6_MC_D_128 : X_XOR2
    port map (
      I0 => s_instcode_6_MC_D1,
      I1 => s_instcode_6_MC_D2,
      O => s_instcode_6_MC_D
    );
  s_instcode_6_MC_D1_129 : X_ZERO
    port map (
      O => s_instcode_6_MC_D1
    );
  s_instcode_6_MC_D2_130 : X_AND2
    port map (
      I0 => s_instcode(5),
      I1 => s_instcode(5),
      O => s_instcode_6_MC_D2
    );
  s_instcode_6_MC_CE_131 : X_AND3
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_instcode_6_MC_CE_IN1,
      I2 => NlwInverterSignal_s_instcode_6_MC_CE_IN2,
      O => s_instcode_6_MC_CE
    );
  s_instcode_5_Q : X_BUF
    port map (
      I => s_instcode_5_MC_Q,
      O => s_instcode(5)
    );
  s_instcode_5_MC_tsimcreated_prld_Q_132 : X_OR2
    port map (
      I0 => FOOBAR1_ctinst_5,
      I1 => PRLD,
      O => s_instcode_5_MC_tsimcreated_prld_Q
    );
  s_instcode_5_MC_REG : X_FF
    port map (
      I => s_instcode_5_MC_D,
      CE => s_instcode_5_MC_CE,
      CLK => s_instcode_5_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_instcode_5_MC_tsimcreated_prld_Q,
      O => s_instcode_5_MC_Q
    );
  s_instcode_5_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_133 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_instcode_5_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_instcode_5_MC_D_134 : X_XOR2
    port map (
      I0 => s_instcode_5_MC_D1,
      I1 => s_instcode_5_MC_D2,
      O => s_instcode_5_MC_D
    );
  s_instcode_5_MC_D1_135 : X_ZERO
    port map (
      O => s_instcode_5_MC_D1
    );
  s_instcode_5_MC_D2_136 : X_AND2
    port map (
      I0 => s_instcode(4),
      I1 => s_instcode(4),
      O => s_instcode_5_MC_D2
    );
  s_instcode_5_MC_CE_137 : X_AND3
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_instcode_5_MC_CE_IN1,
      I2 => NlwInverterSignal_s_instcode_5_MC_CE_IN2,
      O => s_instcode_5_MC_CE
    );
  s_instcode_4_Q : X_BUF
    port map (
      I => s_instcode_4_MC_Q,
      O => s_instcode(4)
    );
  s_instcode_4_MC_tsimcreated_prld_Q_138 : X_OR2
    port map (
      I0 => FOOBAR1_ctinst_5,
      I1 => PRLD,
      O => s_instcode_4_MC_tsimcreated_prld_Q
    );
  s_instcode_4_MC_REG : X_FF
    port map (
      I => s_instcode_4_MC_D,
      CE => s_instcode_4_MC_CE,
      CLK => s_instcode_4_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_instcode_4_MC_tsimcreated_prld_Q,
      O => s_instcode_4_MC_Q
    );
  s_instcode_4_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_139 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_instcode_4_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_instcode_4_MC_D_140 : X_XOR2
    port map (
      I0 => s_instcode_4_MC_D1,
      I1 => s_instcode_4_MC_D2,
      O => s_instcode_4_MC_D
    );
  s_instcode_4_MC_D1_141 : X_ZERO
    port map (
      O => s_instcode_4_MC_D1
    );
  s_instcode_4_MC_D2_142 : X_AND2
    port map (
      I0 => s_instcode(3),
      I1 => s_instcode(3),
      O => s_instcode_4_MC_D2
    );
  s_instcode_4_MC_CE_143 : X_AND3
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_instcode_4_MC_CE_IN1,
      I2 => NlwInverterSignal_s_instcode_4_MC_CE_IN2,
      O => s_instcode_4_MC_CE
    );
  s_instcode_3_Q : X_BUF
    port map (
      I => s_instcode_3_MC_Q,
      O => s_instcode(3)
    );
  s_instcode_3_MC_REG : X_FF
    port map (
      I => s_instcode_3_MC_D,
      CE => s_instcode_3_MC_CE,
      CLK => s_instcode_3_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => s_instcode_3_MC_SETF,
      RST => PRLD,
      O => s_instcode_3_MC_Q
    );
  s_instcode_3_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_144 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_instcode_3_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_instcode_3_MC_D_145 : X_XOR2
    port map (
      I0 => s_instcode_3_MC_D1,
      I1 => s_instcode_3_MC_D2,
      O => s_instcode_3_MC_D
    );
  s_instcode_3_MC_D1_146 : X_ZERO
    port map (
      O => s_instcode_3_MC_D1
    );
  s_instcode_3_MC_D2_147 : X_AND2
    port map (
      I0 => s_instcode(2),
      I1 => s_instcode(2),
      O => s_instcode_3_MC_D2
    );
  s_instcode_3_MC_SETF_148 : X_AND2
    port map (
      I0 => NlwInverterSignal_s_instcode_3_MC_SETF_IN0,
      I1 => NlwInverterSignal_s_instcode_3_MC_SETF_IN1,
      O => s_instcode_3_MC_SETF
    );
  s_instcode_3_MC_CE_149 : X_AND3
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_instcode_3_MC_CE_IN1,
      I2 => NlwInverterSignal_s_instcode_3_MC_CE_IN2,
      O => s_instcode_3_MC_CE
    );
  s_instcode_2_Q : X_BUF
    port map (
      I => s_instcode_2_MC_Q,
      O => s_instcode(2)
    );
  s_instcode_2_MC_tsimcreated_prld_Q_150 : X_OR2
    port map (
      I0 => FOOBAR1_ctinst_5,
      I1 => PRLD,
      O => s_instcode_2_MC_tsimcreated_prld_Q
    );
  s_instcode_2_MC_REG : X_FF
    port map (
      I => s_instcode_2_MC_D,
      CE => s_instcode_2_MC_CE,
      CLK => s_instcode_2_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => Gnd,
      RST => s_instcode_2_MC_tsimcreated_prld_Q,
      O => s_instcode_2_MC_Q
    );
  s_instcode_2_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_151 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_instcode_2_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_instcode_2_MC_D_152 : X_XOR2
    port map (
      I0 => s_instcode_2_MC_D1,
      I1 => s_instcode_2_MC_D2,
      O => s_instcode_2_MC_D
    );
  s_instcode_2_MC_D1_153 : X_ZERO
    port map (
      O => s_instcode_2_MC_D1
    );
  s_instcode_2_MC_D2_154 : X_AND2
    port map (
      I0 => s_instcode(1),
      I1 => s_instcode(1),
      O => s_instcode_2_MC_D2
    );
  s_instcode_2_MC_CE_155 : X_AND3
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_instcode_2_MC_CE_IN1,
      I2 => NlwInverterSignal_s_instcode_2_MC_CE_IN2,
      O => s_instcode_2_MC_CE
    );
  s_instcode_1_Q : X_BUF
    port map (
      I => s_instcode_1_MC_Q,
      O => s_instcode(1)
    );
  s_instcode_1_MC_REG : X_FF
    port map (
      I => s_instcode_1_MC_D,
      CE => s_instcode_1_MC_CE,
      CLK => s_instcode_1_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => s_instcode_1_MC_SETF,
      RST => PRLD,
      O => s_instcode_1_MC_Q
    );
  s_instcode_1_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_156 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_instcode_1_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_instcode_1_MC_D_157 : X_XOR2
    port map (
      I0 => s_instcode_1_MC_D1,
      I1 => s_instcode_1_MC_D2,
      O => s_instcode_1_MC_D
    );
  s_instcode_1_MC_D1_158 : X_ZERO
    port map (
      O => s_instcode_1_MC_D1
    );
  s_instcode_1_MC_D2_159 : X_AND2
    port map (
      I0 => s_instcode(0),
      I1 => s_instcode(0),
      O => s_instcode_1_MC_D2
    );
  s_instcode_1_MC_SETF_160 : X_AND2
    port map (
      I0 => NlwInverterSignal_s_instcode_1_MC_SETF_IN0,
      I1 => NlwInverterSignal_s_instcode_1_MC_SETF_IN1,
      O => s_instcode_1_MC_SETF
    );
  s_instcode_1_MC_CE_161 : X_AND3
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_instcode_1_MC_CE_IN1,
      I2 => NlwInverterSignal_s_instcode_1_MC_CE_IN2,
      O => s_instcode_1_MC_CE
    );
  s_instcode_0_Q : X_BUF
    port map (
      I => s_instcode_0_MC_Q,
      O => s_instcode(0)
    );
  s_instcode_0_MC_tsimcreated_xor_Q_162 : X_XOR2
    port map (
      I0 => s_instcode_0_MC_D,
      I1 => s_instcode_0_MC_Q,
      O => s_instcode_0_MC_tsimcreated_xor_Q
    );
  s_instcode_0_MC_REG : X_FF
    port map (
      I => s_instcode_0_MC_tsimcreated_xor_Q,
      CE => Vcc,
      CLK => s_instcode_0_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => s_instcode_0_MC_SETF,
      RST => PRLD,
      O => s_instcode_0_MC_Q
    );
  s_instcode_0_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_163 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_instcode_0_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_instcode_0_MC_D_164 : X_XOR2
    port map (
      I0 => s_instcode_0_MC_D1,
      I1 => s_instcode_0_MC_D2,
      O => s_instcode_0_MC_D
    );
  s_instcode_0_MC_D1_165 : X_AND4
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_instcode_0_MC_D1_IN1,
      I2 => NlwInverterSignal_s_instcode_0_MC_D1_IN2,
      I3 => s_instcode(0),
      O => s_instcode_0_MC_D1
    );
  s_instcode_0_MC_D2_166 : X_ZERO
    port map (
      O => s_instcode_0_MC_D2
    );
  s_instcode_0_MC_SETF_167 : X_AND2
    port map (
      I0 => NlwInverterSignal_s_instcode_0_MC_SETF_IN0,
      I1 => NlwInverterSignal_s_instcode_0_MC_SETF_IN1,
      O => s_instcode_0_MC_SETF
    );
  spi_holdn_MC_Q_168 : X_BUF
    port map (
      I => spi_holdn_MC_Q_tsimrenamed_net_Q,
      O => spi_holdn_MC_Q
    );
  spi_holdn_MC_Q_tsimrenamed_net_Q_169 : X_BUF
    port map (
      I => spi_holdn_MC_D,
      O => spi_holdn_MC_Q_tsimrenamed_net_Q
    );
  spi_holdn_MC_D_170 : X_XOR2
    port map (
      I0 => NlwInverterSignal_spi_holdn_MC_D_IN0,
      I1 => spi_holdn_MC_D2,
      O => spi_holdn_MC_D
    );
  spi_holdn_MC_D1_171 : X_AND3
    port map (
      I0 => NlwInverterSignal_spi_holdn_MC_D1_IN0,
      I1 => fpga_done_II_UIM,
      I2 => NlwInverterSignal_spi_holdn_MC_D1_IN2,
      O => spi_holdn_MC_D1
    );
  spi_holdn_MC_D2_172 : X_ZERO
    port map (
      O => spi_holdn_MC_D2
    );
  spi_sn_MC_Q_173 : X_BUF
    port map (
      I => spi_sn_MC_Q_tsimrenamed_net_Q,
      O => spi_sn_MC_Q
    );
  spi_sn_MC_OE_174 : X_BUF
    port map (
      I => spi_sn_MC_BUFOE_OUT,
      O => spi_sn_MC_OE
    );
  spi_sn_MC_BUFOE_OUT_175 : X_BUF
    port map (
      I => ext_spi_II_FOE_Q,
      O => spi_sn_MC_BUFOE_OUT
    );
  spi_sn_MC_Q_tsimrenamed_net_Q_176 : X_BUF
    port map (
      I => spi_sn_MC_D,
      O => spi_sn_MC_Q_tsimrenamed_net_Q
    );
  spi_sn_MC_D_177 : X_XOR2
    port map (
      I0 => NlwInverterSignal_spi_sn_MC_D_IN0,
      I1 => spi_sn_MC_D2,
      O => spi_sn_MC_D
    );
  spi_sn_MC_D1_178 : X_ZERO
    port map (
      O => spi_sn_MC_D1
    );
  spi_sn_MC_D2_PT_0_179 : X_AND2
    port map (
      I0 => fpga_done_II_UIM,
      I1 => NlwInverterSignal_spi_sn_MC_D2_PT_0_IN1,
      O => spi_sn_MC_D2_PT_0
    );
  spi_sn_MC_D2_PT_1_180 : X_AND2
    port map (
      I0 => NlwInverterSignal_spi_sn_MC_D2_PT_1_IN0,
      I1 => NlwInverterSignal_spi_sn_MC_D2_PT_1_IN1,
      O => spi_sn_MC_D2_PT_1
    );
  spi_sn_MC_D2_181 : X_OR2
    port map (
      I0 => spi_sn_MC_D2_PT_0,
      I1 => spi_sn_MC_D2_PT_1,
      O => spi_sn_MC_D2
    );
  s_spi_sn_182 : X_BUF
    port map (
      I => s_spi_sn_MC_Q,
      O => s_spi_sn
    );
  s_spi_sn_MC_REG : X_FF
    port map (
      I => s_spi_sn_MC_D,
      CE => Vcc,
      CLK => s_spi_sn_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK,
      SET => s_spi_sn_MC_SETF,
      RST => PRLD,
      O => s_spi_sn_MC_Q
    );
  s_spi_sn_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK_183 : X_INV
    port map (
      I => fpga_cclk_II_FCLK,
      O => s_spi_sn_MC_REG_tsimcreated_inv_fpga_cclk_II_FCLK
    );
  s_spi_sn_MC_D_184 : X_XOR2
    port map (
      I0 => NlwInverterSignal_s_spi_sn_MC_D_IN0,
      I1 => s_spi_sn_MC_D2,
      O => s_spi_sn_MC_D
    );
  s_spi_sn_MC_D1_185 : X_ZERO
    port map (
      O => s_spi_sn_MC_D1
    );
  s_spi_sn_MC_D2_PT_0_186 : X_AND2
    port map (
      I0 => pres_state_FFD1,
      I1 => NlwInverterSignal_s_spi_sn_MC_D2_PT_0_IN1,
      O => s_spi_sn_MC_D2_PT_0
    );
  s_spi_sn_MC_D2_PT_1_187 : X_AND2
    port map (
      I0 => pres_state_FFD1,
      I1 => pres_state_FFD2,
      O => s_spi_sn_MC_D2_PT_1
    );
  s_spi_sn_MC_D2_188 : X_OR2
    port map (
      I0 => s_spi_sn_MC_D2_PT_0,
      I1 => s_spi_sn_MC_D2_PT_1,
      O => s_spi_sn_MC_D2
    );
  s_spi_sn_MC_SETF_189 : X_AND2
    port map (
      I0 => NlwInverterSignal_s_spi_sn_MC_SETF_IN0,
      I1 => NlwInverterSignal_s_spi_sn_MC_SETF_IN1,
      O => s_spi_sn_MC_SETF
    );
  spi_wn_MC_Q_190 : X_BUF
    port map (
      I => spi_wn_MC_Q_tsimrenamed_net_Q,
      O => spi_wn_MC_Q
    );
  spi_wn_MC_Q_tsimrenamed_net_Q_191 : X_BUF
    port map (
      I => spi_wn_MC_D,
      O => spi_wn_MC_Q_tsimrenamed_net_Q
    );
  spi_wn_MC_D_192 : X_XOR2
    port map (
      I0 => NlwInverterSignal_spi_wn_MC_D_IN0,
      I1 => spi_wn_MC_D2,
      O => spi_wn_MC_D
    );
  spi_wn_MC_D1_193 : X_AND3
    port map (
      I0 => NlwInverterSignal_spi_wn_MC_D1_IN0,
      I1 => fpga_done_II_UIM,
      I2 => NlwInverterSignal_spi_wn_MC_D1_IN2,
      O => spi_wn_MC_D1
    );
  spi_wn_MC_D2_194 : X_ZERO
    port map (
      O => spi_wn_MC_D2
    );
  FOOBAR1_ctinst_5_195 : X_AND2
    port map (
      I0 => NlwInverterSignal_FOOBAR1_ctinst_5_IN0,
      I1 => NlwInverterSignal_FOOBAR1_ctinst_5_IN1,
      O => FOOBAR1_ctinst_5
    );
  FOOBAR1_ctinst_6_196 : X_AND3
    port map (
      I0 => NlwInverterSignal_FOOBAR1_ctinst_6_IN0,
      I1 => NlwInverterSignal_FOOBAR1_ctinst_6_IN1,
      I2 => s_instcode(7),
      O => FOOBAR1_ctinst_6
    );
  FOOBAR2_ctinst_5_197 : X_AND3
    port map (
      I0 => NlwInverterSignal_FOOBAR2_ctinst_5_IN0,
      I1 => NlwInverterSignal_FOOBAR2_ctinst_5_IN1,
      I2 => NlwInverterSignal_FOOBAR2_ctinst_5_IN2,
      O => FOOBAR2_ctinst_5
    );
  NlwInverterBlock_fpga_din_MC_D_IN0 : X_INV
    port map (
      I => fpga_din_MC_D1,
      O => NlwInverterSignal_fpga_din_MC_D_IN0
    );
  NlwInverterBlock_fpga_din_MC_D1_IN0 : X_INV
    port map (
      I => spi_q_II_UIM,
      O => NlwInverterSignal_fpga_din_MC_D1_IN0
    );
  NlwInverterBlock_fpga_din_MC_D1_IN1 : X_INV
    port map (
      I => dummybits,
      O => NlwInverterSignal_fpga_din_MC_D1_IN1
    );
  NlwInverterBlock_dummybits_MC_D2_PT_0_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_dummybits_MC_D2_PT_0_IN1
    );
  NlwInverterBlock_dummybits_MC_D2_PT_1_IN0 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_dummybits_MC_D2_PT_1_IN0
    );
  NlwInverterBlock_dummybits_MC_D2_PT_1_IN1 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_dummybits_MC_D2_PT_1_IN1
    );
  NlwInverterBlock_dummybits_MC_SETF_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_dummybits_MC_SETF_IN0
    );
  NlwInverterBlock_dummybits_MC_SETF_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_dummybits_MC_SETF_IN1
    );
  NlwInverterBlock_pres_state_FFD1_MC_D2_PT_0_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_0_IN1
    );
  NlwInverterBlock_pres_state_FFD1_MC_D2_PT_1_IN2 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_1_IN2
    );
  NlwInverterBlock_pres_state_FFD1_MC_D2_PT_2_IN0 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_2_IN0
    );
  NlwInverterBlock_pres_state_FFD1_MC_D2_PT_2_IN1 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_2_IN1
    );
  NlwInverterBlock_pres_state_FFD1_MC_D2_PT_2_IN2 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_pres_state_FFD1_MC_D2_PT_2_IN2
    );
  NlwInverterBlock_pres_state_FFD3_MC_D2_PT_1_IN5 : X_INV
    port map (
      I => s_count(3),
      O => NlwInverterSignal_pres_state_FFD3_MC_D2_PT_1_IN5
    );
  NlwInverterBlock_pres_state_FFD3_MC_D2_PT_1_IN6 : X_INV
    port map (
      I => s_count(4),
      O => NlwInverterSignal_pres_state_FFD3_MC_D2_PT_1_IN6
    );
  NlwInverterBlock_pres_state_FFD3_MC_RSTF_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_pres_state_FFD3_MC_RSTF_IN0
    );
  NlwInverterBlock_pres_state_FFD3_MC_RSTF_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_pres_state_FFD3_MC_RSTF_IN1
    );
  NlwInverterBlock_pres_state_FFD2_MC_D2_PT_0_IN0 : X_INV
    port map (
      I => pres_state_FFD1,
      O => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_0_IN0
    );
  NlwInverterBlock_pres_state_FFD2_MC_D2_PT_0_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_0_IN1
    );
  NlwInverterBlock_pres_state_FFD2_MC_D2_PT_1_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN1
    );
  NlwInverterBlock_pres_state_FFD2_MC_D2_PT_1_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN2
    );
  NlwInverterBlock_pres_state_FFD2_MC_D2_PT_1_IN6 : X_INV
    port map (
      I => s_count(3),
      O => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN6
    );
  NlwInverterBlock_pres_state_FFD2_MC_D2_PT_1_IN7 : X_INV
    port map (
      I => s_count(4),
      O => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN7
    );
  NlwInverterBlock_pres_state_FFD2_MC_D2_PT_1_IN8 : X_INV
    port map (
      I => s_count(5),
      O => NlwInverterSignal_pres_state_FFD2_MC_D2_PT_1_IN8
    );
  NlwInverterBlock_s_count_0_MC_D1_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_count_0_MC_D1_IN1
    );
  NlwInverterBlock_s_count_1_MC_D1_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_count_1_MC_D1_IN1
    );
  NlwInverterBlock_s_count_2_MC_D1_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_count_2_MC_D1_IN1
    );
  NlwInverterBlock_s_count_3_MC_D1_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_count_3_MC_D1_IN1
    );
  NlwInverterBlock_s_count_4_MC_D1_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_count_4_MC_D1_IN1
    );
  NlwInverterBlock_s_count_5_MC_D1_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_count_5_MC_D1_IN1
    );
  NlwInverterBlock_spi_c_MC_D_IN0 : X_INV
    port map (
      I => spi_c_MC_D1,
      O => NlwInverterSignal_spi_c_MC_D_IN0
    );
  NlwInverterBlock_spi_c_MC_D2_PT_0_IN0 : X_INV
    port map (
      I => fpga_cclk_II_UIM,
      O => NlwInverterSignal_spi_c_MC_D2_PT_0_IN0
    );
  NlwInverterBlock_spi_c_MC_D2_PT_0_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_spi_c_MC_D2_PT_0_IN1
    );
  NlwInverterBlock_spi_c_MC_D2_PT_1_IN1 : X_INV
    port map (
      I => fpga_io_clk_II_UIM,
      O => NlwInverterSignal_spi_c_MC_D2_PT_1_IN1
    );
  NlwInverterBlock_spi_d_MC_D_IN0 : X_INV
    port map (
      I => spi_d_MC_D1,
      O => NlwInverterSignal_spi_d_MC_D_IN0
    );
  NlwInverterBlock_spi_d_MC_D2_PT_0_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_spi_d_MC_D2_PT_0_IN0
    );
  NlwInverterBlock_spi_d_MC_D2_PT_1_IN0 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_spi_d_MC_D2_PT_1_IN0
    );
  NlwInverterBlock_spi_d_MC_D2_PT_1_IN1 : X_INV
    port map (
      I => s_cmd_data,
      O => NlwInverterSignal_spi_d_MC_D2_PT_1_IN1
    );
  NlwInverterBlock_s_cmd_data_MC_tsimcreated_set_and_noreset_IN0 : X_INV
    port map (
      I => s_cmd_data_MC_RSTF,
      O => NlwInverterSignal_s_cmd_data_MC_tsimcreated_set_and_noreset_IN0
    );
  NlwInverterBlock_s_cmd_data_MC_D2_PT_0_IN0 : X_INV
    port map (
      I => pres_state_FFD1,
      O => NlwInverterSignal_s_cmd_data_MC_D2_PT_0_IN0
    );
  NlwInverterBlock_s_cmd_data_MC_D2_PT_1_IN0 : X_INV
    port map (
      I => pres_state_FFD1,
      O => NlwInverterSignal_s_cmd_data_MC_D2_PT_1_IN0
    );
  NlwInverterBlock_s_cmd_data_MC_D2_PT_4_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_s_cmd_data_MC_D2_PT_4_IN0
    );
  NlwInverterBlock_s_cmd_data_MC_D2_PT_4_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_s_cmd_data_MC_D2_PT_4_IN1
    );
  NlwInverterBlock_s_cmd_data_MC_D2_PT_5_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_cmd_data_MC_D2_PT_5_IN1
    );
  NlwInverterBlock_s_cmd_data_MC_D2_PT_5_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_s_cmd_data_MC_D2_PT_5_IN2
    );
  NlwInverterBlock_s_cmd_data_MC_RSTF_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_s_cmd_data_MC_RSTF_IN0
    );
  NlwInverterBlock_s_cmd_data_MC_RSTF_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_s_cmd_data_MC_RSTF_IN1
    );
  NlwInverterBlock_s_cmd_data_MC_RSTF_IN2 : X_INV
    port map (
      I => s_instcode(7),
      O => NlwInverterSignal_s_cmd_data_MC_RSTF_IN2
    );
  NlwInverterBlock_s_instcode_7_MC_CE_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_instcode_7_MC_CE_IN1
    );
  NlwInverterBlock_s_instcode_7_MC_CE_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_s_instcode_7_MC_CE_IN2
    );
  NlwInverterBlock_s_instcode_6_MC_CE_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_instcode_6_MC_CE_IN1
    );
  NlwInverterBlock_s_instcode_6_MC_CE_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_s_instcode_6_MC_CE_IN2
    );
  NlwInverterBlock_s_instcode_5_MC_CE_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_instcode_5_MC_CE_IN1
    );
  NlwInverterBlock_s_instcode_5_MC_CE_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_s_instcode_5_MC_CE_IN2
    );
  NlwInverterBlock_s_instcode_4_MC_CE_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_instcode_4_MC_CE_IN1
    );
  NlwInverterBlock_s_instcode_4_MC_CE_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_s_instcode_4_MC_CE_IN2
    );
  NlwInverterBlock_s_instcode_3_MC_SETF_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_s_instcode_3_MC_SETF_IN0
    );
  NlwInverterBlock_s_instcode_3_MC_SETF_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_s_instcode_3_MC_SETF_IN1
    );
  NlwInverterBlock_s_instcode_3_MC_CE_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_instcode_3_MC_CE_IN1
    );
  NlwInverterBlock_s_instcode_3_MC_CE_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_s_instcode_3_MC_CE_IN2
    );
  NlwInverterBlock_s_instcode_2_MC_CE_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_instcode_2_MC_CE_IN1
    );
  NlwInverterBlock_s_instcode_2_MC_CE_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_s_instcode_2_MC_CE_IN2
    );
  NlwInverterBlock_s_instcode_1_MC_SETF_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_s_instcode_1_MC_SETF_IN0
    );
  NlwInverterBlock_s_instcode_1_MC_SETF_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_s_instcode_1_MC_SETF_IN1
    );
  NlwInverterBlock_s_instcode_1_MC_CE_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_instcode_1_MC_CE_IN1
    );
  NlwInverterBlock_s_instcode_1_MC_CE_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_s_instcode_1_MC_CE_IN2
    );
  NlwInverterBlock_s_instcode_0_MC_D1_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_instcode_0_MC_D1_IN1
    );
  NlwInverterBlock_s_instcode_0_MC_D1_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_s_instcode_0_MC_D1_IN2
    );
  NlwInverterBlock_s_instcode_0_MC_SETF_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_s_instcode_0_MC_SETF_IN0
    );
  NlwInverterBlock_s_instcode_0_MC_SETF_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_s_instcode_0_MC_SETF_IN1
    );
  NlwInverterBlock_spi_holdn_MC_D_IN0 : X_INV
    port map (
      I => spi_holdn_MC_D1,
      O => NlwInverterSignal_spi_holdn_MC_D_IN0
    );
  NlwInverterBlock_spi_holdn_MC_D1_IN0 : X_INV
    port map (
      I => ext_spi_II_UIM,
      O => NlwInverterSignal_spi_holdn_MC_D1_IN0
    );
  NlwInverterBlock_spi_holdn_MC_D1_IN2 : X_INV
    port map (
      I => fpga_io_holdn_II_UIM,
      O => NlwInverterSignal_spi_holdn_MC_D1_IN2
    );
  NlwInverterBlock_spi_sn_MC_D_IN0 : X_INV
    port map (
      I => spi_sn_MC_D1,
      O => NlwInverterSignal_spi_sn_MC_D_IN0
    );
  NlwInverterBlock_spi_sn_MC_D2_PT_0_IN1 : X_INV
    port map (
      I => fpga_io_sn_II_UIM,
      O => NlwInverterSignal_spi_sn_MC_D2_PT_0_IN1
    );
  NlwInverterBlock_spi_sn_MC_D2_PT_1_IN0 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_spi_sn_MC_D2_PT_1_IN0
    );
  NlwInverterBlock_spi_sn_MC_D2_PT_1_IN1 : X_INV
    port map (
      I => s_spi_sn,
      O => NlwInverterSignal_spi_sn_MC_D2_PT_1_IN1
    );
  NlwInverterBlock_s_spi_sn_MC_D_IN0 : X_INV
    port map (
      I => s_spi_sn_MC_D1,
      O => NlwInverterSignal_s_spi_sn_MC_D_IN0
    );
  NlwInverterBlock_s_spi_sn_MC_D2_PT_0_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_s_spi_sn_MC_D2_PT_0_IN1
    );
  NlwInverterBlock_s_spi_sn_MC_SETF_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_s_spi_sn_MC_SETF_IN0
    );
  NlwInverterBlock_s_spi_sn_MC_SETF_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_s_spi_sn_MC_SETF_IN1
    );
  NlwInverterBlock_spi_wn_MC_D_IN0 : X_INV
    port map (
      I => spi_wn_MC_D1,
      O => NlwInverterSignal_spi_wn_MC_D_IN0
    );
  NlwInverterBlock_spi_wn_MC_D1_IN0 : X_INV
    port map (
      I => ext_spi_II_UIM,
      O => NlwInverterSignal_spi_wn_MC_D1_IN0
    );
  NlwInverterBlock_spi_wn_MC_D1_IN2 : X_INV
    port map (
      I => fpga_io_wn_II_UIM,
      O => NlwInverterSignal_spi_wn_MC_D1_IN2
    );
  NlwInverterBlock_FOOBAR1_ctinst_5_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_FOOBAR1_ctinst_5_IN0
    );
  NlwInverterBlock_FOOBAR1_ctinst_5_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_FOOBAR1_ctinst_5_IN1
    );
  NlwInverterBlock_FOOBAR1_ctinst_6_IN0 : X_INV
    port map (
      I => fpga_init_II_UIM,
      O => NlwInverterSignal_FOOBAR1_ctinst_6_IN0
    );
  NlwInverterBlock_FOOBAR1_ctinst_6_IN1 : X_INV
    port map (
      I => fpga_done_II_UIM,
      O => NlwInverterSignal_FOOBAR1_ctinst_6_IN1
    );
  NlwInverterBlock_FOOBAR2_ctinst_5_IN0 : X_INV
    port map (
      I => pres_state_FFD1,
      O => NlwInverterSignal_FOOBAR2_ctinst_5_IN0
    );
  NlwInverterBlock_FOOBAR2_ctinst_5_IN1 : X_INV
    port map (
      I => pres_state_FFD3,
      O => NlwInverterSignal_FOOBAR2_ctinst_5_IN1
    );
  NlwInverterBlock_FOOBAR2_ctinst_5_IN2 : X_INV
    port map (
      I => pres_state_FFD2,
      O => NlwInverterSignal_FOOBAR2_ctinst_5_IN2
    );
  NlwBlockROC : X_ROC
    generic map (ROC_WIDTH => 100 ns)
    port map (O => PRLD);

end Structure;

