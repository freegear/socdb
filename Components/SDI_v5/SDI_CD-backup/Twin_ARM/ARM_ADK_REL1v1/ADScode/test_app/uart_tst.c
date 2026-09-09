#include "peripherals.h"
#include "testutils.h"
#include "uart_tst.h"
#include "irq.h"

#include <stdio.h>
#include <stdlib.h>

TestStatus testUart(void);
TestStatus testUartTX(void);
void  init_serial(void);
void  init_tx_int(void);
void  sendchar();
void  get_uart_char();
void  uart_dma_en();

TestStatus testUart(void){

TestStatus status = PASS;

 DO_TEST( testPcellID( (Word *)&uart), "PrimeCell ID" ,status);
 }

