

Video Encoder



./C_model : NTSC/PAL C modeling
./Doc	  : Documentation
./NcVerilogCore : VideoEncoder core block ncverilog simulation
./Ref	  : Standard Ref. doc
./TestPlatfor_Cmodel : Cmodel test platform (Altera board "NCBoard")
./Tool	   : Converting Tools

./Verilog  : Verilog RTL Simulation environments

	./Verilog/Mod 		:: Memory modeling file
	./modelsim    		:: Modelsim simulation
	./Rtl/DM      		:: Display Module Rtl (for testing : DM + VideoEnc)
	./Rtl/Include 		:: DM subdirectory
	./Rtl/IntSRAMController :: DM used this block
	./VideoEnc    		:: Video Encoder Core
	./VideoOut		:: Video Enc + Bt.656 output function
				   (CT500 function apply)
	./Sim			:: Simulation
	./SimCore		:: VideoEnc block simulation (Core block)
	./SimWithDM		:: VideoEnc + DM simulation
	./Tb			:: TestBench


_______________________________________________________________________________

Chip용으로 사용하기 위해서는 define설정을 변경하여 Rom modeling을 변경
하여야 합니다.
_______________________________________________________________________________


2008/11/21 :: CT2000 용으로 Bt.656 output 버그를 수정 하였습니다.
2009/05/12 :: Version 정보 삽입



