 #include "peripherals.h"
 #include "testutils.h"
 #include "smc_tst.h"
 #include "smc.h"
 #include "egmaster_tst.h"
 #include "egmastermem.h"
 
 
 #include <stdio.h>
 #include <stdlib.h>
 
 TestStatus testSmc(void);
 void ConfigureSmc(Word, Word, Word, Word, Word, Word, Word, Word);

 TestStatus testSmc(void){

 TestStatus status = PASS;
 DO_TEST( testPcellID( (Word *)&smc), "PrimeCell ID" ,status); 
 
 printf("SMC TEST: %8x\n",status);
 return status; 

}
