//`timescale 100ns/1ns
`timescale 1ns/1ps

module tb_hapo500 ;

reg	wrb;
reg	rdb;
reg	csb;
reg	a0;

reg	ps;
reg	c80;

reg	preb;
reg	preg;
reg	prer;

reg	c1p;
reg	c1n;
reg	osc1;
reg	dbouten       ;

wire	osc2;
wire	iref;
wire	[7:0]	test;
wire	vicon;

//////////////////////////////////////////////
reg           IC_Test_Mode                   ;
reg           Test_Se                        ;                  
reg           Scan_in                        ;
reg           Test_Clock                     ;


//reg	        OSACLK                       ; //DOT Matrix Clock :
reg	        rstb                         ; //Hardware Reset

//MPU IF
reg             soft_rst                     ; //01H : Soft Reset
reg	        displayonoff                 ; //02H : Dot Matrix Display ON/OFF(Default:00):		
reg	        displaystandbyonoff          ; //14H : DSTBYON/OFF	
reg	[2:0]	framerate                    ; //1AH : Dot Matrxi Frame Rate
reg             RFLAG                        ;	
	

reg	[1:0]	displaydirection             ; //09h : Row Scan Direction	
reg	[6:0]	displaysizexstart            ; //30h : Display Xsize( DXstart)	
reg	[6:0]	displaysizexend              ; //30h : Display Xsize( DXyend)		
reg	[6:0]	displaysizeystart            ; //32h : Display Ysize( DYstart)	
reg	[6:0]	displaysizeyend              ; //32h : Display Ysize( DYend  )		
reg	[6:0]	memreadcolumnstart           ; //38h : Memory Reading X-Start Address(X Axis Start address(00~5Fh)) 
reg	[6:0]	memreadrowstart              ; //39h : Memory Reading Y-Start Address(Y Axis Start address(00~5Fh))
reg	[3:0]	datamask                     ; //1Eh : Data Masking		

reg	[4:0]	peakpulsewidthred            ; //3Ah : Peak Pulse Width Set: PeakWidthR	
reg	[4:0]	peakpulsewidthgreen          ; //3Bh : Peak Pulse Width Set: PeakWidthG	
reg	[4:0]	peakpulsewidthblue           ; //3Ch : Peak Pulse Width Set: PeakWidthB	
reg	[3:0]	peakpulsedelay               ; //16h : Peak Pulse Delay	
	
reg	[7:0]	currentlevelred              ; //40h : Dot Matrix Current Level Set	
reg	[7:0]	currentlevelgreen            ; //41h : Dot Matrix Current Level Set	
reg	[7:0]	currentlevelblue             ; //42h : Dot Matrix Current Level Set	

reg	[7:0]	prechargewidth               ; //18h : Pre-Charge Width Set
reg	[1:0]	preselect                    ; //44h : Pre-Charge Mode Select	
		
reg	[1:0]	rowoverlap                   ; //48h : Row Overlap Set		
reg	        rowscan                      ; //17h : Row_scan		
reg	[1:0]	rowscansequence              ; //13h : Row Scan Sequence setting		

//Non-Frame base
//input	        cpuinterfaceselect           ; //0Dh : CPU Interface Select                     
reg	[7:0]	screensleeptimer             ; //C0h :Screen saver S_SleepTimer	
reg	        screensleepstart             ; //C2h :S_SleepStart		
reg	[7:0]	screensteptimer              ; //C3h :S_StepTimer		
reg	[1:0]	screenstepunit               ; //C4h :S_StepUnit		
reg	[6:0]	screenboxxstart              ; //C6h :Screensaver Column Start Address
reg	[6:0]	screenboxxend                ; //C8h :Screensaver Column End Address
reg	[6:0]	screenboxystart              ; //C7h :Screensaver Row Start Address		
reg	[6:0]	screenboxyend                ; //C9h :Screensaver Row End Address	
	
reg	[3:0]	screenstepvaluex             ; //CAh :Screensaver moving step: S_StepX	
reg	[3:0]	screenstepvaluey             ; //CBh :Screensaver moving step: S_StepY	
reg	[4:0]	screencondition              ; //CCh :Screensaver_Condition(UDRL)		
reg	        screenstartstop              ; //CDh :Screensaver Start/Stop		
reg	[3:0]	screensaverselect            ; //CEh : Screen Saver Select
reg	[2:0]	screencolorstage             ; //CFh : ColorPallet setting command for S_AutoColor
reg	[3:0]	screencolorpallet0           ; //D0h : Pallet Set(RV, R,G,B)pallet0
reg	[3:0]	screencolorpallet1           ; //D0h : Pallet Set(RV, R,G,B)pallet1
reg	[3:0]	screencolorpallet2           ; //D0h : Pallet Set(RV, R,G,B)pallet2
reg	[3:0]	screencolorpallet3           ; //D0h : Pallet Set(RV, R,G,B)pallet3
reg	[3:0]	screencolorpallet4           ; //D0h : Pallet Set(RV, R,G,B)pallet4
reg	[3:0]	screencolorpallet5           ; //D0h : Pallet Set(RV, R,G,B)pallet5
reg	[3:0]	screencolorpallet6           ; //D0h : Pallet Set(RV, R,G,B)pallet6
reg	[3:0]	screencolorpallet7           ; //D0h : Pallet Set(RV, R,G,B)pallet7


wire   	[15:0]	d;
reg	[15:0]	dbin   ;   
wire	[15:0]	dbout  ;  

wire            Scan_Dot_out                 ;
wire	        RSTB_DATA                    ; //To Analog , Hw,Sw,Display On/OFF, Stand-By On/OFF 
wire	        OSCA_CLKB                    ; //To Analog , From Digital To Analog (Inversion Clock )
wire            Start                        ; //To Analog ,Data Start
wire	        LE                           ; //To Analog ,Date Latch enable
//output  data_disp                            ; //To Analog ,Column Data Display Enable

wire	        PRECH                        ; //To Analog
wire	        BOOSTR                       ; //To Analog
wire	        BOOSTG                       ; //To Analog
wire	        BOOSTB                       ; //To Analog

wire    [95:0]   IN_SCAN                      ; //To Analog  
wire   	[5:0]	DATAR                        ; //To Analog        
wire    [6:0]	DATAG                        ; //To Analog
wire   	[5:0]	DATAB                        ; //To Analog

wire	[7:0]	IBIASR                       ; //To Analog
wire	[7:0]	IBIASG                       ; //To Analog
wire	[7:0]	IBIASB                       ; //To Analog
wire	        EN_OSCA                      ; //To Analog

wire          DATAENR                      ; //To Analog  
wire          DATAENG                      ; //To Analog  
wire          DATAENB                      ; //To Analog  
wire          SsleepEnd                    ; //To MCU

wire [3:0]   F4_Reg                        ; //F4h : Test Register(Observer)
wire [6:0]   F5_Reg                        ; //F5h : Test Register(Observer)
wire [5:0]   F6_Reg                        ; //F6h : Test Register(Observer)
wire [6:0]   F7_Reg                        ; //F7h : Test Register(Observer)
wire [5:0]   F8_Reg                        ; //F8h : Test Register(Observer)
wire [7:0]   F9_Reg                        ; //F9h : Test Register(Observer)
wire [7:0]   FA_Reg                        ; //FAh : Test Register(Observer)
wire [7:0]   FB_Reg                        ; //FBh : Test Register(Observer)
wire [7:0]   FC_Reg                        ; //FCh : Test Register(Observer)

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// B-PORT:  PANEL Port
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wire [12:0]   ba_e                         ; //Even Address
wire [12:0]   ba_o                         ; //Odd Address
//reg    [15:0]   bdo_e                        ; //Even Output
//reg    [15:0]   bdo_o                        ; //Odd Output
wire    [15:0]   bdo_e                        ; //Even Output
wire    [15:0]   bdo_o                        ; //Odd Output

wire          Bre_e                        ; //Even Readenable
wire          Bre_o                        ; //Odd Readenable

wire [4:0] dbin_R = dbin[15:11] ;
wire [5:0] dbin_G = dbin [10:5] ;
wire [4:0] dbin_B = dbin [ 4:0] ;


`include "./task_dot_on.v"

Dot_Control_Mem Dot_Control_Mem 
(
vicon,
preb,
preg,
prer,

c1p,
c1n,
	

wrb,
rdb,
csb,
a0,
d,
ps,
c80,
osc1,
osc2,
iref,
test,
	
IC_Test_Mode        ,
Test_Se             ,                  
Scan_in             ,   
Test_Clock          ,
Scan_Dot_out        ,


rstb                ,
//OSACLK              ,

soft_rst            ,
displayonoff        ,
displaystandbyonoff ,
framerate           ,
RFLAG               ,                       
                       
displaydirection    ,
                       
displaysizexstart   ,
displaysizexend     ,
displaysizeystart   ,
displaysizeyend     ,
memreadcolumnstart  ,
memreadrowstart     ,
                       
datamask            ,
                       
peakpulsewidthred   ,
peakpulsewidthgreen ,
peakpulsewidthblue  ,
peakpulsedelay      ,
                      
currentlevelred     ,
currentlevelgreen   ,
currentlevelblue    ,
                    
prechargewidth      ,
preselect           ,
                     
rowoverlap          ,
rowscan             ,
rowscansequence     ,
                      
screensleeptimer    ,
screensleepstart    ,
screensteptimer     ,
screenstepunit      ,
screenboxxstart     ,
screenboxxend       ,
screenboxystart     ,
screenboxyend       ,
screenstepvaluex    ,
screenstepvaluey    ,
screencondition     ,
screenstartstop     ,
screensaverselect   ,
screencolorstage    ,
screencolorpallet0  ,
screencolorpallet1  ,
screencolorpallet2  ,
screencolorpallet3  ,
screencolorpallet4  ,
screencolorpallet5  ,
screencolorpallet6  ,
screencolorpallet7  ,  

//Test Instruction
//F0_Inst             ,
//F1_Inst             ,	
                    
RSTB_DATA           ,
OSCA_CLKB           ,
                    
Start               ,
LE                  ,
//data_disp           ,
                    
PRECH               ,
BOOSTR              ,
BOOSTG              ,
BOOSTB              ,
	            
IN_SCAN             ,
DATAR               ,
DATAG               ,
DATAB               ,
                    
IBIASR              ,
IBIASG              ,
IBIASB              ,

DATAENR             ,
DATAENG             ,
DATAENB             ,
                    
EN_OSCA             ,

      
//Memory IF
ba_e                , 
//bdo_e               ,
                    
ba_o                , 
//bdo_o 	            ,
                    
Bre_e               ,
Bre_o               ,
SsleepEnd           ,
       
                    
// Test Register    
F4_Reg              ,
F5_Reg              ,
F6_Reg              ,
F7_Reg              ,
F8_Reg              ,
F9_Reg              ,
FA_Reg              ,
FB_Reg              ,
FC_Reg              
);


integer	j ;
integer i ;
assign	d = dbouten == 0 ? dbin : 16'dz;
initial begin
INIT ;
ComandWrite68  (16'h000D);    //Chip Select[8/16 bit Bus Select]  
ParameterWR1   (16'h0001);    //16bit Select

ComandWrite68  (16'h0008);    //Memory Write[96x96]
MemWR; 

//1A
Frame_rate       (8'h03 );    //105Hz
                              //8'h00 ; //60Hz
                              //8'h01 ; //75Hz
                              //8'h02 ; //90Hz
                              //8'h03 ; //105Hz
                              //8'h04 ; //120Hz
                              //8'h05 ; //135Hz
                              //8'h06 ; //150HZ
                              
//Dot Current Level 80cd/m2: 40,41,42h:0.75レA Step

Current_Red      (8'h33 );    //38.25レA 
Current_Green    (8'h21 );    //24.75レA
Current_Blue     (8'h29 );    //30.75レA



//Source Driver Parameter
//Peak Pulse Width [3A,3B,3Ch]: 1レA Step
PulseWidth_Red   (8'h05 ); //5レA
PulseWidth_Green (8'h05 ); //5レA
PulseWidth_Blue  (8'h1A ); //26レA

Pulse_Delay      (8'h05 ); //5レs

//Precharge[18h,44h]
PreCh_Width      (8'h0A ); //10 レs
PreCh_Sel        (8'h00 ); //None
                //8'h01 ;  //Every time
                //8'h02 ;  //Every time
                //8'h03 ;  //Selective

//Row Overlap[48h]
Row_Overlap      (8'h00 ); //None
		//8'h01 ;  //Pre-Charge
                //8'h02 ;  //Pre-Charge + Peak delay
                //8'h03 ;  //Pre-Charge + Peak delay + Max(RGB) peak boot timing  
//Row Sequence[13h]       
Row_Sequence     (8'h00 ); //Alternate scan mode (default)
                //8'h01;   //Sequential Scan mode : ODD...EVEN
                //8'h02;   //Simultaneous scan mode(half period)

//Row Scan Direction[19h]
Row_Direction    (8'd00 ); //Normal
                           //8'd02 ; //Mirror
//Row Scan[17h]                           
Row_Scan17H      (1'b0 ) ; //1'b1  : All Scans in VSS
                           
//Display Size[Full][X:30,Y:32h]
Disp_Xstart      (8'h00 );
Disp_Xend        (8'h5F );
Disp_Ystart      (8'h00 );
Disp_Yend        (8'h5F );

//Display Start[14h]: OSCA ON
Disp_Standby     (1'b0  ); //ON OSCA Start
//Display ON/OFF[02h]
Disp_ONOFF       (1'b1  ); //ON
# ( 120000 * 2 );

Frame_rate       (8'h02 ); //90Hz(Default)                          
# ( 12000000 * 2 );

//TEST1

//Row Overlap[48h]
Row_Overlap      (8'h03 ); //Pre-Charge + Peak delay + Max(RGB) peak boot timing  
//Display Size[X:30,Y:32h:50x50]
Disp_Xstart      (8'h14 ); //20d
Disp_Xend        (8'h46 ); //70d 
Disp_Ystart      (8'h1E ); //30d
Disp_Yend        (8'h50 ); //80d

Frame_rate       (8'h06 ); //150HZ
#(120000*2) ;
Row_Sequence     (8'h00 ); //Alternate scan mode (default)
Frame_rate       (8'h01 ); //75Hz
#(120000*2) ; 
Row_Overlap      (8'h02 ); //Pre-Charge + Peak delay + Max(RGB) peak boot timing
Frame_rate       (8'h04 ); //120Hz
#(120000 * 2);
Row_Sequence     (8'h00 ); //Alternate scan mode (default)
Disp_ONOFF       (1'b0  ); //OFF
 #(10000000*2)
Disp_ONOFF       (1'b1  ); //ON
#(1000*23) 
Frame_rate       (8'h05 ); //135HZ
#(120000 * 2);
PulseWidth_Red   (8'h0A ); //10レA
PulseWidth_Green (8'h0B ); //11レA
PulseWidth_Blue  (8'h1A ); //26レA
PreCh_Width      (8'h08 ); //8レs
Frame_rate       (8'h04 ); //120HZ
#(10000000 * 2);
Disp_Standby     (1'b1  ); //OFF OSCA Stop
#(100000);
Disp_ONOFF       (1'b1  ); //ON
#(1000000 *10)
Soft_Reset       (1'b0  ); //Soft Reset
Disp_Standby     (1'b0  ); //ON OSCA Stop
Disp_ONOFF       (1'b1  ); //ON
#(100000);
Soft_Reset       (1'b1  ); //Soft Reset
Frame_rate       (8'h07 ); //150HZ
#(1000000 *10)
#(10000*20);		
$finish;
end

endmodule
