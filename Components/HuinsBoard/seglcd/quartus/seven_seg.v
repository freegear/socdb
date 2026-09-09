module seven_seg(
                   clk,
                   data,
                   reset_n,
                   enable_n,
                   address,
                   seg_data, 
                   seg_out1,
                   seg_out2,
                   seg_gnd1,                   
                   seg_gnd2,
                   cnt3
                );


//Input
input                      clk;           // Clock
input        [31:0]        data;          // Data Input 
input                      reset_n;       // Active Low reset
input                      enable_n;      // Active Low enable
input        [ 9:2]        address;       // 

//Output
output       [31:0]        seg_data;
output       [7:0]         seg_out1;      // Triple 7-segment Data_out 1 
output       [7:0]         seg_out2;      // Triple 7-segment Data out 2
output       [2:0]         seg_gnd1;      // 7-segment GND control 1 
output       [2:0]         seg_gnd2;      // 7-segment GND contorl 2
output       [1:0]         cnt3;

//Register   
reg           [31:0]       D_Reg;         // Data Register
reg           [2:0]        seg_gnd;
reg           [15:0]       cnt64k;
reg           [7:0]        seg_out1;      // Triple 7-segment Data_out 1 
reg           [7:0]        seg_out2;      // Triple 7-segment Data out 2
reg           [1:0]        cnt3;


//wire
wire          [7:0]        seg1;
wire          [7:0]        seg2;
wire          [7:0]        seg3;
wire          [7:0]        seg4;
wire          [7:0]        seg5;
wire          [7:0]        seg6;
wire          [2:0]        seg_gnd1 = seg_gnd;
wire          [2:0]        seg_gnd2 = seg_gnd;         

//Instantiate the binary to 7-segment converter
bin2seg BIN2SEG_1( clk, D_Reg[23:20], seg1);
bin2seg BIN2SEG_2( clk, D_Reg[19:16], seg2);
bin2seg BIN2SEG_3( clk, D_Reg[15:12], seg3);
bin2seg BIN2SEG_4( clk, D_Reg[11: 8], seg4);
bin2seg BIN2SEG_5( clk, D_Reg[ 7: 4], seg5);
bin2seg BIN2SEG_6( clk, D_Reg[ 3: 0], seg6);               

assign seg_data[31:3] = 28'h0;
assign seg_data[ 2:0] = seg_gnd;


//Data Latch
always @(negedge reset_n or posedge clk) 
begin
   if (~reset_n)
   begin
      D_Reg <= 32'h0000;
   end
   else
   begin
      if (address[9:2]==1)
      begin 
         D_Reg <= data;
      end
   end
end

//dynamic_display_time_cnt
always @(negedge reset_n or posedge clk)
begin
  if (~reset_n)
     cnt64k <= 32'h0000;
  else 
  begin 
     if (cnt64k==65535) //65534
        cnt64k <= 32'h0000;
     else 
        cnt64k <= cnt64k+1;
  end
end

//cnt3
always @(negedge reset_n or posedge clk)
begin
   if (~reset_n)
      cnt3 <= 3'b00;
   else
   begin
      if (cnt3==3)
         cnt3 <= 2'b00;
      else if (cnt64k==65534)//65534
         cnt3 <= cnt3 + 1;
   end
   
end    


//Segment Ground control
always @(cnt3)
begin
   if (cnt3==0) 
      seg_gnd <= 3'b011;
   else if (cnt3==1)
      seg_gnd <= 3'b101;
   else if (cnt3==2)  
      seg_gnd <= 3'b110; 
end

//Segment out1 
always @(posedge clk)
begin
   if (seg_gnd==3) 
      seg_out1  <= seg1;
   else if (seg_gnd==5)
      seg_out1  <= seg2;
   else if (seg_gnd==6)
      seg_out1  <= seg3;
    
     
end

//Segment out2 
always @(posedge clk)
begin
   if (seg_gnd==3) 
      seg_out2  <= seg4;
   else if (seg_gnd==5)
      seg_out2  <= seg5;
   else if (seg_gnd==6)
      seg_out2  <= seg6;     
end


endmodule

     
         
      



                   
