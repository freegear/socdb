module tb_staticregif;

reg			RESETn;
reg			CLK;


reg			CS;
reg	[6:0]	EXT_BK_ADDR;
reg	[7:0]	EXT_SFR_DOUT;
reg			EXT_SFR_WR;
wire	[7:0]	EXT_SFR_DIN;

wire			card_ecc_disabled;
wire			card_ecc_failed;
reg	[15:0]	dsr;			
//wire			hreset_b;
wire	[127:0]	pwdin;	
wire	[7:0]	pwd_len;
wire	[2:0]	rd_thd;

wire	[127:0]	cid;					
wire	[127:0]	csd;				
wire	[7:0]	ecsd_a;
wire	[31:0]	ecsd_b;
wire	[7:0]	ecsd_c;
wire	[7:0]	ecsd_d;
wire	[7:0]	ecsd_e;
wire	[7:0]	ecsd_f;
wire	[7:0]	ecsd_g;
wire	[7:0]	ecsd_h;
wire	[7:0]	ecsd_i;
wire	[7:0]	ecsd_j;
wire	[7:0]	ecsd_k;
wire	[7:0]	ecsd_l;
wire	[7:0]	ecsd_m;
wire	[7:0]	ecsd_n;
wire	[7:0]	ecsd_o;
wire	[7:0]	ecsd_p;
wire	[7:0]	ecsd_q;
reg	[7:0]	ecsd_r;
reg	[7:0]	ecsd_s;
wire	[31:0] 	ocr_mem;	
wire	[63:0] 	scr;


initial
begin
	RESETn = 0;
	CLK = 0;
	CS = 0;
	EXT_BK_ADDR = 0;
	EXT_SFR_WR = 0;
	EXT_SFR_DOUT = 0;

end


always #5 CLK = ~CLK;

initial
begin
	#1000
	RESETn = 1;
	CS =1;
	EXT_BK_ADDR	= 7'h01;
	EXT_SFR_DOUT = 8'hff;
	@(posedge CLK)
	#1 EXT_SFR_WR = 1;
	@(posedge CLK)
	#1 EXT_SFR_WR = 0;	
end



staticregif streg
(
	.RESETn				(RESETn				),
	.CLK				(CLK				),
                                            
	.CS					(CS					),
	.EXT_BK_ADDR		(EXT_BK_ADDR		),
	.EXT_SFR_DOUT		(EXT_SFR_DOUT		),
	.EXT_SFR_WR			(EXT_SFR_WR			),
	.EXT_SFR_DIN		(EXT_SFR_DIN		),
                                            
	.card_ecc_disabled	(card_ecc_disabled	),
	.card_ecc_failed	(card_ecc_failed	),
                                            
	.dsr				(dsr				),  		
	.pwdin				(pwdin				),  
	.pwd_len			(pwd_len			),
	.rd_thd				(rd_thd				),
                                            
	.cid				(cid				),					
	.csd				(csd				),				
	.ecsd_a				(ecsd_a				),
	.ecsd_b				(ecsd_b				),
	.ecsd_c				(ecsd_c				),
	.ecsd_d				(ecsd_d				),
	.ecsd_e				(ecsd_e				),
	.ecsd_f				(ecsd_f				),
	.ecsd_g				(ecsd_g				),
	.ecsd_h				(ecsd_h				),
	.ecsd_i				(ecsd_i				),
	.ecsd_j				(ecsd_j				),
	.ecsd_k				(ecsd_k				),
	.ecsd_l				(ecsd_l				),
	.ecsd_m				(ecsd_m				),
	.ecsd_n				(ecsd_n				),
	.ecsd_o				(ecsd_o				),
	.ecsd_p				(ecsd_p				),
	.ecsd_q				(ecsd_q				),
	.ecsd_r				(ecsd_r				),
	.ecsd_s				(ecsd_s				),
	.ocr_mem			(ocr_mem			),
	.scr				(scr				)
);



endmodule
