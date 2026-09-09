task SerialIn1;
input [19:0] InData;
begin
	                #DLY SDI1 = InData[19];
	@(negedge MSCK) #DLY SDI1 = InData[18];
	@(negedge MSCK) #DLY SDI1 = InData[17];
	@(negedge MSCK) #DLY SDI1 = InData[16];
	@(negedge MSCK) #DLY SDI1 = InData[15];
	@(negedge MSCK) #DLY SDI1 = InData[14];
	@(negedge MSCK) #DLY SDI1 = InData[13];
	@(negedge MSCK) #DLY SDI1 = InData[12];
	@(negedge MSCK) #DLY SDI1 = InData[11];
	@(negedge MSCK) #DLY SDI1 = InData[10];
	@(negedge MSCK) #DLY SDI1 = InData[9];
	@(negedge MSCK) #DLY SDI1 = InData[8];
	@(negedge MSCK) #DLY SDI1 = InData[7];
	@(negedge MSCK) #DLY SDI1 = InData[6];
	@(negedge MSCK) #DLY SDI1 = InData[5];
	@(negedge MSCK) #DLY SDI1 = InData[4];
	@(negedge MSCK) #DLY SDI1 = InData[3];
	@(negedge MSCK) #DLY SDI1 = InData[2];
	@(negedge MSCK) #DLY SDI1 = InData[1];
	@(negedge MSCK) #DLY SDI1 = InData[0];
	@(negedge MSCK) #DLY SDI1 = 0;	// Dummy
	@(negedge MSCK) #DLY SDI1 = 0;	// Dummy
	@(negedge MSCK) #DLY SDI1 = 0;	// Dummy
	@(negedge MSCK) #DLY SDI1 = 0;	// Dummy
end
endtask

task SerialIn2;
input [19:0] InData;
begin
	                #DLY SDI2 = InData[19];
	@(negedge MSCK) #DLY SDI2 = InData[18];
	@(negedge MSCK) #DLY SDI2 = InData[17];
	@(negedge MSCK) #DLY SDI2 = InData[16];
	@(negedge MSCK) #DLY SDI2 = InData[15];
	@(negedge MSCK) #DLY SDI2 = InData[14];
	@(negedge MSCK) #DLY SDI2 = InData[13];
	@(negedge MSCK) #DLY SDI2 = InData[12];
	@(negedge MSCK) #DLY SDI2 = InData[11];
	@(negedge MSCK) #DLY SDI2 = InData[10];
	@(negedge MSCK) #DLY SDI2 = InData[9];
	@(negedge MSCK) #DLY SDI2 = InData[8];
	@(negedge MSCK) #DLY SDI2 = InData[7];
	@(negedge MSCK) #DLY SDI2 = InData[6];
	@(negedge MSCK) #DLY SDI2 = InData[5];
	@(negedge MSCK) #DLY SDI2 = InData[4];
	@(negedge MSCK) #DLY SDI2 = InData[3];
	@(negedge MSCK) #DLY SDI2 = InData[2];
	@(negedge MSCK) #DLY SDI2 = InData[1];
	@(negedge MSCK) #DLY SDI2 = InData[0];
	@(negedge MSCK) #DLY SDI2 = 0;	// Dummy
	@(negedge MSCK) #DLY SDI2 = 0;	// Dummy
	@(negedge MSCK) #DLY SDI2 = 0;	// Dummy
	@(negedge MSCK) #DLY SDI2 = 0;	// Dummy
end
endtask
