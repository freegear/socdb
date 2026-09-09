////////////////////////////////////////////////////////////////////////////////
// File          : $HeadURL: file:///ci/svn/USBCTRL/USBIF/trunk/HSXXXIFxx/rtl_v/busmux.v $                                                    
// Author        : $Author: hhsilva $                                                     
// Project       : USBIF                                                    
// Instances     :                                                              
// Creation date :                                                              
////////////////////////////////////////////////////////////////////////////////
// Description:
//
//   Bus MUX for PHY + Controller MPH Integration
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

module busmux  (
                    s,
                    inn,
                    int,
                    o
                    );

`include "vusb_hs_cfg.v"

input  [7:0]                    s   ; // Select
input  [VUSB_HS_NUM_PORT-1:0]   inn  ; // In normal
input                           int  ; // In test
output [VUSB_HS_NUM_PORT-1:0]   o   ; // Out

// Select output using one-hot select signal (s)
assign  o[VUSB_HS_NUM_PORT-1:0] = ( s[VUSB_HS_NUM_PORT-1:0]  & {VUSB_HS_NUM_PORT{int}} ) |  // If Test Interface enable, assign from external single test signal
                                  (~s[VUSB_HS_NUM_PORT-1:0]  & inn);                      // If Test Interface disabled, assign from internal multi-PHY bus, from the Controller

endmodule
