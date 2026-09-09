//----------------------------------------------------------------------
//
// Copyright (c) 2003 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//----------------------------------------------------------------------
//
//  Project       : PCI-M64AHB
//
//  File          : pci_m64_params.v
//
//  Dependencies  : 
//
//  Model Type:   : Synthesizable core
//
//  Description   : PCI-M64AHB Core Parameters
//
//  Designer      : AS
//
//  QA Engineer   : 
//
//  Creation Date : 17-September-2003
//
//  Last Update   : 20-November-2003
//
//  Version       : 1.0.2V
//----------------------------------------------------------------------
   // configuration space parameters
   parameter oe_active = 1'b0; // output buffer polarity
   parameter[15:0] vendor_id = 16'b1010101111001101; //Vendor ID
   parameter[15:0] device_id = 16'b0110010001100110; //Device ID
   parameter[23:0] class_id = {8'b00000110, 8'b10000000, 8'b00000000}; //Device Class, subclass, interface
   parameter[7:0] rev_id = 8'b00010000; //Revision ID
   //BAR0 parameters
   parameter bar0_present = 1'b1; 
   //                             3322222222221111111111
   //                             10987654321098765432109876543210
   parameter[31:0] bar0_map = 32'b11111111111111111111110000000000; 
   parameter bar0_dwidth = 22; //1kB space
   //BAR1 parameters
   parameter bar1_present = 1'b1; 
   //                             3322222222221111111111
   //                             10987654321098765432109876543210
   parameter[31:0] bar1_map = 32'b11111111000000000000000000000000; 
   parameter bar1_dwidth = 8;  //16MB space 
   //BAR2 parameters
   parameter bar2_present = 1'b0; 
   parameter[31:0] bar2_map = 32'b00000000000000000000000000000000; 
   parameter bar2_dwidth = 28; 
   //BAR3 parameters
   parameter bar3_present = 1'b0; 
   parameter[31:0] bar3_map = 32'b00000000000000000000000000000000; 
   parameter bar3_dwidth = 28; 
   //BAR4 parameters
   parameter bar4_present = 1'b0; 
   parameter[31:0] bar4_map = 32'b00000000000000000000000000000000; 
   parameter bar4_dwidth = 28; 
   //BAR5 parameters
   parameter bar5_present = 1'b0; 
   parameter[31:0] bar5_map = 32'b00000000000000000000000000000000; 
   parameter bar5_dwidth = 28; 
   //Expansion ROM BAR parameters
   parameter ebar_present = 1'b0; 
   parameter[31:0] ebar_map = 32'b00000000000000000000000000000000; 
   parameter ebar_dwidth = 17;
   // 
   parameter[15:0] subvendor_id = 16'b0001000011101110; 
   parameter[15:0] subdevice_id = 16'b0000000100000000; 
   parameter[31:0] cis_ptr = {32{1'b0}}; 
   parameter[7:0] cap_ptr = 8'b00000000; // Capabilities pointer
   parameter[7:0] max_lat = 8'b00100000; // Max. latency
   parameter[7:0] min_gnt = 8'b00000100; // Min. grant
   parameter[7:0] int_pin = 8'b00000001; // Interrupt pin (00 = no interrupt, 01 = INTA#)
   parameter[7:0] int_line = 8'b00000000;// Interrupt line
   //------------------------------------------------------
   //------------------------------------------------------
   //--         do not edit beyond this point            --
   //------------------------------------------------------
   //------------------------------------------------------
   parameter[15:0] command_init = 16'b0000000000000000; 
   parameter[15:0] status_init = 16'b0000001000100000; 
   parameter[7:0] clsize_init = 8'b00000000; 
   parameter[7:0] lattimer_init = 8'b00000000; 
   parameter[7:0] intline_init = 8'b00000000; 
   // PCI Commands
   parameter[3:0] iack_code = 4'b0000; 
   parameter[3:0] scyc_code = 4'b0001; 
   parameter[3:0] iord_code = 4'b0010; 
   parameter[3:0] iowr_code = 4'b0011; 
   parameter[3:0] res4_code = 4'b0100; 
   parameter[3:0] res5_code = 4'b0101; 
   parameter[3:0] mrd_code = 4'b0110; 
   parameter[3:0] mwr_code = 4'b0111; 
   parameter[3:0] res8_code = 4'b1000; 
   parameter[3:0] res9_code = 4'b1001; 
   parameter[3:0] cfgrd_code = 4'b1010; 
   parameter[3:0] cfgwr_code = 4'b1011; 
   parameter[3:0] mrm_code = 4'b1100; 
   parameter[3:0] dual_code = 4'b1101; 
   parameter[3:0] mrl_code = 4'b1110; 
   parameter[3:0] mwi_code = 4'b1111; 

