`ifdef GRAPHIC
integer GraphicRead;
initial begin
  GraphicRead = $fopen("./Result/GROut.txt");
  forever @(posedge Clk) begin
    if (DmTop.GDMADataRequest & DmTop.GDMADataValid) $fdisplay(GraphicRead, "%h",DmTop.GDMADataIn[23:0]);
  end
end

integer GDMARead;
initial begin
  GDMARead = $fopen("./Result/GDMAOut.txt");
  forever @(posedge Clk) begin
    if (DmTop.GDMARDataValid) $fdisplay(GDMARead, "%h",DmTop.GDMARData[23:0]);
  end
end
`endif

integer VDMARead;
initial begin
  VDMARead = $fopen("./Result/VDMAOut.txt");
  forever @(posedge Clk) begin
    if (DmTop.VDMARDataValid) $fdisplay(VDMARead, "%h",DmTop.VDMARData);
  end
end

/*
integer FSMInRead;
initial begin
  FSMInRead = $fopen("./Result/FSMIn.txt");
  forever @(posedge Clk) begin
    if (DmTop.VideoPlane.FSMValidIn) $fdisplay(FSMInRead, "%h",DmTop.VideoPlane.FSMIn);
  end
end
*/

`ifdef SCALER
reg ScaleValid;
always @(negedge nRST or posedge Clk)
   if 		(!nRST)	ScaleValid <= 0;
   else	if 	(DmTop.VideoPlane.Scaler.VScInF.OutValid)	
   					ScaleValid <= ScaleValid + 1;
   
integer SCInRead;
initial begin
  SCInRead = $fopen("./Result/SCIn.txt");
  forever @(posedge Clk) begin
//    if (ScaleValid) $fdisplay(SCInRead, "%h",DmTop.VideoPlane.ScaleIn);
    if (DmTop.VideoPlane.Scaler.VScInF.InValid) 
    	$fdisplay(SCInRead, "%h",DmTop.VideoPlane.Scaler.VScInF.InData);
  end
end

integer VSCInRead;
initial begin
  VSCInRead = $fopen("./Result/VSCIn.txt");
  forever @(posedge Clk) begin
    if (ScaleValid) 
    	$fdisplay(VSCInRead, "%h",DmTop.VideoPlane.Scaler.VScInF.OutData);
  end
end

integer FCRead;
initial begin
  FCRead = $fopen("./Result/FCOut.txt");
  forever @(posedge Clk) begin
    if (DmTop.VideoPlane.VidFCValidIn) $fdisplay(FCRead, "%h",DmTop.VideoPlane.VidFCIn);
  end
end

/*
integer CSCRead;
initial begin
  CSCRead = $fopen("./Result/CSCIn.txt");
  forever @(posedge Clk) begin
    if (DmTop.VideoPlane.VidCSCValidIn) $fdisplay(CSCRead, "%h",DmTop.VideoPlane.VidCSCIn);

  end
end

integer CSCReadR;
initial begin
  CSCReadR = $fopen("./Result/CSCOut.txt");
  forever @(posedge Clk) begin
    if (DmTop.VideoPlane.VidCSCValidOut) $fdisplay(CSCReadR, "%h",DmTop.VideoPlane.VidCSCOut);

  end
end
*/
`endif