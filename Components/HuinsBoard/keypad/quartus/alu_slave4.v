
module alu_slave4(
	HCLOCK,
	HSEL,
	HRESETn,
	HWRITE,
	HADDRESS,
	HBURST,
	HSIZE,
	HTRANS,
	HWDATA,
	HREADY,
	HRDATA,
	HRESP,
	testout,
	DATA_AVAIL  ,
        DATA_A          ,
        DATA_B          ,
        DATA_C          ,
        DATA_D          ,
	Int_PLD
);

input	HCLOCK;
input	HSEL;
input	HRESETn;
input	HWRITE;
input	[31:0] HADDRESS;
input	[2:0] HBURST;
input	[1:0] HSIZE;
input	[1:0] HTRANS;
input	[31:0] HWDATA;

input DATA_AVAIL  ;    
input DATA_A      ; 
input DATA_B      ; 
input DATA_C      ; 
input DATA_D      ; 


output	HREADY;
output	[31:0] HRDATA;
output	[1:0] HRESP;
output  [7:0] testout;
output        Int_PLD ;



wire	[31:0] reg_address;
wire	[31:0] reg_wdata;

wire	wait_sig;
wire	[31:0] reg_rdata;
wire	reg_write;
wire	clock_en;
wire	[31:0] result_high;
wire	[31:0] result_low;
wire           Hready_i  ;


ahb_slave_sm2	ahb_slave_sm2(
                                 .HSEL        (HSEL),
                                 .HWRITE      (HWRITE),
                                 .HRESETn     (HRESETn),
                                 .HCLOCK      (HCLOCK),
                                 .wait_sig    (Hready_i),
                                 .HADDRESS    (HADDRESS),
                                 .HBURST      (HBURST),
                                 .HSIZE       (HSIZE),
                                 .HTRANS      (HTRANS),
                                 .HWDATA      (HWDATA),
                                 .reg_rdata   (reg_rdata),
                                 .reg_write   (reg_write),
                                 .HREADY      (HREADY),
                                 .HRDATA      (HRDATA),
                                 .HRESP       (HRESP),
                                 .reg_address (reg_address),
                                 .reg_wdata   (reg_wdata)
                                 );

key_state  key_state
                        (
                          .reset       (HRESETn    ),
                          .clock       (HCLOCK     ),
                          .DATA_AVAIL  (DATA_AVAIL),     
                          .DATA_A      (DATA_A    ),     
                          .DATA_B      (DATA_B    ),     
                          .DATA_C      (DATA_C    ),     
                          .DATA_D      (DATA_D    ),
                          .address     (HADDRESS  ),
                          .write       (HWRITE    ),
                          .read_data   (reg_rdata ),
                          .Int_reg     (Int_reg   ),
                          .Hready_i    (Hready_i  )
                          );

assign testout[7:0] = reg_wdata[7:0];
assign Int_PLD = Int_reg ;
endmodule
