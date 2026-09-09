 #include "peripherals.h"
 #include "testutils.h"
 #include "dmac_tst.h"
 #include "dmac.h"
 #include "egmaster_tst.h"
  
 #include <stdio.h>
 #include <stdlib.h>
 
 #define ONE 1 
 TestStatus testDmac(void);
 TestStatus testP2M(void);
 void dmac_initial(void);
 void dmac_channel0(void);

 const Word tstData[ONE] = {0x00000055};

 TestStatus testDmac(void){

 TestStatus status = PASS;

 DO_TEST( testPcellID( (Word *)&dmac), "PrimeCell ID" ,status); 
}


