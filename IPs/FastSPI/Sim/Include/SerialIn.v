task SerialIn;
input [15:0] InData;
begin
	@(negedge SSPCLKIN) #DLY SSPFSSIN = 0;
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[15];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[14];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[13];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[12];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[11];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[10];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[9];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[8];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[7];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[6];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[5];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[4];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[3];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[2];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[1];
    @(negedge SSPCLKIN) #DLY SSPRXD = InData[0];
	@(negedge SSPCLKIN) #DLY SSPFSSIN = 1;
end
endtask
