////////////////////////////////////////////////////////////////////////////////
// File          : $HeadURL: file:///ci/svn/USBCTRL/USBIF/trunk/HSXXXIFxx/rtl_v/scanclkmux.v $                                                    
// Author        : $Author: hhsilva $                                                     
// Project       : USBIF                                                    
// Instances     :                                                              
// Creation date :                                                              
////////////////////////////////////////////////////////////////////////////////
// Description:
//
//   clock MUX for Controller
//
////////////////////////////////////////////////////////////////////////////////
// ChipIdea Microelectronica / IPCS                                             
// TECMAIA, Rua Eng. Frederico Ulrich, n 2650                                   
// 4470/920 MOREIRA MAIA                                                        
// Portugal                                                                     
// Tel: +351 229471010                                                          
// Fax: +351 229471011                                                          
// e_mail: chipidea@chipidea.com                                                
////////////////////////////////////////////////////////////////////////////////
// ISO 9001:2000 / Certified Company                                            
// (C) 2005 Copyright Chipidea(R)                                               
// Chipidea(R) / Microelectronica, S.A. reserves the right to make changes to   
// the information contained herein without notice. No liability shall be       
// incurred as a result of its use or application.                              
////////////////////////////////////////////////////////////////////////////////
// Last modification   :                                                        
// $Date: 2006-10-27 14:23:04 +0100 (Fri, 27 Oct 2006) $                                                                       
// $Revision: 100 $

`timescale 1ns / 1ps

module scanclkmux  (
                    scanmode        ,
                    clk             ,
                    xcvr_clk        ,
                    muxed_xcvr_clk
                    );

`include "vusb_hs_cfg.v"

input                           scanmode        ; // 
input                           clk             ; //
input  [VUSB_HS_NUM_PORT-1:0]   xcvr_clk        ; //
output [VUSB_HS_NUM_PORT-1:0]   muxed_xcvr_clk  ; //

// Mux clocks according to scanmode. If in scan mode, all clocks are equal to 'clk'
assign  muxed_xcvr_clk  = scanmode ? {VUSB_HS_NUM_PORT{clk}} : xcvr_clk  ;

endmodule
