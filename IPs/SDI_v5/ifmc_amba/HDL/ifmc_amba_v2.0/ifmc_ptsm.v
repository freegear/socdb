/*

    Protocol State Machine for external input signal

    file name : ifmc_ptsm.v
 
    create by gtlee
 
    create date : 2006.3.7
 
    history :
 
    note :
 
 
 */

module  ifmc_ptsm
  (
   clk               ,
   rstb              ,
   
   scl_lpf           ,
   sda_lpf           ,
   sda_out           ,
   sda_oeb           ,
   
   sst_start         ,
   sst_stop          ,
   sst_ishift        ,
   sst_oshift        ,
   end_sclh          ,
   
   fmr_adr           ,
   fmr_rd            ,
   fmr_rdata         ,
   fmb_ready         ,

   fm_wrmode         ,
   fmw_adr           ,
   fmw_xe            ,
   fmw_ye            ,
   fmw_se            ,
   fmw_erase         ,
   fmw_mas1          ,
   fmw_prog          ,
   fmw_nvstr         ,
   fmw_ifren         ,
   fmw_din           ,
   
   hdp               ,
   rdp               ,
   smart               
   );

   input                  clk;
   input 				  rstb;

   input 				  scl_lpf;
   input 				  sda_lpf;   // LPFed sda input
   output 				  sda_out;
   output 				  sda_oeb;    // SDA output enable
   
   input 				  sst_start;
   input 				  sst_stop;
   input 				  sst_ishift;
   input 				  sst_oshift;
   input 				  end_sclh;    // end of SCL high

   // read control signals
   output [15:0] 		  fmr_adr; // bit 2가 lsb
   output 				  fmr_rd;
   input [31:0] 		  fmr_rdata;
   input 				  fmb_ready;
   
   // write control signals
   output 				  fm_wrmode;
   
   output [15:0] 		  fmw_adr;
   output 				  fmw_xe;
   output 				  fmw_ye;
   output 				  fmw_se;
   output 				  fmw_erase;
   output 				  fmw_mas1;
   output 				  fmw_prog;
   output 				  fmw_nvstr;
   output 				  fmw_ifren;
   output [31:0] 		  fmw_din;

   // Protection Informaion
   input 				   hdp;
   input 				   rdp;
   input [15:0] 		   smart;
   

   //----------------------------------------------------------
   // internal signals
   wire 				   sda_out;
   wire 				   sda_oeb;

   // protection signal
   reg 					   perase_hit; // if 1, erasable.
   reg 					   protected;
   
   reg [2:0] 			   bit_cnt;   // up counter

   wire 				   bit_zero;  // end of byte receive
   
   reg [1:0] 			   byte_cnt; // address byte count. up counter
                           // sst_ishift와 cs[`ADDR_DUMMY]가 active이면 증가.

   //    Rx shift register
   reg [7:0] 			   rx_shift;
   
   //    Address register
   reg [7:0] 			   rx_addr0;
   reg [7:0] 			   rx_addr1;
   reg [7:0] 			   rx_addr2;

   //    Data shift register
   reg [31:0] 			   rx_data;     // shift down
   
   //    Tx shift register
   reg 					   ld_tx_data;  // ? load the tx data to the shift register
   reg [31:0] 			   pdata;       // protection data
   reg [31:0] 			   tx_shift;    // shift

   // Delay Data Dummy rising edge
   reg [2:0] 			   ddm_dly; // data dummy delay.
   wire 				   ddm_pe;  // data dummy positive edge.
   reg 					   addr_inc; // address increase signal
   reg 					   waddr_inc_en; // write address를 증가시켜도 될 timing
                                    // 1 word를 receive하면 active된다.
   

   // slc delay for getting rising edge
   reg                     scl_dly;
   wire 				   scl_pe; // scl positive edge
   
   // function decoding
   reg 					   sop_read;   // serial operation read/verify
   reg 					   sop_prog;   // serial operation program
   reg 					   sop_erase;  // serial operation erase
   reg 					   sop_wrp;    // serial operation write protection
   reg 					   sop_rdp;    // serial operation read protection

   reg 					   wait_nvstr; //? for program operation. prog, wrp이고 
                                       // protection이 disable일때만 유효.
   reg 					   wdata_va;   // flash에 write할 데이터가 있을때.
   wire                    data_phase;
   reg                     fst_ddm;    // reach the first dummy

   reg                     pop_wrp;   // write protection at the previous operation
   
   // counter
   reg 					   cnt_en; // counter enable signal
   
   reg [9:0] 			   cnt0;
   
   
   // Flash memory interface signals
   reg [15:0] 			   fmr_adr;   // auto increasement
   wire 				   fmr_rd;
   
   wire 				   fm_wrmode;
   wire [15:0] 			   fmw_adr;
   reg 					   fmw_xe;
   reg 					   fmw_ye;
   wire 				   fmw_se;
   reg 					   fmw_erase;
   reg 					   fmw_mas1;
   reg 					   fmw_prog;
   reg 					   fmw_nvstr;
   wire 				   fmw_ifren;
   reg [31:0] 			   fmw_din;
   

   //-----------------------------------------
   // State Machine
   parameter 			   PT_SM_WIDTH     =  8;
   parameter 			   PT_SM_INIT      =  {{(PT_SM_WIDTH-1){1'b0}},1'b1};
   
   parameter 			   IDLE            =  0;
   parameter 			   INITIALIZE      =  1;
   parameter 			   GET_ADDR        =  2;
   parameter 			   ADDR_DUMMY      =  3;
   parameter               CLR_COUNTER     =  4;
   parameter 			   GET_DATA        =  5;
   parameter 			   DATA_DUMMY      =  6;
   parameter               STOP            =  7;
   
   parameter 			   ST_IDLE         =  (PT_SM_INIT << IDLE);
   parameter 			   ST_INITIALIZE   =  (PT_SM_INIT << INITIALIZE);
   parameter 			   ST_GET_ADDR     =  (PT_SM_INIT << GET_ADDR);
   parameter 			   ST_ADDR_DUMMY   =  (PT_SM_INIT << ADDR_DUMMY);
   parameter 			   ST_CLR_COUNTER  =  (PT_SM_INIT << CLR_COUNTER);
   parameter 			   ST_GET_DATA     =  (PT_SM_INIT << GET_DATA);
   parameter 			   ST_DATA_DUMMY   =  (PT_SM_INIT << DATA_DUMMY);
   parameter 			   ST_STOP         =  (PT_SM_INIT << STOP);
   

   reg [PT_SM_WIDTH-1:0]  cs, ns;


   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cs <= ST_IDLE;
	  else      cs <= ns;
   end


   always@(cs or sst_start or sst_stop or bit_zero or end_sclh or
		   byte_cnt ) begin
	  case (1'b1)    // synopsys parallel_case
		cs[IDLE] :
		  if(sst_start) ns <= ST_INITIALIZE;
		  else ns <= ST_IDLE;

		cs[INITIALIZE] :
		  if(sst_stop == 1'b1) ns <= ST_STOP;
		  else if(end_sclh) ns <= ST_GET_ADDR;
		  else ns <= ST_INITIALIZE;
		
		cs[GET_ADDR] :
		  if(sst_stop) ns <= ST_STOP;
		  else if(bit_zero == 1'b1 && end_sclh == 1'b1) // 1byte receive
			ns <= ST_ADDR_DUMMY;
		  else ns <= ST_GET_ADDR;

		cs[ADDR_DUMMY] :
		  if(sst_stop) ns <= ST_STOP;
		  else if(end_sclh) begin
			 if(byte_cnt == 2'h3) ns <= ST_CLR_COUNTER;
			 else ns <= ST_GET_ADDR;
		  end
		  else ns <= ST_ADDR_DUMMY;

		cs[CLR_COUNTER] :
		  if(sst_stop) ns <= ST_STOP;
		  else ns <= ST_GET_DATA;
		
		cs[GET_DATA] :
		  if(sst_stop) ns <= ST_STOP;
		  else if(bit_zero == 1'b1 && end_sclh == 1'b1) // 1byte receive
			ns <= ST_DATA_DUMMY;
		  else ns <= ST_GET_DATA;
		
		cs[DATA_DUMMY] :
		  if(sst_stop) ns <= ST_STOP;
		  else if(end_sclh)
			ns <= ST_GET_DATA;
		  else ns <= ST_DATA_DUMMY;

		cs[STOP] :
		  if(end_sclh) ns <= ST_IDLE;
		  else         ns <= ST_STOP;
		
		default : ns <= ST_IDLE;
	  endcase // case(1'b1)
   end // always@ (cs or sst_start or sst_stop or bit_zero or end_sclh or...

   //----------------------------------------------------------
   // page erase protection hit/miss
   // if 1, erasable
   always@(fmw_adr or smart or hdp) begin
      if(~hdp) begin  
		 // protection on
		 case(fmw_adr[15:13])  // synopsys parallel_case
		   3'h0 : perase_hit <= smart[0];
		   3'h1 : perase_hit <= smart[1];
		   3'h2 : perase_hit <= smart[2];
		   3'h3 : perase_hit <= smart[3];
		   3'h4 : perase_hit <= smart[4];
		   3'h5 : perase_hit <= smart[5];
		   3'h6 : perase_hit <= smart[6];
		   default: perase_hit <= smart[7];
		 endcase // case(fmw_adr[15:13])
	  end // if (~hdp)
	  else perase_hit <= 1'b1;
   end // always@ (fmw_adr or smart or hdp)
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) protected <= 1'b0;
	  else if( sop_erase )
		  protected <= 1'b0;  
	  else if( sop_prog & ~perase_hit ) // data programming
		protected <= 1'b1;
	  else
 		protected <= 1'b0;
   end // always
   
   //---------------------------------------------------------
   // RX shift register
   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  rx_shift <= 8'h00;
	  else if(~cs[IDLE] & sst_ishift)
		rx_shift <= {rx_shift[6:0],sda_lpf};
   end // always
   

   // Address Register
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 rx_addr0 <= 8'h00;
		 rx_addr1 <= 8'h00;
		 rx_addr2 <= 8'h00;
	  end
	  else if(cs[GET_ADDR] == 1'b1 && 
			  bit_zero == 1'b1 && end_sclh == 1'b1) begin
		 case(byte_cnt)   // synopsys parallel_case
		   2'b00 : rx_addr0 <= rx_shift;
		   2'b01 : rx_addr1 <= rx_shift;
		   default :  rx_addr2 <= rx_shift;
		 endcase // case(byte_cnt)
	  end
   end // always@ (posedge clk or negedge rstb)

   
   // bit count
   // up counter
   // start 0. end 0
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) bit_cnt <= 3'h0;
	  else if(cs[GET_ADDR] | cs[GET_DATA]) begin
		if(sst_ishift)
		  bit_cnt <= bit_cnt + 3'b001;
	  end // else if
	  else if(cs[INITIALIZE] | cs[CLR_COUNTER] |
			   cs[ADDR_DUMMY] | cs[DATA_DUMMY]) 
		bit_cnt <= 3'h0;
   end // always

   assign    bit_zero = ~(|bit_cnt);
   
   
   // count the address bytes
   // dummy state 에 진입하면 1, 2, 3의 값을 갖게 됨.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) byte_cnt <= 2'b00;
	  else if(cs[INITIALIZE] | cs[CLR_COUNTER]) 
		byte_cnt <= 2'b00;
	  else if((cs[GET_ADDR] | cs[GET_DATA]) && 
			  bit_zero == 1'b1 && end_sclh == 1'b1 )
		// Dummy에서도 bit_cnt는 zero.
		// 따라서 Dummy에서는 count하지 말아야 한다.
		byte_cnt <= byte_cnt + 2'b01;
   end // always

   // Rx Data register
   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  rx_data <= {32{1'b0}};
	  else if(cs[GET_DATA] == 1'b1 &&
			  bit_zero == 1'b1 && end_sclh == 1'b1)
		// Dummy는 제외해야 한다.
		rx_data <= {rx_shift,rx_data[31:8]}; // shift down
   end // always@ (posedge clk or negedge rstb)

   // Tx Shift register 
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) ld_tx_data <= 0;
	  else ld_tx_data <= fmb_ready;
   end // always
   
   always@( rx_addr2 or rdp or hdp or smart ) begin
	  if(rx_addr2[2]) // Protection Bit
		   pdata <= {4'hf,rdp,9'h1ff,hdp,17'h1ffff};
		 else  // smart option
		   pdata <= {16'hffff,smart};
   end // always
   
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  tx_shift <= {32{1'b0}};
	  else if( cs[GET_DATA] & sst_oshift ) // trans
		tx_shift <= {tx_shift[30:0],tx_shift[31]};
   	  else if( sop_rdp & cs[CLR_COUNTER] ) begin
		 // read protection information
		   tx_shift <= {pdata[7:0], pdata[15:8],
						pdata[23:16], pdata[31:24]};
	  end
	  else if( sop_read & ~rdp & (cs[CLR_COUNTER] | cs[DATA_DUMMY]) )
		// if read protected
		tx_shift <= {32{1'b0}};
	  else if( ld_tx_data & rdp )  // load and not read protected
		tx_shift <= {fmr_rdata[7:0], fmr_rdata[15:8],
					 fmr_rdata[23:16], fmr_rdata[31:24]};
	end // always
   
   // IO signal
   // output data setup/hold : 10ns
   assign    sda_out = (sda_oeb)?1'b1 : tx_shift[0];
   assign 	 sda_oeb = ((sop_read | sop_rdp) & cs[GET_DATA])? 
						1'b0 : 1'b1;
    
   //----------------------------------------------------
   // Operation control
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 sop_read <= 1'b0;
		 sop_prog <= 1'b0;
		 sop_erase <= 1'b0;
		 sop_wrp <= 1'b0;
		 sop_rdp <= 1'b0;
	  end
	  else if( cs[IDLE] | cs[STOP] ) begin
		 sop_read <= 1'b0;
		 sop_prog <= 1'b0;
		 sop_erase <= 1'b0;
		 sop_wrp <= 1'b0;
		 sop_rdp <= 1'b0;
	  end
	  else if(cs[GET_ADDR] == 1'b1 && byte_cnt == 2'b10) begin // 3rd addr. register receive timing
		 if(rx_addr0[7] == 1'b0) begin // not the protection info and the erase
			  sop_read <= rx_addr0[0]; // if 1, read
			  sop_prog <= ~rx_addr0[0];  // if 0, write
			  sop_erase <= 1'b0;
			  sop_wrp <= 1'b0;
			  sop_rdp <= 1'b0;
		 end // if (rx_addr2[7] == 1'b0)
		 else begin  // erase and protection
			if(rx_addr0[0] == 1'b0 &&   // write
			   rx_addr1[4:0] == 5'b10101) begin
			   // chip erase
			   sop_read <= 1'b0;
			   sop_prog <= 1'b0;
			   sop_erase <= 1'b1;
			   sop_wrp <= 1'b0;
			   sop_rdp <= 1'b0;
			end
			else begin
			   // protection access
			   sop_read <= 1'b0;
			   sop_prog <= 1'b0;
			   sop_erase <= 1'b0;
			   sop_wrp <= ~rx_addr0[0]; // if 0, write
			   sop_rdp <= rx_addr0[0];  // if 1, read
			end // else: !if(rx_addr1[4:0] == 5'b10101)
		 end // else: !if(rx_addr0[7] == 1'b0)
	  end // if (byte_cnt == 2'b10)
   end // always@ (posedge clk or negedge rstb)
   
   
   //---------------------------------------------------
   // data dummy positive edge
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) ddm_dly <= 3'h0;
	  else ddm_dly <= {ddm_dly[1:0],cs[DATA_DUMMY]};
   end // always

   assign ddm_pe = ~ddm_dly[2] & ddm_dly[1];

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) addr_inc <= 1'b0;
	  else if(ddm_pe == 1'b1 && byte_cnt == 2'h0)
		addr_inc <= 1'b1;
	  else addr_inc <= 1'b0;
   end // always
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) waddr_inc_en <= 1'b0;
	  else if(cs[IDLE] | cs[STOP]) waddr_inc_en <= 1'b0;
	  else if(addr_inc) waddr_inc_en <= 1'b1;
   end
   
   // load the write data 
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fmw_din <= {32{1'b0}};
	  else if(cs[DATA_DUMMY] && byte_cnt == 2'h0 && scl_lpf == 1'b1)
		// 4byte를 받았을 때마다 load
		fmw_din <= rx_data;
   end
 		
   // auto increasement address register
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fmr_adr <= {16{1'b0}};
	  else if( cs[ADDR_DUMMY] ) begin // load new address
		 if(sop_rdp | sop_wrp)
			// protection information access
		   fmr_adr <= {12'h000,rx_addr2[5:2]};
		 else
		   fmr_adr <= {rx_addr0[2:1],rx_addr1,rx_addr2[7:2]};
	  end
	  else if( addr_inc & (~((sop_wrp | sop_prog) & ~waddr_inc_en)) )
		// auto increasement
		  fmr_adr <= fmr_adr + 16'h0001;
   end // always

   // address for write
   assign   fmw_adr = fmr_adr;

   // delay scl
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) scl_dly <= 1'b0;
	  else scl_dly <= scl_lpf;
   end

   assign   scl_pe = scl_lpf & ~scl_dly;
   
   // generate read command
   // response가 오기 전에 inactive 시켜야 한다.
   // at protection read, output the protection signals.
   assign   fmr_rd = ((cs[ADDR_DUMMY]|(cs[DATA_DUMMY]== 1'b1 && byte_cnt == 2'b00) ) &&
					  (scl_pe & sop_read & rdp) == 1'b1)? 1'b1 : 1'b0;

   // Information block enable
   // protection write and chip erase
   // at protection read, output the protection signals.
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) pop_wrp <= 1'b0;
	  else if(sop_wrp) pop_wrp <= 1'b1;
	  else if(cs[ADDR_DUMMY]) pop_wrp <= 1'b0;
   end
      
   assign 	fmw_ifren = sop_wrp | sop_erase | (pop_wrp & wait_nvstr);

   assign   fmw_se = 1'b0;  // not used. read시에는 fmb에서 자동생성.


   // Detection the Data Phase
   assign   data_phase = ((byte_cnt == 2'h3 && cs[ADDR_DUMMY] == 1'b1) ||
						  cs[CLR_COUNTER] == 1'b1 || cs[GET_DATA] == 1'b1 ||
						  cs[DATA_DUMMY] == 1'b1)?
						   1'b1 : 1'b0;
      
   // Address enable For Write
   //   always@(sop_read or scl_lpf or cs or wait_nvstr or
   //		   sop_prog or sop_wrp or protected or sop_erase or
   //		   byte_cnt ) begin
   always@(posedge clk or negedge rstb) begin
	  if(~rstb)    fmw_xe <= 1'b0;
	  else if( sop_read )
		fmw_xe <= 1'b0;
	  else if( wait_nvstr )
		// stop 이후에 5us동안  control signal 유지  
		fmw_xe <= 1'b1;
//	  else if( ((sop_prog & (~protected)) | sop_wrp) &
//			   (cs[ADDR_DUMMY] | cs[CLR_COUNTER] | 
//				cs[GET_DATA] | cs[DATA_DUMMY])
//			   )
		 // stop 나올 때가지
//		fmw_xe <= 1'b1;
	  // xe는 protection이 걸려있어도 active된다.
	  // protection masking은 ye로 수행한다.
	  else if((sop_prog | sop_wrp | sop_erase) &
			  data_phase ) // Stop 나올때까지.
		fmw_xe <= 1'b1;
	  else fmw_xe <= 1'b0;
   end // always@ (sop_read or rpd or scl_lpf or cs or wait_nvstr or...
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) wdata_va <= 1'b0;
	  else if(cs[IDLE]) wdata_va <= 1'b0;
	  else if(cs[DATA_DUMMY] && byte_cnt == 2'h0 && scl_lpf == 1'b1)
		wdata_va <= 1'b1;
   end // always
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fmw_ye <= 1'b0;
	  else if( sop_read )
		fmw_ye <= 1'b0;
	  else if( ((sop_prog & (~protected)) | sop_wrp) & wdata_va) begin
		 if(  cs[GET_DATA] == 1'b1 && byte_cnt == 2'h0 )
		   fmw_ye <= 1'b1;
		 else fmw_ye <= 1'b0;
		 /*
		 if(cs[DATA_DUMMY] == 1'b1 && 
			scl_pe == 1'b1 && byte_cnt == 2'b00)
		   fmw_ye <= 1'b1;
		 else if(cs[GET_DATA] == 1'b1 && bit_cnt == 3'h5)
		   fmw_ye <= 1'b0;
		  */
	  end // if ( ((sop_prog & (~protected)) | sop_wrp) & wdata_va)
	  else fmw_ye <= 1'b0; // at chip erase
   end // always@ (posedge clk or negedge rstb)

   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  fst_ddm <= 1'b0;
	  else if(cs[IDLE]) fst_ddm <= 1'b0;
	  else if(cs[DATA_DUMMY]) fst_ddm <= 1'b1;
   end  // always
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fmw_erase <= 1'b0;
	  else if( sop_erase ) begin // 첫번째 data dummy가 끝날때까지.
		 if(fst_ddm == 1'b0 && data_phase == 1'b1)
		   fmw_erase <= 1'b1;
		 else if(fst_ddm == 1'b1 && cs[GET_DATA] == 1'b1)
		   fmw_erase <= 1'b0;
	  end
	  else fmw_erase <= 1'b0;
   end  // always
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fmw_mas1 <= 1'b0;
	  else if( cs[IDLE] | cs[STOP] )  fmw_mas1 <= 1'b0;
	  else if(sop_erase & data_phase ) // Stop 나올때까지.
		fmw_mas1 <= 1'b1;
   end  // always
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fmw_prog <= 1'b0;
	  else if((sop_prog | sop_wrp) & data_phase) // Stop 나올때까지.
		fmw_prog <= 1'b1;
	  else  fmw_prog <= 1'b0;
   end  // always
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) fmw_nvstr <= 1'b0;
	  else if(sop_erase) begin
		 if(cs[DATA_DUMMY] & byte_cnt == 2'h1)
		   fmw_nvstr <= 1'b1;
		 else if(cs[STOP]) fmw_nvstr <= 1'b0;
	  end
	  else if( ~wait_nvstr & ~fmw_prog )
		// stop 이후에 5us동안  control signal 유지  
		fmw_nvstr <= 1'b0;
	  else if( (sop_prog | sop_wrp) & 
			   cs[GET_DATA] & byte_cnt == 2'h1) // Stop 나올때까지.
		fmw_nvstr <= 1'b1;
   end  // always

   always@(posedge clk or negedge rstb) begin
	  if(~rstb)  wait_nvstr <= 1'b0;
	  else if( (sop_prog | sop_wrp) & cs[GET_DATA] & byte_cnt == 2'h2) // 두번째 data dummy
		wait_nvstr <= 1'b1;
	  else if(cs[ADDR_DUMMY]) wait_nvstr <= 1'b0;
	  else if(cs[IDLE] & cnt0[9]) wait_nvstr <= 1'b0;
   end // always

   assign   fm_wrmode = (sop_prog | sop_prog | sop_erase | 
						 sop_wrp | wait_nvstr)? 1'b1 : 1'b0;

   //-------------------------------------
   // counter for wait_nvstr
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cnt_en <= 1'b0;
	  else if(sst_stop & sop_prog) cnt_en <= 1'b1;
	  else if(cs[ADDR_DUMMY] == 1'b1 | fmw_nvstr == 1'b0)
		cnt_en <= 1'b0;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) cnt0 <= {10{1'b0}};
	  else if(cnt_en == 1'b0)  cnt0 <= {10{1'b0}};
	  else cnt0 <= cnt0 + {10'h001};
   end


   //------------------------------------------------------
   // synopsys translate_off

   wire     sm_idle = cs[IDLE];
   wire     sm_initialize = cs[INITIALIZE];
   wire 	sm_get_addr =	cs[GET_ADDR];
   wire 	sm_addr_dummy = cs[ADDR_DUMMY];
   wire 	sm_clr_counter = cs[CLR_COUNTER];
   wire 	sm_get_data = cs[GET_DATA];
   wire 	sm_data_dummy = cs[DATA_DUMMY];
   wire 	sm_stop = cs[STOP];
   
   // synopsys translate_on
   //------------------------------------------------------

   
endmodule // ifmc_ptsm



