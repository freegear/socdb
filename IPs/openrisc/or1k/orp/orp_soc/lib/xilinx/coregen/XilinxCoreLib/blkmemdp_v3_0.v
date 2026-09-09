/**************************************************************************
 * $Id: blkmemdp_v3_0.v,v 1.1 2002/03/28 20:50:04 lampret Exp $
 **************************************************************************
 * Dual Port Block Memory - Verilog Behavioral Model
 * ************************************************************************
 *  
 * 
 * This File is owned and controlled by Xilinx and must be used solely   
 * for design, simulation, implementation and creation of design files   
 * limited to Xilinx devices or technologies. Use with non-Xilinx        
 * devices or technologies is expressly prohibited and immediately       
 * terminates your license.                                              
 *                                                                       
 * Xilinx products are not intended for use in life support              
 * appliances, devices, or systems. Use in such applications is          
 * expressly prohibited. 
 *
 *        ****************************
 *        ** Copyright Xilinx, Inc. **
 *        ** All rights reserved.   **
 *        ****************************
 *
 *
 *************************************************************************
 * Filename:    BLKMEMDP_V3_0.v
 * 
 * Description: The Verilog behavioral model for the Dual Port Block Memory
 * 
 * ***********************************************************************
 */


`celldefine


`define c_dp_rom 4
`define c_dp_ram 2
`define c_write_first 0
`define c_read_first  1
`define c_no_change   2

module BLKMEMDP_V3_0(DOUTA, DOUTB, ADDRA, CLKA, DINA, ENA, SINITA, WEA, NDA, RFDA, RDYA, ADDRB, CLKB, DINB, ENB, SINITB, WEB,NDB, RFDB, RDYB);



  parameter  c_addra_width         =  11 ;
  parameter  c_addrb_width         =  9 ;
  parameter  c_default_data        = "0"; // indicates string of hex characters used to initialize memory
  parameter  c_depth_a             = 2048 ;
  parameter  c_depth_b             = 512 ;
  parameter  c_enable_rlocs        = 0 ; //  core includes placement constraints
  parameter  c_has_default_data    =  1;
  parameter  c_has_dina            = 1  ;  // indicate port A has data input pins
  parameter  c_has_dinb            = 1  ;  // indicate port B has data input pins
  parameter  c_has_douta           = 1 ; // indicates port A has  output
  parameter  c_has_doutb           = 1 ; // indicates port B has  output
  parameter  c_has_ena             =  1 ; // indicates port A has a ENA pin
  parameter  c_has_enb             =  1 ; // indicates port B has a ENB pin
  parameter  c_has_limit_data_pitch       = 1 ;
  parameter  c_has_nda             = 0 ; //  Port A has a new data pin
  parameter  c_has_ndb             = 0 ; //  Port B has a new data pin
  parameter  c_has_rdya            = 0 ; //  Port A has result ready pin
  parameter  c_has_rdyb            = 0 ; //  Port B has result ready pin
  parameter  c_has_rfda            = 0 ; //  Port A has ready for data pin
  parameter  c_has_rfdb            = 0 ; //  Port B has ready for data pin
  parameter  c_has_sinita          =  1 ; // indicates port A has a SINITA pin
  parameter  c_has_sinitb          =  1 ; // indicates port B has a SINITB pin
  parameter  c_has_wea             =  1 ; // indicates port A has a WEA pin
  parameter  c_has_web             =  1 ; // indicates port B has a WEB pin
  parameter  c_limit_data_pitch           = 16 ;
  parameter  c_mem_init_file     =  "null.mif";  // controls which .mif file used to initialize memory
  parameter  c_pipe_stages_a       =  0 ; // indicates the number of pipe stages needed in port A
  parameter  c_pipe_stages_b       =  0 ; // indicates the number of pipe stages needed in port B
  parameter  c_reg_inputsa         = 0 ; // indicates we, addr, and din of port A are registered
  parameter  c_reg_inputsb         = 0 ; // indicates we, addr, and din of port B are registered
  parameter  c_sinita_value        = "0000"; // indicates string of hex used to initialize A output registers
  parameter  c_sinitb_value        = "0000"; // indicates string of hex used to initialize B output resisters
  parameter  c_width_a             =  8 ;
  parameter  c_width_b             = 32 ;
  parameter  c_write_modea        = 2; // controls which write modes shall be used
  parameter  c_write_modeb        = 2; // controls which write modes shall be used

  
 

// IO ports



    output [c_width_a-1:0] DOUTA;

    input [c_addra_width-1:0] ADDRA;
    input [c_width_a-1:0] DINA;
    input ENA, CLKA, WEA, SINITA, NDA;
    output RFDA, RDYA;

    output [c_width_b-1:0] DOUTB;

    input [c_addrb_width-1:0] ADDRB;
    input [c_width_b-1:0] DINB;
    input ENB, CLKB, WEB, SINITB, NDB;
    output RFDB, RDYB;


// internal signals

    reg [c_width_a-1:0] douta_mux_out ; // output of multiplexer --
    wire [c_width_a-1:0] DOUTA = douta_mux_out;
    reg  RFDA, RDYA ;

    reg [c_width_b-1:0] doutb_mux_out ; // output of multiplexer --
    wire [c_width_b-1:0] DOUTB = doutb_mux_out;
    reg RFDB, RDYB;


    reg [c_width_a-1:0] douta_out_q; // registered output of douta_out
    reg [c_width_a-1:0] doa_out;  // output of Port A RAM
    reg [c_width_a-1:0] douta_out; // output of pipeline mux for port A

    reg [c_width_b-1:0] doutb_out_q ; // registered output for doutb_out
    reg [c_width_b-1:0] dob_out; // output of Port B RAM
    reg [c_width_b-1:0] doutb_out ; // output of pipeline mux for port B

    reg [c_depth_a*c_width_a-1 : 0] mem; 
    reg [24:0] count ;
    reg [1:0] wr_mode_a, wr_mode_b;

    reg [(c_width_a-1) : 0]  pipelinea [0 : c_pipe_stages_a];
    reg [(c_width_b-1) : 0]  pipelineb [0 : c_pipe_stages_b];
    reg sub_rdy_a[0 : c_pipe_stages_a];
    reg sub_rdy_b[0 : c_pipe_stages_b];

    reg [10:0] ci, cj;
    reg [10:0] dmi, dmj, dni, dnj, doi, doj, dai, daj, dbi, dbj, dci, dcj, ddi, ddj;
    reg [10:0] pmi, pmj, pni, pnj, poi, poj, pai, paj, pbi, pbj, pci, pcj, pdi, pdj;
    integer ai, aj, ak, al, am, an, ap ;
    integer bi, bj, bk, bl, bm, bn, bp ;
    integer i, j, k, l, m, n, p; 

    wire [c_addra_width-1:0] addra_i = ADDRA;
    reg [c_width_a-1:0] dia_int ;
    reg [c_width_a-1:0] dia_q ;
    wire [c_width_a-1:0] dia_i ;
    wire ena_int  ;
    reg ena_q ;
    wire clka_int = CLKA  ;
    reg wea_int  ;
    wire wea_i  ;
    reg wea_q ;
    wire ssra_int  ;
    wire nda_int ;
    wire nda_i ;
    reg rfda_int ;
    reg rdya_int ;
    reg nda_q ;
    reg new_data_a ;
    reg new_data_a_q ;
    reg [c_addra_width-1:0] addra_q;
    reg [c_addra_width-1:0] addra_int;
    reg [c_width_a-1:0] sinita_value ; // initialization value for output registers of Port A

    wire [c_addrb_width-1:0] addrb_i = ADDRB;
    reg [c_width_b-1:0] dib_int ;
    reg [c_width_b-1:0] dib_q ;
    wire [c_width_b-1:0] dib_i ;
    wire enb_int ;
    reg enb_q ;
    wire clkb_int = CLKB  ;
    reg web_int  ;
    wire web_i ;
    reg web_q ;
    wire ssrb_int  ;
    wire ndb_int ;
    wire ndb_i ;
    reg rfdb_int ;
    reg rdyb_int ;
    reg ndb_q ;
    reg new_data_b ;
    reg new_data_b_q ;
    reg [c_addrb_width-1:0] addrb_q ;
    reg [c_addrb_width-1:0] addrb_int ;
    reg [c_width_b-1:0] sinitb_value ; // initialization value for output registers of Port B

//  variables used to initialize memory contents to default values.

    reg [c_width_a-1:0] bitval ;
    reg [c_width_a-1:0] ram_temp [0:c_depth_a-1] ;
    reg [c_width_a-1:0] default_data ;

//  variables used to detect address collision on dual port Rams

    reg recovery_a, recovery_b;
    reg address_collision;    

    wire clka_enable = ena_int && wea_int && enb_int && address_collision;
    wire clkb_enable = enb_int && web_int && ena_int && address_collision;
    wire collision = clka_enable || clkb_enable;

//   tri0 GSR = glbl.GSR;

    assign dia_i    = (c_has_dina === 1)?DINA:'b0;
    assign ena_int  = defval(ENA, c_has_ena, 1);
    assign ssra_int = defval( SINITA , c_has_sinita , 0);
    assign nda_i  = defval( NDA, c_has_nda, 1);
    assign dib_i    = (c_has_dinb === 1)?DINB:'b0;
    assign enb_int  = defval(ENB, c_has_enb, 1);
    assign ssrb_int = defval( SINITB, c_has_sinitb, 0);
    assign ndb_i = defval( NDB, c_has_ndb, 1);

// RAM/ROM functionality

    assign wea_i = (c_has_wea == 1)  ? WEA:1'b0 ;
    assign web_i = (c_has_web == 1)  ? WEB:1'b0 ;



    function defval;
      input i;
      input hassig;
      input val;
            begin
                   if(hassig == 1)
                           defval = i;
                   else
                           defval = val;
            end
    endfunction

    function max;
      input a;
      input b;
        begin
                max = (a > b) ? a : b;
        end
    endfunction

    function a_is_X;
      input [c_width_a-1 : 0] i;
      integer j ;
        begin
                a_is_X = 1'b0;
                for(j = 0; j < c_width_a; j = j + 1)
                begin
                        if(i[j] === 1'bx)
                                a_is_X = 1'b1;
                end // loop
        end
    endfunction
 
    function b_is_X;
      input [c_width_b-1 : 0] i;
      integer j ;
        begin
                b_is_X = 1'b0;
                for(j = 0; j < c_width_b; j = j + 1)
                begin
                        if(i[j] === 1'bx)
                                b_is_X = 1'b1;
                end // loop
        end
    endfunction

  function [c_width_a-1:0] hexstr_conv;
    input [(c_width_a*8)-1:0] def_data;
 
    integer index,i,j;
    reg [3:0] bin;
 
    begin
      index = 0;
      hexstr_conv = 'b0;
      for( i=c_width_a-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 :
          begin
            bin = 4'b0000;
            i = -1;
          end
          8'b00110000 : bin = 4'b0000;
          8'b00110001 : bin = 4'b0001;
          8'b00110010 : bin = 4'b0010;
          8'b00110011 : bin = 4'b0011;
          8'b00110100 : bin = 4'b0100;
          8'b00110101 : bin = 4'b0101;
          8'b00110110 : bin = 4'b0110;
          8'b00110111 : bin = 4'b0111;
          8'b00111000 : bin = 4'b1000;
          8'b00111001 : bin = 4'b1001;
          8'b01000001 : bin = 4'b1010;
          8'b01000010 : bin = 4'b1011;
          8'b01000011 : bin = 4'b1100;
          8'b01000100 : bin = 4'b1101;
          8'b01000101 : bin = 4'b1110;
          8'b01000110 : bin = 4'b1111;
          8'b01100001 : bin = 4'b1010;
          8'b01100010 : bin = 4'b1011;
          8'b01100011 : bin = 4'b1100;
          8'b01100100 : bin = 4'b1101;
          8'b01100101 : bin = 4'b1110;
          8'b01100110 : bin = 4'b1111;
          default :
          begin
            $display("ERROR : NOT A HEX CHARACTER");
            bin = 4'bx;
          end
        endcase
        for( j=0; j<4; j=j+1)
        begin
          if ((index*4)+j < c_width_a)
          begin
            hexstr_conv[(index*4)+j] = bin[j];
          end
        end
        index = index + 1;
        def_data = def_data >> 8;
      end
    end
  endfunction

  function [c_width_b-1:0] hexstr_conv_b;
    input [(c_width_b*8)-1:0] def_data;
 
    integer index,i,j;
    reg [3:0] bin;
 
    begin
      index = 0;
      hexstr_conv_b = 'b0;
      for( i=c_width_b-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 :
          begin
            bin = 4'b0000;
            i = -1;
          end
          8'b00110000 : bin = 4'b0000;
          8'b00110001 : bin = 4'b0001;
          8'b00110010 : bin = 4'b0010;
          8'b00110011 : bin = 4'b0011;
          8'b00110100 : bin = 4'b0100;
          8'b00110101 : bin = 4'b0101;
          8'b00110110 : bin = 4'b0110;
          8'b00110111 : bin = 4'b0111;
          8'b00111000 : bin = 4'b1000;
          8'b00111001 : bin = 4'b1001;
          8'b01000001 : bin = 4'b1010;
          8'b01000010 : bin = 4'b1011;
          8'b01000011 : bin = 4'b1100;
          8'b01000100 : bin = 4'b1101;
          8'b01000101 : bin = 4'b1110;
          8'b01000110 : bin = 4'b1111;
          8'b01100001 : bin = 4'b1010;
          8'b01100010 : bin = 4'b1011;
          8'b01100011 : bin = 4'b1100;
          8'b01100100 : bin = 4'b1101;
          8'b01100101 : bin = 4'b1110;
          8'b01100110 : bin = 4'b1111;
          default :
          begin
            $display("ERROR : NOT A HEX CHARACTER");
            bin = 4'bx;
          end
        endcase
        for( j=0; j<4; j=j+1)
        begin
          if ((index*4)+j < c_width_b)
          begin
            hexstr_conv_b[(index*4)+j] = bin[j];
          end
        end
        index = index + 1;
        def_data = def_data >> 8;
      end
    end
  endfunction





//  Initialize memory contents to 0 for now . 

    initial begin

        sinita_value = 'b0 ;
        sinitb_value = 'b0 ;

             default_data = hexstr_conv(c_default_data);
        if (c_has_sinita == 1 )
             sinita_value = hexstr_conv(c_sinita_value);
        if (c_has_sinitb == 1 ) 
             sinitb_value = hexstr_conv_b(c_sinitb_value);
            for(i = 0; i < c_depth_a; i = i + 1)
              ram_temp[i] = default_data;
       if (c_has_default_data == 0)
          $readmemb(c_mem_init_file, ram_temp) ;

        for(i = 0; i < c_depth_a; i = i + 1)
           for(j = 0; j < c_width_a; j = j + 1)
              begin
                 bitval = (1'b1 << j);
                 mem[(i*c_width_a) + j] = (ram_temp[i] & bitval) >> j;
              end
        recovery_a = 0;
        recovery_b = 0;
        for (k = 0; k <= c_pipe_stages_a; k = k + 1)
            pipelinea[k] = sinita_value ;
        for (l = 0; l <= c_pipe_stages_b; l = l + 1)
            pipelineb[l] = sinitb_value ;
        for (m = 0; m <= c_pipe_stages_a; m = m + 1)
            sub_rdy_a[m] = 0 ;
        for (n = 0; n <= c_pipe_stages_b; n = n + 1) 
            sub_rdy_b[n] = 0 ;
        doa_out = sinita_value ;
        dob_out = sinitb_value ;
        nda_q = 0;
        ndb_q = 0;
        new_data_a_q = 0 ;
        new_data_b_q = 0 ;
        dia_q = 0;
        dib_q = 0;
        addra_q = 0;
        addrb_q = 0;
        wea_q   = 0;
        web_q   = 0;
    end


    always @(addra_int or addrb_int) begin  //  check address collision
	address_collision <= 1'b0;
	for (ci = 0; ci < c_width_a; ci = ci + 1) begin // absolute address A
	    for (cj = 0; cj < c_width_b; cj = cj + 1) begin // absolute address B
		if ((addra_int * c_width_a + ci) == (addrb_int * c_width_b + cj)) begin
		    address_collision <= 1'b1;
		end
	    end
	end
    end

    // Data
    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b01) && (wr_mode_b == 2'b01)) ||
	    ((wr_mode_a != 2'b01) && (wr_mode_b != 2'b01))) begin
	    if (wea_int == 1 && web_int == 1) begin
              if (addra_int < c_depth_a)
		for (dmi = 0; dmi < c_width_a; dmi = dmi + 1) begin
		    for (dmj = 0; dmj < c_width_b; dmj = dmj + 1) begin
			if ((addra_int * c_width_a + dmi) == (addrb_int * c_width_b + dmj)) begin
			    mem[addra_int * c_width_a + dmi] <= 1'bX;
			end
		    end
		end
              else
                $display("Warning : Memory out of range");
	    end
	end
	recovery_a <= 0;
        recovery_b <= 0;
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a == 2'b01) && (wr_mode_b != 2'b01)) begin
	    if (wea_int == 1 && web_int == 1) begin
              if (addra_int < c_depth_a)
		for (dni = 0; dni < c_width_a; dni = dni + 1) begin
		    for (dnj = 0; dnj < c_width_b; dnj = dnj + 1) begin
			if ((addra_int * c_width_a + dni) == (addrb_int * c_width_b + dnj)) begin
			    mem[addra_int * c_width_a + dni] <= dia_int[dni];
			end
		    end
		end
              else
                $display("Warning : Memory out of range");
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a != 2'b01) && (wr_mode_b == 2'b01)) begin
	    if (wea_int == 1 && web_int == 1) begin
              if (addrb_int < c_depth_b)
		for (doi = 0; doi < c_width_a; doi = doi + 1) begin
		    for (doj = 0; doj < c_width_b; doj = doj + 1) begin
			if ((addra_int * c_width_a + doi) == (addrb_int * c_width_b + doj)) begin
			    mem[addrb_int * c_width_b + doj] <= dib_int[doj];
			end
		    end
		end
              else
                $display("Warning : Memory out of range");
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_b == 2'b00) || (wr_mode_b == 2'b10)) begin
	    if ((wea_int == 0) && (web_int == 1) && (ssra_int == 0)) begin
              if (addra_int < c_depth_a)
		for (dai = 0; dai < c_width_a; dai = dai + 1) begin
		    for (daj = 0; daj < c_width_b; daj = daj + 1) begin
			if ((addra_int * c_width_a + dai) == (addrb_int * c_width_b + daj)) begin
			    doa_out[dai] <= 1'bX;
			end
		    end
		end
              else
                $display("Warning : Memory out of range");
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if ((wr_mode_a == 2'b00) || (wr_mode_a == 2'b10)) begin
	    if ((wea_int == 1) && (web_int == 0) && (ssrb_int == 0)) begin
              if (addrb_int < c_depth_b)
		for (dbi = 0; dbi < c_width_a; dbi = dbi + 1) begin
		    for (dbj = 0; dbj < c_width_b; dbj = dbj + 1) begin
			if ((addra_int * c_width_a + dbi) == (addrb_int * c_width_b + dbj)) begin
			    dob_out[dbj] <= 1'bX;
			end
		    end
		end
              else
                $display("Warning : Memory out of range");
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b00) && (wr_mode_b == 2'b00)) ||
	    ((wr_mode_a != 2'b10) && (wr_mode_b == 2'b10)) ||
	    ((wr_mode_a == 2'b01) && (wr_mode_b == 2'b00))) begin
	    if ((wea_int == 1) && (web_int == 1) && (ssra_int == 0)) begin
              if (addra_int < c_depth_a)
		for (dci = 0; dci < c_width_a; dci = dci + 1) begin
		    for (dcj = 0; dcj < c_width_b; dcj = dcj + 1) begin
			if ((addra_int * c_width_a + dci) == (addrb_int * c_width_b + dcj)) begin
			    doa_out[dci] <= 1'bX;
			end
		    end
		end
              else
                $display("Warning : Memory out of range");
	    end
	end
    end

    always @(posedge recovery_a or posedge recovery_b) begin
	if (((wr_mode_a == 2'b00) && (wr_mode_b == 2'b00)) ||
	    ((wr_mode_a == 2'b10) && (wr_mode_b != 2'b10)) ||
	    ((wr_mode_a == 2'b00) && (wr_mode_b == 2'b01))) begin
	    if ((wea_int == 1) && (web_int == 1) && (ssrb_int == 0)) begin
              if (addrb_int < c_depth_b)
		for (ddi = 0; ddi < c_width_a; ddi = ddi + 1) begin
		    for (ddj = 0; ddj < c_width_b; ddj = ddj + 1) begin
			if ((addra_int * c_width_a + ddi) == (addrb_int * c_width_b + ddj)) begin
			    dob_out[ddj] <= 1'bX;
			end
		    end
		end
              else
                $display("Warning : Memory out of range");
	    end
	end
    end

 //   Parity Section is deleted

    initial begin
	case (c_write_modea)
	    `c_write_first : wr_mode_a <= 2'b00;
	    `c_read_first  : wr_mode_a <= 2'b01;
	    `c_no_change   : wr_mode_a <= 2'b10;
	    default       : begin
				$display("Error : c_write_modea = %s is not WRITE_FIRST, READ_FIRST or NO_CHANGE.", c_write_modea);
				$finish;
			    end
	endcase
    end

    initial begin
	case (c_write_modeb)
	    `c_write_first : wr_mode_b <= 2'b00;
	    `c_read_first  : wr_mode_b <= 2'b01;
	    `c_no_change   : wr_mode_b <= 2'b10;
	    default       : begin
				$display("Error : c_write_modeb = %s is not WRITE_FIRST, READ_FIRST or NO_CHANGE.", c_write_modeb);
				$finish;
			    end
	endcase
    end

// Port A


// Generate ouput control signals for Port A: RFDA and RDYA
   
    always @ (rfda_int or rdya_int)
    begin
       if (c_has_rfda == 1)
          RFDA = rfda_int ;
       else
          RFDA = 1'b0 ;
      
       if ((c_has_rdya == 1) && (c_has_nda == 1) && (c_has_rfda == 1) )
          RDYA  = rdya_int;
       else
          RDYA  = 1'b0 ;
    end

    always @ (ena_int )
    begin
       if (ena_int == 1'b1)
          rfda_int <= 1'b1 ;
       else
          rfda_int <= 1'b0 ;
    end

// Gate nd signal with en     

   assign nda_int = ena_int && nda_i ;

// Register hanshaking signals for port A

    always @ (posedge clka_int)
    begin
       if (ena_int == 1'b1)
          begin
              if (ssra_int == 1'b1)
                 nda_q <= 1'b0 ;
              else
                 nda_q <= nda_int ;
          end
       else
          nda_q  <= nda_q ;  
    end

// Register data/ address / we inputs for port A

    always @ (posedge clka_int)
    begin
      if (ena_int == 1'b1)
         begin
          dia_q  <= dia_i ;
          addra_q <= addra_i ;
          wea_q  <= wea_i ;
      end
    end


// Select registered or non-registered write enable for Port A

   always @ ( wea_i or wea_q )
   begin
      if (c_reg_inputsa == 1)
         wea_int = wea_q ;
      else
         wea_int = wea_i ;
   end

// Select registered or non-registered  data/address/nd inputs for Port A

    always @ ( dia_i or dia_q )
    begin
         if ( c_reg_inputsa == 1)
            dia_int = dia_q;
         else
            dia_int = dia_i;
    end

    always @ ( addra_i or addra_q or nda_q or nda_int )
    begin
         if ( c_reg_inputsa == 1)
            begin
                addra_int = addra_q ;
                new_data_a = nda_q ;
            end
         else
            begin
                addra_int = addra_i;
                new_data_a = nda_int ;
            end
    end

// Register the new_data signal for Port A to track the synchronous RAM output

    always @(posedge clka_int)
       begin
          if (ena_int == 1'b1)
             begin
                if (ssra_int == 1'b1)
                   new_data_a_q <= 1'b0 ;
                else
                   new_data_a_q <= new_data_a ;
             end
       end

// Generate data outputs for Port A

    always @(posedge clka_int) begin
	if (ena_int == 1'b1) begin
	    if (ssra_int == 1'b1) begin
                for ( ai = 0; ai < c_width_a; ai = ai + 1)
                    doa_out[ai] <= sinita_value[ai];
	    end
	    else begin
		if (wea_int == 1'b1) begin
		    if (wr_mode_a == 2'b00) begin
                      if (addra_int < c_depth_a)
                        for ( aj = 0; aj < c_width_a; aj = aj + 1)
                            doa_out[aj] <= dia_int[aj] ;
                      else
                        $display("Warning : Memory out of range");
		    end
		    else if (wr_mode_a == 2'b01) begin
                      if (addra_int < c_depth_a)
                        for ( ak = 0; ak < c_width_a; ak = ak + 1)
                            doa_out[ak] <= mem[(addra_int*c_width_a) + ak];
                      else
                        $display("Warning : Memory out of range");
		    end
		    else begin
                      if (addra_int < c_depth_a)
                        doa_out <= doa_out;
                      else
                        $display("Warning : Memory out of range");
		    end
		end
		else begin
                  if (addra_int < c_depth_a)
                    for ( al = 0; al < c_width_a; al = al + 1)
                        doa_out[al]  <= mem[(addra_int*c_width_a) + al];
                  else
                    $display("Warning : Memory out of range");
		end
	    end
	end
    end

    always @(posedge clka_int) begin
	if (ena_int == 1'b1 && wea_int == 1'b1) begin
          if (addra_int < c_depth_a)
            for ( am = 0; am < c_width_a; am = am + 1)
                mem[(addra_int*c_width_a) + am] <= dia_int[am];
          else
            $display("Warning : Memory out of range");
	end
    end

    //  output pipelines for Port A

   always @(posedge clka_int) begin
       if (ena_int == 1'b1)
         begin
             for (i = c_pipe_stages_a; i > 1; i = i -1 )
               begin
                  if (ssra_int == 1'b1 && ena_int == 1'b1 )
                     begin
                      pipelinea[i] <= sinita_value ;
                      sub_rdy_a[i]   <= 0 ;
                     end
                  else
                     begin
                      pipelinea[i] <= pipelinea[i-1] ;
                      sub_rdy_a[i] <= sub_rdy_a[i-1] ;
                     end
               end
             if (ssra_int == 1'b1 && ena_int == 1'b1 )
                begin
                  pipelinea[1]<= sinita_value ;
                  sub_rdy_a[1] <= 0 ;
                end
             else
                begin
                 pipelinea[1] <= doa_out ;
                 sub_rdy_a[1]  <= new_data_a_q ;
             end
       end
   end

// Select pipeline output if c_pipe_stages_a > 0

   always @( pipelinea[c_pipe_stages_a] or sub_rdy_a[c_pipe_stages_a] or new_data_a_q or doa_out ) begin
          if (c_pipe_stages_a == 0 )
             begin 
                douta_out = doa_out ;
                rdya_int  = new_data_a_q;
             end
          else
             begin
                douta_out = pipelinea[c_pipe_stages_a];
                rdya_int  = sub_rdy_a[c_pipe_stages_a];
             end
   end

 
 // Select Port A data outputs based on c_has_douta parameter
 
  always @( douta_out ) begin
         if ( c_has_douta == 1)
            douta_mux_out = douta_out ;
         else
            douta_mux_out = 0 ;
  end
 
 

// Port B



// Generate output control signals for Port B: RFDB and RDYB
   
    always @ (rfdb_int or rdyb_int)
    begin
       if (c_has_rfdb == 1)
          RFDB = rfdb_int ;
       else
          RFDB = 1'b0 ;

       if ((c_has_rdyb == 1) && (c_has_ndb == 1) && (c_has_rfdb == 1) )
          RDYB  = rdyb_int;
       else
          RDYB  = 1'b0 ;
    end

    always @ (enb_int )
    begin
        if ( enb_int == 1'b1 )
           rfdb_int = 1'b1 ;
        else
          rfdb_int  = 1'b0 ;
    end

// Gate nd signal with en

   assign ndb_int = enb_int && ndb_i ;

// Register hanshaking signals for port B

    always @ (posedge clkb_int)
    begin
       if (enb_int == 1'b1)
          begin
             if (ssrb_int == 1'b1)
                 ndb_q <= 1'b0 ;
             else
                 ndb_q   <=  ndb_int ;
          end
       else
          ndb_q <=  ndb_q;
    end

// Register data / address / we  inputs for port B

    always @ (posedge clkb_int)
    begin
      if (enb_int == 1'b1)
         begin
           dib_q  <= dib_i ;
           addrb_q <= addrb_i ;
           web_q  <= web_i ;
         end
    end

// Select registered or non-registered write enable for port B

   always @ (web_i or web_q )
   begin
      if (c_reg_inputsb == 1)
         web_int = web_q ;
      else
         web_int = web_i ;
   end


 
// Select registered or non-registered  data/address/nd inputs for Port B
 
    always @ ( dib_i or dib_q )
    begin
         if ( c_reg_inputsb == 1)
            dib_int = dib_q;
         else
            dib_int = dib_i;
    end
 
    always @ ( addrb_i or addrb_q or  ndb_q or ndb_int)
    begin
         if ( c_reg_inputsb == 1)
            begin
                addrb_int = addrb_q ;
                new_data_b = ndb_q ;
            end
         else
            begin
                addrb_int = addrb_i;
                new_data_b = ndb_int ;
            end
    end

// Register the new_data signal for Port B to track the synchronous RAM output
 
    always @(posedge clkb_int)
       begin
         if (enb_int == 1'b1 )
            begin
              if (ssrb_int == 1'b1)
                 new_data_b_q <= 1'b0 ;
              else
                 new_data_b_q <= new_data_b ;
            end 
       end





// Generate data outputs for Port B

    always @(posedge clkb_int) begin
	if (enb_int == 1'b1) begin
	    if (ssrb_int == 1'b1) begin
                for (bi = 0; bi < c_width_b; bi = bi + 1)
                    dob_out[bi]  <= sinitb_value[bi];
	    end
	    else begin
		if (web_int == 1'b1) begin
		    if (wr_mode_b == 2'b00) begin
                      if (addrb_int < c_depth_b)
                        for (bj = 0; bj < c_width_b; bj = bj + 1)
                            dob_out[bj] <= dib_int[bj];
                      else
                        $display("Warning : Memory out of range");
		    end
		    else if (wr_mode_b == 2'b01) begin
                      if (addrb_int < c_depth_b)
                         for (bk = 0; bk < c_width_b; bk = bk + 1)
                             dob_out[bk] <= mem[(addrb_int*c_width_b) + bk];
                      else
                        $display("Warning : Memory out of range");
		    end
		    else begin
                      if (addrb_int < c_depth_b)
                         dob_out  <= dob_out ;
                      else
                        $display("Warning : Memory out of range");
		    end
		end
		else begin
                  if (addrb_int < c_depth_b)
                     for (bl = 0; bl < c_width_b; bl = bl + 1)
                         dob_out[bl] <= mem[(addrb_int*c_width_b) + bl];
                  else
                    $display("Warning : Memory out of range");
		end
	    end
	end
    end

    always @(posedge clkb_int) begin
	if (enb_int == 1'b1 && web_int == 1'b1) begin
          if (addrb_int < c_depth_b)
            for (bm = 0; bm < c_width_b; bm = bm + 1)
                 mem[(addrb_int*c_width_b) + bm]  <= dib_int[bm];
          else
            $display("Warning : Memory out of range");
	end
    end

  //  output pipelines for Port B

    always @(posedge clkb_int) begin
      if (enb_int == 1'b1)
         begin
              for (j = c_pipe_stages_b; j > 1; j = j -1 )
                begin
                  if (ssrb_int == 1'b1 && enb_int == 1'b1 )
                     begin
                       pipelineb[j] <= sinitb_value ;
                       sub_rdy_b[j] <= 0 ;
                     end
                  else
                     begin
                        pipelineb[j] <= pipelineb[j-1] ;
                        sub_rdy_b[j] <= sub_rdy_b[j-1] ;
                     end
                end
              if (ssrb_int == 1'b1 && enb_int == 1'b1)
                 begin
                    pipelineb[1] <= sinitb_value ;
                    sub_rdy_b[1]   <=  0 ;
                 end
              else
                 begin
                   pipelineb[1] <= dob_out ;
                   sub_rdy_b[1] <= new_data_b_q ;
                 end
         end
   end

// Select pipeline for B if c_pipe_stages_b > 0

    always @(pipelineb[c_pipe_stages_b] or sub_rdy_b[c_pipe_stages_b] or new_data_b_q or dob_out) begin
           if ( c_pipe_stages_b == 0 )
              begin
               doutb_out = dob_out ;
               rdyb_int = new_data_b_q;
              end
           else
              begin
               rdyb_int   = sub_rdy_b[c_pipe_stages_b];
               doutb_out  = pipelineb[c_pipe_stages_b];
              end
    end

 
// Select Port B data outputs based on c_has_doutb parameter
 
   always @(   doutb_out) begin
          if ( c_has_doutb == 1)
             doutb_mux_out = doutb_out ;
          else
             doutb_mux_out = 0 ;
   end
 

 


    specify
	$recovery (posedge CLKB, posedge CLKA &&& collision, 1, recovery_b);
	$recovery (posedge CLKA, posedge CLKB &&& collision, 1, recovery_a);
    endspecify

endmodule

`endcelldefine
