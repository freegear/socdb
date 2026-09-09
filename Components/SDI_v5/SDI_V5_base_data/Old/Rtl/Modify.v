//  reg         Timer_Match_Clr ;
  reg         Timer_Out       ;
 // wire         Timer_Out       ;
wire  [15:0] TPWM              ;
reg  [15:0]  R4            ;

//==============================================================================
// PWM end register[0x01FF_8410]    
// TPWM[15:0]:0x00FF
// Current PWM's end count value during PWM operation
//============================================================================== 
//Timers 0
  always @ (posedge PCLK or negedge PRESETn)
    begin : p_Reg4Seq
      if ((!PRESETn))
        R4 <= 16'h00FF;
      else
        if (R4En)
        R4 <= PWDATA[15:0] ;
    end
    

  always @ (PADDR or R0 or R1 or R2 or R3 or R4 )
          begin : p_RdRegMuxComb
      // Determine the next value of ReadRegs0
      case (PADDR[7:2])
       // case (PADDR[4:2]) 
        `ADDRREG0 : ReadRegs  = {{16{1'b0}},  R0  };
        `ADDRREG1 : ReadRegs  = {24'd0, R1        };
        `ADDRREG2 : ReadRegs  = {24'd0, R2        };
        `ADDRREG3 : ReadRegs  = {16'd0, R3        };
        `ADDRREG4 : ReadRegs  = {16'd0, R4        };
         default  : ReadRegs   = {32{1'b0}}        ;  // Read as zero default
        endcase
           end 
 
//=======================================================================================
// 16-Bit Timer Counter
//=======================================================================================

//Timers 0
always @ (posedge Timers_CLK or negedge Timers_CLR)
    begin : p_Timers_Count //4
     if ((!Timers_CLR))
      Timer_Cnt <= {16{1'b0}};
      else begin 
        if (~TEN) 
         Timer_Cnt <= {16{1'b0}}; 
      else begin 
       if (OMS == `OMSCode0  ) begin  //Internal Mode
      if (Timer_Cnt == TDAT_Value-1  )
             Timer_Cnt <=  {16{1'b0}}; 
       else  Timer_Cnt <= Timer_Cnt + 1 ;
                               end
       else if (OMS == `OMSCode2  ) begin
         if (Timer_Cnt == TPWM-1)  
              Timer_Cnt <= {16{1'b0}}    ;
         else Timer_Cnt <= Timer_Cnt + 1 ;
                                    end
            else  begin
            Timer_Cnt <= Timer_Cnt + 1  ;                   
              end
         end 
          end 
           end 




          
//-------------------------------------------------------------
// Tout Mode Timing Match
//-------------------------------------------------------------
//Timers 0                  
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_Timer_Match_Gen
         if ((!Timers_CLR)) 
                Timer_Match_Set <= 1'b0 ; 
            else begin
                if ( Timer_Cnt == TDAT_Value - 2 ) 
                        Timer_Match_Set <= 1'b1 ;
                  else  Timer_Match_Set <= 1'b0 ;                         
                       end
                          end       
assign INT_TMC  = Timer_Match_Set   ; 

//----------------------------------------------------------
// Time Out
//----------------------------------------------------------
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_Interval
         if ((!Timers_CLR))
            
                 Timer_Out <= 1'b0 ;
              else begin
               if ( OMS != `OMSCode0 )
                   Timer_Out <= 1'b0 ;
               else begin
               if (Timer_Match_Set)
                   Timer_Out <=  Timer_Out + 1 ;   
                     end              
                    end 
                     end       

                                                               
//==============================================================================
// PWM end register[0x01FF_8410]    
// TPWM[15:0]:0x00
// Current PWM's end count value during PWM operation
//============================================================================== 
assign TPWM = R4 ;
always @(posedge Timers_CLK or negedge Timers_CLR)
          begin : p_PWM_O
          if ((!Timers_CLR))
              PWM_Out <= 1'b1 ;
              else begin
              if ( OMS != `OMSCode2 ) 
                  PWM_Out <= 1'b1 ;
                  else begin
                 if (Timer_Cnt > TDAT_Value-2 && Timer_Cnt < TPWM-1 )  
                   PWM_Out <=  1'b0 ;
              else PWM_Out <=  1'b1 ;
                        end  
                         end              
                          end
