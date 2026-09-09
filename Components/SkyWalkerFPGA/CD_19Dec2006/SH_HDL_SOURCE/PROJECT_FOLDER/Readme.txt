ADC(TOUCH SCREEN) : ADC TEST로서 Vin 0~0.5[V]의 범위내에서 측정가능합니다.
                    측정핀은 Exp.3번핀입니다.  부가적인 회로추가를 못하므로
		    코드 작성시 동작 범위 설정을 낮게 잡아 주었습니다.  

FPGA_to_FPGA(interface) : FPGA간에 핀 컨넥션을 측정하는 것으로서 MASTER(U60)과 SLAVE(U51)로
                          구성되어져 있습니다.   MASTER와 SLAVE내부에는 각각 시프트레지스터
                          가 있어 MASTER에서 하나의 제어신호로 시프트를 하게되며, 핀 간에 정보를
                          체크하는 방식으로 되어져 있습니다.  실행(에러실행 및 체크확인) 스위치는
                          S6번으로 버튼을 누른 후 2.5초 후에 동작하게 됩니다.
                          ERROR PIN은 E.XXX로 표시되며, 현재 체크된 핀은 P.XXX로 표시됩니다.

                              ------              ------
                                    |            | 
                                    | ====/====> | 
                               U51  |    446     |    U60
                                    |            | 
                                    | <--------- | 
                              ------    FPGA_EN   ------

                             EX)  
                                  000001 -------> COMPARATOR -------> NEXT(or COMPLETE)
                                                      *         |
                                                      |         |---> ERROR(GOto Error CHECK MODE)
                                                      | 
                                                    000001


UART : 96000bps로서 UART단자의 TOP은 송신전용으로 PC와 연결을 하는 포트로 설정했으며, BOTTOM은 LOOP BACK
       단자로서 현재 출력되는 데이터와 수신된 데이터가 SEGMENT에 16진수(HEX) 표시됩니다.
       SEGMENT [수신데이터 : 송신데이터] 로 표시됩니다.

LCM : TFT-LCD TEST로서 스위치(S[6:9])에 따라 그에 해당하는 화면을 출력합니다.
  

       default : 시간단위로 변화하는 color 출력
         s6    : horizontal-color bar
         s7    : vertical-color bar
         s8    : gray (all display)   * RGB MSB= '0', others '1';
         s9    : white (all display)  * RGB ALL '1';


