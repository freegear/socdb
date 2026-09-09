module priority(
	//input
		disint,
		ie,
		reti,
		clk, 
		rst_p, 
		int, 
		ip,
		ie7, 
	//output
		int_vec,
		isrc_cur,
		en_int 			 
		);  
////input////////////////////////////////////
input	        clk,	
		reti,	
		ie7,	
		rst_p,
		disint;
input[4:0]	int,			
		ie,			
		ip;			
////output///////////////////////////////////
output[2:0]	int_vec;			 
output[2:0]     isrc_cur;
output		en_int; 			 
////internal signal//////////////////////////
wire		reti1;			 
reg 		en_int; 
wire [4:0] int_src;
// isrc   processing interrupt sources
reg [2:0] isrc [1:0];
reg [1:0] int_dept;
reg[2:0]	int_vec;			 
wire [1:0] int_dept_1;
reg int_proc;
reg [1:0] int_lev [1:0];
wire[1:0] cur_lev;

wire [2:0] isrc_cur;
assign isrc_cur=(int_proc)?isrc[int_dept_1]:3'h0;
assign int_dept_1 = int_dept - 2'b01;
assign cur_lev = int_lev[int_dept_1];

//int level
wire[4:0] int_l0, int_l1;
wire[4:0] ip_l0, ip_l1;
wire il0, il1;

//int priority
assign	ip_l0 = ~ip[4:0]; 		
assign	ip_l1 = ip[4:0]; 		

//waiting int
assign int_src = int;  
assign int_l0 = ie & ip_l0 & int_src;
assign int_l1 = ie & ip_l1 & int_src;
assign il0 = |int_l0;
assign il1 = |int_l1;

always @(rst_p or il0 or il1 or ie7 or int_proc or disint)
if(rst_p) en_int <= 0;
else if(disint) en_int <= 0;
else if(ie7) begin
	if(!int_proc)en_int <= il0; 
	else en_int <= il1; 
end else en_int <= 0;
/////////////////////////////////////////////
//   interrupt processing                  //
/////////////////////////////////////////////
one_shot one_shot_reti (
        .clk(clk),
        .rst_p(rst_p),
        .d(reti),
        .q(reti1)
        );
always @(posedge clk or posedge rst_p)
begin
  if (rst_p) begin
    int_vec <=  3'b000;
    int_dept <=  2'b0;
    isrc[0] <=  3'h0; 
    isrc[1] <=  3'h0; 
    int_proc <=  1'b0;
    int_lev[0] <=  2'b00;
    int_lev[1] <=  2'b00;
//---- RETURN INT PROCESS -----------------// 
  //end else if (reti1 & int_proc) 
  end else if (reti1 ) 
   begin  //return from interrupt
   if (int_dept==2'b01) int_proc <=  1'b0;
   int_dept <=  int_dept - 2'b01;
//---- LEVEL1 INT PROCESS -----------------// 
end else if (
   (ie7 & (!cur_lev) || (!int_proc | en_int)) 
   & il1) 
   begin  // interrupt on level 1
   int_proc <=  1'b1;
   int_lev[int_dept] <= 2'h1; 
   int_dept <=  int_dept + 2'b01;
   if (int_l1[0]) begin
     int_vec <= 3'b001;//INT_X0
     isrc[int_dept] <=  3'b001;//8051_ISRC_IE0 
   end else if (int_l1[1]) begin
     int_vec <= 3'b010; //INT_T0;
     isrc[int_dept] <=  3'b010;//8051_ISRC_TF0 
   end else if (int_l1[2]) begin
     int_vec <=  3'b011; //INT_X1
     isrc[int_dept] <=  3'b011;//8051_ISRC_IE1 
   end else if (int_l1[3]) begin
     int_vec <=  3'b100; //INT_T1
     isrc[int_dept] <=  3'b100;//8051_ISRC_TF1 
   end else if (int_l1[4]) begin
     int_vec <=  3'b101; //INT_UART
     isrc[int_dept] <=  3'b101;//8051_ISRC_UART 
   end
//---- LEVEL0 INT PROCESS -----------------// 
end else if (
   ie7 &
   (!int_proc) & //not int svr   
   il0
    ) begin  // interrupt on level 0
   int_proc <=  1'b1;
   int_lev[int_dept] <=  2'h0;
   int_dept <=  2'b01;
   if (int_l0[0]) begin
     int_vec <= 3'b001;//INT_X0
     isrc[int_dept] <=  3'b001;//8051_ISRC_IE0 
   end else if (int_l0[1]) begin
     int_vec <= 3'b010; //INT_T0;
     isrc[int_dept] <=  3'b010;//8051_ISRC_TF0 
   end else if (int_l0[2]) begin
     int_vec <=  3'b011; //INT_X1
     isrc[int_dept] <=  3'b011;//8051_ISRC_IE1 
   end else if (int_l0[3]) begin
     int_vec <=  3'b100; //INT_T1
     isrc[int_dept] <=  3'b100;//8051_ISRC_TF1 
   end else if (int_l0[4]) begin
     int_vec <=  3'b101; //INT_UART
     isrc[int_dept] <=  3'b101;//8051_ISRC_UART 
   end
 end else begin
   int_vec <=  3'b000;
 end
end 
endmodule
