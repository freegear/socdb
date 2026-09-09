`timescale 1ns/10ps

module tb_SMC_top();

reg					HCLK      ;
reg					HRESETn   ;
reg	[19:0]			HADDR     ;
reg	[ 1:0]			HTRANS    ;
reg					HWRITE    ;
reg [ 2:0]			HSIZE     ;
reg	[31:0]			HWDATA    ;
reg					HSEL0     ;
reg					HSEL1     ;
reg					HSEL2     ;
reg					HSEL3     ;
reg					HREADY_in ;
wire				HREADY_out;
wire[ 1:0]			HRESP     ;
wire[31:0]			HRDATA    ;
                	          
//APB SIGN      	          
reg					PCLK      ;
reg					PRESETn   ;
reg	[ 2:3]			PADDR     ;
reg					PSEL      ;
reg					PENABLE   ;
reg					PWRITE    ;
reg	[31:0]			PWDATA    ;
wire[31:0]  		PRDATA    ;
                	          
wire[19:0]			EXT_ADDR  ;
wire[31:0]			EXT_WDATA ;
wire[31:0]			EXT_RDATA ;
wire[ 3:0]			EXT_CSb   ;
wire				EXT_OEb   ;
wire				EXT_WEb   ;
wire[3:0]			EXT_BEb   ;
wire[3:0]			EXT_WBEb  ;
wire				EXT_BIDEN ;

wire[7 :0]			sram_data_0;
wire[7 :0]			sram_data_1;
wire[7 :0]			sram_data_2;
wire[7 :0]			sram_data_3;
wire[31:0]			sram_data_32;

reg		ready0_en;
reg		ready0;

SMC_TOP uSMC_TOP(
		.HCLK      	(HCLK      ),    
		.HRESETn   	(HRESETn   ),    
		.HADDR     	(HADDR     ),    
		.HTRANS    	(HTRANS    ),    
		.HWRITE    	(HWRITE    ),    
		.HSIZE	   	(HSIZE	   ),     
		.HWDATA    	(HWDATA    ),    
		.HSEL0     	(HSEL0     ),    
		.HSEL1     	(HSEL1     ),    
		.HSEL2     	(HSEL2     ),    
		.HSEL3     	(HSEL3     ),    
		.HREADY_in 	(HREADY_in ),    
		.HREADY_out	(HREADY_out),    
		.HRESP     	(HRESP     ),    
		.HRDATA    	(HRDATA    ),    
                   	                 
		.PCLK      	(PCLK      ),    
		.PRESETn   	(PRESETn   ),    
		.PADDR     	(PADDR     ),    
		.PSEL      	(PSEL      ),    
		.PENABLE   	(PENABLE   ),    
		.PWRITE    	(PWRITE    ),    
		.PWDATA    	(PWDATA    ),    
		.PRDATA    	(PRDATA    ),    
        	           	                 
		.EXT_ADDR  	(EXT_ADDR  ),    
		.EXT_WDATA 	(EXT_WDATA ),    
		.EXT_RDATA 	(EXT_RDATA ),    
		.EXT_CSb   	(EXT_CSb   ),    
		.EXT_OEb   	(EXT_OEb   ),    
		.EXT_WEb   	(EXT_WEb   ),    
		.EXT_BEb   	(EXT_BEb   ),    
		.EXT_WBEb  	(EXT_WBEb  ),    
		.EXT_BIDEN 	(EXT_BIDEN ));   
                                     
// bank0
sram8bit u0_sram8bit(
		.data	   	(sram_data_0   	),
		.addr	   	(EXT_ADDR[17:0]	),
		.we_n	   	(EXT_WBEb[0]   	),
		.oe_n	   	(EXT_OEb	   	),
		.cs_n	   	(EXT_CSb[0]	   	));

//bank1
sram16bit u1_sram16bit(
		.data  		({sram_data_1,sram_data_0}	),
		.addr  		({EXT_ADDR[17:1],1'b0}		),
		.we_n  		(EXT_WEb					),
		.oe_n  		(EXT_OEb					),
		.cs_n  		(EXT_CSb[1]	 				),
		.ble_n 		(EXT_BEb[0]					),
		.bhe_n 		(EXT_BEb[1]					));

sram32bit u2_sram32bit(
		.data  		(sram_data_32 				),
		.addr  		({EXT_ADDR[17:2],2'b00}		),
		.we_n  		(EXT_WEb					),
		.oe_n  		(EXT_OEb					),
		.cs_n  		(EXT_CSb[2]	 				),
		.be0_n		(EXT_BEb[0]					),
		.be1_n		(EXT_BEb[1]					),
		.be2_n		(EXT_BEb[2]					),
		.be3_n		(EXT_BEb[3]					));

sram32bit u3_sram32bit(
		.data  		(sram_data_32 				),
		.addr  		(EXT_ADDR[17:0]				),
		.we_n  		(EXT_WEb					),
		.oe_n  		(EXT_OEb					),
		.cs_n  		(EXT_CSb[3]	 				),
		.be0_n		(EXT_BEb[0]					),
		.be1_n		(EXT_BEb[1]					),
		.be2_n		(EXT_BEb[2]					),
		.be3_n		(EXT_BEb[3]					));

assign	sram_data_3 = (EXT_BIDEN) ? EXT_WDATA[31:24] : 32'hz;
assign	sram_data_2 = (EXT_BIDEN) ? EXT_WDATA[23:16] : 32'hz;
assign	sram_data_1 = (EXT_BIDEN) ? EXT_WDATA[15:8 ] : 32'hz;
assign	sram_data_0 = (EXT_BIDEN) ? EXT_WDATA[ 7:0 ] : 32'hz;


assign  sram_data_32= {sram_data_3,sram_data_2,sram_data_1,sram_data_0};
assign  EXT_RDATA   = sram_data_32;

parameter	dly = 10;
		
initial
begin
	HCLK      = 0;
	HRESETn   = 0;
	HADDR     = 0;
	HTRANS    = 0;
	HWRITE    = 0;
	HSIZE	  = 0;
	HWDATA    = 0;
	HSEL0     = 0;
	HSEL1     = 0;
	HSEL2     = 0;
	HSEL3     = 0;
	HREADY_in = 0;
	PCLK      = 0;
	PRESETn   = 0;
	PADDR     = 0;
	PSEL      = 0;
	PENABLE   = 0;
	PWRITE    = 0;
	PWDATA    = 0; # 100 ;    
	HREADY_in = 1;
	HRESETn   = 1;
	PRESETn   = 1;
	ready0_en = 0;
	ready0    = 0;
end		
		
always  #dly HCLK = ~HCLK;
always  #dly PCLK = ~PCLK;
always @(HREADY_out) 
begin
	if(ready0_en)
		HREADY_in = ready0;
	else
		HREADY_in = HREADY_out;
end
task reg_write; 
	input[ 1:0]	addr;
	input[31:0] data;
	begin
		@(negedge HCLK) #2
			PENABLE = 1'b0;
		@(posedge HCLK) #2
			PSEL = 1'b1;
			PWRITE = 1'b1;
			PADDR = addr;
			PWDATA = data;
		@(posedge HCLK) #2
			PENABLE = 1'b1;
		@(posedge HCLK) #2
			$display($time, " : address [%h]   reg write : data [%h]", addr, data);
			PSEL = 1'b0;
			PENABLE = 1'b0;
			PWDATA = 32'd0;
	end
endtask

task reg_read; 
	input[ 1:0]	addr;
	input[31:0] data;
	begin
		@(negedge HCLK) #2
			PENABLE = 1'b0;
		@(posedge HCLK) #2
			PSEL = 1'b1;
			PWRITE = 1'b0;
			PADDR = addr;
		@(posedge HCLK) #2
			PENABLE = 1'b1;
		@(posedge HCLK) #2
			if(PRDATA == data)
				$display($time, " : match data ");
			else	
				$display($time, " : error repected data[%h] : read data[%h]",data , PRDATA);
			PSEL = 1'b0;
			PENABLE = 1'b0;
			PWDATA = 32'd0;
	end
endtask

task mem_write;
	input[ 3:0] bank;
	input[ 2:0] size;
	input[31:0] addr;
	input[31:0] data;

	begin
		@(posedge HCLK) #2
			HTRANS = 2'b10;
//			HREADY_in =1'b1;
			HADDR = addr;
			HSIZE = size;
			HWRITE = 1'b1;
			HSEL0 = bank[0];
			HSEL1 = bank[1];
			HSEL2 = bank[2];
			HSEL3 = bank[3];
		@(posedge HCLK) #2
			HWDATA = data;
			HSEL0 = 0;
			HSEL1 = 0;
			HSEL2 = 0;
			HSEL3 = 0;
		wait(HREADY_out);
			
	end
endtask

task mem_read;
	input[ 7:0] num;
	input[ 3:0] bank;
	input[ 2:0] size;
	input[19:0] addr;
	input[31:0] mask;
	input[31:0] data;

	begin
		@(posedge HCLK) #2
			HTRANS = 2'b10;
//			HREADY_in =1'b1;
			HADDR = addr;
			HSIZE = size;
			HWRITE = 1'b0;
			HSEL0 = bank[0];
			HSEL1 = bank[1];
			HSEL2 = bank[2];
			HSEL3 = bank[3];
		@(posedge HCLK) #2
			HWDATA = data;
			HSEL0 = 0;
			HSEL1 = 0;
			HSEL2 = 0;
			HSEL3 = 0;
		wait(HREADY_out);
			if((HRDATA&mask) == (data&mask))
				$display($time, " :[%d] match data", num);
			else 
				$display($time, " :[%d] error mask data[%h] repected data[%h] : read data[%h]",num, mask, data , HRDATA);
	end
endtask


initial
begin
wait(HRESETn);
repeat (10) @(posedge HCLK);

// register read write test  

//*******addr,reserved  ,addr_setup,cs_setup,acc_cycle,cs_hold,addr_hold,bus_width,addr_shift)*****
reg_write(0  ,{12'd0    ,3'b000    ,3'b001  ,4'b0010  ,3'b001 ,3'b001   ,2'b00    ,    2'b00});  
reg_write(1  ,{12'd0    ,3'b001    ,3'b001  ,4'b0010  ,3'b001 ,3'b001   ,2'b01    ,    2'b00});  
reg_write(2  ,{12'd0    ,3'b010    ,3'b001  ,4'b0010  ,3'b001 ,3'b001   ,2'b10    ,    2'b00});  
reg_write(3  ,{12'd0    ,3'b100    ,3'b001  ,4'b0010  ,3'b001 ,3'b001   ,2'b10    ,    2'b00});  

reg_read (0  ,{12'd0    ,3'b000    ,3'b001  ,4'b0010  ,3'b001 ,3'b001   ,2'b00    ,    2'b00});  
reg_read (1  ,{12'd0    ,3'b001    ,3'b001  ,4'b0010  ,3'b001 ,3'b001   ,2'b01    ,    2'b00});  
reg_read (2  ,{12'd0    ,3'b010    ,3'b001  ,4'b0010  ,3'b001 ,3'b001   ,2'b10    ,    2'b00});  
reg_read (3  ,{12'd0    ,3'b100    ,3'b001  ,4'b0010  ,3'b001 ,3'b001   ,2'b10    ,    2'b00});  

// bank select test

//*******addr,reserved  ,addr_setup,cs_setup,acc_cycle,cs_hold,addr_hold,bus_width,addr_shift)*****
reg_write(0  ,{12'd0    ,3'b000    ,3'b001  ,4'b0000  ,3'b001 ,3'b001   ,2'b00    ,    2'b00});  

//*******(bank,size ,addr,    data    )*********

// bank0 test
mem_write(   1,    0,   0,32'hffffff11);

reg_write(0  ,{12'd0    ,3'b001    ,3'b010  ,4'b1000  ,3'b000 ,3'b000   ,2'b01    ,    2'b00});  
// bank1 test
mem_write(   2,    0,   4,32'hffffffdd);

reg_write(0  ,{12'd0    ,3'b010    ,3'b100  ,4'b1010  ,3'b100 ,3'b010   ,2'b10    ,    2'b00});  
// bank2 test
mem_write(   4,    0,   8,32'hffffffbb);

reg_write(0  ,{12'd0    ,3'b100    ,3'b000  ,4'b0110  ,3'b001 ,3'b101   ,2'b10    ,    2'b10});  
// bank3 test
mem_write(   8,    0,   12,32'hffffffcc);


//*******addr,reserved  ,addr_setup,cs_setup,acc_cycle,cs_hold,addr_hold,bus_width,addr_shift)*****
reg_write(0  ,{12'd0    ,3'b000    ,3'b001  ,4'b0000  ,3'b001 ,3'b001   ,2'b00    ,    2'b00});  



//memory read write test
//*******(bank,size,addr)*********

// 8 bit memory write
mem_write (   1,    2,  1  ,32'h12345601);
mem_write (   1,    2,  2  ,32'habcdef02);
mem_write (   1,    2,  3  ,32'h11223344);
mem_write (   1,    2,  4  ,32'h55667788);
                             
mem_read  (1, 1,    2,  1  ,32'hffffffff ,32'h11223344);
mem_read  (2, 1,    2,  2  ,32'hffffffff ,32'h11223344);
mem_read  (3, 1,    2,  3  ,32'hffffffff ,32'h11223344);
mem_read  (4, 1,    2,  4  ,32'hffffffff ,32'h55667788);
                            
mem_write (   1,    1,  1  ,32'h12345601);
mem_write (   1,    1,  2  ,32'habcdef02);
mem_read  (5, 1,    1,  1  ,32'h0000ffff ,32'h12345601);
mem_read  (6, 1,    1,  2  ,32'hffff0000 ,32'habcdef02);
mem_write (   1,    1,  3  ,32'hff11aa00);
mem_write (   1,    1,  4  ,32'hbb33cc44);
mem_read  (7, 1,    1,  4  ,32'h0000ffff ,32'hbb33cc44);
                            
mem_write (   1,    0,  16 ,32'haf45be37);
mem_read  (8, 1,    0,  16 ,32'h000000ff ,32'haf45be37);
                            
mem_write (   1,    2,  21 ,32'h12345601);
mem_write (   1,    2,  22 ,32'habcdef02);
mem_write (   1,    2,  23 ,32'h11223344);
mem_write (   1,    2,  24 ,32'h55667788);
                            
mem_read  (9, 1,    2,  21 ,32'hffffffff ,32'h11223344);
mem_read  (10,1,    2,  22 ,32'hffffffff ,32'h11223344);
mem_read  (11,1,    2,  23 ,32'hffffffff ,32'h11223344);
mem_read  (12,1,    2,  24 ,32'hffffffff ,32'h55667788);
                            
mem_write (   1,    2,  20 ,32'h12345601);	  
mem_write (   1,    2,  24 ,32'habcdefab);	  
mem_read  (13,1,    1,  20 ,32'h0000ffff ,32'h12345601);
mem_read  (14,1,    0,  24 ,32'h000000ff ,32'habcdefab);
                            
                            
mem_write (   1,    2,  28 ,32'h12345601);
mem_write (   1,    2,  28 ,32'habcdefab);
mem_write (   1,    2,  28 ,32'haabbccdd);
mem_read  (15,1,    2,  28 ,32'hffffffff ,32'haabbccdd);

//16 bit memory write
mem_write (   2,    2,  1  ,32'h12345601);
mem_write (   2,    2,  2  ,32'habcdef02);
mem_write (   2,    2,  3  ,32'h11223344);
mem_write (   2,    2,  4  ,32'h55667788);
                         
mem_read  (16,2,    2,  1  ,32'hffffffff ,32'h11223344);
mem_read  (17,2,    2,  2  ,32'hffffffff ,32'h11223344);
mem_read  (18,2,    2,  3  ,32'hffffffff ,32'h11223344);
mem_read  (19,2,    2,  4  ,32'hffffffff ,32'h55667788);
                          
mem_write (   2,    1,  1  ,32'h12345601);
mem_write (   2,    1,  2  ,32'habcdef02);
mem_read  (20,2,    1,  1  ,32'h0000ffff ,32'h12345601);
mem_read  (21,2,    1,  2  ,32'hffff0000 ,32'habcdef02);
mem_write (   2,    1,  3  ,32'hff11aa00);
mem_write (   2,    1,  4  ,32'hbb33cc44);
mem_read  (22,2,    1,  4  ,32'h0000ffff ,32'hbb33cc44);
                          
mem_write (   2,    1,  16 ,32'haf45be37);
mem_read  (23,2,    1,  16 ,32'h0000ffff ,32'haf45be37);
                         
mem_write (   2,    1,  21 ,32'h12345601);
mem_write (   2,    1,  22 ,32'habcdef02);
mem_write (   2,    1,  23 ,32'h11223344);
mem_write (   2,    1,  24 ,32'h55667788);
                         
mem_read  (24,2,    1,  21 ,32'h0000ffff ,32'h12345601);
mem_read  (25,2,    1,  22 ,32'hffff0000 ,32'h11223344);
mem_read  (26,2,    1,  23 ,32'hffff0000 ,32'h11223344);
mem_read  (27,2,    1,  24 ,32'h0000ffff ,32'h55667788);
                         
mem_write (   2,    0,  20 ,32'h12345601);	  
mem_write (   2,    0,  24 ,32'habcdefab);	  
mem_read  (28,2,    0,  20 ,32'h000000ff ,32'h12345601);
mem_read  (29,2,    0,  24 ,32'h000000ff ,32'habcdefab);
                          
                           
mem_write (   2,    1,  28 ,32'h12345601);
mem_write (   2,    1,  28 ,32'habcdefab);
mem_write (   2,    1,  28 ,32'haabbccdd);
mem_read  (30,2,    1,  28 ,32'h0000ffff ,32'haabbccdd);

//32 bit memory write 
mem_write (   4,    2,  1  ,32'h12345601);
mem_write (   4,    2,  2  ,32'habcdef02);
mem_write (   4,    2,  3  ,32'h11223344);
mem_write (   4,    2,  4  ,32'h55667788);
                           
mem_read  (31,4,    2,  1  ,32'hffffffff ,32'h11223344);
mem_read  (32,4,    2,  2  ,32'hffffffff ,32'h11223344);
mem_read  (33,4,    2,  3  ,32'hffffffff ,32'h11223344);
mem_read  (34,4,    2,  4  ,32'hffffffff ,32'h55667788);
                         
mem_write (   4,    1,  1  ,32'h12345601);
mem_write (   4,    1,  2  ,32'habcdef02);
mem_read  (35,4,    1,  1  ,32'h0000ffff ,32'h12345601);
mem_read  (36,4,    1,  2  ,32'hffff0000 ,32'habcdef02);
mem_write (   4,    1,  3  ,32'hff11aa00);
mem_write (   4,    1,  4  ,32'hbb33cc44);
mem_read  (37,4,    1,  4  ,32'h0000ffff ,32'hbb33cc44);
                         
mem_write (   4,    1,  16 ,32'haf45be37);
mem_read  (38,4,    1,  16 ,32'h0000ffff ,32'haf45be37);
                         
mem_write (   4,    0,  21 ,32'h12345601);
mem_write (   4,    0,  22 ,32'habcdef02);
mem_write (   4,    0,  23 ,32'h11223344);
mem_write (   4,    0,  24 ,32'h55667788);
                         
mem_read  (39,4,    0,  21 ,32'h0000ff00 ,32'h12345601);
mem_read  (40,4,    0,  22 ,32'h00ff0000 ,32'habcdef02);
mem_read  (41,4,    0,  23 ,32'hff000000 ,32'h11223344);
mem_read  (42,4,    0,  24 ,32'h000000ff ,32'h55667788);
                       
mem_write (   4,    0,  20 ,32'h12345601);	  
mem_write (   4,    0,  24 ,32'habcdefab);	  
mem_read  (43,4,    0,  20 ,32'h000000ff ,32'h12345601);
mem_read  (44,4,    0,  24 ,32'h000000ff ,32'habcdefab);
                        
                        
mem_write (   4,    0,  28 ,32'h12345601);
mem_write (   4,    0,  28 ,32'habcdefab);
mem_write (   4,    0,  28 ,32'haabbccdd);
mem_read  (45,4,    0,  28 ,32'h000000ff ,32'haabbccdd);

#100;
$stop;
end

endmodule

		
		