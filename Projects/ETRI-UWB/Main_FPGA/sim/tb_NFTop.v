//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : Nand flash control
// module name : NFCtrl.v
// history     :
//
//************************************************

`timescale 1ns/10ps
`define BOOT
//`define debug
module Tb_NFTop();

reg         PCLK	    ;
reg         PRESETn     ;
reg [ 6:2]  PADDR       ;
reg         PSEL        ;
reg         PENABLE     ;
reg         PWRITE      ;
reg [31:0]  PWDATA      ;
wire[31:0]  PRDATA      ;

wire        NFDMAReqOut ;
wire        NFINTOut    ;

reg         NFBootPinIn;    
reg         IOWidthPinIn;   
reg         NandWidthPinIn;   
reg [ 1:0]  BootCfgPinIn;   
reg         OutDtmnPinIn;   

wire[11:0]  AddrCnt     ;

wire[15:0]  NFDataIn    ;
wire[15:0]  NFDataOut   ;
wire        NFDataOutEn ;
wire        CLE         ;
wire        ALE         ;
wire        nNFCE0      ;
wire        nNFCE1      ;
wire        nNFRE       ;
wire        nNFWE       ;

wire        RnB0        ;
wire        RnB1        ;



parameter   byte        =2'b00;
parameter   halfword    =2'b01;
parameter   word        =2'b10;

parameter   cycle2      =2'b00;
parameter   cycle3      =2'b01;
parameter   cycle4      =2'b10;
parameter   cycle5      =2'b11;

parameter   NoOption    =2'b00;
parameter   RnBWait     =2'b01;
parameter   AutoRdStat  =2'b10;
parameter   Continue    =2'b11;


parameter   FIFOLEVEL   =3'd0; //FIFOLEVEL+1 => ½ÇÁ¦ level

pullup(RnB1);
pullup(RnB0);
// Instantiate Device

reg[11:0] PageSize;
wire[15:0]  NFIO;

`ifdef x8
    `ifdef Page512
        NANDxxxWxA  uut0(
           .I_O (NFIO[7:0]  ),   
           .E_N (nNFCE0     ),   
           .R_N (nNFRE      ),       
           .W_N (nNFWE      ),   
           .WP_N(1'b1       ),
           .AL  (ALE        ),    
           .CL  (CLE        ),
           .RB_N(RnB0       ),
           .Vss (           ),
           .Vdd (           ));
    `else
        nand_model_0 uut0(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE0     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB0       ));
    `endif
`endif

`ifdef x16
nand_model_0 uut0(
   .Io  (NFIO[15:0] ),        
   .Cle (CLE        ),
   .Ale (ALE        ),
   .Ce_n(nNFCE0     ),
   .We_n(nNFWE      ),
   .Re_n(nNFRE      ),
   .Wp_n(1'b1       ),
   .Pre (1'b1       ),
   .Rb_n(RnB0       ));
   
`endif

`ifdef dual
    `ifdef Page512
        NANDxxxWxA  uut0(
           .I_O (NFIO[7:0]  ),   
           .E_N (nNFCE0     ),   
           .R_N (nNFRE      ),       
           .W_N (nNFWE      ),   
           .WP_N(1'b1       ),
           .AL  (ALE        ),    
           .CL  (CLE        ),
           .RB_N(RnB0       ),
           .Vss (           ),
           .Vdd (3          ));

        NANDxxxWxA  uut1(
           .I_O (NFIO[15:8] ),   
           .E_N (nNFCE0     ),   
           .R_N (nNFRE      ),       
           .W_N (nNFWE      ),   
           .WP_N(1'b1       ),
           .AL  (ALE        ),    
           .CL  (CLE        ),
           .RB_N(RnB0       ),
           .Vss (           ),
           .Vdd (3          ));
   `else
        nand_model_0 uut0(
           .Io  (NFIO[7:0]  ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE0     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB0       ));

        nand_model_0 uut1(
           .Io  (NFIO[15:8] ),        
           .Cle (CLE        ),
           .Ale (ALE        ),
           .Ce_n(nNFCE0     ),
           .We_n(nNFWE      ),
           .Re_n(nNFRE      ),
           .Wp_n(1'b1       ),
           .Pre (1'b1       ),
           .Rb_n(RnB0       ));
    `endif
`endif

`ifdef mcp
nand_model_0 uut0(
   .Io  (NFIO[7:0]  ),        
   .Cle (CLE        ),
   .Ale (ALE        ),
   .Ce_n(nNFCE0     ),
   .We_n(nNFWE      ),
   .Re_n(nNFRE      ),
   .Wp_n(1'b1       ),
   .Pre (1'b1       ),
   .Rb_n(RnB0       ));

nand_model_1 uut1(
   .Io  (NFIO[7:0] ),        
   .Cle (CLE        ),
   .Ale (ALE        ),
   .Ce_n(nNFCE1     ),
   .We_n(nNFWE      ),
   .Re_n(nNFRE      ),
   .Wp_n(1'b1       ),
   .Pre (1'b1       ),
   .Rb_n(RnB1       ));
`endif

NFTop uNFTop(
   .PCLK	    (PCLK	     ),      
   .PRESETn     (PRESETn     ),
   .PADDR       (PADDR       ),
   .PSEL        (PSEL        ),
   .PENABLE     (PENABLE     ),
   .PWRITE      (PWRITE      ),
   .PWDATA      (PWDATA      ),
   .PRDATA      (PRDATA      ),
 
   .NFDMAReqOut (NFDMAReqOut ),
   .NFINTOut    (NFINTOut    ),

   .NFBootPinIn(NFBootPinIn),  
   .IOWidthPinIn(IOWidthPinIn), 
   .NandWidthPinIn(NandWidthPinIn), 
   .BootCfgPinIn(BootCfgPinIn), 
   .OutDtmnPinIn(OutDtmnPinIn), 
   
   .AddrCnt     (AddrCnt     ),

   .NFDataIn    (NFDataIn    ),
   .NFDataOut   (NFDataOut   ),
   .NFDataOutEn (NFDataOutEn ),
   .CLE         (CLE         ),
   .ALE         (ALE         ),
   .nNFCE0      (nNFCE0      ),
   .nNFCE1      (nNFCE1      ),
   .nNFRE       (nNFRE       ),
   .nNFWE       (nNFWE       ),
   .RnB0        (RnB0        ),
   .RnB1        (RnB1        ));

// For Ecc simulation
//`define ECCERRTEST

`ifdef ECCERRTEST
    wire EccErr=1;
`else
    wire EccErr=0;
`endif

`define ECC512
wire Ecc512En = 1'b1; //enabel = 1'b1
wire Correctable=1;
wire[2:0] ErrBitNum=0;
reg[15:0] NandData;
reg[9:0]  BytePos=0;

    always @(EccErr or Correctable or ErrBitNum or NFIO or AddrCnt)
    begin
        if(EccErr) begin
            if(Correctable) begin
`ifdef ECC512                
                if(AddrCnt==(0+BytePos) || AddrCnt==(512+BytePos) || AddrCnt==(1024+BytePos) || AddrCnt==(1056+BytePos)) begin
`else //256ECC
                if(AddrCnt==(0+BytePos)    || AddrCnt==(256+BytePos)  || AddrCnt==(512+BytePos)  || AddrCnt==(768+BytePos) ||
                   AddrCnt==(1024+BytePos) || AddrCnt==(1280+BytePos) || AddrCnt==(1536+BytePos) || AddrCnt==(1792+BytePos)) begin
`endif
                    case(ErrBitNum)
                        3'b000  : NandData<={NFIO[15:1],~NFIO[0]}; 
                        3'b001  : NandData<={NFIO[15:2],~NFIO[1],NFIO[0]}; 
                        3'b010  : NandData<={NFIO[15:3],~NFIO[2],NFIO[1:0]}; 
                        3'b011  : NandData<={NFIO[15:4],~NFIO[3],NFIO[2:0]}; 
                        3'b100  : NandData<={NFIO[15:5],~NFIO[4],NFIO[3:0]}; 
                        3'b101  : NandData<={NFIO[15:6],~NFIO[5],NFIO[4:0]}; 
                        3'b110  : NandData<={NFIO[15:7],~NFIO[6],NFIO[5:0]}; 
                        default : NandData<={NFIO[15:8],~NFIO[7],NFIO[6:0]}; 
                    endcase
                end
                else NandData<=NFIO;
            end
            else begin
`ifdef ECC512                
                if(AddrCnt==(0+BytePos) || AddrCnt==(512+BytePos) || AddrCnt==(1024+BytePos) || AddrCnt==(1056+BytePos)) begin
`else //256ECC
                if(AddrCnt==(0+BytePos)    || AddrCnt==(256+BytePos)  || AddrCnt==(512+BytePos)  || AddrCnt==(768+BytePos) ||
                   AddrCnt==(1024+BytePos) || AddrCnt==(1280+BytePos) || AddrCnt==(1536+BytePos) || AddrCnt==(1792+BytePos)) begin
`endif
                    case(ErrBitNum)
                        3'b000  : NandData<={NFIO[15:1],NFIO[7:2],~NFIO[1:0]}; 
                        3'b001  : NandData<={NFIO[15:2],NFIO[7:3],~NFIO[2:1],NFIO[0]}; 
                        3'b010  : NandData<={NFIO[15:3],NFIO[7:4],~NFIO[3:2],NFIO[1:0]}; 
                        3'b011  : NandData<={NFIO[15:4],NFIO[7:5],~NFIO[4:3],NFIO[2:0]}; 
                        3'b100  : NandData<={NFIO[15:5],NFIO[7:6],~NFIO[5:4],NFIO[3:0]}; 
                        3'b101  : NandData<={NFIO[15:6],NFIO[7],~NFIO[6:5],NFIO[4:0]}; 
                        3'b110  : NandData<={NFIO[15:7],~NFIO[7:6],NFIO[5:0]}; 
                        default : NandData<={NFIO[15:8],NFIO[7:6],~NFIO[5],NFIO[4:2],~NFIO[1],NFIO[0]}; 
                    endcase
                end
                else NandData<=NFIO;
            end
        end
        else NandData<=NFIO;
    end

assign      NFIO = (NFDataOutEn==1'b0) ? NFDataOut : 16'hzz;
assign      NFDataIn = NandData;
//assign      NFDataIn = NFIO;

integer write_file[10],read_file[20];
integer wnum,rnum,i;

initial begin
    write_file[0] = $fopen("./rwdata/write0.dat");
    write_file[1] = $fopen("./rwdata/write1.dat");
    write_file[2] = $fopen("./rwdata/write2.dat");
    write_file[3] = $fopen("./rwdata/write3.dat");
    write_file[4] = $fopen("./rwdata/write4.dat");
    write_file[5] = $fopen("./rwdata/write5.dat");
    write_file[6] = $fopen("./rwdata/write6.dat");
    write_file[7] = $fopen("./rwdata/write7.dat");
    write_file[8] = $fopen("./rwdata/write8.dat");
    write_file[9] = $fopen("./rwdata/write9.dat");
    read_file[0]  = $fopen("./rwdata/boot0.dat");
    read_file[1]  = $fopen("./rwdata/boot1.dat");
    read_file[2]  = $fopen("./rwdata/boot2.dat");
    read_file[3]  = $fopen("./rwdata/boot3.dat");
    read_file[4]  = $fopen("./rwdata/boot4.dat");
    read_file[5]  = $fopen("./rwdata/boot5.dat");
    read_file[6]  = $fopen("./rwdata/boot6.dat");
    read_file[7]  = $fopen("./rwdata/boot7.dat");
    read_file[8]  = $fopen("./rwdata/boot8.dat");
    read_file[9]  = $fopen("./rwdata/boot9.dat");
    read_file[10] = $fopen("./rwdata/boot10.dat");
    read_file[11] = $fopen("./rwdata/boot11.dat");
    read_file[12] = $fopen("./rwdata/boot12.dat");
    read_file[13] = $fopen("./rwdata/boot13.dat");
    read_file[14] = $fopen("./rwdata/boot14.dat");
    read_file[15] = $fopen("./rwdata/boot15.dat");
    read_file[16] = $fopen("./rwdata/read0.dat");
    read_file[17] = $fopen("./rwdata/read1.dat");
    read_file[18] = $fopen("./rwdata/read2.dat");
    read_file[19] = $fopen("./rwdata/read3.dat");
end

//always #3.5 PCLK<=~PCLK;
always #10 PCLK<=~PCLK; //50Mhz

task reg_write;
input[ 4:0]	addr;
input[31:0]	data;
begin
	@(posedge PCLK) PSEL    <=1'b1;
	PWRITE  <=1'b1;
	PADDR   <=addr;
	PWDATA  <=data;
	PENABLE <=1'b0;
	@(posedge PCLK) PENABLE <=1'b1;  
	@(posedge PCLK) PSEL    <=0;
	PWRITE  <=1'b0;
	PENABLE <=1'b0;
	@(posedge PCLK);					
end
endtask


task reg_read;
input[ 4:0]	addr;
output[31:0] rdata;
begin
	@(posedge PCLK) PSEL    <=1'b1;
	PWRITE  <=1'b0;
	PADDR   <=addr;
	PENABLE <=1'b0;
	@(posedge PCLK) PENABLE<=1'b1; 
    @(posedge PCLK) PSEL<=0;
    rdata<=PRDATA;
	PWRITE  <=1'b0;
	PENABLE <=1'b0;
	@(posedge PCLK);				
end

endtask

wire[4:0]   fifo_level = FIFOLEVEL+1;
task write_data;
    input[11:0]  data_size;
    input[ 1:0]  trans_size;
    integer i,j;
    integer size;
    integer remain;
    reg[7:0] div; 

    reg[7:0] byte1;
    reg[7:0] byte2;
    reg[7:0] byte3;
    reg[7:0] byte4;
    reg[31:0] status;
    begin
        byte1=4;
        byte2=5;
        byte3=6;
        byte4=7;
/*
        if(trans_size==byte) div=8;
        else if(trans_size==halfword) div=16;
        else if(trans_size==word) div=32;
*/        
        size=(data_size/fifo_level);
        remain=data_size%fifo_level;
        //fifo ready check
        reg_read (4'd4,status);
        while(!status[5]) reg_read(4'd4,status);
        //reg_write(4'd4,32'hffff);
        
        //fifo Ready => Data write to NFDATA register       
        for(i=0;i<size;i=i+1) begin
            for(j=0;j<fifo_level;j=j+1) begin
                byte1<=byte1+j;
                byte2<=byte2+j;
                byte3<=byte3+j;
                byte4<=byte4+j;
                
                if(trans_size==byte) begin 
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    reg_write(4'd01,{8'd0,8'd0,8'd0,byte1});
                end
                else if(trans_size==halfword) begin
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    $fwrite(write_file[wnum],"%h\n",byte2);
                    reg_write(4'd01,{8'd0,8'd0,byte2,byte1});
                end
                else if(trans_size==word) begin
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    $fwrite(write_file[wnum],"%h\n",byte2);
                    $fwrite(write_file[wnum],"%h\n",byte3);
                    $fwrite(write_file[wnum],"%h\n",byte4);
                    reg_write(4'd01,{byte4,byte3,byte2,byte1});
                end
            end
            reg_read(4'd4,status);
            while(!status[5]) begin
                reg_read(4'd4,status);
            end
        end

        reg_read (4'd4,status);
        while(!status[5]) reg_read(4'd4,status);
        
        if(remain!=0) begin
            for(j=0;j<remain;j=j+1) begin
                byte1<=byte1+j;
                byte2<=byte2+j;
                byte3<=byte3+j;
                byte4<=byte4+j;
                
                if(trans_size==byte) begin 
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    reg_write(4'd01,{8'd0,8'd0,8'd0,byte1});
                end
                else if(trans_size==halfword) begin
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    $fwrite(write_file[wnum],"%h\n",byte2);
                    reg_write(4'd01,{8'd0,8'd0,byte2,byte1});
                end
                else if(trans_size==word) begin
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    $fwrite(write_file[wnum],"%h\n",byte2);
                    $fwrite(write_file[wnum],"%h\n",byte3);
                    $fwrite(write_file[wnum],"%h\n",byte4);
                    reg_write(4'd01,{byte4,byte3,byte2,byte1});
                end
            end
/*
            reg_read(4'd4,status);
            while(!status[5]) begin
                reg_read(4'd4,status);
            end
*/            
        end
        if(trans_size==word && PageSize==528) begin
            for(j=0;j<4;j=j+1) begin
                byte1<=byte1+j;
                byte2<=byte2+j;
                byte3<=byte3+j;
                byte4<=byte4+j;
                    $fwrite(write_file[wnum],"%h\n",byte1);
                    $fwrite(write_file[wnum],"%h\n",byte2);
                    $fwrite(write_file[wnum],"%h\n",byte3);
                    $fwrite(write_file[wnum],"%h\n",byte4);
                    reg_write(4'd01,{byte4,byte3,byte2,byte1});
            end
        end
    end
endtask

task RnB_Wait;
    input       chipsel;
    reg[31:0] status;
    begin

        reg_read(4'd4,status);
        if(chipsel==0) begin //chip 0
            while(status[0]) reg_read(4'd4,status);
            while(!status[0]) reg_read(4'd4,status);
        end
        else begin
            while(status[1]) reg_read(4'd4,status);
            while(!status[1]) reg_read(4'd4,status);
        end
        //$display($time,"    task RnB Wait[%b]\n",status[0]);
    end
endtask

task Data_Read;
    input[11:0] data_size;
    input[ 1:0] trans_size;
    reg  [31:0] status;
    reg  [31:0] read_data;
    reg  [ 7:0] byte1;
    reg  [ 7:0] byte2;
    reg  [ 7:0] byte3;
    reg  [ 7:0] byte4;
    integer size;
    integer remain;
    integer i,j;
    begin
        byte1=0;
        byte2=1;
        byte3=2;
        byte4=3;
    
        size=(data_size/fifo_level);        
        remain=data_size%fifo_level;
        for(i=0;i<size;i=i+1) begin
            reg_read(4'd4,status);
            while(!status[4]) reg_read(4'd4,status);
            reg_write(4'd4,32'hffff);

            for(j=0;j<fifo_level;j=j+1) begin
                reg_read(4'd1,read_data);
                if(trans_size==2'b00) begin
                    $fwrite(read_file[rnum],"%h\n",read_data[7:0]);
                end
                else if(trans_size==2'b01) begin
                    $fwrite(read_file[rnum],"%h\n",read_data[7:0]);
                    $fwrite(read_file[rnum],"%h\n",read_data[15:8]);
                end
                else if(trans_size==2'b10) begin
                    $fwrite(read_file[rnum],"%h\n",read_data[7:0]);
                    $fwrite(read_file[rnum],"%h\n",read_data[15:8]);
                    $fwrite(read_file[rnum],"%h\n",read_data[23:16]);
                    $fwrite(read_file[rnum],"%h\n",read_data[31:24]);
                end
            end
        end
        if(remain!=0) begin
            for(j=0;j<remain;j=j+1) begin
                reg_read(4'd1,read_data);
                if(trans_size==2'b00) begin
                    $fwrite(read_file[rnum],"%h\n",read_data[7:0]);
                end
                else if(trans_size==2'b01) begin
                    $fwrite(read_file[rnum],"%h\n",read_data[7:0]);
                    $fwrite(read_file[rnum],"%h\n",read_data[15:8]);
                end
                else if(trans_size==2'b10) begin
                    $fwrite(read_file[rnum],"%h\n",read_data[7:0]);
                    $fwrite(read_file[rnum],"%h\n",read_data[15:8]);
                    $fwrite(read_file[rnum],"%h\n",read_data[23:16]);
                    $fwrite(read_file[rnum],"%h\n",read_data[31:24]);
                end
            end
        end

        if(trans_size==word && PageSize==528) begin
            reg_read(4'd4,status);
            while(!status[4]) reg_read(4'd4,status);
            reg_write(4'd4,32'hffff);
            for(j=0;j<4;j=j+1) begin
                reg_read(4'd1,read_data);
                    $fwrite(read_file[rnum],"%h\n",read_data[7:0]);
                    $fwrite(read_file[rnum],"%h\n",read_data[15:8]);
                    $fwrite(read_file[rnum],"%h\n",read_data[23:16]);
                    $fwrite(read_file[rnum],"%h\n",read_data[31:24]);
                    byte1<=byte1+j;
                    byte2<=byte2+j;
                    byte3<=byte3+j;
                    byte4<=byte4+j;
`ifdef debug                    
                    if(read_data[31:0]!={byte4,byte3,byte2,byte1}) begin
                        $display($time,"i[%d] j[%d]:: write data[%h] :: read data[%h]",i,j,{byte4,byte3,byte2,byte1},read_data);
                        $display($time,":: Read DATA ERROR");
                        $stop;
                    end
`endif                    
            end
        end
    end
endtask

task Read_ID;
    input[ 1:0]  trans_size;
    input[ 1:0]  IDByte;
    reg  [31:0]  status;
    reg  [31:0]  ID;
    integer i,j,size;
begin

        $display("**************************",);
        $display("  ID READ START");
        $display("**************************",);
    if(IOWidthPinIn==0) begin
        if(trans_size!=2'b00) begin
            $display(" 16bit IO ID READ :: size half word!!");
            $stop;
        end
        if(IDByte==2'b00)      size<=2;
        else if(IDByte==2'b01) size<=3;
        else if(IDByte==2'b10) size<=4;
        else if(IDByte==2'b11) size<=5;
        

        reg_read(4'd4,status);
        while(!status[4])    reg_read(4'd4,status); // RdFIFOReady Check
        reg_write(4'd4,32'hffff);

        for(i=0;i<size;i=i+1) begin
            reg_read(4'd1,ID);
            $display("  ID Byte[%h]",ID[7:0]);
        end
    end
    else begin
        if(trans_size!=2'b01) begin
            $display(" 16bit IO ID READ :: size half word!!");
            $stop;
        end
        if(trans_size==2'b01) begin //halfword
            if(IDByte==2'b00)      size<=2;
            else if(IDByte==2'b01) size<=3;
            else if(IDByte==2'b10) size<=4;
            else if(IDByte==2'b11) size<=5;
        end

        reg_read(4'd4,status);
        while(!status[4])    reg_read(4'd4,status);
        reg_write(4'd4,32'hffff);

        for(i=0;i<size;i=i+1) begin
            reg_read(4'd1,ID);
                $display("  ID Byte[%h]",ID[15:0]);
        end
    end
        $display("**************************");
        $display("  ID READ End");
        $display("**************************");
end
endtask

// 8KByte Boot data read

reg[31:0]   data;
reg         ReadEn;
reg[3:0]    cnt;
reg[8:0]    cnt1;
reg         BootEnd;
wire[11:0]  value;

always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        BootEnd<=0;
        cnt<=0;
        cnt1<=0;
        ReadEn<=0;
    end
    else begin
        if(NFDMAReqOut==1'b1 && NFBootPinIn==1'b1) ReadEn<=1'b1;

        if(ReadEn && cnt!=8) begin
            cnt<=cnt+1;
            reg_read(4'd1,data);
        end
        else if(cnt==8) begin
            ReadEn<=1'b0;
            cnt<=0;
            cnt1<=cnt1+1;
        end

        if(cnt1==256) begin
            ReadEn<=0;
            BootEnd<=1'b1;
        end
        else BootEnd<=1'b0;
    end
end

// first NFOPER
// NFOPER[21]/NFOPER[20]/NFOPER[19]/NFOPER[18:16]/NFOPER[15:13]/NFOPER[12:11]/NFOPER[10:8]/NFOPER[7:0] 
// CE        /RnbWait   /AutoRdStat/FIFOLevel    /OpMode       /TransferSize /TransferByte/CmdAddrFlag
// 0         /0         /0         /111          /000(RdData)  /10(WORD size)/            /

// second NFOPER
// DATASIZE[11:0]
// page read cmd test)
//
// OPMode 
// 000: read data  001: read status
// 010: read ID    011: write data
// 100: cell write Others: NOP
reg[31:0]  rddata;
reg[ 7:0]  wmem[4224:0];
reg[ 7:0]  rmem[4224:0];
reg[ 3:0] TransferByte;
integer num;
initial
begin
    PCLK        =1'b0;
    PRESETn     =1'b0;
    PADDR       =0;
    PSEL        =0;
    PENABLE     =0;
    PWDATA      =0;
    PWRITE      =0;
`ifdef BOOT
    NFBootPinIn=1'b1 ;  //NFBootEnable;  
`else
    NFBootPinIn=1'b0;   //NFBootDisable;
`endif


`ifdef x8
    IOWidthPinIn=1'b0 ;   
    NandWidthPinIn=1'b0 ;   
`endif
`ifdef mcp  // used 2 chip_enable pin
    IOWidthPinIn=1'b0 ;   
    NandWidthPinIn=1'b0 ;   
`endif
`ifdef dual
    IOWidthPinIn=1'b1 ;
    NandWidthPinIn=1'b0 ;   
`endif
`ifdef x16
    IOWidthPinIn=1'b1 ;
    NandWidthPinIn=1'b1 ;   
`endif

`ifdef Page512
    PageSize=12'd528;
    BootCfgPinIn=2'b01;   //512page addr_4cycle
    TransferByte=4'd4;
`else
    PageSize=12'd2112;
    BootCfgPinIn=2'b11;   
    TransferByte=4'd7;
`endif

    OutDtmnPinIn=1'b1 ;       
    #100 PRESETn=1'b1;

rddata<=0;
wait(PRESETn);

// NANDBoot test
`ifdef BOOT
    wait(BootEnd);
    $display("\n///// 8Kbyte Boot End /////\n");
`endif

$display("\n/////  NAND FLASH READ ID /////\n");
    //                   /NFCtrlRst/FIFOLevel/    /Ecc512En/AutoEccWr/DMAEn/WrEndIntEn/RdEndIntEn/EccErrIntEn/FIFOIntEn/RnBIntEn1/RnBIntEn0/
    reg_write(4'd3,{18'd0,1'b0     ,3'b111   ,1'b0,1'b1   ,1'b1     ,1'b0 ,1'b0      ,1'b0      ,1'b0       ,1'b0     ,1'b0     ,1'b0});//NFCTRL
   

`ifdef dual
    // READ ID
                    //CE/Option   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    reg_write(4'd0,{1'd0,NoOption ,12'h005 ,3'b010,halfword    ,4'b0010     ,8'b10001001});
    reg_write(4'd0,{8'h90,8'h00,8'h00,8'h90});
    Read_ID(halfword,cycle5);
`else
    // READ ID
                    //CE/Option   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    reg_write(4'd0,{1'd0,NoOption ,12'h005 ,3'b010,byte        ,4'b0010     ,8'b10001001});
    reg_write(4'd0,{8'h90,8'h00,8'h00,8'h90});
    Read_ID(byte,cycle5);
`endif

    //********* reg setting *************

reg_write(4'd2,{19'd0,4'b1111,3'b001,3'b001,3'b001});//NFCONF
//reg_write(4'd2,{19'd0,4'b1111,3'b000,3'b000,3'b000});//NFCONF
//                   /NFCtrlRst/FIFOLevel/    /Ecc512En/AutoEccWr/DMAEn/WrEndIntEn/RdEndIntEn/reserved/FIFOIntEn/RnBIntEn1/RnBIntEn0/
reg_write(4'd3,{18'd0,1'b0     ,FIFOLEVEL,1'b0,Ecc512En,1'b1     ,1'b1 ,1'b0      ,1'b0      ,1'b0    ,1'b1     ,1'b0     ,1'b0});//NFCTRL
    
reg_read (4'd2,rddata);
reg_read (4'd3,rddata);


$display("\n/////  NAND FLASH RESET /////\n");

    // nand flash reset
                    //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    reg_write(4'd0,{1'd0,AutoRdStat,12'h800 ,3'b111,2'b10       ,4'b0010     ,8'b00000011});
    reg_write(4'd0,{8'haa,8'hbb,8'h70,8'hff});

    //RnB wait
    //RnB_Wait;


$display("\n/////  NAND FLASH BLOCK ERASE /////\n");

    // Block Erase
                    //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    reg_write(4'd0,{1'd0,AutoRdStat,12'h800 ,3'b111,2'b10       ,4'b0110     ,8'b10010001});
//    reg_write(4'd0,{8'h60,8'h00,8'h00,8'h00});
//    reg_write(4'd0,{8'hd0,8'h70,8'h10,8'h70});    
    reg_write(4'd0,{8'h00,8'h00,8'h00,8'h60});
    reg_write(4'd0,{8'hd0,8'h70,8'h70,8'hd0});    

`ifndef Page512 // 2048 page!!!!!!!!!!!!!
    $display("\n/////  NAND FLASH BLOCK ERASE /////\n");

        // Block Erase
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
    //    reg_write(4'd0,{1'd0,NoOption,12'h800 ,3'b101,2'b10       ,4'b0100     ,8'b10010001});
        reg_write(4'd0,{1'd0,Continue,12'h800 ,3'b111,2'b10       ,4'b0100     ,8'b10010001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h60});
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,12'h800 ,3'b111,2'b10       ,4'b0110     ,8'b10010001});
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h60});
        reg_write(4'd0,{8'hd0,8'h70,8'h70,8'hd0});    

        // wait for command Queue empty
        reg_read (4'd5,rddata);
        while(rddata[11:8]!=0) reg_read (4'd5,rddata);
        $display("\n/////  CMD Q Empty /////\n");
        repeat(2000) @(posedge PCLK); 
    $display("\n/////  NAND FLASH copy back /////\n");
                        //CE/Option /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,RnBWait,12'h800 ,3'b101,2'b10       ,4'b0111     ,8'b01000001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h35,8'h00,8'h00});    
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,12'h800 ,3'b111,2'b10       ,4'b1000     ,8'b01000001});
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h85});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});    

        // wait for command Queue empty
        reg_read (4'd5,rddata);
        while(rddata[11:8]!=0) reg_read (4'd5,rddata);
        $display("\n/////  CMD Q Empty /////\n");
        repeat(2000) @(posedge PCLK); 

        reg_write(4'd0,{1'd0,NoOption,12'h800 ,3'b101,2'b10       ,4'b0001     ,8'b01000001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h31});
`endif
    /*******************************************************/
    //                  Nand Read Write                     /
    /*******************************************************/

`ifdef Page512
        $display("*************Page Write*************\n");
        // --------------Byte Size Write-------------------
                        //CE/Option   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption ,PageSize,3'b011,byte       ,4'b0111     ,8'b11000011});// word 
//        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h00,8'h00,8'h80,8'h00});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
        
        wnum=0;
        write_data(PageSize,byte);
        $display("           Byte Size Write data End");
        RnB_Wait(0);

        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,PageSize,3'b011,halfword   ,4'b0111     ,8'b11100001});// word 
        reg_write(4'd0,{8'h00,8'h01,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h70,8'h10,8'h00});   

        wnum=1;
        write_data(PageSize/2,halfword);
        $display("           HalfWord Size Write data End");
        RnB_Wait(0);

        // --------------Word Size Write-------------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,PageSize,3'b011,word       ,4'b0111     ,8'b11100001});// word 
        reg_write(4'd0,{8'h00,8'h02,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h70,8'h10,8'h00});   
            
        wnum=2;
        write_data(PageSize/4,word);
        $display("           Word Size Write data End");
        RnB_Wait(0);




        repeat(100) @(posedge PCLK); 

        $display("*************Page Read*************\n");
        // page_read
        // --------------Byte Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,PageSize,3'b000,byte       ,4'b0101     ,8'b11000001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=16;
        RnB_Wait(0);
        Data_Read(PageSize,byte);
        $display("           Byte Size Read End");

        // --------------HalfWord Size Read---------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,PageSize,3'b000,halfword   ,4'b0101     ,8'b11000001});
        reg_write(4'd0,{8'h00,8'h01,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=17;
        RnB_Wait(0);
        Data_Read(PageSize/2,halfword);
        $display("           HalfWord Size Read End");

        // page_read
        // --------------Word Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,PageSize,3'b000,word      ,4'b0101     ,8'b11000001});
        reg_write(4'd0,{8'h00,8'h02,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=18;
        RnB_Wait(0);
        Data_Read(PageSize/4,word);
        $display("           Word Size Read End\n");
        $display("*********8Bit IO Read Write Test End*********\n");

`else //page 2048
    /*******************************************************/
    //              8bit IO Nand Read Write                 /
    /*******************************************************/

    `ifdef x8
        
        $display("*************************************");
        $display(" 8bit IO BUS READ WRITE TEST !!!!");
        $display("*************************************");

        $display("*************Page Write*************\n");
        // --------------Byte Size Write-------------------
                        //CE/Option   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
//        reg_write(4'd0,{1'd0,NoOption ,PageSize,3'b011,byte       ,4'b0111     ,8'b11000001});// word 
        reg_write(4'd0,{1'd0,NoOption ,12'd2111,3'b011,byte       ,4'b0111     ,8'b11000001});// word 
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
       
        wnum=0;
        //write_data(PageSize,byte);
        write_data(2111,byte);
        $display("           Byte Size Write data End");
        RnB_Wait(0);

        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,PageSize,3'b011,halfword   ,4'b1000     ,8'b11000001});// word 
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   

        wnum=1;
        write_data(PageSize/2,halfword);
        $display("           HalfWord Size Write data End");
        RnB_Wait(0);

        // --------------Word Size Write-------------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,PageSize,3'b011,word       ,4'b1000     ,8'b11000001});// word 
        reg_write(4'd0,{8'h02,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
            
        wnum=2;
        write_data(PageSize/4,word);
        $display("           Word Size Write data End");
        RnB_Wait(0);





        $display("*************Page Read*************\n");
        // page_read
        // --------------Byte Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
//        reg_write(4'd0,{1'd0,NoOption,PageSize,3'b000,byte       ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{1'd0,NoOption,12'd2111,3'b000,byte       ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=16;
        RnB_Wait(0);
//        Data_Read(PageSize,byte);
        Data_Read(12'd2111,byte);
        $display("           Byte Size Read End");

        // --------------HalfWord Size Read---------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,PageSize,3'b000,halfword   ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=17;
        RnB_Wait(0);
        Data_Read(PageSize/2,halfword);
        $display("           HalfWord Size Read End");

        // page_read
        // --------------Word Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,PageSize,3'b000,word      ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h02,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=18;
        RnB_Wait(0);
        Data_Read(PageSize/4,word);
        $display("           Word Size Read End\n");
        $display("*********8Bit IO Read Write Test End*********\n");

    `endif

    /*******************************************************/
    //              8bit IO MCP Chip Read Write             /
    /*******************************************************/

    `ifdef mcp

        $display("*************************************");
        $display(" 8bit IO BUS READ WRITE TEST !!!!");
        $display("*************************************");

        $display("*************Page Write*************\n");
        // --------------Byte Size Write-------------------
                        //CE/Optiont   /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,12'h840 ,3'b011,byte       ,4'b1000     ,8'b11000001});// word 
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
            
        wnum=0;
        write_data(2112,byte);
        $display("           Byte Size Write data End");
        RnB_Wait(0);

        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,12'h840 ,3'b011,halfword   ,4'b1000     ,8'b11000001});// word 
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
            
        wnum=1;
        write_data(2112/2,halfword);
        $display("           HalfWord Size Write data End");
        RnB_Wait(0);

        // --------------Word Size Write-------------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,12'h840 ,3'b011,word       ,4'b1000     ,8'b11000001});// word 
        reg_write(4'd0,{8'h02,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
            
        wnum=2;
        write_data(2112/4,word);
        $display("           Word Size Write data End");
        RnB_Wait(0);





        $display("*************Page Read*************\n");
        // page_read

        // --------------Byte Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,12'h840 ,3'b000,byte       ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=16;
        RnB_Wait(0);
        Data_Read(2112,byte);
        $display("           Byte Size Read End");

        // --------------HalfWord Size Read---------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,12'h840 ,3'b000,halfword   ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=17;
        RnB_Wait(0);
        Data_Read(2112/2,halfword);
        $display("           HalfWord Size Read End");

        // --------------Word Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,12'h840 ,3'b000,word      ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h02,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=18;
        RnB_Wait(0);
        Data_Read(2112/4,word);
        $display("           Word Size Read End\n");
        $display("*********8Bit IO Read Write Test End*********\n");

    `endif

    /*******************************************************/
    //              16bit IO Nand Read Write                  /
    /*******************************************************/
    `ifdef x16
       
        $display("*************************************");
        $display(" 16bit IO BUS READ WRITE TEST !!!!");
        $display("*************************************");

        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,12'h420 ,3'b011,halfword       ,4'b1000     ,8'b11000001});// word 
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
            
        wnum=0;
        write_data(1056,halfword);
        $display($time,"           HalfWord Size Write data End");
        RnB_Wait(0);

        // --------------Word Size Write-------------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,12'h420 ,3'b011,word       ,4'b1000     ,8'b11000001});// word 
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
            
        wnum=1;
        write_data(1056/2,word);
        $display($time,"           Word Size Write data End");
        RnB_Wait(0);



        $display("*************Page Read*************\n");
        // page_read

        // --------------HalfWord Size Read---------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,12'h420 ,3'b000,halfword   ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=16;
        RnB_Wait(0);
        Data_Read(1056,halfword);
        $display($time,"           HalfWord Size Read End");

        // --------------Word Size Read-------------------
                         //CE/Option /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,12'h420 ,3'b000,word       ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=17;
        RnB_Wait(0);
        Data_Read(1056/2,word);
        $display($time,"           Word Size Read End\n");
        $display("*********16Bit IO Read Write Test End*********\n");

    `endif

    /*******************************************************/
    //        two 8bit_IO_Nand Read Write                   /
    /*******************************************************/
    `ifdef dual

        $display("*************************************");
        $display(" Two 8bit nand READ WRITE TEST !!!!");
        $display("*************************************");

        // --------------HalfWord Size Write---------------
                        //CE/Option    /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,PageSize,3'b011,halfword       ,4'b1000     ,8'b11000001});// word 
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
            
        wnum=0;
        write_data(PageSize,halfword);
        $display($time,"           HalfWord Size Write data End");
        RnB_Wait(0);

        // --------------Word Size Write-------------------
                       //CE/Option     /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,AutoRdStat,PageSize,3'b011,word       ,4'b1000     ,8'b11000001});// word 
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h80});
        reg_write(4'd0,{8'h70,8'h10,8'h00,8'h00});   
            
        wnum=1;
        write_data(PageSize/2,word);
        $display($time,"           Word Size Write data End");
        RnB_Wait(0);



        $display("*************Page Read*************\n");
        // page_read

        // --------------HalfWord Size Read---------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,PageSize,3'b000,halfword   ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h00,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=16;
        RnB_Wait(0);
        Data_Read(PageSize,halfword);
        $display($time,"           HalfWord Size Read End");

        // --------------Word Size Read-------------------
                        //CE/Option  /DataSize/OpMode/TransferSize/TransferByte/CmdAddrFlag
        reg_write(4'd0,{1'd0,NoOption,PageSize,3'b000,word       ,4'b0111     ,8'b11000001});
        reg_write(4'd0,{8'h01,8'h00,8'h00,8'h00});
        reg_write(4'd0,{8'h00,8'h30,8'h00,8'h00});

        rnum=17;
        RnB_Wait(0);
        Data_Read(PageSize/2,word);
        $display($time,"           Word Size Read End\n");
        $display("*********16Bit IO Read Write Test End*********\n");

    `endif
`endif
reg_read (5'd2,rddata);
reg_read (5'd3,rddata);
reg_read (5'd4,rddata);
reg_read (5'd5,rddata);
reg_read (5'd6,rddata);
reg_read (5'd7,rddata);
reg_read (5'd8,rddata);
reg_read (5'd9,rddata);
reg_read (5'd10,rddata);
reg_read (5'd11,rddata);
reg_read (5'd12,rddata);
reg_read (5'd13,rddata);
reg_read (5'd14,rddata);
reg_read (5'd15,rddata);
reg_read (5'd16,rddata);
reg_read (5'd17,rddata);
reg_read (5'd18,rddata);
reg_read (5'd19,rddata);
reg_read (5'd20,rddata);
reg_read (5'd21,rddata);
reg_read (5'd22,rddata);
reg_read (5'd23,rddata);
reg_read (5'd24,rddata);
reg_read (5'd25,rddata);
reg_read (5'd26,rddata);
reg_read (5'd27,rddata);
reg_read (5'd28,rddata);
reg_read (5'd29,rddata);
reg_read (5'd30,rddata);
/*******************************************************/
//              Nand Read,Write data Compare            /
/*******************************************************/
`ifdef dual
    num=4224;
`else
    num=2112;
`endif

$readmemh ("./rwdata/write0.dat", wmem);
$readmemh ("./rwdata/read0.dat", rmem);
for(i=0;i<num;i=i+1) begin
    if(wmem[i]!=rmem[i]) begin
        $display("**************************",);
        $display(" FILE 0",);
        $display("Addr %d  Write, Read Not Match",i);
        $display("**************************",);
    end
end
$readmemh ("./rwdata/write1.dat", wmem);
$readmemh ("./rwdata/read1.dat", rmem);
for(i=0;i<num;i=i+1) begin
    if(wmem[i]!=rmem[i]) begin
        $display("**************************",);
        $display(" FILE 1",);
        $display("Addr %d  Write, Read Not Match",i);
        $display("**************************",);
    end
end

$readmemh ("./rwdata/write2.dat", wmem);
$readmemh ("./rwdata/read2.dat", rmem);
for(i=0;i<num;i=i+1) begin
    if(wmem[i]!=rmem[i]) begin
        $display("**************************",);
        $display(" FILE 2",);
        $display("Addr %d  Write, Read Not Match",i);
        $display("**************************",);
    end
end

$display("OK");
$stop;

end //initial begin



endmodule











