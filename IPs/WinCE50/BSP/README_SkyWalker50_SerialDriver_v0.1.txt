[README]

* History

	****1차 포팅 작업.****

		CSP 드라이버 작업
		PUBLIC/COMMON/OAK/CSP/ARM/SMT/SMT926A
		/INC
		Smt926a_uart.h
		- replace register name to new one
		
		/inc
		Pddsmt926a.h
		- 레지스터 관련 변수 값들을 Smt926a_uart.h로 이동.
		
		/DRIVER/SERIAL
		Pddsmt926a.cpp
		- PDD class의 각 멤버 함수 내 register 이름 변경.
						
		BSP SERIAL DRIVER 작업
		PLATFORM\SkyWalker50\
		Src\Drivers\Serial
		ser_skywalker.cpp
		- UART0 초기화 루틴 
							
		SKYWALKER50/SRC/KERNEL/OAL		
		debug.c
		- skywalker의 firmware(lib.c,init.c)의 내용 포팅함.

* check list 
- 모뎀 기능 제거 작업 필요		
- 백업 해야 하는 레지스터 결정(POWER MANAGEMENT 관련).
- DMA CONTROLL 및 LOWPOWER IRDA REGISTER(스펙에 REGISTER 설명 없음, 추후 확인)
- firm ware  SHIFT_DN_FROM_MASK 매크로 사용시  2비트 이상되는 마스크 사용한 코드 수정 필요
- UART_RSR/ECR READ Sequence 재확인 필요. (get_linestatus)
	- the register must be read after reading UART_DR 

- fifo 관련하여 sdi UART에 없는 기능 처리작업..
   - implement : GetWriteableSize//Rx_Pause 
   - reset RX, TX fifo 
   - count RX TX fifo
- kitl serial porting??
  - debug.c
- set Baud rate에서 float 연산 가능여부 확인.
	- 커널 모드에서 folating 연산하면 오류 발생할 수 있다고 msdn에서 본것 같은데...
								
		