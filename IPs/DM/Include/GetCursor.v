parameter CGetImageSize = CursorX*CursorY;
integer 	CGetImageAddr;
//------------------------------------------------------------------------
/*
// to get 32bit Cursor Data from 15bit RGB555
reg  [15:0] CGetData [0:CImageSize-1];

initial begin
   $readmemh ("./Image/rgb565.txt", CGetData);
end

reg [31:0] CursorReadData;

always @(CGetImageAddr)
   	if (!CGetImageAddr[0])	CursorReadData[15:0]  <= CGetData[CImageAddr];
   	else 	 				CursorReadData[31:16] <= CGetData[CImageAddr];

integer CursorRead;
initial begin
  CursorRead = $fopen("./Image/Graphic32.txt");
  forever @(posedge Clk) begin
    if (IncCImageAddr & WREADY & WVALID & CGetImageAddr[0]) begin
    	$fdisplay(CursorRead, "%h",CursorReadData);
    end
  end
end
*/
//------------------------------------------------------------------------
reg  [7:0] CGetData [0:CGetImageSize-1];

initial begin
   $readmemh ("./Image/rgb332.txt", CGetData);
end

reg [31:0] CursorReadData;

always @(CGetImageAddr)
	case(CGetImageAddr[1:0])
		2'b00 : CursorReadData[ 7: 0]  <= CGetData[CGetImageAddr];
		2'b01 : CursorReadData[15: 8]  <= CGetData[CGetImageAddr];
		2'b10 : CursorReadData[23:16]  <= CGetData[CGetImageAddr];
		2'b11 : CursorReadData[31:24]  <= CGetData[CGetImageAddr];
	endcase

integer CursorRead;
initial begin
  CursorRead = $fopen("./Image/Cursor32_8.txt");
  forever @(posedge Clk) begin
    if (IncCImageAddr & WREADY & WVALID & CGetImageAddr[1] & CGetImageAddr[0]) begin
    	$fdisplay(CursorRead, "%h",CursorReadData);
    end
  end
end
//------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
   if 		(!nRST)  		CGetImageAddr <= 0;
   else if (FrameRst | CGetImageAddr==CGetImageSize)		
   							CGetImageAddr <= 0;
   else if (IncCImageAddr & WREADY & WVALID) 	
   							CGetImageAddr <= CGetImageAddr + 1;
//------------------------------------------------------------------------