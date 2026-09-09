module SspNewDMA (
		//input
		TxFFillLevel,
		RxFFillLevel,
		
		//input
		TxDMALevel,
		RxDMALevel,
		
		TxDMAReqEn,
		RxDMAReqEn,
		
		//output
		TxDMAReq,
		RxDMAReq
		);

`define TxFIFOFullLevel 4'b1000

input	[3:0]	TxFFillLevel;
input	[3:0]	RxFFillLevel;
input	[3:0]	TxDMALevel;
input	[3:0]	RxDMALevel;
	
input			TxDMAReqEn;
input			RxDMAReqEn;

output			TxDMAReq;
output			RxDMAReq;

// FIFO에 남아 있는 양이 DMA requst 보낼 양보다 많을 경우
assign TxDMAReq = (~TxDMAReqEn)? 1'b0:
					((`TxFIFOFullLevel-TxFFillLevel)>= TxDMALevel); 

// Rx FIFO가 일정량 이상 차 있을 경우 DMA request를 보내 
// 퍼 가게 만든다.
assign RxDMAReq = (~RxDMAReqEn)? 1'b0:(RxFFillLevel>=RxDMALevel);

endmodule

