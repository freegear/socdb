module memchblk
(
	CLK,

	MMC_CEn0,
	MMC_CEn1,
	MMC_CEn2,
	MMC_CEn3,
	
	xram_ce_b,	
	
	NandRAM0_Sel0,
	NandRAM0_Sel1,
	NandRAM0_Sel2,
	NandRAM0_Sel3,
	NandRAM0_Sel4,
	NandRAM0_Sel5,

	NandRAM1_Sel0,
	NandRAM1_Sel1,
	NandRAM1_Sel2,
	NandRAM1_Sel3,
	NandRAM1_Sel4,
	NandRAM1_Sel5,

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

input			NandRAM0_Sel0;
input			NandRAM0_Sel1;
input			NandRAM0_Sel2;
input			NandRAM0_Sel3;
input			NandRAM0_Sel4;
input			NandRAM0_Sel5;

input			NandRAM1_Sel0;
input			NandRAM1_Sel1;
input			NandRAM1_Sel2;
input			NandRAM1_Sel3;
input			NandRAM1_Sel4;
input			NandRAM1_Sel5;

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

wire			CpuRAM_Sel0;
wire			CpuRAM_Sel1;
wire			CpuRAM_Sel2;
wire			CpuRAM_Sel3;
wire			CpuRAM_Sel4;
wire			CpuRAM_Sel5;

wire			RAM0_WEN;
wire			RAM1_WEN;
wire			RAM_Wen2;
wire			RAM_Wen3;
wire			RAM_Wen4;
wire			RAM_Wen5;

assign CpuRAM_Sel0 = ((~xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b10100));
assign CpuRAM_Sel1 = ((~xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b10101));
assign CpuRAM_Sel2 = ((~xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b10000));
assign CpuRAM_Sel3 = ((~xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b10001));
assign CpuRAM_Sel4 = ((~xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b10010));
assign CpuRAM_Sel5 = ((~xram_ce_b) & (CpuRAM_Addr[15:11] == 5'b10011));


wire		RAM_SEL0;
wire		RAM_SEL1;

assign RAM_SEL0 = (CpuRAM_Sel0)|(NandRAM0_Sel0)|(NandRAM1_Sel0)|(MMCRAM_Sel0);
assign RAM_SEL1 = (CpuRAM_Sel1)|(NandRAM0_Sel1)|(NandRAM1_Sel1)|(MMCRAM_Sel1);

assign MRAM0_ADDR = (CpuRAM_Sel0)? CpuRAM_Addr[10:2]:
					(NandRAM0_Sel0)? NandRAM_Addr0[10:2]: 
					(NandRAM1_Sel0)? NandRAM_Addr1[10:2]: MMCRAM_Addr;

assign MRAM1_ADDR = (CpuRAM_Sel1)? CpuRAM_Addr[10:2]:
					(NandRAM0_Sel1)? NandRAM_Addr0[10:2]:
					(NandRAM1_Sel1)? NandRAM_Addr1[10:2]: MMCRAM_Addr;

assign MMCRAM_DATAo = (MMCRAM_Sel0)? RAM0_DATAo : 
				      (MMCRAM_Sel1)? RAM1_DATAo : 32'd0;

assign RAM0_0DATAi = (CpuRAM_Sel0)?	CpuRAM_DATAi: 
					(NandRAM0_Sel0)?NandRAM0_DATAi :
					(NandRAM1_Sel0)?NandRAM1_DATAi : MMCRAM_DATAi[7:0];

assign RAM0_1DATAi = (CpuRAM_Sel0)?	CpuRAM_DATAi: 
					(NandRAM0_Sel0)?NandRAM0_DATAi :
					(NandRAM1_Sel0)?NandRAM1_DATAi : MMCRAM_DATAi[15:8];

assign RAM0_2DATAi = (CpuRAM_Sel0)?	CpuRAM_DATAi: 
					(NandRAM0_Sel0)?NandRAM0_DATAi :
					(NandRAM1_Sel0)?NandRAM1_DATAi : MMCRAM_DATAi[23:16];

assign RAM0_3DATAi = (CpuRAM_Sel0)?	CpuRAM_DATAi: 
					(NandRAM0_Sel0)?NandRAM0_DATAi:
					(NandRAM1_Sel0)?NandRAM1_DATAi: MMCRAM_DATAi[31:24];

assign RAM1_0DATAi = (CpuRAM_Sel1)?	CpuRAM_DATAi:
					(NandRAM0_Sel1)?NandRAM0_DATAi:
					(NandRAM1_Sel1)?NandRAM1_DATAi: MMCRAM_DATAi[7:0];

assign RAM1_1DATAi = (CpuRAM_Sel1)?	CpuRAM_DATAi:
					(NandRAM0_Sel1)?NandRAM0_DATAi:
					(NandRAM1_Sel1)?NandRAM1_DATAi: MMCRAM_DATAi[15:8];

assign RAM1_2DATAi = (CpuRAM_Sel1)?	CpuRAM_DATAi:
					(NandRAM0_Sel1)?NandRAM0_DATAi:
					(NandRAM1_Sel1)?NandRAM1_DATAi: MMCRAM_DATAi[23:16];

assign RAM1_3DATAi = (CpuRAM_Sel1)?	CpuRAM_DATAi:
					(NandRAM0_Sel1)?NandRAM0_DATAi: 
					(NandRAM1_Sel1)?NandRAM1_DATAi: MMCRAM_DATAi[31:24];


wire	RAM0_0WEN;
wire	RAM0_1WEN;
wire	RAM0_2WEN;
wire	RAM0_3WEN;
wire	RAM1_0WEN;
wire	RAM1_1WEN;
wire	RAM1_2WEN;
wire	RAM1_3WEN;

assign RAM0_0WEN = 	(CpuRAM_Sel0)? 	(~Cpu_Wen& (CpuRAM_Addr[1:0]==2'b00)):
					(NandRAM0_Sel0)? (NandRAM_Wen0&(NandRAM_Addr0[1:0] == 2'b00)) :
					(NandRAM1_Sel0)? (NandRAM_Wen1&(NandRAM_Addr1[1:0] == 2'b00)) : RAM_SEL0 & ~MMC_Wen & ~MMC_CEn0 ;

assign RAM0_1WEN = 	(CpuRAM_Sel0)? 	(~Cpu_Wen& (CpuRAM_Addr[1:0]==2'b01)):
					(NandRAM0_Sel0)? (NandRAM_Wen0&(NandRAM_Addr0[1:0] == 2'b01)) :
					(NandRAM1_Sel0)? (NandRAM_Wen1&(NandRAM_Addr1[1:0] == 2'b01)) : RAM_SEL0 & ~MMC_Wen & ~MMC_CEn1;

assign RAM0_2WEN = 	(CpuRAM_Sel0)? 	(~Cpu_Wen& (CpuRAM_Addr[1:0]==2'b10)):
					(NandRAM0_Sel0)? (NandRAM_Wen0&(NandRAM_Addr0[1:0] == 2'b10)) :
					(NandRAM1_Sel0)? (NandRAM_Wen1&(NandRAM_Addr1[1:0] == 2'b10)) : RAM_SEL0 & ~MMC_Wen & ~MMC_CEn2;

assign RAM0_3WEN = 	(CpuRAM_Sel0)? 	(~Cpu_Wen& (CpuRAM_Addr[1:0]==2'b11)):
					(NandRAM0_Sel0)? (NandRAM_Wen0&(NandRAM_Addr0[1:0] == 2'b11)) :
					(NandRAM1_Sel0)? (NandRAM_Wen1&(NandRAM_Addr1[1:0] == 2'b11)) : RAM_SEL0 & ~MMC_Wen & ~MMC_CEn3;

assign RAM1_0WEN = 	(CpuRAM_Sel1)? 	(~Cpu_Wen& (CpuRAM_Addr[1:0]==2'b00)):
					(NandRAM0_Sel1)? (NandRAM_Wen0&(NandRAM_Addr0[1:0] == 2'b00)) :
					(NandRAM1_Sel1)? (NandRAM_Wen1&(NandRAM_Addr1[1:0] == 2'b00)) : RAM_SEL1 & ~MMC_Wen & ~MMC_CEn0;

assign RAM1_1WEN = 	(CpuRAM_Sel1)? 	(~Cpu_Wen& (CpuRAM_Addr[1:0]==2'b01)):
					(NandRAM0_Sel1)? (NandRAM_Wen0&(NandRAM_Addr0[1:0] == 2'b01)) :
					(NandRAM1_Sel1)? (NandRAM_Wen1&(NandRAM_Addr1[1:0] == 2'b01)) : RAM_SEL1 & ~MMC_Wen & ~MMC_CEn1;

assign RAM1_2WEN = 	(CpuRAM_Sel1)? 	(~Cpu_Wen& (CpuRAM_Addr[1:0]==2'b10)):
					(NandRAM0_Sel1)? (NandRAM_Wen0&(NandRAM_Addr0[1:0] == 2'b10)) :
					(NandRAM1_Sel1)? (NandRAM_Wen1&(NandRAM_Addr1[1:0] == 2'b10)) : RAM_SEL1 & ~MMC_Wen & ~MMC_CEn2;

assign RAM1_3WEN = 	(CpuRAM_Sel1)? 	(~Cpu_Wen& (CpuRAM_Addr[1:0]==2'b11)):
					(NandRAM0_Sel1)? (NandRAM_Wen0&(NandRAM_Addr0[1:0] == 2'b11)) :
					(NandRAM1_Sel1)? (NandRAM_Wen1&(NandRAM_Addr1[1:0] == 2'b11)) : RAM_SEL1 & ~MMC_Wen & ~MMC_CEn3;


// Program RAM
// Program RAM
// Program RAM
// Program RAM
wire 	[10:0]	RAM2_ADDR;
wire 	[10:0]	RAM3_ADDR;
wire 	[10:0]	RAM4_ADDR;
wire 	[10:0]	RAM5_ADDR;

wire	[7:0]	RAM2_DATAi;
wire	[7:0]	RAM3_DATAi;
wire	[7:0]	RAM4_DATAi;
wire	[7:0]	RAM5_DATAi;

assign RAM2_ADDR = 	(CpuRAM_Sel2)? CpuRAM_Addr[10:0]:
					(NandRAM0_Sel2)? NandRAM_Addr0 :
					(NandRAM1_Sel2)? NandRAM_Addr1 : CpuRAM_Addr[10:0];

assign RAM3_ADDR = 	(CpuRAM_Sel3)? CpuRAM_Addr[10:0]:
					(NandRAM0_Sel3)? NandRAM_Addr0 :
					(NandRAM1_Sel3)? NandRAM_Addr1 : CpuRAM_Addr[10:0];

assign RAM4_ADDR = 	(CpuRAM_Sel4)? CpuRAM_Addr[10:0]:
					(NandRAM0_Sel4)? NandRAM_Addr0 : 
					(NandRAM1_Sel4)? NandRAM_Addr1 : CpuRAM_Addr[10:0];

assign RAM5_ADDR = 	(CpuRAM_Sel5)? CpuRAM_Addr[10:0]:
					(NandRAM0_Sel5)? NandRAM_Addr0 :
					(NandRAM1_Sel5)? NandRAM_Addr1 : CpuRAM_Addr[10:0];

//`ifdef CHIP

//`else
SSRAM8bit RAM2 	(	
			.CLK(CLK), 
			.ADDR(RAM2_ADDR), 
			.CEn(1'b0), 
			.WEn(RAM_Wen2), 
			.RDATA(RAM2_DATAo), 
			.WDATA(RAM2_DATAi)
			);

SSRAM8bit RAM3 	(	
			.CLK(CLK), 
			.ADDR(RAM3_ADDR), 
			.CEn(1'b0), 
			.WEn(RAM_Wen3), 
			.RDATA(RAM3_DATAo), 
			.WDATA(RAM3_DATAi)
			);

SSRAM8bit RAM4 	(	
			.CLK(CLK), 
			.ADDR(RAM4_ADDR), 
			.CEn(1'b0), 
			.WEn(RAM_Wen4), 
			.RDATA(RAM4_DATAo), 
			.WDATA(RAM4_DATAi)
			);

SSRAM8bit RAM5 	(	
			.CLK(CLK),
			.ADDR(RAM5_ADDR), 
			.CEn(1'b0), 
			.WEn(RAM_Wen5), 
			.RDATA(RAM5_DATAo), 
			.WDATA(RAM5_DATAi)
			);
//`endif

assign RAM2_DATAi =	(CpuRAM_Sel2)? CpuRAM_DATAi[7:0]:
					(NandRAM0_Sel2)? NandRAM0_DATAi:
					(NandRAM1_Sel2)? NandRAM1_DATAi: CpuRAM_DATAi[7:0];

assign RAM3_DATAi =	(CpuRAM_Sel3)? CpuRAM_DATAi[7:0]:
					(NandRAM0_Sel3)? NandRAM0_DATAi:
					(NandRAM1_Sel3)? NandRAM1_DATAi: CpuRAM_DATAi[7:0];

assign RAM4_DATAi =	(CpuRAM_Sel4)? CpuRAM_DATAi[7:0]:
					(NandRAM0_Sel4)? NandRAM0_DATAi:
					(NandRAM1_Sel4)? NandRAM1_DATAi: CpuRAM_DATAi[7:0];

assign RAM5_DATAi =	(CpuRAM_Sel5)? CpuRAM_DATAi[7:0]:
					(NandRAM0_Sel5)? NandRAM0_DATAi:
					(NandRAM1_Sel5)? NandRAM1_DATAi: CpuRAM_DATAi[7:0]; 

assign RAM_Wen2 =	(CpuRAM_Sel2)? 		Cpu_Wen :
					(NandRAM0_Sel2)?	~NandRAM_Wen0: 
					(NandRAM1_Sel2)?	~NandRAM_Wen1: 1'b1 ;

assign RAM_Wen3 =	(CpuRAM_Sel3)? 		Cpu_Wen :
					(NandRAM0_Sel3)?	~NandRAM_Wen0: 
					(NandRAM1_Sel3)?	~NandRAM_Wen1:  1'b1 ;

assign RAM_Wen4 =	(CpuRAM_Sel4)? 		Cpu_Wen :
					(NandRAM0_Sel4)?	~NandRAM_Wen0: 
					(NandRAM1_Sel4)?	~NandRAM_Wen1:  1'b1 ;

assign RAM_Wen5 =	(CpuRAM_Sel5)? 		Cpu_Wen :
					(NandRAM0_Sel5)?	~NandRAM_Wen0: 
					(NandRAM1_Sel5)?	~NandRAM_Wen1:  1'b1 ;


assign NandRAM0_DATAo = (NandRAM0_Sel0)? ((NandRAM_Addr0[1:0]== 2'b00)?RAM0_DATAo[7:0]:
										 (NandRAM_Addr0[1:0]== 2'b01)?RAM0_DATAo[15:8]:
										 (NandRAM_Addr0[1:0]== 2'b10)?RAM0_DATAo[23:16]:RAM0_DATAo[31:24]):
						(NandRAM0_Sel1)? ((NandRAM_Addr0[1:0]== 2'b00)?RAM1_DATAo[7:0]:
										 (NandRAM_Addr0[1:0]== 2'b01)?RAM1_DATAo[15:8]:
										 (NandRAM_Addr0[1:0]== 2'b10)?RAM1_DATAo[23:16]:RAM1_DATAo[31:24]):
						(NandRAM0_Sel2)? RAM2_DATAo :
						(NandRAM0_Sel3)? RAM3_DATAo : 
						(NandRAM0_Sel4)? RAM4_DATAo : 
						(NandRAM0_Sel5)? RAM5_DATAo : 8'b00000000 ;

assign NandRAM1_DATAo = (NandRAM1_Sel0)? ((NandRAM_Addr1[1:0]== 2'b00)?RAM0_DATAo[7:0]:
										 (NandRAM_Addr1[1:0]== 2'b01)?RAM0_DATAo[15:8]:
										 (NandRAM_Addr1[1:0]== 2'b10)?RAM0_DATAo[23:16]:RAM0_DATAo[31:24]):
						(NandRAM1_Sel1)? ((NandRAM_Addr1[1:0]== 2'b00)?RAM1_DATAo[7:0]:
										 (NandRAM_Addr1[1:0]== 2'b01)?RAM1_DATAo[15:8]:
										 (NandRAM_Addr1[1:0]== 2'b10)?RAM1_DATAo[23:16]:RAM1_DATAo[31:24]):
						(NandRAM1_Sel2)? RAM2_DATAo :
						(NandRAM1_Sel3)? RAM3_DATAo : 
						(NandRAM1_Sel4)? RAM4_DATAo : 
						(NandRAM1_Sel5)? RAM5_DATAo : 8'b00000000 ;

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

//`ifdef CHIP


//`else
SSRAM8bit #9 RAM0_0	(	
			.CLK(CLK), 
			.ADDR(MRAM0_ADDR), 
			.CEn(1'b0), 
			.WEn(~RAM0_0WEN), 
			.RDATA(RAM0_DATAo[7:0]), 
			.WDATA(RAM0_0DATAi)
			);

SSRAM8bit #9 RAM0_1	(	
			.CLK(CLK), 
			.ADDR(MRAM0_ADDR), 
			.CEn(1'b0), 
			.WEn(~RAM0_1WEN), 
			.RDATA(RAM0_DATAo[15:8]), 
			.WDATA(RAM0_1DATAi)
			);

SSRAM8bit #9 RAM0_2	(	
			.CLK(CLK), 
			.ADDR(MRAM0_ADDR), 
			.CEn(1'b0), 
			.WEn(~RAM0_2WEN), 
			.RDATA(RAM0_DATAo[23:16]), 
			.WDATA(RAM0_2DATAi)
			);

SSRAM8bit #9 RAM0_3	(	
			.CLK(CLK), 
			.ADDR(MRAM0_ADDR), 
			.CEn(1'b0), 
			.WEn(~RAM0_3WEN), 
			.RDATA(RAM0_DATAo[31:24]), 
			.WDATA(RAM0_3DATAi)
			);

SSRAM8bit #9 RAM1_0	(	
			.CLK(CLK), 
			.ADDR(MRAM1_ADDR), 
			.CEn(1'b0), 	
			.WEn(~RAM1_0WEN), 
			.RDATA(RAM1_DATAo[7:0]), 
			.WDATA(RAM1_0DATAi)
			);

SSRAM8bit #9 RAM1_1	(	
			.CLK(CLK), 
			.ADDR(MRAM1_ADDR), 
			.CEn(1'b0), 	
			.WEn(~RAM1_1WEN), 
			.RDATA(RAM1_DATAo[15:8]), 
			.WDATA(RAM1_1DATAi)
			);

SSRAM8bit #9 RAM1_2	(	
			.CLK(CLK), 
			.ADDR(MRAM1_ADDR), 
			.CEn(1'b0), 	
			.WEn(~RAM1_2WEN), 
			.RDATA(RAM1_DATAo[23:16]), 
			.WDATA(RAM1_2DATAi)
			);

SSRAM8bit #9 RAM1_3	(	
			.CLK(CLK), 
			.ADDR(MRAM1_ADDR), 
			.CEn(1'b0), 	
			.WEn(~RAM1_3WEN), 
			.RDATA(RAM1_DATAo[31:24]), 
			.WDATA(RAM1_3DATAi)
			);
//`endif
endmodule

