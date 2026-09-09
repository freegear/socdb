
integer Cursor64Read;
integer Graphic64Read;
integer Video64Read;

reg Cursor64Valid;
always @(negedge nRST or posedge Clk)
   if 		(!nRST)	Cursor64Valid <= 0;
   else	if 	(DmTop.CDMARDataValid)	
   					Cursor64Valid <= Cursor64Valid + 1;
 
reg Graphic64Valid;
always @(negedge nRST or posedge Clk)
   if 		(!nRST)	Graphic64Valid <= 0;
   else	if 	(DmTop.GDMARDataValid)	
   					Graphic64Valid <= Graphic64Valid + 1;

reg Video64Valid;
always @(negedge nRST or posedge Clk)
   if 		(!nRST)	Video64Valid <= 0;
   else	if 	(DmTop.VDMARDataValid)	
   					Video64Valid <= Video64Valid + 1;

reg [63:0] Cursor64Data;
reg [63:0] Graphic64Data;
reg [63:0] Video64Data;

always @(DmTop.CDMARDataValid or Cursor64Valid or DmTop.CDMARData)
	if (DmTop.CDMARDataValid)
		if (!Cursor64Valid)	Cursor64Data[31: 0] <= DmTop.CDMARData;
		else				Cursor64Data[63:32] <= DmTop.CDMARData;

always @(DmTop.GDMARDataValid or Graphic64Valid or DmTop.GDMARData)
	if (DmTop.GDMARDataValid)
		if (!Graphic64Valid)Graphic64Data[31: 0] <= DmTop.GDMARData;
		else				Graphic64Data[63:32] <= DmTop.GDMARData;

always @(DmTop.VDMARDataValid or Video64Valid or DmTop.VDMARData)
	if (DmTop.VDMARDataValid)
		if (!Video64Valid)	Video64Data[31: 0] <= DmTop.VDMARData;
		else				Video64Data[63:32] <= DmTop.VDMARData;

initial begin
  Cursor64Read = $fopen("./Image/Cursor64_8.txt");
  forever @(posedge Clk) begin
    if (Cursor64Valid) begin
    	$fdisplay(Cursor64Read, "%h", Cursor64Data);
    end
  end
end

initial begin
  Graphic64Read = $fopen("./Image/Graphic64_16.txt");
  forever @(posedge Clk) begin
    if (Graphic64Valid) begin
    	$fdisplay(Graphic64Read, "%h", Graphic64Data);
    end
  end
end

initial begin
  Video64Read = $fopen("./Image/Video64.txt");
  forever @(posedge Clk) begin
    if (Video64Valid) begin
    	$fdisplay(Video64Read, "%h", Video64Data);
    end
  end
end