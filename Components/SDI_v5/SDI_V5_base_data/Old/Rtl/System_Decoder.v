// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : System_Decoder.v
// File Revision       : 1.0
//  ------------------------------------------------------------------
//  Purpose            : Provides the HSELx module select outputs to
//                       the AHB system slaves
//  --==============================================================--

`timescale 1ns/1ps

module System_Decoder
  (
   // Upper order bits of the address bus for the decode function
   HADDR       ,

   // Status of the system re-map
   Remap       ,
   // Select lines produced by Boot Mode :0x0000_0000 ~ 0x0010_0000
   HSELS0B     ,   // Boot select for the first 1MB      
   HSELS0R     ,   // Re-map select for the first 1MB
   // Select lines produced by Boot Mode :0x0010_0000 ~ 0x0020_0000
   HSELS0EM    ,   // External SRAM 
   HSELS0IF    ,   // Internal Flash                   
   
   HSELS0      ,   // External SRAM1                   : 0x0020_0000 ~ 0x0010_0000
   HSELS1      ,   // External SRAM2                   : 0x0030_0000 ~ 0x0020_0000
   HSELS2      ,   // External SRAM3                   : 0x0040_0000 ~ 0x0050_0000
   HSELS3      ,   //Internal FLASH mirror             : 0x01F0_0000 ~ 0x01F4_0000
   HSELS4      ,   //Internal 24KB SRAM                : 0x01FF_0000 ~ 0x01FF_8000
   HSELS5      ,   //Internal FLASH Control            : 0x01FF_8000 ~ 0x01FF_8100
   HSELS6      ,   //External SRAM Bank Control        : 0x01FF_8100 ~ 0x01FF_8200
   HSELS7      ,   //APB                               : 0x01FF_8200 ~ 0x01FF_8E00
   HSELS_Resv1 ,   //Reserve1                          : 0x0050_0000 ~ 0x1F00_0000
   HSELS_Resv2 ,   //Reserve2                          : 0x01F4_0000 ~ 0x01FF_0000
   HSELS_Resv3 ,   //Reserve3                          : 0x01FF_8E00 ~ 0x0200_0000
   HSELS_Abort      //Abort                             : 0x0200_0000 ~ 0xFFFF_FFFF
   
 );  

 
  input [31:0]   HADDR       ;
  input          Remap       ;
  output         HSELS0B     ;
  output         HSELS0R     ;
  output         HSELS0EM    ;
  output         HSELS0IF    ;
  
  output         HSELS0      ;
  output         HSELS1      ;
  output         HSELS2      ;
  output         HSELS3      ;
  output         HSELS4      ;
  output         HSELS5      ;
  output         HSELS6      ;
  output         HSELS7      ;  
  output         HSELS_Resv1 ;
  output         HSELS_Resv2 ;
  output         HSELS_Resv3 ;
  output         HSELS_Abort  ;


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire [31:0] HADDR       ;
  wire         Remap       ;

  reg          HSELS0B     ;
  reg          HSELS0R     ;
  reg          HSELS0EM    ;
  reg          HSELS0IF    ;
  
  reg          HSELS0      ;
  reg          HSELS1      ;
  reg          HSELS2      ;
  
  wire         HSELS3      ;
  wire         HSELS4      ;
  wire         HSELS5      ;
  wire         HSELS6      ;
  wire         HSELS7      ;
  
  wire         HSELS_Resv1 ;
  wire         HSELS_Resv2 ;
  wire         HSELS_Resv3 ;
  wire         HSELS_Abort ;
//--------------------------------------------------------------------
// Signal declarations
//--------------------------------------------------------------------
// Signal used to determine memory selected at address zero
  reg      LoMem   ;
// Signal used to determine memory selected at address 0x00100000
//  reg      LoMemEx ;
//--------------------------------------------------------------------
// Beginning of main code
//--------------------------------------------------------------------

//--------------------------------------------------------------------
// Low memory decoding
//--------------------------------------------------------------------
// Detection of the first 1MB within the region addressed by HSELS0 is
// performed separately in order to reduce the depth of the main case
// statement in p_AddressDecodeComb
   

  always @ (HADDR)
    begin : p_LoMemDecodeComb
      if (HADDR[27:20]== 8'b00000000) //0x00000000 ~ 0x000FFFFF:0xX00XXXXX
        begin 
          LoMem = 1'b1;
        end
      else
        begin //=> 0x00100000 
          LoMem = 1'b0;
        end 
    

    end 


//--------------------------------------------------------------------
// AHB address decoding
//--------------------------------------------------------------------
// The address map is split into 256MB sections, based on a decode of
// the top 4 address bits.  The exception is the first 1MB: an ARM
// processor always boots from address 0, and expects the exception
// vectors to be located from here.  HSELS0B and HSELS0R provide
// separate decodes for the first 1MB region at boot-up and after
// remap, respectively.

  always @ (HADDR or LoMem or Remap)
    begin : p_addressdecode0x001
      // Default values:Simulation
      HSELS0B      = 1'b0; //Internal Flash
      HSELS0R      = 1'b0; //External SRAM
      HSELS0EM     = 1'b0; //External SRAM
      HSELS0IF     = 1'b0; //Internal Flash
                   
      HSELS0       = 1'b0; //External SRAM1
      HSELS1       = 1'b0; //External SRAM2
      HSELS2       = 1'b0; //External SRAM3
      
//      HSELS_Resv1  = 1'b0 ;
//      HSELS3       = 1'b0 ;
//      HSELS_Resv2  = 1'b0 ;
//      HSELS4       = 1'b0 ;
//      HSELS5       = 1'b0 ;
//      HSELS6       = 1'b0 ;
//      HSELS7       = 1'b0 ;
//      HSELS_Resv3  = 1'b0 ;
//      HSELS_Abort  = 1'b0 ;

     
      
     // +0x001---:0x0000_0000 ~ 0x01EF_FFFF
      case (HADDR[31:20]) //0x000-----
       12'h000: begin //
         if (LoMem)
           begin 
            
       case (Remap)
         1'b0 : begin
         HSELS0B = 1'b1;
                end
           
         1'b1 : begin
         HSELS0R = 1'b1;
                end
               
         default: begin
            // Null
                  end
             endcase
              end
               end
       
        
      
       12'h001 :begin   //0x001-----
          case (Remap)
           1'b0   : begin
           HSELS0EM = 1'b1 ;
                 end
           1'b1   : begin
           HSELS0IF = 1'b1 ;
                  end
           default: begin
           //Null
                   end
                endcase
                  end
            
       12'h002 : begin    
          HSELS0 = 1'b1; 
          end
        
       12'h003 : begin    
          HSELS1 = 1'b1; 
                 end
       12'h004: begin
          HSELS2 = 1'b1;
        end
        
        default: begin
                 // Null
            end
             endcase
             
              end 

 //Reserve1: 0x0050_0000 ~ 0x1F00_0000
 //Internal FLASH mirror       : 0x01F0_0000 ~ 0x01F4_0000
 //Reserve2                    : 0x01F4_0000 ~ 0x01FF_0000
 //Internal 24KB SRAM          : 0x01FF_0000 ~ 0x01FF_8000
 //Internal FLASH Control      : 0x01FF_8000 ~ 0x01FF_8100
 //External SRAM Bank Control  : 0x01FF_8100 ~ 0x01FF_8200
 //APB                         : 0x01FF_8200 ~ 0x01FF_8E00
 //Reserve3                    : 0x01FF_8E00 ~ 0x0200_0000
 //Abort                       : 0x0200_0000 ~ 0xFFFF_FFFF
 //FPGA Conversion?? U must check this phrase 
 assign HSELS_Resv1  = (( HADDR[31:20] >=  12'h005  ) && ( HADDR[31:20] < 12'h01F  )) ? 1'b1 : 1'b0 ;
 assign HSELS3       = (( HADDR[31:18] >=  {12'h01F,2'b00} ) && ( HADDR[31:18] < { 12'h01F,2'b01}  )) ? 1'b1 : 1'b0 ;
 assign HSELS_Resv2  = ( HADDR[31:16]  >=  16'h01F4 ) && ( HADDR[31:16] < 16'h01FF ) ? 1'b1 : 1'b0 ;  
 assign HSELS4       = (( HADDR[31:15] >= {16'h01FF, 1'b0})) && ((HADDR[31:15] < {16'h01FF,1'b1} )) ? 1'b1 : 1'b0 ;
 
 assign HSELS5       = ( HADDR[31:8]   >=  24'h01FF_80   )&& (HADDR[31:8] < 24'h01FF_81 ) ? 1'b1 : 1'b0 ;
 assign HSELS6       = ( HADDR[31:8]   >=  24'h01FF_81   )&& (HADDR[31:8] < 24'h01FF_82 ) ? 1'b1 : 1'b0 ;
 assign HSELS7       = ( HADDR[31:8]   >=  24'h01FF_82   )&& (HADDR[31:8] < 24'h01FF_8E ) ? 1'b1 : 1'b0 ;
 assign HSELS_Resv3  = ( HADDR[31:8]   >=  24'h01FF_8E   )&& (HADDR[31:8] < 24'h0200_00 ) ? 1'b1 : 1'b0 ;
 assign HSELS_Abort  = ( HADDR[31:25]  >=  7'b0000_001   ) ? 1'b1 : 1'b0 ;
 
endmodule
