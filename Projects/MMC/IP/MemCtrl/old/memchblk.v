module memchblk
(
//	RESETn,
	CLK,
//	sdclk,

	MMC_CEn0,
	MMC_CEn1,
	MMC_CEn2,
	MMC_CEn3,
	
	xram_ce_b,	
	
	NandRAM_Sel0,
	NandRAM_Sel1,
	NandRAM_Sel2,
	NandRAM_Sel3,
	NandRAM_Sel4,
	NandRAM_Sel5,

	CpuRAM_Addr, // From Cpu
	Cpu_Wen,

	NandRAM_Addr0, // From RS block
	NandRAM_Addr1, // From RS block
	NandRAM_Wen0,
	NandRAM_Wen1,

	CpuRAM_DATAo,
	CpuRAM_DATAi,

	NandRAM0_DATAo,
	NandRAM1_DATAo,
	NandRAM0_DATAi,
	NandRAM1_DATAi,

	MMCRAM_Addr,
	MMC_Wen,
	MMCRAM_DATAi, 
	MMCRAM_Sel0,
	MMCRAM_Sel1,
 	MMCRAM_DATAo // Dedicate MMC RAM Data

);

//input 			RESETn;
input 			CLK;
///input			sdclk;

input			MMC_CEn0;
input			MMC_CEn1;
input			MMC_CEn2;
input			MMC_CEn3;

input			xram_ce_b;

input			NandRAM_Sel0;
input			NandRAM_Sel1;
input			NandRAM_Sel2;
input			NandRAM_Sel3;
input			NandRAM_Sel4;
input			NandRAM_Sel5;

//input [13:0]	CpuRAM_Addr;
input [15:0]	CpuRAM_Addr;
input			Cpu_Wen;

input [10:0]	NandRAM_Addr0; // From RS block
input [10:0]	NandRAM_Addr1; // From RS block
input			NandRAM_Wen0;
input			NandRAM_Wen1;

output 	[7:0]	CpuRAM_DATAo;
input	[7:0]	CpuRAM_DATAi; // CPU ACCESS

output	[7:0]	NandRAM0_DATAo; 
output	[7:0]	NandRAM1_DATAo; 
input	[7:0]	NandRAM0_DATAi; 
input	[7:0]	NandRAM1_DATAi; 

input	[10:0]	MMCRAM_Addr;
input			MMC_Wen;

input	[31:0]	MMCRAM_DATAi; 

input			MMCRAM_Sel0;
input			MMCRAM_Sel1;

output	[31:0]	MMCRAM_DATAo;

wire			RAM0_0_CEN; // MMC RAM
wire			RAM0_1_CEN; // MMC RAM
wire			RAM0_2_CEN; // MMC RAM
wire			RAM0_3_CEN; // MMC RAM
wire			RAM1_0_CEN; // MMC RAM
wire			RAM1_1_CEN; // MMC RAM
wire			RAM1_2_CEN; // MMC RAM
wire			RAM1_3_CEN; // MMC RAM

wire	[31:0]	RAM0_DATAo;
wire	[31:0]	RAM1_DATAo;
wire	[7:0]	RAM2_DATAo;
wire	[7:0]	RAM3_DATAo;
wire	[7:0]	RAM4_DATAo;
wire	[7:0]	RAM5_DATAo;


wire	[7:0]	RAM0_0DATAi;
wire	[7:0]	RAM0_1DATAi;
wire	[7:0]	RAM0_2DATAi;
wire	[7:0]	RAM0_3DATAi;
wire	[7:0]	RAM1_0DATAi;
wire	[7:0]	RAM1_1DATAi;
wire	[7:0]	RAM1_2DATAi;
wire	[7:0]	RAM1_3DATAi;

// MMC RAM
wire	[8:0]	MRAM0_ADDR;
wire	[8:0]	MRAM1_ADDR;

wire			MRAMCLK0;
wire			MRAMCLK1;


wire			CpuRAM_Sel0;
wire			CpuRAM_Sel1;
wire			CpuRAM_Sel2;
wire			CpuRAM_Sel3;
wire			CpuRAM_Sel4;
wire			CpuRAM_Sel5;

//assign MRAMCLK0 = (MMCRAM_Sel0)? sdclk : CLK;
//assign MRAMCLK1 = (MMCRAM_Sel1)? sdclk : CLK;

assign CpuRAM_Sel0 = ((xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b00001));
assign CpuRAM_Sel1 = ((xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b00010));
assign CpuRAM_Sel2 = ((xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b00011));
assign CpuRAM_Sel3 = ((xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b00100));
assign CpuRAM_Sel4 = ((xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b00101));
assign CpuRAM_Sel5 = ((xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b00110));

SRAM512 RAM0_0	(	
			.Q(RAM0_DATAo[7:0]), 
			.CLK(CLK), 
			.CEN(RAM0_0_CEN), 
			.WEN(RAM0_WEN), 
			.A(MRAM0_ADDR), 
			.D(RAM0_0DATAi)
			);

SRAM512 RAM0_1	(	
			.Q(RAM0_DATAo[15:8]), 
			.CLK(CLK), 
			.CEN(RAM0_1_CEN), 
			.WEN(RAM0_WEN), 
			.A(MRAM0_ADDR), 
			.D(RAM0_1DATAi)
			);

SRAM512 RAM0_2	(	
			.Q(RAM0_DATAo[23:16]), 
			.CLK(CLK), 
			.CEN(RAM0_2_CEN), 
			.WEN(RAM0_WEN), 
			.A(MRAM0_ADDR), 
			.D(RAM0_2DATAi)
			);

SRAM512 RAM0_3	(	
			.Q(RAM0_DATAo[31:24]), 
			.CLK(CLK), 
			.CEN(RAM0_3_CEN), 
			.WEN(RAM0_WEN), 
			.A(MRAM0_ADDR), 
			.D(RAM0_3DATAi)
			);

SRAM512 RAM1_0	(	
			.Q(RAM1_DATAo[7:0]), 
			.CLK(CLK), 
			.CEN(RAM1_0_CEN), 	
			.WEN(RAM1_WEN), 
			.A(MRAM1_ADDR), 
			.D(RAM1_0DATAi)
			);

SRAM512 RAM1_1	(	
			.Q(RAM1_DATAo[15:8]), 
			.CLK(CLK), 
			.CEN(RAM1_1_CEN), 	
			.WEN(RAM1_WEN), 
			.A(MRAM1_ADDR), 
			.D(RAM1_1DATAi)
			);

SRAM512 RAM1_2	(	
			.Q(RAM1_DATAo[23:16]), 
			.CLK(CLK), 
			.CEN(RAM1_2_CEN), 	
			.WEN(RAM1_WEN), 
			.A(MRAM1_ADDR), 
			.D(RAM1_2DATAi)
			);

SRAM512 RAM1_3	(	
			.Q(RAM1_DATAo[31:24]), 
			.CLK(CLK), 
			.CEN(RAM1_3_CEN), 	
			.WEN(RAM1_WEN), 
			.A(MRAM1_ADDR), 
			.D(RAM1_3DATAi)
			);

wire		RAM_SEL0;
wire		RAM_SEL1;

assign RAM_SEL0 = ((CpuRAM_Sel0)|(NandRAM_Sel0))|
					(~(CpuRAM_Sel0)&MMCRAM_Sel0)|
					(~(NandRAM_Sel0)&MMCRAM_Sel0);

assign RAM_SEL1 = ((CpuRAM_Sel1)|(NandRAM_Sel1))|
					((~CpuRAM_Sel1)&MMCRAM_Sel1)|
					((~NandRAM_Sel1)&MMCRAM_Sel1);

assign MRAM0_ADDR = (CpuRAM_Sel0)? CpuRAM_Addr[10:2]:
					(NandRAM_Sel0)? NandRAM_Addr0[10:2]: MMCRAM_Addr;

assign MRAM1_ADDR = (CpuRAM_Sel1)? CpuRAM_Addr[10:2]:
					(NandRAM_Sel1)? NandRAM_Addr1[10:2]: MMCRAM_Addr;

assign MMCRAM_DATAo = (MMCRAM_Sel0)? RAM0_DATAo : 
				      (MMCRAM_Sel1)? RAM1_DATAo : 32'd0;

assign RAM0_0_CEN = (CpuRAM_Sel0)?  (CpuRAM_Addr[1:0] == 2'b00) : 
					(NandRAM_Sel0)? (NandRAM_Addr0[1:0] == 2'b00): RAM_SEL0 & ~MMC_CEn0;

assign RAM0_1_CEN = (CpuRAM_Sel0)?  (CpuRAM_Addr[1:0] == 2'b01) : 
					(NandRAM_Sel0)? (NandRAM_Addr0[1:0] == 2'b01): RAM_SEL0 & ~MMC_CEn1;

assign RAM0_2_CEN = (CpuRAM_Sel0)?  (CpuRAM_Addr[1:0] == 2'b10) : 
					(NandRAM_Sel0)? (NandRAM_Addr0[1:0] == 2'b10): RAM_SEL0 & ~MMC_CEn2;

assign RAM0_3_CEN = (CpuRAM_Sel0)?  (CpuRAM_Addr[1:0] == 2'b11) : 
					(NandRAM_Sel0)? (NandRAM_Addr0[1:0] == 2'b11): RAM_SEL0 & ~MMC_CEn3;

assign RAM1_0_CEN = (CpuRAM_Sel1)?  (CpuRAM_Addr[1:0] == 2'b00) : 
					(NandRAM_Sel1)? (NandRAM_Addr1[1:0] == 2'b00): RAM_SEL1 & ~MMC_CEn0;

assign RAM1_1_CEN = (CpuRAM_Sel1)?  (CpuRAM_Addr[1:0] == 2'b01) : 
					(NandRAM_Sel1)? (NandRAM_Addr1[1:0] == 2'b01): RAM_SEL1 & ~MMC_CEn1;

assign RAM1_2_CEN = (CpuRAM_Sel1)?  (CpuRAM_Addr[1:0] == 2'b10) : 
					(NandRAM_Sel1)? (NandRAM_Addr1[1:0] == 2'b10): RAM_SEL1 & ~MMC_CEn2;

assign RAM1_3_CEN = (CpuRAM_Sel1)?  (CpuRAM_Addr[1:0] == 2'b11) : 
					(NandRAM_Sel1)? (NandRAM_Addr1[1:0] == 2'b11): RAM_SEL1 & ~MMC_CEn3;

assign RAM0_0DATAi = (CpuRAM_Sel0)?	CpuRAM_DATAi: 
					(NandRAM_Sel0)?	NandRAM0_DATAi : MMCRAM_DATAi[7:0];

assign RAM0_1DATAi = (CpuRAM_Sel0)?	CpuRAM_DATAi: 
					(NandRAM_Sel0)?	NandRAM0_DATAi : MMCRAM_DATAi[15:8];

assign RAM0_2DATAi = (CpuRAM_Sel0)?	CpuRAM_DATAi: 
					(NandRAM_Sel0)?	NandRAM0_DATAi : MMCRAM_DATAi[23:16];

assign RAM0_3DATAi = (CpuRAM_Sel0)?	CpuRAM_DATAi: 
					(NandRAM_Sel0)?	NandRAM0_DATAi: MMCRAM_DATAi[31:24];

assign RAM1_0DATAi = (CpuRAM_Sel1)?	CpuRAM_DATAi:
					(NandRAM_Sel1)?	NandRAM1_DATAi: MMCRAM_DATAi[7:0];

assign RAM1_1DATAi = (CpuRAM_Sel1)?	CpuRAM_DATAi:
					(NandRAM_Sel1)?	NandRAM1_DATAi: MMCRAM_DATAi[15:8];

assign RAM1_2DATAi = (CpuRAM_Sel1)?	CpuRAM_DATAi:
					(NandRAM_Sel1)?	NandRAM1_DATAi: MMCRAM_DATAi[23:16];

assign RAM1_3DATAi = (CpuRAM_Sel1)?	CpuRAM_DATAi:
					(NandRAM_Sel1)?	NandRAM1_DATAi: MMCRAM_DATAi[31:24];

assign RAM0_WEN = 	(CpuRAM_Sel0)? 	Cpu_Wen :
					(NandRAM_Sel0)?	NandRAM_Wen0:  RAM_SEL0 & MMC_Wen ;

assign RAM1_WEN =	(CpuRAM_Sel1)? 	Cpu_Wen : 
					(NandRAM_Sel1)?	NandRAM_Wen1:  RAM_SEL1 & MMC_Wen ;


// Program RAM
wire [10:0]	RAM2_ADDR;
wire [10:0]	RAM3_ADDR;
wire [10:0]	RAM4_ADDR;
wire [10:0]	RAM5_ADDR;

wire	[7:0]	RAM2_DATAi;
wire	[7:0]	RAM3_DATAi;
wire	[7:0]	RAM4_DATAi;
wire	[7:0]	RAM5_DATAi;

wire			RAM_Sel2;
wire			RAM_Sel3;
wire			RAM_Sel4;
wire			RAM_Sel5;

assign RAM2_ADDR = (NandRAM_Sel2)? NandRAM_Addr0 : CpuRAM_Addr[10:0];
assign RAM3_ADDR = (NandRAM_Sel3)? NandRAM_Addr0 : CpuRAM_Addr[10:0];
assign RAM4_ADDR = (NandRAM_Sel4)? NandRAM_Addr0 : CpuRAM_Addr[10:0];
assign RAM5_ADDR = (NandRAM_Sel5)? NandRAM_Addr0 : CpuRAM_Addr[10:0];


SSRAM8bit RAM2 	(	
			.CLK(CLK), 
			.ADDR(RAM2_ADDR), 
			.CEn(~RAM_Sel2), 
			.WEn(~RAM_Wen2), 
			.RDATA(RAM2_DATAo), 
			.WDATA(RAM2_DATAi)
			);

SSRAM8bit RAM3 	(	
			.CLK(CLK), 
			.ADDR(RAM3_ADDR), 
			.CEn(~RAM_Sel3), 
			.WEn(~RAM_Wen3), 
			.RDATA(RAM3_DATAo), 
			.WDATA(RAM3_DATAi)
			);

SSRAM8bit RAM4 	(	
			.CLK(CLK), 
			.ADDR(RAM4_ADDR), 
			.CEn(~RAM_Sel4), 
			.WEn(~RAM_Wen4), 
			.RDATA(RAM4_DATAo), 
			.WDATA(RAM4_DATAi)
			);

SSRAM8bit RAM5 	(	
			.CLK(CLK),
			.ADDR(RAM5_ADDR), 
			.CEn(~RAM_Sel5),
			.WEn(~RAM_Wen5), 
			.RDATA(RAM5_DATAo), 
			.WDATA(RAM5_DATAi)
			);

assign RAM2_DATAi =	(NandRAM_Sel2)? NandRAM0_DATAi: CpuRAM_DATAi[7:0];
assign RAM3_DATAi =	(NandRAM_Sel3)?	NandRAM0_DATAi: CpuRAM_DATAi[7:0];
assign RAM4_DATAi =	(NandRAM_Sel4)?	NandRAM0_DATAi: CpuRAM_DATAi[7:0]; 
assign RAM5_DATAi =	(NandRAM_Sel5)? NandRAM0_DATAi: CpuRAM_DATAi[7:0]; 
assign RAM_Sel2 =	(CpuRAM_Sel2)|(NandRAM_Sel2);
assign RAM_Sel3 =	(CpuRAM_Sel3)|(NandRAM_Sel3);
assign RAM_Sel4 =	(CpuRAM_Sel4)|(NandRAM_Sel4);
assign RAM_Sel5 =	(CpuRAM_Sel5)|(NandRAM_Sel5);

						
assign RAM_Wen2 =	(NandRAM_Sel2)?	NandRAM_Wen0: 
					(CpuRAM_Sel2)? 	Cpu_Wen : 1'b0 ;

assign RAM_Wen3 =	(NandRAM_Sel3)?	NandRAM_Wen0: 	
					(CpuRAM_Sel3)? 	Cpu_Wen : 1'b0 ;

assign RAM_Wen4 =	(NandRAM_Sel4)?	NandRAM_Wen0: 	
					(CpuRAM_Sel4)? 	Cpu_Wen	: 1'b0 ;

assign RAM_Wen5 =	(NandRAM_Sel5)? NandRAM_Wen0: 
					(CpuRAM_Sel5)? 	Cpu_Wen : 1'b0 ;

assign NandRAM0_DATAo = 	(NandRAM_Sel0)? ((NandRAM_Addr0[1:0]== 2'b00)?RAM0_DATAo[7:0]:
										 (NandRAM_Addr0[1:0]== 2'b01)?RAM0_DATAo[15:8]:
										 (NandRAM_Addr0[1:0]== 2'b10)?RAM0_DATAo[23:16]:RAM0_DATAo[31:24]):
						(NandRAM_Sel2)? RAM2_DATAo :
						(NandRAM_Sel3)? RAM3_DATAo : 
						(NandRAM_Sel4)? RAM4_DATAo : 
						(NandRAM_Sel5)? RAM5_DATAo : 8'b00000000 ;

assign NandRAM1_DATAo = (NandRAM_Sel1)? ((NandRAM_Addr1[1:0]== 2'b00)?RAM1_DATAo[7:0]:
										 (NandRAM_Addr1[1:0]== 2'b01)?RAM1_DATAo[15:8]:
										 (NandRAM_Addr1[1:0]== 2'b10)?RAM1_DATAo[23:16]:RAM1_DATAo[31:24]): 8'b00000000;

assign CpuRAM_DATAo = 	(CpuRAM_Sel0)? ((CpuRAM_Addr[1:0]== 2'b00)?RAM0_DATAo[7:0]:
										(CpuRAM_Addr[1:0]== 2'b01)?RAM0_DATAo[15:8]:
										(CpuRAM_Addr[1:0]== 2'b10)?RAM0_DATAo[23:16]:RAM0_DATAo[31:24]):
						(CpuRAM_Sel1)? ((CpuRAM_Addr[1:0]== 2'b00)?RAM1_DATAo[7:0]:
										(CpuRAM_Addr[1:0]== 2'b01)?RAM1_DATAo[15:8]:
										(CpuRAM_Addr[1:0]== 2'b10)?RAM1_DATAo[23:16]:RAM1_DATAo[31:24]):
						(CpuRAM_Sel2)? RAM2_DATAo :
						(CpuRAM_Sel3)? RAM3_DATAo :
						(CpuRAM_Sel4)? RAM4_DATAo :
						(CpuRAM_Sel5)? RAM5_DATAo : 8'b00000000;

/*
//synopsys translate_off
reg 	[8*5:0] NextMMCRAMState;
reg 	[8*5:0] MMCRAMState;

always @(NextMDataState)
begin
case (NextMDataState)
3'b001	: NextMMCRAMState	= "IDLE";
3'b010	: NextMMCRAMState	= "READ";
3'b100	: NextMMCRAMState	= "WRITE";
endcase
end

always @(posedge CpuMRAM_acc)
begin
	if (CpuMRAM_acc)
		$display ("CPU MMC RAM Access ");
end

always @(posedge RAM_SEL0)
begin
	if (RAM_SEL0)
		$display ("RAM0 Selected");
end

always @(posedge RAM_SEL1)
begin
	if (RAM_SEL1)
		$display ("RAM1 Selected");
end

always @(posedge RAM_SEL2)
begin
	if (RAM_SEL2)
		$display ("RAM2 Selected");
end

always @(posedge RAM_SEL3)
begin
	if (RAM_SEL3)
		$display ("RAM3 Selected");
end
always @(posedge RAM_SEL4)
begin
	if (RAM_SEL4)
		$display ("RAM4 Selected");
end
always @(posedge RAM_SEL5)
begin
	if (RAM_SEL5)
		$display ("RAM5 Selected");
end

always @(MDataState)
begin
case (MDataState)
3'b001	: MMCRAMState 	= "IDLE";
3'b010	: MMCRAMState	= "READ";
3'b100	: MMCRAMState	= "WRITE";
endcase
end
//synopsys translate_on
*/
endmodule

