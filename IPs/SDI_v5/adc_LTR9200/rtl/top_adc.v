
// ====================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// --------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : top_adc.v 
// File Revision       : 1.0
//
//  -------------------------------------------------------------------
//  Purpose            : Test for ADC ( adc_control /adc modeling)
//  ===================================================================
//

module  top_adc(

    //APB interface
    PCLK         , 
    PRESETn      , 
    PENABLE      , 
    PSEL         , 
    PWRITE       , 
    PADDR        , //[3:2] used
    PWDATA       , //[15:0] used
    PRDATA       , 
    
    INT_ADC      ,
    CLK_ADCCLK   ,


    //Analog signal
    AVDD    ,
    DVDD    ,
    CH0     ,
    CH1     ,
    CH2     ,
    CH3     ,
    CH4     ,
    CH5     ,
    CH6     ,
    CH7     ,
    DIFF    , //normal = 0
    AVSS    ,
    DVSS     
);

input	PCLK;
input	CLK_ADCCLK;
input	PRESETn;

input	[3:2]	PADDR;
input	[15:0]	PWDATA;

input	PSEL;
input	PWRITE ;
input	PENABLE;

input AVDD    ;
input DVDD    ;
input CH0     ;
input CH1     ;
input CH2     ;
input CH3     ;
input CH4     ;
input CH5     ;
input CH6     ;
input CH7     ;
input DIFF    ; //normal = 0
input AVSS    ;
input DVSS    ;

output	[31:0]	PRDATA;
output	INT_ADC;


//ADC 
wire  SHDN;
wire  SOC;
wire  EOC;
wire  [2:0] SEL;
wire  [9:0] DOUT;

adc_control U0_adc_control(

  //APB interface
    .PCLK(PCLK)         , 
    .PRESETn(PRESETn)   , 
    .PENABLE(PENABLE)   , 
    .PSEL(PSEL)         , 
    .PWRITE(PWRITE)     , 
    .PADDR(PADDR[3:2])  , 
    .PWDATA(PWDATA[15:0])  , 
    .PRDATA(PRDATA)  ,
    
    .INT_ADC(INT_ADC)        ,
    .CLK_ADCCLK(CLK_ADCCLK)  ,

  //ADC interface

    .SOC(SOC),   //start of conversion
    .SEL(SEL),   //Select channel
    .SHDN(SHDN), //shutdown mode
    .EOC(EOC),   //end of conversion
    .DOUT(DOUT)  // [9:0]

	);

adc_LTR9200 U0_adc_LTR9200(

  .SHDN(SHDN)    ,
  .AD_CLK(CLK_ADCCLK),
  .RST(PRESETn),
  .ASEL(SEL)    ,
  .SOC(SOC)     ,

  .EOC(EOC)      ,
  .DOUT(DOUT)	,

  //analog

  .AVDD(AVDD)  ,
  .DVDD(DVDD)  ,
  .CH0(CH0)    ,
  .CH1(CH1)    ,
  .CH2(CH2)    ,
  .CH3(CH3)    ,
  .CH4(CH4)    ,
  .CH5(CH5)    ,
  .CH6(CH6)    ,
  .CH7(CH7)    ,
  .DIFF(DIFF)    , //normal = 0
  .AVSS(AVSS)    ,
  .DVSS(DVSS)  
);

endmodule
