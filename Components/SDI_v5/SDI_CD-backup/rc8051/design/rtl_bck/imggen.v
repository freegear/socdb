
/***************************************************
**                                                **
** Decoder Sync&Data Input Test Vecter Gen.       **
** Img_01(DecD_02) Ver_0110.                      **
**                                                **
***************************************************/
module imggen(clk, rst, Hs, Vs, bayer);
input           clk, rst;

output          Hs, Vs;
output   [9:0]  bayer;

parameter       FILE_SIZE = 3540950;

reg     [11:0]     MEM_Y[0:FILE_SIZE-1] ;


initial begin
   $readmemh("./VHDATA_SEN.txt", MEM_Y);
end

reg     [29:0]     address ;
reg     [9:0]      bayer;
reg                Hs, Vs;

wire    [11:0]     mem;

assign mem  = MEM_Y[address] ;

always @(posedge clk or negedge rst) begin
   if (rst == 1'b0) begin
      address <= 30'd0;
   end
   else if (address == (FILE_SIZE-1)) begin
      address <= 30'd0;
   end
   else if ((address > 10) && (address < 20)) begin  
      address <= address + 1'b1;
      bayer   <= mem[9:0];
      Hs      <= mem[10];
      Vs      <= 1'b0;
   end
   else begin
      address <= address + 1'b1;
      bayer   <= mem[9:0];
      Hs      <= mem[10];
      Vs      <= mem[11];
   end
end


endmodule

