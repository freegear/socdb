
`timescale 1ns/100ps

module tb_hapo500_min ;

reg 	RSTB           ;
reg	CSB            ;
reg	PS             ;
reg	C80            ;
reg	A0             ;
reg	RDB_E          ;
reg	WRB_RW         ;
reg     IC_TEST        ;
wire	[15:0]	DIO    ;

reg	[15:0]	dbin   ;   
wire	[15:0]	dbout  ;  

wire	vicon          ;
wire	VPREB          ;
wire	VPREG          ;
wire	VPRER          ;

wire	C1P            ;
wire	C1N            ;

wire	OSCA1          ;
wire	OSCA2          ;
wire	IREF           ;
//wire	[7:0]	test   ;
reg	dbouten        ;
//Simulation
wire [4:0] dbin_R = dbin[15:11] ;
wire [5:0] dbin_G = dbin [10:5] ;
wire [4:0] dbin_B = dbin [ 4:0] ;
wire [0:95] OUTR                ;
wire [0:95] OUTG                ;
wire [0:95] OUTB                ;
wire [95:0] OUT_SCAN            ;
wire [49:0] DOUT_ICON           ;
wire [3:0]  SOUT_ICON           ;

`include "./task_dot.v"

hapo500_eco9 hapo500_eco9 
(
C1P       , 
C1N       , 
RSTB      , 
WRB_RW    , 
RDB_E     , 
CSB       , 
A0        , 
DIO       , 
PS        , 
C80       ,
OSCA1     , 
OSCA2     , 
VPREB     , 
VPREG     , 
VPRER     , 
IREF      , 
IC_TEST   , 
OUTR      , 
OUTG      , 
OUTB      ,
SOUT_ICON , 
DOUT_ICON , 
OUT_SCAN 
);

/*wire [159:0]  Dig_Data ;
assign Dig_Data = { RSTB, PS, C80, IC_TEST, A0, WRB_RW, RDB_E, CSB, DIO,                                   //8
                   hapo500_eco9.LOGIC.EN_OSCA, hapo500_eco9.LOGIC.OSCACLK, hapo500_eco9.LOGIC.RSB_DATA,    //3
                   hapo500_eco9.LOGIC.OSCACLKB, hapo500_eco9.LOGIC.START,                                  //2
                   hapo500_eco9.LOGIC.DATAR, hapo500_eco9.LOGIC.DATAG, hapo500_eco9.LOGIC.DATAB,           //19
                   hapo500_eco9.LOGIC.LE, hapo500_eco9.LOGIC.PRECH,                                        //2
                   hapo500_eco9.LOGIC.BOOSTR, hapo500_eco9.LOGIC.BOOSTG, hapo500_eco9.LOGIC.BOOSTB,        //3
                   hapo500_eco9.LOGIC.DATAENR, hapo500_eco9.LOGIC.DATAENG, hapo500_eco9.LOGIC.DATAENB,     //3
                   hapo500_eco9.LOGIC.IN_SCAN,                                                             //96
                   hapo500_eco9.LOGIC.IBIASR, hapo500_eco9.LOGIC.IBIASG, hapo500_eco9.LOGIC.IBIASB };      //24
*/
/*integer Dot_Dyn ;
   initial begin
      Dot_Dyn = $fopen("Dot_MIN.trc"); end

    //initial begin
     // $fmonitor (Dot_Dyn, "%15.3f %b", $realtime, Dig_Data ); end

  always @(posedge hapo500_eco9.LOGIC.OSCACLKB) begin
      $fstrobe(Dot_Dyn, "%b",Dig_Data);
//      $fstrobe(Dot_Dyn,"%15.3f %b",$realtime,Dig_Data);
//      $fstrobe(Dot_Dyn,"%b",Dig_Data);
  end
*/
    
/*initial begin
        $sdf_annotate("/home3/project/HAPO500/Sim/Post_sim/Sim_jj/SDF/hapo500_eco9.SDF",hapo500_eco9,,,,);
        $sdf_annotate("/home3/project/HAPO500/Sim/Post_sim/Sim_jj/SDF/pad_top.min.sdf" ,hapo500_eco9.PAD,,,,);
        $sdf_annotate("/home3/project/HAPO500/Sim/Post_sim/Sim_jj/SDF/icon_top1.SDF"   ,hapo500_eco9.CON_ICON_LO,,,,);
        $sdf_annotate("/home3/project/HAPO500/Sim/Post_sim/Sim_jj/SDF/icon_top1.SDF"   ,hapo500_eco9.CON_ICON_HI,,,,);
        $shm_open("graphic.min.shm");
        $shm_probe("AC");
  end
 */
integer	j ;
integer i ;
assign	DIO = dbouten == 0 ? dbin : 16'dz;
initial begin
INIT ;
ComandWrite68(16'h000D);
ParameterWR1(16'h0001);

ComandWrite68(16'h0030);
ParameterWR1(16'h0000);
ParameterWR2(16'h005F);

ComandWrite68(16'h0008);
MemWR; 



/*initial begin
 		//$sdf_annotate("HANA_3RD.SDF",HANA_TOP,,,,,);
		//$monitor($time,,,"%b %b %b %b %b %b %b %b",RSTB,PS,C80,CSB,A0,RDB_E,WRB_RW,dbin);
		RSTB    = 0 ;
		PS      = 1 ;
		C80     = 1 ;
		CSB     = 1 ;
		A0      = 0 ;
		RDB_E   = 0 ;
		WRB_RW  = 0 ;
		dbin    = 0 ;
		IC_TEST = 0 ;
		#5000
		RSTB    = 1 ;
		#5000



// ******************************************************************
// 1. cpu interface select[0Dh]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h0D;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0         =1'b1;
                //Parameter
		dbin[15:8] = 8'h00;
                //dbin[7:0]  = 8'h00; //8bit interface
                dbin[7:0]  = 8'h01; //16bit interface
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;

// ******************************************************************
// 2. DFRAME:Dot Matrix Frame rate[1Ah]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h1A ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter               
                //dbin[7:0]  = 8'h00 ; //60Hz
                //dbin[7:0]  = 8'h01 ; //75Hz
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                dbin[7:0]  = 8'h03 ; //105Hz
                //dbin[7:0]  = 8'h04 ; //120Hz
                //dbin[7:0]  = 8'h05 ; //135Hz
                //dbin[7:0]  = 8'h06 ; //150HZ
                //dbin[7:0]  = 8'h07 ; //150Hz
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;

// ******************************************************************
// 3. Dot Matrix Current level set red[40h]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h40 ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
               // dbin[7:0]  = 8'h0f ; //11.25 レA
               //TEST
                dbin[7:0]  = 8'h33 ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;
// ******************************************************************
// ******************************************************************
// 4. Dot Matrix Current level set green[41h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h41; //23.25 レA
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h21 ;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
// ******************************************************************
// ******************************************************************
// 5. Dot Matrix Current level blue[42h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h42;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h29;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;

// ******************************************************************
// 6. Xbox start Address[34h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h34;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		//dbin[15:8]=8'h00;
                //dbin[7:0]=8'h0A; //10d
                dbin[7:0]=8'h00;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
//********************************************************************

// ******************************************************************
// 7. Xbox End Address[35h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h35;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]=8'h00;
                //dbin[7:0]=8'h2D; //45d
                dbin[7:0]=8'h5F;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
//********************************************************************

// ******************************************************************
// 8. Ybox Start Address[36h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h36;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8] = 8'h00;
		//dbin[7:0]  = 8'h0B; //11d
                dbin[7:0]=8'h00;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
//*******************************************************************

// ******************************************************************
// 9. Ybox End Address[37h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h37;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]= 8'h00 ;
		//dbin[7:0] = 8'h23 ; //35d
                dbin[7:0]=8'h5F;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
//*******************************************************************

// ******************************************************************
// 10. Graphic memory writing direction[1Dh]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h1D ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
                
                //Horizontal
                dbin[7:0] = 8'h00 ; //VH:D1:D0 =000
                //dbin[7:0] = 8'h01 ; //VH:D1:D0 =001
                //dbin[7:0] = 8'h02 ; //VH:D1:D0 =010
                //dbin[7:0] = 8'h03 ; //VH:D1:D0 =011
                
                //Vertical
                //dbin[7:0] = 8'h04 ; //VH:D1:D0 =000
                //dbin[7:0] = 8'h05 ; //VH:D1:D0 =001
                //dbin[7:0] = 8'h06 ; //VH:D1:D0 =010
                //dbin[7:0] = 8'h07 ; //VH:D1:D0 =011
                
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;
//*******************************************************************

// ******************************************************************
//  11. Peak pulse width red[3Ah]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h3A;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h05; //5レA
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
// ******************************************************************
// ******************************************************************
//  12. Peak pulse width green[3Bh]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h3b;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]=8'h00;
                dbin[7:0] =8'h05; //5レA
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
               	#50
                CSB=1;
		#50;
// ******************************************************************
// ******************************************************************
//  13. Peak pulse width blue[3Ch]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h3c;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
		dbin[15:8]=8'h00;
                //dbin[7:0]=8'h05; //5レA
                dbin[7:0]=8'h1A; //26レA
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
// ******************************************************************
// ******************************************************************
//  14. Peak pulse delay[16h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h16;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h05; //5レs
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
               	#50
                CSB=1;
		#50;
// ******************************************************************
// ******************************************************************
//  15. Precharge width[18h]
// ******************************************************************
		CSB          = 0     ;
		dbouten      = 0     ;
                A0           = 1'b0  ;
                WRB_RW          = 1'b0  ;
		dbin[15:8]   = 8'h00 ;
                dbin[7:0]    = 8'h18 ;
                RDB_E          = 1'b0  ;
                #50
                RDB_E          = 1'b1  ;
                #50
                RDB_E          = 1'b0  ;
                #50
                A0           = 1'b1  ;
		dbin[15:8]   = 8'h00 ;
                //dbin[7:0] = 8'h08 ; //default
                dbin[7:0]    = 8'h0A ;   //10 レs
                RDB_E          = 1'b0  ;
                #50
                RDB_E          = 1'b1  ;
                #50
                RDB_E          = 1'b0  ;
                #50
                CSB          = 1     ;
		#50;
// ******************************************************************
// ******************************************************************
//  16. Precharge mode select[44h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h44;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
		dbin[15:8] = 8'h00 ;
                
                dbin[7:0] = 8'h00 ; //None
                //dbin[7:0] = 8'h01 ; //Every time
                //dbin[7:0] = 8'h02 ; //Every time
                //dbin[7:0] = 8'h03 ; //Selective
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
// ******************************************************************
// ******************************************************************
//  17. Row overlap[48h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h48;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
		dbin[15:8]= 8'h00 ;
		dbin[7:0] = 8'h00 ; //None
		//dbin[7:0] = 8'h01 ; //Pre-Charge
                //dbin[7:0] = 8'h02 ; //Pre-Charge + Peak delay
                //dbin[7:0] = 8'h03 ; //Pre-Charge + Peak delay + Max(RGB) peak boot timing
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
// ******************************************************************

// ******************************************************************
// ******************************************************************
//  18. Row scan sequence[13h] : 
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h13;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h00; //Alternate scan mode (default)
                //dbin[7:0]=8'h01; //Sequential Scan mode : ODD...EVEN
                //dbin[7:0]=8'h02; //Simultaneous scan mode(half period)
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;

// ******************************************************************

// ******************************************************************
// Page-18 ref
//  19. Memory reading X-start Address[38h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h38;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h00;
                //dbin[7:0]=8'd47; //d'47
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;

// ******************************************************************
//  20. Memory reading Y-start Address[39h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h39;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]= 8'h00;
                dbin[7:0] = 8'h00;
                //dbin[7:0] = 8'd93; //d'31 
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
				
// ******************************************************************
// ******************************************************************
//   21. Dot Matrix data write[08h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h08;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                
                A0=1'b1;
                WRB_RW=1'b0;
                #50
		for(j = 0; j < 96; j = j + 1 )
		begin
		 for(i = 0; i < 96 ; i = i + 1 )
		 begin
		 //******* data insert ********
		 //dbin[15:11] = dbin[15:11] + 1 ;	        //red
		 //dbin[10:5]  = dbin[10:5]  + 1 ;		//green 
		 //dbin[4:0]   = dbin[4:0]   + 1 ;		//blue  
		 
		// dbin[15:11] = dbin[15:11] + 1 ;	        //red
		// dbin[10:5]  = 6'h3F           ;		//green //44h(03h:Selective Data Test)
		// dbin[4:0]   = dbin[4:0]   + 1 ;		//blue  
		 	
		  dbin = dbin + 1 ; //Normal
		  //dbin[15:8] = 8'h00        ; //8Bit Mode
		  //dbin[7:0] = dbin[7:0] + 1 ; //8Bit Mode(0Dh) 
                 //******* data insert end ********
                 	RDB_E=1'b0;
                 	#50
                 	RDB_E=1'b1;
                 	#50
                 	RDB_E=1'b0;
		 	#50;
			end
		end
		CSB=1;
		#50;
// ******************************************************************

// ******************************************************************
//  22. Row scan direction[09h] 
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h09 ;
                RDB_E        = 1'b0  ;
                #50
                
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
                #50
                
                A0         = 1'b1  ;
                //parameter
		dbin[15:8] = 8'h00 ;
                dbin[7:0]= 8'd00 ; //Normal
                //dbin[7:0]  = 8'd02 ; //Mirror
                RDB_E        = 1'b0  ;
                #50
                
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
               	#50
               	
                CSB        = 1     ;
		#50;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ******************************************************************
//  23. Display Xsize [30h]0~5Fh
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h30 ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
                #50
               // 1st Parameter               
                A0         = 1'b1  ;
		dbin[15:8] = 8'h00 ;
               // dbin[7:0]  = 8'h00 ;
                dbin[7:0]  = 8'h14 ; //20d
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
              
              // 2nd Parameter    
                A0         = 1'b1  ;
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]  = 8'h5F ;
                dbin[7:0]  = 8'h46 ;//70d
          	RDB_E        = 1'b0  ;
          	#50
          	RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;



// ******************************************************************
//  24. Display Ysize [32h]0~5Fh
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h32 ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
                #50
               // 1st Parameter               
                A0         = 1'b1  ;
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]  = 8'h00 ;
                //dbin[7:0]  = 8'h5F ; //Size Error
                dbin[7:0]  = 8'h1E ; //30d
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
              
              // 2nd Parameter    
                A0         = 1'b1  ;
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]  = 8'h5F ;
                //dbin[7:0]  = 8'h0A ; //Size Error
                dbin[7:0]  = 8'h50 ; //80d
          	RDB_E        = 1'b0  ;
          	#50
          	RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;

// ******************************************************************
// 25. Row Scan [17h]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h17 ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]  = 8'h01 ; //All Scan VSS
                dbin[7:0]  = 8'h00 ; //Normal Operation
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;
// ******************************************************************
		
// ******************************************************************
// 26. Display standby ON/Off[14h]
// ******************************************************************
                CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                dbin[15:8] = 8'h00 ;
		dbin[7:0]  = 8'h14 ;
		RDB_E        = 1'b0  ;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
		A0=1'b1;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h00; //ON
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;

// ******************************************************************
//  27. Display On/OFF[02h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h02;
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h01; //ON
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
          
                 # ( 120000 * 2 );
// ******************************************************************
//  28. Row scan direction[09h] 
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h09 ;
                RDB_E        = 1'b0  ;
                #50
                
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
                #50
                
                A0         = 1'b1  ;
                //parameter
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]= 8'd00 ; //Normal
                dbin[7:0]  = 8'd02 ; //Mirror
                RDB_E        = 1'b0  ;
                #50
                
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
               	#50
               	
                CSB        = 1     ;
		#50;
// ******************************************************************
// 29. DFRAME:Dot Matrix Frame rate[1Ah]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h1A ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h00 ; //60Hz
                //dbin[7:0]  = 8'h01 ; //75Hz
                //dbin[7:0]  = 8'h03 ; //105Hz
                //dbin[7:0]  = 8'h04 ; //120Hz
                //dbin[7:0]  = 8'h05 ; //135Hz
                //dbin[7:0]  = 8'h06 ; //150HZ
              
                //dbin[7:0]  = 8'h07 ; //150Hz
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;
		//#(120000) ;
                # ( 12000000 * 2 );
// ******************************************************************
//  30. Row scan direction[09h] 
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h09 ;
                RDB_E        = 1'b0  ;
                #50
                
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
                #50
                
                A0         = 1'b1  ;
                //parameter
		dbin[15:8] = 8'h00 ;
                dbin[7:0]= 8'd00 ; //Normal
                //dbin[7:0]  = 8'd02 ; //Mirror
                RDB_E        = 1'b0  ;
                #50
                
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
               	#50
               	
                CSB        = 1     ;
		#50;
// ******************************************************************
//  31. Display Xsize [30h]0~5Fh
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h30 ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
                #50
               // 1st Parameter               
                A0         = 1'b1  ;
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h00 ;
                //dbin[7:0]  = 8'h14 ; //20d
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
              
              // 2nd Parameter    
                A0         = 1'b1  ;
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h5F ;
               // dbin[7:0]  = 8'h46 ;//70d
          	RDB_E        = 1'b0  ;
          	#50
          	RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;



// ******************************************************************
//  32. Display Ysize [32h]0~5Fh
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h32 ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                
                RDB_E        = 1'b0  ;
                #50
               // 1st Parameter               
                A0         = 1'b1  ;
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h00 ;
                //dbin[7:0]  = 8'h5F ; //Size Error
                //dbin[7:0]  = 8'h1E ; //30d
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
              
              // 2nd Parameter    
                A0         = 1'b1  ;
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h5F ;
                //dbin[7:0]  = 8'h0A ; //Size Error
                //dbin[7:0]  = 8'h50 ; //80d
          	RDB_E        = 1'b0  ;
          	#50
          	RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;
 


// ******************************************************************
// 33. DFRAME:Dot Matrix Frame rate[1Ah]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h1A ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h00 ; //60Hz
                //dbin[7:0]  = 8'h01 ; //75Hz
                //dbin[7:0]  = 8'h03 ; //105Hz
                //dbin[7:0]  = 8'h04 ; //120Hz
                //dbin[7:0]  = 8'h05 ; //135Hz
                dbin[7:0]  = 8'h06 ; //150HZ
                // dbin[7:0]  = 8'h07 ; //150Hz
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;
	     
		#(120000*2) ;  

// ******************************************************************
//  34. Row scan sequence[13h] :
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h13;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]=8'h00;
                //dbin[7:0]=8'h00; //Alternate scan mode (default)
                dbin[7:0]=8'h01; //Sequential Scan mode : ODD...EVEN
                //dbin[7:0]=8'h02; //Simultaneous scan mode(half period)
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;

// ******************************************************************
// ******************************************************************
// 35. DFRAME:Dot Matrix Frame rate[1Ah]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h1A ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h00 ; //60Hz
                dbin[7:0]  = 8'h01 ; //75Hz
                //dbin[7:0]  = 8'h03 ; //105Hz
                //dbin[7:0]  = 8'h04 ; //120Hz
                //dbin[7:0]  = 8'h05 ; //135Hz
                //dbin[7:0]  = 8'h06 ; //150HZ
                // dbin[7:0]  = 8'h07 ; //150Hz
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;
	     
		#(120000*2) ;  

// ******************************************************************
//  36. Row overlap[48h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h48;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
		dbin[15:8]= 8'h00 ;
		//dbin[7:0] = 8'h00 ; //None
		//dbin[7:0] = 8'h01 ; //Pre-Charge
                //dbin[7:0] = 8'h02 ; //Pre-Charge + Peak delay
                dbin[7:0] = 8'h03 ; //Pre-Charge + Peak delay + Max(RGB) peak boot timing
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
		
// ******************************************************************
// 37. Display standby ON/Off[14h]
// ******************************************************************
                CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                dbin[15:8] = 8'h00 ;
		dbin[7:0]  = 8'h14 ;
		RDB_E        = 1'b0  ;
                #50;
                RDB_E        = 1'b1;
                #50;
                RDB_E        = 1'b0;
                #50
		A0=1'b1;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h00; //ON
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;		       

// ******************************************************************
//38. Display On/OFF[02h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h02;
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h01; //ON
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;       
		#(12000000);         
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ******************************************************************
// 39. DFRAME:Dot Matrix Frame rate[1Ah]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h1A ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h00 ; //60Hz
                //dbin[7:0]  = 8'h01 ; //75Hz
                //dbin[7:0]  = 8'h03 ; //105Hz
                 dbin[7:0]  = 8'h04 ; //120Hz
                //dbin[7:0]  = 8'h05 ; //135Hz
                //dbin[7:0]  = 8'h06 ; //150HZ
                //dbin[7:0]  = 8'h07 ; //150Hz
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;


		#(120000 * 2);
// ******************************************************************
// ******************************************************************
//  40. Row scan sequence[13h] : row96channnel.v
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h13;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]=8'h00;
                //dbin[7:0]=8'h00; //Alternate scan mode (default)
                //dbin[7:0]=8'h01; //Sequential Scan mode : ODD...EVEN
                dbin[7:0]=8'h02; //Simultaneous scan mode(half period)
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
// ******************************************************************
//  41. Precharge mode select[44h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h44;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
		dbin[15:8] = 8'h00 ;
                
                //dbin[7:0] = 8'h00 ; //None
                dbin[7:0] = 8'h01 ; //Every time
                //dbin[7:0] = 8'h02 ; //Every time
                //dbin[7:0] = 8'h03 ; //Selective
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
// ******************************************************************
//42. Display On/OFF[02h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h02;
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h00; //OFF
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
                #(10000000*2)
// ******************************************************************
// ******************************************************************
//43. Display On/OFF[02h]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h02;
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h01; //ON
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
                #(1000*23)               
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// ******************************************************************
// 44. DFRAME:Dot Matrix Frame rate[1Ah]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h1A ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h00 ; //60Hz
                //dbin[7:0]  = 8'h01 ; //75Hz
                //dbin[7:0]  = 8'h03 ; //105Hz
                // dbin[7:0]  = 8'h04 ; //120Hz
                dbin[7:0]  = 8'h05 ; //135Hz
                //dbin[7:0]  = 8'h06 ; //150HZ
                //dbin[7:0]  = 8'h07 ; //150Hz
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;


		#(120000 * 2);
// ******************************************************************
//  45. Peak pulse width red[3Ah]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h3A;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h0A; //5レA
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
// ******************************************************************
// ******************************************************************
//  46. Peak pulse width green[3Bh]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h3b;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8]=8'h00;
                dbin[7:0] =8'h0B; //5レA
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
               	#50
                CSB=1;
		#50;
// ******************************************************************
// ******************************************************************
//  47. Peak pulse width blue[3Ch]
// ******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h3c;
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                A0=1'b1;
		dbin[15:8]=8'h00;
                //dbin[7:0]=8'h05; //5レA
                dbin[7:0]=8'h1F; //31レA
                RDB_E=1'b0;
                #50
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
// ******************************************************************
//  48. Precharge width[18h]
// ******************************************************************
		CSB          = 0     ;
		dbouten      = 0     ;
                A0           = 1'b0  ;
                WRB_RW          = 1'b0  ;
		dbin[15:8]   = 8'h00 ;
                dbin[7:0]    = 8'h18 ;
                RDB_E          = 1'b0  ;
                #50
                RDB_E          = 1'b1  ;
                #50
                RDB_E          = 1'b0  ;
                #50
                A0           = 1'b1  ;
		dbin[15:8]   = 8'h00 ;
                //dbin[7:0] = 8'h08 ; //default
                dbin[7:0]    = 8'h0A ;   //10 レs
                RDB_E          = 1'b0  ;
                #50
                RDB_E          = 1'b1  ;
                #50
                RDB_E          = 1'b0  ;
                #50
                CSB          = 1     ;
		#50;
// ******************************************************************
// 49. DFRAME:Dot Matrix Frame rate[1Ah]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h1A ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h00 ; //60Hz
                //dbin[7:0]  = 8'h01 ; //75Hz
                //dbin[7:0]  = 8'h03 ; //105Hz
                 dbin[7:0]  = 8'h04 ; //120Hz
                //dbin[7:0]  = 8'h05 ; //135Hz
                //dbin[7:0]  = 8'h06 ; //150HZ
                //dbin[7:0]  = 8'h07 ; //150Hz
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;


		#(10000000 * 2);
		

// ******************************************************************
// 50. Display standby ON/Off[14h]
// ******************************************************************
                CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                dbin[15:8] = 8'h00 ;
		dbin[7:0]  = 8'h14 ;
		RDB_E        = 1'b0  ;
                #50;
                RDB_E        = 1'b1;
                #50;
                RDB_E        = 1'b0;
                #50
		A0=1'b1;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h01; //OFF OSCA Stop
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;		       
              #(10000) ; 	

// ******************************************************************
// 51. Display standby ON/Off[14h]
// ******************************************************************
                CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                dbin[15:8] = 8'h00 ;
		dbin[7:0]  = 8'h14 ;
		RDB_E        = 1'b0  ;
                #50;
                RDB_E        = 1'b1;
                #50;
                RDB_E        = 1'b0;
                #50
		A0=1'b1;
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h00; //ON : OSCACLK RUN
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;		       
            //  #(10000) ; 		

//*******************************************************************
//52. Display On/OFF[02h]
//******************************************************************
		CSB=0;
		dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
		dbin[15:8]=8'h00;
                dbin[7:0]=8'h02;
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
		dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h01; //ON
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
		#50;
                #(1000000 *10)

// ******************************************************************
// 53. softreset
// ******************************************************************
              CSB=0;
                #10
                dbouten = 0;            //
                #1                      //
                A0=1'b0;                //      Software reset command.

                WRB_RW=1'b0;            //   All registers are cleared default (except for ICON Area and Data Register )
                dbin[15:8]=8'h00;       //      Dot matrix and all Icon turn OFF.

                dbin[7:0]=8'h01;        //      OSCA , OSCB and internal DC-DC are stopped.

                RDB_E=1'b0;             //
                #50                     //
                RDB_E=1'b1;
                #50
                RDB_E=1'b0;
                #50
                #50000;

// ******************************************************************
// 54. Display standby ON/Off[14h]
// ******************************************************************
                CSB        = 0     ;
                dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW     = 1'b0  ;
                dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h14 ;
                RDB_E      = 1'b0  ;
                #50;
                RDB_E      = 1'b1  ;
                #50;
                RDB_E      = 1'b0  ;
                #50
                A0=1'b1;
                dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h00 ; //ON
                RDB_E      = 1'b0  ;
                #50;
                RDB_E      = 1'b1  ;
                #50;
                RDB_E      = 1'b0  ;
                #50
                CSB=1;
                #5000;

//*******************************************************************
//55. Display On/OFF[02h]
//******************************************************************
                CSB=0;
                dbouten = 0;
                A0=1'b0;
                WRB_RW=1'b0;
                //Command
                dbin[15:8]=8'h00;
                dbin[7:0]=8'h02;
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                A0=1'b1;
                //Parameter
                dbin[15:8] = 8'h00;
                dbin[7:0]  = 8'h01; //ON
                RDB_E=1'b0;
                #50;
                RDB_E=1'b1;
                #50;
                RDB_E=1'b0;
                #50
                CSB=1;
                #50;

// ******************************************************************
// 56. DFRAME:Dot Matrix Frame rate[1Ah]
// ******************************************************************
		CSB        = 0     ;
		dbouten    = 0     ;
                A0         = 1'b0  ;
                WRB_RW        = 1'b0  ;
                //Command
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h1A ;
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                A0         = 1'b1  ;
                //Parameter
		dbin[15:8] = 8'h00 ;
                dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h02 ; //90Hz(Default)
                //dbin[7:0]  = 8'h00 ; //60Hz
                //dbin[7:0]  = 8'h01 ; //75Hz
                //dbin[7:0]  = 8'h03 ; //105Hz
                // dbin[7:0]  = 8'h04 ; //120Hz
                //dbin[7:0]  = 8'h05 ; //135Hz
                //dbin[7:0]  = 8'h06 ; //150HZ
                //dbin[7:0]  = 8'h07 ; //150Hz
                RDB_E        = 1'b0  ;
                #50
                RDB_E        = 1'b1  ;
                #50
                RDB_E        = 1'b0  ;
                #50
                CSB        = 1     ;
		#50;


		#(10000 * 200);*/
#(1000*20);		
$finish;
end

endmodule
