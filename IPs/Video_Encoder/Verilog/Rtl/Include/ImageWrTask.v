
always @(negedge nRST or posedge Clk)
   if 		(!nRST)  		CImageAddr <= 0;
   else if (FrameRst | CImageAddr==CImageSize)		
   							CImageAddr <= 0;
   else if (IncCImageAddr & WREADY & WVALID) 	
   							CImageAddr <= CImageAddr + 1;

always @(negedge nRST or posedge Clk)
   if 		(!nRST)  		GImageAddr <= 0;
   else if (FrameRst | GImageAddr==GImageSize)		
   							GImageAddr <= 0;
   else if (IncGImageAddr & WREADY & WVALID)	
   							GImageAddr <= GImageAddr + 1;

always @(negedge nRST or posedge Clk)
   if 		(!nRST)  		VImageAddr <= 0;
   else if (FrameRst | VImageAddr==VImageSize)		
   							VImageAddr <= 0;
   else if (IncVImageAddr & WREADY & WVALID)	
   							VImageAddr <= VImageAddr + 1;

assign WLAST = (k==WBS-1);

task CurSorW;
begin
	IncCImageAddr = 0;
	`ifdef GETCurSor
	for(i=0;i<=(CGetImageSize/WBS);i=i+1) begin
	`else
	for(i=0;i<=(CImageSize/WBS);i=i+1) begin
	`endif
		awrite(1, CPlaneStartAddr+(CImageAddr<<2), WBS, `SIZE_WORD, `BURST_INCR);
		for(k=0;k<WBS;k=k+1) begin
			IncCImageAddr = 1;
			`ifdef GETCurSor
			writedata(CGetData[CGetImageAddr], {(BB+1){1'b1}}, WBS-1);
			`else
			writedata(CTestData[CImageAddr], {(BB+1){1'b1}}, WBS-1);
			`endif
		end
		k = 0;
		IncCImageAddr = 0;
	end
end
endtask

task GraphicW;
begin
	IncGImageAddr = 0;
	for(i=0;i<=(GImageSize/WBS);i=i+1) begin
		awrite(1, GPlaneStartAddr+(GImageAddr<<2), WBS, `SIZE_WORD, `BURST_INCR);
		for(k=0;k<WBS;k=k+1) begin
			IncGImageAddr = 1;
			writedata(GTestData[GImageAddr], {(BB+1){1'b1}}, WBS-1);
		end
		k = 0;
		IncGImageAddr = 0;
	end
end
endtask

task VideoW;
begin
	IncVImageAddr = 0;
	for(i=0;i<=(VImageSize/WBS);i=i+1) begin
		awrite(1, VPlaneStartAddr+(VImageAddr<<2), WBS, `SIZE_WORD, `BURST_INCR);
		for(k=0;k<WBS;k=k+1) begin
			IncVImageAddr = 1;
			writedata(VTestData[VImageAddr], {(BB+1){1'b1}}, WBS-1);
		end
		k = 0;
		IncVImageAddr = 0;
	end
end
endtask