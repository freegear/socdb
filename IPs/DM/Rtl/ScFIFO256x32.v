
module ScFIFO256x32(
    Clk,
    nRST,
    FIFOWrite,
    FIFOWrData,
    FIFORead,
    FIFORdData,
    FIFOFlush,
    FIFOFull,
    FIFOHalfFull,
    FIFOAlmostEmpty,
    FIFOEmpty,
    FIFOEmptyWr
) ;

/*-----------------------------------------------------------------------------------------------------------
Address length parameters:
FIFO_DEPTH = defines FIFO depth
FIFO_AW = defines FIFO's location address length - log2(DEPTH)
-----------------------------------------------------------------------------------------------------------*/
parameter FIFO_AW = 6 ;
parameter FIFO_ML = 4 ;
parameter FIFO_DW = 32;

input Clk;
input nRST;

/*-----------------------------------------------------------------------------------------------------------
Write enable signal:
FIFOWrite = Write enable input for FIFO - driven by camera interface

data input signals:
FIFOWrData      = data input - data from camera interface 

Read enable signal:
FIFORead = Read enable input driven by Bus interface

data output signals:
FIFORdData = data output - data to bus

status signals - monitored by various resources in the core
FIFOFlush = flush signal input for FIFO - when asserted, fifo is flushed(emptied)
fifo Fullout = Full output from FIFO
FIFOAlmostEmpty = almost Empty output from FIFO
FIFOEmpty = Empty output from FIFO (to RD side)
FIFOEmptyWr = Empty output (to WR side)
-----------------------------------------------------------------------------------------------------------*/

// input control and data
input         FIFOWrite;
input  [FIFO_DW-1:0] FIFOWrData;

// output control and data
input         FIFORead ;
output [FIFO_DW-1:0] FIFORdData ;

// flush input
input         FIFOFlush ;

// status outputs
output        FIFOFull, FIFOHalfFull ;
output        FIFOAlmostEmpty ;
output        FIFOEmpty ;
output        FIFOEmptyWr ;

/*-----------------------------------------------------------------------------------------------------------
WriteAllow - Writes to FIFO are allowed when FIFO isn't Full and Write enable is 1
ReadAllow - Reads from FIFO are allowed when FIFO isn't Empty and Read enable is 1
-----------------------------------------------------------------------------------------------------------*/
wire WriteAllow ;
wire ReadAllow ;

/*-----------------------------------------------------------------------------------------------------------
wires for address port conections from FIFO control logic to RAM blocks used for FIFO
-----------------------------------------------------------------------------------------------------------*/
wire [(FIFO_AW - 1):0] ReadAddr ;
wire [(FIFO_AW - 1):0] WriteAddr ;

/*-----------------------------------------------------------------------------------------------------------
Fifo output assignments  
-----------------------------------------------------------------------------------------------------------*/
wire nReadEnable = 1'b0 ;

`ifdef CHIP
RF2SH256x32 WQL(
	.QA		(FIFORdData),
	.AA		(ReadAddr),
	.CLKA	(Clk),
	.CENA	(nReadEnable),
	.AB		(WriteAddr),
	.DB		(FIFOWrData),
	.CLKB	(Clk),
	.CENB	(~WriteAllow)
);
`else
reg [FIFO_DW-1:0] FIFO[0:{FIFO_AW{1'b1}}];
integer i;

always @(posedge Clk)
    if (WriteAllow) FIFO[WriteAddr] <= FIFOWrData;
    else            FIFO[WriteAddr] <= FIFO[WriteAddr];

//assign RdData = FIFO[RdCnt];

reg [FIFO_DW-1:0] FIFORdData;
always @(posedge Clk) FIFORdData <= FIFO[ReadAddr];
`endif

/*-----------------------------------------------------------------------------------------------------------
Instantiation of control logic module 
-----------------------------------------------------------------------------------------------------------*/
ScFIFOCtl256x32 #(FIFO_AW, FIFO_ML) FIFOCtl
(
    .Clki			(Clk),
    .ReadEni		(FIFORead),
    .WriteEni		(FIFOWrite),
    .nRST			(nRST),
    .Flushi			(FIFOFlush),
    .FIFOHalfFull	(FIFOHalfFull),
    .Fullo			(FIFOFull),
    .AlmostEmptyo	(FIFOAlmostEmpty),
    .Emptyo			(FIFOEmpty),
    .EmptyWrSideo	(FIFOEmptyWr),
    .WriteAddro		(WriteAddr),
    .ReadAddro		(ReadAddr),
    .ReadAllowo		(ReadAllow),
    .WriteAllowo	(WriteAllow)
);


endmodule


module ScFIFOCtl256x32(
    Clki,
    ReadEni,
    WriteEni,
    nRST,
    Flushi,
    Fullo,
    FIFOHalfFull,
    AlmostEmptyo,
    Emptyo,
    EmptyWrSideo,
    WriteAddro,
    ReadAddro,
    ReadAllowo,
    WriteAllowo
);


parameter AW = 5 ;// address length parameter - depends on fifo depth
parameter ML = 4; // MaxLatency

input  Clki;

input  ReadEni;
input  WriteEni;

input  nRST;
input  Flushi ;

output AlmostEmptyo;
output FIFOHalfFull;
output Fullo;
output Emptyo;
output EmptyWrSideo;

// Read and Write addresses outputs
output [(AW - 1):0] WriteAddro;
output [(AW - 1):0] ReadAddro;

// Read and Write allow outputs
output ReadAllowo;
output WriteAllowo ;

// Read address register
reg [(AW - 1):0] RdAddr ;

// Write address register
reg [(AW - 1):0] WrAddr;
assign WriteAddro = WrAddr ;

// grey code registers
// grey code pipeline for Write address
reg [(AW - 1):0] WrGreyAddr ; // current grey coded Write address
reg [(AW - 1):0] WrGreyNext ; // next grey coded Write address

// next Write gray address calculation - bitwise xor between address and shifted address
wire [(AW - 2):0] CalcWrGreyNext  = WrAddr[(AW - 1):1] ^ WrAddr[(AW - 2):0] ;

// grey code pipeline for Read address
reg [(AW - 1):0] RdGreyAddr ; // current
reg [(AW - 1):0] RdGreyNext ; // next

// next Read gray address calculation - bitwise xor between address and shifted address
wire [(AW - 2):0] CalcRdGreyNext  = RdAddr[(AW - 1):1] ^ RdAddr[(AW - 2):0] ;

// FFs for registered Empty and Full flags
wire Empty ;
wire EmptyWrSide ;
wire Full ;

// AlmostEmpty tag
wire AlmostEmpty ;

// Write allow wire - Writes are allowed when fifo is not Full
wire WrAllow = WriteEni && !Full ;

// Write allow output assignment
assign WriteAllowo = WrAllow ;

// Read allow wire
wire RdAllow ;

// Full output assignment
assign Fullo  = Full ;

assign Emptyo       = Empty ;
assign EmptyWrSideo = EmptyWrSide ;

//RdAllow generation
assign RdAllow = ReadEni && !Empty ; // Reads allowed if Read enable is high and FIFO is not Empty

// RdAllow output assignment
assign ReadAllowo = RdAllow ;

// almost Empty output assignment
assign AlmostEmptyo = AlmostEmpty ;

// at any clock edge that RdAllow is high, this register provides next Read address, so wait cycles are not necessary
// when FIFO is Empty, this register provides actual Read address, so first location can be Read
reg [(AW - 1):0] RdAddrPlusOne ;

// address output mux - when FIFO is not Read, current actual address is driven out, when it is Read, next address is driven out to provide
// next data immediately
// done for zero wait state burst operation
assign ReadAddro = RdAllow ? RdAddrPlusOne : RdAddr ;

always @(negedge nRST or posedge Clki)
begin
    if (!nRST)
    begin
        // initial values seem a bit odd - they are this way to allow easier grey pipeline implementation and to allow min fifo size of 8
        RdAddrPlusOne <=  3 ;
        RdAddr        <=  2 ;
    end
    else if (Flushi)
    begin
        RdAddrPlusOne <=  WrAddr + 1'b1 ;
        RdAddr        <=  WrAddr ;
    end
    else if (RdAllow)
    begin
        RdAddrPlusOne <=  RdAddrPlusOne + 1'b1 ;
        RdAddr        <=  RdAddrPlusOne ;
    end
end

/*-----------------------------------------------------------------------------------------------
Read address control consists of Read address counter and Grey Address pipeline
There are 2 Grey addresses:
    - RdGreyAddr is Grey Code of current Read address
    - RdGreyNext is Grey Code of next Read address
--------------------------------------------------------------------------------------------------*/
// grey coded address pipeline for status generation in Read clock domain
always @(negedge nRST or posedge Clki)
begin
    if (!nRST)
    begin
        RdGreyAddr   <=  0 ;
        RdGreyNext   <=  1 ; // this grey code is calculated from the current binary address and loaded any time data is Read from fifo
    end
    else if (Flushi)
    begin
        // when fifo is flushed, load the register values from the Write clock domain.
        // must be no problem, because Write pointers are stable for at least 3 clock cycles before flush can occur.
        RdGreyAddr   <=  WrGreyAddr ;
        RdGreyNext   <=  WrGreyNext ;
    end
    else if (RdAllow)
    begin
        // move the pipeline when data is Read from fifo and calculate new value for first stage of pipeline from current binary fifo address
        RdGreyAddr   <=  RdGreyNext ;
        RdGreyNext   <=  {RdAddr[AW - 1], CalcRdGreyNext} ;
    end
end

/*--------------------------------------------------------------------------------------------
Write address control consists of Write address counter and 2 Grey Code Registers:
    - WrGreyAddr represents current Grey Coded Write address
    - WrGreyNext represents Grey Coded next Write address
----------------------------------------------------------------------------------------------*/
// grey coded address pipeline for status generation in Write clock domain
always @(negedge nRST or posedge Clki)
begin
    if (!nRST)
    begin
        WrGreyAddr   <=  0 ;
        WrGreyNext   <=  1 ;
    end
    else
    if (WrAllow)
    begin
        WrGreyAddr   <=  WrGreyNext ;
        WrGreyNext   <=  {WrAddr[(AW - 1)], CalcWrGreyNext} ;
    end
end

// Write address binary counter - nothing special except initial value
always @(negedge nRST or posedge Clki)
begin
    if (!nRST)
        // initial value 2
        WrAddr <=  2 ;
    else
    if (WrAllow)
        WrAddr <=  WrAddr + 1'b1 ;
end

/*------------------------------------------------------------------------------------------------------------------------------
Full control:
Gray coded Read address pointer is synchronized to Write clock domain and compared to Gray coded next Write address.
If they are equal, fifo is Full.
--------------------------------------------------------------------------------------------------------------------------------*/

assign Full        = (WrGreyNext == RdGreyAddr) ;
assign EmptyWrSide = (WrGreyAddr == RdGreyAddr) ;

/*------------------------------------------------------------------------------------------------------------------------------
Empty control:
Gray coded Write address pointer is synchronized to Read clock domain and compared to Gray coded Read address pointer.
If they are equal, fifo is Empty. Synchronized Write pointer is also compared to Gray coded next Read address. If these two are
equal, fifo is almost Empty.
--------------------------------------------------------------------------------------------------------------------------------*/

assign AlmostEmpty = (RdGreyNext == WrGreyAddr) ; 
assign Empty       = (RdGreyAddr == WrGreyAddr) ;

// HALF Full

reg [AW-1:0] DatCnt;

always @(negedge nRST or posedge Clki) 
  if (!nRST)    DatCnt <= 0;
  else if (Flushi)
  				DatCnt <= 0;
  else begin
    case ({RdAllow, WrAllow}) // synopsys parallel_case
      2'b10   : DatCnt <= DatCnt - 1;
      2'b01   : DatCnt <= DatCnt + 1;
      default : DatCnt <= DatCnt;
    endcase
  end

//assign FIFOHalfFull = DatCnt[AW-3];
assign FIFOHalfFull = DatCnt>=({AW{1'b1}}-ML);

endmodule