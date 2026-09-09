// ****** (C) Copyright 1998 Avant! Inc. ********
//  --    AVANT! Verilog Models
// **********************************************
// Model type   	: Verilog UDP
// Filename     	: mtb_verilog.v
// Description  	: MTB User Defined Primitives
// Library      	: cb18os120
// Programmer   	: yzhu
// Date                 : 14-Mar-2001
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//

// Additional Verilog UDP models with notifiers created for  STAR-MTB
//            U_FT_N_TE_RB_SB_QN,U_FT_N_TE_RB_SB_QN_NO,U_FJK_N_RB_SB_QN_NO
// Version 1.1A : 20-OCT-93 : Paul Foster

// Additional Verilog UDP models with notifiers created for STAR-MTB
// Version 1.0A : 25-AUG : Peter Thomson

// 5 Oct 2000     pavlov    Modified s_sdcrn UDP to eleminate output response
//                          to SC, SD, D signals fronts without clock pulse.


// 23 Jan 2001 jmre Modification UDPs to eliminate redundancy with X value
//                  from CLK signal.
// 		UDP modified:
//				-U_FD_P_RB_SB
//				-U_FD_N_R_S_NO_QN
//				-U_FD_P_RB_SB_NO	
// 		Change UDP to eliminate redundancy with functional test.
// 		UDP modified:
//				-U_LD_P_SB_RB_NO

		
// 06.Feb.2001 jmre suppress one line in UDP : U_LD_P_SB_RB_NO 
//			==> Warning with Modelsim : redundancy with line
//			number 14880.


primitive U_FD_N_SD_RB_SB_NO_QN  (QN, D, CP, TI, TE, RB, SB, NOTIFIER_REG);

    output QN;  
    input  D, CP, TI, TE, RB, SB, NOTIFIER_REG;
    reg    QN; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR WITH scan inputs  ( QN OUTPUT UDP )

    table
 
    //  D    CP     TI  TE  RB   SB  NOTIFIER_REG     :   Qtn :   Qtn+1
                                
        1   (10)    ?   0   1    1     ?              :   ?   :   0;  // clocked data
        0   (10)    ?   0   1    1     ?              :   ?   :   1;
                                
        0   (10)    ?   0   x    1     ?              :   ?   :   1;  // pessimism
        1   (10)    ?   0   1    x     ?              :   ?   :   0;  // pessimism
                        
        ?    ?      ?   ?   x    1     ?              :   1   :   1;  // pessimism
        ?    ?      ?   ?   1    x     ?              :   0   :   0;  // pessimism
                                                           
        1   (1x)    ?   0   1    1     ?              :   0   :   0;  // reducing pessimism
        0   (1x)    ?   0   1    1     ?              :   1   :   1;                          
        1   (x0)    ?   0   1    1     ?              :   0   :   0;  
        0   (x0)    ?   0   1    1     ?              :   1   :   1;  
                                
                                
        ?    ?      ?   ?   0    1     ?              :   ?   :   1;  // asynchronous clear and clear override
        ?    ?      ?   ?   ?    0     ?              :   ?   :   0;  // asynchronous set
                        
        ?   (?1)    ?   ?   ?    ?     ?              :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   ?    ?     ?              :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   ?    ?     ?              :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)  1     ?              :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?   ?   1   (?1)   ?              :   ?   :   -;  // ignore the edges on set 

        ?   (10)    0   1   1    1     ?              :   ?   :   1;  // scan data
        ?   (10)    1   1   1    1     ?              :   ?   :   0;  

        ?   (10)    0   1   x    1     ?              :   ?   :   1;
        ?   (10)    1   1   1    x     ?              :   ?   :   0;

        ?   (1x)    1   1   1    1     ?              :   0   :   0;  // reducing pessimism
        ?   (1x)    0   1   1    1     ?              :   1   :   1;  // for scan data                        
        ?   (x0)    1   1   1    1     ?              :   0   :   0;  
        ?   (x0)    0   1   1    1     ?              :   1   :   1;  

        1   (10)    1   x   1    1     ?              :   ?   :   0; // reducing pessimism
        0   (10)    0   x   1    1     ?              :   ?   :   1;                      

        1   (10)    1   x   1    x     ?              :   ?   :   0; // reducing pessimism
        0   (10)    0   x   x    1     ?              :   ?   :   1; 

        ?    ?      *   ?   ?    ?     ?              :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   1    1     ?              :   ?   :   -;  // ignore edges      
	?    ?      ?   ?   ?    ?     *              :   ?   :   x;  
    endtable
endprimitive

primitive U_FD_N_SD_RB_SB_QN  (QN, D, CP, TI, TE, RB, SB);

    output QN;  
    input  D, CP, TI, TE, RB, SB;
    reg    QN; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR WITH scan inputs  ( QN OUTPUT UDP )

    table
 
    //  D    CP     TI  TE  RB   SB                 :   Qtn :   Qtn+1
                                
        1   (10)    ?   0   1    1                  :   ?   :   0;  // clocked data
        0   (10)    ?   0   1    1                  :   ?   :   1;
                                
        0   (10)    ?   0   x    1                  :   ?   :   1;  // pessimism
        1   (10)    ?   0   1    x                  :   ?   :   0;  // pessimism
                        
        ?    ?      ?   ?   x    1                  :   1   :   1;  // pessimism
        ?    ?      ?   ?   1    x                  :   0   :   0;  // pessimism
                                                           
        1   (1x)    ?   0   1    1                  :   0   :   0;  // reducing pessimism
        0   (1x)    ?   0   1    1                  :   1   :   1;                          
        1   (x0)    ?   0   1    1                  :   0   :   0;  
        0   (x0)    ?   0   1    1                  :   1   :   1;  
                                
        ?    ?      ?   ?   0    1                  :   ?   :   1;  // asynchronous clear and clear override
        ?    ?      ?   ?   ?    0                  :   ?   :   0;  // asynchronous set
                        
        ?   (?1)    ?   ?   ?    ?                  :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   ?    ?                  :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   ?    ?                  :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)  1                  :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?   ?   1   (?1)                :   ?   :   -;  // ignore the edges on set 

        ?   (10)    0   1   1    1                  :   ?   :   1;  // scan data
        ?   (10)    1   1   1    1                  :   ?   :   0;  

        ?   (10)    0   1   x    1                  :   ?   :   1;
        ?   (10)    1   1   1    x                  :   ?   :   0;

        ?   (1x)    1   1   1    1                  :   0   :   0;  // reducing pessimism
        ?   (1x)    0   1   1    1                  :   1   :   1;  // for scan data                        
        ?   (x0)    1   1   1    1                  :   0   :   0;  
        ?   (x0)    0   1   1    1                  :   1   :   1;  

        1   (10)    1   x   1    1                  :   ?   :   0; // reducing pessimism
        0   (10)    0   x   1    1                  :   ?   :   1;                      

        1   (10)    1   x   1    x                  :   ?   :   0; // reducing pessimism
        0   (10)    0   x   x    1                  :   ?   :   1; 

        ?    ?      *   ?   ?    ?                  :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   1    1                  :   ?   :   -;  // ignore edges      
    endtable
endprimitive

primitive U_FD_N_SD_RB_SB_NO  (Q, D, CP, TI, TE, RB, SB, NOTIFIER_REG);

    output Q;  
    input  D, CP, TI, TE, RB, SB, NOTIFIER_REG;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR WITH scan inputs  ( Q OUTPUT UDP )

    table
 
    //  D    CP     TI  TE  RB   SB  NOTIFIER_REG     :   Qt  :   Qt+1
                                
        1   (10)    ?   0   1    1     ?              :   ?   :   1;  // clocked data
        0   (10)    ?   0   1    1     ?              :   ?   :   0;
                                
        0   (10)    ?   0   x    1     ?              :   ?   :   0;  // pessimism
        1   (10)    ?   0   1    x     ?              :   ?   :   1;  // pessimism
                        
        ?    ?      ?   ?   x    1     ?              :   0   :   0;  // pessimism
        ?    ?      ?   ?   1    x     ?              :   1   :   1;  // pessimism
                                                          
        1   (1x)    ?   0   1    1     ?              :   1   :   1;  // reducing pessimism
        0   (1x)    ?   0   1    1     ?              :   0   :   0;                          
        1   (x0)    ?   0   1    1     ?              :   1   :   1;  
        0   (x0)    ?   0   1    1     ?              :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0    ?     ?              :   ?   :   0;  // asynchronous clear and clear override
        ?    ?      ?   ?   1    0     ?              :   ?   :   1;  // asynchronous set
                        
        ?   (?1)    ?   ?   ?    ?     ?              :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   ?    ?     ?              :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   ?    ?     ?              :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)  1     ?              :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?   ?   1   (?1)   ?              :   ?   :   -;  // ignore the edges on set 

        ?   (10)    0   1   1    1     ?              :   ?   :   0;  // scan data
        ?   (10)    1   1   1    1     ?              :   ?   :   1;  

        ?   (10)    0   1   x    1     ?              :   ?   :   0;
        ?   (10)    1   1   1    x     ?              :   ?   :   1;

        ?   (1x)    1   1   1    1     ?              :   1   :   1;  // reducing pessimism
        ?   (1x)    0   1   1    1     ?              :   0   :   0;  // for scan data                        
        ?   (x0)    1   1   1    1     ?              :   1   :   1;  
        ?   (x0)    0   1   1    1     ?              :   0   :   0;  

        1   (10)    1   x   1    1     ?              :   ?   :   1; // reducing pessimism
        0   (10)    0   x   1    1     ?              :   ?   :   0;                      

        1   (10)    1   x   1    x     ?              :   ?   :   1; // reducing pessimism
        0   (10)    0   x   x    1     ?              :   ?   :   0; 

        ?    ?      *   ?   ?    ?     ?              :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   1    1     ?              :   ?   :   -;  // ignore edges      
	?    ?      ?   ?   ?    ?     *              :   ?   :   x;  
    endtable
endprimitive


primitive U_FD_P_SD_RB_SB_NO_QN (QN, D, CP, TI, TE, RB, SB, NOTIFIER_REG);

    output QN;  
    input  D, CP, TI, TE, RB, SB, NOTIFIER_REG;
    reg    QN; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR WITH scan inputs  ( QN OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  RB   SB  NOTIFIER_REG     :   Qtn :   Qtn+1
                                
        1   (01)    ?   0   1    1     ?              :   ?   :   0;  // clocked data
        0   (01)    ?   0   1    1     ?              :   ?   :   1;
                                
        0   (01)    ?   0   x    1     ?              :   ?   :   1;  // pessimism
        1   (01)    ?   0   1    x     ?              :   ?   :   0;  // pessimism
                        
        ?    ?      ?   ?   x    1     ?              :   1   :   1;  // pessimism
        ?    ?      ?   ?   1    x     ?              :   0   :   0;  // pessimism
                                                                      
        1   (x1)    ?   0   1    1     ?              :   0   :   0;  // reducing pessimism
        0   (x1)    ?   0   1    1     ?              :   1   :   1;                          
        1   (0x)    ?   0   1    1     ?              :   0   :   0;  
        0   (0x)    ?   0   1    1     ?              :   1   :   1;  
                                
                                
        ?    ?      ?   ?   0    1     ?              :   ?   :   1;  // asynchronous clear and clear override
        ?    ?      ?   ?   ?    0     ?              :   ?   :   0;  // asynchronous set
                        
        ?   (?0)    ?   ?   1    1     ?              :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   1    1     ?              :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?    ?     ?              :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)  1     ?              :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?   ?   1   (?1)   ?              :   ?   :   -;  // ignore the edges on set 

        ?   (01)    0   1   1    1     ?              :   ?   :   1;  // scan data
        ?   (01)    1   1   1    1     ?              :   ?   :   0;  // 

        ?   (01)    0   1   x    1     ?              :   ?   :   1;
        ?   (01)    1   1   1    x     ?              :   ?   :   0;

        ?   (x1)    1   1   1    1     ?              :   0   :   0;  // reducing pessimism
        ?   (x1)    0   1   1    1     ?              :   1   :   1;  // for scan data                        
        ?   (0x)    1   1   1    1     ?              :   0   :   0;  
        ?   (0x)    0   1   1    1     ?              :   1   :   1;  

        1   (01)    1   x   1    1     ?              :   ?   :   0; // reducing pessimism
        0   (01)    0   x   1    1     ?              :   ?   :   1;                      

        1   (01)    1   x   1    x     ?              :   ?   :   0; // reducing pessimism
        0   (01)    0   x   x    1     ?              :   ?   :   1; 

        ?    ?      *   ?   ?    ?     ?              :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   1    1     ?              :   ?   :   -;  // ignore 
        ?    ?      ?   ?   ?    ?     *              :   ?   :   x;
    endtable
endprimitive

primitive U_FD_P_SD_RB_SB_QN (QN, D, CP, TI, TE, RB, SB);

    output QN;  
    input  D, CP, TI, TE, RB, SB;
    reg    QN; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR WITH scan inputs  ( QN OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  RB   SB                 :   Qtn :   Qtn+1
                                
        1   (01)    ?   0   1    1                  :   ?   :   0;  // clocked data
        0   (01)    ?   0   1    1                  :   ?   :   1;
                                
        0   (01)    ?   0   x    1                  :   ?   :   1;  // pessimism
        1   (01)    ?   0   1    x                  :   ?   :   0;  // pessimism
                        
        ?    ?      ?   ?   x    1                  :   1   :   1;  // pessimism
        ?    ?      ?   ?   1    x                  :   0   :   0;  // pessimism
                                                                      
        1   (x1)    ?   0   1    1                  :   0   :   0;  // reducing pessimism
        0   (x1)    ?   0   1    1                  :   1   :   1;                          
        1   (0x)    ?   0   1    1                  :   0   :   0;  
        0   (0x)    ?   0   1    1                  :   1   :   1;  
                                
                                
        ?    ?      ?   ?   0    1                  :   ?   :   1;  // asynchronous clear and clear override
        ?    ?      ?   ?   ?    0                  :   ?   :   0;  // asynchronous set
                        
        ?   (?0)    ?   ?   1    1                  :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   1    1                  :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?    ?                  :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)  1                  :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?   ?   1   (?1)                :   ?   :   -;  // ignore the edges on set 

        ?   (01)    0   1   1    1                  :   ?   :   1;  // scan data
        ?   (01)    1   1   1    1                  :   ?   :   0;  // 

        ?   (01)    0   1   x    1                  :   ?   :   1;
        ?   (01)    1   1   1    x                  :   ?   :   0;

        ?   (x1)    1   1   1    1                  :   0   :   0;  // reducing pessimism
        ?   (x1)    0   1   1    1                  :   1   :   1;  // for scan data                        
        ?   (0x)    1   1   1    1                  :   0   :   0;  
        ?   (0x)    0   1   1    1                  :   1   :   1;  

        1   (01)    1   x   1    1                  :   ?   :   0; // reducing pessimism
        0   (01)    0   x   1    1                  :   ?   :   1;                      

        1   (01)    1   x   1    x                  :   ?   :   0; // reducing pessimism
        0   (01)    0   x   x    1                  :   ?   :   1; 

        ?    ?      *   ?   ?    ?                  :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   1    1                  :   ?   :   -;  // ignore 
    endtable
endprimitive

primitive U_FD_P_SD_RB_SB_NO  (Q, D, CP, TI, TE, RB, SB, NOTIFIER_REG);

    output Q;  
    input  D, CP, TI, TE, RB, SB, NOTIFIER_REG;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR WITH scan inputs  ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  RB   SB  NOTIFIER_REG     :   Qt  :   Qt+1
                                
        1   (01)    ?   0   1    1     ?              :   ?   :   1;  // clocked data
        0   (01)    ?   0   1    1     ?              :   ?   :   0;
                                
        0   (01)    ?   0   x    1     ?              :   ?   :   0;  // pessimism
        1   (01)    ?   0   1    x     ?              :   ?   :   1;  // pessimism
                        
        ?    ?      ?   ?   x    1     ?              :   0   :   0;  // pessimism
        ?    ?      ?   ?   1    x     ?              :   1   :   1;  // pessimism
                                                                      
        1   (x1)    ?   0   1    1     ?              :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0   1    1     ?              :   0   :   0;                          
        1   (0x)    ?   0   1    1     ?              :   1   :   1;  
        0   (0x)    ?   0   1    1     ?              :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0    ?     ?              :   ?   :   0;  // asynchronous clear and clear override
        ?    ?      ?   ?   1    0     ?              :   ?   :   1;  // asynchronous set
                        
        ?   (?0)    ?   ?   1    1     ?              :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   1    1     ?              :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?    ?     ?              :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)  1     ?              :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?   ?   1   (?1)   ?              :   ?   :   -;  // ignore the edges on set 

        ?   (01)    0   1   1    1     ?              :   ?   :   0;  // scan data
        ?   (01)    1   1   1    1     ?              :   ?   :   1;  // 

        ?   (01)    0   1   x    1     ?              :   ?   :   0;
        ?   (01)    1   1   1    x     ?              :   ?   :   1;

        ?   (x1)    1   1   1    1     ?              :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1   1    1     ?              :   0   :   0;  // for scan data                        
        ?   (0x)    1   1   1    1     ?              :   1   :   1;  
        ?   (0x)    0   1   1    1     ?              :   0   :   0;  

        1   (01)    1   x   1    1     ?              :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1    1     ?              :   ?   :   0;                      

        1   (01)    1   x   1    x     ?              :   ?   :   1; // reducing pessimism
        0   (01)    0   x   x    1     ?              :   ?   :   0; 

        ?    ?      *   ?   ?    ?     ?              :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   1    1     ?              :   ?   :   -;  // ignore 
        ?    ?      ?   ?   ?    ?     *              :   ?   :   x;
    endtable
endprimitive


primitive U_FJK_N_RB_SB_X_NO (Q, J, K, CP, RB, SB, NOTIFIER_REG);
 
// FUNCTION :NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//           ASYNCHRONOUS CLEAR AND  SET  ( Q OUTPUT UDP )
//           OUTPUT GOES TO "X" WHEN BOTH CLEAR AND SET ARE ACTIVE 

    output Q;
    reg    Q;  

    input  J,K,
           CP,                                  // Clock.
           RB,                                  // Clear input.
           SB,                                  // Set input.
	   NOTIFIER_REG;

    table
      // J   K   CP  RB   SB   NOTIFIER_REG   : Qtn : Qtn+1

         0   0  (10) 1    1      ?            :  ?  :   - ;    // Output retains the 

         0   1  (10) 1    1      ?            :  ?  :   0 ;    // Clocked J and K.
         0   1  (10) x    1      ?            :  ?  :   0 ;    // pessimism
         ?   ?   ?   x    1      ?            :  0  :   0 ;    // pessimism

         1   0  (10) 1    1      ?            :  ?  :   1 ;    
         1   0  (10) 1    x      ?            :  ?  :   1 ;    // pessimism
         ?   ?   ?   1    x      ?            :  1  :   1 ;    // pessimism

         1   1  (10) 1    1      ?            :  0  :   1 ;    // Clocked toggle.
         1   1  (10) 1    1      ?            :  1  :   0 ;
         
         ?   1  (10) x    1      ?            :  1  :   0 ;    //pessimism
         1   ?  (10) 1    x      ?            :  0  :   1 ;


         0   0  (1x) 1    1      ?            :  ?  :   - ;    //possible clocked JK
         0   1  (1x) 1    1      ?            :  0  :   0 ;   
         1   0  (1x) 1    1      ?            :  1  :   1 ;
         0   0  (x0) 1    1      ?            :  ?  :   - ;
         0   1  (x0) 1    1      ?            :  0  :   0 ;
         1   0  (x0) 1    1      ?            :  1  :   1 ;

                                
         *   ?   ?   1    1      ?            :  ?  :   - ;    // Insensitive to 
         ?   *   ?   1    1      ?            :  ?  :   - ;    // transitions on J and K
                                                               // with steady clock.

         ?   ?   ?   0    1      ?            :  ?  :  0  ;    // Clear.
         ?   ?   ?   1    0      ?            :  ?  :  1  ;    // Set.
         ?   ?   ?   0    0      ?            :  ?  :  x  ;    // ILLEGAL 

         x   0   f   1    1      ?            :  1  :  1  ;
         x   1   f   1    1      ?            :  1  :  0  ;
         0   x   f   1    1      ?            :  0  :  0  ;
         1   x   f   1    1      ?            :  0  :  1  ;
         
         x   0 (1x)  1    1      ?            :  1  :   1 ;    //possible clocked with
         0   x (1x)  1    1      ?            :  0  :   0 ;    //possible J & K                                 
         x   0 (x0)  1    1      ?            :  1  :   1 ;
         0   x (x0)  1    1      ?            :  0  :   0 ;


         ?   ? (?1)  ?    ?      ?            :   ? :  -  ;   
         ?   ? (0x)  ?    ?      ?            :   ? :  -  ;

         ?   ?   ? (?1)   1      ?            :  ?  :  -  ;    //ignore changes on set and
         ?   ?   ?   1  (?1)     ?            :  ?  :  -  ;    //reset.
	 ?   ?   ?   ?    ?      *            :  ?  :  x  ;

    endtable

endprimitive


primitive U_FJK_P_RB_SB_X_NO (Q, J, K, CP, RB, SB, NOTIFIER_REG);
 
// FUNCTION :POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//           ASYNCHRONOUS CLEAR AND  SET  ( Q OUTPUT UDP )
//           OUTPUT GOES TO "x" WHEN BOTH CLEAR AND SET ARE ACTIVE 

    output Q;
    reg    Q;   
    input   J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB,                                  // Set input.
            NOTIFIER_REG;                      

    table
      // J   K  CP  RB   SB   NOTIFIER_REG   : Qtn : Qtn+1

         0   0  (01) 1    1     ?            :  ?  :   - ;    // Output retains the 

         0   1  (01) 1    1     ?            :  ?  :   0 ;    // Clocked J and K.
         0   1  (01) x    1     ?            :  ?  :   0 ;    // pessimism
         ?   ?   ?   x    1     ?            :  0  :   0 ;    // pessimism

         1   0  (01) 1    1     ?            :  ?  :   1 ;    
         1   0  (01) 1    x     ?            :  ?  :   1 ;    // pessimism
         ?   ?   ?   1    x     ?            :  1  :   1 ;    // pessimism

         1   1  (01) 1    1     ?            :  0  :   1 ;    // Clocked toggle.
         1   1  (01) 1    1     ?            :  1  :   0 ;
         
         ?   1  (01) x    1     ?            :  1  :   0 ;     //pessimism
         1   ?  (01) 1    x     ?            :  0  :   1 ;


         0   0  (x1) 1    1     ?            :  ?  :   - ;   //possible clocked JK
         0   1  (x1) 1    1     ?            :  0  :   0 ;   
         1   0  (x1) 1    1     ?            :  1  :   1 ;
         0   0  (0x) 1    1     ?            :  ?  :   - ;
         0   1  (0x) 1    1     ?            :  0  :   0 ;
         1   0  (0x) 1    1     ?            :  1  :   1 ;

                                
         *   ?   ?   1    1     ?            :  ?  :   - ;    // Insensitive to 
         ?   *   ?   1    1     ?            :  ?  :   - ;    // transitions on J and K
                                                              // with steady clock.

         ?   ?   ?   0    1     ?            :  ?  :  0  ;    // Clear.
         ?   ?   ?   1    0     ?            :  ?  :  1  ;    // Set.
         ?   ?   ?   0    0     ?            :  ?  :  x  ;    // ILLEGAL 

         x   0   r   1    1     ?            :  1  :  1  ;
         x   1   r   1    1     ?            :  1  :  0  ;
         0   x   r   1    1     ?            :  0  :  0  ;
         1   x   r   1    1     ?            :  0  :  1  ;
         
         x   0 (x1)  1    1     ?            :  1  :   1 ;        //possible clocked with
         0   x (x1)  1    1     ?            :  0  :   0 ;        //possible J & K                                 
         x   0 (0x)  1    1     ?            :  1  :   1 ;
         0   x (0x)  1    1     ?            :  0  :   0 ;


         ?   ? (?0)  1    1     ?             :   ? :  -  ;    //ignore falling clock.
         ?   ? (1x)  1    1     ?             :   ? :  -  ;

         ?   ?   ? (?1)   1     ?            :  ?  :  -  ;    //ignore changes on set and
         ?   ?   ?   1  (?1)    ?            :  ?  :  -  ;    //reset.
         ?   ?   ?   ?    ?     *            :  ?  :  x  ;

    endtable

endprimitive


primitive U_FT_N_RB_SB_X_NO (Q, CP, RB, SB, NOTIFIER_REG);
                       
//
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ILLEGAL OUPUT WHEN BOTH CLEAR AND PRESET ARE LOW ( Q OUTPUT UDP ).


    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB,
           NOTIFIER_REG;

    table
      //   CP    RB    SB   NOTIFIER_REG   :  QTN  :  QTN+1
           f     1     1      ?            :   0   :    1   ;     // Toggle condition.
           f     1     1      ?            :   1   :    0   ;

           ?     0     1      ?            :   ?   :    0   ;     //asynchronous reset.
           ?     1     0      ?            :   ?   :    1   ;     //asynchronous set.
           ?     0     0      ?            :   ?   :    x   ;     //illegal
                         
          (?1)   ?     ?      ?            :   ?   :    -   ;
          (0x)   ?     ?      ?            :   ?   :    -   ;
           ?    (?1)   ?      ?            :   ?   :    -   ;
           ?     ?    (?1)    ?            :   ?   :    -   ;

           f     x     1      ?            :   1   :    0   ;     // pessimism
           f     1     x      ?            :   0   :    1   ;     // pessimism  
           ?     x     1      ?            :   0   :    0   ;
           ?     1     x      ?            :   1   :    1   ;
           ?     ?     ?      *            :   ?   :    x   ;
    endtable
endprimitive

primitive U_FT_N_TE_RB_SB_NO (Q, TE, CP, RB, SB,NOTIFIER_REG);

// FUNCTION :  NEGATIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH TOGGLE ENABLE
//             AND ACTIVE LOW ASYNCHRONOUS SET AND RESET ( Q OUTPUT UDP ).
//

    output Q; 
    reg    Q;
    input  TE,
           CP,                                     // Clock.
           RB,                                     // Clear input.
           SB,                                     // Set input
           NOTIFIER_REG;

    table
      //   TE     CP       RB      SB      NOTIFIER_REG      :  QTN  :  QTN+1
           1      f        1       1         ?               :   0   :    1   ;     // Toggle condition.
           1      f        1       1         ?               :   1   :    0   ;
                                        
           1     (?1)      ?       ?         ?               :   ?   :    -   ;
           1     (0x)      ?       ?         ?               :   ?   :    -   ;
                                        
           ?      ?       (?1)     ?         ?               :   ?   :    -   ;
           ?      ?        ?      (?1)       ?               :   ?   :    -   ;
           ?      ?        0       1         ?               :   ?   :    0   ;  
           ?      ?        ?       0         ?               :   ?   :    1   ;  
           1      f        x       1         ?               :   1   :    0   ;     // pessimism
           1      f        1       x         ?               :   0   :    1   ;     // pessimism
                                        
           0      ?        1       1         ?               :   ?   :    -   ;  
           ?      ?        x       1         ?               :   0   :    0   ;
           ?      ?        1       x         ?               :   1   :    1   ;  
           *      ?        ?       ?         ?               :   ?   :    -   ;  
           ?      ?        ?       ?         *               :   ?   :    x   ;
    endtable
endprimitive

primitive U_FT_P_RB_SB_X_NO (Q, CP, RB, SB, NOTIFIER_REG);
                       
//
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ILLEGAL OUPUT WHEN BOTH CLEAR AND PRESET ARE LOW ( Q OUTPUT UDP ).


    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB,
           NOTIFIER_REG;
    

    table
      //   CP    RB    SB    NOTIFIER_REG    :  QTN  :  QTN+1
           r     1     1       ?             :   0   :    1   ;     // Toggle condition.
           r     1     1       ?             :   1   :    0   ;

           ?     0     1       ?             :   ?   :    0   ;     //asynchronous reset.
           ?     1     0       ?             :   ?   :    1   ;     //asynchronous set.
           ?     0     0       ?             :   ?   :    x   ;     //illegal
                         
          (?0)   1     1       ?             :   ?   :    -   ;
          (1x)   1     1       ?             :   ?   :    -   ;
           ?    (?1)   ?       ?             :   ?   :    -   ;
           ?     ?    (?1)     ?             :   ?   :    -   ;

           r     x     1       ?             :   1   :    0   ;     // pessimism
           r     1     x       ?             :   0   :    1   ;     // pessimism  
           ?     x     1       ?             :   0   :    0   ;
           ?     1     x       ?             :   1   :    1   ;
           ?     ?     ?       *             :   ?   :    x   ;
    endtable

endprimitive


primitive U_FT_P_TE_RB_SB_NO (Q, TE, CP, RB, SB, NOTIFIER_REG);

// FUNCTION :  POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH TOGGLE ENABLE
//             AND ACTIVE LOW ASYNCHRONOUS SET AND RESET ( Q OUTPUT UDP ).
//

    output Q; 
    reg    Q;
    input  TE,
           CP,                                     // Clock.
           RB,                                     // Clear input.
           SB,                                     // Set input
           NOTIFIER_REG;     

    table
      //   TE     CP       RB      SB      NOTIFIER_REG :  QTN  :  QTN+1
           1      r        1       1         ?          :   0   :    1   ;     // Toggle condition.
           1      r        1       1         ?          :   1   :    0   ;
                                        
           1     (?0)      1       1         ?          :   ?   :    -   ;
           1     (1x)      1       1         ?          :   ?   :    -   ;
                                        
           ?      ?       (?1)     ?         ?          :   ?   :    -   ;
           ?      ?        ?      (?1)       ?          :   ?   :    -   ;
           ?      ?        0       ?         ?          :   ?   :    0   ;  
           ?      ?        1       0         ?          :   ?   :    1   ;  
           1      r        x       1         ?          :   1   :    0   ;     // pessimism
           1      r        1       x         ?          :   0   :    1   ;     // pessimism
                                        
           0      ?        1       1         ?          :   ?   :    -   ;  
           ?      ?        x       1         ?          :   0   :    0   ;
           ?      ?        1       x         ?          :   1   :    1   ;  
           *      ?        ?       ?         ?          :   ?   :    -   ;  
           ?      ?        ?       ?         *          :   ?   :    x   ;
    endtable


endprimitive

primitive U_LD_N_RB_SB_X_NO ( Q, D, CK, RB, SB, NOTIFIER_REG );
    output Q; 
    reg    Q;
    input D,
          CK,
          RB,
          SB,
          NOTIFIER_REG;


// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).

table
    //  D   CK  RB  SB  NOTIFIER_REG  :   Qt  :   Qt+1

        1   0   1   1     ?           :   ?   :   1;  // clock enabled transparent data.
        0   0   1   1     ?           :   ?   :   0;

        1   x   1   1     ?           :   1   :   1;  // possible enabled clock.
        0   x   1   1     ?           :   0   :   0;

        ?   ?   0   1     ?           :   ?   :   0;  // asynchronous reset.
        ?   ?   1   0     ?           :   ?   :   1;  // asynchronous set
        ?   ?   0   0     ?           :   ?   :   x;  // Illegal output 

        ?   1   1   1     ?           :   ?   :   -;  // clock disabled.

        0   0   x   1     ?           :   ?   :   0;  // pessimism 
        0   ?   x   1     ?           :   0   :   0;  // pessimism 
        1   0   1   x     ?           :   ?   :   1;  // pessimism 
        1   ?   1   x     ?           :   1   :   1;  // pessimism                       

        ?   1   x   1     ?           :   0  :    0;  // set inactive                    
        ?   1   1   x     ?           :   1  :    1;  // reset inactive 
      
        ?   p   1   1     ?           :   ?  :    -;                 
	?   ?   ?   ?     *           :   ?  :    x;                                              
    endtable 

endprimitive


primitive U_LD_N_SB_RB_QN_NO ( QN, D, CK, RB, SB, NOTIFIER_REG);
    output QN; 
    reg    QN;
    input D,
          CK,
          RB,
          SB,
          NOTIFIER_REG;

// FUNCTION :  NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//             ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).

table
    //  D   CK  RB  SB  NOTIFIER_REG  :  QNtn :  QNtn+1

        1   0   1   1     ?           :   ?   :   0;  // clock enabled transparent data.
        0   0   1   1     ?           :   ?   :   1;

        1   x   1   1     ?           :   0   :   0;  // possible enabled clock.
        0   x   1   1     ?           :   1   :   1;

        ?   ?   0   1     ?           :   ?   :   1;  // asynchronous reset.
        ?   ?   1   0     ?           :   ?   :   0;  // asynchronous set 
        ?   ?   0   0     ?           :   ?   :   1;  // asynchronous set override.

        ?   1   1   1     ?           :   ?   :   -;  // clock disabled.

        0   0   x   1     ?           :   ?   :   1;  // pessimism 
        0   ?   x   1     ?           :   1   :   1;  // pessimism 
        1   0   1   x     ?           :   ?   :   0;  // pessimism 
        1   ?   1   x     ?           :   0   :   0;  // pessimism                       

        ?   1   x   1     ?           :   1  :    1;  // set inactive                    
        ?   1   1   x     ?           :   0  :    0;  // reset inactive 
      
        ?   p   1   1     ?           :   ?  :    -;                 
	?   ?   ?   ?     *           :   ?  :    x;                                              
    endtable 

endprimitive


primitive U_LD_P_RB_SB_X_NO ( Q, D, CK, RB, SB, NOTIFIER_REG );
    output Q; 
    reg    Q;
    input  D, 
          CK,
          RB,
          SB,
	  NOTIFIER_REG;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET. ILLEGAL OUTPUT WHEN BOTH SET AND
//            RESET ARE LOW ( Q OUTPUT UDP ).


table
    //  D   CK  RB  SB  NOTIFIER_REG  :   Qt  :   Qt+1

        1   1   1   1     ?           :   ?   :   1;  // clock enabled transparent data.
        0   1   1   1     ?           :   ?   :   0;

        1   x   1   1     ?           :   1   :   1;  // possible enabled clock.
        0   x   1   1     ?	      :   0   :   0;

        ?   ?   0   1     ?	      :   ?   :   0;  // asynchronous reset.
        ?   ?   1   0     ?	      :   ?   :   1;  // asynchronous set.
        ?   ?   0   0     ?	      :   ?   :   x;  // illegal output.

        ?   0   1   1     ?	      :   ?   :   -;  // clock disabled.

        0   1   x   1     ?	      :   ?   :   0;  // pessimism 
        0   ?   x   1     ?	      :   0   :   0;  // pessimism 
        1   1   1   x     ?	      :   ?   :   1;  // pessimism 
        1   ?   1   x     ?	      :   1   :   1;  // pessimism

        ?   0   x   1     ?	      :   0   :   0;  // set inactive
        ?   0   1   x     ?	      :   1   :   1;  // reset inactive  

        ?   n   1   1     ?	      :   ?   :   -;
	?   ?   ?   ?     *	      :   ?   :   x;
    endtable

endprimitive

primitive U_LD_P_SB_RB_QN_NO ( QN, D, CK, RB, SB, NOTIFIER_REG );
   output QN; 
   reg    QN;
   input  D, 
         CK, 
         RB, 
         SB,
	 NOTIFIER_REG;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET ( QN OUTPUT UDP ).


table
    //  D   CK  RB  SB  NOTIFIER_REG  :   Qtn : Qtn+1

        1   1   1   1     ?           :   ?   :   0;  // clock enabled transparent data.
        0   1   1   1     ?           :   ?   :   1;

        1   x   1   1     ?           :   0   :   0;  // possible enabled clock.
        0   x   1   1     ?           :   1   :   1;

        ?   ?   0   1     ?           :   ?   :   1;  // asynchronous reset.
        ?   ?   1   0     ?           :   ?   :   0;  // asynchronous set 
        ?   ?   0   0     ?           :   ?   :   1;  // asynchronous set
// add by hua       
        *   0   1   1     ?           :   ?   :   -;  
        ?   0   r   1     ?           :   ?   :   -;
        ?   0   1   r     ?           :   ?   :   -;
//end of addition.

//delete by hua        ?   0   1   1     ?           :   ?   :   -;  // clock disabled.

        0   1   x   1     ?           :   ?   :   1;  // pessimism 
        0   ?   x   1     ?           :   1   :   1;  // pessimism 
        1   1   1   x     ?           :   ?   :   0;  // pessimism 
        1   ?   1   x     ?           :   0   :   0;  // pessimism                       

        ?   0   x   1     ?           :   1  :    1;  // set inactive                    
        ?   0   1   x     ?           :   0  :    0;  // reset inactive    
  
        ?   n   1   1     ?           :   ?  :    -;               
// added by Rihua Pan
//        ?   ?   0   ?     ?           :   ?  :    1; // asynchronous reset
// end of modification
	?   ?   ?   ?     *           :   ?  :    x;               
   endtable  


endprimitive


primitive U_FT_N_TE_RB_SB_QN (QN, TE, CP, RB, SB);

// FUNCTION :  POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH TOGGLE ENABLE
//             AND ACTIVE LOW ASYNCHRONOUS SET AND RESET ( NOT Q OUTPUT UDP ).

    output QN; 
    reg    QN;
    input  TE,CP,RB,SB;

    table
      //   TE     CP       RB      SB      :  QTN  :  QTN+1
           1      f        1       1       :   0   :    1   ;     // Toggle condition.
           1      f        1       1       :   1   :    0   ;
                                        
           1     (?1)      1       1       :   ?   :    -   ;
           1     (0x)      1       1       :   ?   :    -   ;
                                        
           ?      ?       (?1)     ?       :   ?   :    -   ;
           ?      ?        ?      (?1)     :   ?   :    -   ;
           ?      ?        0       ?       :   ?   :    1   ;  
           ?      ?        1       0       :   ?   :    0   ;  
           1      f        x       1       :   1   :    0   ;     // pessimism
           1      f        1       x       :   0   :    1   ;     // pessimism
                                        
           0      ?        1       1       :   ?   :    -   ;  
           ?      ?        x       1       :   0   :    0   ;
           ?      ?        1       x       :   1   :    1   ;  
           *      ?        ?       ?       :   ?   :    -   ;  

    endtable
endprimitive

primitive U_FT_N_TE_RB_SB_QN_NO (QN, TE, CP, RB, SB,NOTIFIER_REG);

// FUNCTION :  POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH TOGGLE ENABLE
//             AND ACTIVE LOW ASYNCHRONOUS SET AND RESET ( NOT Q OUTPUT UDP ).
//

    output QN; 
    reg    QN;
    input  TE,CP,RB,SB,NOTIFIER_REG;

    table
      //   TE     CP       RB      SB  NOTIFIER_REG    :  QTN  :  QTN+1
           1      f        1       1     ?             :   0   :    1   ;     // Toggle condition.
           1      f        1       1     ?             :   1   :    0   ;
                                        
           1     (?1)      1       1     ?             :   ?   :    -   ;
           1     (0x)      1       1     ?             :   ?   :    -   ;
                                        
           ?      ?       (?1)     ?     ?             :   ?   :    -   ;
           ?      ?        ?      (?1)   ?             :   ?   :    -   ;
           ?      ?        0       ?     ?             :   ?   :    1   ;  
           ?      ?        1       0     ?             :   ?   :    0   ;  
           1      f        x       1     ?             :   1   :    0   ;     // pessimism
           1      f        1       x     ?             :   0   :    1   ;     // pessimism
                                        
           0      ?        1       1     ?             :   ?   :    -   ;  
           ?      ?        x       1     ?             :   0   :    0   ;
           ?      ?        1       x     ?             :   1   :    1   ;  
           *      ?        ?       ?     ?             :   ?   :    -   ;  
           ?      ?        ?       ?     *             :   ?   :    x   ;
    endtable
endprimitive


primitive U_FJK_N_RB_SB_QN_NO (QN, J, K, CP, RB, SB, NOTIFIER_REG);
 
// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//            ASYNCHRONOUS CLEAR AND  SET  ( QN OUTPUT UDP ).  


    output QN;
    reg    QN;  
    input  J,K,CP,RB,SB,NOTIFIER_REG;

    table
      // J   K   CP   RB   SB : NOTIFIER_REG : Qtn : Qtn+1

         0   0  (10)  1    1      ?          :  ?  :   - ;    // Output retains the 

         0   1  (10)  1    1      ?          :  ?  :   1 ;    // Clocked J and K.
         0   1  (10)  x    1      ?          :  ?  :   1 ;    // pessimism
         ?   ?   ?    x    1      ?          :  1  :   1 ;    // pessimism

         1   0  (10)  1    1      ?          :  ?  :   0 ;    
         1   0  (10)  1    x      ?          :  ?  :   0 ;    // pessimism
         ?   ?   ?    1    x      ?          :  0  :   0 ;    // pessimism

         1   1  (10)  1    1      ?          :  1  :   0 ;    // Clocked toggle.
         1   1  (10)  1    1      ?          :  0  :   1 ;
                                                     
         ?   1  (10)  x    1      ?          :  0  :   1 ;     //pessimism
         1   ?  (10)  1    x      ?          :  1  :   0 ;
  
         0   0  (x0)  1    1      ?          :  ?  :   - ;   //possible clocked JK
         0   1  (x0)  1    1      ?          :  1  :   1 ;   
         1   0  (x0)  1    1      ?          :  0  :   0 ;
         0   0  (1x)  1    1      ?          :  ?  :   - ;
         0   1  (1x)  1    1      ?          :  1  :   1 ;
         1   0  (1x)  1    1      ?          :  0  :   0 ;

                                 
         *   ?   ?    1    1      ?          :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1      ?          :  ?  :   - ;    // transitions on J and K
                                                 // with steady clock.

         ?   ?   ?    1    0      ?          :  ?  :  0  ;    // Set.
         ?   ?   ?    0    1      ?          :  ?  :  1  ;    // clear 
         ?   ?   ?    0    0      ?          :  ?  :  0  ;    // clear and  clear override. 

         ?   ? (?1)   1    1      ?          :   ? :  -  ;    //ignore falling clock.
         ?   ? (0x)   1    1      ?          :   ? :  -  ;
    
         x   0   f    1    1      ?          :   0  :   0 ;         // reducing pessimism for unknown J 
         x   1   f    1    1      ?          :   0  :   1 ;         // reducing pessimism for unknown J 
         0   x   f    1    1      ?          :   1  :   1 ;         // reducing pessimism for unknown K 
         1   x   f    1    1      ?          :   1  :   0 ;         // reducing pessimism for unknown K 

         x   0  (x0)  1    1      ?          :   0  :   0 ;        //possible clocked with
         0   x  (x0)  1    1      ?          :   1  :   1 ;        //possible J & K                                 
         x   0  (1x)  1    1      ?          :   0  :   0 ;
         0   x  (1x)  1    1      ?          :   1  :   1 ;

         ?   ?   ?  (?1)   1      ?          :   ?  :  -  ;    //ignore changes on set and
         ?   ?   ?   1   (?1)     ?          :   ?  :  -  ;    //reset.
         ?   ?   ?   ?     ?      *          :   ?  :  x  ;

    endtable

endprimitive

// These are definitions of the two previous cells - not declared as problems appear
// with X generation through notifier.
// definition = TFF.U_FT_N_TE_RB_SB_QN o.q/i/b=1 cen.te clk.cp/i clr.rb/i set.sb/i;
// definition = TFF.U_FT_N_TE_RB_SB_QN_NO o.q/i/b=1 cen.te clk.cp/i clr.rb/i set.sb/i no.notifier_reg;

primitive U_FD_N_SD_RB_NO_QN (QN, D, CP, TI, TE, RB, NOTIFIER_REG);

    output QN;  
    input  D, CP, TI, TE, RB, NOTIFIER_REG;
    reg    QN; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR WITH scan inputs  ( QN OUTPUT UDP )

    table
 
    //  D    CP     TI  TE  RB NOTIFIER_REG	:   Qtn :   Qtn+1
                               
        1   (10)    ?   0   1    ?		:   ?	:   0;  // clocked data
        0   (10)    ?   0   1    ?		:   ?	:   1;
                                                                                            	     
        1   (1x)    ?   0   1    ?		:   0	:   0;  // reducing pessimism
        0   (1x)    ?   0   1    ?		:   1	:   1;  			
        1   (x0)    ?   0   1    ?		:   0	:   0;  
        0   (x0)    ?   0   1    ?		:   1	:   1;                                 
                              
        ?    ?      ?   ?   0    ?		:   ?	:   1;  // asynchronous clear and clear override
                        
        ?   (?1)    ?   ?   ?    ?		:   ?	:   -;  // ignore rising clock
        ?   (0x)    ?   ?   ?    ?		:   ?	:   -;  // ignore rising clock
        *    ?      ?   ?   ?    ?		:   ?	:   -;  // ignore the edges on data
                               
        ?    ?      ?   ?  (?1)  ?		:   ?	:   -;  // ignore the edges on clear 

        ?   (10)    0   1   1    ?		:   ?	:   1;  // scan data
        ?   (10)    1   1   1    ?		:   ?	:   0;  

        ?   (1x)    1   1   1    ?		:   0	:   0;  // reducing pessimism
        ?   (1x)    0   1   1    ?		:   1	:   1;  // for scan data			
        ?   (x0)    1   1   1    ?		:   0	:   0;  
        ?   (x0)    0   1   1    ?		:   1	:   1;  

        1   (10)    1   x   1    ?		:   ?	:   0; // reducing pessimism
        0   (10)    0   x   1    ?		:   ?	:   1;  		    

        ?    ?      *   ?   ?    ?		:   ?	:   -;  // ignore edges      
        ?    ?      ?   *   1    ?		:   ?	:   -;  // ignore edges      
	?    ?      ?   ?   ?    *		:   ?	:   x;  
    endtable
endprimitive



primitive U_A2_OI2_OI(Z, A, B, C, D);

    output  Z;
    input   A, B, C, D;

// FUNCTION :  2-INPUT AND and 2-INPUT NOR  into 2-INPUT NOR 

    table
    // A  B  C  D  :  Z

       1  1  ?  ?  :  0 ;
       ?  ?  0  0  :  0 ;

       0  ?  1  ?  :  1 ;
       0  ?  ?  1  :  1 ;

       ?  0  1  ?  :  1 ;
       ?  0  ?  1  :  1 ;
    endtable
endprimitive
      

primitive U_ADDR2_C   (CO, A, B, CI);
    output CO;
    input A, B, CI;

// FUNCTION :  FULL ADDER CARRY OUT TERM

    table
    //  A   B   CI  :   CO
        1   1   ?   :   1 ;
        1   ?   1   :   1 ;
        ?   1   1   :   1 ;
        0   0   ?   :   0 ;
        0   ?   0   :   0 ;
        ?   0   0   :   0 ;

    endtable
endprimitive   

primitive U_ADDR2_S (S, A, B, CI);
    output S;
    input A, B, CI;

// FUNCTION :  FULL ADDER SUM TERM

    table
    //  A   B   CI  :   S
        0   0   0   :   0 ;
        0   0   1   :   1 ;
        0   1   0   :   1 ;
        0   1   1   :   0 ;
        1   0   0   :   1 ;
        1   0   1   :   0 ;
        1   1   0   :   0 ;
        1   1   1   :   1 ;

    endtable
endprimitive 
primitive U_AO3 (Z, A, B, C);

    input A, B, C ;
    output Z;

// FUNCTION : 3-INPUT AND-OR GATE 
 
  table
 
// A      B      C  :  Z
   
   1      1      ?  :  1;
   1      ?      1  :  1;
   ?      1      1  :  1;
 
   0      0      ?  :  0;
   0      ?      0  :  0;
   ?      0      0  :  0;

   endtable
endprimitive  
primitive U_AOI_1_2_2(Y, A, B, C, D, E);

    output  Y;
    input   A, B, C, D, E;  

// FUNCTION : TWO 2-INPUT and ONE SINGLE INPUT AND into 3-INPUT NOR
    
    table
    // A  B  C  D  E :  Y

       1  1  ?  ?  ?   :  0 ;
       ?  ?  1  1  ?   :  0 ;
       ?  ?  ?  ?  1   :  0 ;

       0  ?  0  ?  0   :  1 ;
       0  ?  ?  0  0   :  1 ;
       ?  0  0  ?  0   :  1 ;
       ?  0  ?  0  0   :  1 ;

    endtable
endprimitive
      

primitive U_AOI_1_2_3(Y, A, B, C, D, E, F);

    output  Y;
    input   A, B, C, D, E, F;

// FUNCTION : 1-INPUT, 2-INPUT and 3-INPUT AND into 3-INPUT NOR
    
    table
    // A  B  C  D  E  F :  Y

       1  1  1  ?  ?  ? :  0 ;
       ?  ?  ?  1  1  ? :  0 ;
       ?  ?  ?  ?  ?  1 :  0 ;

       0  ?  ?  0  ?  0 :  1 ;
       0  ?  ?  ?  0  0 :  1 ;
       ?  0  ?  0  ?  0 :  1 ;
       ?  0  ?  ?  0  0 :  1 ;
       ?  ?  0  0  ?  0 :  1 ;
       ?  ?  0  ?  0  0 :  1 ;

    endtable
endprimitive
      

primitive U_AOI_2_2(Z, A, B, C, D);

    output  Z;
    input   A, B, C, D;

// FUNCTION : 2-WIDE 2-INPUT AND into 2-INPUT NOR
    
    table
    // A  B  C  D  :  Z

       1  1  ?  ?  :  0 ;
       ?  ?  1  1  :  0 ;

       0  ?  0  ?  :  1 ;
       0  ?  ?  0  :  1 ;

       ?  0  0  ?  :  1 ;
       ?  0  ?  0  :  1 ;
    endtable
endprimitive
      

primitive U_AOI_2_2_2(Y, A, B, C, D, E, F);

    output  Y;
    input   A, B, C, D, E, F;

// FUNCTION : 3-WIDE 2-INPUT AND into 3-INPUT NOR
    
    table
    // A  B  C  D  E  F :  Y

       1  1  ?  ?  ?  ? :  0 ;
       ?  ?  1  1  ?  ? :  0 ;
       ?  ?  ?  ?  1  1 :  0 ;

       0  ?  0  ?  0  ? :  1 ;
       0  ?  0  ?  ?  0 :  1 ;
       0  ?  ?  0  0  ? :  1 ;
       0  ?  ?  0  ?  0 :  1 ;
       ?  0  0  ?  0  ? :  1 ;
       ?  0  0  ?  ?  0 :  1 ;
       ?  0  ?  0  0  ? :  1 ;
       ?  0  ?  0  ?  0 :  1 ;

    endtable
endprimitive
      

primitive U_AOI_2_3(Y, A, B, C, D, E);

    output  Y;
    input   A, B, C, D, E;

// FUNCTION : 2-INPUT AND and 3-INPUT AND into 2-INPUT NOR   

    table
    // A  B  C  D  E     :  Y

       1  1  1  ?  ?     :  0 ;
       ?  ?  ?  1  1     :  0 ;

       0  ?  ?  0  ?     :  1 ;
       ?  0  ?  0  ?     :  1 ;
       ?  ?  0  0  ?     :  1 ;
      
       0  ?  ?  ?  0     :  1 ;
       ?  0  ?  ?  0     :  1 ;
       ?  ?  0  ?  0     :  1 ;
      
    endtable
endprimitive
      

primitive U_AOI_3(Z, A, B, C);

    output  Z;
    input   A, B, C ;

// FUNCTION : 3-INPUT AND-OR INVERT GATE 

    table
    // A  B  C  :   Z

       1  1  ?  :  0 ;
       1  ?  1  :  0 ;
       ?  1  1  :  0 ;

       0  ?  0  :  1 ;
       0  0  ?  :  1 ;
       ?  0  0  :  1 ;
    endtable
endprimitive
      
primitive U_AOI_3_3(Y, A, B, C, D, E, F);

    output  Y;
    input   A, B, C, D, E, F;

// FUNCTION : 2-WIDE 3-INPUT AND into 2-INPUT NOR
    
    table
    // A  B  C  D  E  F   :  Y

       1  1  1  ?  ?  ?   :  0 ;
       ?  ?  ?  1  1  1   :  0 ;

       0  ?  ?  0  ?  ?   :  1 ;
       0  ?  ?  ?  0  ?   :  1 ;
       0  ?  ?  ?  ?  0   :  1 ;
      
       ?  ?  0  0  ?  ?   :  1 ;
       ?  ?  0  ?  0  ?   :  1 ;
       ?  ?  0  ?  ?  0   :  1 ;
      
       ?  0  ?  0  ?  ?   :  1 ;
       ?  0  ?  ?  0  ?   :  1 ;
       ?  0  ?  ?  ?  0   :  1 ;
      
    endtable
endprimitive
      

primitive U_AO_2_2 (Z, A, B, C, D);

    output  Z;
    input   A, B, C, D;

// FUNCTION : 2-WIDE 2-INPUT AND into 2-INPUT OR
    
    table
    // A  B  C  D  :  Z

       1  1  ?  ?  :  1 ;
       ?  ?  1  1  :  1 ;

       0  ?  0  ?  :  0 ;
       0  ?  ?  0  :  0 ;

       ?  0  0  ?  :  0 ;
       ?  0  ?  0  :  0 ;
    endtable
endprimitive
      

primitive U_AO_2_2_2(Y, A, B, C, D, E, F);

    output  Y;
    input   A, B, C, D, E, F;

// FUNCTION : 3-WIDE 2-INPUT AND into 2-INPUT OR
    
    table
    // A  B  C  D  E  F :  Y

       1  1  ?  ?  ?  ? :  1 ;
       ?  ?  1  1  ?  ? :  1 ;
       ?  ?  ?  ?  1  1 :  1 ;

       0  ?  0  ?  0  ? :  0 ;
       0  ?  0  ?  ?  0 :  0 ;
       0  ?  ?  0  0  ? :  0 ;
       0  ?  ?  0  ?  0 :  0 ;
       ?  0  0  ?  0  ? :  0 ;
       ?  0  0  ?  ?  0 :  0 ;
       ?  0  ?  0  0  ? :  0 ;
       ?  0  ?  0  ?  0 :  0 ;

    endtable
endprimitive
      

primitive U_AO_2_3(Y, A, B, C, D, E);

    output  Y;
    input   A, B, C, D, E;

// FUNCTION : 2-INPUT AND and 3-INPUT AND into 2-INPUT OR   
    
    table
    // A  B  C  D  E     :  Y

       1  1  1  ?  ?     :  1 ;
       ?  ?  ?  1  1     :  1 ;

       0  ?  ?  0  ?     :  0 ;
       ?  0  ?  0  ?     :  0 ;
       ?  ?  0  0  ?     :  0 ;
      
       0  ?  ?  ?  0     :  0 ;
       ?  0  ?  ?  0     :  0 ;
       ?  ?  0  ?  0     :  0 ;
    
    endtable
endprimitive
      

primitive U_AO_3 (Z, A, B, C);

    input A, B, C ;
    output Z;

// FUNCTION : 3-INPUT AND-OR GATE 
 
  table
 
// A      B      C  :  Z
   
   1      ?      ?  :  1;
   ?      1      1  :  1;
 
   0      0      ?  :  0;
   0      ?      0  :  0;

   endtable
endprimitive  
primitive U_AO_3_3 (Y, A, B, C, D, E, F);

    output  Y;
    input   A, B, C, D, E, F;

// FUNCTION : 2-WIDE 3-INPUT AND into 2-INPUT OR
    
    table
    // A  B  C  D  E  F   :  Y

       1  1  1  ?  ?  ?   :  1 ;
       ?  ?  ?  1  1  1   :  1 ;

       0  ?  ?  0  ?  ?   :  0 ;
       0  ?  ?  ?  0  ?   :  0 ;
       0  ?  ?  ?  ?  0   :  0 ;
      
       ?  ?  0  0  ?  ?   :  0 ;
       ?  ?  0  ?  0  ?   :  0 ;
       ?  ?  0  ?  ?  0   :  0 ;
      
       ?  0  ?  0  ?  ?   :  0 ;
       ?  0  ?  ?  0  ?   :  0 ;
       ?  0  ?  ?  ?  0   :  0 ;

    endtable
endprimitive
      
primitive U_AXO_2_2 (Z, A, B, C, D);

   input A, B, C, D;
   output  Z;

// FUNCTION : 2-WIDE 2-INPUT AND into 2-INPUT XOR

  table
// A   B    C   D   : Z

   1   1    1   1   : 0;
   
   0   ?    0   ?   : 0;
   0   ?    ?   0   : 0;

   ?   0    0   ?   : 0;
   ?   0    ?   0   : 0;

   1   1    0   ?   : 1;
   1   1    ?   0   : 1;

   0   ?    1   1   : 1;
   ?   0    1   1   : 1;
 endtable

endprimitive
primitive  U_AXO_2_3 (Z, A, B, C, D, E);

    input A, B, C, D, E;
    output  Z;

// FUNCTION : 2-INPUT and 3-INPUT AND into 2-INPUT XOR

  table
// A   B    C   D   E   : Z

   1   1    1   1   1   : 0;

   0   ?    0   ?   ?   : 0;
   0   ?    ?   0   ?   : 0;
   0   ?    ?   ?   0   : 0;

   ?   0    0   ?   ?   : 0;
   ?   0    ?   0   ?   : 0;
   ?   0    ?   ?   0   : 0;

   1   1    0   ?   ?   : 1;
   1   1    ?   0   ?   : 1;
   1   1    ?   ?   0   : 1;
 
   0   ?    1   1   1   : 1;
   ?   0    1   1   1   : 1;

  endtable

endprimitive
primitive  U_AXO_2_4 (Z, A, B, C, D, E, F);

    input A, B, C, D, E, F;
    output  Z;

// FUNCTION : 2-INPUT and 4-INPUT AND into 2-INPUT XOR

  table
// A   B    C   D   E   F  : Z

   1   1    1   1   1   1   : 0;

   0   ?    0   ?   ?   ?   : 0;
   0   ?    ?   0   ?   ?   : 0;
   0   ?    ?   ?   0   ?   : 0;
   0   ?    ?   ?   ?   0   : 0;

   ?   0    0   ?   ?   ?   : 0;
   ?   0    ?   0   ?   ?   : 0;
   ?   0    ?   ?   0   ?   : 0;
   ?   0    ?   ?   ?   0   : 0;
                        
   1   1    0   ?   ?   ?   : 1;
   1   1    ?   0   ?   ?   : 1;
   1   1    ?   ?   0   ?   : 1;
   1   1    ?   ?   ?   0   : 1;
 
   0   ?    1   1   1   1   : 1;
   ?   0    1   1   1   1   : 1;

  endtable

endprimitive
primitive U_BUF (Z, TN, EN);

  input TN, EN;
  output Z;

  // FUNCTION : To implement the logic equation Z = ~( !EN && TN )
 
  table 

//  TN  EN : Z
// ------------
    0   ?  : 1 ;
    1   0  : 0 ;
    ?   1  : 1 ;

  endtable

endprimitive
primitive U_BUF_1 (Z, TN, EN);

  input TN, EN;
  output Z;

  // FUNCTION : To implement the logic equation Z = ( !EN && TN )
 
  table 

//  TN  EN : Z
// -------------
    0   ?  : 0 ;
    1   0  : 1 ;
    ?   1  : 0 ;

  endtable

endprimitive
primitive U_DIFF_BUF (Y, A, AN);

    output Y;
    input  A, AN;
    reg    Y;

// Differential udp

    table
    // A    AN  :  Y   :  Y+1

       0    1   :  ?   :   0;
       0    0   :  ?   :   -;
       1    0   :  ?   :   1;

       1    1   :  ?   :   -;
       
       1    x   :  1   :   1;

       0    x   :  0   :   0;

       x    1   :  0   :   0;

       x    0   :  1   :   1;

       x    x   :  ?   :   -;

    endtable
endprimitive    

primitive U_FD_LD_P_RB_SB  (Q, CNTRL, D, CP, RB, SB);

   output Q ;
   input  CNTRL, D, CP, RB, SB ;
   reg Q ;

    // FUNCTION : D-TYPE FLIP-FLOP AND A D-TYPE LATCH WITH  
    //            ACTIVE LOW ASYNCHRONOUS CLEAR and PRESET ( Q OUTPUT UDP ) .
    //            
    //            

   table 

// CNTRL  D     CP    RB    SB      :  Qtn :  Qtn+1 ;
                                
    1     1     r      1     1      :   ?  :   1   ;     // clocked data
    1     0     r      1     1      :   ?  :   0   ;
    1     0     r      x     1      :   ?  :   0   ;
    1     1     r      1     x      :   ?  :   1   ;
    1     0     ?      x     1      :   0  :   0   ;

    1     1     0      x     1      :   0  :   0   ;
    1     1     x     (?x)   1      :   0  :   0   ;
    1     1     1     (?x)   1      :   0  :   0   ;

    1     x     0      x     1      :   0  :   0   ;
    1     x     x     (?x)   1      :   0  :   0   ;
    1     x     1     (?x)   1      :   0  :   0   ;

    1     1     ?      1     x      :   1  :   1   ;
                                 
    1     0     0      1     x      :   1  :   1   ;
    1     0     x      1   (?x)     :   1  :   1   ;
    1     0     1      1   (?x)     :   1  :   1   ;
                                 
    1     x     0      1    x       :   1  :   1   ;
    1     x     x      1   (?x)     :   1  :   1   ;
    1     x     1      1   (?x)     :   1  :   1   ;
                                
    1     1    (x1)    1     1      :   1  :   1   ;    // pessimism
    1     0    (x1)    1     1      :   0  :   0   ;
    1     1    (0x)    1     1      :   1  :   1   ;
    1     0    (0x)    1     1      :   0  :   0   ;
                                
    1     *     ?      1     1      :   ?  :   -   ;    // pessimism
                                
    ?     ?     ?      0     ?      :   ?  :   0   ;    // CLEAR

    ?     ?     ?      1     0      :   ?  :   1   ;    // SET
                                
    1     ?     ?    (?1)    1      :   ?  :   -   ;    // Ignore edges on
                                                        // CLEAR
    1     ?     ?      1    (?1)    :   ?  :   -   ;    // Ignore edges on
                                                        // SET
    ?     ?     n      1     1      :   ?  :   -   ;
                                
    0     1     r      1     1      :   ?  :   1   ;    // Scan data
    0     0     r      1     1      :   ?  :   0   ;

   (?0)   1     1      1     1      :   ?  :   1   ;    // Scan data
   (?0)   0     1      1     1      :   ?  :   0   ; 

   (?1)   ?     ?      1     1      :   ?  :   -   ;  


    0    (?1)   1      1     1      :   ?  :   1   ;
    0    (?0)   1      1     1      :   ?  :   0   ;

    0     ?     0    (?1)    1      :   ?  :   -   ;    // Ignore edges on
                                                        // CLEAR
    0     0     1    (?1)    1      :   ?  :   0   ;    
    0     1     1    (?1)    1      :   ?  :   1   ;    

    0     ?     0      1    (?1)    :   ?  :   -   ;    // Ignore edges on SET

    0     0     1      1    (?1)    :   ?  :   0   ;   
    0     1     1      1    (?1)    :   ?  :   1   ;   

   (?0)   0     1      x     1      :   ?  :   0   ;
    0    (?0)   1      x     1      :   ?  :   0   ;
    0     0     r      x     1      :   ?  :   0   ;
    0     0     1     (?x)   1      :   ?  :   0   ;
    0     0     1      x    (?1)    :   ?  :   0   ;

   (?0)   1     1      1     x      :   ?  :   1   ;
    0    (?1)   1      1     x      :   ?  :   1   ;
    0     1     r      1     x      :   ?  :   1   ;
    0     1     1     (?1)   x      :   ?  :   1   ;
    0     1     1      1    (?x)    :   ?  :   1   ;
                                
    0     1    (x1)    1     1      :   1  :   1   ;    // pessimism
    0     0    (x1)    1     1      :   0  :   0   ;

    0     1    (x1)    1     x      :   1  :   1   ;    // pessimism
    0     0    (x1)    x     1      :   0  :   0   ;

    0     1    (0x)    1     1      :   1  :   1   ;
    0     0    (0x)    1     1      :   0  :   0   ;

    0     1    (0x)    1     x      :   1  :   1   ;
    0     0    (0x)    x     1      :   0  :   0   ;
                                
    0    (?1)   x      1     1      :   1  :   1   ;    // pessimism
    0    (?0)   x      1     1      :   0  :   0   ; 
   (?0)    0    x      1     1      :   0  :   0   ; 
   (?0)    1    x      1     1      :   1  :   1   ; 

    0    (?0)   x      x     1      :   0  :   0   ; 
    0    (?1)   x      1     x      :   1  :   1   ; 

    x    (?0)   x      x     1      :   0  :   0   ; 
    x    (?1)   x      1     x      :   1  :   1   ; 
  
   (?0)    0    x      x     1      :   0  :   0   ; 
   (?0)    1    x      1     x      :   1  :   1   ; 
                               
    x     0    (01)    1     1      :   ?  :   0   ;
    x     1    (01)    1     1      :   ?  :   1   ;

    x     0    (01)    x     1      :   ?  :   0   ;
    x     ?    (?x)    x     1      :   0  :   0   ;
                                
    x     1    (01)    1     x      :   ?  :   1   ;
    x     ?    (?x)    1     x      :   1  :   1   ;

    x     1    (x1)    1     1      :   1  :   1   ;
    x     0    (x1)    1     1      :   0  :   0   ;
    x     1    (0x)    1     1      :   1  :   1   ;
    x     0    (0x)    1     1      :   0  :   0   ;
                                
    0     *     0      1     1      :   ?  :   -   ;
   (?0)   ?     0      1     1      :   ?  :   -   ;
                                

  endtable

endprimitive 

 
 


primitive U_FD_N  (Q, D, CP);

    output Q;  
    input  D, CP;
    reg    Q;  

// FUNCTION :  NEGATIVE EDGE TRIGGERED D FLIP-FLOP ( Q OUTPUT UDP ).

    table
 
    //  D   CP        :   Qt  :   Qt+1

        1   (10)      :   ?   :   1;  // clocked data
        0   (10)      :   ?   :   0;
                                                           
        1   (1x)      :   1   :   1;  // reducing pessimism
        0   (1x)      :   0   :   0;                          
        1   (x0)      :   1   :   1;  
        0   (x0)      :   0   :   0; 
        
        ?   (0x)      :   ?   :   -;  // no change on rising edge 
        ?   (?1)      :   ?   :   -;  

        *    ?        :   ?   :   -;  // ignore edges on data

    endtable
endprimitive



primitive U_FD_N_CEB_NO (Q, D, CP, CEB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, CEB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH CLOCK ENABLE INPUT ( Q OUTPUT UDP ) 


    table
 
    //  D   CP      CEB     NOTIFIER_REG  :   Qt  :   Qt+1
                            
        1   (10)    0         ?          :   ?   :   1;  // clocked data
        0   (10)    0         ?          :   ?   :   0;
                            
        1   (1x)    0         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0         ?          :   0   :   0;                          
        1   (x0)    0         ?          :   1   :   1;  
        0   (x0)    0         ?          :   0   :   0;  
                            
                            
        ?   (?1)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the edges on data
                                  
        1   (10)    x         ?          :   1   :   1;  // reducing pessimism
        0   (10)    x         ?          :   0   :   0;                      
             
        1   (1x)    x         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    x         ?          :   0   :   0;                          
        1   (x0)    x         ?          :   1   :   1;  
        0   (x0)    x         ?          :   0   :   0;  

 
        ?   (?0)    1         ?          :   ?   :   -;  // reducing pessimism
        ?   (1x)    1         ?          :   ?   :   -;  // reducing pessimism

        ?    ?      *         ?          :   ?   :   -; // ignore edges on CE
        ?    ?      ?         *          :   ?   :   x;

    endtable
endprimitive


primitive U_FD_N_CEB_S_NO (Q, D, CP, S, CEB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, S, CEB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS PRESET and ENABLE ( Q OUTPUT UDP ).


    table
 
    //  D   CP      S   CEB      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    0    0          ?          :   ?   :   1;  // clocked data
        0   (10)    0    0          ?          :   ?   :   0;
 
        1   (10)    0    x          ?          :   1   :   1;  // clocked data
        0   (10)    0    x          ?          :   0   :   0;

        1   (10)    x    0          ?          :   ?   :   1;  // pessimism
        1    ?      x    0          ?          :   1   :   1;  // pessimism

        0    1      x    0          ?          :   1   :   1;  // pessimism
        0    x    (?x)   0          ?          :   1   :   1;  // pessimism
        0    0    (?x)   0          ?          :   1   :   1;  // pessimism

        x    1      x    0          ?          :   1   :   1;  // pessimism
        x    x    (?x)   0          ?          :   1   :   1;  // pessimism
        x    0    (?x)   0          ?          :   1   :   1;  // pessimism
        
        1    ?      x    x          ?          :   1   :   1;  // pessimism

        0    1      x    x          ?          :   1   :   1;  // pessimism
        0    x    (?x)   x          ?          :   1   :   1;  // pessimism
        0    0    (?x)   x          ?          :   1   :   1;  // pessimism

        x    1      x    x          ?          :   1   :   1;  // pessimism
        x    x    (?x)   x          ?          :   1   :   1;  // pessimism
        x    0    (?x)   x          ?          :   1   :   1;  // pessimism


        1   (1x)    0    0          ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0    0          ?          :   0   :   0;                          
        1   (x0)    0    0          ?          :   1   :   1;  
        0   (x0)    0    0          ?          :   0   :   0;  

        1   (1x)    0    x          ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0    x          ?          :   0   :   0;                          
        1   (x0)    0    x          ?          :   1   :   1;  
        0   (x0)    0    x          ?          :   0   :   0;  


        ?    ?      1    ?          ?          :   ?   :   1;  // asynchronous preset

        ?   (?0)    0    1          ?          :   ?   :   -;  // chip is not enabled
        ?   (1x)    0    1          ?          :   ?   :   -;  // chip is not enabled

        ?   (?0)    x    1          ?          :   1   :   1;  // chip is not enabled pessimism with preset
        ?   (1x)    x    1          ?          :   1   :   1;  // chip is not enabled pessimism with preset
        ?    ?    (?x)   1          ?          :   1   :   1;  // chip is not enabled pessimism with preset


        ?   (?1)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?    ?          ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?0)   ?          ?          :   ?   :   -;  // ignore the edges on preset
  
        ?    ?      ?    *          ?          :   ?   :   -;

        ?    ?      ?    ?          *          :   ?   :   x;
 
    endtable
endprimitive



primitive U_FD_N_CE_NO (Q, D, CP, CEB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, CEB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH CLOCK ENABLE INPUT ( Q OUTPUT UDP ) 


    table
 
    //  D   CP      CEB     NOTIFIER_REG  :   Qt  :   Qt+1
                            
        1   (10)    1         ?          :   ?   :   1;  // clocked data
        0   (10)    1         ?          :   ?   :   0;
                            
        1   (1x)    1         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    1         ?          :   0   :   0;                          
        1   (x0)    1         ?          :   1   :   1;  
        0   (x0)    1         ?          :   0   :   0;  
                            
                            
        ?   (?1)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the edges on data
                                  
        1   (10)    x         ?          :   1   :   1;  // reducing pessimism
        0   (10)    x         ?          :   0   :   0;                      
             
        1   (1x)    x         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    x         ?          :   0   :   0;                          
        1   (x0)    x         ?          :   1   :   1;  
        0   (x0)    x         ?          :   0   :   0;  

 
        ?   (?0)    0         ?          :   ?   :   -;  // reducing pessimism
        ?   (1x)    0         ?          :   ?   :   -;  // reducing pessimism

        ?    ?      *         ?          :   ?   :   -; // ignore edges on CE
        ?    ?      ?         *          :   ?   :   x;

    endtable
endprimitive


primitive U_FD_N_CE_RB_NO (Q, D, CP, RB, CE, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB, CE;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR and ENABLE ( Q OUTPUT UDP ).


    table
 
    //  D   CP      RB   CE      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    1    1          ?          :   ?   :   1;  // clocked data
        0   (10)    1    1          ?          :   ?   :   0;
 
        1   (10)    1    x          ?          :   1   :   1;  // clocked data
        0   (10)    1    x          ?          :   0   :   0;

        0   (10)    x    1          ?          :   ?   :   0;  // pessimism
        0    ?      x    1          ?          :   0   :   0;  // pessimism

        1    1      x    1          ?          :   0   :   0;  // pessimism
        1    x    (?x)   1          ?          :   0   :   0;  // pessimism
        1    0    (?x)   1          ?          :   0   :   0;  // pessimism

        x    1      x    1          ?          :   0   :   0;  // pessimism
        x    x    (?x)   1          ?          :   0   :   0;  // pessimism
        x    0    (?x)   1          ?          :   0   :   0;  // pessimism
        
        0    ?      x    x          ?          :   0   :   0;  // pessimism

        1    1      x    x          ?          :   0   :   0;  // pessimism
        1    x    (?x)   x          ?          :   0   :   0;  // pessimism
        1    0    (?x)   x          ?          :   0   :   0;  // pessimism

        x    1      x    x          ?          :   0   :   0;  // pessimism
        x    x    (?x)   x          ?          :   0   :   0;  // pessimism
        x    0    (?x)   x          ?          :   0   :   0;  // pessimism


        1   (1x)    1    1          ?          :   1   :   1;  // reducing pessimism
        0   (1x)    1    1          ?          :   0   :   0;                          
        1   (x0)    1    1          ?          :   1   :   1;  
        0   (x0)    1    1          ?          :   0   :   0;  

        1   (1x)    1    x          ?          :   1   :   1;  // reducing pessimism
        0   (1x)    1    x          ?          :   0   :   0;                          
        1   (x0)    1    x          ?          :   1   :   1;  
        0   (x0)    1    x          ?          :   0   :   0;  


        ?    ?      0    ?          ?          :   ?   :   0;  // asynchronous clear

        ?   (?0)    1    0          ?          :   ?   :   -;  // chip is not enabled
        ?   (1x)    1    0          ?          :   ?   :   -;  // chip is not enabled

        ?   (?0)    x    0          ?          :   0   :   0;  // chip is not enabled pessimism with reset
        ?   (1x)    x    0          ?          :   0   :   0;  // chip is not enabled pessimism with reset
        ?    ?    (?x)   0          ?          :   0   :   0;  // chip is not enabled pessimism with reset


        ?   (?1)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?    ?          ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?1)   ?          ?          :   ?   :   -;  // ignore the edges on clear 
  
        ?    ?      ?    *          ?          :   ?   :   -;

        ?    ?      ?    ?          *          :   ?   :   x;
 
    endtable
endprimitive




primitive U_FD_N_CE_S_NO (Q, D, CP, S, CE, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, S, CE;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS PRESET and ENABLE ( Q OUTPUT UDP ).


    table
 
    //  D   CP      S   CE      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    0    1          ?          :   ?   :   1;  // clocked data
        0   (10)    0    1          ?          :   ?   :   0;
 
        1   (10)    0    x          ?          :   1   :   1;  // clocked data
        0   (10)    0    x          ?          :   0   :   0;

        1   (10)    x    1          ?          :   ?   :   1;  // pessimism
        1    ?      x    1          ?          :   1   :   1;  // pessimism

        0    1      x    1          ?          :   1   :   1;  // pessimism
        0    x    (?x)   1          ?          :   1   :   1;  // pessimism
        0    0    (?x)   1          ?          :   1   :   1;  // pessimism

        x    1      x    1          ?          :   1   :   1;  // pessimism
        x    x    (?x)   1          ?          :   1   :   1;  // pessimism
        x    0    (?x)   1          ?          :   1   :   1;  // pessimism
        
        1    ?      x    x          ?          :   1   :   1;  // pessimism

        0    1      x    x          ?          :   1   :   1;  // pessimism
        0    x    (?x)   x          ?          :   1   :   1;  // pessimism
        0    0    (?x)   x          ?          :   1   :   1;  // pessimism

        x    1      x    x          ?          :   1   :   1;  // pessimism
        x    x    (?x)   x          ?          :   1   :   1;  // pessimism
        x    0    (?x)   x          ?          :   1   :   1;  // pessimism


        1   (1x)    0    1          ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0    1          ?          :   0   :   0;                          
        1   (x0)    0    1          ?          :   1   :   1;  
        0   (x0)    0    1          ?          :   0   :   0;  

        1   (1x)    0    x          ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0    x          ?          :   0   :   0;                          
        1   (x0)    0    x          ?          :   1   :   1;  
        0   (x0)    0    x          ?          :   0   :   0;  


        ?    ?      1    ?          ?          :   ?   :   1;  // asynchronous preset

        ?   (?0)    0    0          ?          :   ?   :   -;  // chip is not enabled
        ?   (1x)    0    0          ?          :   ?   :   -;  // chip is not enabled

        ?   (?0)    x    0          ?          :   1   :   1;  // chip is not enabled pessimism with preset
        ?   (1x)    x    0          ?          :   1   :   1;  // chip is not enabled pessimism with preset
        ?    ?    (?x)   0          ?          :   1   :   1;  // chip is not enabled pessimism with preset


        ?   (?1)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?    ?          ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?0)   ?          ?          :   ?   :   -;  // ignore the edges on preset
  
        ?    ?      ?    *          ?          :   ?   :   -;

        ?    ?      ?    ?          *          :   ?   :   x;
 
    endtable
endprimitive




primitive U_FD_N_NO (Q, D, CP , NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP;
    reg    Q;  

// FUNCTION :  NEGATIVE EDGE TRIGGERED D FLIP-FLOP ( Q OUTPUT UDP ).


    table
 
    //  D   CP           NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)            ?          :   ?   :   1;  // clocked data
        0   (10)            ?          :   ?   :   0;
                                                           
        1   (1x)            ?          :   1   :   1;  // reducing pessimism
        0   (1x)            ?          :   0   :   0;                          
        1   (x0)            ?          :   1   :   1;  
        0   (x0)            ?          :   0   :   0; 
        
        ?   (0x)            ?          :   ?   :   -;  // no change on rising edge 
        ?   (?1)            ?          :   ?   :   -;  

        *    ?              ?          :   ?   :   -;  // ignore edges on data
        
        ?    ?              *          :   ?   :   x;
    endtable
endprimitive



primitive U_FD_N_RB_NO (Q, D, CP, RB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR ( Q OUTPUT UDP ).


    table
 
    //  D   CP      RB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    1         ?          :   ?   :   1;  // clocked data
        0   (10)    1         ?          :   ?   :   0;

        0   (10)    x         ?          :   ?   :   0;  // pessimism
        0    ?      x         ?          :   0   :   0;  // pessimism

        1    1      x         ?          :   0   :   0;  // pessimism
        1    x    (?x)        ?          :   0   :   0;  // pessimism
        1    0    (?x)        ?          :   0   :   0;  // pessimism

        x    1      x         ?          :   0   :   0;  // pessimism
        x    x    (?x)        ?          :   0   :   0;  // pessimism
        x    0    (?x)        ?          :   0   :   0;  // pessimism

        1   (1x)    1         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    1         ?          :   0   :   0;                          
        1   (x0)    1         ?          :   1   :   1;  
        0   (x0)    1         ?          :   0   :   0;  


        ?   ?       0         ?          :   ?   :   0;  // asynchronous clear

        ?   (?1)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?1)        ?          :   ?   :   -;  // ignore the edges on clear 

        ?    ?      ?         *          :   ?   :   x;
 
    endtable
endprimitive



primitive U_FD_N_RB_SB  (Q, D, CP, RB, SB);

    output Q;  
    input  D, CP, RB, SB;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP ).

    table
 
    //  D    CP     RB  SB  :   Qt  :   Qt+1

        1   (10)    1   1   :   ?   :   1;  // clocked data
        1   (10)    1   x   :   ?   :   1;  // pessimism

        1    ?      1   x   :   1   :   1;  // pessimism

        0    1      1   x   :   1   :   1;  // pessimism
        0    x      1 (?x)  :   1   :   1;  // pessimism
        0    0      1 (?x)  :   1   :   1;  // pessimism

        x    1      1   x   :   1   :   1;  // pessimism
        x    x      1 (?x)  :   1   :   1;  // pessimism
        x    0      1 (?x)  :   1   :   1;  // pessimism


        0   (10)    1   1   :   ?   :   0;  // clocked data
        0   (10)    x   1   :   ?   :   0;  // pessimism

        0    ?      x   1   :   0   :   0;  // pessimism

        1    1      x   1   :   0   :   0;  // pessimism
        1    x    (?x)  1   :   0   :   0;  // pessimism
        1    0    (?x)  1   :   0   :   0;  // pessimism

        x    1      x   1   :   0   :   0;  // pessimism
        x    x    (?x)  1   :   0   :   0;  // pessimism
        x    0    (?x)  1   :   0   :   0;  // pessimism
                                                           
        1   (1x)    1   1   :   1   :   1;  // reducing pessimism
        0   (1x)    1   1   :   0   :   0;                          
        1   (x0)    1   1   :   1   :   1;  
        0   (x0)    1   1   :   0   :   0;  

        ?    ?      0   ?   :   ?   :   0;  // asynchronous clear
        ?    ?      1   0   :   ?   :   1;  // asynchronous set

        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?    ?     (?1) 1   :   ?   :   -;  // ignore the edges on 
        ?    ?      ?  (?1) :   ?   :   -;  // set and clear                  

    endtable
endprimitive



primitive U_FD_N_RB_SB_NO  (Q, D, CP, RB, SB, NOTIFY_REG);

    output Q;  
    input  D, CP, RB, SB, NOTIFY_REG;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP ).

    table
 
    //  D    CP     RB  SB  NOTIFY_REG  :   Qt  :   Qt+1

        1   (10)    1   1      ?        :   ?   :   1;  // clocked data
        1   (10)    1   x      ?        :   ?   :   1;  // pessimism

        1    ?      1   x      ?        :   1   :   1;  // pessimism

        0    1      1   x      ?        :   1   :   1;  // pessimism
        0    x      1 (?x)     ?        :   1   :   1;  // pessimism
        0    0      1 (?x)     ?        :   1   :   1;  // pessimism

        x    1      1   x      ?        :   1   :   1;  // pessimism
        x    x      1 (?x)     ?        :   1   :   1;  // pessimism
        x    0      1 (?x)     ?        :   1   :   1;  // pessimism


        0   (10)    1   1      ?        :   ?   :   0;  // clocked data
        0   (10)    x   1      ?        :   ?   :   0;  // pessimism

        0    ?      x   1      ?        :   0   :   0;  // pessimism

        1    1      x   1      ?        :   0   :   0;  // pessimism
        1    x    (?x)  1      ?        :   0   :   0;  // pessimism
        1    0    (?x)  1      ?        :   0   :   0;  // pessimism

        x    1      x   1      ?        :   0   :   0;  // pessimism
        x    x    (?x)  1      ?        :   0   :   0;  // pessimism
        x    0    (?x)  1      ?        :   0   :   0;  // pessimism
                                                           
        1   (1x)    1   1      ?        :   1   :   1;  // reducing pessimism
        0   (1x)    1   1      ?        :   0   :   0;                          
        1   (x0)    1   1      ?        :   1   :   1;  
        0   (x0)    1   1      ?        :   0   :   0;  

        ?    ?      0   ?      ?        :   ?   :   0;  // asynchronous clear
        ?    ?      1   0      ?        :   ?   :   1;  // asynchronous set

        ?   (?1)    ?   ?      ?        :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?      ?        :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?      ?        :   ?   :   -;  // ignore data edges 

        ?    ?     (?1) 1      ?        :   ?   :   -;  // ignore the edges on 
        ?    ?      ?  (?1)    ?        :   ?   :   -;  // set and clear                  
        ?    ?      ?   ?      *        :   ?   :   x;  

    endtable
endprimitive



primitive U_FD_N_RB_SB_QN (QN, D, CP, RB, SB);

    output QN;  
    input  D, CP, RB, SB;
    reg    QN; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR .  ( QN OUTPUT UDP ).

    table
 
    //  D    CP     RB  SB  :   Qtn :   Qtn+1

        1   (10)    1   1   :   ?   :   0;  // clocked data
        1   (10)    1   x   :   ?   :   0;  // pessimism

        1    ?      1   x   :   0   :   0;  // pessimism

        0    1      1   x   :   0   :   0;  // pessimism
        0    x      1 (?x)  :   0   :   0;  // pessimism
        0    0      1 (?x)  :   0   :   0;  // pessimism

        x    1      1   x   :   0   :   0;  // pessimism
        x    x      1 (?x)  :   0   :   0;  // pessimism
        x    0      1 (?x)  :   0   :   0;  // pessimism


        0   (10)    1   1   :   ?   :   1;  // clocked data
        0   (10)    x   1   :   ?   :   1;  // pessimism

        0    ?      x   1   :   1   :   1;  // pessimism
                        
        1    1      x   1   :   1   :   1;  // pessimism
        1    x    (?x)  1   :   1   :   1;  // pessimism
        1    0    (?x)  1   :   1   :   1;  // pessimism
                        
        x    1      x   1   :   1   :   1;  // pessimism
        x    x    (?x)  1   :   1   :   1;  // pessimism
        x    0    (?x)  1   :   1   :   1;  // pessimism

        ?    ?      0   1   :   ?   :   1;  // asynchronous clear
        ?    ?      ?   0   :   ?   :   0;  // asynchronous set

        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    1   1   :   ?   :   x;  // ignore rising clock
        ?   (1x)    1   1   :   ?   :   x;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?    ?     (?1) ?   :   ?   :   -;  // ignore the edges on 
        ?    ?      1  (?1) :   ?   :   -;  // set and clear                  

    endtable
endprimitive



primitive U_FD_N_RB_SB_X  (Q, D, CP, RB, SB);

    output Q;  
    input  D, CP, RB, SB;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ILLEGAL OUPUT WHEN BOTH
//            SET AND CLEAR ARE LOW ( Q OUTPUT UDP ).

    table
 
    //  D    CP     RB  SB  :   Qt  :   Qt+1

        1   (10)    1   1   :   ?   :   1;  // clocked data
        1   (10)    1   x   :   ?   :   1;  // pessimism

        1    ?      1   x   :   1   :   1;  // pessimism

        0    1      1   x   :   1   :   1;  // pessimism
        0    x      1 (?x)  :   1   :   1;  // pessimism
        0    0      1 (?x)  :   1   :   1;  // pessimism

        x    1      1   x   :   1   :   1;  // pessimism
        x    x      1 (?x)  :   1   :   1;  // pessimism
        x    0      1 (?x)  :   1   :   1;  // pessimism

        0   (10)    1   1   :   ?   :   0;  // clocked data
        0   (10)    x   1   :   ?   :   0;  // pessimism

        0    ?      x   1   :   0   :   0;  // pessimism

        1    1      x   1   :   0   :   0;  // pessimism
        1    x    (?x)  1   :   0   :   0;  // pessimism
        1    0    (?x)  1   :   0   :   0;  // pessimism

        x    1      x   1   :   0   :   0;  // pessimism
        x    x    (?x)  1   :   0   :   0;  // pessimism
        x    0    (?x)  1   :   0   :   0;  // pessimism
 
                                                           
        1   (1x)    1   1   :   1   :   1;  // reducing pessimism
        0   (1x)    1   1   :   0   :   0;                          
        1   (x0)    1   1   :   1   :   1;  
        0   (x0)    1   1   :   0   :   0;  

        ?   ?       0   1   :   ?   :   0;  // asynchronous clear
        ?   ?       1   0   :   ?   :   1;  // asynchronous set
        ?   ?       0   0   :   ?   :   x;  // illegal output

        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  ?   :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?1) :   ?   :   -;  // set and clear                  

    endtable
endprimitive



primitive U_FD_N_R_NO (Q, D, CP, R, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, R;
    reg    Q; 
    
// FUNCTION :  NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//             ASYNCHRONOUS CLEAR ( Q OUTPUT UDP ).


    table
 
    //  D   CP      R      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    0         ?          :   ?   :   1;  // clocked data
        0   (10)    0         ?          :   ?   :   0;

        0   (10)    x         ?          :   ?   :   0;  // pessimism
        0    ?      x         ?          :   0   :   0;  // pessimism

        1    1      x         ?          :   0   :   0;  // pessimism
        1    x    (?x)        ?          :   0   :   0;  // pessimism
        1    0    (?x)        ?          :   0   :   0;  // pessimism

        x    1      x         ?          :   0   :   0;  // pessimism
        x    x    (?x)        ?          :   0   :   0;  // pessimism
        x    0    (?x)        ?          :   0   :   0;  // pessimism
                                                           
        1   (1x)    0         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0         ?          :   0   :   0;                          
        1   (x0)    0         ?          :   1   :   1;  
        0   (x0)    0         ?          :   0   :   0;  


        ?   ?       1         ?          :   ?   :   0;  // asynchronous clear

        ?   (?1)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?0)        ?          :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_N_R_S (Q, D, CP, R, S);

    output Q;  
    input  D, CP, R, S;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP )
    
     table
 
    //  D    CP      R   S   :   Qt  :   Qt+1

        1   (10)    0   0   :   ?   :   1;  // clocked data
        1   (10)    0   x   :   ?   :   1;  // pessimism

        1    ?      0   x   :   1   :   1;  // pessimism

        0    1      0   x   :   1   :   1;  // pessimism
        0    x      0 (?x)  :   1   :   1;  // pessimism
        0    0      0 (?x)  :   1   :   1;  // pessimism

        x    1      0   x   :   1   :   1;  // pessimism
        x    x      0 (?x)  :   1   :   1;  // pessimism
        x    0      0 (?x)  :   1   :   1;  // pessimism

        0   (10)    0   0   :   ?   :   0;  // clocked data
        0   (10)    x   0   :   ?   :   0;  // pessimism

        0    ?      x   0   :   0   :   0;  // pessimism
                           
        1    1      x   0   :   0   :   0;  // pessimism
        1    x    (?x)  0   :   0   :   0;  // pessimism
        1    0    (?x)  0   :   0   :   0;  // pessimism
                          
        x    1      x   0   :   0   :   0;  // pessimism
        x    x    (?x)  0   :   0   :   0;  // pessimism
        x    0    (?x)  0   :   0   :   0;  // pessimism
                                                           
        1   (1x)    0   0   :   1   :   1;  // reducing pessimism
        0   (1x)    0   0   :   0   :   0;                          
        1   (x0)    0   0   :   1   :   1;  
        0   (x0)    0   0   :   0   :   0;  

        ?   ?       1   ?   :   ?   :   0;  // asynchronous clear
        ?   ?       0   1   :   ?   :   1;  // asynchronous set

        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  0   :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?0) :   ?   :   -;  // set and clear                  

    endtable
endprimitive

primitive U_FD_N_R_S_NO (Q, D, CP, R, S, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP )
        

     table
 
    //  D   CP      R   S      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    0   0         ?          :   ?   :   1;  // clocked data
        1   (10)    0   x         ?          :   ?   :   1;  // pessimism
        1    ?      0   x         ?          :   1   :   1;  // pessimism

        0    1      0   x         ?          :   1   :   1;  // pessimism
        0    x      0 (?x)        ?          :   1   :   1;  // pessimism
        0    0      0 (?x)        ?          :   1   :   1;  // pessimism

        x    1      0   x         ?          :   1   :   1;  // pessimism
        x    x      0 (?x)        ?          :   1   :   1;  // pessimism
        x    0      0 (?x)        ?          :   1   :   1;  // pessimism


        0   (10)    0   0         ?          :   ?   :   0;  // clocked data
        0   (10)    x   0         ?          :   ?   :   0;  // pessimism

        0    ?      x   0         ?          :   0   :   0;  // pessimism

        1    1      x   0         ?          :   0   :   0;  // pessimism
        1    x    (?x)  0         ?          :   0   :   0;  // pessimism
        1    0    (?x)  0         ?          :   0   :   0;  // pessimism

        x    1      x   0         ?          :   0   :   0;  // pessimism
        x    x    (?x)  0         ?          :   0   :   0;  // pessimism
        x    0    (?x)  0         ?          :   0   :   0;  // pessimism
                                                              
        1   (1x)    0   0         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0   0         ?          :   0   :   0;                          
        1   (x0)    0   0         ?          :   1   :   1;  
        0   (x0)    0   0         ?          :   0   :   0;  

        ?   ?       1   ?         ?          :   ?   :   0;  // asynchronous clear
        ?   ?       0   1         ?          :   ?   :   1;  // asynchronous set

        ?   (?1)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  0         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?0)       ?          :   ?   :   -;  // set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_N_R_S_NO_QN (QN, D, CP, R, S, NOTIFIER_REG); 

    output QN;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    QN; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP )
        

     table
 
    //  D   CP      R   S      NOTIFIER_REG  :   Qtn :   Qtn+1

        1   (10)    0   0         ?          :   ?   :   0;  // clocked data
        1   (10)    0   x         ?          :   ?   :   0;  // pessimism

        1    ?      0   x         ?          :   0   :   0;  // pessimism

        0    1      0   x         ?          :   0   :   0;  // pessimism
        0    x      0 (?x)        ?          :   0   :   0;  // pessimism
        0    0      0 (?x)        ?          :   0   :   0;  // pessimism

        x    1      0   x         ?          :   0   :   0;  // pessimism
        x    x      0 (?x)        ?          :   0   :   0;  // pessimism
        x    0      0 (?x)        ?          :   0   :   0;  // pessimism


        0   (10)    0   0         ?          :   ?   :   1;  // clocked data
        0   (10)    x   0         ?          :   ?   :   1;  // pessimism

        0    ?      x   0         ?          :   1   :   1;  // pessimism

        1    1      x   0         ?          :   1   :   1;  // pessimism
        1    x    (?x)  0         ?          :   1   :   1;  // pessimism
        1    0    (?x)  0         ?          :   1   :   1;  // pessimism

        x    1      x   0         ?          :   1   :   1;  // pessimism
        x    x    (?x)  0         ?          :   1   :   1;  // pessimism
        x    0    (?x)  0         ?          :   1   :   1;  // pessimism
                                                           
        ?   ?       1   0         ?          :   ?   :   1;  // asynchronous clear
        ?   ?       ?   1         ?          :   ?   :   0;  // asynchronous set

        ?   (?1)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
//        ?   (0x)    1   1         ?          :   ?   :   x;  // ignore rising clock
//        ?   (1x)    1   1         ?          :   ?   :   x;  // ignore rising clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  ?         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       0  (?0)       ?          :   ?   :   -;  // set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_N_R_S_QN (QN, D, CP, R, S);

    output QN;  
    input  D, CP, R, S;
    reg    QN; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP )
    
     table
 
    //  D   CP      R   S   :   Qtn :   Qtn+1

        1   (10)    0   0   :   ?   :   0;  // clocked data
        1   (10)    0   x   :   ?   :   0;  // pessimism

        1    ?      0   x   :   0   :   0;  // pessimism

        0    1      0   x   :   0   :   0;  // pessimism
        0    x      0 (?x)  :   0   :   0;  // pessimism
        0    0      0 (?x)  :   0   :   0;  // pessimism

        x    1      0   x   :   0   :   0;  // pessimism
        x    x      0 (?x)  :   0   :   0;  // pessimism
        x    0      0 (?x)  :   0   :   0;  // pessimism

        0   (10)    0   0   :   ?   :   1;  // clocked data
        0   (10)    x   0   :   ?   :   1;  // pessimism

        0    ?      x   0   :   1   :   1;  // pessimism
                           
        1    1      x   0   :   1   :   1;  // pessimism
        1    x    (?x)  0   :   1   :   1;  // pessimism
        1    0    (?x)  0   :   1   :   1;  // pessimism
                          
        x    1      x   0   :   1   :   1;  // pessimism
        x    x    (?x)  0   :   1   :   1;  // pessimism
        x    0    (?x)  0   :   1   :   1;  // pessimism
                                                           
        1   (1x)    0   0   :   0   :   0;  // reducing pessimism
        0   (1x)    0   0   :   1   :   1;                          
        1   (x0)    0   0   :   0   :   0;  
        0   (x0)    0   0   :   1   :   1;  

        ?   ?       1   0   :   ?   :   1;  // asynchronous clear
        ?   ?       ?   1   :   ?   :   0;  // asynchronous set

        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  ?   :   ?   :   -;  // ignore the edges on 
        ?   ?       0  (?0) :   ?   :   -;  // set and clear                  

    endtable
endprimitive

primitive U_FD_N_R_S_X (Q, D, CP, R, S);

    output Q;  
    input  D, CP, R, S;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET. ILLEGAL OUTPUT OCCURS WHEN BOTH
//            SET AND RESET ARE HIGH . ( Q OUTPUT UDP )

    table
 
    //  D    CP     R   S   :   Qt  :   Qt+1

        1   (10)    0   0   :   ?   :   1;  // clocked data
        1   (10)    0   x   :   ?   :   1;  // pessimism

        1    ?      0   x   :   1   :   1;  // pessimism

        0    1      0   x   :   1   :   1;  // pessimism
        0    x      0 (?x)  :   1   :   1;  // pessimism
        0    0      0 (?x)  :   1   :   1;  // pessimism

        x    1      0   x   :   1   :   1;  // pessimism
        x    x      0 (?x)  :   1   :   1;  // pessimism
        x    0      0 (?x)  :   1   :   1;  // pessimism

        0   (10)    0   0   :   ?   :   0;  // clocked data
        0   (10)    x   0   :   ?   :   0;  // pessimism

        0    ?      x   0   :   0   :   0;  // pessimism
                           
        1    1      x   0   :   0   :   0;  // pessimism
        1    x    (?x)  0   :   0   :   0;  // pessimism
        1    0    (?x)  0   :   0   :   0;  // pessimism
                          
        x    1      x   0   :   0   :   0;  // pessimism
        x    x    (?x)  0   :   0   :   0;  // pessimism
        x    0    (?x)  0   :   0   :   0;  // pessimism
                                                           
        1   (1x)    0   0   :   1   :   1;  // reducing pessimism
        0   (1x)    0   0   :   0   :   0;                          
        1   (x0)    0   0   :   1   :   1;  
        0   (x0)    0   0   :   0   :   0;  

        ?    ?      1   0   :   ?   :   0;  // asynchronous clear
        ?    ?      0   1   :   ?   :   1;  // asynchronous set
        ?    ?      1   1   :   ?   :   x;

        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?    ?    (?0)  ?   :   ?   :   -;  // ignore the edges on 
        ?    ?      ?  (?0) :   ?   :   -;  // set and clear                  

    endtable
endprimitive

primitive U_FD_N_R_S_X_NO (Q, D, CP, R, S, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET. ILLEGAL OUTPUT OCCURS WHEN BOTH
//            SET AND RESET ARE HIGH . ( Q OUTPUT UDP )

    table
 
    //  D    CP     R   S      NOTIFIER_REG  :   Qt  :   Qt+1
                
        1   (10)    0   0         ?          :   ?   :   1;  // clocked data
        1   (10)    0   x         ?          :   ?   :   1;  // pessimism

        1    ?      0   x         ?          :   1   :   1;  // pessimism

        0    1      0   x         ?          :   1   :   1;  // pessimism
        0    x      0 (?x)        ?          :   1   :   1;  // pessimism
        0    0      0 (?x)        ?          :   1   :   1;  // pessimism

        x    1      0   x         ?          :   1   :   1;  // pessimism
        x    x      0 (?x)        ?          :   1   :   1;  // pessimism
        x    0      0 (?x)        ?          :   1   :   1;  // pessimism

                
        0   (10)    0   0         ?          :   ?   :   0;  // clocked data
        0   (10)    x   0         ?          :   ?   :   0;  // pessimism

        0    ?      x   0         ?          :   0   :   0;  // pessimism

        1    1      x   0         ?          :   0   :   0;  // pessimism
        1    x    (?x)  0         ?          :   0   :   0;  // pessimism
        1    0    (?x)  0         ?          :   0   :   0;  // pessimism

        x    1      x   0         ?          :   0   :   0;  // pessimism
        x    x    (?x)  0         ?          :   0   :   0;  // pessimism
        x    0    (?x)  0         ?          :   0   :   0;  // pessimism
                                                             
        1   (1x)    0   0         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0   0         ?          :   0   :   0;                          
        1   (x0)    0   0         ?          :   1   :   1;  
        0   (x0)    0   0         ?          :   0   :   0;  
                
        ?    ?      1   0         ?          :   ?   :   0;  // asynchronous clear
        ?    ?      0   1         ?          :   ?   :   1;  // asynchronous set
        ?    ?      1   1         ?          :   ?   :   x;
                
        ?   (?1)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 
                
        ?    ?     (?0) ?         ?          :   ?   :   -;  // ignore the edges on 
        ?    ?      ?  (?0)       ?          :   ?   :   -;  // set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;

    endtable
endprimitive


primitive U_FD_N_SB_NO (Q, D, CP, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, SB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP )


    table
 
    //  D   CP      SB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    1         ?          :   ?   :   1;  // clocked data
        0   (10)    1         ?          :   ?   :   0;
        1   (10)    x         ?          :   ?   :   1;  // reducing pessimism
        1    ?      x         ?          :   1   :   1;  // pessimism

        0    1      x         ?          :   1   :   1;  // pessimism
        0    x    (?x)        ?          :   1   :   1;  // pessimism
        0    0    (?x)        ?          :   1   :   1;  // pessimism

        x    1      x         ?          :   1   :   1;  // pessimism
        x    x    (?x)        ?          :   1   :   1;  // pessimism
        x    0    (?x)        ?          :   1   :   1;  // pessimism

        1   (1x)    1         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    1         ?          :   0   :   0;                          
        1   (x0)    1         ?          :   1   :   1;  
        0   (x0)    1         ?          :   0   :   0;  

        ?    ?      0         ?          :   ?   :   1;  // asynchronous clear

        ?   (?1)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the data edges

        ?   ?     (?1)        ?          :   ?   :   -;  // ignore the edges on set
        
        ?   ?       ?         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_N_SB_RB (Q, D, CP, RB, SB);

    output Q;  
    input  D, CP, RB, SB;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP )

    table
 
    //  D    CP     RB  SB  :   Qt  :   Qt+1
                
        1   (10)    1   1   :   ?   :   1;  // clocked data
        1   (10)    1   x   :   ?   :   1;  // pessimism

        1    ?      1   x   :   1   :   1;  // pessimism

        0    1      1   x   :   1   :   1;  // pessimism
        0    x      1 (?x)  :   1   :   1;  // pessimism
        0    0      1 (?x)  :   1   :   1;  // pessimism

        x    1      1   x   :   1   :   1;  // pessimism
        x    x      1 (?x)  :   1   :   1;  // pessimism
        x    0      1 (?x)  :   1   :   1;  // pessimism

                
        0   (10)    1   1   :   ?   :   0;  // clocked data
        0   (10)    x   1   :   ?   :   0;  // pessimism

        0    ?      x   1   :   0   :   0;  // pessimism

        1    1      x   1   :   0   :   0;  // pessimism
        1    x    (?x)  1   :   0   :   0;  // pessimism
        1    0    (?x)  1   :   0   :   0;  // pessimism

        x    1      x   1   :   0   :   0;  // pessimism
        x    x    (?x)  1   :   0   :   0;  // pessimism
        x    0    (?x)  1   :   0   :   0;  // pessimism
                                                           
        1   (1x)    1   1   :   1   :   1;  // reducing pessimism
        0   (1x)    1   1   :   0   :   0;                          
        1   (x0)    1   1   :   1   :   1;  
        0   (x0)    1   1   :   0   :   0;  
                
        ?    ?      0   1   :   ?   :   0;  // asynchronous clear
        ?    ?      ?   0   :   ?   :   1;  // asynchronous set
                
        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 
                
        ?    ?    (?1)  ?   :   ?   :   -;  // ignore the edges on 
        ?    ?      1  (?1) :   ?   :   -;  // set and clear                  

    endtable
endprimitive



primitive U_FD_N_SB_RB_NO  (Q, D, CP, RB, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB, SB;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR.  ( Q OUTPUT UDP )

    table
 
    //  D    CP     RB  SB     NOTIFIER_REG  :   Qt  :   Qt+1
                
        1   (10)    1   1         ?          :   ?   :   1;  // clocked data
        1   (10)    1   x         ?          :   ?   :   1;  // pessimism

        1    ?      1   x         ?          :   1   :   1;  // pessimism

        0    1      1   x         ?          :   1   :   1;  // pessimism
        0    x      1 (?x)        ?          :   1   :   1;  // pessimism
        0    0      1 (?x)        ?          :   1   :   1;  // pessimism

        x    1      1   x         ?          :   1   :   1;  // pessimism
        x    x      1 (?x)        ?          :   1   :   1;  // pessimism
        x    0      1 (?x)        ?          :   1   :   1;  // pessimism

                
        0   (10)    1   1         ?          :   ?   :   0;  // clocked data
        0   (10)    x   1         ?          :   ?   :   0;  // pessimism

        0    ?      x   1         ?          :   0   :   0;  // pessimism

        1    1      x   1         ?          :   0   :   0;  // pessimism
        1    x    (?x)  1         ?          :   0   :   0;  // pessimism
        1    0    (?x)  1         ?          :   0   :   0;  // pessimism

        x    1      x   1         ?          :   0   :   0;  // pessimism
        x    x    (?x)  1         ?          :   0   :   0;  // pessimism
        x    0    (?x)  1         ?          :   0   :   0;  // pessimism

                                                           
        1   (1x)    1   1         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    1   1         ?          :   0   :   0;                          
        1   (x0)    1   1         ?          :   1   :   1;  
        0   (x0)    1   1         ?          :   0   :   0;  
                
        ?    ?      0   1         ?          :   ?   :   0;  // asynchronous clear
        ?    ?      ?   0         ?          :   ?   :   1;  // asynchronous set
                
        ?   (?1)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 
                
        ?    ?    (?1)  ?         ?          :   ?   :   -;  // ignore the edges on 
        ?    ?      1  (?1)       ?          :   ?   :   -;  // set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;
 
    endtable
endprimitive


primitive U_FD_N_SB_RB_QN (QN, D, CP, RB, SB);
            
    output QN;  
    input  D, CP, RB, SB;
    reg    QN; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( QN OUTPUT UDP )

    table
 
    //  D    CP     RB  SB  :   Qtn :   Qtn+1
                
        1   (10)    1   1   :   ?   :   0;  // clocked data
        1   (10)    1   x   :   ?   :   0;  // pessimism

        1    ?      1   x   :   0   :   0;  // pessimism

        0    1      1   x   :   0   :   0;  // pessimism
        0    x      1 (?x)  :   0   :   0;  // pessimism
        0    0      1 (?x)  :   0   :   0;  // pessimism

        x    1      1   x   :   0   :   0;  // pessimism
        x    x      1 (?x)  :   0   :   0;  // pessimism
        x    0      1 (?x)  :   0   :   0;  // pessimism
                
        0   (10)    1   1   :   ?   :   1;  // clocked data
        0   (10)    x   1   :   ?   :   1;  // pessimism

        0    ?      x   1   :   1   :   1;  // pessimism
                     
        1    1      x   1   :   1   :   1;  // pessimism
        1    x    (?x)  1   :   1   :   1;  // pessimism
        1    0    (?x)  1   :   1   :   1;  // pessimism
                     
        x    1      x   1   :   1   :   1;  // pessimism
        x    x    (?x)  1   :   1   :   1;  // pessimism
        x    0    (?x)  1   :   1   :   1;  // pessimism
                                                           
        1   (1x)    1   1   :   0   :   0;  // reducing pessimism
        0   (1x)    1   1   :   1   :   1;                          
        1   (x0)    1   1   :   0   :   0;  
        0   (x0)    1   1   :   1   :   1;  
                
        ?    ?      0   ?   :   ?   :   1;  // asynchronous clear
        ?    ?      1   0   :   ?   :   0;  // asynchronous set
                
        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 
                
        ?    ?    (?1)  1   :   ?   :   -;  // ignore the edges on 
        ?    ?      ? (?1)  :   ?   :   -;  // set and clear                  

    endtable
endprimitive

primitive U_FD_N_SD  (Q, D, CP, TI, TE);

    output Q;  
    input  D, CP, TI, TE;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH SCAN INPUTS ( Q OUTPUT UDP ) 

  table
 
    //  D    CP     TI  TE  :   Qt  :   Qt+1
                            
        1   (10)    ?   0   :   ?   :   1;  // clocked data
        0   (10)    ?   0   :   ?   :   0;
                            
        1   (1x)    ?   0   :   1   :   1;  // reducing pessimism
        0   (1x)    ?   0   :   0   :   0;                          
        1   (x0)    ?   0   :   1   :   1;  
        0   (x0)    ?   0   :   0   :   0;  
                            
                            
        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore the edges on data
                            
        ?   (10)    0   1   :   ?   :   0;  // scan data
        ?   (10)    1   1   :   ?   :   1;  // scan data  
      
        ?   (1x)    1   1   :   1   :   1;  // reducing pessimism
        ?   (1x)    0   1   :   0   :   0;  // for scan data                        
        ?   (x0)    1   1   :   1   :   1;  
        ?   (x0)    0   1   :   0   :   0;  

        1   (10)    1   x   :   ?   :   1;  // reducing pessimism
        0   (10)    0   x   :   ?   :   0;                      
             
        1   (1x)    1   x   :   1   :   1;  // reducing pessimism
        0   (1x)    0   x   :   0   :   0;                          
        1   (x0)    1   x   :   1   :   1;  
        0   (x0)    0   x   :   0   :   0;  

        ?    ?      *   ?   :   ?   :   -;  // ignore edges      

        ?    ?      ?   *   :   ?   :   -;  // ignore  edge on TE

    endtable
endprimitive

primitive U_FD_N_SD_NO (Q, D, CP, TI, TE, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, TI, TE;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH SCAN INPUTS ( Q OUTPUT UDP ) 

    table
 
    //  D    CP     TI  TE     NOTIFIER_REG  :   Qt  :   Qt+1
                            
        1   (10)    ?   0         ?          :   ?   :   1;  // clocked data
        0   (10)    ?   0         ?          :   ?   :   0;
                            
        1   (1x)    ?   0         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    ?   0         ?          :   0   :   0;                          
        1   (x0)    ?   0         ?          :   1   :   1;  
        0   (x0)    ?   0         ?          :   0   :   0;  
                            
                            
        ?   (?1)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                            
        ?   (10)    0   1         ?          :   ?   :   0;  // scan data
        ?   (10)    1   1         ?          :   ?   :   1;  // scan data  
                
        ?   (1x)    1   1         ?          :   1   :   1;  // reducing pessimism
        ?   (1x)    0   1         ?          :   0   :   0;  // for scan data                        
        ?   (x0)    1   1         ?          :   1   :   1;  
        ?   (x0)    0   1         ?          :   0   :   0;  
                
        1   (10)    1   x         ?          :   ?   :   1;  // reducing pessimism
        0   (10)    0   x         ?          :   ?   :   0;                      
                
        1   (1x)    1   x         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0   x         ?          :   0   :   0;                          
        1   (x0)    1   x         ?          :   1   :   1;  
        0   (x0)    0   x         ?          :   0   :   0;  
                
        ?    ?      *   ?         ?          :   ?   :   -;  // ignore edges      
                
        ?    ?      ?   *         ?          :   ?   :   -;  // ignore edges on TE
        ?    ?      ?   ?         *          :   ?   :   x;

    endtable
endprimitive


primitive U_FD_N_SD_RB_NO (Q, D, CP, TI, TE, RB, NOTIFIER_REG); 

    output Q;  
    input  D, CP, TI, TE, RB, NOTIFIER_REG;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR WITH  SCAN INPUTS ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  RB     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (10)    ?   0   1         ?          :   ?   :   1;  // clocked data
        0   (10)    ?   0   1         ?          :   ?   :   0;
                                
        0   (10)    ?   0   x         ?          :   ?   :   0;  // pessimism
                                
        0    ?      ?   0   x         ?          :   0   :   0;  // pessimism

        1    1      ?   0   x         ?          :   0   :   0;  // pessimism
        1    x      ?   0 (?x)        ?          :   0   :   0;  // pessimism
        1    0      ?   0 (?x)        ?          :   0   :   0;  // pessimism

        x    1      ?   0   x         ?          :   0   :   0;  // pessimism
        x    x      ?   0 (?x)        ?          :   0   :   0;  // pessimism
        x    0      ?   0 (?x)        ?          :   0   :   0;  // pessimism

        ?    ?      0   1   x         ?          :   0   :   0;  // pessimism
                     
        ?    1      1   1   x         ?          :   0   :   0;  // pessimism
        ?    x      1   1 (?x)        ?          :   0   :   0;  // pessimism
        ?    0      1   1 (?x)        ?          :   0   :   0;  // pessimism
                     
        ?    1      x   1   x         ?          :   0   :   0;  // pessimism
        ?    x      x   1 (?x)        ?          :   0   :   0;  // pessimism
        ?    0      x   1 (?x)        ?          :   0   :   0;  // pessimism
                                                                   
        ?    ?      ?   x (?x)        ?          :   0   :   0;  // AB

        1   (1x)    ?   0   1         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    ?   0   1         ?          :   0   :   0;                          
        1   (x0)    ?   0   1         ?          :   1   :   1;  
        0   (x0)    ?   0   1         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0         ?          :   ?   :   0;  // asynchronous clear
                                
        ?   (?1)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)       ?          :   ?   :   -;  // ignore the edges on clear 

        ?   (10)    0   1   1         ?          :   ?   :   0;  // scan data
        ?   (10)    1   1   1         ?          :   ?   :   1;  // 

        ?   (10)    0   1   x         ?          :   ?   :   0;
        
        ?   (1x)    1   1   1         ?          :   1   :   1;  // reducing pessimism
        ?   (1x)    0   1   1         ?          :   0   :   0;  // for scan data                        
        ?   (x0)    1   1   1         ?          :   1   :   1;  
        ?   (x0)    0   1   1         ?          :   0   :   0;  

        1   (10)    1   x   1         ?          :   ?   :   1; // reducing pessimism
        0   (10)    0   x   1         ?          :   ?   :   0;                      

        0   (1x)    0   x   1         ?          :   0   :   0; //AB
        0   (x0)    0   x   1         ?          :   0   :   0; //AB    

        1   (1x)    1   x   1         ?          :   1   :   1; //AB
        1   (x0)    1   x   1         ?          :   1   :   1; //AB   
             
        0   (10)    0   x   x         ?          :   ?   :   0; 
        0   (1x)    0   x   x         ?          :   0   :   0; //AB
        0   (x0)    0   x   x         ?          :   0   :   0; //AB
             
        ?    ?      *   ?   ?         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   1         ?          :   ?   :   -;  // ignore edges on TE
        ?    ?      ?   ?   1         *          :   ?   :   x;  

    endtable
endprimitive


primitive U_FD_N_SD_RB_SB  (Q, D, CP, TI, TE, RB, SB);

    output Q;  
    input  D, CP, TI, TE, RB, SB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR WITH scan inputs  ( Q OUTPUT UDP )

    table
 
    //  D    CP     TI  TE  RB   SB       :   Qt  :   Qt+1
                                
        1   (10)    ?   0   1    1        :   ?   :   1;  // clocked data
        0   (10)    ?   0   1    1        :   ?   :   0;
                                
        0   (10)    ?   0   x    1        :   ?   :   0;  // pessimism
        1   (10)    ?   0   1    x        :   ?   :   1;  // pessimism
                        
        ?    ?      ?   ?   x    1        :   0   :   0;  // pessimism
        ?    ?      ?   ?   1    x        :   1   :   1;  // pessimism
                                                           
        1   (1x)    ?   0   1    1        :   1   :   1;  // reducing pessimism
        0   (1x)    ?   0   1    1        :   0   :   0;                          
        1   (x0)    ?   0   1    1        :   1   :   1;  
        0   (x0)    ?   0   1    1        :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0    ?        :   ?   :   0;  // asynchronous clear and clear override
        ?    ?      ?   ?   1    0        :   ?   :   1;  // asynchronous set
                        
        ?   (?1)    ?   ?   ?    ?        :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   ?    ?        :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   ?    ?        :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)  1        :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?   ?   1   (?1)      :   ?   :   -;  // ignore the edges on set 

        ?   (10)    0   1   1    1        :   ?   :   0;  // scan data
        ?   (10)    1   1   1    1        :   ?   :   1;  

        ?   (10)    0   1   x    1        :   ?   :   0;
        ?   (10)    1   1   1    x        :   ?   :   1;

        ?   (1x)    1   1   1    1        :   1   :   1;  // reducing pessimism
        ?   (1x)    0   1   1    1        :   0   :   0;  // for scan data                        
        ?   (x0)    1   1   1    1        :   1   :   1;  
        ?   (x0)    0   1   1    1        :   0   :   0;  

        1   (10)    1   x   1    1        :   ?   :   1; // reducing pessimism
        0   (10)    0   x   1    1        :   ?   :   0;                      

        1   (10)    1   x   1    x        :   ?   :   1; // reducing pessimism
        0   (10)    0   x   x    1        :   ?   :   0; 

        ?    ?      *   ?   ?    ?        :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   1    1        :   ?   :   -;  // ignore edges      

    endtable
endprimitive



primitive U_FD_N_SD_R_NO (Q, D, CP, TI, TE, R, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, TI, TE, R;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS CLEAR WITH  SCAN INPUTS ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  R     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (10)    ?   0   0         ?          :   ?   :   1;  // clocked data
        0   (10)    ?   0   0         ?          :   ?   :   0;
                                
        0   (10)    ?   0   x         ?          :   ?   :   0;  // pessimism
                                
        0    ?      ?   0   x         ?          :   0   :   0;  // pessimism

        1    1      ?   0   x         ?          :   0   :   0;  // pessimism
        1    x      ?   0 (?x)        ?          :   0   :   0;  // pessimism
        1    0      ?   0 (?x)        ?          :   0   :   0;  // pessimism

        x    1      ?   0   x         ?          :   0   :   0;  // pessimism
        x    x      ?   0 (?x)        ?          :   0   :   0;  // pessimism
        x    0      ?   0 (?x)        ?          :   0   :   0;  // pessimism

        ?    ?      0   1   x         ?          :   0   :   0;  // pessimism
                     
        ?    1      1   1   x         ?          :   0   :   0;  // pessimism
        ?    x      1   1 (?x)        ?          :   0   :   0;  // pessimism
        ?    0      1   1 (?x)        ?          :   0   :   0;  // pessimism
                     
        ?    1      x   1   x         ?          :   0   :   0;  // pessimism
        ?    x      x   1 (?x)        ?          :   0   :   0;  // pessimism
        ?    0      x   1 (?x)        ?          :   0   :   0;  // pessimism
                                                                   
        ?    ?      ?   x (?x)        ?          :   0   :   0;  // AB

        1   (1x)    ?   0   0         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    ?   0   0         ?          :   0   :   0;                          
        1   (x0)    ?   0   0         ?          :   1   :   1;  
        0   (x0)    ?   0   0         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   1         ?          :   ?   :   0;  // asynchronous clear
                                
        ?   (?1)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?0)       ?          :   ?   :   -;  // ignore the edges on clear 

        ?   (10)    0   1   0         ?          :   ?   :   0;  // scan data
        ?   (10)    1   1   0         ?          :   ?   :   1;  // 

        ?   (10)    0   1   x         ?          :   ?   :   0;
        
        ?   (1x)    1   1   0         ?          :   1   :   1;  // reducing pessimism
        ?   (1x)    0   1   0         ?          :   0   :   0;  // for scan data                        
        ?   (x0)    1   1   0         ?          :   1   :   1;  
        ?   (x0)    0   1   0         ?          :   0   :   0;  

        1   (10)    1   x   0         ?          :   ?   :   1; // reducing pessimism
        0   (10)    0   x   0         ?          :   ?   :   0;                      

        0   (1x)    0   x   0         ?          :   0   :   0; //AB
        0   (x0)    0   x   0         ?          :   0   :   0; //AB    

        1   (1x)    1   x   0         ?          :   1   :   1; //AB
        1   (x0)    1   x   0         ?          :   1   :   1; //AB   
             
        0   (10)    0   x   x         ?          :   ?   :   0; 
        0   (1x)    0   x   x         ?          :   0   :   0; //AB
        0   (x0)    0   x   x         ?          :   0   :   0; //AB
             
        ?    ?      *   ?   ?         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   ?         ?          :   ?   :   -;  // ignore edges on TE
        ?    ?      ?   ?   ?         *          :   ?   :   x;  

    endtable
endprimitive



primitive U_FD_N_SD_SB_NO (Q, D, CP, TI, TE, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, TI, TE, SB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET WITH  scan inputs ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  SB     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (10)    ?   0   1         ?          :   ?   :   1;  // clocked data
        0   (10)    ?   0   1         ?          :   ?   :   0;
                                
        1   (10)    ?   1   x         ?          :   ?   :   1;  // pessimism
                                
        1    ?      ?   0   x         ?          :   1   :   1;  // pessimism

        0    1      ?   0   x         ?          :   1   :   1;  // pessimism
        0    x      ?   0 (?x)        ?          :   1   :   1;  // pessimism
        0    0      ?   0 (?x)        ?          :   1   :   1;  // pessimism

        x    1      ?   0   x         ?          :   1   :   1;  // pessimism
        x    x      ?   0 (?x)        ?          :   1   :   1;  // pessimism
        x    0      ?   0 (?x)        ?          :   1   :   1;  // pessimism

        ?    ?      1   1   x         ?          :   1   :   1;  // pessimism
                     
        ?    1      0   1   x         ?          :   1   :   1;  // pessimism
        ?    x      0   1 (?x)        ?          :   1   :   1;  // pessimism
        ?    0      0   1 (?x)        ?          :   1   :   1;  // pessimism
                     
        ?    1      x   1   x         ?          :   1   :   1;  // pessimism
        ?    x      x   1 (?x)        ?          :   1   :   1;  // pessimism
        ?    0      x   1 (?x)        ?          :   1   :   1;  // pessimism
  
        ?    ?      ?   x (?x)        ?          :   1   :   1;  // AB
                                                                      
        1   (1x)    ?   0   1         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    ?   0   1         ?          :   0   :   0;                          
        1   (x0)    ?   0   1         ?          :   1   :   1;  
        0   (x0)    ?   0   1         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0         ?          :   ?   :   1;  // asynchronous set
                                
        ?   (?1)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)       ?          :   ?   :   -;  // ignore the edges on set 

        ?   (10)    0   1   1         ?          :   ?   :   0;  // scan data
        ?   (10)    1   1   1         ?          :   ?   :   1;  // 

        ?   (10)    1   1   x         ?          :   ?   :   1;
        
        ?   (1x)    1   1   1         ?          :   1   :   1;  // reducing pessimism
        ?   (1x)    0   1   1         ?          :   0   :   0;  // for scan data                        
        ?   (x0)    1   1   1         ?          :   1   :   1;  
        ?   (x0)    0   1   1         ?          :   0   :   0;  

        1   (10)    1   x   1         ?          :   ?   :   1; // reducing pessimism
        0   (10)    0   x   1         ?          :   ?   :   0;                      
             
        0   (1x)    0   x   1         ?          :   0   :   0; //AB
        0   (x0)    0   x   1         ?          :   0   :   0; //AB    

        1   (1x)    1   x   1         ?          :   1   :   1; //AB
        1   (x0)    1   x   1         ?          :   1   :   1; //AB   
             
        1   (10)    1   x   x         ?          :   ?   :   1; 
        1   (1x)    1   x   x         ?          :   1   :   1; //AB
        1   (x0)    1   x   x         ?          :   1   :   1; //AB

        ?    ?      *   ?   ?         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   ?         ?          :   ?   :   -;  // ignore edges on TE
        ?    ?      ?   ?   ?         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_N_SD_S_NO (Q, D, CP, TI, TE, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, TI, TE, SB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET WITH  scan inputs ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  SB     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (10)    ?   0   0         ?          :   ?   :   1;  // clocked data
        0   (10)    ?   0   0         ?          :   ?   :   0;
                                
        1   (10)    ?   1   x         ?          :   ?   :   1;  // pessimism
                                
        1    ?      ?   0   x         ?          :   1   :   1;  // pessimism

        0    1      ?   0   x         ?          :   1   :   1;  // pessimism
        0    x      ?   0 (?x)        ?          :   1   :   1;  // pessimism
        0    0      ?   0 (?x)        ?          :   1   :   1;  // pessimism

        x    1      ?   0   x         ?          :   1   :   1;  // pessimism
        x    x      ?   0 (?x)        ?          :   1   :   1;  // pessimism
        x    0      ?   0 (?x)        ?          :   1   :   1;  // pessimism

        ?    ?      1   1   x         ?          :   1   :   1;  // pessimism
                     
        ?    1      0   1   x         ?          :   1   :   1;  // pessimism
        ?    x      0   1 (?x)        ?          :   1   :   1;  // pessimism
        ?    0      0   1 (?x)        ?          :   1   :   1;  // pessimism
                     
        ?    1      x   1   x         ?          :   1   :   1;  // pessimism
        ?    x      x   1 (?x)        ?          :   1   :   1;  // pessimism
        ?    0      x   1 (?x)        ?          :   1   :   1;  // pessimism
  
        ?    ?      ?   x (?x)        ?          :   1   :   1;  // AB
                                                                      
        1   (1x)    ?   0   0         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    ?   0   0         ?          :   0   :   0;                          
        1   (x0)    ?   0   0         ?          :   1   :   1;  
        0   (x0)    ?   0   0         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   1         ?          :   ?   :   1;  // asynchronous set
                                
        ?   (?1)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?0)       ?          :   ?   :   -;  // ignore the edges on set 

        ?   (10)    0   1   0         ?          :   ?   :   0;  // scan data
        ?   (10)    1   1   0         ?          :   ?   :   1;  // 

        ?   (10)    1   1   x         ?          :   ?   :   1;
        
        ?   (1x)    1   1   0         ?          :   1   :   1;  // reducing pessimism
        ?   (1x)    0   1   0         ?          :   0   :   0;  // for scan data                        
        ?   (x0)    1   1   0         ?          :   1   :   1;  
        ?   (x0)    0   1   0         ?          :   0   :   0;  

        1   (10)    1   x   0         ?          :   ?   :   1; // reducing pessimism
        0   (10)    0   x   0         ?          :   ?   :   0;                      
             
        0   (1x)    0   x   0         ?          :   0   :   0; //AB
        0   (x0)    0   x   0         ?          :   0   :   0; //AB    

        1   (1x)    1   x   0         ?          :   1   :   1; //AB
        1   (x0)    1   x   0         ?          :   1   :   1; //AB   
             
        1   (10)    1   x   x         ?          :   ?   :   1; 
        1   (1x)    1   x   x         ?          :   1   :   1; //AB
        1   (x0)    1   x   x         ?          :   1   :   1; //AB

        ?    ?      *   ?   ?         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   ?         ?          :   ?   :   -;  // ignore edges on TE
        ?    ?      ?   ?   ?         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_N_S_NO (Q, D, CP, S, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, S;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET ( Q OUTPUT UDP )


    table
 
    //  D   CP      S     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    0         ?          :   ?   :   1;  // clocked data
        0   (10)    0         ?          :   ?   :   0;
        1   (10)    x         ?          :   ?   :   1;  // reducing pessimism
        1    ?      x         ?          :   1   :   1;  // pessimism

        0    1      x         ?          :   1   :   1;  // pessimism
        0    x    (?x)        ?          :   1   :   1;  // pessimism
        0    0    (?x)        ?          :   1   :   1;  // pessimism

        x    1      x         ?          :   1   :   1;  // pessimism
        x    x    (?x)        ?          :   1   :   1;  // pessimism
        x    0    (?x)        ?          :   1   :   1;  // pessimism

        1   (1x)    0         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0         ?          :   0   :   0;                          
        1   (x0)    0         ?          :   1   :   1;  
        0   (x0)    0         ?          :   0   :   0;  

        ?    ?      1         ?          :   ?   :   1;  // asynchronous clear

        ?   (?1)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the data edges

        ?   ?     (?0)        ?          :   ?   :   -;  // ignore the edges on set
        
        ?   ?       ?         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_N_S_R (Q, D, CP, R, S);

    output Q;  
    input  D, CP, R, S;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP )
    
     table
 
    //  D    CP     R   S   :   Qt  :   Qt+1
                
        1   (10)    0   0   :   ?   :   1;  // clocked data
        1   (10)    0   x   :   ?   :   1;  // pessimism

        1    ?      0   x   :   1   :   1;  // pessimism

        0    1      0   x   :   1   :   1;  // pessimism
        0    x      0 (?x)  :   1   :   1;  // pessimism
        0    0      0 (?x)  :   1   :   1;  // pessimism

        x    1      0   x   :   1   :   1;  // pessimism
        x    x      0 (?x)  :   1   :   1;  // pessimism
        x    0      0 (?x)  :   1   :   1;  // pessimism
                
        0   (10)    0   0   :   ?   :   0;  // clocked data
        0   (10)    x   0   :   ?   :   0;  // pessimism

        0    ?      x   0   :   0   :   0;  // pessimism

        1    1      x   0   :   0   :   0;  // pessimism
        1    x    (?x)  0   :   0   :   0;  // pessimism
        1    0    (?x)  0   :   0   :   0;  // pessimism

        x    1      x   0   :   0   :   0;  // pessimism
        x    x    (?x)  0   :   0   :   0;  // pessimism
        x    0    (?x)  0   :   0   :   0;  // pessimism
                                                           
        1   (1x)    0   0   :   1   :   1;  // reducing pessimism
        0   (1x)    0   0   :   0   :   0;                          
        1   (x0)    0   0   :   1   :   1;  
        0   (x0)    0   0   :   0   :   0;  
                
        ?   ?       1   0   :   ?   :   0;  // asynchronous clear
        ?   ?       ?   1   :   ?   :   1;  // asynchronous set
                
        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 
                
        ?   ?      (?0) ?   :   ?   :   -;  // ignore the edges on 
        ?   ?       0  (?0) :   ?   :   -;  // set and clear                  

    endtable
endprimitive

primitive U_FD_N_S_R_NO (Q, D, CP, R, S, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP )
        

     table
 
    //  D    CP     R   S      NOTIFIER_REG  :   Qt  :   Qt+1
                
        1   (10)    0   0         ?          :   ?   :   1;  // clocked data
        1   (10)    0   x         ?          :   ?   :   1;  // pessimism

        1    ?      0   x         ?          :   1   :   1;  // pessimism

        0    1      0   x         ?          :   1   :   1;  // pessimism
        0    x      0 (?x)        ?          :   1   :   1;  // pessimism
        0    0      0 (?x)        ?          :   1   :   1;  // pessimism

        x    1      0   x         ?          :   1   :   1;  // pessimism
        x    x      0 (?x)        ?          :   1   :   1;  // pessimism
        x    0      0 (?x)        ?          :   1   :   1;  // pessimism

                
        0   (10)    0   0         ?          :   ?   :   0;  // clocked data
        0   (10)    x   0         ?          :   ?   :   0;  // pessimism

        0    ?      x   0         ?          :   0   :   0;  // pessimism

        1    1      x   0         ?          :   0   :   0;  // pessimism
        1    x    (?x)  0         ?          :   0   :   0;  // pessimism
        1    0    (?x)  0         ?          :   0   :   0;  // pessimism

        x    1      x   0         ?          :   0   :   0;  // pessimism
        x    x    (?x)  0         ?          :   0   :   0;  // pessimism
        x    0    (?x)  0         ?          :   0   :   0;  // pessimism
                                                           
        1   (1x)    0   0         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    0   0         ?          :   0   :   0;                          
        1   (x0)    0   0         ?          :   1   :   1;  
        0   (x0)    0   0         ?          :   0   :   0;  
                
        ?   ?       1   0         ?          :   ?   :   0;  // asynchronous clear
        ?   ?       ?   1         ?          :   ?   :   1;  // asynchronous set
                
        ?   (?1)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 
                
        ?   ?     (?0)  ?         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       0  (?0)       ?          :   ?   :   -;  // set and clear                  
         
        ?   ?       ?   ?         *          :   ?   :   x; 

    endtable
endprimitive

primitive U_FD_N_S_R_NO_QN (QN, D, CP, R, S, NOTIFIER_REG); 

    output QN;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    QN; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP )
        

     table
 
    //  D    CP     R   S      NOTIFIER_REG  :   Qtn :   Qtn+1
                
        1   (10)    0   0         ?          :   ?   :   0;  // clocked data
        1   (10)    0   x         ?          :   ?   :   0;  // pessimism

        1    ?      0   x         ?          :   0   :   0;  // pessimism

        0    1      0   x         ?          :   0   :   0;  // pessimism
        0    x      0 (?x)        ?          :   0   :   0;  // pessimism
        0    0      0 (?x)        ?          :   0   :   0;  // pessimism

        x    1      0   x         ?          :   0   :   0;  // pessimism
        x    x      0 (?x)        ?          :   0   :   0;  // pessimism
        x    0      0 (?x)        ?          :   0   :   0;  // pessimism

                
        0   (10)    0   0         ?          :   ?   :   1;  // clocked data
        0   (10)    x   0         ?          :   ?   :   1;  // pessimism

        0    ?      x   0         ?          :   1   :   1;  // pessimism

        1    1      x   0         ?          :   1   :   1;  // pessimism
        1    x    (?x)  0         ?          :   1   :   1;  // pessimism
        1    0    (?x)  0         ?          :   1   :   1;  // pessimism

        x    1      x   0         ?          :   1   :   1;  // pessimism
        x    x    (?x)  0         ?          :   1   :   1;  // pessimism
        x    0    (?x)  0         ?          :   1   :   1;  // pessimism
                                                           
        1   (1x)    0   0         ?          :   0   :   0;  // reducing pessimism
        0   (1x)    0   0         ?          :   1   :   1;                          
        1   (x0)    0   0         ?          :   0   :   0;  
        0   (x0)    0   0         ?          :   1   :   1;  
                
        ?   ?       1   ?         ?          :   ?   :   1;  // asynchronous clear
        ?   ?       0   1         ?          :   ?   :   0;  // asynchronous set
                
        ?   (?1)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?         ?          :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 
                
        ?   ?     (?0)  0         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?0)       ?          :   ?   :   -;  // set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_N_S_R_QN (QN, D, CP, R, S);

    output QN;  
    input  D, CP, R, S;
    reg    QN; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP )
    
     table
 
    //  D    CP     R   S   :   Qtn :   Qtn+1
                
        1   (10)    0   0   :   ?   :   0;  // clocked data
        1   (10)    0   x   :   ?   :   0;  // pessimism

        1    ?      0   x   :   0   :   0;  // pessimism

        0    1      0   x   :   0   :   0;  // pessimism
        0    x      0 (?x)  :   0   :   0;  // pessimism
        0    0      0 (?x)  :   0   :   0;  // pessimism

        x    1      0   x   :   0   :   0;  // pessimism
        x    x      0 (?x)  :   0   :   0;  // pessimism
        x    0      0 (?x)  :   0   :   0;  // pessimism

                
        0   (10)    0   0   :   ?   :   1;  // clocked data
        0   (10)    x   0   :   ?   :   1;  // pessimism

        0    ?      x   0   :   1   :   1;  // pessimism
                        
        1    1      x   0   :   1   :   1;  // pessimism
        1    x    (?x)  0   :   1   :   1;  // pessimism
        1    0    (?x)  0   :   1   :   1;  // pessimism
                        
        x    1      x   0   :   1   :   1;  // pessimism
        x    x    (?x)  0   :   1   :   1;  // pessimism
        x    0    (?x)  0   :   1   :   1;  // pessimism
                                                           
        1   (1x)    0   0   :   0   :   0;  // reducing pessimism
        0   (1x)    0   0   :   1   :   1;                          
        1   (x0)    0   0   :   0   :   0;  
        0   (x0)    0   0   :   1   :   1;  
                
        ?   ?       1   ?   :   ?   :   1;  // asynchronous clear
        ?   ?       0   1   :   ?   :   0;  // asynchronous set
                
        ?   (?1)    ?   ?   :   ?   :   -;  // ignore rising clock
        ?   (0x)    ?   ?   :   ?   :   -;  // ignore rising clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 
                
        ?   ?     (?0)  0   :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?0) :   ?   :   -;  // set and clear                  

    endtable
endprimitive


primitive U_FD_P  (Q, D, CP);

    output Q;  
    input  D, CP;
    reg    Q;  

// FUNCTION :  POSITIVE EDGE TRIGGERED D FLIP-FLOP ( Q OUTPUT UDP ).

    table
 
    //  D   CP        :   Qt  :   Qt+1

        1   (01)      :   ?   :   1;  // clocked data
        0   (01)      :   ?   :   0;
                                                           
        1   (x1)      :   1   :   1;  // reducing pessimism
        0   (x1)      :   0   :   0;                          
        1   (0x)      :   1   :   1;  
        0   (0x)      :   0   :   0; 
        
        ?   (1x)      :   ?   :   -;  // no change on falling edge 
        ?   (?0)      :   ?   :   -;  

        *    ?        :   ?   :   -;  // ignore edges on data

    endtable
endprimitive



primitive U_FD_P_CEB_NO (Q, D, CP, CEB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, CEB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH CLOCK ENABLE INPUT ( Q OUTPUT UDP ) 


    table
 
    //  D   CP      CEB     NOTIFIER_REG  :   Qt  :   Qt+1
                            
        1   (01)    0         ?          :   ?   :   1;  // clocked data
        0   (01)    0         ?          :   ?   :   0;
                            
        1   (x1)    0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0         ?          :   0   :   0;                          
        1   (0x)    0         ?          :   1   :   1;  
        0   (0x)    0         ?          :   0   :   0;  
                            
                            
        ?   (?0)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the edges on data
                                  
        1   (01)    x         ?          :   1   :   1;  // reducing pessimism
        0   (01)    x         ?          :   0   :   0;                      
             
        1   (x1)    x         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    x         ?          :   0   :   0;                          
        1   (0x)    x         ?          :   1   :   1;  
        0   (0x)    x         ?          :   0   :   0;  

 
        ?   (?1)    1         ?          :   ?   :   -;  // reducing pessimism
        ?   (0x)    1         ?          :   ?   :   -;  // reducing pessimism

        ?    ?      *         ?          :   ?   :   -; // ignore edges on CE
        ?    ?      ?         *          :   ?   :   x;

    endtable
endprimitive


primitive U_FD_P_CEB_S_NO (Q, D, CP, S, CEB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, S, CEB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS PRESET and ENABLE ACTIVE LOW ( Q OUTPUT UDP ).


    table
 
    //  D   CP      S   CEB      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    0    0          ?          :   ?   :   1;  // clocked data
        0   (01)    0    0          ?          :   ?   :   0;
 
        1   (01)    0    x          ?          :   1   :   1;  // clocked data
        0   (01)    0    x          ?          :   0   :   0;

        1   (01)    x    0          ?          :   ?   :   1;  // pessimism
        1    ?      x    0          ?          :   1   :   1;  // pessimism

        0    0      x    0          ?          :   1   :   1;  // pessimism
        0    x    (?x)   0          ?          :   1   :   1;  // pessimism
        0    1    (?x)   0          ?          :   1   :   1;  // pessimism

        x    0      x    0          ?          :   1   :   1;  // pessimism
        x    x    (?x)   0          ?          :   1   :   1;  // pessimism
        x    1    (?x)   0          ?          :   1   :   1;  // pessimism
        
        1    ?      x    x          ?          :   1   :   1;  // pessimism

        0    0      x    x          ?          :   1   :   1;  // pessimism
        0    x    (?x)   x          ?          :   1   :   1;  // pessimism
        0    1    (?x)   x          ?          :   1   :   1;  // pessimism

        x    0      x    x          ?          :   1   :   1;  // pessimism
        x    x    (?x)   x          ?          :   1   :   1;  // pessimism
        x    1    (?x)   x          ?          :   1   :   1;  // pessimism


        1   (x1)    0    0          ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0    0          ?          :   0   :   0;                          
        1   (0x)    0    0          ?          :   1   :   1;  
        0   (0x)    0    0          ?          :   0   :   0;  

        1   (x1)    0    x          ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0    x          ?          :   0   :   0;                          
        1   (0x)    0    x          ?          :   1   :   1;  
        0   (0x)    0    x          ?          :   0   :   0;  


        ?    ?      1    ?          ?          :   ?   :   1;  // asynchronous preset

        ?   (?1)    0    1          ?          :   ?   :   -;  // chip is not enabled
        ?   (0x)    0    1          ?          :   ?   :   -;  // chip is not enabled

        ?   (?1)    x    1          ?          :   1   :   1;  // chip is not enabled pessimism with preset
        ?   (0x)    x    1          ?          :   1   :   1;  // chip is not enabled pessimism with preset
        ?    ?    (?x)   1          ?          :   1   :   1;  // chip is not enabled pessimism with preset


        ?   (?0)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?    ?          ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?0)   ?          ?          :   ?   :   -;  // ignore the edges on preset
  
        ?    ?      ?    *          ?          :   ?   :   -;

        ?    ?      ?    ?          *          :   ?   :   x;
 
    endtable
endprimitive



primitive U_FD_P_CE_NO (Q, D, CP, CE, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, CE;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH CLOCK ENABLE INPUT ( Q OUTPUT UDP ) 


    table
 
    //  D   CP      CE     NOTIFIER_REG  :   Qt  :   Qt+1
                            
        1   (01)    1         ?          :   ?   :   1;  // clocked data
        0   (01)    1         ?          :   ?   :   0;
                            
        1   (x1)    1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1         ?          :   0   :   0;                          
        1   (0x)    1         ?          :   1   :   1;  
        0   (0x)    1         ?          :   0   :   0;  
                            
                            
        ?   (?0)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the edges on data
                                  
        1   (01)    x         ?          :   1   :   1;  // reducing pessimism
        0   (01)    x         ?          :   0   :   0;                      
             
        1   (x1)    x         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    x         ?          :   0   :   0;                          
        1   (0x)    x         ?          :   1   :   1;  
        0   (0x)    x         ?          :   0   :   0;  

 
        ?   (?1)    0         ?          :   ?   :   -;  // reducing pessimism
        ?   (0x)    0         ?          :   ?   :   -;  // reducing pessimism

        ?    ?      *         ?          :   ?   :   -; // ignore edges on CE
        ?    ?      ?         *          :   ?   :   x;

    endtable
endprimitive


primitive U_FD_P_CE_RB_NO (Q, D, CP, RB, CE, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB, CE;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR and ENABLE ( Q OUTPUT UDP ).


    table
 
    //  D   CP      RB   CE      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1    1          ?          :   ?   :   1;  // clocked data
        0   (01)    1    1          ?          :   ?   :   0;
 
        1   (01)    1    x          ?          :   1   :   1;  // clocked data
        0   (01)    1    x          ?          :   0   :   0;

        0   (01)    x    1          ?          :   ?   :   0;  // pessimism
        0    ?      x    1          ?          :   0   :   0;  // pessimism

        1    0      x    1          ?          :   0   :   0;  // pessimism
        1    x    (?x)   1          ?          :   0   :   0;  // pessimism
        1    1    (?x)   1          ?          :   0   :   0;  // pessimism

        x    0      x    1          ?          :   0   :   0;  // pessimism
        x    x    (?x)   1          ?          :   0   :   0;  // pessimism
        x    1    (?x)   1          ?          :   0   :   0;  // pessimism
        
        0    ?      x    x          ?          :   0   :   0;  // pessimism

        1    0      x    x          ?          :   0   :   0;  // pessimism
        1    x    (?x)   x          ?          :   0   :   0;  // pessimism
        1    1    (?x)   x          ?          :   0   :   0;  // pessimism

        x    0      x    x          ?          :   0   :   0;  // pessimism
        x    x    (?x)   x          ?          :   0   :   0;  // pessimism
        x    1    (?x)   x          ?          :   0   :   0;  // pessimism


        1   (x1)    1    1          ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1    1          ?          :   0   :   0;                          
        1   (0x)    1    1          ?          :   1   :   1;  
        0   (0x)    1    1          ?          :   0   :   0;  

        1   (x1)    1    x          ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1    x          ?          :   0   :   0;                          
        1   (0x)    1    x          ?          :   1   :   1;  
        0   (0x)    1    x          ?          :   0   :   0;  


        ?    ?      0    ?          ?          :   ?   :   0;  // asynchronous clear

        ?   (?1)    1    0          ?          :   ?   :   -;  // chip is not enabled
        ?   (0x)    1    0          ?          :   ?   :   -;  // chip is not enabled

        ?   (?1)    x    0          ?          :   0   :   0;  // chip is not enabled pessimism with reset
        ?   (0x)    x    0          ?          :   0   :   0;  // chip is not enabled pessimism with reset
        ?    ?    (?x)   0          ?          :   0   :   0;  // chip is not enabled pessimism with reset


        ?   (?0)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?    ?          ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?1)   ?          ?          :   ?   :   -;  // ignore the edges on clear 
  
        ?    ?      ?    *          ?          :   ?   :   -;

        ?    ?      ?    ?          *          :   ?   :   x;
 
    endtable
endprimitive




primitive U_FD_P_CE_S_NO (Q, D, CP, S, CE, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, S, CE;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS PRESET and ENABLE ( Q OUTPUT UDP ).


    table
 
    //  D   CP      S   CE      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    0    1          ?          :   ?   :   1;  // clocked data
        0   (01)    0    1          ?          :   ?   :   0;
 
        1   (01)    0    x          ?          :   1   :   1;  // clocked data
        0   (01)    0    x          ?          :   0   :   0;

        1   (01)    x    1          ?          :   ?   :   1;  // pessimism
        1    ?      x    1          ?          :   1   :   1;  // pessimism

        0    0      x    1          ?          :   1   :   1;  // pessimism
        0    x    (?x)   1          ?          :   1   :   1;  // pessimism
        0    1    (?x)   1          ?          :   1   :   1;  // pessimism

        x    0      x    1          ?          :   1   :   1;  // pessimism
        x    x    (?x)   1          ?          :   1   :   1;  // pessimism
        x    1    (?x)   1          ?          :   1   :   1;  // pessimism
        
        1    ?      x    x          ?          :   1   :   1;  // pessimism

        0    0      x    x          ?          :   1   :   1;  // pessimism
        0    x    (?x)   x          ?          :   1   :   1;  // pessimism
        0    1    (?x)   x          ?          :   1   :   1;  // pessimism

        x    0      x    x          ?          :   1   :   1;  // pessimism
        x    x    (?x)   x          ?          :   1   :   1;  // pessimism
        x    1    (?x)   x          ?          :   1   :   1;  // pessimism


        1   (x1)    0    1          ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0    1          ?          :   0   :   0;                          
        1   (0x)    0    1          ?          :   1   :   1;  
        0   (0x)    0    1          ?          :   0   :   0;  

        1   (x1)    0    x          ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0    x          ?          :   0   :   0;                          
        1   (0x)    0    x          ?          :   1   :   1;  
        0   (0x)    0    x          ?          :   0   :   0;  


        ?    ?      1    ?          ?          :   ?   :   1;  // asynchronous preset

        ?   (?1)    0    0          ?          :   ?   :   -;  // chip is not enabled
        ?   (0x)    0    0          ?          :   ?   :   -;  // chip is not enabled

        ?   (?1)    x    0          ?          :   1   :   1;  // chip is not enabled pessimism with preset
        ?   (0x)    x    0          ?          :   1   :   1;  // chip is not enabled pessimism with preset
        ?    ?    (?x)   0          ?          :   1   :   1;  // chip is not enabled pessimism with preset


        ?   (?0)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?    ?          ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?    ?          ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?0)   ?          ?          :   ?   :   -;  // ignore the edges on preset
  
        ?    ?      ?    *          ?          :   ?   :   -;

        ?    ?      ?    ?          *          :   ?   :   x;
 
    endtable
endprimitive




primitive U_FD_P_NO (Q, D, CP , NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP;
    reg    Q;  

// FUNCTION :  POSITIVE EDGE TRIGGERED D FLIP-FLOP ( Q OUTPUT UDP ).


    table
 
    //  D   CP           NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)            ?          :   ?   :   1;  // clocked data
        0   (01)            ?          :   ?   :   0;
                                                           
        1   (x1)            ?          :   1   :   1;  // reducing pessimism
        0   (x1)            ?          :   0   :   0;                          
        1   (0x)            ?          :   1   :   1;  
        0   (0x)            ?          :   0   :   0; 
        
        ?   (1x)            ?          :   ?   :   -;  // no change on falling edge 
        ?   (?0)            ?          :   ?   :   -;  

        *    ?              ?          :   ?   :   -;  // ignore edges on data
        
        ?    ?              *          :   ?   :   x;
    endtable
endprimitive



primitive U_FD_P_PLD  (Q, D, CP, PD, PLD);

    output Q;  
    input  D, CP, PD, PLD;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH PARALLEL LOAD ( Q OUTPUT UDP ).

    table
 
    //  D   CP      PD PLD  :   Qt  :   Qt+1
                            
        1   (01)    ?   1   :   ?   :   1;  // clocked data
        0   (01)    ?   1   :   ?   :   0;
                            
        1   (x1)    ?   1   :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1   :   0   :   0;                          
        1   (0x)    ?   1   :   1   :   1;  
        0   (0x)    ?   1   :   0   :   0;  
                            
                            
        ?   (?0)    ?   1   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   1   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore the edges on data
                            
        ?    ?      0   0   :   ?   :   0;  // load parallel data
        ?    ?      1   0   :   ?   :   1;  // load parallel data   

        1   (01)    1   x   :   ?   :   1; // reducing pessimism
        0   (01)    0   x   :   ?   :   0;                      
             
        ?    ?      1   x   :   1   :   1; // reducing pessimism
        ?    ?      0   x   :   0   :   0;
     

        ?    ?      *   ?   :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1) :   ?   :   -;  // ignore edges 


    endtable
endprimitive

primitive U_FD_P_PLD_NO  (Q, D, CP, PD, PLD, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, PD, PLD;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH PARALLEL LOAD ( Q OUTPUT UDP ).


    table
 
    //  D   CP      PD PLD     NOTIFIER_REG  :   Qt  :   Qt+1
                            
        1   (01)    ?   1         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   1         ?          :   ?   :   0;
                            
        1   (x1)    ?   1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1         ?          :   0   :   0;                          
        1   (0x)    ?   1         ?          :   1   :   1;  
        0   (0x)    ?   1         ?          :   0   :   0;  
                            
                            
        ?   (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock

        *    ?      ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                            
        ?    ?     (?0) 0         ?          :   ?   :   0;  // load parallel data
        ?    ?     (?1) 0         ?          :   ?   :   1;  // load parallel data   

        ?    ?      0  (?0)       ?          :   ?   :   0;  // load parallel data
        ?    ?      1  (?0)       ?          :   ?   :   1;  // load parallel data   

        1   (01)    1   x         ?          :   ?   :   1; // reducing pessimism
        0   (01)    0   x         ?          :   ?   :   0;                      
             
        ?    ?      1  (?x)       ?          :   1   :   1; // reducing pessimism
        ?    ?      0  (?x)       ?          :   0   :   0;

        ?    ?    (?1)  x         ?          :   1   :   1; // reducing pessimism
        ?    ?    (?0)  x         ?          :   0   :   0;

        ?    ?      *   1         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1)       ?          :   ?   :   -;  // ignore edges 

        ?    ?      ?   ?         *          :   ?   :   x; 
    endtable
endprimitive

primitive U_FD_P_R  (Q, D, CP, R);

    output Q;  
    input  D, CP, R;
    reg    Q; 
    
// FUNCTION :  POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//             ASYNCHRONOUS CLEAR ( Q OUTPUT UDP ).

    table
 
    //  D   CP      R   :   Qt  :   Qt+1

        1   (01)    0   :   ?   :   1;  // clocked data
        0   (01)    0   :   ?   :   0;

        0   (01)    x   :   ?   :   0;  // pessimism
        0    ?      x   :   0   :   0;  // pessimism

        1    0      x   :   0   :   0;  // pessimism
        1    x    (?x)  :   0   :   0;  // pessimism
        1    1    (?x)  :   0   :   0;  // pessimism

        x    0      x   :   0   :   0;  // pessimism
        x    x    (?x)  :   0   :   0;  // pessimism
        x    1    (?x)  :   0   :   0;  // pessimism
                                                           
        1   (x1)    0   :   1   :   1;  // reducing pessimism
        0   (x1)    0   :   0   :   0;                          
        1   (0x)    0   :   1   :   1;  
        0   (0x)    0   :   0   :   0;  


        ?   ?       1   :   ?   :   0;  // asynchronous clear

        ?   (?0)    ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   :   ?   :   -;  // ignore the edges on data

        ?    ?    (?0)  :   ?   :   -;  // ignore the edges on clear 


    endtable
endprimitive



primitive U_FD_P_RB  (Q, D, CP, RB);

    output Q;  
    input  D, CP, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR ( Q OUTPUT UDP ).

    table
 
    //  D   CP      RB  :   Qt  :   Qt+1

        1   (01)    1   :   ?   :   1;  // clocked data
        0   (01)    1   :   ?   :   0;

        0   (01)    x   :   ?   :   0;  // pessimism

        0    ?      x   :   0   :   0;  // pessimism
                       
        1    0      x   :   0   :   0;  // pessimism
        1    x    (?x)  :   0   :   0;  // pessimism
        1    1    (?x)  :   0   :   0;  // pessimism
                       
        x    0      x   :   0   :   0;  // pessimism
        x    x    (?x)  :   0   :   0;  // pessimism
        x    1    (?x)  :   0   :   0;  // pessimism

        1   (x1)    1   :   1   :   1;  // reducing pessimism
        0   (x1)    1   :   0   :   0;                          
        1   (0x)    1   :   1   :   1;  
        0   (0x)    1   :   0   :   0;  


        ?   ?       0   :   ?   :   0;  // asynchronous clear

        ?   (?0)    ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   :   ?   :   -;  // ignore the edges on data

        ?    ?    (?1)  :   ?   :   -;  // ignore the edges on clear 


    endtable
endprimitive



primitive U_FD_P_RBC (Q, D, CP, RB);

    output Q;  
    input  D, CP, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            SYNCHRONOUS CLEAR ( Q OUTPUT UDP )

    table
 
    //  D   CP      RB  :   Qt  :   Qt+1

        1   (01)    1   :   ?   :   1;  // clocked data
        0   (01)    1   :   ?   :   0;  // reducing pessimism 
        0   (01)    x   :   ?   :   0; 
                                                           
        1   (x1)    1   :   1   :   1;  // reducing pessimism
        0   (x1)    1   :   0   :   0;                          
        1   (0x)    1   :   1   :   1;  
        0   (0x)    1   :   0   :   0;  

        ?   (01)    0   :   ?   :   0;  // synchronous clear
        ?    ?      x   :   0   :   0;  // pessimism

        ?   (?0)    ?   :   ?   :   -;  // ignore falling clock  
        ?   (1x)    ?   :   ?   :   -;  // ignore falling clock

        *    ?      ?   :   ?   :   -;  // ignore the edges on data
        ?    ?      *   :   ?   :   -;  // ignore the edge of clear


    endtable
endprimitive



primitive U_FD_P_RBC_LD  (Q, D, CP, RB, LD);

    output Q;  
    input  D, CP, RB, LD;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH
//            SYNCHRONOUS CLEAR AND LOAD ( Q OUTPUT UDP )

    table
 
    //  D   CP      RB   LD :   Qt  :   Qt+1

        1   (01)    1    1  :   ?   :   1;  // clocked data
        0   (01)    1    1  :   ?   :   0;  
        0   (01)    x    1  :   ?   :   0;  // reducing pessimism  

        ?    ?      1    0  :   ?   :   -;  // load disabled
        ?    ?      0    0  :   ?   :   -;  // load disabled
        ?   (01)    1    x  :   ?   :   -;  
                                                           
        1   (x1)    1    ?  :   1   :   1;  // reducing pessimism
        0   (x1)    1    ?  :   0   :   0;                          
        1   (0x)    1    ?  :   1   :   1;  
        0   (0x)    1    ?  :   0   :   0;  

        ?   (01)    0    ?  :   ?   :   0;  // synchronous clear
        ?    ?      x    ?  :   0   :   0;  // pessimism

        ?   (?0)    ?    ?  :   ?   :   -;  // ignore falling clock  
        ?   (1x)    ?    ?  :   ?   :   -;  // ignore falling clock 

        *    ?      ?    ?  :   ?   :   -;  // ignore the edges on data
                                                                  
        ?    ?      *    ?  :   ?   :   -;  // ignore the edge of clear
        ?    ?      ?    *  :   ?   :   -;  // ignore the edge of load


    endtable
endprimitive



primitive U_FD_P_RBC_LD_NO  (Q, D, CP, RB, LD, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB, LD;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH
//            SYNCHRONOUS CLEAR AND LOAD ( Q OUTPUT UDP )


    table
 
    //  D   CP      RB   LD    NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1    1        ?          :   ?   :   1;  // clocked data
        0   (01)    1    1        ?          :   ?   :   0;  
        0   (01)    x    1        ?          :   ?   :   0;  // reducing pessimism  

        ?    ?      1    0        ?          :   ?   :   -;  // load disabled
        ?    ?      0    0        ?          :   ?   :   -;  // load disabled
        ?   (01)    1    x        ?          :   ?   :   -;  
                                                           
        1   (x1)    1    ?        ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1    ?        ?          :   0   :   0;                          
        1   (0x)    1    ?        ?          :   1   :   1;  
        0   (0x)    1    ?        ?          :   0   :   0;  

        ?   (01)    0    ?        ?          :   ?   :   0;  // synchronous clear
        ?    ?      x    ?        ?          :   0   :   0;  // pessimism

        ?   (?0)    ?    ?        ?          :   ?   :   -;  // ignore falling clock  
        ?   (1x)    ?    ?        ?          :   ?   :   -;  // ignore falling clock 

        *    ?      ?    ?        ?          :   ?   :   -;  // ignore the edges on data
                                                                  
        ?    ?      *    ?        ?          :   ?   :   -;  // ignore the edge of clear
        ?    ?      ?    *        ?          :   ?   :   -;  // ignore the edge of load

        ?    ?      ?    ?        *          :   ?   :   x;
   
    endtable
endprimitive



primitive U_FD_P_RBC_NO (Q, D, CP, RB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            SYNCHRONOUS CLEAR ( Q OUTPUT UDP )


    table
 
    //  D   CP      RB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1         ?          :   ?   :   1;  // clocked data
        0   (01)    1         ?          :   ?   :   0;  // reducing pessimism 
        0   (01)    x         ?          :   ?   :   0; 
                                                           
        1   (x1)    1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1         ?          :   0   :   0;                          
        1   (0x)    1         ?          :   1   :   1;  
        0   (0x)    1         ?          :   0   :   0;  

        ?   (01)    0         ?          :   ?   :   0;  // synchronous clear

        ?   (?0)    ?         ?          :   ?   :   -;  // ignore falling clock  
        ?   (1x)    ?         ?          :   ?   :   -;  // ignore falling clock

        *    ?      ?         ?          :   ?   :   -;  // ignore the edges on data
        ?    ?      *         ?          :   ?   :   -;  // ignore the edge of clear
        ?    ?      ?         *          :   ?   :   x;

    endtable
endprimitive




primitive U_FD_P_RB_NO (Q, D, CP, RB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR ( Q OUTPUT UDP ).


    table
 
    //  D   CP      RB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1         ?          :   ?   :   1;  // clocked data
        0   (01)    1         ?          :   ?   :   0;

        0   (01)    x         ?          :   ?   :   0;  // pessimism

        0    ?      x         ?          :   0   :   0;  // pessimism

        1    0      x         ?          :   0   :   0;  // pessimism
        1    x    (?x)        ?          :   0   :   0;  // pessimism
        1    1    (?x)        ?          :   0   :   0;  // pessimism

        x    0      x         ?          :   0   :   0;  // pessimism
        x    x    (?x)        ?          :   0   :   0;  // pessimism
        x    1    (?x)        ?          :   0   :   0;  // pessimism

        1   (x1)    1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1         ?          :   0   :   0;                          
        1   (0x)    1         ?          :   1   :   1;  
        0   (0x)    1         ?          :   0   :   0;  


        ?   ?       0         ?          :   ?   :   0;  // asynchronous clear

        ?   (?0)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?1)        ?          :   ?   :   -;  // ignore the edges on clear 

        ?    ?      ?         *          :   ?   :   x;
 
    endtable
endprimitive



primitive U_FD_P_RB_PLD  (Q, D, CP, PD, PLD, RB);

    output Q;  
    input  D, CP, PD, PLD, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR AND PARALLEL LOAD ( Q OUTPUT UDP )

    table
 
    //  D   CP      PD PLD  RB  :   Qt  :   Qt+1
                                
        1   (01)    ?   1   1   :   ?   :   1;  // clocked data
        0   (01)    ?   1   1   :   ?   :   0;
                                
        0   (01)    ?   1   x   :   ?   :   0;  // pessimism
                                
        0    ?      ?   1   x   :   0   :   0;  // pessimism
                        
        1    0      ?   1   x   :   0   :   0;  // pessimism
        1    x      ?   1 (?x)  :   0   :   0;  // pessimism
        1    1      ?   1 (?x)  :   0   :   0;  // pessimism
                        
        x    0      ?   1   x   :   0   :   0;  // pessimism
        x    x      ?   1 (?x)  :   0   :   0;  // pessimism
        x    1      ?   1 (?x)  :   0   :   0;  // pessimism
                                                                   
        1   (x1)    ?   1   1   :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1   1   :   0   :   0;                          
        1   (0x)    ?   1   1   :   1   :   1;  
        0   (0x)    ?   1   1   :   0   :   0;  
                                
        ?    ?      ?   ?   0   :   ?   :   0;  // asynchronous clear
                                
        ?   (?0)    ?   ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?   :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1) :   ?   :   -;  // ignore the edges on clear 

        ?    ?      0   0   1   :   ?   :   0;  // load parallel data
        ?    ?      1   0   1   :   ?   :   1;  // load parallel data
        1   (01)    1   x   1   :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1   :   ?   :   0;                      
             
        ?    ?      1   x   1   :   1   :   1; // reducing pessimism
        ?    ?      0   x   1   :   0   :   0;   
        
        ?    ?      0   x   x   :   0   :   0;
        0   (01)    0   x   x   :   ?   :   0; 

        ?    ?      *   ?   ?   :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1) 1   :   ?   :   -;  // ignore edges      

    endtable
endprimitive


primitive U_FD_P_RB_PLD_NO  (Q, D, CP, PD, PLD, RB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, PD, PLD, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR AND PARALLEL LOAD ( Q OUTPUT UDP )


    table
 
    //  D   CP      PD PLD  RB     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (01)    ?   1   1         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   1   1         ?          :   ?   :   0;
                                
        0   (01)    ?   1   x         ?          :   ?   :   0;  // pessimism
                                
        0    ?      ?   1   x         ?          :   0   :   0;  // pessimism
                     
        1    0      ?   1   x         ?          :   0   :   0;  // pessimism
        1    x      ?   1 (?x)        ?          :   0   :   0;  // pessimism
        1    1      ?   1 (?x)        ?          :   0   :   0;  // pessimism
                    
        x    0      ?   1   x         ?          :   0   :   0;  // pessimism
        x    x      ?   1 (?x)        ?          :   0   :   0;  // pessimism
        x    1      ?   1 (?x)        ?          :   0   :   0;  // pessimism
                
                                                                   
        1   (x1)    ?   1   1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1   1         ?          :   0   :   0;                          
        1   (0x)    ?   1   1         ?          :   1   :   1;  
        0   (0x)    ?   1   1         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0         ?          :   ?   :   0;  // asynchronous clear
                                
        ?   (?0)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                
        ?    ?     (?0) 0   1         ?          :   ?   :   0;  // load parallel data
        ?    ?     (?1) 0   1         ?          :   ?   :   1;  // load parallel data

        ?    ?      0  (?0) 1         ?          :   ?   :   0;  // load parallel data
        ?    ?      1  (?0) 1         ?          :   ?   :   1;  // load parallel data

        1   (01)    1   x   1         ?          :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1         ?          :   ?   :   0;                      
             
        ?    ?      1  (?x) 1         ?          :   1   :   1; // reducing pessimism
        ?    ?      0  (?x) 1         ?          :   0   :   0;   

        ?    ?    (?1)  x   1         ?          :   1   :   1; // reducing pessimism
        ?    ?    (?0)  x   1         ?          :   0   :   0;   

        0    r      0   x   x         ?          :   ?   :   0;
        ?    ?      0  (?x) x         ?          :   0   :   0;
        ?    ?      0   x  (?x)       ?          :   0   :   0;
        ?    ?    (?0)  x   x         ?          :   0   :   0;
     
        ?    ?      ?   1  (?1)       ?          :   ?   :   -;  // ignore the edges on clear 
        ?    ?      0   0  (?1)       ?          :   ?   :   0;
        ?    ?      1   0  (?1)       ?          :   ?   :   1;

        ?    ?      *   1   1         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1) 1         ?          :   ?   :   -;  // ignore edges      
        
        ?    ?      ?   ?   ?         *          :   ?   :   x;    
    endtable
endprimitive


primitive U_FD_P_RB_SB  (Q, D, CP, RB, SB);

    output Q;  
    input  D, CP, RB, SB;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP ).

    table
 
    //  D   CP      RB  SB  :   Qt  :   Qt+1

        1   (01)    1   1   :   ?   :   1;  // clocked data
        1   (01)    1   x   :   ?   :   1;  // pessimism

        1    ?      1   x   :   1   :   1;  // pessimism

        0    0      1   x   :   1   :   1;  // pessimism
        0    x      1 (?x)  :   1   :   1;  // pessimism
        0    1      1 (?x)  :   1   :   1;  // pessimism

        x    0      1   x   :   1   :   1;  // pessimism
        x    x      1 (?x)  :   1   :   1;  // pessimism
        x    1      1 (?x)  :   1   :   1;  // pessimism

        0   (01)    1   1   :   ?   :   0;  // clocked data
        0   (01)    x   1   :   ?   :   0;  // pessimism
 
        0    ?      x   1   :   0   :   0;  // pessimism

        1    0      x   1   :   0   :   0;  // pessimism
        1    x    (?x)  1   :   0   :   0;  // pessimism
        1    1    (?x)  1   :   0   :   0;  // pessimism

        x    0      x   1   :   0   :   0;  // pessimism
        x    x    (?x)  1   :   0   :   0;  // pessimism
        x    1    (?x)  1   :   0   :   0;  // pessimism
                                                           
        ?   ?       0   ?   :   ?   :   0;  // asynchronous clear
        ?   ?       1   0   :   ?   :   1;  // asynchronous set

        ?   (?0)    1   1   :   ?   :   -;  // ignore falling clock
//        ?   (1x)    1   1   :   ?   :   x;  // ignore falling clock
//        ?   (0x)    1   1   :   ?   :   x;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  1   :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?1) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive




primitive U_FD_P_RB_SB_NO (Q, D, CP, RB, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB, SB;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP ).


    table
 
    //  D   CP      RB  SB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1   1         ?          :   ?   :   1;  // clocked data
        1   (01)    1   x         ?          :   ?   :   1;  // pessimism
 
        1    ?      1   x         ?          :   1   :   1;  // pessimism

        0    0      1   x         ?          :   1   :   1;  // pessimism
        0    x      1 (?x)        ?          :   1   :   1;  // pessimism
        0    1      1 (?x)        ?          :   1   :   1;  // pessimism

        x    0      1   x         ?          :   1   :   1;  // pessimism
        x    x      1 (?x)        ?          :   1   :   1;  // pessimism
        x    1      1 (?x)        ?          :   1   :   1;  // pessimism

        0   (01)    1   1         ?          :   ?   :   0;  // clocked data
        0   (01)    x   1         ?          :   ?   :   0;  // pessimism

        0    ?      x   1         ?          :   0   :   0;  // pessimism

        1    0      x   1         ?          :   0   :   0;  // pessimism
        1    x    (?x)  1         ?          :   0   :   0;  // pessimism
        1    1    (?x)  1         ?          :   0   :   0;  // pessimism

        x    0      x   1         ?          :   0   :   0;  // pessimism
        x    x    (?x)  1         ?          :   0   :   0;  // pessimism
        x    1    (?x)  1         ?          :   0   :   0;  // pessimism

        ?   ?       0   ?         ?          :   ?   :   0;  // asynchronous clear
        ?   ?       1   0         ?          :   ?   :   1;  // asynchronous set

        ?   (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
//        ?   (1x)    1   1         ?          :   ?   :   x;  // ignore falling clock
//        ?   (0x)    1   1         ?          :   ?   :   x;  // ignore falling clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  1         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       1  (?1)       ?          :   ?   :   -;  //       set and clear                  
       
        ?   ?       ?   ?         *          :   ?   :   x;


    endtable

endprimitive



primitive U_FD_P_RB_SB_QN (QN, D, CP, RB, SB);

    output QN;  
    input  D, CP, RB, SB;
    reg    QN; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR .  ( QN OUTPUT UDP ).

    table
 
    //  D   CP      RB  SB  :   Qtn :   Qtn+1

        1   (01)    1   1   :   ?   :   0;  // clocked data
        1   (01)    1   x   :   ?   :   0;  // pessimism

        1    ?      1   x   :   0   :   0;  // pessimism

        0    0      1   x   :   0   :   0;  // pessimism
        0    x      1 (?x)  :   0   :   0;  // pessimism
        0    1      1 (?x)  :   0   :   0;  // pessimism

        x    0      1   x   :   0   :   0;  // pessimism
        x    x      1 (?x)  :   0   :   0;  // pessimism
        x    1      1 (?x)  :   0   :   0;  // pessimism

        0   (01)    1   1   :   ?   :   1;  // clocked data
        0   (01)    x   1   :   ?   :   1;  // pessimism

        0    ?      x   1   :   1   :   1;  // pessimism
                        
        1    0      x   1   :   1   :   1;  // pessimism
        1    x    (?x)  1   :   1   :   1;  // pessimism
        1    1    (?x)  1   :   1   :   1;  // pessimism
                        
        x    0      x   1   :   1   :   1;  // pessimism
        x    x    (?x)  1   :   1   :   1;  // pessimism
        x    1    (?x)  1   :   1   :   1;  // pessimism
                                                           
        1   (x1)    1   1   :   0   :   0;  // reducing pessimism
        0   (x1)    1   1   :   1   :   1;                          
        1   (0x)    1   1   :   0   :   0;  
        0   (0x)    1   1   :   1   :   1;  

        ?   ?       0   1   :   ?   :   1;  // asynchronous clear
        ?   ?       ?   0   :   ?   :   0; 

        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  ?   :   ?   :   -;  // ignore the edges on 
        ?   ?       1  (?1) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive



primitive U_FD_P_RB_SB_X  (Q, D, CP, RB, SB);

    output Q;  
    input  D, CP, RB, SB;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ILLEGAL OUPUT WHEN BOTH
//            SET AND CLEAR ARE LOW ( Q OUTPUT UDP ).

    table
 
    //  D   CP      RB  SB  :   Qt  :   Qt+1

        1   (01)    1   1   :   ?   :   1;  // clocked data
        1   (01)    1   x   :   ?   :   1;  // pessimism

        1    ?      1   x   :   1   :   1;  // pessimism

        0    0      1   x   :   1   :   1;  // pessimism
        0    x      1 (?x)  :   1   :   1;  // pessimism
        0    1      1 (?x)  :   1   :   1;  // pessimism

        x    0      1   x   :   1   :   1;  // pessimism
        x    x      1 (?x)  :   1   :   1;  // pessimism
        x    1      1 (?x)  :   1   :   1;  // pessimism

        0   (01)    1   1   :   ?   :   0;  // clocked data
        0   (01)    x   1   :   ?   :   0;  // pessimism

        0    ?      x   1   :   0   :   0;  // pessimism

        1    0      x   1   :   0   :   0;  // pessimism
        1    x    (?x)  1   :   0   :   0;  // pessimism
        1    1    (?x)  1   :   0   :   0;  // pessimism

        x    0      x   1   :   0   :   0;  // pessimism
        x    x    (?x)  1   :   0   :   0;  // pessimism
        x    1    (?x)  1   :   0   :   0;  // pessimism
                                                           
        1   (x1)    1   1   :   1   :   1;  // reducing pessimism
        0   (x1)    1   1   :   0   :   0;                          
        1   (0x)    1   1   :   1   :   1;  
        0   (0x)    1   1   :   0   :   0;  

        ?   ?       0   1   :   ?   :   0;  // asynchronous clear
        ?   ?       1   0   :   ?   :   1;  // asynchronous set
        ?   ?       0   0   :   ?   :   x;  // illegal output

        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  ?   :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?1) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive



primitive U_FD_P_R_NO (Q, D, CP, R, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, R;
    reg    Q; 
    
// FUNCTION :  POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//             ASYNCHRONOUS CLEAR ( Q OUTPUT UDP ).


    table
 
    //  D   CP      R      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    0         ?          :   ?   :   1;  // clocked data
        0   (01)    0         ?          :   ?   :   0;

        0   (01)    x         ?          :   ?   :   0;  // pessimism
        0    ?      x         ?          :   0   :   0;  // pessimism

        1    0      x         ?          :   0   :   0;  // pessimism
        1    x    (?x)        ?          :   0   :   0;  // pessimism
        1    1    (?x)        ?          :   0   :   0;  // pessimism

        x    0      x         ?          :   0   :   0;  // pessimism
        x    x    (?x)        ?          :   0   :   0;  // pessimism
        x    1    (?x)        ?          :   0   :   0;  // pessimism
                                                           
        1   (x1)    0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0         ?          :   0   :   0;                          
        1   (0x)    0         ?          :   1   :   1;  
        0   (0x)    0         ?          :   0   :   0;  


        ?   ?       1         ?          :   ?   :   0;  // asynchronous clear

        ?   (?0)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?0)        ?          :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_P_R_PLD  (Q, D, CP, PD, PLD, R);

    output Q;  
    input  D, CP, PD, PLD, R;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS CLEAR AND PARALLEL LOAD ( Q OUTPUT UDP )

    table
 
    //  D   CP      PD PLD  R  :    Qt  :   Qt+1
                                 
        1   (01)    ?   1   0   :   ?   :   1;  // clocked data
        0   (01)    ?   1   0   :   ?   :   0;
                                 
        0   (01)    ?   1   x   :   ?   :   0;  // pessimism
                                 
        0    ?      ?   1   x   :   0   :   0;  // pessimism
                             
        1    0      ?   1   x   :   0   :   0;  // pessimism
        1    x      ?   1 (?x)  :   0   :   0;  // pessimism
        1    1      ?   1 (?x)  :   0   :   0;  // pessimism
                             
        x    0      ?   1   x   :   0   :   0;  // pessimism
        x    x      ?   1 (?x)  :   0   :   0;  // pessimism
        x    1      ?   1 (?x)  :   0   :   0;  // pessimism
                                                           
                                                                   
        1   (x1)    ?   1   0   :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1   0   :   0   :   0;                          
        1   (0x)    ?   1   0   :   1   :   1;  
        0   (0x)    ?   1   0   :   0   :   0;  

                                 
        ?    ?      ?   ?   1   :   ?   :   0;  // asynchronous clear
                                 
        ?   (?0)    ?   ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?   :   ?   :   -;  // ignore the edges on data
                                 
        ?    ?      ?   ?  (?0) :   ?   :   -;  // ignore the edges on clear 
                                 
        ?    ?      0   0   0   :   ?   :   0;  // load parallel data
        ?    ?      1   0   0   :   ?   :   1;  // load parallel data
        1   (01)    1   x   0   :   ?   :   1; // reducing pessimism
        0   (01)    0   x   0   :   ?   :   0;                      
                                 
        ?    ?      1   x   0   :   1   :   1; // reducing pessimism
        ?    ?      0   x   0   :   0   :   0;   
                                 
        ?    ?      0   x   x   :   0   :   0;
        0   (01)    0   x   x   :   ?   :   0; 
                                 
        ?    ?      *   ?   ?   :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1) 0   :   ?   :   -;  // ignore edges      
                            
    endtable                
endprimitive


primitive U_FD_P_R_PLD_NO  (Q, D, CP, PD, PLD, R, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, PD, PLD, R;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS CLEAR AND PARALLEL LOAD ( Q OUTPUT UDP )


    table
 
    //  D   CP      PD PLD  R     NOTIFIER_REG  :    Qt  :   Qt+1
                                 
        1   (01)    ?   1   0         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   1   0         ?          :   ?   :   0;
                                 
        0   (01)    ?   1   x         ?          :   ?   :   0;  // pessimism
                                 
        0    ?      ?   1   x         ?          :   0   :   0;  // pessimism
        1    0      ?   1   x         ?          :   0   :   0;  // pessimism
        1    x      ?   1 (?x)        ?          :   0   :   0;  // pessimism
        1    1      ?   1 (?x)        ?          :   0   :   0;  // pessimism
        x    0      ?   1   x         ?          :   0   :   0;  // pessimism
        x    x      ?   1 (?x)        ?          :   0   :   0;  // pessimism
        x    1      ?   1 (?x)        ?          :   0   :   0;  // pessimism

        1   (x1)    ?   1   0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1   0         ?          :   0   :   0;                          
        1   (0x)    ?   1   0         ?          :   1   :   1;  
        0   (0x)    ?   1   0         ?          :   0   :   0;  
                                 
        ?    ?      ?   ?   1         ?          :   ?   :   0;  // asynchronous clear
                                 
        ?   (?0)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                 
        ?    ?     (?0) 0   0         ?          :   ?   :   0;  // load parallel data
        ?    ?     (?1) 0   0         ?          :   ?   :   1;  // load parallel data

        ?    ?      0  (?0) 0         ?          :   ?   :   0;  // load parallel data
        ?    ?      1  (?0) 0         ?          :   ?   :   1;  // load parallel data

        1   (01)    1   x   0         ?          :   ?   :   1; // reducing pessimism
        0   (01)    0   x   0         ?          :   ?   :   0;                      
             
        ?    ?      1  (?x) 0         ?          :   1   :   1; // reducing pessimism
        ?    ?      0  (?x) 0         ?          :   0   :   0;   

        ?    ?    (?1)  x   0         ?          :   1   :   1; // reducing pessimism
        ?    ?    (?0)  x   0         ?          :   0   :   0;   

        0    r      0   x   x         ?          :   ?   :   0;
        ?    ?      0  (?x) x         ?          :   0   :   0;
        ?    ?      0   x  (?x)       ?          :   0   :   0;
        ?    ?    (?0)  x   x         ?          :   0   :   0;
     
        ?    ?      ?   1  (?0)       ?          :   ?   :   -;  // ignore the edges on clear 
        ?    ?      0   0  (?0)       ?          :   ?   :   0;
        ?    ?      1   0  (?0)       ?          :   ?   :   1;
                                 
        ?    ?      *   1   0         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1) 0         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?   ?   ?         *          :   ?   :   x; 
                            
    endtable                
endprimitive


primitive U_FD_P_R_S (Q, D, CP, R, S);

    output Q;  
    input  D, CP, R, S;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP )
    
     table
 
    //  D   CP      R   S   :   Qt  :   Qt+1

        1   (01)    0   0   :   ?   :   1;  // clocked data
        1   (01)    0   x   :   ?   :   1;  // pessimism

        1    ?      0   x   :   1   :   1;  // pessimism

        0    0      0   x   :   1   :   1;  // pessimism
        0    x      0 (?x)  :   1   :   1;  // pessimism
        0    1      0 (?x)  :   1   :   1;  // pessimism

        x    0      0   x   :   1   :   1;  // pessimism
        x    x      0 (?x)  :   1   :   1;  // pessimism
        x    1      0 (?x)  :   1   :   1;  // pessimism

        0   (01)    0   0   :   ?   :   0;  // clocked data
        0   (01)    x   0   :   ?   :   0;  // pessimism
        
        0    ?      x   0   :   0   :   0;  // pessimism
                           
        1    0      x   0   :   0   :   0;  // pessimism
        1    x    (?x)  0   :   0   :   0;  // pessimism
        1    1    (?x)  0   :   0   :   0;  // pessimism
                          
        x    0      x   0   :   0   :   0;  // pessimism
        x    x    (?x)  0   :   0   :   0;  // pessimism
        x    1    (?x)  0   :   0   :   0;  // pessimism
                                                              
        1   (x1)    0   0   :   1   :   1;  // reducing pessimism
        0   (x1)    0   0   :   0   :   0;                          
        1   (0x)    0   0   :   1   :   1;        

        0   (0x)    0   0   :   0   :   0;  

        ?   ?       1   ?   :   ?   :   0;  // asynchronous clear
        ?   ?       0   1   :   ?   :   1;  // asynchronous set

        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  0   :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?0) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive

primitive U_FD_P_R_S_NO (Q, D, CP, R, S, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP )
        

     table
 
    //  D   CP      R   S      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    0   0         ?          :   ?   :   1;  // clocked data
        1   (01)    0   x         ?          :   ?   :   1;  // pessimism

        1    ?      0   x         ?          :   1   :   1;  // pessimism

        0    0      0   x         ?          :   1   :   1;  // pessimism
        0    x      0 (?x)        ?          :   1   :   1;  // pessimism
        0    1      0 (?x)        ?          :   1   :   1;  // pessimism

        x    0      0   x         ?          :   1   :   1;  // pessimism
        x    x      0 (?x)        ?          :   1   :   1;  // pessimism
        x    1      0 (?x)        ?          :   1   :   1;  // pessimism

        0   (01)    0   0         ?          :   ?   :   0;  // clocked data
        0   (01)    x   0         ?          :   ?   :   0;  // pessimism

        0    ?      x   0         ?          :   0   :   0;  // pessimism

        1    0      x   0         ?          :   0   :   0;  // pessimism
        1    x    (?x)  0         ?          :   0   :   0;  // pessimism
        1    1    (?x)  0         ?          :   0   :   0;  // pessimism

        x    0      x   0         ?          :   0   :   0;  // pessimism
        x    x    (?x)  0         ?          :   0   :   0;  // pessimism
        x    1    (?x)  0         ?          :   0   :   0;  // pessimism
                                                           
        1   (x1)    0   0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0   0         ?          :   0   :   0;                          
        1   (0x)    0   0         ?          :   1   :   1;  
        0   (0x)    0   0         ?          :   0   :   0;  

        ?   ?       1   ?         ?          :   ?   :   0;  // asynchronous clear
        ?   ?       0   1         ?          :   ?   :   1;  // asynchronous set

        ?   (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  0         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?0)       ?          :   ?   :   -;  //       set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_P_R_S_NO_QN (QN, D, CP, R, S, NOTIFIER_REG); 

    output QN;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    QN; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP )
        

     table
 
    //  D   CP      R   S      NOTIFIER_REG  :   Qtn :   Qtn+1

        1   (01)    0   0         ?          :   ?   :   0;  // clocked data
        1   (01)    0   x         ?          :   ?   :   0;  // pessimism

        1    ?      0   x         ?          :   0   :   0;  // pessimism

        0    0      0   x         ?          :   0   :   0;  // pessimism
        0    x      0 (?x)        ?          :   0   :   0;  // pessimism
        0    1      0 (?x)        ?          :   0   :   0;  // pessimism

        x    0      0   x         ?          :   0   :   0;  // pessimism
        x    x      0 (?x)        ?          :   0   :   0;  // pessimism
        x    1      0 (?x)        ?          :   0   :   0;  // pessimism

        0   (01)    0   0         ?          :   ?   :   1;  // clocked data
        0   (01)    x   0         ?          :   ?   :   1;  // pessimism

        0    ?      x   0         ?          :   1   :   1;  // pessimism

        1    0      x   0         ?          :   1   :   1;  // pessimism
        1    x    (?x)  0         ?          :   1   :   1;  // pessimism
        1    1    (?x)  0         ?          :   1   :   1;  // pessimism

        x    0      x   0         ?          :   1   :   1;  // pessimism
        x    x    (?x)  0         ?          :   1   :   1;  // pessimism
        x    1    (?x)  0         ?          :   1   :   1;  // pessimism
                                                           
        1   (x1)    0   0         ?          :   0   :   0;  // reducing pessimism
        0   (x1)    0   0         ?          :   1   :   1;                          
        1   (0x)    0   0         ?          :   0   :   0;  
        0   (0x)    0   0         ?          :   1   :   1;  

        ?   ?       1   0         ?          :   ?   :   1;  // asynchronous clear
        ?   ?       ?   1         ?          :   ?   :   0; 

        ?   (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  ?         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       0  (?0)       ?          :   ?   :   -;  //       set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_P_R_S_QN (QN, D, CP, R, S);

    output QN;  
    input  D, CP, R, S;
    reg    QN; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP )
    
     table
 
    //  D   CP      R   S   :   Qtn :   Qtn+1

        1   (01)    0   0   :   ?   :   0;  // clocked data
        1   (01)    0   x   :   ?   :   0;  // pessimism

        1    ?      0   x   :   0   :   0;  // pessimism

        0    0      0   x   :   0   :   0;  // pessimism
        0    x      0 (?x)  :   0   :   0;  // pessimism
        0    1      0 (?x)  :   0   :   0;  // pessimism

        x    0      0   x   :   0   :   0;  // pessimism
        x    x      0 (?x)  :   0   :   0;  // pessimism
        x    1      0 (?x)  :   0   :   0;  // pessimism

        0   (01)    0   0   :   ?   :   1;  // clocked data
        0   (01)    x   0   :   ?   :   1;  // pessimism

        0    ?      x   0   :   1   :   1;  // pessimism
                           
        1    0      x   0   :   1   :   1;  // pessimism
        1    x    (?x)  0   :   1   :   1;  // pessimism
        1    1    (?x)  0   :   1   :   1;  // pessimism
                          
        x    0      x   0   :   1   :   1;  // pessimism
        x    x    (?x)  0   :   1   :   1;  // pessimism
        x    1    (?x)  0   :   1   :   1;  // pessimism
                                                           
        1   (x1)    0   0   :   0   :   0;  // reducing pessimism
        0   (x1)    0   0   :   1   :   1;                          
        1   (0x)    0   0   :   0   :   0;  
        0   (0x)    0   0   :   1   :   1;  

        ?   ?       1   0   :   ?   :   1;  // asynchronous clear
        ?   ?       ?   1   :   ?   :   0;  // asynchronous set

        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  ?   :   ?   :   -;  // ignore the edges on 
        ?   ?       0  (?0) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive

primitive U_FD_P_R_S_X (Q, D, CP, R, S);

    output Q;  
    input  D, CP, R, S;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET. ILLEGAL OUTPUT OCCURS WHEN BOTH
//            SET AND RESET ARE HIGH . ( Q OUTPUT UDP )

    table
 
    //  D   CP      R   S   :   Qt  :   Qt+1

        1   (01)    0   0   :   ?   :   1;  // clocked data
        1   (01)    0   x   :   ?   :   1;  // pessimism

        1    ?      0   x   :   1   :   1;  // pessimism

        0    0      0   x   :   1   :   1;  // pessimism
        0    x      0 (?x)  :   1   :   1;  // pessimism
        0    1      0 (?x)  :   1   :   1;  // pessimism

        x    0      0   x   :   1   :   1;  // pessimism
        x    x      0 (?x)  :   1   :   1;  // pessimism
        x    1      0 (?x)  :   1   :   1;  // pessimism

        0   (01)    0   0   :   ?   :   0;  // clocked data
        0   (01)    x   0   :   ?   :   0;  // pessimism

        0    ?      x   0   :   0   :   0;  // pessimism
                           
        1    0      x   0   :   0   :   0;  // pessimism
        1    x    (?x)  0   :   0   :   0;  // pessimism
        1    1    (?x)  0   :   0   :   0;  // pessimism
                          
        x    0      x   0   :   0   :   0;  // pessimism
        x    x    (?x)  0   :   0   :   0;  // pessimism
        x    1    (?x)  0   :   0   :   0;  // pessimism
                                                           
        1   (x1)    0   0   :   1   :   1;  // reducing pessimism
        0   (x1)    0   0   :   0   :   0;                          
        1   (0x)    0   0   :   1   :   1;  
        0   (0x)    0   0   :   0   :   0;  

        ?   ?       1   0   :   ?   :   0;  // asynchronous clear
        ?   ?       0   1   :   ?   :   1;  // asynchronous set
        ?   ?       1   1   :   ?   :   x;

        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?    ?    (?0)  ?   :   ?   :   -;  // ignore the edges on 
        ?    ?      ?  (?0) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive

primitive U_FD_P_R_S_X_NO (Q, D, CP, R, S, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET. ILLEGAL OUTPUT OCCURS WHEN BOTH
//            SET AND RESET ARE HIGH . ( Q OUTPUT UDP )


    table
 
    //  D   CP      R   S      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    0   0         ?          :   ?   :   1;  // clocked data
        1   (01)    0   x         ?          :   ?   :   1;  // pessimism

        1    ?      0   x         ?          :   1   :   1;  // pessimism

        0    0      0   x         ?          :   1   :   1;  // pessimism
        0    x      0 (?x)        ?          :   1   :   1;  // pessimism
        0    1      0 (?x)        ?          :   1   :   1;  // pessimism

        x    0      0   x         ?          :   1   :   1;  // pessimism
        x    x      0 (?x)        ?          :   1   :   1;  // pessimism
        x    1      0 (?x)        ?          :   1   :   1;  // pessimism

        0   (01)    0   0         ?          :   ?   :   0;  // clocked data
        0   (01)    x   0         ?          :   ?   :   0;  // pessimism

        0    ?      x   0         ?          :   0   :   0;  // pessimism

        1    0      x   0         ?          :   0   :   0;  // pessimism
        1    x    (?x)  0         ?          :   0   :   0;  // pessimism
        1    1    (?x)  0         ?          :   0   :   0;  // pessimism

        x    0      x   0         ?          :   0   :   0;  // pessimism
        x    x    (?x)  0         ?          :   0   :   0;  // pessimism
        x    1    (?x)  0         ?          :   0   :   0;  // pessimism
                                                           
        1   (x1)    0   0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0   0         ?          :   0   :   0;                          
        1   (0x)    0   0         ?          :   1   :   1;  
        0   (0x)    0   0         ?          :   0   :   0;  

        ?   ?       1   0         ?          :   ?   :   0;  // asynchronous clear
        ?   ?       0   1         ?          :   ?   :   1;  // asynchronous set
        ?   ?       1   1         ?          :   ?   :   x;

        ?   (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  ?         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?0)       ?          :   ?   :   -;  //       set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_P_SB (Q, D, CP, SB);

    output Q;  
    input  D, CP, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP )

    table
 
    //  D   CP      SB  :   Qt  :   Qt+1

        1   (01)    1   :   ?   :   1;  // clocked data
        0   (01)    1   :   ?   :   0;
        1   (01)    x   :   ?   :   1;  // reducing pessimism

        1    ?      x   :   1   :   1;  // pessimism

        0    0      x   :   1   :   1;  // pessimism
        0    x    (?x)  :   1   :   1;  // pessimism
        0    1    (?x)  :   1   :   1;  // pessimism

        x    0      x   :   1   :   1;  // pessimism
        x    x    (?x)  :   1   :   1;  // pessimism
        x    1    (?x)  :   1   :   1;  // pessimism
                                                           
        1   (x1)    1   :   1   :   1;  // reducing pessimism
        0   (x1)    1   :   0   :   0;                          
        1   (0x)    1   :   1   :   1;  
        0   (0x)    1   :   0   :   0;  

        ?    ?      0   :   ?   :   1;  // asynchronous clear

        ?   (?0)    ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   :   ?   :   -;  // ignore the data edges

        ?   ?     (?1)  :   ?   :   -;  // ignore the edges on set

    endtable
endprimitive




primitive U_FD_P_SB_NO (Q, D, CP, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP )


    table
 
    //  D   CP      SB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1         ?          :   ?   :   1;  // clocked data
        0   (01)    1         ?          :   ?   :   0;
        1   (01)    x         ?          :   ?   :   1;  // reducing pessimism
        1    ?      x         ?          :   1   :   1;  // pessimism

        0    0      x         ?          :   1   :   1;  // pessimism
        0    x    (?x)        ?          :   1   :   1;  // pessimism
        0    1    (?x)        ?          :   1   :   1;  // pessimism

        x    0      x         ?          :   1   :   1;  // pessimism
        x    x    (?x)        ?          :   1   :   1;  // pessimism
        x    1    (?x)        ?          :   1   :   1;  // pessimism

        1   (x1)    1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1         ?          :   0   :   0;                          
        1   (0x)    1         ?          :   1   :   1;  
        0   (0x)    1         ?          :   0   :   0;  

        ?    ?      0         ?          :   ?   :   1;  // asynchronous clear

        ?   (?0)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the data edges

        ?   ?     (?1)        ?          :   ?   :   -;  // ignore the edges on set
        
        ?   ?       ?         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_P_SB_PLD  (Q, D, CP, PD, PLD, SB);

    output Q;  
    input  D, CP, PD, PLD, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND PARALLEL LOAD ( Q OUTPUT UDP )

    table
 
    //  D   CP      PD PLD  SB  :   Qt  :   Qt+1
                                
        1   (01)    ?   1   1   :   ?   :   1;  // clocked data
        0   (01)    ?   1   1   :   ?   :   0;
                                
        1   (01)    ?   1   x   :   ?   :   1;  // pessimism
                                

        1    ?      ?   1   x   :   1   :   1;  // pessimism
                             
        0    0      ?   1   x   :   1   :   1;  // pessimism
        0    x      ?   1 (?x)  :   1   :   1;  // pessimism
        0    1      ?   1 (?x)  :   1   :   1;  // pessimism
                             
        x    0      ?   1   x   :   1   :   1;  // pessimism
        x    x      ?   1 (?x)  :   1   :   1;  // pessimism
        x    1      ?   1 (?x)  :   1   :   1;  // pessimism
                                                                   
        1   (x1)    ?   1   1   :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1   1   :   0   :   0;                          
        1   (0x)    ?   1   1   :   1   :   1;  
        0   (0x)    ?   1   1   :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0   :   ?   :   1;  // asynchronous set
                                
        ?   (?0)    ?   ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?   :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1) :   ?   :   -;  // ignore the edges on clear 

        ?    ?      0   0   1   :   ?   :   0;  // load parallel data
        ?    ?      1   0   1   :   ?   :   1;  // load parallel data
        1   (01)    1   x   1   :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1   :   ?   :   0;                      
             
        ?    ?      1   x   1   :   1   :   1; // reducing pessimism
        ?    ?      0   x   1   :   0   :   0;   

        ?    ?      1   x   x   :   1   :   1;
        1   (01)    1   x   x   :   ?   :   1; 

        ?    ?      *   ?   ?   :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1) 1   :   ?   :   -;  // ignore edges      

    endtable
endprimitive


primitive U_FD_P_SB_PLD_NO  (Q, D, CP, PD, PLD, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, PD, PLD, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND PARALLEL LOAD ( Q OUTPUT UDP )


    table
 
    //  D   CP      PD PLD  SB     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (01)    ?   1   1         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   1   1         ?          :   ?   :   0;
                                
        1   (01)    ?   1   x         ?          :   ?   :   1;  // pessimism
                                

        1    ?      ?   1   x         ?          :   1   :   1;  // pessimism
                 
        0    0      ?   1   x         ?          :   1   :   1;  // pessimism
        0    x      ?   1 (?x)        ?          :   1   :   1;  // pessimism
        0    1      ?   1 (?x)        ?          :   1   :   1;  // pessimism
               
        x    0      ?   1   x         ?          :   1   :   1;  // pessimism
        x    x      ?   1 (?x)        ?          :   1   :   1;  // pessimism
        x    1      ?   1 (?x)        ?          :   1   :   1;  // pessimism
                                                                   
        1   (x1)    ?   1   1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1   1         ?          :   0   :   0;                          
        1   (0x)    ?   1   1         ?          :   1   :   1;  
        0   (0x)    ?   1   1         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0         ?          :   ?   :   1;  // asynchronous set
                                
        ?   (?0)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock

        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
  
        ?    ?     (?0) 0   1         ?          :   ?   :   0;  // load parallel data
        ?    ?     (?1) 0   1         ?          :   ?   :   1;  // load parallel data

        ?    ?      0  (?0) 1         ?          :   ?   :   0;  // load parallel data
        ?    ?      1  (?0) 1         ?          :   ?   :   1;  // load parallel data

        1   (01)    1   x   1         ?          :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1         ?          :   ?   :   0;                      
             
        ?    ?      1  (?x) 1         ?          :   1   :   1; // reducing pessimism
        ?    ?      0  (?x) 1         ?          :   0   :   0;   

        ?    ?    (?1)  x   1         ?          :   1   :   1; // reducing pessimism
        ?    ?    (?0)  x   1         ?          :   0   :   0;   

        1    r      1   x   x         ?          :   ?   :   1;
        ?    ?      1  (?x) x         ?          :   1   :   1;
        ?    ?      1   x  (?x)       ?          :   1   :   1;
        ?    ?    (?1)  x   x         ?          :   1   :   1;
     
        ?    ?      ?   1  (?1)       ?          :   ?   :   -;  // ignore the edges on clear 
        ?    ?      0   0  (?1)       ?          :   ?   :   0;
        ?    ?      1   0  (?1)       ?          :   ?   :   1;

        ?    ?      *   1   1         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1) 1         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?   ?   ?         *          :   ?   :   x; 


    endtable
endprimitive


primitive U_FD_P_SB_RB  (Q, D, CP, RB, SB);

    output Q;  
    input  D, CP, RB, SB;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP )

    table
 
    //  D   CP      RB  SB  :   Qt  :   Qt+1

        1   (01)    1   1   :   ?   :   1;  // clocked data
        1   (01)    1   x   :   ?   :   1;  // pessimism

        1    ?      1   x   :   1   :   1;  // pessimism

        0    0      1   x   :   1   :   1;  // pessimism
        0    x      1 (?x)  :   1   :   1;  // pessimism
        0    1      1 (?x)  :   1   :   1;  // pessimism

        x    0      1   x   :   1   :   1;  // pessimism
        x    x      1 (?x)  :   1   :   1;  // pessimism
        x    1      1 (?x)  :   1   :   1;  // pessimism


        0   (01)    1   1   :   ?   :   0;  // clocked data
        0   (01)    x   1   :   ?   :   0;  // pessimism

        0    ?      x   1   :   0   :   0;  // pessimism

        1    0      x   1   :   0   :   0;  // pessimism
        1    x    (?x)  1   :   0   :   0;  // pessimism
        1    1    (?x)  1   :   0   :   0;  // pessimism

        x    0      x   1   :   0   :   0;  // pessimism
        x    x    (?x)  1   :   0   :   0;  // pessimism
        x    1    (?x)  1   :   0   :   0;  // pessimism
                                                            
        1   (x1)    1   1   :   1   :   1;  // reducing pessimism
        0   (x1)    1   1   :   0   :   0;                          
        1   (0x)    1   1   :   1   :   1;  
        0   (0x)    1   1   :   0   :   0;  

        ?   ?       0   1   :   ?   :   0;  // asynchronous clear
        ?   ?       ?   0   :   ?   :   1;  // asynchronous set

        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  ?   :   ?   :   -;  // ignore the edges on 
        ?   ?       1  (?1) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive



primitive U_FD_P_SB_RB_NO  (Q, D, CP, RB, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB, SB;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR.  ( Q OUTPUT UDP )


    table
 
    //  D   CP      RB  SB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1   1         ?          :   ?   :   1;  // clocked data
        1   (01)    1   x         ?          :   ?   :   1;  // pessimism

        1    ?      1   x         ?          :   1   :   1;  // pessimism

        0    0      1   x         ?          :   1   :   1;  // pessimism
        0    x      1 (?x)        ?          :   1   :   1;  // pessimism
        0    1      1 (?x)        ?          :   1   :   1;  // pessimism

        x    0      1   x         ?          :   1   :   1;  // pessimism
        x    x      1 (?x)        ?          :   1   :   1;  // pessimism
        x    1      1 (?x)        ?          :   1   :   1;  // pessimism

        0   (01)    1   1         ?          :   ?   :   0;  // clocked data
        0   (01)    x   1         ?          :   ?   :   0;  // pessimism

        0    ?      x   1         ?          :   0   :   0;  // pessimism

        1    0      x   1         ?          :   0   :   0;  // pessimism
        1    x    (?x)  1         ?          :   0   :   0;  // pessimism
        1    1    (?x)  1         ?          :   0   :   0;  // pessimism

        x    0      x   1         ?          :   0   :   0;  // pessimism
        x    x    (?x)  1         ?          :   0   :   0;  // pessimism
        x    1    (?x)  1         ?          :   0   :   0;  // pessimism
                                                           
        1   (x1)    1   1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1   1         ?          :   0   :   0;                          
        1   (0x)    1   1         ?          :   1   :   1;  
        0   (0x)    1   1         ?          :   0   :   0;  

        ?   ?       0   1         ?          :   ?   :   0;  // asynchronous clear
        ?   ?       ?   0         ?          :   ?   :   1;  // asynchronous set

        ?   (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  ?         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       1  (?1)       ?          :   ?   :   -;  //       set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;
 
    endtable
endprimitive



primitive U_FD_P_SB_RB_QN (QN, D, CP, RB, SB);
            
    output QN;  
    input  D, CP, RB, SB;
    reg    QN; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( QN OUTPUT UDP )

    table
 
    //  D   CP      RB  SB  :   Qtn :   Qtn+1

        1   (01)    1   1   :   ?   :   0;  // clocked data
        1   (01)    1   x   :   ?   :   0;  // pessimism

        1    ?      1   x   :   0   :   0;  // pessimism

        0    0      1   x   :   0   :   0;  // pessimism
        0    x      1 (?x)  :   0   :   0;  // pessimism
        0    1      1 (?x)  :   0   :   0;  // pessimism

        x    0      1   x   :   0   :   0;  // pessimism
        x    x      1 (?x)  :   0   :   0;  // pessimism
        x    1      1 (?x)  :   0   :   0;  // pessimism


        0   (01)    1   1   :   ?   :   1;  // clocked data
        0   (01)    x   1   :   ?   :   1;  // pessimism

        0    ?      x   1   :   1   :   1;  // pessimism
                          
        1    0      x   1   :   1   :   1;  // pessimism
        1    x    (?x)  1   :   1   :   1;  // pessimism
        1    1    (?x)  1   :   1   :   1;  // pessimism
                          
        x    0      x   1   :   1   :   1;  // pessimism
        x    x    (?x)  1   :   1   :   1;  // pessimism
        x    1    (?x)  1   :   1   :   1;  // pessimism
                                                               
        1   (x1)    1   1   :   0   :   0;  // reducing pessimism
        0   (x1)    1   1   :   1   :   1;                          
        1   (0x)    1   1   :   0   :   0;  
        0   (0x)    1   1   :   1   :   1;  

        ?   ?       0   ?   :   ?   :   1;  // asynchronous clear
        ?   ?       1   0   :   ?   :   0;  // asynchronous set

        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  1   :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?1) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive



primitive U_FD_P_SD  (Q, D, CP, TI, TE);

    output Q;  
    input  D, CP, TI, TE;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH SCAN INPUTS ( Q OUTPUT UDP ) 

  table
 
    //  D   CP      TI  TE  :   Qt  :   Qt+1
                            
        1   (01)    ?   0   :   ?   :   1;  // clocked data
        0   (01)    ?   0   :   ?   :   0;
                            
        1   (x1)    ?   0   :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0   :   0   :   0;                          
        1   (0x)    ?   0   :   1   :   1;  
        0   (0x)    ?   0   :   0   :   0;  
                            
                            
        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore the edges on data
                            
        ?   (01)    0   1   :   ?   :   0;  // scan data
        ?   (01)    1   1   :   ?   :   1;  // scan data  
      
        ?   (x1)    1   1   :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1   :   0   :   0;  // for scan data                        
        ?   (0x)    1   1   :   1   :   1;  
        ?   (0x)    0   1   :   0   :   0;  

        1   (01)    1   x   :   ?   :   1;  // reducing pessimism
        0   (01)    0   x   :   ?   :   0;                      
             
        1   (x1)    1   x   :   1   :   1;  // reducing pessimism
        0   (x1)    0   x   :   0   :   0;                          
        1   (0x)    1   x   :   1   :   1;  
        0   (0x)    0   x   :   0   :   0;  

        ?    ?      *   ?   :   ?   :   -;  // ignore edges      

//added by sp
        ?    ?      ?    *  :   ?   :   -;  // ignore  edge on TE
//end



    endtable
endprimitive

primitive U_FD_P_SD_NO (Q, D, CP, TI, TE, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, TI, TE;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH SCAN INPUTS ( Q OUTPUT UDP ) 


    table
 
    //  D   CP      TI  TE     NOTIFIER_REG  :   Qt  :   Qt+1
                            
        1   (01)    ?   0         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   0         ?          :   ?   :   0;
                            
        1   (x1)    ?   0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0         ?          :   0   :   0;                          
        1   (0x)    ?   0         ?          :   1   :   1;  
        0   (0x)    ?   0         ?          :   0   :   0;  
                            
                            
        ?   (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                            
        ?   (01)    0   1         ?          :   ?   :   0;  // scan data
        ?   (01)    1   1         ?          :   ?   :   1;  // scan data  
      
        ?   (x1)    1   1         ?          :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1         ?          :   0   :   0;  // for scan data                        
        ?   (0x)    1   1         ?          :   1   :   1;  
        ?   (0x)    0   1         ?          :   0   :   0;  

        1   (01)    1   x         ?          :   ?   :   1;  // reducing pessimism
        0   (01)    0   x         ?          :   ?   :   0;                      
             
        1   (x1)    1   x         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0   x         ?          :   0   :   0;                          
        1   (0x)    1   x         ?          :   1   :   1;  
        0   (0x)    0   x         ?          :   0   :   0;  

        ?    ?      *   ?         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?   *          ?          :   ?   :   -; // ignore edges on TE
        ?    ?      ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_P_SD_RB  (Q, D, CP, TI, TE, RB);

    output Q;  
    input  D, CP, TI, TE, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR WITH  SCAN INPUTS ( Q OUTPUT UDP )

    table
 
    //  D   CP      TI  TE  RB  :   Qt  :   Qt+1
                                
        1   (01)    ?   0   1   :   ?   :   1;  // clocked data
        0   (01)    ?   0   1   :   ?   :   0;
                                
        0   (01)    ?   0   x   :   ?   :   0;  // pessimism
                                 
        0    ?      ?   0    x   :   0   :   0;  // pessimism

        1    0      ?   0    x   :   0   :   0;  // pessimism
        1    1      ?   0  (?x)  :   0   :   0;  // pessimism
        1    x      ?   0  (?x)  :   0   :   0;  // pessimism

        x    0      ?   0    x   :   0   :   0;  // pessimism
        x    1      ?   0  (?x)  :   0   :   0;  // pessimism
        x    x      ?   0  (?x)  :   0   :   0;  // pessimism

        ?    ?      0   1    x   :   0   :   0;  // pessimism

        ?    0      1   1    x   :   0   :   0;  // pessimism
        ?    1      1   1  (?x)  :   0   :   0;  // pessimism
        ?    x      1   1  (?x)  :   0   :   0;  // pessimism

        ?    0      x   1    x   :   0   :   0;  // pessimism
        ?    1      x   1  (?x)  :   0   :   0;  // pessimism
        ?    x      x   1  (?x)  :   0   :   0;  // pessimism
                                                                   
        1   (x1)    ?   0   1    :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0   1    :   0   :   0;                          
        1   (0x)    ?   0   1    :   1   :   1;  
        0   (0x)    ?   0   1    :   0   :   0;  
                                
        ?    ?      ?   ?   0   :   ?   :   0;  // asynchronous clear
                                
        ?   (?0)    ?   ?   1   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   1   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?   :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1) :   ?   :   -;  // ignore the edges on clear 

        ?   (01)    0   1   1   :   ?   :   0;  // scan data
        ?   (01)    1   1   1   :   ?   :   1;  // 

        ?   (01)    0   1   x   :   ?   :   0;
        
        ?   (x1)    1   1   1   :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1   1   :   0   :   0;  // for scan data                        
        ?   (0x)    1   1   1   :   1   :   1;  
        ?   (0x)    0   1   1   :   0   :   0;  

        1   (01)    1   x   1   :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1   :   ?   :   0;                      
             
        0   (01)    0   x   x   :   ?   :   0; 

        ?    ?      *   ?   ?   :   ?   :   -;  // ignore edges      
//added by sp
        ?    ?      ?   *   1   :   ?   :   -;  // ignore edges on TE     
//end

    endtable
endprimitive



primitive U_FD_P_SD_RB_NO (Q, D, CP, TI, TE, RB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, TI, TE, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR WITH  SCAN INPUTS ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  RB     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (01)    ?   0   1         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   0   1         ?          :   ?   :   0;
                                
        0   (01)    ?   0   x         ?          :   ?   :   0;  // pessimism
                                
        0    ?      ?   0   x         ?          :   0   :   0;  // pessimism

        1    0      ?   0   x         ?          :   0   :   0;  // pessimism
        1    x      ?   0 (?x)        ?          :   0   :   0;  // pessimism
        1    1      ?   0 (?x)        ?          :   0   :   0;  // pessimism

        x    0      ?   0   x         ?          :   0   :   0;  // pessimism
        x    x      ?   0 (?x)        ?          :   0   :   0;  // pessimism
        x    1      ?   0 (?x)        ?          :   0   :   0;  // pessimism

        ?    ?      0   1   x         ?          :   0   :   0;  // pessimism
                     
        ?    0      1   1   x         ?          :   0   :   0;  // pessimism
        ?    x      1   1 (?x)        ?          :   0   :   0;  // pessimism
        ?    1      1   1 (?x)        ?          :   0   :   0;  // pessimism

        ?    ?      ?   x (?x)        ?          :   0   :   0;  // AB
                     
        ?    0      x   1   x         ?          :   0   :   0;  // pessimism
        ?    x      x   1 (?x)        ?          :   0   :   0;  // pessimism
        ?    1      x   1 (?x)        ?          :   0   :   0;  // pessimism
                                                                   
        1   (x1)    ?   0   1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0   1         ?          :   0   :   0;                          
        1   (0x)    ?   0   1         ?          :   1   :   1;  
        0   (0x)    ?   0   1         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0         ?          :   ?   :   0;  // asynchronous clear
                                
        ?   (?0)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)       ?          :   ?   :   -;  // ignore the edges on clear 

        ?   (01)    0   1   1         ?          :   ?   :   0;  // scan data
        ?   (01)    1   1   1         ?          :   ?   :   1;  // 

        ?   (01)    0   1   x         ?          :   ?   :   0;
        
        ?   (x1)    1   1   1         ?          :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1   1         ?          :   0   :   0;  // for scan data                        
        ?   (0x)    1   1   1         ?          :   1   :   1;  
        ?   (0x)    0   1   1         ?          :   0   :   0;  

        1   (01)    1   x   1         ?          :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1         ?          :   ?   :   0;                      
        0   (0x)    0   x   1         ?          :   0   :   0; //AB
        0   (x1)    0   x   1         ?          :   0   :   0; //AB    

        1   (0x)    1   x   1         ?          :   1   :   1; //AB
        1   (x1)    1   x   1         ?          :   1   :   1; //AB   
             
        0   (01)    0   x   x         ?          :   ?   :   0; 
        0   (0x)    0   x   x         ?          :   0   :   0; //AB
        0   (x1)    0   x   x         ?          :   0   :   0; //AB

        ?    ?      *   ?   ?         ?          :   ?   :   -;  // ignore edges      
//added by sp
        ?    ?      ?   *   1         ?          :   ?   :   -;  // ignore edges on TE
//end     
        ?    ?      ?   ?   1         *          :   ?   :   x;  

    endtable
endprimitive


primitive U_FD_P_SD_RB_SB  (Q, D, CP, TI, TE, RB, SB);

    output Q;  
    input  D, CP, TI, TE, RB, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR WITH scan inputs  ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  RB   SB       :   Qt  :   Qt+1
                                
        1   (01)    ?   0   1    1        :   ?   :   1;  // clocked data
        0   (01)    ?   0   1    1        :   ?   :   0;
                                
        0   (01)    ?   0   x    1        :   ?   :   0;  // pessimism
        1   (01)    ?   0   1    x        :   ?   :   1;  // pessimism
                        
        ?    ?      ?   ?   x    1        :   0   :   0;  // pessimism
        ?    ?      ?   ?   1    x        :   1   :   1;  // pessimism
                                                           
        1   (x1)    ?   0   1    1        :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0   1    1        :   0   :   0;                          
        1   (0x)    ?   0   1    1        :   1   :   1;  
        0   (0x)    ?   0   1    1        :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0    ?        :   ?   :   0;  // asynchronous clear and clear override
        ?    ?      ?   ?   1    0        :   ?   :   1;  // asynchronous set
                        
        ?   (?0)    ?   ?   1    1        :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   1    1        :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?    ?        :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)  1        :   ?   :   -;  // ignore the edges on clear 
        ?    ?      ?   ?   1   (?1)      :   ?   :   -;  // ignore the edges on set 

        ?   (01)    0   1   1    1        :   ?   :   0;  // scan data
        ?   (01)    1   1   1    1        :   ?   :   1;  // 

        ?   (01)    0   1   x    1        :   ?   :   0;
        ?   (01)    1   1   1    x        :   ?   :   1;

        ?   (x1)    1   1   1    1        :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1   1    1        :   0   :   0;  // for scan data                        
        ?   (0x)    1   1   1    1        :   1   :   1;  
        ?   (0x)    0   1   1    1        :   0   :   0;  

        1   (01)    1   x   1    1        :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1    1        :   ?   :   0;                      

        1   (01)    1   x   1    x        :   ?   :   1; // reducing pessimism
        0   (01)    0   x   x    1        :   ?   :   0; 

        ?    ?      *   ?   ?    ?        :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   1    1        :   ?   :   -;  // ignore edges      

    endtable
endprimitive



primitive U_FD_P_SD_R_NO (Q, D, CP, TI, TE, R, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, TI, TE, R;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS CLEAR WITH  SCAN INPUTS ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  R     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (01)    ?   0   0         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   0   0         ?          :   ?   :   0;
                                
        0   (01)    ?   0   x         ?          :   ?   :   0;  // pessimism
                                
        0    ?      ?   0   x         ?          :   0   :   0;  // pessimism

        1    0      ?   0   x         ?          :   0   :   0;  // pessimism
        1    x      ?   0 (?x)        ?          :   0   :   0;  // pessimism
        1    1      ?   0 (?x)        ?          :   0   :   0;  // pessimism

        x    0      ?   0   x         ?          :   0   :   0;  // pessimism
        x    x      ?   0 (?x)        ?          :   0   :   0;  // pessimism
        x    1      ?   0 (?x)        ?          :   0   :   0;  // pessimism

        ?    ?      0   1   x         ?          :   0   :   0;  // pessimism
                     
        ?    0      1   1   x         ?          :   0   :   0;  // pessimism
        ?    x      1   1 (?x)        ?          :   0   :   0;  // pessimism
        ?    1      1   1 (?x)        ?          :   0   :   0;  // pessimism
     
        ?    ?      ?   x (?x)        ?          :   0   :   0;  // AB
                     
        ?    0      x   1   x         ?          :   0   :   0;  // pessimism
        ?    x      x   1 (?x)        ?          :   0   :   0;  // pessimism
        ?    1      x   1 (?x)        ?          :   0   :   0;  // pessimism
                                                                   
        1   (x1)    ?   0   0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0   0         ?          :   0   :   0;                          
        1   (0x)    ?   0   0         ?          :   1   :   1;  
        0   (0x)    ?   0   0         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   1        ?          :   ?   :   0;  // asynchronous clear
                                
        ?   (?0)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?0)       ?          :   ?   :   -;  // ignore the edges on clear 

        ?   (01)    0   1   0         ?          :   ?   :   0;  // scan data
        ?   (01)    1   1   0         ?          :   ?   :   1;  // 

        ?   (01)    0   1   x         ?          :   ?   :   0;
        
        ?   (x1)    1   1   0         ?          :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1   0         ?          :   0   :   0;  // for scan data                        
        ?   (0x)    1   1   0         ?          :   1   :   1;  
        ?   (0x)    0   1   0         ?          :   0   :   0;  

        1   (01)    1   x   0         ?          :   ?   :   1; // reducing pessimism
        0   (01)    0   x   0         ?          :   ?   :   0;                              
        0   (0x)    0   x   0         ?          :   0   :   0; //AB
        0   (x1)    0   x   0         ?          :   0   :   0; //AB    

        1   (0x)    1   x   0         ?          :   1   :   1; //AB
        1   (x1)    1   x   0         ?          :   1   :   1; //AB   
             
        0   (01)    0   x   x         ?          :   ?   :   0; 
        0   (0x)    0   x   x         ?          :   0   :   0; //AB
        0   (x1)    0   x   x         ?          :   0   :   0; //AB

             
        ?    ?      *   ?   ?         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   ?         ?          :   ?   :   -;  // ignore edges on TE
        ?    ?      ?   ?   ?         *          :   ?   :   x;  

    endtable
endprimitive


primitive U_FD_P_SD_SB  (Q, D, CP, TI, TE, SB);

    output Q;  
    input  D, CP, TI, TE, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET WITH  scan inputs ( Q OUTPUT UDP )

    table
 
    //  D   CP      TI  TE  SB  :   Qt  :   Qt+1
                                
        1   (01)    ?   0   1   :   ?   :   1;  // clocked data
        0   (01)    ?   0   1   :   ?   :   0;
                                
        1   (01)    ?   1   x   :   ?   :   1;  // pessimism
                                
        ?    ?      ?   ?   x   :   1   :   1;  // pessimism
                                                                   
        1   (x1)    ?   0   1   :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0   1   :   0   :   0;                          
        1   (0x)    ?   0   1   :   1   :   1;  
        0   (0x)    ?   0   1   :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0   :   ?   :   1;  // asynchronous set
                                
        ?   (?0)    ?   ?   1   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   1   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?   :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1) :   ?   :   -;  // ignore the edges on set 

        ?   (01)    0   1   1   :   ?   :   0;  // scan data
        ?   (01)    1   1   1   :   ?   :   1;  // 

        ?   (01)    1   1   x   :   ?   :   1;
        
        ?   (x1)    1   1   1   :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1   1   :   0   :   0;  // for scan data                        
        ?   (0x)    1   1   1   :   1   :   1;  
        ?   (0x)    0   1   1   :   0   :   0;  

        1   (01)    1   x   1   :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1   :   ?   :   0;                      
             
        1   (01)    1   x   x   :   ?   :   1; 

        ?    ?      *   ?   ?   :   ?   :   -;  // ignore edges      
//added by sp
        ?    ?      ?   *   1   :   ?   :   -;  // ignore edges on TE
//end     

    endtable
endprimitive



primitive U_FD_P_SD_SB_NO (Q, D, CP, TI, TE, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, TI, TE, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET WITH  scan inputs ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  SB     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (01)    ?   0   1         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   0   1         ?          :   ?   :   0;
                                
        1   (01)    ?   1   x         ?          :   ?   :   1;  // pessimism
                                
        1    ?      ?   0   x         ?          :   1   :   1;  // pessimism

        0    0      ?   0   x         ?          :   1   :   1;  // pessimism
        0    x      ?   0 (?x)        ?          :   1   :   1;  // pessimism
        0    1      ?   0 (?x)        ?          :   1   :   1;  // pessimism

        x    0      ?   0   x         ?          :   1   :   1;  // pessimism
        x    x      ?   0 (?x)        ?          :   1   :   1;  // pessimism
        x    1      ?   0 (?x)        ?          :   1   :   1;  // pessimism

        ?    ?      1   1   x         ?          :   1   :   1;  // pessimism
                     
        ?    0      0   1   x         ?          :   1   :   1;  // pessimism
        ?    x      0   1 (?x)        ?          :   1   :   1;  // pessimism
        ?    1      0   1 (?x)        ?          :   1   :   1;  // pessimism
                     
        ?    0      x   1   x         ?          :   1   :   1;  // pessimism
        ?    x      x   1 (?x)        ?          :   1   :   1;  // pessimism
        ?    1      x   1 (?x)        ?          :   1   :   1;  // pessimism

        ?    ?      ?   x (?x)        ?          :   1   :   1;  // AB
                                                                      
        1   (x1)    ?   0   1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0   1         ?          :   0   :   0;                          
        1   (0x)    ?   0   1         ?          :   1   :   1;  
        0   (0x)    ?   0   1         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   0         ?          :   ?   :   1;  // asynchronous set
                                
        ?   (?0)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?1)       ?          :   ?   :   -;  // ignore the edges on set 

        ?   (01)    0   1   1         ?          :   ?   :   0;  // scan data
        ?   (01)    1   1   1         ?          :   ?   :   1;  // 

        ?   (01)    1   1   x         ?          :   ?   :   1;
        
        ?   (x1)    1   1   1         ?          :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1   1         ?          :   0   :   0;  // for scan data                        
        ?   (0x)    1   1   1         ?          :   1   :   1;  
        ?   (0x)    0   1   1         ?          :   0   :   0;  

        1   (01)    1   x   1         ?          :   ?   :   1; // reducing pessimism
        0   (01)    0   x   1         ?          :   ?   :   0;                      
             
        0   (0x)    0   x   1         ?          :   0   :   0; //AB
        0   (x1)    0   x   1         ?          :   0   :   0; //AB    

        1   (0x)    1   x   1         ?          :   1   :   1; //AB
        1   (x1)    1   x   1         ?          :   1   :   1; //AB   
             
        1   (01)    1   x   x         ?          :   ?   :   1; 
        1   (0x)    1   x   x         ?          :   1   :   1; //AB
        1   (x1)    1   x   x         ?          :   1   :   1; //AB

        ?    ?      *   ?   ?         ?          :   ?   :   -;  // ignore edges      
//added by sp
        ?    ?      ?   *   1         ?          :   ?   :   -;  // ignore edges on TE
//end     
        ?    ?      ?   ?   1         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_P_SD_S_NO (Q, D, CP, TI, TE, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, TI, TE, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET WITH  scan inputs ( Q OUTPUT UDP )


    table
 
    //  D   CP      TI  TE  SB     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (01)    ?   0   0         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   0   0         ?          :   ?   :   0;
                                
        1   (01)    ?   1   x         ?          :   ?   :   1;  // pessimism
                                
        1    ?      ?   0   x         ?          :   1   :   1;  // pessimism

        0    0      ?   0   x         ?          :   1   :   1;  // pessimism
        0    x      ?   0 (?x)        ?          :   1   :   1;  // pessimism
        0    1      ?   0 (?x)        ?          :   1   :   1;  // pessimism

        x    0      ?   0   x         ?          :   1   :   1;  // pessimism
        x    x      ?   0 (?x)        ?          :   1   :   1;  // pessimism
        x    1      ?   0 (?x)        ?          :   1   :   1;  // pessimism

        ?    ?      1   1   x         ?          :   1   :   1;  // pessimism
                     
        ?    0      0   1   x         ?          :   1   :   1;  // pessimism
        ?    x      0   1 (?x)        ?          :   1   :   1;  // pessimism
        ?    1      0   1 (?x)        ?          :   1   :   1;  // pessimism
                     
        ?    0      x   1   x         ?          :   1   :   1;  // pessimism
        ?    x      x   1 (?x)        ?          :   1   :   1;  // pessimism
        ?    1      x   1 (?x)        ?          :   1   :   1;  // pessimism
  
        ?    ?      ?   x (?x)        ?          :   1   :   1;  // AB
                                                                      
        1   (x1)    ?   0   0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   0   0         ?          :   0   :   0;                          
        1   (0x)    ?   0   0         ?          :   1   :   1;  
        0   (0x)    ?   0   0         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   1         ?          :   ?   :   1;  // asynchronous set
                                
        ?   (?0)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   ?  (?0)       ?          :   ?   :   -;  // ignore the edges on set 

        ?   (01)    0   1   0         ?          :   ?   :   0;  // scan data
        ?   (01)    1   1   0         ?          :   ?   :   1;  // 

        ?   (01)    1   1   x         ?          :   ?   :   1;
        
        ?   (x1)    1   1   0         ?          :   1   :   1;  // reducing pessimism
        ?   (x1)    0   1   0         ?          :   0   :   0;  // for scan data                        
        ?   (0x)    1   1   0         ?          :   1   :   1;  
        ?   (0x)    0   1   0         ?          :   0   :   0;  

        1   (01)    1   x   0         ?          :   ?   :   1; // reducing pessimism
        0   (01)    0   x   0         ?          :   ?   :   0;                      
             
        0   (0x)    0   x   0         ?          :   0   :   0; //AB
        0   (x1)    0   x   0         ?          :   0   :   0; //AB    

        1   (0x)    1   x   0         ?          :   1   :   1; //AB
        1   (x1)    1   x   0         ?          :   1   :   1; //AB   
             
        1   (01)    1   x   x         ?          :   ?   :   1; 
        1   (0x)    1   x   x         ?          :   1   :   1; //AB
        1   (x1)    1   x   x         ?          :   1   :   1; //AB

        ?    ?      *   ?   ?         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?   *   ?         ?          :   ?   :   -;  // ignore edges on TE
        ?    ?      ?   ?   ?         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_P_S_NO (Q, D, CP, S, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, S;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET ( Q OUTPUT UDP )


    table
 
    //  D   CP      S     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    0         ?          :   ?   :   1;  // clocked data
        0   (01)    0         ?          :   ?   :   0;
        1   (01)    x         ?          :   ?   :   1;  // reducing pessimism
        1    ?      x         ?          :   1   :   1;  // pessimism

        0    0      x         ?          :   1   :   1;  // pessimism
        0    x    (?x)        ?          :   1   :   1;  // pessimism
        0    1    (?x)        ?          :   1   :   1;  // pessimism

        x    0      x         ?          :   1   :   1;  // pessimism
        x    x    (?x)        ?          :   1   :   1;  // pessimism
        x    1    (?x)        ?          :   1   :   1;  // pessimism

        1   (x1)    0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0         ?          :   0   :   0;                          
        1   (0x)    0         ?          :   1   :   1;  
        0   (0x)    0         ?          :   0   :   0;  

        ?    ?      1         ?          :   ?   :   1;  // asynchronous clear

        ?   (?0)    ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?         ?          :   ?   :   -;  // ignore the data edges

        ?   ?     (?0)        ?          :   ?   :   -;  // ignore the edges on set
        
        ?   ?       ?         *          :   ?   :   x;

    endtable
endprimitive



primitive U_FD_P_S_PLD  (Q, D, CP, PD, PLD, S);

    output Q;  
    input  D, CP, PD, PLD, S;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIp-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND PARALLEL LOAD ( Q OUTPUT UDP )

    table
 
    //  D   CP      PD PLD  S  :   Qt  :   Qt+1
                                
        1   (01)    ?   1   0   :   ?   :   1;  // clocked data
        0   (01)    ?   1   0   :   ?   :   0;
                                
        1   (01)    ?   1   x   :   ?   :   1;  // pessimism
                                

        1    ?      ?   1   x   :   1   :   1;  // pessimism
                             
        0    0      ?   1   x   :   1   :   1;  // pessimism
        0    x      ?   1 (?x)  :   1   :   1;  // pessimism
        0    1      ?   1 (?x)  :   1   :   1;  // pessimism
                             
        x    0      ?   1   x   :   1   :   1;  // pessimism
        x    x      ?   1 (?x)  :   1   :   1;  // pessimism
        x    1      ?   1 (?x)  :   1   :   1;  // pessimism
                                                                      
        1   (x1)    ?   1   0   :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1   0   :   0   :   0;                          
        1   (0x)    ?   1   0   :   1   :   1;  
        0   (0x)    ?   1   0   :   0   :   0;  
                                
                                
        ?    ?      ?   ?   1   :   ?   :   1;  // asynchronous set
                                
        ?   (?0)    ?   ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?   :   ?   :   -;  // ignore the edges on data
                                
        ?    ?      ?   1  (?0) :   ?   :   -;  // ignore the edges on SET   

        ?    ?      0   0   0   :   ?   :   0;  // load parallel data
        ?    ?      1   0   0   :   ?   :   1;  // load parallel data
        1   (01)    1   x   0   :   ?   :   1;  // reducing pessimism
        0   (01)    0   x   0   :   ?   :   0;                      
             
        ?    ?      1   x   0   :   1   :   1;  // reducing pessimism
        ?    ?      0   x   0   :   0   :   0;    

        ?    ?      1   x   x   :   1   :   1;
        1   (01)    1   x   x   :   ?   :   1;



        ?    ?      *   ?   ?   :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1) 0   :   ?   :   -;  // ignore edges      

    endtable
endprimitive

primitive U_FD_P_S_PLD_NO  (Q, D, CP, PD, PLD, S, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, PD, PLD, S;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIp-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND PARALLEL LOAD ( Q OUTPUT UDP )


    table
 
    //  D   CP      PD PLD  S     NOTIFIER_REG  :   Qt  :   Qt+1
                                
        1   (01)    ?   1   0         ?          :   ?   :   1;  // clocked data
        0   (01)    ?   1   0         ?          :   ?   :   0;
                                
        1   (01)    ?   1   x         ?          :   ?   :   1;  // pessimism
                                

        1    ?      ?   1   x         ?          :   1   :   1;  // pessimism
                 
        0    0      ?   1   x         ?          :   1   :   1;  // pessimism
        0    x      ?   1 (?x)        ?          :   1   :   1;  // pessimism
        0    1      ?   1 (?x)        ?          :   1   :   1;  // pessimism
               
        x    0      ?   1   x         ?          :   1   :   1;  // pessimism
        x    x      ?   1 (?x)        ?          :   1   :   1;  // pessimism
        x    1      ?   1 (?x)        ?          :   1   :   1;  // pessimism
                                                                   
        1   (x1)    ?   1   0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    ?   1   0         ?          :   0   :   0;                          
        1   (0x)    ?   1   0         ?          :   1   :   1;  
        0   (0x)    ?   1   0         ?          :   0   :   0;  
                                
                                
        ?    ?      ?   ?   1         ?          :   ?   :   1;  // asynchronous clear
                                
        ?   (?0)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   ?         ?          :   ?   :   -;  // ignore the edges on data

        ?    ?     (?0) 0   0         ?          :   ?   :   0;  // load parallel data
        ?    ?     (?1) 0   0         ?          :   ?   :   1;  // load parallel data

        ?    ?      0  (?0) 0         ?          :   ?   :   0;  // load parallel data
        ?    ?      1  (?0) 0         ?          :   ?   :   1;  // load parallel data

        1   (01)    1   x   0         ?          :   ?   :   1; // reducing pessimism
        0   (01)    0   x   0         ?          :   ?   :   0;                      
             
        ?    ?      1  (?x) 0         ?          :   1   :   1; // reducing pessimism
        ?    ?      0  (?x) 0         ?          :   0   :   0;   

        ?    ?    (?1)  x   0         ?          :   1   :   1; // reducing pessimism
        ?    ?    (?0)  x   0         ?          :   0   :   0;   

        1    r      1   x   x         ?          :   ?   :   1;
        ?    ?      1  (?x) x         ?          :   1   :   1;
        ?    ?      1   x  (?x)       ?          :   1   :   1;
        ?    ?    (?1)  x   x         ?          :   1   :   1;
     
        ?    ?      ?   1  (?0)       ?          :   ?   :   -;  // ignore the edges on clear 
        ?    ?      0   0  (?0)       ?          :   ?   :   0;
        ?    ?      1   0  (?0)       ?          :   ?   :   1;

        ?    ?      *   1   0         ?          :   ?   :   -;  // ignore edges      
        ?    ?      ?  (?1) 0         ?          :   ?   :   -;  // ignore edges      
        
        ?    ?      ?   ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_P_S_R (Q, D, CP, R, S);

    output Q;  
    input  D, CP, R, S;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP )
    
     table
 
    //  D   CP      R   S   :   Qt  :   Qt+1

        1   (01)    0   0   :   ?   :   1;  // clocked data
        1   (01)    0   x   :   ?   :   1;  // pessimism

        1    ?      0   x   :   1   :   1;  // pessimism

        0    0      0   x   :   1   :   1;  // pessimism
        0    x      0 (?x)  :   1   :   1;  // pessimism
        0    1      0 (?x)  :   1   :   1;  // pessimism

        x    0      0   x   :   1   :   1;  // pessimism
        x    x      0 (?x)  :   1   :   1;  // pessimism
        x    1      0 (?x)  :   1   :   1;  // pessimism

        0   (01)    0   0   :   ?   :   0;  // clocked data
        0   (01)    x   0   :   ?   :   0;  // pessimism

        0    ?      x   0   :   0   :   0;  // pessimism

        1    0      x   0   :   0   :   0;  // pessimism
        1    x    (?x)  0   :   0   :   0;  // pessimism
        1    1    (?x)  0   :   0   :   0;  // pessimism

        x    0      x   0   :   0   :   0;  // pessimism
        x    x    (?x)  0   :   0   :   0;  // pessimism
        x    1    (?x)  0   :   0   :   0;  // pessimism
                                                              
        1   (x1)    0   0   :   1   :   1;  // reducing pessimism
        0   (x1)    0   0   :   0   :   0;                          
        1   (0x)    0   0   :   1   :   1;  
        0   (0x)    0   0   :   0   :   0;  

        ?   ?       1   0   :   ?   :   0;  // asynchronous clear
        ?   ?       ?   1   :   ?   :   1;  // asynchronous set

        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  ?   :   ?   :   -;  // ignore the edges on 
        ?   ?       0  (?0) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive
primitive U_FD_P_S_R_NO (Q, D, CP, R, S, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP )
        

     table
 
    //  D   CP      R   S      NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    0   0         ?          :   ?   :   1;  // clocked data
        1   (01)    0   x         ?          :   ?   :   1;  // pessimism

        1    ?      0   x         ?          :   1   :   1;  // pessimism

        0    0      0   x         ?          :   1   :   1;  // pessimism
        0    x      0 (?x)        ?          :   1   :   1;  // pessimism
        0    1      0 (?x)        ?          :   1   :   1;  // pessimism

        x    0      0   x         ?          :   1   :   1;  // pessimism
        x    x      0 (?x)        ?          :   1   :   1;  // pessimism
        x    1      0 (?x)        ?          :   1   :   1;  // pessimism

        0   (01)    0   0         ?          :   ?   :   0;  // clocked data
        0   (01)    x   0         ?          :   ?   :   0;  // pessimism

        0    ?      x   0         ?          :   0   :   0;  // pessimism

        1    0      x   0         ?          :   0   :   0;  // pessimism
        1    x    (?x)  0         ?          :   0   :   0;  // pessimism
        1    1    (?x)  0         ?          :   0   :   0;  // pessimism

        x    0      x   0         ?          :   0   :   0;  // pessimism
        x    x    (?x)  0         ?          :   0   :   0;  // pessimism
        x    1    (?x)  0         ?          :   0   :   0;  // pessimism
                                                           
        1   (x1)    0   0         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    0   0         ?          :   0   :   0;                          
        1   (0x)    0   0         ?          :   1   :   1;  
        0   (0x)    0   0         ?          :   0   :   0;  

        ?   ?       1   0         ?          :   ?   :   0;  // asynchronous clear
        ?   ?       ?   1         ?          :   ?   :   1;  // asynchronous set

        ?   (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  ?         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       0  (?0)       ?          :   ?   :   -;  //       set and clear                  
         
        ?   ?       ?   ?         *          :   ?   :   x; 

    endtable
endprimitive
primitive U_FD_P_S_R_NO_QN (QN, D, CP, R, S, NOTIFIER_REG); 

    output QN;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    QN; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP )
        

     table
 
    //  D   CP      R   S      NOTIFIER_REG  :   Qtn :   Qtn+1

        1   (01)    0   0         ?          :   ?   :   0;  // clocked data
        1   (01)    0   x         ?          :   ?   :   0;  // pessimism

        1    ?      0   x         ?          :   0   :   0;  // pessimism

        0    0      0   x         ?          :   0   :   0;  // pessimism
        0    x      0 (?x)        ?          :   0   :   0;  // pessimism
        0    1      0 (?x)        ?          :   0   :   0;  // pessimism

        x    0      0   x         ?          :   0   :   0;  // pessimism
        x    x      0 (?x)        ?          :   0   :   0;  // pessimism
        x    1      0 (?x)        ?          :   0   :   0;  // pessimism


        0   (01)    0   0         ?          :   ?   :   1;  // clocked data
        0   (01)    x   0         ?          :   ?   :   1;  // pessimism

        0    ?      x   0         ?          :   1   :   1;  // pessimism

        1    0      x   0         ?          :   1   :   1;  // pessimism
        1    x    (?x)  0         ?          :   1   :   1;  // pessimism
        1    1    (?x)  0         ?          :   1   :   1;  // pessimism

        x    0      x   0         ?          :   1   :   1;  // pessimism
        x    x    (?x)  0         ?          :   1   :   1;  // pessimism
        x    1    (?x)  0         ?          :   1   :   1;  // pessimism
                                                            
        1   (x1)    0   0         ?          :   0   :   0;  // reducing pessimism
        0   (x1)    0   0         ?          :   1   :   1;                          
        1   (0x)    0   0         ?          :   0   :   0;  
        0   (0x)    0   0         ?          :   1   :   1;  

        ?   ?       1   ?         ?          :   ?   :   1;  // asynchronous clear
        ?   ?       0   1         ?          :   ?   :   0;  // asynchronous set

        ?   (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  0         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?0)       ?          :   ?   :   -;  //       set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_P_S_R_QN (QN, D, CP, R, S);

    output QN;  
    input  D, CP, R, S;
    reg    QN; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP )
    
     table
 
    //  D   CP      R   S   :   Qtn :   Qtn+1

        1   (01)    0   0   :   ?   :   0;  // clocked data
        1   (01)    0   x   :   ?   :   0;  // pessimism

        1    ?      0   x   :   0   :   0;  // pessimism

        0    0      0   x   :   0   :   0;  // pessimism
        0    x      0 (?x)  :   0   :   0;  // pessimism
        0    1      0 (?x)  :   0   :   0;  // pessimism

        x    0      0   x   :   0   :   0;  // pessimism
        x    x      0 (?x)  :   0   :   0;  // pessimism
        x    1      0 (?x)  :   0   :   0;  // pessimism


        0   (01)    0   0   :   ?   :   1;  // clocked data
        0   (01)    x   0   :   ?   :   1;  // pessimism

        0    ?      x   0   :   1   :   1;  // pessimism
                         
        1    0      x   0   :   1   :   1;  // pessimism
        1    x    (?x)  0   :   1   :   1;  // pessimism
        1    1    (?x)  0   :   1   :   1;  // pessimism
                         
        x    0      x   0   :   1   :   1;  // pessimism
        x    x    (?x)  0   :   1   :   1;  // pessimism
        x    1    (?x)  0   :   1   :   1;  // pessimism
                                                                 
        1   (x1)    0   0   :   0   :   0;  // reducing pessimism
        0   (x1)    0   0   :   1   :   1;                          
        1   (0x)    0   0   :   0   :   0;  
        0   (0x)    0   0   :   1   :   1;  

        ?   ?       1   ?   :   ?   :   1;  // asynchronous clear
        ?   ?       0   1   :   ?   :   0;  // asynchronous set

        ?   (?0)    ?   ?   :   ?   :   -;  // ignore falling clock
        ?   (1x)    ?   ?   :   ?   :   -;  // ignore falling clock
        *    ?      ?   ?   :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  0   :   ?   :   -;  // ignore the edges on 
        ?   ?       ?  (?0) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive

primitive U_FJKB_N_NO (Q, J, K, CP, NOTIFIER_REG); 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP;

// FUNCTION : NEGATIVE EDGE TRIGGERED JK FLIP FLOP

    table
      //    J   K   CP      NOTIFIER_REG  :  Qtn   :   Qtn+1
                       
            0   1  (10)        ?          :   ?    :     - ;      // Output retains the 
                       
            0   0  (10)        ?          :   ?    :     0 ;      // Clocked J and K.
            1   1  (10)        ?          :   ?    :     1 ;    
                       
            1   0  (10)        ?          :   0    :     1 ;      // Clocked toggle.
            1   0  (10)        ?          :   1    :     0 ;
                       
            0   1  (1x)        ?          :   ?    :     - ;      //possible clocked JK
            0   0  (1x)        ?          :   0    :     0 ;   
            1   1  (1x)        ?          :   1    :     1 ;
            0   1  (x0)        ?          :   ?    :     - ;
            0   0  (x0)        ?          :   0    :     0 ;
            1   1  (x0)        ?          :   1    :     1 ;
                       
            *   ?   ?          ?          :   ?    :     - ;      // Insensitive to 
            ?   *   ?          ?          :   ?    :     - ;      // transitions on J and K
                                                 // with steady clock.  
            ?   ? (?1)         ?          :   ?    :     - ;      
            ?   ? (0x)         ?          :   ?    :     - ;                                
                       
                       
            x   1   f          ?          :   1    :     1 ;   // reducing pessimism for unknown J  
            x   0   f          ?          :   1    :     0 ;   // reducing pessimism for unknown J  
            0   x   f          ?          :   0    :     0 ;   // reducing pessimism for unknown K  
            1   x   f          ?          :   0    :     1 ;   // reducing pessimism for unknown K  
                       
            x   1  (1x)        ?          :   1    :     1 ;   //possible clocked with
            0   x  (1x)        ?          :   0    :     0 ;   //possible J & K                                 
            x   1  (x0)        ?          :   1    :     1 ;
            0   x  (x0)        ?          :   0    :     0 ;
            ?   ?   ?          *          :   ?    :     x ;

    endtable

endprimitive

primitive U_FJKB_N_RB_NO (Q, J, K, CP, RB, NOTIFIER_REG); 


    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP,                                  // CLOCK.
           RB;                                  // CLEAR INPUT.

// FUNCTION : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH CLEAR 
//            ACTIVE LOW 

    table
      // J   K   CP   RB     NOTIFIER_REG  :  Qtn : Qtn+1

         0   1  (10)  1         ?          :   ?  :   - ;         // Output retains the 
                                                                  // present state if both 
                                                                  // J and K are 0.
         0   0  (10)  1         ?          :   ?  :   0 ;         // Clocked J and K.
         1   1  (10)  1         ?          :   ?  :   1 ;    

         0   0  (10)  x         ?          :   ?  :   0 ;         // pessimism
         ?   ?   ?    x         ?          :   0  :   0 ;         // pessimism

         1   0  (10)  1         ?          :   0  :   1 ;         // Clocked toggle.
         1   0  (10)  1         ?          :   1  :   0 ;

         ?   0  (10)  x         ?          :   1  :   0 ;         // pessimism

         0   1  (x0)  1         ?          :   ?  :   - ;         //possible clocked JK
         0   0  (x0)  1         ?          :   0  :   0 ;   
         1   1  (x0)  1         ?          :   1  :   1 ;
         0   1  (1x)  1         ?          :   ?  :   - ;
         0   0  (1x)  1         ?          :   0  :   0 ;
         1   1  (1x)  1         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                                  // with steady clock.
         ?   ? (?1)   1         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (0x)   1         ?          :   ?  :   - ;
                                         
         x   1   f    1         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   0   f    1         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   f    1         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   f    1         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   1  (x0)  1         ?          :   1  :   1 ;         //possible clocked with
         0   x  (x0)  1         ?          :   0  :   0 ;         //possible J & K                                 
         x   1  (1x)  1         ?          :   1  :   1 ;
         0   x  (1x)  1         ?          :   0  :   0 ;

         ?   ?   ?    0         ?          :   ?  :   0 ;         // Clear. 

         ?   ?   ?   (?1)       ?          :   ?  :   - ;         // Insensitive to a rising
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on RESET.


    endtable

endprimitive

primitive U_FJKB_N_R_NO (Q, J, K, CP, R, NOTIFIER_REG); 


    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP,                                  // CLOCK.
           R;                                   // CLEAR INPUT.

// FUNCTION : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH CLEAR 
//            ACTIVE HIGH

    table
      // J   K   CP   R      NOTIFIER_REG  :  Qtn : Qtn+1

         0   1  (10)  0         ?          :   ?  :   - ;         // Output retains the 
                                                                  // present state if both 
                                                                  // J and K are 0.
         0   0  (10)  0         ?          :   ?  :   0 ;         // Clocked J and K.
         1   1  (10)  0         ?          :   ?  :   1 ;    

         0   0  (10)  x         ?          :   ?  :   0 ;         // pessimism
         ?   ?   ?    x         ?          :   0  :   0 ;         // pessimism

         1   0  (10)  0         ?          :   0  :   1 ;         // Clocked toggle.
         1   0  (10)  0         ?          :   1  :   0 ;

         ?   0  (10)  x         ?          :   1  :   0 ;         // pessimism

         0   1  (x0)  0         ?          :   ?  :   - ;         //possible clocked JK
         0   0  (x0)  0         ?          :   0  :   0 ;   
         1   1  (x0)  0         ?          :   1  :   1 ;
         0   1  (1x)  0         ?          :   ?  :   - ;
         0   0  (1x)  0         ?          :   0  :   0 ;
         1   1  (1x)  0         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                                  // with steady clock.
         ?   ? (?1)   0         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (0x)   0         ?          :   ?  :   - ;
                                         
         x   1   f    0         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   0   f    0         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   f    0         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   f    0         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   1  (x0)  0         ?          :   1  :   1 ;         //possible clocked with
         0   x  (x0)  0         ?          :   0  :   0 ;         //possible J & K                                 
         x   1  (1x)  0         ?          :   1  :   1 ;
         0   x  (1x)  0         ?          :   0  :   0 ;

         ?   ?   ?    1         ?          :   ?  :   0 ;         // Clear. 

         ?   ?   ?   (?0)       ?          :   ?  :   - ;         // insensitive to a falling
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on RESET.


    endtable

endprimitive

primitive U_FJKB_N_SB_NO (Q, J, K, CP, SB, NOTIFIER_REG); 
 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP,                                  // CLOCK.
           SB;                                  // SET INPUT.

// FUNCTION : NEGATIVE EDGE TRIGGERED J K FLIP FLOP, WITH
//            ASYNCHRONOUS ACTIVE LOW SET

    table
      // J   K   CP   SB     NOTIFIER_REG  :  Qtn : Qtn+1

         0   1  (10)  1         ?          :   ?  :   - ;         // Output retains the 
                                                                  // present state if both 
                                                                  // J and K are 0.

         0   0  (10)  1         ?          :   ?  :   0 ;         // Clocked J and K.
         1   1  (10)  1         ?          :   ?  :   1 ;    

         1   1  (10)  x         ?          :   ?  :   1 ;         // pessimism
         ?   ?   ?    x         ?          :   1  :   1 ;         // pessimism

         1   0  (10)  1         ?          :   0  :   1 ;         // Clocked toggle.
         1   0  (10)  1         ?          :   1  :   0 ;

         1   ?  (10)  x         ?          :   0  :   1 ;         // pessimism

         0   1  (x0)  1         ?          :   ?  :   - ;         //possible clocked JK
         0   0  (x0)  1         ?          :   0  :   0 ;   
         1   1  (x0)  1         ?          :   1  :   1 ;
         0   1  (1x)  1         ?          :   ?  :   - ;
         0   0  (1x)  1         ?          :   0  :   0 ;
         1   1  (1x)  1         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                                  // with steady clock.
         ?   ? (?1)   1         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (0x)   1         ?          :   ?  :   - ;
                                         
         x   1   f    1         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   0   f    1         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   f    1         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   f    1         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   1  (x0)  1         ?          :   1  :   1 ;         //possible clocked with
         0   x  (x0)  1         ?          :   0  :   0 ;         //possible J & K                                 
         x   1  (1x)  1         ?          :   1  :   1 ;
         0   x  (1x)  1         ?          :   0  :   0 ;

         ?   ?   ?    0         ?          :   ?  :   1 ;         // SET. 

         ?   ?   ?   (?1)       ?          :   ?  :   - ;         // Insensitive to a rising 
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on SET .


    endtable

endprimitive

primitive U_FJKB_N_S_NO (Q, J, K, CP, S, NOTIFIER_REG); 
 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP,                                  // CLOCK.
           S;                                   // SET INPUT.

// FUNCTION : NEGATIVE EDGE TRIGGERED J K FLIP FLOP, WITH
//            ASYNCHRONOUS ACTIVE HIGH SET

    table
      // J   K   CP   S      NOTIFIER_REG  :  Qtn : Qtn+1

         0   1  (10)  0         ?          :   ?  :   - ;         // Output retains the 
                                                                  // present state if both 
                                                                  // J and K are 0.

         0   0  (10)  0         ?          :   ?  :   0 ;         // Clocked J and K.
         1   1  (10)  0         ?          :   ?  :   1 ;    

         1   1  (10)  x         ?          :   ?  :   1 ;         // pessimism
         ?   ?   ?    x         ?          :   1  :   1 ;         // pessimism

         1   0  (10)  0         ?          :   0  :   1 ;         // Clocked toggle.
         1   0  (10)  0         ?          :   1  :   0 ;

         1   ?  (10)  x         ?          :   0  :   1 ;         // pessimism

         0   1  (x0)  0         ?          :   ?  :   - ;         //possible clocked JK
         0   0  (x0)  0         ?          :   0  :   0 ;   
         1   1  (x0)  0         ?          :   1  :   1 ;
         0   1  (1x)  0         ?          :   ?  :   - ;
         0   0  (1x)  0         ?          :   0  :   0 ;
         1   1  (1x)  0         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                                  // with steady clock.
         ?   ? (?1)   0         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (0x)   0         ?          :   ?  :   - ;
                                         
         x   1   f    0         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   0   f    0         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   f    0         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   f    0         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   1  (x0)  0         ?          :   1  :   1 ;         //possible clocked with
         0   x  (x0)  0         ?          :   0  :   0 ;         //possible J & K                                 
         x   1  (1x)  0         ?          :   1  :   1 ;
         0   x  (1x)  0         ?          :   0  :   0 ;

         ?   ?   ?    1         ?          :   ?  :   1 ;         // SET. 

         ?   ?   ?   (?0)       ?          :   ?  :   - ;         // insensitive to a falling
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on SET .


    endtable

endprimitive

primitive U_FJKB_P_NO (Q, J, K, CP, NOTIFIER_REG); 
 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP;

// FUNCTION : POSITIVE EDGE TRIGGERED JK_ FLIP FLOP

    table
      //    J   K   CP      NOTIFIER_REG  :  Qtn   :   Qtn+1

            0   1  (01)        ?          :   ?    :     - ;      // Output retains the 

            0   0  (01)        ?          :   ?    :     0 ;      // Clocked J and K.
            1   1  (01)        ?          :   ?    :     1 ;    

            1   0  (01)        ?          :   0    :     1 ;      // Clocked toggle.
            1   0  (01)        ?          :   1    :     0 ;

            0   1  (x1)        ?          :   ?    :     - ;      //possible clocked JK
            0   0  (x1)        ?          :   0    :     0 ;   
            1   1  (x1)        ?          :   1    :     1 ;
            0   1  (0x)        ?          :   ?    :     - ;
            0   0  (0x)        ?          :   0    :     0 ;
            1   1  (0x)        ?          :   1    :     1 ;

            *   ?   ?          ?          :   ?    :     - ;      // Insensitive to 
            ?   *   ?          ?          :   ?    :     - ;      // transitions on J and K
                                                 // with steady clock.  
            ?   ? (?0)         ?          :   ?    :     - ;      //ignore falling clock.  
            ?   ? (1x)         ?          :   ?    :     - ;                                


            x   1   r          ?          :   1    :     1 ;   // reducing pessimism for unknown J  
            x   0   r          ?          :   1    :     0 ;   // reducing pessimism for unknown J  
            0   x   r          ?          :   0    :     0 ;   // reducing pessimism for unknown K  
            1   x   r          ?          :   0    :     1 ;   // reducing pessimism for unknown K  
    
            x   1  (x1)        ?          :   1    :     1 ;   //possible clocked with
            0   x  (x1)        ?          :   0    :     0 ;   //possible J & K                                 
            x   1  (0x)        ?          :   1    :     1 ;
            0   x  (0x)        ?          :   0    :     0 ;
            ?   ?   ?          *          :   ?    :     x ;

    endtable

endprimitive

primitive U_FJKB_P_RB_NO (Q, J, K, CP, RB, NOTIFIER_REG); 


    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP,                                  // CLOCK.
           RB;                                  // CLEAR INPUT.

// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH CLEAR 
//            ACTIVE LOW 

    table
      // J   K   CP   RB     NOTIFIER_REG  :  Qtn : Qtn+1

         0   1  (01)  1         ?          :   ?  :   - ;         // Output retains the 
                                                                  // present state if both 
                                                                  // J and K are 0.
         0   0  (01)  1         ?          :   ?  :   0 ;         // Clocked J and K.
         1   1  (01)  1         ?          :   ?  :   1 ;    

         0   0  (01)  x         ?          :   ?  :   0 ;         // pessimism
         ?   ?   ?    x         ?          :   0  :   0 ;         // pessimism

         1   0  (01)  1         ?          :   0  :   1 ;         // Clocked toggle.
         1   0  (01)  1         ?          :   1  :   0 ;

         ?   0  (01)  x         ?          :   1  :   0 ;         // pessimism

         0   1  (x1)  1         ?          :   ?  :   - ;         //possible clocked JK
         0   0  (x1)  1         ?          :   0  :   0 ;   
         1   1  (x1)  1         ?          :   1  :   1 ;
         0   1  (0x)  1         ?          :   ?  :   - ;
         0   0  (0x)  1         ?          :   0  :   0 ;
         1   1  (0x)  1         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                                  // with steady clock.
         ?   ? (?0)   1         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   1         ?          :   ?  :   - ;
                                         
         x   1   r    1         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   0   r    1         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    1         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    1         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   1  (x1)  1         ?          :   1  :   1 ;         //possible clocked with
         0   x  (x1)  1         ?          :   0  :   0 ;         //possible J & K                                 
         x   1  (0x)  1         ?          :   1  :   1 ;
         0   x  (0x)  1         ?          :   0  :   0 ;

         ?   ?   ?    0         ?          :   ?  :   0 ;         // Clear. 

         ?   ?   ?   (?1)       ?          :   ?  :   - ;         // Insensitive to a rising
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on RESET.


    endtable

endprimitive

primitive U_FJKB_P_R_NO (Q, J, K, CP, R, NOTIFIER_REG); 
 


    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP,                                  // CLOCK.
           R;                                   // CLEAR INPUT.

// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH CLEAR 
//            ACTIVE HIGH

    table
      // J   K   CP   R      NOTIFIER_REG  :  Qtn : Qtn+1

         0   1  (01)  0         ?          :   ?  :   - ;         // Output retains the 
                                                 // present state if both 
                                                 // J and K are 0.

         0   0  (01)  0         ?          :   ?  :   0 ;         // Clocked J and K.
         1   1  (01)  0         ?          :   ?  :   1 ;    

         0   0  (01)  x         ?          :   ?  :   0 ;         // pessimism
         ?   ?   ?    x         ?          :   0  :   0 ;         // pessimism

         1   0  (01)  0         ?          :   0  :   1 ;         // Clocked toggle.
         1   0  (01)  0         ?          :   1  :   0 ;

         ?   0  (01)  x         ?          :   1  :   0 ;         // pessimism

         0   1  (x1)  0         ?          :   ?  :   - ;         //possible clocked JK
         0   0  (x1)  0         ?          :   0  :   0 ;   
         1   1  (x1)  0         ?          :   1  :   1 ;
         0   1  (0x)  0         ?          :   ?  :   - ;
         0   0  (0x)  0         ?          :   0  :   0 ;
         1   1  (0x)  0         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                 // with steady clock.
         ?   ? (?0)   0         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   0         ?          :   ?  :   - ;
                                         
         x   1   r    0         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   0   r    0         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    0         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    0         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   1  (x1)  0         ?          :   1  :   1 ;        //possible clocked with
         0   x  (x1)  0         ?          :   0  :   0 ;        //possible J & K                                 
         x   1  (0x)  0         ?          :   1  :   1 ;
         0   x  (0x)  0         ?          :   0  :   0 ;

         ?   ?   ?    1         ?          :   ?  :   0 ;         // Clear. 

         ?   ?   ?   (?0)       ?          :   ?  :   - ;         // Insensitive to a rising
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on RESET.


    endtable

endprimitive

primitive U_FJKB_P_SB_NO (Q, J, K, CP, SB, NOTIFIER_REG); 
 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP,                                  // CLOCK.
           SB;                                  // SET INPUT.

// FUNCTION : POSITIVE EDGE TRIGGERED J K FLIP FLOP, WITH
//            ASYNCHRONOUS ACTIVE LOW SET

    table
      // J   K   CP   SB     NOTIFIER_REG  :  Qtn : Qtn+1

         0   1  (01)  1         ?          :   ?  :   - ;         // Output retains the 
                                                                  // present state if both 
                                                                  // J and K are 0.

         0   0  (01)  1         ?          :   ?  :   0 ;         // Clocked J and K.
         1   1  (01)  1         ?          :   ?  :   1 ;    

         1   1  (01)  x         ?          :   ?  :   1 ;         // pessimism
         ?   ?   ?    x         ?          :   1  :   1 ;         // pessimism

         1   0  (01)  1         ?          :   0  :   1 ;         // Clocked toggle.
         1   0  (01)  1         ?          :   1  :   0 ;

         1   ?  (01)  x         ?          :   0  :   1 ;         // pessimism

         0   1  (x1)  1         ?          :   ?  :   - ;         //possible clocked JK
         0   0  (x1)  1         ?          :   0  :   0 ;   
         1   1  (x1)  1         ?          :   1  :   1 ;
         0   1  (0x)  1         ?          :   ?  :   - ;
         0   0  (0x)  1         ?          :   0  :   0 ;
         1   1  (0x)  1         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                                  // with steady clock.
         ?   ? (?0)   1         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   1         ?          :   ?  :   - ;
                                         
         x   1   r    1         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   0   r    1         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    1         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    1         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   1  (x1)  1         ?          :   1  :   1 ;         //possible clocked with
         0   x  (x1)  1         ?          :   0  :   0 ;         //possible J & K                                 
         x   1  (0x)  1         ?          :   1  :   1 ;
         0   x  (0x)  1         ?          :   0  :   0 ;

         ?   ?   ?    0         ?          :   ?  :   1 ;         // SET. 

         ?   ?   ?   (?1)       ?          :   ?  :   - ;         // Insensitive to a rising 
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on SET .


    endtable

endprimitive

primitive U_FJKB_P_S_NO (Q, J, K, CP, S, NOTIFIER_REG); 
 



    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP,                                  // CLOCK.
           S;                                   // SET INPUT.

// FUNCTION : POSITIVE EDGE TRIGGERED J K FLIP FLOP, WITH
//            ASYNCHRONOUS ACTIVE HIGH SET



    table
      // J   K   CP   S      NOTIFIER_REG  :  Qtn : Qtn+1

         0   1  (01)  0         ?          :   ?  :   - ;         // Output retains the 
                                                                  // present state if both 
                                                                  // J and K are 0.

         0   0  (01)  0         ?          :   ?  :   0 ;         // Clocked J and K.
         1   1  (01)  0         ?          :   ?  :   1 ;    

         1   1  (01)  x         ?          :   ?  :   1 ;         // pessimism
         ?   ?   ?    x         ?          :   1  :   1 ;         // pessimism

         1   0  (01)  0         ?          :   0  :   1 ;         // Clocked toggle.
         1   0  (01)  0         ?          :   1  :   0 ;

         1   ?  (01)  x         ?          :   0  :   1 ;         // pessimism

         0   1  (x1)  0         ?          :   ?  :   - ;         //possible clocked JK
         0   0  (x1)  0         ?          :   0  :   0 ;   
         1   1  (x1)  0         ?          :   1  :   1 ;
         0   1  (0x)  0         ?          :   ?  :   - ;
         0   0  (0x)  0         ?          :   0  :   0 ;
         1   1  (0x)  0         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                                   // with steady clock.
         ?   ? (?0)   0         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   0         ?          :   ?  :   - ;
                                         
         x   1   r    0         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   0   r    0         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    0         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    0         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   1  (x1)  0         ?          :   1  :   1 ;        //possible clocked with
         0   x  (x1)  0         ?          :   0  :   0 ;        //possible J & K                                 
         x   1  (0x)  0         ?          :   1  :   1 ;
         0   x  (0x)  0         ?          :   0  :   0 ;

         ?   ?   ?    1         ?          :   ?  :   1 ;         // SET. 

         ?   ?   ?   (?0)       ?          :   ?  :   - ;         // Insensitive to a falling
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on SET .


    endtable

endprimitive

primitive U_FJK_N (Q, J, K, CP);
 
// FUNCTION : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, ( Q OUTPUT UDP )
//  

    output Q;
    reg    Q;  
    input  J,K,
           CP;                                  // Clock.

    table
      //    J   K   CP   :  Qtn   :   Qtn+1

            0   0  (10)  :   ?    :     - ;      // Output retains the 

            0   1  (10)  :   ?    :     0 ;      // Clocked J and K.
            1   0  (10)  :   ?    :     1 ;    

            1   1  (10)  :   0    :     1 ;      // Clocked toggle.
            1   1  (10)  :   1    :     0 ;

            0   0  (1x)  :   ?    :     - ;      //possible clocked JK
            0   1  (1x)  :   0    :     0 ;   
            1   0  (1x)  :   1    :     1 ;
            0   0  (x0)  :   ?    :     - ;
            0   1  (x0)  :   0    :     0 ;
            1   0  (x0)  :   1    :     1 ;

            *   ?   ?    :   ?    :     - ;      // Insensitive to 
            ?   *   ?    :   ?    :     - ;      // transitions on J and K
                                                 // with steady clock.  
            ?   ? (?1)   :   ?    :     - ;      // ignore rising clock.  
            ?   ? (0x)   :   ?    :     - ;                                


            x   0   f    :   1    :     1 ;   // reducing pessimism for unknown J  
            x   1   f    :   1    :     0 ;   // reducing pessimism for unknown J  
            0   x   f    :   0    :     0 ;   // reducing pessimism for unknown K  
            1   x   f    :   0    :     1 ;   // reducing pessimism for unknown K  
    
            x   0  (1x)  :   1    :     1 ;   //possible clocked with
            0   x  (1x)  :   0    :     0 ;   //possible J & K                                 
            x   0  (x0)  :   1    :     1 ;
            0   x  (x0)  :   0    :     0 ;

    endtable

endprimitive

primitive U_FJK_N_NO (Q, J, K, CP, NOTIFIER_REG); 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP;

// FUNCTION : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, ( Q OUTPUT UDP )

    table
      //    J   K   CP      NOTIFIER_REG  :  Qtn   :   Qtn+1
                       
            0   0  (10)        ?          :   ?    :     - ;      // Output retains the 
                       
            0   1  (10)        ?          :   ?    :     0 ;      // Clocked J and K.
            1   0  (10)        ?          :   ?    :     1 ;    
                       
            1   1  (10)        ?          :   0    :     1 ;      // Clocked toggle.
            1   1  (10)        ?          :   1    :     0 ;
                       
            0   0  (1x)        ?          :   ?    :     - ;      //possible clocked JK
            0   1  (1x)        ?          :   0    :     0 ;   
            1   0  (1x)        ?          :   1    :     1 ;
            0   0  (x0)        ?          :   ?    :     - ;
            0   1  (x0)        ?          :   0    :     0 ;
            1   0  (x0)        ?          :   1    :     1 ;
                       
            *   ?   ?          ?          :   ?    :     - ;      // Insensitive to 
            ?   *   ?          ?          :   ?    :     - ;      // transitions on J and K
                                                 // with steady clock.  
            ?   ? (?1)         ?          :   ?    :     - ;      
            ?   ? (0x)         ?          :   ?    :     - ;                                
                       
                       
            x   0   f          ?          :   1    :     1 ;   // reducing pessimism for unknown J  
            x   1   f          ?          :   1    :     0 ;   // reducing pessimism for unknown J  
            0   x   f          ?          :   0    :     0 ;   // reducing pessimism for unknown K  
            1   x   f          ?          :   0    :     1 ;   // reducing pessimism for unknown K  
                       
            x   0  (1x)        ?          :   1    :     1 ;   //possible clocked with
            0   x  (1x)        ?          :   0    :     0 ;   //possible J & K                                 
            x   0  (x0)        ?          :   1    :     1 ;
            0   x  (x0)        ?          :   0    :     0 ;
            ?   ?   ?          *          :   ?    :     x ;

    endtable

endprimitive
 
primitive U_FJK_N_RB_SB (Q, J, K, CP, RB, SB);
 
// FUNCTION : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//            ASYNCHRONOUS CLEAR AND  SET  ( Q OUTPUT UDP ). 


    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB;                                  // Set input.

    table
      // J   K   CP   RB   SB     : Qtn : Qtn+1

         0   0  (10)  1    1     :  ?  :   - ;    // Output retains the 

         0   1  (10)  1    1     :  ?  :   0 ;    // Clocked J and K.
         0   1  (10)  x    1     :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    1     :  0  :   0 ;    // pessimism

         1   0  (10)  1    1     :  ?  :   1 ;    
         1   0  (10)  1    x     :  ?  :   1 ;    // pessimism
         ?   ?   ?    1    x     :  1  :   1 ;    // pessimism

         1   1  (10)  1    1     :  0  :   1 ;    // Clocked toggle.
         1   1  (10)  1    1     :  1  :   0 ;
                                                     
         ?   1  (10)  x    1     :  1  :   0 ;    //pessimism
         1   ?  (10)  1    x     :  0  :   1 ;
  
         0   0  (1x)  1    1     :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  1    1     :  0  :   0 ;   
         1   0  (1x)  1    1     :  1  :   1 ;
         0   0  (x0)  1    1     :  ?  :   - ;
         0   1  (x0)  1    1     :  0  :   0 ;
         1   0  (x0)  1    1     :  1  :   1 ;

                                 
         *   ?   ?    1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1     :  ?  :   - ;    // transitions on J and K
                                                  // with steady clock.

         ?   ?   ?    1    0     :  ?  :  1  ;    // Set.
         ?   ?   ?    0    ?     :  ?  :  0  ;    // clear and  clear override.

         ?   ? (?1)   ?    ?     :   ? :  -  ;
         ?   ? (0x)   ?    ?     :   ? :  -  ;
    
         x   0   f    1    1     :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   f    1    1     :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   f    1    1     :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   f    1    1     :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (1x)  1    1     :   1  :   1 ;        //possible clocked with
         0   x  (1x)  1    1     :   0  :   0 ;        //possible J & K                                 
         x   0  (x0)  1    1     :   1  :   1 ;
         0   x  (x0)  1    1     :   0  :   0 ;

         ?   ?   ?  (?1)   1     :  ?   :  -  ;    //ignore changes on set and
         ?   ?   ?   1   (?1)    :  ?   :  -  ;    //reset.

    endtable

endprimitive

 
primitive U_FJK_N_RB_SB_NO (Q, J, K, CP, RB, SB, NOTIFIER_REG); 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input
            SB;                                  // Set input  
// FUNCTION : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//            ASYNCHRONOUS CLEAR AND  SET  ( Q OUTPUT UDP ).

    table
      // J   K   CP   RB   SB       NOTIFIER_REG  : Qtn : Qtn+1
                    
         0   0  (10)  1    1           ?          :  ?  :   - ;    // Output retains the 
                    
         0   1  (10)  1    1           ?          :  ?  :   0 ;    // Clocked J and K.
         0   1  (10)  x    1           ?          :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    1           ?          :  0  :   0 ;    // pessimism
                    
         1   0  (10)  1    1           ?          :  ?  :   1 ;    
         1   0  (10)  1    x           ?          :  ?  :   1 ;    // pessimism
         ?   ?   ?    1    x           ?          :  1  :   1 ;    // pessimism
                    
         1   1  (10)  1    1           ?          :  0  :   1 ;    // Clocked toggle.
         1   1  (10)  1    1           ?          :  1  :   0 ;
                                                     
         ?   1  (10)  x    1           ?          :  1  :   0 ;    //pessimism
         1   ?  (10)  1    x           ?          :  0  :   1 ;
                    
         0   0  (1x)  1    1           ?          :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  1    1           ?          :  0  :   0 ;   
         1   0  (1x)  1    1           ?          :  1  :   1 ;
         0   0  (x0)  1    1           ?          :  ?  :   - ;
         0   1  (x0)  1    1           ?          :  0  :   0 ;
         1   0  (x0)  1    1           ?          :  1  :   1 ;
                    
                                 
         *   ?   ?    1    1           ?          :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1           ?          :  ?  :   - ;    // transitions on J and K
                                                                   // with steady clock.
                    
         ?   ?   ?    1    0           ?          :  ?  :   1 ;    // Set.
         ?   ?   ?    0    ?           ?          :  ?  :   0 ;    // clear and  clear override.
                    
         ?   ? (?1)   ?    ?           ?          :  ?  :   - ;
         ?   ? (0x)   ?    ?           ?          :  ?  :   - ;
                    
         x   0   f    1    1           ?          :  1  :   1 ;    // reducing pessimism for unknown J 
         x   1   f    1    1           ?          :  1  :   0 ;    // reducing pessimism for unknown J 
         0   x   f    1    1           ?          :  0  :   0 ;    // reducing pessimism for unknown K 
         1   x   f    1    1           ?          :  0  :   1 ;    // reducing pessimism for unknown K 
                    
         x   0  (1x)  1    1           ?          :  1  :   1 ;    //possible clocked with
         0   x  (1x)  1    1           ?          :  0  :   0 ;    //possible J & K                                 
         x   0  (x0)  1    1           ?          :  1  :   1 ;
         0   x  (x0)  1    1           ?          :  0  :   0 ;
                    
         ?   ?   ?  (?1)   1           ?          :  ?  :   - ;    //ignore changes on set and
         ?   ?   ?   1   (?1)          ?          :  ?  :   - ;    //reset.
         ?   ?   ?   ?     ?           *          :  ?  :   x ;

    endtable

endprimitive

 
primitive U_FJK_N_RB_SB_QN (QN, J, K, CP, RB, SB);
 
// FUNCTION : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//            ASYNCHRONOUS CLEAR AND  SET  ( QN OUTPUT UDP ).  


    output QN;
    reg    QN;  
    input  J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB;                                  // Set input.

    table
      // J   K   CP   RB   SB     : Qtn : Qtn+1
                    
         0   0  (10)  1    1     :  ?  :   - ;    // Output retains the 
                    
         0   1  (10)  1    1     :  ?  :   1 ;    // Clocked J and K.
         0   1  (10)  x    1     :  ?  :   1 ;    // pessimism
         ?   ?   ?    x    1     :  1  :   1 ;    // pessimism
                    
         1   0  (10)  1    1     :  ?  :   0 ;    
         1   0  (10)  1    x     :  ?  :   0 ;    // pessimism
         ?   ?   ?    1    x     :  0  :   0 ;    // pessimism
                    
         1   1  (10)  1    1     :  1  :   0 ;    // Clocked toggle.
         1   1  (10)  1    1     :  0  :   1 ;
                                                     
         ?   1  (10)  x    1     :  0  :   1 ;    //pessimism
         1   ?  (10)  1    x     :  1  :   0 ;
                    
         0   0  (1x)  1    1     :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  1    1     :  1  :   1 ;   
         1   0  (1x)  1    1     :  0  :   0 ;
         0   0  (x0)  1    1     :  ?  :   - ;
         0   1  (x0)  1    1     :  1  :   1 ;
         1   0  (x0)  1    1     :  0  :   0 ;
                    
                                 
         *   ?   ?    1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1     :  ?  :   - ;    // transitions on J and K
                                                 
                    
         ?   ?   ?    ?    0     :  ?  :  0  ;    // Set.
         ?   ?   ?    0    1     :  ?  :  1  ;    // clear 
               
         ?   ? (?1)   ?    ?     :   ? :  -  ;
         ?   ? (0x)   ?    ?     :   ? :  -  ;
                    
         x   0   f    1    1     :   0  :   0 ;         // reducing pessimism for unknown J 
         x   1   f    1    1     :   0  :   1 ;         // reducing pessimism for unknown J 
         0   x   f    1    1     :   1  :   1 ;         // reducing pessimism for unknown K 
         1   x   f    1    1     :   1  :   0 ;         // reducing pessimism for unknown K 
                    
         x   0  (1x)  1    1     :   0  :   0 ;        //possible clocked with
         0   x  (1x)  1    1     :   1  :   1 ;        //possible J & K                                 
         x   0  (x0)  1    1     :   0  :   0 ;
         0   x  (x0)  1    1     :   1  :   1 ;
                    
         ?   ?   ?  (?1)   1     :  ?   :  -  ;    //ignore changes on set and
         ?   ?   ?   1    (?1)   :  ?   :  -  ;    //reset.

    endtable

endprimitive

primitive U_FJK_N_RB_SB_X (Q, J, K, CP, RB, SB);
 
// FUNCTION :NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//           ASYNCHRONOUS CLEAR AND  SET  ( Q OUTPUT UDP )
//           OUTPUT GOES TO "X" WHEN BOTH CLEAR AND SET ARE ACTIVE 

    output Q;
    reg    Q;  
    input  J,K,
           CP,                                  // Clock.
           RB,                                  // Clear input.
           SB;                                  // Set input.

    table
      // J   K   CP  RB   SB    : Qtn : Qtn+1

         0   0  (10) 1    1     :  ?  :   - ;    // Output retains the 

         0   1  (10) 1    1     :  ?  :   0 ;    // Clocked J and K.
         0   1  (10) x    1     :  ?  :   0 ;    // pessimism
         ?   ?   ?   x    1     :  0  :   0 ;    // pessimism

         1   0  (10) 1    1     :  ?  :   1 ;    
         1   0  (10) 1    x     :  ?  :   1 ;    // pessimism
         ?   ?   ?   1    x     :  1  :   1 ;    // pessimism

         1   1  (10) 1    1     :  0  :   1 ;    // Clocked toggle.
         1   1  (10) 1    1     :  1  :   0 ;
         
         ?   1  (10) x    1     :  1  :   0 ;    //pessimism
         1   ?  (10) 1    x     :  0  :   1 ;


         0   0  (1x) 1    1     :  ?  :   - ;    //possible clocked JK
         0   1  (1x) 1    1     :  0  :   0 ;   
         1   0  (1x) 1    1     :  1  :   1 ;
         0   0  (x0) 1    1     :  ?  :   - ;
         0   1  (x0) 1    1     :  0  :   0 ;
         1   0  (x0) 1    1     :  1  :   1 ;

                                
         *   ?   ?   1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?   1    1     :  ?  :   - ;    // transitions on J and K
                                                 // with steady clock.

         ?   ?   ?   0    1     :  ?  :  0  ;    // Clear.
         ?   ?   ?   1    0     :  ?  :  1  ;    // Set.
         ?   ?   ?   0    0     :  ?  :  x  ;    // ILLEGAL 

         x   0   f   1    1     :  1  :  1  ;
         x   1   f   1    1     :  1  :  0  ;
         0   x   f   1    1     :  0  :  0  ;
         1   x   f   1    1     :  0  :  1  ;
         
         x   0 (1x)  1    1     :  1  :   1 ;    //possible clocked with
         0   x (1x)  1    1     :  0  :   0 ;    //possible J & K                                 
         x   0 (x0)  1    1     :  1  :   1 ;
         0   x (x0)  1    1     :  0  :   0 ;


         ?   ? (?1)  ?    ?      :   ? :  -  ;   
         ?   ? (0x)  ?    ?      :   ? :  -  ;

         ?   ?   ? (?1)   1     :  ?  :  -  ;    //ignore changes on set and
         ?   ?   ?   1  (?1)    :  ?  :  -  ;    //reset.


    endtable

endprimitive

primitive U_FJK_N_SB_RB (Q, J, K, CP, RB, SB);
 
// FUNCTION  : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE LOW ASYNCHRONOUS CLEAR AND SET ( Q OUTPUT UDP )
//            

    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB;                                  // Set input.

    table
      // J   K   CP   RB   SB     : Qtn : Qtn+1

         0   0  (10)  1    1     :  ?  :   - ;    // Output retains the 

         0   1  (10)  1    1     :  ?  :   0 ;    // Clocked J and K.
         0   1  (10)  x    1     :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    1     :  0  :   0 ;    // pessimism

         1   0  (10)  1    1     :  ?  :   1 ;    
         1   0  (10)  1    x     :  ?  :   1 ;    // pessimism
         ?   ?   ?    1    x     :  1  :   1 ;    // pessimism

         1   1  (10)  1    1     :  0  :   1 ;    // Clocked toggle.
         1   1  (10)  1    1     :  1  :   0 ;
                                                     
         ?   1  (10)  x    1     :  1  :   0 ;    //pessimism
         1   ?  (10)  1    x     :  0  :   1 ;
  
         0   0  (1x)  1    1     :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  1    1     :  0  :   0 ;   
         1   0  (1x)  1    1     :  1  :   1 ;
         0   0  (x0)  1    1     :  ?  :   - ;
         0   1  (x0)  1    1     :  0  :   0 ;
         1   0  (x0)  1    1     :  1  :   1 ;

                                 
         *   ?   ?    1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1     :  ?  :   - ;    // transitions on J and K
                                                  // with steady clock.

         ?   ?   ?    ?    0     :  ?  :  1  ;    // Set 
         ?   ?   ?    0    1     :  ?  :  0  ;    // clear
 
         ?   ? (?1)   ?    ?     :   ? :  -  ;    
         ?   ? (0x)   ?    ?     :   ? :  -  ;
    
         x   0   f    1    1     :   1 :   1 ;    // reducing pessimism for unknown J 
         x   1   f    1    1     :   1 :   0 ;    // reducing pessimism for unknown J 
         0   x   f    1    1     :   0 :   0 ;    // reducing pessimism for unknown K 
         1   x   f    1    1     :   0 :   1 ;    // reducing pessimism for unknown K 

         x   0  (1x)  1    1     :   1 :   1 ;    //possible clocked with
         0   x  (1x)  1    1     :   0 :   0 ;    //possible J & K                                 
         x   0  (x0)  1    1     :   1 :   1 ;
         0   x  (x0)  1    1     :   0 :   0 ;

         ?   ?   ?  (?1)   1     :  ?  :  -  ;    //ignore changes on set and
         ?   ?   ?   1   (?1)    :  ?  :  -  ;    //reset.


    endtable

endprimitive
 
primitive U_FJK_N_SB_RB_NO (Q, J, K, CP, RB, SB, NOTIFIER_REG); 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input
            SB;                                  // Set input  
// FUNCTION  : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE LOW ASYNCHRONOUS CLEAR AND SET ( Q OUTPUT UDP )

    table
      // J   K   CP   RB   SB       NOTIFIER_REG  : Qtn : Qtn+1
                    
         0   0  (10)  1    1           ?          :  ?  :   - ;    // Output retains the 
                    
         0   1  (10)  1    1           ?          :  ?  :   0 ;    // Clocked J and K.
         0   1  (10)  x    1           ?          :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    1           ?          :  0  :   0 ;    // pessimism
                    
         1   0  (10)  1    1           ?          :  ?  :   1 ;    
         1   0  (10)  1    x           ?          :  ?  :   1 ;    // pessimism
         ?   ?   ?    1    x           ?          :  1  :   1 ;    // pessimism
                    
         1   1  (10)  1    1           ?          :  0  :   1 ;    // Clocked toggle.
         1   1  (10)  1    1           ?          :  1  :   0 ;
                                                     
         ?   1  (10)  x    1           ?          :  1  :   0 ;    //pessimism
         1   ?  (10)  1    x           ?          :  0  :   1 ;
                    
         0   0  (1x)  1    1           ?          :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  1    1           ?          :  0  :   0 ;   
         1   0  (1x)  1    1           ?          :  1  :   1 ;
         0   0  (x0)  1    1           ?          :  ?  :   - ;
         0   1  (x0)  1    1           ?          :  0  :   0 ;
         1   0  (x0)  1    1           ?          :  1  :   1 ;
                    
                                 
         *   ?   ?    1    1           ?          :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1           ?          :  ?  :   - ;    // transitions on J and K
                                                                   // with steady clock.
                    
         ?   ?   ?    ?    0           ?          :  ?  :   1 ;    // Set.
         ?   ?   ?    0    1           ?          :  ?  :   0 ;    // clear and  clear override.
                    
         ?   ? (?1)   ?    ?           ?          :  ?  :   - ;    
         ?   ? (0x)   ?    ?           ?          :  ?  :   - ;
                    
         x   0   f    1    1           ?          :  1  :   1 ;    // reducing pessimism for unknown J 
         x   1   f    1    1           ?          :  1  :   0 ;    // reducing pessimism for unknown J 
         0   x   f    1    1           ?          :  0  :   0 ;    // reducing pessimism for unknown K 
         1   x   f    1    1           ?          :  0  :   1 ;    // reducing pessimism for unknown K 
                    
         x   0  (1x)  1    1           ?          :  1  :   1 ;    //possible clocked with
         0   x  (1x)  1    1           ?          :  0  :   0 ;    //possible J & K                                 
         x   0  (x0)  1    1           ?          :  1  :   1 ;
         0   x  (x0)  1    1           ?          :  0  :   0 ;
                    
         ?   ?   ?  (?1)   1           ?          :  ?  :   - ;    //ignore changes on set and
         ?   ?   ?   1   (?1)          ?          :  ?  :   - ;    //reset.
         ?   ?   ?   ?     ?           *          :  ?  :   x ;

    endtable

endprimitive

primitive U_FJK_N_SB_RB_QN (QN, J, K, CP, RB, SB);
 
// FUNCTION  : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE LOW ASYNCHRONOUS CLEAR AND SET ( QN OUTPUT UDP )

    output QN;
    reg    QN;  
    input  J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB;                                  // Set input.

    table
      // J   K   CP   RB   SB     : Qtn : Qtn+1

         0   0  (10)  1    1     :  ?  :   - ;    // Output retains the 

         0   1  (10)  1    1     :  ?  :   1 ;    // Clocked J and K.
         0   1  (10)  x    1     :  ?  :   1 ;    // pessimism
         ?   ?   ?    x    1     :  1  :   1 ;    // pessimism

         1   0  (10)  1    1     :  ?  :   0 ;    
         1   0  (10)  1    x     :  ?  :   0 ;    // pessimism
         ?   ?   ?    1    x     :  0  :   0 ;    // pessimism

         1   1  (10)  1    1     :  1  :   0 ;    // Clocked toggle.
         1   1  (10)  1    1     :  0  :   1 ;
                                                     
         ?   1  (10)  x    1     :  0  :   1 ;    //pessimism
         1   ?  (10)  1    x     :  1  :   0 ;
  
         0   0  (1x)  1    1     :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  1    1     :  1  :   1 ;   
         1   0  (1x)  1    1     :  0  :   0 ;
         0   0  (x0)  1    1     :  ?  :   - ;
         0   1  (x0)  1    1     :  1  :   1 ;
         1   0  (x0)  1    1     :  0  :   0 ;

                                 
         *   ?   ?    1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1     :  ?  :   - ;    // transitions on J and K
                                                  // with steady clock.

         ?   ?   ?    1    0     :  ?  :  0  ;    // Set 
         ?   ?   ?    0    ?     :  ?  :  1  ;    // clear
 
         ?   ? (?1)   ?    ?     :   ? :  -  ;    
         ?   ? (0x)   ?    ?     :   ? :  -  ;
    
         x   0   f    1    1     :   0 :   0 ;    // reducing pessimism for unknown J 
         x   1   f    1    1     :   0 :   1 ;    // reducing pessimism for unknown J 
         0   x   f    1    1     :   1 :   1 ;    // reducing pessimism for unknown K 
         1   x   f    1    1     :   1 :   0 ;    // reducing pessimism for unknown K 

         x   0  (1x)  1    1     :   0 :   0 ;    //possible clocked with
         0   x  (1x)  1    1     :   1 :   1 ;    //possible J & K                                 
         x   0  (x0)  1    1     :   0 :   0 ;
         0   x  (x0)  1    1     :   1 :   1 ;

         ?   ?   ?  (?1)   1     :  ?  :  -  ;    //ignore changes on set and
         ?   ?   ?   1   (?1)    :  ?  :  -  ;    //reset.


    endtable

endprimitive
 
primitive U_FJK_N_S_R (Q, J, K, CP, R, S);
 
// FUNCTION  : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE HIGH ASYNCHRONOUS CLEAR AND SET ( Q OUTPUT UDP )

    output Q;
    reg    Q;  
    input  J,K,
           CP,                                  // Clock.
           R,                                   // Clear input.
           S;                                   // Set input.
                                  

    table
      // J   K   CP   R    S     : Qtn : Qtn+1

         0   0  (10)  0    0     :  ?  :   - ;    // Output retains the previous value

         0   1  (10)  0    0     :  ?  :   0 ;    // Clocked J and K.
         0   1  (10)  x    0     :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    0     :  0  :   0 ;    // pessimism

         1   0  (10)  0    0     :  ?  :   1 ;    
         1   0  (10)  0    x     :  ?  :   1 ;    // pessimism
         ?   ?   ?    0    x     :  1  :   1 ;    // pessimism

         1   1  (10)  0    0     :  0  :   1 ;    // Clocked toggle.
         1   1  (10)  0    0     :  1  :   0 ;
                                                     
         ?   1  (10)  x    0     :  1  :   0 ;    //pessimism
         1   ?  (10)  0    x     :  0  :   1 ;
  
         0   0  (1x)  0    0     :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  0    0     :  0  :   0 ;   
         1   0  (1x)  0    0     :  1  :   1 ;
         0   0  (x0)  0    0     :  ?  :   - ;
         0   1  (x0)  0    0     :  0  :   0 ;
         1   0  (x0)  0    0     :  1  :   1 ;

                                 
         *   ?   ?    0    0     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    0    0     :  ?  :   - ;    // transitions on J and K
                                                  // with steady clock.

         ?   ?   ?    ?    1     :  ?  :  1  ;    // Set.
         ?   ?   ?    1    0     :  ?  :  0  ;    // clear

         ?   ? (?1)   ?    ?     :   ? :  -  ;    
         ?   ? (0x)   ?    ?     :   ? :  -  ;
    
         x   0   f    0    0     :   1  :   1 ;   // reducing pessimism for unknown J 
         x   1   f    0    0     :   1  :   0 ;   // reducing pessimism for unknown J 
         0   x   f    0    0     :   0  :   0 ;   // reducing pessimism for unknown K 
         1   x   f    0    0     :   0  :   1 ;   // reducing pessimism for unknown K 

         x   0  (1x)  0    0     :   1  :   1 ;   //possible clocked with
         0   x  (1x)  0    0     :   0  :   0 ;   //possible J & K                                 
         x   0  (x0)  0    0     :   1  :   1 ;
         0   x  (x0)  0    0     :   0  :   0 ;

         ?   ?   ?  (?0)   0     :  ?   :  -  ;    //ignore changes on set and
         ?   ?   ?   0   (?0)    :  ?   :  -  ;    //reset.

    endtable

endprimitive
 
primitive U_FJK_N_S_R_NO (Q, J, K, CP, R, S, NOTIFIER_REG); 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // Clock.
            R,                                   // Clear input 
            S;                                   // Set input
// FUNCTION  : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE HIGH ASYNCHRONOUS CLEAR AND SET ( Q OUTPUT UDP )

    table
      // J   K   CP   R    S        NOTIFIER_REG  : Qtn : Qtn+1
                    
         0   0  (10)  0    0           ?          :  ?  :   - ;    // Output retains the 
                    
         0   1  (10)  0    0           ?          :  ?  :   0 ;    // Clocked J and K.
         0   1  (10)  x    0           ?          :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    0           ?          :  0  :   0 ;    // pessimism
                    
         1   0  (10)  0    0           ?          :  ?  :   1 ;    
         1   0  (10)  0    x           ?          :  ?  :   1 ;    // pessimism
         ?   ?   ?    0    x           ?          :  1  :   1 ;    // pessimism
                    
         1   1  (10)  0    0           ?          :  0  :   1 ;    // Clocked toggle.
         1   1  (10)  0    0           ?          :  1  :   0 ;
                                                     
         ?   1  (10)  x    0           ?          :  1  :   0 ;    //pessimism
         1   ?  (10)  0    x           ?          :  0  :   1 ;
                    
         0   0  (1x)  0    0           ?          :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  0    0           ?          :  0  :   0 ;   
         1   0  (1x)  0    0           ?          :  1  :   1 ;
         0   0  (x0)  0    0           ?          :  ?  :   - ;
         0   1  (x0)  0    0           ?          :  0  :   0 ;
         1   0  (x0)  0    0           ?          :  1  :   1 ;
                    
                                 
         *   ?   ?    0    0           ?          :  ?  :   - ;    // Insensitive to 
         ?   *   ?    0    0           ?          :  ?  :   - ;    // transitions on J and K
                                                                   // with steady clock.
                    
         ?   ?   ?    ?    1           ?          :  ?  :   1 ;    // Set.
         ?   ?   ?    1    0           ?          :  ?  :   0 ;    // clear
                    
         ?   ? (?1)   ?    ?           ?          :  ?  :   - ;    
         ?   ? (0x)   ?    ?           ?          :  ?  :   - ;
                    
         x   0   f    0    0           ?          :  1  :   1 ;    // reducing pessimism for unknown J 
         x   1   f    0    0           ?          :  1  :   0 ;    // reducing pessimism for unknown J 
         0   x   f    0    0           ?          :  0  :   0 ;    // reducing pessimism for unknown K 
         1   x   f    0    0           ?          :  0  :   1 ;    // reducing pessimism for unknown K 
                    
         x   0  (1x)  0    0           ?          :  1  :   1 ;    //possible clocked with
         0   x  (1x)  0    0           ?          :  0  :   0 ;    //possible J & K                                 
         x   0  (x0)  0    0           ?          :  1  :   1 ;
         0   x  (x0)  0    0           ?          :  0  :   0 ;
                    
         ?   ?   ?  (?0)   0           ?          :  ?  :   - ;    //ignore changes on set and
         ?   ?   ?   0   (?0)          ?          :  ?  :   - ;    //reset.
         ?   ?   ?   ?     ?           *          :  ?  :   x ; 

    endtable

endprimitive
 
primitive U_FJK_N_S_R_NO_QN (QN, J, K, CP, R, S, NOTIFIER_REG); 

    output QN;
    reg    QN;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // Clock.
            R,                                  // Clear input
            S;                                  // Set input  
// FUNCTION  : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE HIGH ASYNCHRONOUS CLEAR AND SET ( QN OUTPUT UDP )

    table
      // J   K   CP   R    S        NOTIFIER_REG  : Qtn : Qtn+1

         0   0  (10)  0    0           ?          :  ?  :   - ;    // Output retains the 

         0   1  (10)  0    0           ?          :  ?  :   1 ;    // Clocked J and K.
         0   1  (10)  x    0           ?          :  ?  :   1 ;    // pessimism
         ?   ?   ?    x    0           ?          :  1  :   1 ;    // pessimism

         1   0  (10)  0    0           ?          :  ?  :   0 ;    
         1   0  (10)  0    x           ?          :  ?  :   0 ;    // pessimism
         ?   ?   ?    0    x           ?          :  0  :   0 ;    // pessimism

         1   1  (10)  0    0           ?          :  1  :   0 ;    // Clocked toggle.
         1   1  (10)  0    0           ?          :  0  :   1 ;
                                                     
         ?   1  (10)  x    0           ?          :  0  :   1 ;    //pessimism
         1   ?  (10)  0    x           ?          :  1  :   0 ;
  
         0   0  (1x)  0    0           ?          :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  0    0           ?          :  1  :   1 ;   
         1   0  (1x)  0    0           ?          :  0  :   0 ;
         0   0  (x0)  0    0           ?          :  ?  :   - ;
         0   1  (x0)  0    0           ?          :  1  :   1 ;
         1   0  (x0)  0    0           ?          :  0  :   0 ;

                                 
         *   ?   ?    0    0           ?          :  ?  :   - ;    // Insensitive to 
         ?   *   ?    0    0           ?          :  ?  :   - ;    // transitions on J and K
                                                                   // with steady clock.

         ?   ?   ?    0    1           ?          :  ?  :   0 ;    // Set.
         ?   ?   ?    1    ?           ?          :  ?  :   1 ;    // clear

         ?   ? (?1)   ?    ?           ?          :  ?  :   - ;    
         ?   ? (0x)   ?    ?           ?          :  ?  :   - ;
    
         x   0   f    0    0           ?          :  0  :   0 ;    // reducing pessimism for unknown J 
         x   1   f    0    0           ?          :  0  :   1 ;    // reducing pessimism for unknown J 
         0   x   f    0    0           ?          :  1  :   1 ;    // reducing pessimism for unknown K 
         1   x   f    0    0           ?          :  1  :   0 ;    // reducing pessimism for unknown K 

         x   0  (1x)  0    0           ?          :  0  :   0 ;    //possible clocked with
         0   x  (1x)  0    0           ?          :  1  :   1 ;    //possible J & K                                 
         x   0  (x0)  0    0           ?          :  0  :   0 ;
         0   x  (x0)  0    0           ?          :  1  :   1 ;

         ?   ?   ?  (?0)   0           ?          :  ?  :   - ;    //ignore changes on set and
         ?   ?   ?   0   (?0)          ?          :  ?  :   - ;    //reset.
         ?   ?   ?   ?     ?           *          :  ?  :   x ;

    endtable

endprimitive
 
primitive U_FJK_N_S_R_QN (QN, J, K, CP, R, S);
 
// FUNCTION  : NEGATIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE HIGH ASYNCHRONOUS CLEAR AND SET ( QN OUTPUT UDP )

    output QN;
    reg    QN;  
    input  J,K,
            CP,                                  // Clock.
            R,                                  // Clear input.
            S;                                  // Set input.

    table
      // J   K   CP   R    S     : Qtn : Qtn+1

         0   0  (10)  0    0     :  ?  :   - ;    // Output retains the 

         0   1  (10)  0    0     :  ?  :   1 ;    // Clocked J and K.
         0   1  (10)  x    0     :  ?  :   1 ;    // pessimism
         ?   ?   ?    x    0     :  1  :   1 ;    // pessimism

         1   0  (10)  0    0     :  ?  :   0 ;    
         1   0  (10)  0    x     :  ?  :   0 ;    // pessimism
         ?   ?   ?    0    x     :  0  :   0 ;    // pessimism

         1   1  (10)  0    0     :  1  :   0 ;    // Clocked toggle.
         1   1  (10)  0    0     :  0  :   1 ;
                                                     
         ?   1  (10)  x    0     :  0  :   1 ;    //pessimism
         1   ?  (10)  0    x     :  1  :   0 ;
  
         0   0  (1x)  0    0     :  ?  :   - ;    //possible clocked JK
         0   1  (1x)  0    0     :  1  :   1 ;   
         1   0  (1x)  0    0     :  0  :   0 ;
         0   0  (x0)  0    0     :  ?  :   - ;
         0   1  (x0)  0    0     :  1  :   1 ;
         1   0  (x0)  0    0     :  0  :   0 ;

                                 
         *   ?   ?    0    0     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    0    0     :  ?  :   - ;    // transitions on J and K
                                                  // with steady clock.

         ?   ?   ?    0    1     :  ?  :  0  ;    // Set.
         ?   ?   ?    1    ?     :  ?  :  1  ;    // clear

         ?   ? (?1)   ?    ?     :   ? :  -  ;    
         ?   ? (0x)   ?    ?     :   ? :  -  ;
    
         x   0   f    0    0     :   0  :   0 ;   // reducing pessimism for unknown J 
         x   1   f    0    0     :   0  :   1 ;   // reducing pessimism for unknown J 
         0   x   f    0    0     :   1  :   1 ;   // reducing pessimism for unknown K 
         1   x   f    0    0     :   1  :   0 ;   // reducing pessimism for unknown K 

         x   0  (1x)  0    0     :   0  :   0 ;   //possible clocked with
         0   x  (1x)  0    0     :   1  :   1 ;   //possible J & K                                 
         x   0  (x0)  0    0     :   0  :   0 ;
         0   x  (x0)  0    0     :   1  :   1 ;

         ?   ?   ?  (?0)   0     :  ?   :  -  ;   //ignore changes on set and
         ?   ?   ?   0   (?0)    :  ?   :  -  ;   //reset.

    endtable

endprimitive

primitive U_FJK_P (Q, J, K, CP);
 
// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, STANDARD DRIVE ( Q OUTPUT UDP )
//  

    output Q;
    reg    Q;  
    input  J,K,
           CP;                                  // Clock.

    table
      //    J   K   CP   :  Qtn   :   Qtn+1

            0   0  (01)  :   ?    :     - ;      // Output retains the 

            0   1  (01)  :   ?    :     0 ;      // Clocked J and K.
            1   0  (01)  :   ?    :     1 ;    

            1   1  (01)  :   0    :     1 ;      // Clocked toggle.
            1   1  (01)  :   1    :     0 ;

            0   0  (x1)  :   ?    :     - ;      //possible clocked JK
            0   1  (x1)  :   0    :     0 ;   
            1   0  (x1)  :   1    :     1 ;
            0   0  (0x)  :   ?    :     - ;
            0   1  (0x)  :   0    :     0 ;
            1   0  (0x)  :   1    :     1 ;

            *   ?   ?    :   ?    :     - ;      // Insensitive to 
            ?   *   ?    :   ?    :     - ;      // transitions on J and K
                                                 // with steady clock.  
            ?   ? (?0)   :   ?    :     - ;      //ignore falling clock.  
            ?   ? (1x)   :   ?    :     - ;                                


            x   0   r    :   1    :     1 ;   // reducing pessimism for unknown J  
            x   1   r    :   1    :     0 ;   // reducing pessimism for unknown J  
            0   x   r    :   0    :     0 ;   // reducing pessimism for unknown K  
            1   x   r    :   0    :     1 ;   // reducing pessimism for unknown K  
    
            x   0  (x1)  :   1    :     1 ;   //possible clocked with
            0   x  (x1)  :   0    :     0 ;   //possible J & K                                 
            x   0  (0x)  :   1    :     1 ;
            0   x  (0x)  :   0    :     0 ;



    endtable

endprimitive

primitive U_FJK_P_NO (Q, J, K, CP, NOTIFIER_REG); 
 
 
 
 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
           CP;                                  // Clock.
// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, STANDARD DRIVE ( Q OUTPUT UDP )
//  


    table
      //    J   K   CP      NOTIFIER_REG  :  Qtn   :   Qtn+1

            0   0  (01)        ?          :   ?    :     - ;      // Output retains the 

            0   1  (01)        ?          :   ?    :     0 ;      // Clocked J and K.
            1   0  (01)        ?          :   ?    :     1 ;    

            1   1  (01)        ?          :   0    :     1 ;      // Clocked toggle.
            1   1  (01)        ?          :   1    :     0 ;

            0   0  (x1)        ?          :   ?    :     - ;      //possible clocked JK
            0   1  (x1)        ?          :   0    :     0 ;   
            1   0  (x1)        ?          :   1    :     1 ;
            0   0  (0x)        ?          :   ?    :     - ;
            0   1  (0x)        ?          :   0    :     0 ;
            1   0  (0x)        ?          :   1    :     1 ;

            *   ?   ?          ?          :   ?    :     - ;      // Insensitive to 
            ?   *   ?          ?          :   ?    :     - ;      // transitions on J and K
                                                 // with steady clock.  
            ?   ? (?0)         ?          :   ?    :     - ;      //ignore falling clock.  
            ?   ? (1x)         ?          :   ?    :     - ;                                


            x   0   r          ?          :   1    :     1 ;   // reducing pessimism for unknown J  
            x   1   r          ?          :   1    :     0 ;   // reducing pessimism for unknown J  
            0   x   r          ?          :   0    :     0 ;   // reducing pessimism for unknown K  
            1   x   r          ?          :   0    :     1 ;   // reducing pessimism for unknown K  
    
            x   0  (x1)        ?          :   1    :     1 ;   //possible clocked with
            0   x  (x1)        ?          :   0    :     0 ;   //possible J & K                                 
            x   0  (0x)        ?          :   1    :     1 ;
            0   x  (0x)        ?          :   0    :     0 ;
            ?   ?   ?          *          :   ?    :     x ;

    endtable

endprimitive

primitive U_FJK_P_R (Q, J, K, CP, R);
 

// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH CLEAR 
//            ACTIVE HIGH / STANDARD DRIVE ( Q OUTPUT UDP )

    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // CLOCK.
            R;                                  // CLEAR INPUT.

    table
      // J   K   CP   R   :  Qtn : Qtn+1

         0   0  (01)  0   :   ?  :   - ;         // Output retains the 
                                                 // present state if both 
                                                 // J and K are 0.

         0   1  (01)  0   :   ?  :   0 ;         // Clocked J and K.
         1   0  (01)  0   :   ?  :   1 ;    

         0   1  (01)  x   :   ?  :   0 ;         // pessimism
         ?   ?   ?    x   :   0  :   0 ;         // pessimism

         1   1  (01)  0   :   0  :   1 ;         // Clocked toggle.
         1   1  (01)  0   :   1  :   0 ;

         ?   1  (01)  x   :   1  :   0 ;         // pessimism

         0   0  (x1)  0   :   ?  :   - ;         //possible clocked JK
         0   1  (x1)  0   :   0  :   0 ;   
         1   0  (x1)  0   :   1  :   1 ;
         0   0  (0x)  0   :   ?  :   - ;
         0   1  (0x)  0   :   0  :   0 ;
         1   0  (0x)  0   :   1  :   1 ;


         *   ?   ?    ?   :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?   :   ?  :   - ;         // transitions on J and K
                                                 // with steady clock.
         ?   ? (?0)   0   :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   0   :   ?  :   - ;
                                         
         x   0   r    0   :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    0   :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    0   :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    0   :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  0   :   1  :   1 ;        //possible clocked with
         0   x  (x1)  0   :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  0   :   1  :   1 ;
         0   x  (0x)  0   :   0  :   0 ;

         ?   ?   ?    1   :   ?  :   0 ;         // Clear. 

         ?   ?   ?   (?0) :   ?  :   - ;         // Insensitive to a rising
                                                 // edge on RESET.


    endtable

endprimitive

primitive U_FJK_P_RB (Q, J, K, CP, RB);
 

// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH CLEAR 
//            ACTIVE LOW / STANDARD DRIVE ( Q OUTPUT UDP )

    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // CLOCK.
            RB;                                  // CLEAR INPUT.

    table
      // J   K   CP  RB   :  Qtn : Qtn+1

         0   0  (01)  1   :   ?  :   - ;         // Output retains the 
                                                 // present state if both 
                                                 // J and K are 0.

         0   1  (01)  1   :   ?  :   0 ;         // Clocked J and K.
         1   0  (01)  1   :   ?  :   1 ;    

         0   1  (01)  x   :   ?  :   0 ;         // pessimism
         ?   ?   ?    x   :   0  :   0 ;         // pessimism

         1   1  (01)  1   :   0  :   1 ;         // Clocked toggle.
         1   1  (01)  1   :   1  :   0 ;

         ?   1  (01)  x   :   1  :   0 ;         // pessimism

         0   0  (x1)  1   :   ?  :   - ;         //possible clocked JK
         0   1  (x1)  1   :   0  :   0 ;   
         1   0  (x1)  1   :   1  :   1 ;
         0   0  (0x)  1   :   ?  :   - ;
         0   1  (0x)  1   :   0  :   0 ;
         1   0  (0x)  1   :   1  :   1 ;


         *   ?   ?    ?   :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?   :   ?  :   - ;         // transitions on J and K
                                                 // with steady clock.
         ?   ? (?0)   1   :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   1   :   ?  :   - ;
                                         
         x   0   r    1   :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    1   :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    1   :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    1   :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  1   :   1  :   1 ;        //possible clocked with
         0   x  (x1)  1   :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  1   :   1  :   1 ;
         0   x  (0x)  1   :   0  :   0 ;

         ?   ?   ?    0   :   ?  :   0 ;         // Clear. 

         ?   ?   ?   (?1) :   ?  :   - ;         // Insensitive to a rising
                                                 // edge on CD.


    endtable

endprimitive

primitive U_FJK_P_RB_NO (Q, J, K, CP, RB, NOTIFIER_REG); 
 
 
 
 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // CLOCK.
            RB;                                  // CLEAR INPUT.
// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH CLEAR 
//            ACTIVE LOW / STANDARD DRIVE ( Q OUTPUT UDP )


    table
      // J   K   CP  RB      NOTIFIER_REG  :  Qtn : Qtn+1

         0   0  (01)  1         ?          :   ?  :   - ;         // Output retains the 
                                                                  // present state if both 
                                                                  // J and K are 0.
         0   1  (01)  1         ?          :   ?  :   0 ;         // Clocked J and K.
         1   0  (01)  1         ?          :   ?  :   1 ;    

         0   1  (01)  x         ?          :   ?  :   0 ;         // pessimism
         ?   ?   ?    x         ?          :   0  :   0 ;         // pessimism

         1   1  (01)  1         ?          :   0  :   1 ;         // Clocked toggle.
         1   1  (01)  1         ?          :   1  :   0 ;

         ?   1  (01)  x         ?          :   1  :   0 ;         // pessimism

         0   0  (x1)  1         ?          :   ?  :   - ;         //possible clocked JK
         0   1  (x1)  1         ?          :   0  :   0 ;   
         1   0  (x1)  1         ?          :   1  :   1 ;
         0   0  (0x)  1         ?          :   ?  :   - ;
         0   1  (0x)  1         ?          :   0  :   0 ;
         1   0  (0x)  1         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                                  // with steady clock.
         ?   ? (?0)   1         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   1         ?          :   ?  :   - ;
                                         
         x   0   r    1         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    1         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    1         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    1         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  1         ?          :   1  :   1 ;        //possible clocked with
         0   x  (x1)  1         ?          :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  1         ?          :   1  :   1 ;
         0   x  (0x)  1         ?          :   0  :   0 ;

         ?   ?   ?    0         ?          :   ?  :   0 ;         // Clear. 

         ?   ?   ?   (?1)       ?          :   ?  :   - ;         // Insensitive to a rising
                                                                  // edge on CD.
         ?   ?   ?    ?         *          :   ?  :   x ;         


    endtable

endprimitive

 
primitive U_FJK_P_RB_SB (Q, J, K, CP, RB, SB);
 
// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//            ASYNCHRONOUS CLEAR AND  SET  ( Q OUTPUT UDP ). 


    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB;                                  // Set input.
                                  

    table
      // J   K   CP   RB   SB     : Qtn : Qtn+1

         0   0  (01)  1    1     :  ?  :   - ;    // Output retains the 

         0   1  (01)  1    1     :  ?  :   0 ;    // Clocked J and K.
         0   1  (01)  x    1     :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    1     :  0  :   0 ;    // pessimism

         1   0  (01)  1    1     :  ?  :   1 ;    
         1   0  (01)  1    x     :  ?  :   1 ;    // pessimism
         ?   ?   ?    1    x     :  1  :   1 ;    // pessimism

         1   1  (01)  1    1     :  0  :   1 ;    // Clocked toggle.
         1   1  (01)  1    1     :  1  :   0 ;
                                                     
         ?   1  (01)  x    1     :  1  :   0 ;     //pessimism
         1   ?  (01)  1    x     :  0  :   1 ;
  
         0   0  (x1)  1    1     :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  1    1     :  0  :   0 ;   
         1   0  (x1)  1    1     :  1  :   1 ;
         0   0  (0x)  1    1     :  ?  :   - ;
         0   1  (0x)  1    1     :  0  :   0 ;
         1   0  (0x)  1    1     :  1  :   1 ;

                                 
         *   ?   ?    1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1     :  ?  :   - ;    // transitions on J and K
                                                 // with steady clock.

         ?   ?   ?    1    0     :  ?  :  1  ;    // Set.
         ?   ?   ?    0    ?     :  ?  :  0  ;    // clear and  clear override.

         ?   ? (?0)   1    1     :   ? :  -  ;    //ignore falling clock.
         ?   ? (1x)   1    1     :   ? :  -  ;
    
         x   0   r    1    1     :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    1    1     :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    1    1     :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    1    1     :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  1    1     :   1  :   1 ;        //possible clocked with
         0   x  (x1)  1    1     :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  1    1     :   1  :   1 ;
         0   x  (0x)  1    1     :   0  :   0 ;

         ?   ?   ?  (?1)   1     :  ?   :  -  ;    //ignore changes on set and
         ?   ?   ?   1   (?1)    :  ?   :  -  ;    //reset.


    endtable

endprimitive

 
primitive U_FJK_P_RB_SB_NO (Q, J, K, CP, RB, SB, NOTIFIER_REG); 
 
 
 
 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input
            SB;                                  // Set input  
// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//            ASYNCHRONOUS CLEAR AND  SET  ( Q OUTPUT UDP ).



    table
      // J   K   CP   RB   SB       NOTIFIER_REG  : Qtn : Qtn+1

         0   0  (01)  1    1           ?          :  ?  :   - ;    // Output retains the 

         0   1  (01)  1    1           ?          :  ?  :   0 ;    // Clocked J and K.
         0   1  (01)  x    1           ?          :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    1           ?          :  0  :   0 ;    // pessimism

         1   0  (01)  1    1           ?          :  ?  :   1 ;    
         1   0  (01)  1    x           ?          :  ?  :   1 ;    // pessimism
         ?   ?   ?    1    x           ?          :  1  :   1 ;    // pessimism

         1   1  (01)  1    1           ?          :  0  :   1 ;    // Clocked toggle.
         1   1  (01)  1    1           ?          :  1  :   0 ;
                                                     
         ?   1  (01)  x    1           ?          :  1  :   0 ;     //pessimism
         1   ?  (01)  1    x           ?          :  0  :   1 ;
  
         0   0  (x1)  1    1           ?          :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  1    1           ?          :  0  :   0 ;   
         1   0  (x1)  1    1           ?          :  1  :   1 ;
         0   0  (0x)  1    1           ?          :  ?  :   - ;
         0   1  (0x)  1    1           ?          :  0  :   0 ;
         1   0  (0x)  1    1           ?          :  1  :   1 ;

                                 
         *   ?   ?    1    1           ?          :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1           ?          :  ?  :   - ;    // transitions on J and K
                                                                   // with steady clock.

         ?   ?   ?    1    0           ?          :  ?  :   1 ;    // Set.
         ?   ?   ?    0    ?           ?          :  ?  :   0 ;    // clear and  clear override.

         ?   ? (?0)   1    1           ?          :  ?  :   - ;    //ignore falling clock.
         ?   ? (1x)   1    1           ?          :  ?  :   - ;
    
         x   0   r    1    1           ?          :  1  :   1 ;    // reducing pessimism for unknown J 
         x   1   r    1    1           ?          :  1  :   0 ;    // reducing pessimism for unknown J 
         0   x   r    1    1           ?          :  0  :   0 ;    // reducing pessimism for unknown K 
         1   x   r    1    1           ?          :  0  :   1 ;    // reducing pessimism for unknown K 

         x   0  (x1)  1    1           ?          :  1  :   1 ;    //possible clocked with
         0   x  (x1)  1    1           ?          :  0  :   0 ;    //possible J & K                                 
         x   0  (0x)  1    1           ?          :  1  :   1 ;
         0   x  (0x)  1    1           ?          :  0  :   0 ;

         ?   ?   ?  (?1)   1           ?          :  ?  :   - ;    //ignore changes on set and
         ?   ?   ?   1   (?1)          ?          :  ?  :   - ;    //reset.
         ?   ?   ?   ?     ?           *          :  ?  :   x ;

    endtable

endprimitive

 
primitive U_FJK_P_RB_SB_QN (QN, J, K, CP, RB, SB);
 
// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//            ASYNCHRONOUS CLEAR AND  SET  ( QN OUTPUT UDP ).  


    output QN;
    reg    QN;  
    input  J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB;                                  // Set input.
                                  

    table
      // J   K   CP   RB   SB     : Qtn : Qtn+1

         0   0  (01)  1    1     :  ?  :   - ;    // Output retains the 

         0   1  (01)  1    1     :  ?  :   1 ;    // Clocked J and K.
         0   1  (01)  x    1     :  ?  :   1 ;    // pessimism
         ?   ?   ?    x    1     :  1  :   1 ;    // pessimism

         1   0  (01)  1    1     :  ?  :   0 ;    
         1   0  (01)  1    x     :  ?  :   0 ;    // pessimism
         ?   ?   ?    1    x     :  0  :   0 ;    // pessimism

         1   1  (01)  1    1     :  1  :   0 ;    // Clocked toggle.
         1   1  (01)  1    1     :  0  :   1 ;
                                                     
         ?   1  (01)  x    1     :  0  :   1 ;     //pessimism
         1   ?  (01)  1    x     :  1  :   0 ;
  
         0   0  (x1)  1    1     :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  1    1     :  1  :   1 ;   
         1   0  (x1)  1    1     :  0  :   0 ;
         0   0  (0x)  1    1     :  ?  :   - ;
         0   1  (0x)  1    1     :  1  :   1 ;
         1   0  (0x)  1    1     :  0  :   0 ;

                                 
         *   ?   ?    1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1     :  ?  :   - ;    // transitions on J and K
                                                 // with steady clock.

         ?   ?   ?    1    0     :  ?  :  0  ;    // Set.
         ?   ?   ?    0    1     :  ?  :  1  ;    // clear 
         ?   ?   ?    0    0     :  ?  :  0  ;    // clear and  clear override. 

         ?   ? (?0)   1    1     :   ? :  -  ;    //ignore falling clock.
         ?   ? (1x)   1    1     :   ? :  -  ;
    
         x   0   r    1    1     :   0  :   0 ;         // reducing pessimism for unknown J 
         x   1   r    1    1     :   0  :   1 ;         // reducing pessimism for unknown J 
         0   x   r    1    1     :   1  :   1 ;         // reducing pessimism for unknown K 
         1   x   r    1    1     :   1  :   0 ;         // reducing pessimism for unknown K 

         x   0  (x1)  1    1     :   0  :   0 ;        //possible clocked with
         0   x  (x1)  1    1     :   1  :   1 ;        //possible J & K                                 
         x   0  (0x)  1    1     :   0  :   0 ;
         0   x  (0x)  1    1     :   1  :   1 ;

         ?   ?   ?  (?1)   1     :  ?   :  -  ;    //ignore changes on set and
         ?   ?   ?   1   (?1)    :  ?   :  -  ;    //reset.


    endtable

endprimitive

primitive U_FJK_P_RB_SB_X (Q, J, K, CP, RB, SB);
 
// FUNCTION :POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH ACTIVE LOW 
//           ASYNCHRONOUS CLEAR AND  SET  ( Q OUTPUT UDP )
//           OUTPUT GOES TO "x" WHEN BOTH CLEAR AND SET ARE ACTIVE 

    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB;                                  // Set input.
                                  

    table
      // J   K  CP  RB   SB     : Qtn : Qtn+1

         0   0  (01) 1    1     :  ?  :   - ;    // Output retains the 

         0   1  (01) 1    1     :  ?  :   0 ;    // Clocked J and K.
         0   1  (01) x    1     :  ?  :   0 ;    // pessimism
         ?   ?   ?   x    1     :  0  :   0 ;    // pessimism

         1   0  (01) 1    1     :  ?  :   1 ;    
         1   0  (01) 1    x     :  ?  :   1 ;    // pessimism
         ?   ?   ?   1    x     :  1  :   1 ;    // pessimism

         1   1  (01) 1    1     :  0  :   1 ;    // Clocked toggle.
         1   1  (01) 1    1     :  1  :   0 ;
         
         ?   1  (01) x    1     :  1  :   0 ;     //pessimism
         1   ?  (01) 1    x     :  0  :   1 ;


         0   0  (x1) 1    1     :  ?  :   - ;   //possible clocked JK
         0   1  (x1) 1    1     :  0  :   0 ;   
         1   0  (x1) 1    1     :  1  :   1 ;
         0   0  (0x) 1    1     :  ?  :   - ;
         0   1  (0x) 1    1     :  0  :   0 ;
         1   0  (0x) 1    1     :  1  :   1 ;

                                
         *   ?   ?   1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?   1    1     :  ?  :   - ;    // transitions on J and K
                                                 // with steady clock.

         ?   ?   ?   0    1     :  ?  :  0  ;    // Clear.
         ?   ?   ?   1    0     :  ?  :  1  ;    // Set.
         ?   ?   ?   0    0     :  ?  :  x  ;    // ILLEGAL 

         x   0   r   1    1     :  1  :  1  ;
         x   1   r   1    1     :  1  :  0  ;
         0   x   r   1    1     :  0  :  0  ;
         1   x   r   1    1     :  0  :  1  ;
         
         x   0 (x1)  1    1     :  1  :   1 ;        //possible clocked with
         0   x (x1)  1    1     :  0  :   0 ;        //possible J & K                                 
         x   0 (0x)  1    1     :  1  :   1 ;
         0   x (0x)  1    1     :  0  :   0 ;


         ?   ? (?0)  1    1      :   ? :  -  ;    //ignore falling clock.
         ?   ? (1x)  1    1      :   ? :  -  ;

         ?   ?   ? (?1)   1     :  ?  :  -  ;    //ignore changes on set and
         ?   ?   ?   1  (?1)    :  ?  :  -  ;    //reset.


    endtable

endprimitive

primitive U_FJK_P_R_NO (Q, J, K, CP, R, NOTIFIER_REG); 
 


    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // CLOCK.
            R;                                  // CLEAR INPUT.
// FUNCTION : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH CLEAR 
//            ACTIVE HIGH / STANDARD DRIVE ( Q OUTPUT UDP )


    table
      // J   K   CP   R      NOTIFIER_REG  :  Qtn : Qtn+1

         0   0  (01)  0         ?          :   ?  :   - ;         // Output retains the 
                                                 // present state if both 
                                                 // J and K are 0.

         0   1  (01)  0         ?          :   ?  :   0 ;         // Clocked J and K.
         1   0  (01)  0         ?          :   ?  :   1 ;    

         0   1  (01)  x         ?          :   ?  :   0 ;         // pessimism
         ?   ?   ?    x         ?          :   0  :   0 ;         // pessimism

         1   1  (01)  0         ?          :   0  :   1 ;         // Clocked toggle.
         1   1  (01)  0         ?          :   1  :   0 ;

         ?   1  (01)  x         ?          :   1  :   0 ;         // pessimism

         0   0  (x1)  0         ?          :   ?  :   - ;         //possible clocked JK
         0   1  (x1)  0         ?          :   0  :   0 ;   
         1   0  (x1)  0         ?          :   1  :   1 ;
         0   0  (0x)  0         ?          :   ?  :   - ;
         0   1  (0x)  0         ?          :   0  :   0 ;
         1   0  (0x)  0         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                 // with steady clock.
         ?   ? (?0)   0         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   0         ?          :   ?  :   - ;
                                         
         x   0   r    0         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    0         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    0         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    0         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  0         ?          :   1  :   1 ;        //possible clocked with
         0   x  (x1)  0         ?          :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  0         ?          :   1  :   1 ;
         0   x  (0x)  0         ?          :   0  :   0 ;

         ?   ?   ?    1         ?          :   ?  :   0 ;         // Clear. 

         ?   ?   ?   (?0)       ?          :   ?  :   - ;         // Insensitive to a rising
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on RESET.


    endtable

endprimitive

primitive U_FJK_P_S (Q, J, K, CP, S);
 

// FUNCTION : POSITIVE EDGE TRIGGERED J K FLIP FLOP, WITH
//            ASYNCHRONOUS ACTIVE HIGH SET  ( Q OUTPUT UDP )  


    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // CLOCK.
            S;                                  // SET INPUT.

    table
      // J   K   CP   S   :  Qtn : Qtn+1

         0   0  (01)  0   :   ?  :   - ;         // Output retains the 
                                                 // present state if both 
                                                 // J and K are 0.

         0   1  (01)  0   :   ?  :   0 ;         // Clocked J and K.
         1   0  (01)  0   :   ?  :   1 ;    

         1   0  (01)  x   :   ?  :   1 ;         // pessimism
         ?   ?   ?    x   :   1  :   1 ;         // pessimism

         1   1  (01)  0   :   0  :   1 ;         // Clocked toggle.
         1   1  (01)  0   :   1  :   0 ;

         1   ?  (01)  x   :   0  :   1 ;         // pessimism

         0   0  (x1)  0   :   ?  :   - ;         //possible clocked JK
         0   1  (x1)  0   :   0  :   0 ;   
         1   0  (x1)  0   :   1  :   1 ;
         0   0  (0x)  0   :   ?  :   - ;
         0   1  (0x)  0   :   0  :   0 ;
         1   0  (0x)  0   :   1  :   1 ;


         *   ?   ?    ?   :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?   :   ?  :   - ;         // transitions on J and K
                                                 // with steady clock.
         ?   ? (?0)   0   :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   0   :   ?  :   - ;
                                         
         x   0   r    0   :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    0   :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    0   :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    0   :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  0   :   1  :   1 ;        //possible clocked with
         0   x  (x1)  0   :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  0   :   1  :   1 ;
         0   x  (0x)  0   :   0  :   0 ;

         ?   ?   ?    1   :   ?  :   1 ;         // SET. 

         ?   ?   ?   (?0) :   ?  :   - ;         // Insensitive to a rising
                                                 // edge on SET.


    endtable

endprimitive

primitive U_FJK_P_SB (Q, J, K, CP, SB);
 

// FUNCTION : POSITIVE EDGE TRIGGERED J K FLIP FLOP, WITH
//            ASYNCHRONOUS ACTIVE LOW SET  ( Q OUTPUT UDP )  


    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // CLOCK.
            SB;                                  // SET INPUT.

    table
      // J   K   CP  SB   :  Qtn : Qtn+1

         0   0  (01)  1   :   ?  :   - ;         // Output retains the 
                                                 // present state if both 
                                                 // J and K are 0.

         0   1  (01)  1   :   ?  :   0 ;         // Clocked J and K.
         1   0  (01)  1   :   ?  :   1 ;    

         1   0  (01)  x   :   ?  :   1 ;         // pessimism
         ?   ?   ?    x   :   1  :   1 ;         // pessimism

         1   1  (01)  1   :   0  :   1 ;         // Clocked toggle.
         1   1  (01)  1   :   1  :   0 ;

         1   ?  (01)  x   :   0  :   1 ;         // pessimism

         0   0  (x1)  1   :   ?  :   - ;         //possible clocked JK
         0   1  (x1)  1   :   0  :   0 ;   
         1   0  (x1)  1   :   1  :   1 ;
         0   0  (0x)  1   :   ?  :   - ;
         0   1  (0x)  1   :   0  :   0 ;
         1   0  (0x)  1   :   1  :   1 ;


         *   ?   ?    ?   :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?   :   ?  :   - ;         // transitions on J and K
                                                 // with steady clock.
         ?   ? (?0)   1   :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   1   :   ?  :   - ;
                                         
         x   0   r    1   :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    1   :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    1   :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    1   :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  1   :   1  :   1 ;        //possible clocked with
         0   x  (x1)  1   :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  1   :   1  :   1 ;
         0   x  (0x)  1   :   0  :   0 ;

         ?   ?   ?    0   :   ?  :   1 ;         // SET. 

         ?   ?   ?   (?1) :   ?  :   - ;         // Insensitive to a rising
                                                 // edge on SB.


    endtable

endprimitive

primitive U_FJK_P_SB_NO (Q, J, K, CP, SB, NOTIFIER_REG); 
 



    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // CLOCK.
            SB;                                  // SET INPUT.
// FUNCTION : POSITIVE EDGE TRIGGERED J K FLIP FLOP, WITH
//            ASYNCHRONOUS ACTIVE LOW SET  ( Q OUTPUT UDP )  



    table
      // J   K   CP  SB      NOTIFIER_REG  :  Qtn : Qtn+1

         0   0  (01)  1         ?          :   ?  :   - ;         // Output retains the 
                                                                // present state if both 
                                                                 // J and K are 0.

         0   1  (01)  1         ?          :   ?  :   0 ;         // Clocked J and K.
         1   0  (01)  1         ?          :   ?  :   1 ;    

         1   0  (01)  x         ?          :   ?  :   1 ;         // pessimism
         ?   ?   ?    x         ?          :   1  :   1 ;         // pessimism

         1   1  (01)  1         ?          :   0  :   1 ;         // Clocked toggle.
         1   1  (01)  1         ?          :   1  :   0 ;

         1   ?  (01)  x         ?          :   0  :   1 ;         // pessimism

         0   0  (x1)  1         ?          :   ?  :   - ;         //possible clocked JK
         0   1  (x1)  1         ?          :   0  :   0 ;   
         1   0  (x1)  1         ?          :   1  :   1 ;
         0   0  (0x)  1         ?          :   ?  :   - ;
         0   1  (0x)  1         ?          :   0  :   0 ;
         1   0  (0x)  1         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                 // with steady clock.
         ?   ? (?0)   1         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   1         ?          :   ?  :   - ;
                                         
         x   0   r    1         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    1         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    1         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    1         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  1         ?          :   1  :   1 ;        //possible clocked with
         0   x  (x1)  1         ?          :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  1         ?          :   1  :   1 ;
         0   x  (0x)  1         ?          :   0  :   0 ;

         ?   ?   ?    0         ?          :   ?  :   1 ;         // SET. 

         ?   ?   ?   (?1)       ?          :   ?  :   - ;         // Insensitive to a rising
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on SB

    endtable

endprimitive

 
primitive U_FJK_P_SB_RB (Q, J, K, CP, RB, SB);
 
// FUNCTION  : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE LOW ASYNCHRONOUS CLEAR AND SET ( Q OUTPUT UDP )
//            

    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB;                                  // Set input.
                                  

    table
      // J   K   CP   RB   SB     : Qtn : Qtn+1

         0   0  (01)  1    1     :  ?  :   - ;    // Output retains the 

         0   1  (01)  1    1     :  ?  :   0 ;    // Clocked J and K.
         0   1  (01)  x    1     :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    1     :  0  :   0 ;    // pessimism

         1   0  (01)  1    1     :  ?  :   1 ;    
         1   0  (01)  1    x     :  ?  :   1 ;    // pessimism
         ?   ?   ?    1    x     :  1  :   1 ;    // pessimism

         1   1  (01)  1    1     :  0  :   1 ;    // Clocked toggle.
         1   1  (01)  1    1     :  1  :   0 ;
                                                     
         ?   1  (01)  x    1     :  1  :   0 ;     //pessimism
         1   ?  (01)  1    x     :  0  :   1 ;
  
         0   0  (x1)  1    1     :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  1    1     :  0  :   0 ;   
         1   0  (x1)  1    1     :  1  :   1 ;
         0   0  (0x)  1    1     :  ?  :   - ;
         0   1  (0x)  1    1     :  0  :   0 ;
         1   0  (0x)  1    1     :  1  :   1 ;

                                 
         *   ?   ?    1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1     :  ?  :   - ;    // transitions on J and K
                                                 // with steady clock.

         ?   ?   ?    ?    0     :  ?  :  1  ;    // Set 
         ?   ?   ?    0    1     :  ?  :  0  ;    // clear
 
         ?   ? (?0)   1    1     :   ? :  -  ;    //ignore falling clock.
         ?   ? (1x)   1    1     :   ? :  -  ;
    
         x   0   r    1    1     :   1 :   1 ;         // reducing pessimism for unknown J 
         x   1   r    1    1     :   1 :   0 ;         // reducing pessimism for unknown J 
         0   x   r    1    1     :   0 :   0 ;         // reducing pessimism for unknown K 
         1   x   r    1    1     :   0 :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  1    1     :   1 :   1 ;        //possible clocked with
         0   x  (x1)  1    1     :   0 :   0 ;        //possible J & K                                 
         x   0  (0x)  1    1     :   1 :   1 ;
         0   x  (0x)  1    1     :   0 :   0 ;

         ?   ?   ?  (?1)   1     :  ?  :  -  ;    //ignore changes on set and
         ?   ?   ?   1   (?1)    :  ?  :  -  ;    //reset.


    endtable

endprimitive

 
primitive U_FJK_P_SB_RB_NO (Q, J, K, CP, RB, SB, NOTIFIER_REG); 
 
 
 
 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input
            SB;                                  // Set input  
// FUNCTION  : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE LOW ASYNCHRONOUS CLEAR AND SET ( Q OUTPUT UDP )
//           


    table
      // J   K   CP   RB   SB       NOTIFIER_REG  : Qtn : Qtn+1

         0   0  (01)  1    1           ?          :  ?  :   - ;    // Output retains the 

         0   1  (01)  1    1           ?          :  ?  :   0 ;    // Clocked J and K.
         0   1  (01)  x    1           ?          :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    1           ?          :  0  :   0 ;    // pessimism

         1   0  (01)  1    1           ?          :  ?  :   1 ;    
         1   0  (01)  1    x           ?          :  ?  :   1 ;    // pessimism
         ?   ?   ?    1    x           ?          :  1  :   1 ;    // pessimism

         1   1  (01)  1    1           ?          :  0  :   1 ;    // Clocked toggle.
         1   1  (01)  1    1           ?          :  1  :   0 ;
                                                     
         ?   1  (01)  x    1           ?          :  1  :   0 ;     //pessimism
         1   ?  (01)  1    x           ?          :  0  :   1 ;
  
         0   0  (x1)  1    1           ?          :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  1    1           ?          :  0  :   0 ;   
         1   0  (x1)  1    1           ?          :  1  :   1 ;
         0   0  (0x)  1    1           ?          :  ?  :   - ;
         0   1  (0x)  1    1           ?          :  0  :   0 ;
         1   0  (0x)  1    1           ?          :  1  :   1 ;

                                 
         *   ?   ?    1    1           ?          :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1           ?          :  ?  :   - ;    // transitions on J and K
                                                                   // with steady clock.

         ?   ?   ?    ?    0           ?          :  ?  :   1 ;    // Set.
         ?   ?   ?    0    1           ?          :  ?  :   0 ;    // clear and  clear override.

         ?   ? (?0)   1    1           ?          :  ?  :   - ;    //ignore falling clock.
         ?   ? (1x)   1    1           ?          :  ?  :   - ;
    
         x   0   r    1    1           ?          :  1  :   1 ;    // reducing pessimism for unknown J 
         x   1   r    1    1           ?          :  1  :   0 ;    // reducing pessimism for unknown J 
         0   x   r    1    1           ?          :  0  :   0 ;    // reducing pessimism for unknown K 
         1   x   r    1    1           ?          :  0  :   1 ;    // reducing pessimism for unknown K 

         x   0  (x1)  1    1           ?          :  1  :   1 ;    //possible clocked with
         0   x  (x1)  1    1           ?          :  0  :   0 ;    //possible J & K                                 
         x   0  (0x)  1    1           ?          :  1  :   1 ;
         0   x  (0x)  1    1           ?          :  0  :   0 ;

         ?   ?   ?  (?1)   1           ?          :  ?  :   - ;    //ignore changes on set and
         ?   ?   ?   1   (?1)          ?          :  ?  :   - ;    //reset.
         ?   ?   ?   ?     ?           *          :  ?  :   x ;

    endtable

endprimitive

 
primitive U_FJK_P_SB_RB_QN (QN, J, K, CP, RB, SB);
 
// FUNCTION  : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE LOW ASYNCHRONOUS CLEAR AND SET ( QN OUTPUT UDP )
//             


    output QN;
    reg    QN;  
    input  J,K,
            CP,                                  // Clock.
            RB,                                  // Clear input.
            SB;                                  // Set input.
                                  

    table
      // J   K   CP   RB   SB     : Qtn : Qtn+1

         0   0  (01)  1    1     :  ?  :   - ;    // Output retains the 

         0   1  (01)  1    1     :  ?  :   1 ;    // Clocked J and K.
         0   1  (01)  x    1     :  ?  :   1 ;    // pessimism
         ?   ?   ?    x    1     :  1  :   1 ;    // pessimism

         1   0  (01)  1    1     :  ?  :   0 ;    
         1   0  (01)  1    x     :  ?  :   0 ;    // pessimism
         ?   ?   ?    1    x     :  0  :   0 ;    // pessimism

         1   1  (01)  1    1     :  1  :   0 ;    // Clocked toggle.
         1   1  (01)  1    1     :  0  :   1 ;
                                                     
         ?   1  (01)  x    1     :  0  :   1 ;     //pessimism
         1   ?  (01)  1    x     :  1  :   0 ;
  
         0   0  (x1)  1    1     :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  1    1     :  1  :   1 ;   
         1   0  (x1)  1    1     :  0  :   0 ;
         0   0  (0x)  1    1     :  ?  :   - ;
         0   1  (0x)  1    1     :  1  :   1 ;
         1   0  (0x)  1    1     :  0  :   0 ;

                                 
         *   ?   ?    1    1     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    1    1     :  ?  :   - ;    // transitions on J and K
                                                 // with steady clock.

         ?   ?   ?    1    0     :  ?  :  0  ;    // Set 
         ?   ?   ?    0    0     :  ?  :  1  ;    
         ?   ?   ?    0    1     :  ?  :  1  ;    // clear
 
         ?   ? (?0)   1    1     :   ? :  -  ;    //ignore falling clock.
         ?   ? (1x)   1    1     :   ? :  -  ;
    
         x   0   r    1    1     :   0 :   0 ;         // reducing pessimism for unknown J 
         x   1   r    1    1     :   0 :   1 ;         // reducing pessimism for unknown J 
         0   x   r    1    1     :   1 :   1 ;         // reducing pessimism for unknown K 
         1   x   r    1    1     :   1 :   0 ;         // reducing pessimism for unknown K 

         x   0  (x1)  1    1     :   0 :   0 ;        //possible clocked with
         0   x  (x1)  1    1     :   1 :   1 ;        //possible J & K                                 
         x   0  (0x)  1    1     :   0 :   0 ;
         0   x  (0x)  1    1     :   1 :   1 ;

         ?   ?   ?  (?1)   1     :  ?  :  -  ;    //ignore changes on set and
         ?   ?   ?   1   (?1)    :  ?  :  -  ;    //reset.


    endtable

endprimitive

primitive U_FJK_P_S_NO (Q, J, K, CP, S, NOTIFIER_REG); 
 



    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // CLOCK.
            S;                                  // SET INPUT.
// FUNCTION : POSITIVE EDGE TRIGGERED J K FLIP FLOP, WITH
//            ASYNCHRONOUS ACTIVE HIGH SET  ( Q OUTPUT UDP )  



    table
      // J   K   CP   S      NOTIFIER_REG  :  Qtn : Qtn+1

         0   0  (01)  0         ?          :   ?  :   - ;         // Output retains the 
                                                                  // present state if both 
                                                                  // J and K are 0.

         0   1  (01)  0         ?          :   ?  :   0 ;         // Clocked J and K.
         1   0  (01)  0         ?          :   ?  :   1 ;    

         1   0  (01)  x         ?          :   ?  :   1 ;         // pessimism
         ?   ?   ?    x         ?          :   1  :   1 ;         // pessimism

         1   1  (01)  0         ?          :   0  :   1 ;         // Clocked toggle.
         1   1  (01)  0         ?          :   1  :   0 ;

         1   ?  (01)  x         ?          :   0  :   1 ;         // pessimism

         0   0  (x1)  0         ?          :   ?  :   - ;         //possible clocked JK
         0   1  (x1)  0         ?          :   0  :   0 ;   
         1   0  (x1)  0         ?          :   1  :   1 ;
         0   0  (0x)  0         ?          :   ?  :   - ;
         0   1  (0x)  0         ?          :   0  :   0 ;
         1   0  (0x)  0         ?          :   1  :   1 ;


         *   ?   ?    ?         ?          :   ?  :   - ;         // Insensitive to 
         ?   *   ?    ?         ?          :   ?  :   - ;         // transitions on J and K
                                                                   // with steady clock.
         ?   ? (?0)   0         ?          :   ?  :   - ;         //ignore falling clock.
         ?   ? (1x)   0         ?          :   ?  :   - ;
                                         
         x   0   r    0         ?          :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    0         ?          :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    0         ?          :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    0         ?          :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  0         ?          :   1  :   1 ;        //possible clocked with
         0   x  (x1)  0         ?          :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  0         ?          :   1  :   1 ;
         0   x  (0x)  0         ?          :   0  :   0 ;

         ?   ?   ?    1         ?          :   ?  :   1 ;         // SET. 

         ?   ?   ?   (?0)       ?          :   ?  :   - ;         // Insensitive to a falling
         ?   ?   ?    ?         *          :   ?  :   x ;         // edge on SET .


    endtable

endprimitive

 
primitive U_FJK_P_S_R (Q, J, K, CP, R, S);
 
// FUNCTION  : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE HIGH ASYNCHRONOUS CLEAR AND SET ( Q OUTPUT UDP )

    output Q;
    reg    Q;  
    input  J,K,
            CP,                                  // Clock.
            R,                                  // Clear input.
            S;                                  // Set input.
                                  

    table
      // J   K   CP   R    S     : Qtn : Qtn+1

         0   0  (01)  0    0     :  ?  :   - ;    // Output retains the previous value

         0   1  (01)  0    0     :  ?  :   0 ;    // Clocked J and K.
         0   1  (01)  x    0     :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    0     :  0  :   0 ;    // pessimism

         1   0  (01)  0    0     :  ?  :   1 ;    
         1   0  (01)  0    x     :  ?  :   1 ;    // pessimism
         ?   ?   ?    0    x     :  1  :   1 ;    // pessimism

         1   1  (01)  0    0     :  0  :   1 ;    // Clocked toggle.
         1   1  (01)  0    0     :  1  :   0 ;
                                                     
         ?   1  (01)  x    0     :  1  :   0 ;     //pessimism
         1   ?  (01)  0    x     :  0  :   1 ;
  
         0   0  (x1)  0    0     :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  0    0     :  0  :   0 ;   
         1   0  (x1)  0    0     :  1  :   1 ;
         0   0  (0x)  0    0     :  ?  :   - ;
         0   1  (0x)  0    0     :  0  :   0 ;
         1   0  (0x)  0    0     :  1  :   1 ;

                                 
         *   ?   ?    0    0     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    0    0     :  ?  :   - ;    // transitions on J and K
                                                 // with steady clock.

         ?   ?   ?    ?    1     :  ?  :  1  ;    // Set.
         ?   ?   ?    1    0     :  ?  :  0  ;    // clear

         ?   ? (?0)   0    0     :   ? :  -  ;    //ignore falling clock.
         ?   ? (1x)   0    0     :   ? :  -  ;
    
         x   0   r    0    0     :   1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    0    0     :   1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    0    0     :   0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    0    0     :   0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  0    0     :   1  :   1 ;        //possible clocked with
         0   x  (x1)  0    0     :   0  :   0 ;        //possible J & K                                 
         x   0  (0x)  0    0     :   1  :   1 ;
         0   x  (0x)  0    0     :   0  :   0 ;

         ?   ?   ?  (?0)   0     :  ?   :  -  ;    //ignore changes on set and
         ?   ?   ?   0   (?0)    :  ?   :  -  ;    //reset.


    endtable

endprimitive

 
primitive U_FJK_P_S_R_NO (Q, J, K, CP, R, S, NOTIFIER_REG); 
 
 
 
 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // Clock.
            R,                                  // Clear input 
            S;                                  // Set input
// FUNCTION  : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE HIGH ASYNCHRONOUS CLEAR AND SET ( Q OUTPUT UDP )


    table
      // J   K   CP   R    S        NOTIFIER_REG  : Qtn : Qtn+1

         0   0  (01)  0    0           ?          :  ?  :   - ;    // Output retains the 

         0   1  (01)  0    0           ?          :  ?  :   0 ;    // Clocked J and K.
         0   1  (01)  x    0           ?          :  ?  :   0 ;    // pessimism
         ?   ?   ?    x    0           ?          :  0  :   0 ;    // pessimism

         1   0  (01)  0    0           ?          :  ?  :   1 ;    
         1   0  (01)  0    x           ?          :  ?  :   1 ;    // pessimism
         ?   ?   ?    0    x           ?          :  1  :   1 ;    // pessimism

         1   1  (01)  0    0           ?          :  0  :   1 ;    // Clocked toggle.
         1   1  (01)  0    0           ?          :  1  :   0 ;
                                                     
         ?   1  (01)  x    0           ?          :  1  :   0 ;     //pessimism
         1   ?  (01)  0    x           ?          :  0  :   1 ;
  
         0   0  (x1)  0    0           ?          :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  0    0           ?          :  0  :   0 ;   
         1   0  (x1)  0    0           ?          :  1  :   1 ;
         0   0  (0x)  0    0           ?          :  ?  :   - ;
         0   1  (0x)  0    0           ?          :  0  :   0 ;
         1   0  (0x)  0    0           ?          :  1  :   1 ;

                                 
         *   ?   ?    0    0           ?          :  ?  :   - ;    // Insensitive to 
         ?   *   ?    0    0           ?          :  ?  :   - ;    // transitions on J and K
                                                                   // with steady clock.

         ?   ?   ?    ?    1           ?          :  ?  :   1 ;    // Set.
         ?   ?   ?    1    0           ?          :  ?  :   0 ;    // clear

         ?   ? (?0)   0    0           ?          :  ?  :   - ;    //ignore falling clock.
         ?   ? (1x)   0    0           ?          :  ?  :   - ;
    
         x   0   r    0    0           ?          :  1  :   1 ;         // reducing pessimism for unknown J 
         x   1   r    0    0           ?          :  1  :   0 ;         // reducing pessimism for unknown J 
         0   x   r    0    0           ?          :  0  :   0 ;         // reducing pessimism for unknown K 
         1   x   r    0    0           ?          :  0  :   1 ;         // reducing pessimism for unknown K 

         x   0  (x1)  0    0           ?          :  1  :   1 ;        //possible clocked with
         0   x  (x1)  0    0           ?          :  0  :   0 ;        //possible J & K                                 
         x   0  (0x)  0    0           ?          :  1  :   1 ;
         0   x  (0x)  0    0           ?          :  0  :   0 ;

         ?   ?   ?  (?0)   0           ?          :  ?  :   - ;    //ignore changes on set and
         ?   ?   ?   0   (?0)          ?          :  ?  :   - ;    //reset.
         ?   ?   ?   ?     ?           *          :  ?  :   x ; 

    endtable

endprimitive

 
primitive U_FJK_P_S_R_NO_QN (QN, J, K, CP, R, S, NOTIFIER_REG); 
 
 
 
 

    output QN;
    reg    QN;  
    input  NOTIFIER_REG,
           J,K,
            CP,                                  // Clock.
            R,                                  // Clear input
            S;                                  // Set input  
// FUNCTION  : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE HIGH ASYNCHRONOUS CLEAR AND SET ( QN OUTPUT UDP )


    table
      // J   K   CP   R   S        NOTIFIER_REG  : Qtn : Qtn+1

         0   0  (01)  0    0           ?          :  ?  :   - ;    // Output retains the 

         0   1  (01)  0    0           ?          :  ?  :   1 ;    // Clocked J and K.
         0   1  (01)  x    0           ?          :  ?  :   1 ;    // pessimism
         ?   ?   ?    x    0           ?          :  1  :   1 ;    // pessimism

         1   0  (01)  0    0           ?          :  ?  :   0 ;    
         1   0  (01)  0    x           ?          :  ?  :   0 ;    // pessimism
         ?   ?   ?    0    x           ?          :  0  :   0 ;    // pessimism

         1   1  (01)  0    0           ?          :  1  :   0 ;    // Clocked toggle.
         1   1  (01)  0    0           ?          :  0  :   1 ;
                                                     
         ?   1  (01)  x    0           ?          :  0  :   1 ;     //pessimism
         1   ?  (01)  0    x           ?          :  1  :   0 ;
  
         0   0  (x1)  0    0           ?          :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  0    0           ?          :  1  :   1 ;   
         1   0  (x1)  0    0           ?          :  0  :   0 ;
         0   0  (0x)  0    0           ?          :  ?  :   - ;
         0   1  (0x)  0    0           ?          :  1  :   1 ;
         1   0  (0x)  0    0           ?          :  0  :   0 ;

                                 
         *   ?   ?    0    0           ?          :  ?  :   - ;    // Insensitive to 
         ?   *   ?    0    0           ?          :  ?  :   - ;    // transitions on J and K
                                                                   // with steady clock.

         ?   ?   ?    0    1           ?          :  ?  :   0 ;    // Set.
         ?   ?   ?    1    0           ?          :  ?  :   1 ;    // clear
         ?   ?   ?    1    1           ?          :  ?  :   1 ;    // Set override


         ?   ? (?0)   0    0           ?          :  ?  :   - ;    //ignore falling clock.
         ?   ? (1x)   0    0           ?          :  ?  :   - ;
    
         x   0   r    0    0           ?          :  0  :   0 ;         // reducing pessimism for unknown J 
         x   1   r    0    0           ?          :  0  :   1 ;         // reducing pessimism for unknown J 
         0   x   r    0    0           ?          :  1  :   1 ;         // reducing pessimism for unknown K 
         1   x   r    0    0           ?          :  1  :   0 ;         // reducing pessimism for unknown K 

         x   0  (x1)  0    0           ?          :  0  :   0 ;        //possible clocked with
         0   x  (x1)  0    0           ?          :  1  :   1 ;        //possible J & K                                 
         x   0  (0x)  0    0           ?          :  0  :   0 ;
         0   x  (0x)  0    0           ?          :  1  :   1 ;

         ?   ?   ?  (?0)   0           ?          :  ?  :   - ;    //ignore changes on set and
         ?   ?   ?   0   (?0)          ?          :  ?  :   - ;    //reset.
         ?   ?   ?   ?     ?           *          :  ?  :   x ;

    endtable

endprimitive

 
primitive U_FJK_P_S_R_QN (QN, J, K, CP, R, S);
 
// FUNCTION  : POSITIVE EDGE TRIGGERED JK FLIP FLOP, WITH 
//             ACTIVE HIGH ASYNCHRONOUS CLEAR AND SET ( QN OUTPUT UDP )

    output QN;
    reg    QN;  
    input  J,K,
            CP,                                  // Clock.
            R,                                  // Clear input.
            S;                                  // Set input.
                                  

    table
      // J   K   CP   R    S     : Qtn : Qtn+1

         0   0  (01)  0    0     :  ?  :   - ;    // Output retains the 

         0   1  (01)  0    0     :  ?  :   1 ;    // Clocked J and K.
         0   1  (01)  x    0     :  ?  :   1 ;    // pessimism
         ?   ?   ?    x    0     :  1  :   1 ;    // pessimism

         1   0  (01)  0    0     :  ?  :   0 ;    
         1   0  (01)  0    x     :  ?  :   0 ;    // pessimism
         ?   ?   ?    0    x     :  0  :   0 ;    // pessimism

         1   1  (01)  0    0     :  1  :   0 ;    // Clocked toggle.
         1   1  (01)  0    0     :  0  :   1 ;
                                                     
         ?   1  (01)  x    0     :  0  :   1 ;     //pessimism
         1   ?  (01)  0    x     :  1  :   0 ;
  
         0   0  (x1)  0    0     :  ?  :   - ;   //possible clocked JK
         0   1  (x1)  0    0     :  1  :   1 ;   
         1   0  (x1)  0    0     :  0  :   0 ;
         0   0  (0x)  0    0     :  ?  :   - ;
         0   1  (0x)  0    0     :  1  :   1 ;
         1   0  (0x)  0    0     :  0  :   0 ;

                                 
         *   ?   ?    0    0     :  ?  :   - ;    // Insensitive to 
         ?   *   ?    0    0     :  ?  :   - ;    // transitions on J and K
                                                 // with steady clock.

         ?   ?   ?    0    1     :  ?  :  0  ;    // Set.
         ?   ?   ?    1    ?     :  ?  :  1  ;    // clear

         ?   ? (?0)   0    0     :   ? :  -  ;    //ignore falling clock.
         ?   ? (1x)   0    0     :   ? :  -  ;
    
         x   0   r    0    0     :   0  :   0 ;         // reducing pessimism for unknown J 
         x   1   r    0    0     :   0  :   1 ;         // reducing pessimism for unknown J 
         0   x   r    0    0     :   1  :   1 ;         // reducing pessimism for unknown K 
         1   x   r    0    0     :   1  :   0 ;         // reducing pessimism for unknown K 

         x   0  (x1)  0    0     :   0  :   0 ;        //possible clocked with
         0   x  (x1)  0    0     :   1  :   1 ;        //possible J & K                                 
         x   0  (0x)  0    0     :   0  :   0 ;
         0   x  (0x)  0    0     :   1  :   1 ;

         ?   ?   ?  (?0)   0     :  ?   :  -  ;    //ignore changes on set and
         ?   ?   ?   0   (?0)    :  ?   :  -  ;    //reset.


    endtable

endprimitive
primitive U_FRS_N (Q, S, R, CP);

     output Q; 
     reg    Q;        
     input  S,
            R,
            CP;
                                                                                                                 
// FUNCTION : R-S FLIP-FLOP ( Q OUTPUT UDP ) .
//            

   table
       // S   R   CP      Qtn   Qtn+1

          0   0  (10)    :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (10)    :  ?  :   0 ;    // Clocked R and S.
                      
          1   0  (10)    :  ?  :   1 ;    

          0   0  (1x)    :  ?  :   - ;    // possible clocked RS
          ?   1  (1x)    :  0  :   0 ;   
          1   0  (1x)    :  1  :   1 ;
          0   0  (x0)    :  ?  :   - ;
          ?   1  (x0)    :  0  :   0 ;
          1   0  (x0)    :  1  :   1 ; 
                                                                                                                  
          0   x  (x0)    :  0  :   0 ;
          x   0  (x0)    :  1  :   1 ;
          0   x  (1x)    :  0  :   0 ;
          x   0  (1x)    :  1  :   1 ;
                        
          *   ?   ?      :  ?  :   - ;    // Insensitive to 
          ?   *   ?      :  ?  :   - ;    // transitions on R and S


          ?   ? (?1)     :   ? :  -  ;    
          ?   ? (0x)     :   ? :  -  ;

          x   0   f      :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   f      :  0  :  0  ;    // reducing pessimism for unknown R 

   endtable
endprimitive
primitive U_FRS_N_NO (Q, S, R, CP, NOTIFIER_REG); 

     output Q; 
     reg    Q;        
     input  NOTIFIER_REG,
           S,
           R,
           CP;
                                                                                                                 
// FUNCTION : R-S FLIP-FLOP ( Q OUTPUT UDP ) .
//            
   table
       // S   R   CP     NOTIFIER_REG  Qtn   Qtn+1
                     
          0   0  (10)      ?          :  ?  :   - ;    // Output retains the previous value
                     
          ?   1  (10)      ?          :  ?  :   0 ;    // Clocked R and S.
                      
          1   0  (10)      ?          :  ?  :   1 ;    
                     
          0   0  (1x)      ?          :  ?  :   - ;    // possible clocked RS
          ?   1  (1x)      ?          :  0  :   0 ;   
          1   0  (1x)      ?          :  1  :   1 ;
          0   0  (x0)      ?          :  ?  :   - ;
          ?   1  (x0)      ?          :  0  :   0 ;
          1   0  (x0)      ?          :  1  :   1 ; 
                                                                                                              
          0   x  (x0)      ?          :  0  :   0 ;
          x   0  (x0)      ?          :  1  :   1 ;
          0   x  (1x)      ?          :  0  :   0 ;
          x   0  (1x)      ?          :  1  :   1 ;
                       
          *   ?   ?        ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?        ?          :  ?  :   - ;    // transitions on R and S
                     
                     
          ?   ? (?1)       ?          :   ? :  -  ;    
          ?   ? (0x)       ?          :   ? :  -  ;
                     
          x   0   f        ?          :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   f        ?          :  0  :  0  ;    // reducing pessimism for unknown R 

          ?   ?   ?        *          :  ?  :  x  ;

   endtable
endprimitive
primitive U_FRS_N_NO_QN (QN, S, R, CP, NOTIFIER_REG); 

     output QN; 
     reg    QN;        
     input  NOTIFIER_REG,
            S,
            R,
           CP;
                                                                                                                 
// FUNCTION : R-S FLIP-FLOP ( QN OUTPUT UDP ) .
//            

   table
       // S   R    CP     NOTIFIER_REG     Qtn   Qtn+1
                      
          0   0   (10)         ?          :  ?  :   - ;    // Output retains the previous value
                      
          0   1   (10)         ?          :  ?  :   1 ;    // Clocked R and S.
                      
          1   ?   (10)         ?          :  ?  :   0 ;    
                      
          0   0   (1x)         ?          :  ?  :   - ;    // possible clocked RS
          0   1   (1x)         ?          :  1  :   1 ;   
          1   ?   (1x)         ?          :  0  :   0 ;
          0   0   (x0)         ?          :  ?  :   - ;
          0   1   (x0)         ?          :  1  :   1 ;
          1   ?   (x0)         ?          :  0  :   0 ; 
                                                                                                                  
          0   x   (x0)         ?          :  1  :   1 ;
          x   0   (x0)         ?          :  0  :   0 ;
          0   x   (1x)         ?          :  1  :   1 ;
          x   0   (1x)         ?          :  0  :   0 ;
                        
          *   ?    ?           ?          :  ?  :   - ;    // Insensitive to 
          ?   *    ?           ?          :  ?  :   - ;    // transitions on R and S
                      
                      
          ?   ?  (?1)          ?          :   ? :  -  ;    
          ?   ?  (0x)          ?          :   ? :  -  ;
                      
          x   0    f           ?          :  0  :  0  ;    // reducing pessimism for unknown S 
          0   x    f           ?          :  1  :  1  ;    // reducing pessimism for unknown R 
          ?   ?    ?           *          :  ?  :   x ;      

   endtable
endprimitive
primitive U_FRS_N_QN (QN, S, R, CP);

     output QN; 
     reg    QN;        
     input  S,
            R,
            CP;
                                                                                                                 
// FUNCTION : NEGATIVE EDGE TRIGGERED R-S FLIP-FLOP ( QN OUTPUT UDP ) .
//            

   table
       // S   R   CP      Qtn   Qtn+1
                     
          0   0  (10)    :  ?  :   - ;    // Output retains the previous value
                     
          0   1  (10)    :  ?  :   1 ;    // Clocked R and S.
                      
          1   ?  (10)    :  ?  :   0 ;    
                     
          0   0  (1x)    :  ?  :   - ;    // possible clocked RS
          0   1  (1x)    :  1  :   1 ;   
          1   ?  (1x)    :  0  :   0 ;
          0   0  (x0)    :  ?  :   - ;
          0   1  (x0)    :  1  :   1 ;
          1   ?  (x0)    :  0  :   0 ; 
                                                                                                                  
          0   x  (x0)    :  1  :   1 ;
          x   0  (x0)    :  0  :   0 ;
          0   x  (1x)    :  1  :   1 ;
          x   0  (1x)    :  0  :   0 ;
                        
          *   ?   ?      :  ?  :   - ;    // Insensitive to 
          ?   *   ?      :  ?  :   - ;    // transitions on R and S
                     
                     
          ?   ? (?1)     :   ? :  -  ;    
          ?   ? (0x)     :   ? :  -  ;
                     
          x   0   f      :  0  :  0  ;    // reducing pessimism for unknown S 
          0   x   f      :  1  :  1  ;    // reducing pessimism for unknown R 

   endtable
endprimitive

primitive U_FRS_N_RB_SB (Q, S, R, CP, RB, SB);
 
// 
// FUNCTION : R-S FLIP-FLOP WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT. ASYNCHRONOUS SET & RESET ARE ACTIVE LOW
//            ( Q OUTPUT UDP ) .
  

    output Q;
    reg    Q;  
    input  S,R,
            CP,                                  // Clock.
            RB,                                  // Reset input
            SB;                                  // Set input.

    table
       // S   R   CP  RB   SB     Qtn   Qtn+1

          0   0  (10) 1    1     :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (10) 1    1     :  ?  :   0 ;    // Clocked R and S.
          ?   1  (10) x    1     :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    1     :  0  :   0 ;    // pessimism
                           
          1   0  (10) 1    1     :  ?  :   1 ;    
          1   0  (10) 1    x     :  ?  :   1 ;    // pessimism
          ?   ?   ?   1    x     :  1  :   1 ;    // pessimism

          0   0  (1x) 1    1     :  ?  :   - ;    // possible clocked RS
          ?   1  (1x) 1    1     :  0  :   0 ;   
          1   0  (1x) 1    1     :  1  :   1 ;
          0   0  (x0) 1    1     :  ?  :   - ;
          ?   1  (x0) 1    1     :  0  :   0 ;
          1   0  (x0) 1    1     :  1  :   1 ; 
       
          0   x  (x0) 1    1     :  0  :   0 ;
          x   0  (x0) 1    1     :  1  :   1 ;
          0   x  (1x) 1    1     :  0  :   0 ;
          x   0  (1x) 1    1     :  1  :   1 ;
                                
          *   ?   ?   1    1     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   1    1     :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   0    ?     :  ?  :  0  ;    // Clear.
          ?   ?   ?   1    0     :  ?  :  1  ;    // Set.

          ?   ? (?1)  ?    ?     :   ? :  -  ;    
          ?   ? (0x)  ?    ?     :   ? :  -  ;

          x   0   f   1    1     :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   f   1    1     :  0  :  0  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?1) ?     :  ?  :  -  ;
          ?   ?   ?   ?    (?1)  :  ?  :  -  ;    // ignore transitions on RST and SET

    endtable

endprimitive

primitive U_FRS_N_RB_SB_NO (Q, S, R, CP, RB, SB, NOTIFIER_REG); 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           S,R,
            CP,                                  // Clock.
            RB,                                  // Reset input
            SB;                                  // Set input  
                                  
// FUNCTION : R-S FLIP-FLOP WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT. ASYNCHRONOUS SET & RESET ARE ACTIVE LOW
//            ( Q OUTPUT UDP ) .

    table
       // S   R   CP  RB   SB    NOTIFIER_REG        Qtn   Qtn+1
                     
          0   0  (10) 1    1           ?          :  ?  :   - ;    // Output retains the previous value
                     
          ?   1  (10) 1    1           ?          :  ?  :   0 ;    // Clocked R and S.
          ?   1  (10) x    1           ?          :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    1           ?          :  0  :   0 ;    // pessimism
                           
          1   0  (10) 1    1           ?          :  ?  :   1 ;    
          1   0  (10) 1    x           ?          :  ?  :   1 ;    // pessimism
          ?   ?   ?   1    x           ?          :  1  :   1 ;    // pessimism
                     
          0   0  (1x) 1    1           ?          :  ?  :   - ;    // possible clocked RS
          ?   1  (1x) 1    1           ?          :  0  :   0 ;   
          1   0  (1x) 1    1           ?          :  1  :   1 ;
          0   0  (x0) 1    1           ?          :  ?  :   - ;
          ?   1  (x0) 1    1           ?          :  0  :   0 ;
          1   0  (x0) 1    1           ?          :  1  :   1 ; 
                     
          0   x  (x0) 1    1           ?          :  0  :   0 ;
          x   0  (x0) 1    1           ?          :  1  :   1 ;
          0   x  (1x) 1    1           ?          :  0  :   0 ;
          x   0  (1x) 1    1           ?          :  1  :   1 ;
                                
          *   ?   ?   1    1           ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?   1    1           ?          :  ?  :   - ;    // transitions on R and S
                     
          ?   ?   ?   0    ?           ?          :  ?  :  0  ;    // Clear.
          ?   ?   ?   1    0           ?          :  ?  :  1  ;    // Set.
                     
          ?   ? (?1)  ?    ?           ?          :   ? :  -  ;    
          ?   ? (0x)  ?    ?           ?          :   ? :  -  ;
                     
          x   0   f   1    1           ?          :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   f   1    1           ?          :  0  :  0  ;    // reducing pessimism for unknown R 
                     
          ?   ?   ?   (?1) ?           ?          :  ?  :  -  ;
          ?   ?   ?   ?   (?1)         ?          :  ?  :  -  ;    // ignore transitions on RST and SET
          ?   ?   ?    ?   ?           *          :  ?  :   x ;      

    endtable

endprimitive

primitive U_FRS_N_RB_SB_QN (QN, S, R, CP, RB, SB);
 
// 
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET.
//            RESET DOMINANT. ASYNCHRONOUS SET & RESET ARE ACTIVE LOW 
//            ( QN OUTPUT UDP ) .

    output QN;
    reg    QN;  
    input  S,R,
            CP,                                   // Clock.
            RB,                                  // Reset input
            SB;                                  // Set input.

    table
       // S   R   CP  RB  SB      Qtn   Qtn+1

          0   0  (10) 1    1     :  ?  :   - ;    // Output retains the previous value
          
          0   1  (10) 1    1     :  ?  :   1 ;    // Reset  state
          0   1  (10) x    1     :  ?  :   1 ;    // pessimism
          ?   ?   ?   x    1     :  1  :   1 ;    // pessimism
                           
          1   ?  (10) 1    1     :  ?  :   0 ;    
          1   ?  (10) 1    x     :  ?  :   0 ;    // pessimism
          ?   ?   ?   1    x     :  0  :   0 ;    // pessimism

          0   0  (1x) 1    1     :  ?  :   - ;    // possible clocked RS
          0   1  (1x) 1    1     :  1  :   1 ;   
          1   ?  (1x) 1    1     :  0  :   0 ;
          0   0  (x0) 1    1     :  ?  :   - ;
          0   1  (x0) 1    1     :  1  :   1 ;
          1   ?  (x0) 1    1     :  0  :   0 ; 
       
          0   x  (x0) 1    1     :  1  :   1 ;
          x   0  (x0) 1    1     :  0  :   0 ;
          0   x  (1x) 1    1     :  1  :   1 ;
          x   0  (1x) 1    1     :  0  :   0 ;
                                
          *   ?   ?   1    1     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   1    1     :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   0    1     :  ?  :  1  ;    // Clear.
          ?   ?   ?   ?    0     :  ?  :  0  ;    // Set.

          ?   ? (?1)  ?    ?     :   ? :  -  ;    
          ?   ? (0x)  ?    ?     :   ? :  -  ;

          x   0   f   1    1     :  0  :  0  ;    // reducing pessimism for unknown S 
          0   x   f   1    1     :  1  :  1  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?1) ?     :  ?  :  -  ;
          ?   ?   ?   ?    (?1)  :  ?  :  -  ;    // ignore transitions on RESET and SET

    endtable

endprimitive

primitive U_FRS_N_SB_RB_X (Q, S, R, CP, RB, SB);
 
// 
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT . ILLEGAL OUTPUT OCCURS WHEN BOTH
//            ASYNCHRONOUS SET & RESET ARE ACTIVE LOW ( Q OUTPUT UDP ) .
  

    output Q;
    reg    Q;  
    input  S,R,
           CP,                                  // Clock.
           RB,                                  // Reset input
           SB;                                  // Set input.

    table
       // S   R   CP  RB   SB     Qtn   Qtn+1

          0   0  (10) 1    1     :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (10) 1    1     :  ?  :   0 ;    // Clocked R and S.
          ?   1  (10) x    1     :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    1     :  0  :   0 ;    // pessimism
                           
          1   0  (10) 1    1     :  ?  :   1 ;    
          1   0  (10) 1    x     :  ?  :   1 ;    // pessimism
          ?   ?   ?   1    x     :  1  :   1 ;    // pessimism

          0   0  (1x) 1    1     :  ?  :   - ;    // possible clocked RS
          ?   1  (1x) 1    1     :  0  :   0 ;   
          1   0  (1x) 1    1     :  1  :   1 ;
          0   0  (x0) 1    1     :  ?  :   - ;
          ?   1  (x0) 1    1     :  0  :   0 ;
          1   0  (x0) 1    1     :  1  :   1 ; 
       
          0   x  (x0) 1    1     :  0  :   0 ;
          x   0  (x0) 1    1     :  1  :   1 ;
          0   x  (1x) 1    1     :  0  :   0 ;
          x   0  (1x) 1    1     :  1  :   1 ;
                                
          *   ?   ?   1    1     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   1    1     :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   0    1     :  ?  :  0  ;    // Clear.
          ?   ?   ?   1    0     :  ?  :  1  ;    // Set.
          ?   ?   ?   0    0     :  ?  :  x  ;    // Illegal output when both are active

          ?   ? (?1)  ?    ?     :   ? :  -  ;    
          ?   ? (0x)  ?    ?     :   ? :  -  ;

          x   0   f   1    1     :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   f   1    1     :  0  :  0  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?1) ?     :  ?  :  -  ;
          ?   ?   ?   ?   (?1)   :  ?  :  -  ;    // ignore transitions on RST and SET

    endtable

endprimitive

primitive U_FRS_N_S_R_X (Q, S, R, CP, RST, SET);
 
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT . ILLEGAL OUTPUT OCCURS WHEN BOTH
//            ASYNCHRONOUS SET & RESET ARE ACTIVE HIGH ( Q OUTPUT UDP ) .

    output Q;
    reg    Q;  
    input  S,R,
           CP,                                  // Clock.
           RST,                                 // Reset input
           SET;                                 // Set input.

    table
       // S   R   CP  RST  SET     QTN   QTN+1
                     
          0   0  (10) 0    0     :  ?  :   - ;    // Output retains the previous value
                     
          ?   1  (10) 0    0     :  ?  :   0 ;    // Clocked R and S.
          ?   1  (10) x    0     :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    0     :  0  :   0 ;    // pessimism
                           
          1   0  (10) 0    0     :  ?  :   1 ;    
          1   0  (10) 0    x     :  ?  :   1 ;    // pessimism
          ?   ?   ?   0    x     :  1  :   1 ;    // pessimism
                     
          0   0  (1x) 0    0     :  ?  :   - ;    // possible clocked RS
          ?   1  (1x) 0    0     :  0  :   0 ;   
          1   0  (1x) 0    0     :  1  :   1 ;
          0   0  (x0) 0    0     :  ?  :   - ;
          ?   1  (x0) 0    0     :  0  :   0 ;
          1   0  (x0) 0    0     :  1  :   1 ; 
                     
          0   x  (x0) 0    0     :  0  :   0 ;
          x   0  (x0) 0    0     :  1  :   1 ;
          0   x  (1x) 0    0     :  0  :   0 ;
          x   0  (1x) 0    0     :  1  :   1 ;
                                
          *   ?   ?   0    0     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   0    0     :  ?  :   - ;    // transitions on R and S
                     
          ?   ?   ?   1    0     :  ?  :  0  ;    // Clear.
          ?   ?   ?   0    1     :  ?  :  1  ;    // Set.
          ?   ?   ?   1    1     :  ?  :  x  ;    // Illegal output when both are active
                     
          ?   ? (?1)  ?    ?     :   ? :  -  ;    
          ?   ? (0x)  ?    ?     :   ? :  -  ;
                     
          x   0   f   0    0     :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   f   0    0     :  0  :  0  ;    // reducing pessimism for unknown R 
                     
          ?   ?   ?   (?0) ?     :  ?  :  -  ;
          ?   ?   ?   ?   (?0)   :  ?  :  -  ;    // ignore transitions on RST and SET

    endtable

endprimitive

primitive U_FRS_N_S_R_X_NO (Q, S, R, CP, RST, SET, NOTIFIER_REG); 

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           S,R,
           CP,                                  // Clock.
           RST,                                 // Reset input
           SET;                                 // Set input 
                                  
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT . ILLEGAL OUTPUT OCCURS WHEN BOTH
//            ASYNCHRONOUS SET & RESET ARE ACTIVE HIGH ( Q OUTPUT UDP ) .

    table
       // S   R   CP  RST  SET     NOTIFIER_REG    QTN   QTN+1
                     
          0   0  (10) 0    0           ?          :  ?  :   - ;    // Output retains the previous value
                     
          ?   1  (10) 0    0           ?          :  ?  :   0 ;    // Clocked R and S.
          ?   1  (10) x    0           ?          :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    0           ?          :  0  :   0 ;    // pessimism
                           
          1   0  (10) 0    0           ?          :  ?  :   1 ;    
          1   0  (10) 0    x           ?          :  ?  :   1 ;    // pessimism
          ?   ?   ?   0    x           ?          :  1  :   1 ;    // pessimism
                     
          0   0  (1x) 0    0           ?          :  ?  :   - ;    // possible clocked RS
          ?   1  (1x) 0    0           ?          :  0  :   0 ;   
          1   0  (1x) 0    0           ?          :  1  :   1 ;
          0   0  (x0) 0    0           ?          :  ?  :   - ;
          ?   1  (x0) 0    0           ?          :  0  :   0 ;
          1   0  (x0) 0    0           ?          :  1  :   1 ; 
                     
          0   x  (x0) 0    0           ?          :  0  :   0 ;
          x   0  (x0) 0    0           ?          :  1  :   1 ;
          0   x  (1x) 0    0           ?          :  0  :   0 ;
          x   0  (1x) 0    0           ?          :  1  :   1 ;
                                
          *   ?   ?   0    0           ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?   0    0           ?          :  ?  :   - ;    // transitions on R and S
                     
          ?   ?   ?   1    0           ?          :  ?  :  0  ;    // Clear.
          ?   ?   ?   0    1           ?          :  ?  :  1  ;    // Set.
          ?   ?   ?   1    1           ?          :  ?  :  x  ;    // Illegal output when both are active
                     
          ?   ? (?1)  ?    ?           ?          :   ? :  -  ;    
          ?   ? (0x)  ?    ?           ?          :   ? :  -  ;
                     
          x   0   f   0    0           ?          :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   f   0    0           ?          :  0  :  0  ;    // reducing pessimism for unknown R 
                     
          ?   ?   ?  (?0)  ?           ?          :  ?  :  -  ;
          ?   ?   ?   ?   (?0)         ?          :  ?  :  -  ;    // ignore transitions on RST and SET
          ?   ?   ?   ?    ?           *          :  ?  :  x  ;      

    endtable

endprimitive

primitive U_FRS_N_S_R_X_QN (QN, S, R, CP, RST, SET);
 
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT. ILLEGAL OUTPUT OCCURS WHEN BOTH
//            ASYNCHRONOUS SET & RESET ARE ACTIVE HIGH ( QN OUTPUT UDP ) .

    output QN;
    reg    QN;  
    input  S,R,
           CP,                                   // Clock.
           RST,                                  // Reset input
           SET;                                  // Set input.

    table
       // S   R   CP  RST  SET    Qtn   Qtn+1
                     
          0   0  (10) 0    0     :  ?  :   - ;    // Output retains the previous value
                     
          0   1  (10) 0    0     :  ?  :   1 ;    // Reset  state
          0   1  (10) x    0     :  ?  :   1 ;    // pessimism
          ?   ?   ?   x    0     :  1  :   1 ;    // pessimism
                           
          1   ?  (10) 0    0     :  ?  :   0 ;    
          1   ?  (10) 0    x     :  ?  :   0 ;    // pessimism
          ?   ?   ?   0    x     :  0  :   0 ;    // pessimism
                     
          0   0  (1x) 0    0     :  ?  :   - ;    // possible clocked RS
          0   1  (1x) 0    0     :  1  :   1 ;   
          1   ?  (1x) 0    0     :  0  :   0 ;
          0   0  (x0) 0    0     :  ?  :   - ;
          0   1  (x0) 0    0     :  1  :   1 ;
          1   ?  (x0) 0    0     :  0  :   0 ; 
                     
          0   x  (x0) 0    0     :  1  :   1 ;
          x   0  (x0) 0    0     :  0  :   0 ;
          0   x  (1x) 0    0     :  1  :   1 ;
          x   0  (1x) 0    0     :  0  :   0 ;
                                
          *   ?   ?   0    0     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   0    0     :  ?  :   - ;    // transitions on R and S
                     
          ?   ?   ?   1    0     :  ?  :  1  ;    // Clear.
          ?   ?   ?   0    1     :  ?  :  0  ;    // Set.
          ?   ?   ?   1    1     :  ?  :  x  ;    // Illegal output when both are active.
                     
          ?   ? (?1)  ?    ?     :   ? :  -  ;    
          ?   ? (0x)  ?    ?     :   ? :  -  ;
                     
          x   0   f   0    0     :  0  :  0  ;    // reducing pessimism for unknown S 
          0   x   f   0    0     :  1  :  1  ;    // reducing pessimism for unknown R 
                     
          ?   ?   ?   (?0) ?     :  ?  :  -  ;
          ?   ?   ?   ?    (?0)  :  ?  :  -  ;    // ignore transitions on RST and SET
                    
    endtable

endprimitive
primitive U_FRS_P (Q, S, R, CP);

     output Q; 
     reg    Q;        
     input  S,
            R,
            CP;
                                                                                                                 
// FUNCTION : R-S FLIP-FLOP ( Q OUTPUT UDP ) .
//            

   table
       // S   R   CP      Qtn   Qtn+1

          0   0  (01)    :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (01)    :  ?  :   0 ;    // Clocked R and S.
                      
          1   0  (01)    :  ?  :   1 ;    

          0   0  (x1)    :  ?  :   - ;    // possible clocked RS
          ?   1  (x1)    :  0  :   0 ;   
          1   0  (x1)    :  1  :   1 ;
          0   0  (0x)    :  ?  :   - ;
          ?   1  (0x)    :  0  :   0 ;
          1   0  (0x)    :  1  :   1 ; 
                                                                                                                  
          0   x  (0x)    :  0  :   0 ;
          x   0  (0x)    :  1  :   1 ;
          0   x  (x1)    :  0  :   0 ;
          x   0  (x1)    :  1  :   1 ;
                        
          *   ?   ?      :  ?  :   - ;    // Insensitive to 
          ?   *   ?      :  ?  :   - ;    // transitions on R and S


          ?   ? (?0)     :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)     :   ? :  -  ;

          x   0   r      :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   r      :  0  :  0  ;    // reducing pessimism for unknown R 



   endtable
endprimitive



































                                                                                                                   
primitive U_FRS_P_NO (Q, S, R, CP, NOTIFIER_REG); 

     output Q; 
     reg    Q;        
     input  NOTIFIER_REG,
           S,
            R,
            CP;
                                                                                                                 
// FUNCTION : R-S FLIP-FLOP ( Q OUTPUT UDP ) .
//            
   table
       // S   R   CP         NOTIFIER_REG  Qtn   Qtn+1

          0   0  (01)          ?          :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (01)          ?          :  ?  :   0 ;    // Clocked R and S.
                      
          1   0  (01)          ?          :  ?  :   1 ;    

          0   0  (x1)          ?          :  ?  :   - ;    // possible clocked RS
          ?   1  (x1)          ?          :  0  :   0 ;   
          1   0  (x1)          ?          :  1  :   1 ;
          0   0  (0x)          ?          :  ?  :   - ;
          ?   1  (0x)          ?          :  0  :   0 ;
          1   0  (0x)          ?          :  1  :   1 ; 
                                                                                                                  
          0   x  (0x)          ?          :  0  :   0 ;
          x   0  (0x)          ?          :  1  :   1 ;
          0   x  (x1)          ?          :  0  :   0 ;
          x   0  (x1)          ?          :  1  :   1 ;
                        
          *   ?   ?            ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?            ?          :  ?  :   - ;    // transitions on R and S


          ?   ? (?0)           ?          :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)           ?          :   ? :  -  ;

          x   0   r            ?          :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   r            ?          :  0  :  0  ;    // reducing pessimism for unknown R 

          ?   ?   ?            *          :  ?  :  x  ;

   endtable
endprimitive



































                                                                                                                   
primitive U_FRS_P_NO_QN (QN, S, R, CP, NOTIFIER_REG); 

     output QN; 
     reg    QN;        
     input  NOTIFIER_REG,
           S,
            R,
            CP;
                                                                                                                 
// FUNCTION : R-S FLIP-FLOP ( QN OUTPUT UDP ) .
//            

   table
       // S   R   CP      NOTIFIER_REG     Qtn   Qtn+1

          0   0  (01)          ?          :  ?  :   - ;    // Output retains the previous value
         
          0   1  (01)          ?          :  ?  :   1 ;    // Clocked R and S.
                      
          1   ?  (01)          ?          :  ?  :   0 ;    

          0   0  (x1)          ?          :  ?  :   - ;    // possible clocked RS
          0   1  (x1)          ?          :  1  :   1 ;   
          1   ?  (x1)          ?          :  0  :   0 ;
          0   0  (0x)          ?          :  ?  :   - ;
          0   1  (0x)          ?          :  1  :   1 ;
          1   ?  (0x)          ?          :  0  :   0 ; 
                                                                                                                  
          0   x  (0x)          ?          :  1  :   1 ;
          x   0  (0x)          ?          :  0  :   0 ;
          0   x  (x1)          ?          :  1  :   1 ;
          x   0  (x1)          ?          :  0  :   0 ;
                        
          *   ?   ?            ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?            ?          :  ?  :   - ;    // transitions on R and S


          ?   ? (?0)           ?          :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)           ?          :   ? :  -  ;

          x   0   r            ?          :  0  :  0  ;    // reducing pessimism for unknown S 
          0   x   r            ?          :  1  :  1  ;    // reducing pessimism for unknown R 
          ?   ?   ?            *          :  ?  :   x ;      



   endtable
endprimitive



































                                                                                                                   
primitive U_FRS_P_QN (QN, S, R, CP);

     output QN; 
     reg    QN;        
     input  S,
            R,
            CP;
                                                                                                                 
// FUNCTION : POSITIVE EDGE TRIGGERED R-S FLIP-FLOP ( QN OUTPUT UDP ) .
//            

   table
       // S   R   CP      Qtn   Qtn+1

          0   0  (01)    :  ?  :   - ;    // Output retains the previous value
         
          0   1  (01)    :  ?  :   1 ;    // Clocked R and S.
                      
          1   ?  (01)    :  ?  :   0 ;    

          0   0  (x1)    :  ?  :   - ;    // possible clocked RS
          0   1  (x1)    :  1  :   1 ;   
          1   ?  (x1)    :  0  :   0 ;
          0   0  (0x)    :  ?  :   - ;
          0   1  (0x)    :  1  :   1 ;
          1   ?  (0x)    :  0  :   0 ; 
                                                                                                                  
          0   x  (0x)    :  1  :   1 ;
          x   0  (0x)    :  0  :   0 ;
          0   x  (x1)    :  1  :   1 ;
          x   0  (x1)    :  0  :   0 ;
                        
          *   ?   ?      :  ?  :   - ;    // Insensitive to 
          ?   *   ?      :  ?  :   - ;    // transitions on R and S


          ?   ? (?0)     :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)     :   ? :  -  ;

          x   0   r      :  0  :  0  ;    // reducing pessimism for unknown S 
          0   x   r      :  1  :  1  ;    // reducing pessimism for unknown R 



   endtable
endprimitive



































                                                                                                                   

primitive U_FRS_P_RB_SB (Q, S, R, CP, RB, SB);
 
// 
// FUNCTION : R-S FLIP-FLOP WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT. ASYNCHRONOUS SET & RESET ARE ACTIVE LOW
//            ( Q OUTPUT UDP ) .
  

    output Q;
    reg    Q;  
    input  S,R,
            CP,                                  // Clock.
            RB,                                  // Reset input
            SB;                                  // Set input.
                                  

    table
       // S   R   CP  RB   SB     Qtn   Qtn+1

          0   0  (01) 1    1     :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (01) 1    1     :  ?  :   0 ;    // Clocked R and S.
          ?   1  (01) x    1     :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    1     :  0  :   0 ;    // pessimism
                           
          1   0  (01) 1    1     :  ?  :   1 ;    
          1   0  (01) 1    x     :  ?  :   1 ;    // pessimism
          ?   ?   ?   1    x     :  1  :   1 ;    // pessimism

          0   0  (x1) 1    1     :  ?  :   - ;    // possible clocked RS
          ?   1  (x1) 1    1     :  0  :   0 ;   
          1   0  (x1) 1    1     :  1  :   1 ;
          0   0  (0x) 1    1     :  ?  :   - ;
          ?   1  (0x) 1    1     :  0  :   0 ;
          1   0  (0x) 1    1     :  1  :   1 ; 
       
          0   x  (0x) 1    1     :  0  :   0 ;
          x   0  (0x) 1    1     :  1  :   1 ;
          0   x  (x1) 1    1     :  0  :   0 ;
          x   0  (x1) 1    1     :  1  :   1 ;
                                
          *   ?   ?   1    1     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   1    1     :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   0    ?     :  ?  :  0  ;    // Clear.
          ?   ?   ?   1    0     :  ?  :  1  ;    // Set.

          ?   ? (?0)  1    1     :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)  1    1     :   ? :  -  ;

          x   0   r   1    1     :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   r   1    1     :  0  :  0  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?1) ?     :  ?  :  -  ;
          ?   ?   ?   ?    (?1)  :  ?  :  -  ;    // ignore transitions on RST and SET

    endtable

endprimitive

primitive U_FRS_P_RB_SB_NO (Q, S, R, CP, RB, SB, NOTIFIER_REG); 
 
 

  

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           S,R,
            CP,                                  // Clock.
            RB,                                  // Reset input
            SB;                                  // Set input  
                                  
// FUNCTION : R-S FLIP-FLOP WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT. ASYNCHRONOUS SET & RESET ARE ACTIVE LOW
//            ( Q OUTPUT UDP ) .
  


    table
       // S   R   CP  RB   SB    NOTIFIER_REG        Qtn   Qtn+1

          0   0  (01) 1    1           ?          :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (01) 1    1           ?          :  ?  :   0 ;    // Clocked R and S.
          ?   1  (01) x    1           ?          :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    1           ?          :  0  :   0 ;    // pessimism
                           
          1   0  (01) 1    1           ?          :  ?  :   1 ;    
          1   0  (01) 1    x           ?          :  ?  :   1 ;    // pessimism
          ?   ?   ?   1    x           ?          :  1  :   1 ;    // pessimism

          0   0  (x1) 1    1           ?          :  ?  :   - ;    // possible clocked RS
          ?   1  (x1) 1    1           ?          :  0  :   0 ;   
          1   0  (x1) 1    1           ?          :  1  :   1 ;
          0   0  (0x) 1    1           ?          :  ?  :   - ;
          ?   1  (0x) 1    1           ?          :  0  :   0 ;
          1   0  (0x) 1    1           ?          :  1  :   1 ; 
       
          0   x  (0x) 1    1           ?          :  0  :   0 ;
          x   0  (0x) 1    1           ?          :  1  :   1 ;
          0   x  (x1) 1    1           ?          :  0  :   0 ;
          x   0  (x1) 1    1           ?          :  1  :   1 ;
                                
          *   ?   ?   1    1           ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?   1    1           ?          :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   0    ?           ?          :  ?  :  0  ;    // Clear.
          ?   ?   ?   1    0           ?          :  ?  :  1  ;    // Set.

          ?   ? (?0)  1    1           ?          :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)  1    1           ?          :   ? :  -  ;

          x   0   r   1    1           ?          :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   r   1    1           ?          :  0  :  0  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?1) ?           ?          :  ?  :  -  ;
          ?   ?   ?   ?    (?1)        ?          :  ?  :  -  ;    // ignore transitions on RST and SET
          ?   ?   ?    ?   ?           *          :  ?  :   x ;      

    endtable

endprimitive

primitive U_FRS_P_RB_SB_QN (QN, S, R, CP, RB, SB);
 
// 
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET.
//            RESET DOMINANT. ASYNCHRONOUS SET & RESET ARE ACTIVE LOW 
//            ( QN OUTPUT UDP ) .
  

    output QN;
    reg    QN;  
    input  S,R,
            CP,                                   // Clock.
            RB,                                  // Reset input
            SB;                                  // Set input.
                                  

    table
       // S   R   CP  RB  SB     QNtn   QNtn+1

          0   0  (01) 1    1     :  ?  :   - ;    // Output retains the previous value
          
          0   1  (01) 1    1     :  ?  :   1 ;    // Reset  state
          0   1  (01) x    1     :  ?  :   1 ;    // pessimism
          ?   ?   ?   x    1     :  1  :   1 ;    // pessimism
                           
          1   ?  (01) 1    1     :  ?  :   0 ;    
          1   ?  (01) 1    x     :  ?  :   0 ;    // pessimism
          ?   ?   ?   1    x     :  0  :   0 ;    // pessimism

          0   0  (x1) 1    1     :  ?  :   - ;    // possible clocked RS
          0   1  (x1) 1    1     :  1  :   1 ;   
          1   ?  (x1) 1    1     :  0  :   0 ;
          0   0  (0x) 1    1     :  ?  :   - ;
          0   1  (0x) 1    1     :  1  :   1 ;
          1   ?  (0x) 1    1     :  0  :   0 ; 
       
          0   x  (0x) 1    1     :  1  :   1 ;
          x   0  (0x) 1    1     :  0  :   0 ;
          0   x  (x1) 1    1     :  1  :   1 ;
          x   0  (x1) 1    1     :  0  :   0 ;
                                
          *   ?   ?   1    1     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   1    1     :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   0    1     :  ?  :  1  ;    // Clear.
          ?   ?   ?   1    0     :  ?  :  0  ;    // Set.
          ?   ?   ?   0    0     :  ?  :  0  ;   

          ?   ? (?0)  1    1     :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)  1    1     :   ? :  -  ;

          x   0   r   1    1     :  0  :  0  ;    // reducing pessimism for unknown S 
          0   x   r   1    1     :  1  :  1  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?1) ?     :  ?  :  -  ;
          ?   ?   ?   ?    (?1)  :  ?  :  -  ;    // ignore transitions on RESET and SET

    endtable

endprimitive

primitive U_FRS_P_SB_RB_X (Q, S, R, CP, RB, SB);
 
// 
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT . ILLEGAL OUTPUT OCCURS WHEN BOTH
//            ASYNCHRONOUS SET & RESET ARE ACTIVE LOW ( Q OUTPUT UDP ) .
  

    output Q;
    reg    Q;  
    input  S,R,
            CP,                                  // Clock.
            RB,                                  // Reset input
            SB;                                  // Set input.
                                  

    table
       // S   R   CP  RB   SB     Qtn   Qtn+1

          0   0  (01) 1    1     :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (01) 1    1     :  ?  :   0 ;    // Clocked R and S.
          ?   1  (01) x    1     :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    1     :  0  :   0 ;    // pessimism
                           
          1   0  (01) 1    1     :  ?  :   1 ;    
          1   0  (01) 1    x     :  ?  :   1 ;    // pessimism
          ?   ?   ?   1    x     :  1  :   1 ;    // pessimism

          0   0  (x1) 1    1     :  ?  :   - ;    // possible clocked RS
          ?   1  (x1) 1    1     :  0  :   0 ;   
          1   0  (x1) 1    1     :  1  :   1 ;
          0   0  (0x) 1    1     :  ?  :   - ;
          ?   1  (0x) 1    1     :  0  :   0 ;
          1   0  (0x) 1    1     :  1  :   1 ; 
       
          0   x  (0x) 1    1     :  0  :   0 ;
          x   0  (0x) 1    1     :  1  :   1 ;
          0   x  (x1) 1    1     :  0  :   0 ;
          x   0  (x1) 1    1     :  1  :   1 ;
                                
          *   ?   ?   1    1     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   1    1     :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   0    1     :  ?  :  0  ;    // Clear.
          ?   ?   ?   1    0     :  ?  :  1  ;    // Set.
          ?   ?   ?   0    0     :  ?  :  x  ;    // Illegal output when both are active

          ?   ? (?0)  1    1     :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)  1    1     :   ? :  -  ;

          x   0   r   1    1     :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   r   1    1     :  0  :  0  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?1) ?     :  ?  :  -  ;
          ?   ?   ?   ?    (?1)  :  ?  :  -  ;    // ignore transitions on RST and SET

    endtable

endprimitive

primitive U_FRS_P_S_R_X (Q, S, R, CP, RST, SET);
 
// 
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT . ILLEGAL OUTPUT OCCURS WHEN BOTH
//            ASYNCHRONOUS SET & RESET ARE ACTIVE HIGH ( Q OUTPUT UDP ) .
  

    output Q;
    reg    Q;  
    input  S,R,
            CP,                                  // Clock.
            RST,                                  // Reset input
            SET;                                  // Set input.
                                  

    table
       // S   R   CP  RST  SET     QTN   QTN+1

          0   0  (01) 0    0     :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (01) 0    0     :  ?  :   0 ;    // Clocked R and S.
          ?   1  (01) x    0     :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    0     :  0  :   0 ;    // pessimism
                           
          1   0  (01) 0    0     :  ?  :   1 ;    
          1   0  (01) 0    x     :  ?  :   1 ;    // pessimism
          ?   ?   ?   0    x     :  1  :   1 ;    // pessimism

          0   0  (x1) 0    0     :  ?  :   - ;    // possible clocked RS
          ?   1  (x1) 0    0     :  0  :   0 ;   
          1   0  (x1) 0    0     :  1  :   1 ;
          0   0  (0x) 0    0     :  ?  :   - ;
          ?   1  (0x) 0    0     :  0  :   0 ;
          1   0  (0x) 0    0     :  1  :   1 ; 
       
          0   x  (0x) 0    0     :  0  :   0 ;
          x   0  (0x) 0    0     :  1  :   1 ;
          0   x  (x1) 0    0     :  0  :   0 ;
          x   0  (x1) 0    0     :  1  :   1 ;
                                
          *   ?   ?   0    0     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   0    0     :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   1    0     :  ?  :  0  ;    // Clear.
          ?   ?   ?   0    1     :  ?  :  1  ;    // Set.
          ?   ?   ?   1    1     :  ?  :  x  ;    // Illegal output when both are active

          ?   ? (?0)  0    0     :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)  0    0     :   ? :  -  ;

          x   0   r   0    0     :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   r   0    0     :  0  :  0  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?0) ?     :  ?  :  -  ;
          ?   ?   ?   ?    (?0)  :  ?  :  -  ;    // ignore transitions on RST and SET

    endtable

endprimitive

primitive U_FRS_P_S_R_X_NO (Q, S, R, CP, RST, SET, NOTIFIER_REG); 
 
 

  

    output Q;
    reg    Q;  
    input  NOTIFIER_REG,
           S,R,
            CP,                                  // Clock.
            RST,                                  // Reset input
            SET;                                  // Set input 
                                  
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT . ILLEGAL OUTPUT OCCURS WHEN BOTH
//            ASYNCHRONOUS SET & RESET ARE ACTIVE HIGH ( Q OUTPUT UDP ) .
  


    table
       // S   R   CP  RST  SET     NOTIFIER_REG    QTN   QTN+1

          0   0  (01) 0    0           ?          :  ?  :   - ;    // Output retains the previous value
         
          ?   1  (01) 0    0           ?          :  ?  :   0 ;    // Clocked R and S.
          ?   1  (01) x    0           ?          :  ?  :   0 ;    // pessimism
          ?   ?   ?   x    0           ?          :  0  :   0 ;    // pessimism
                           
          1   0  (01) 0    0           ?          :  ?  :   1 ;    
          1   0  (01) 0    x           ?          :  ?  :   1 ;    // pessimism
          ?   ?   ?   0    x           ?          :  1  :   1 ;    // pessimism

          0   0  (x1) 0    0           ?          :  ?  :   - ;    // possible clocked RS
          ?   1  (x1) 0    0           ?          :  0  :   0 ;   
          1   0  (x1) 0    0           ?          :  1  :   1 ;
          0   0  (0x) 0    0           ?          :  ?  :   - ;
          ?   1  (0x) 0    0           ?          :  0  :   0 ;
          1   0  (0x) 0    0           ?          :  1  :   1 ; 
       
          0   x  (0x) 0    0           ?          :  0  :   0 ;
          x   0  (0x) 0    0           ?          :  1  :   1 ;
          0   x  (x1) 0    0           ?          :  0  :   0 ;
          x   0  (x1) 0    0           ?          :  1  :   1 ;
                                
          *   ?   ?   0    0           ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?   0    0           ?          :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   1    0           ?          :  ?  :  0  ;    // Clear.
          ?   ?   ?   0    1           ?          :  ?  :  1  ;    // Set.
          ?   ?   ?   1    1           ?          :  ?  :  x  ;    // Illegal output when both are active

          ?   ? (?0)  0    0           ?          :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)  0    0           ?          :   ? :  -  ;

          x   0   r   0    0           ?          :  1  :  1  ;    // reducing pessimism for unknown S 
          0   x   r   0    0           ?          :  0  :  0  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?0) ?           ?          :  ?  :  -  ;
          ?   ?   ?   ?    (?0)        ?          :  ?  :  -  ;    // ignore transitions on RST and SET
          ?   ?   ?   ?    ?           *          :  ?  :   x ;      

    endtable

endprimitive

primitive U_FRS_P_S_R_X_QN (QN, S, R, CP, RST, SET);
 
// 
// FUNCTION : R-S FF WITH ASYNCHRONOUS SET AND RESET
//            RESET DOMINANT. ILLEGAL OUTPUT OCCURS WHEN BOTH
//            ASYNCHRONOUS SET & RESET ARE ACTIVE HIGH ( QN OUTPUT UDP ) .
  

    output QN;
    reg    QN;  
    input  S,R,
            CP,                                   // Clock.
            RST,                                  // Reset input
            SET;                                  // Set input.
                                  

    table
       // S   R   CP  RST  SET    Qtn   Qtn+1

          0   0  (01) 0    0     :  ?  :   - ;    // Output retains the previous value
          
          0   1  (01) 0    0     :  ?  :   1 ;    // Reset  state
          0   1  (01) x    0     :  ?  :   1 ;    // pessimism
          ?   ?   ?   x    0     :  1  :   1 ;    // pessimism
                           
          1   ?  (01) 0    0     :  ?  :   0 ;    
          1   ?  (01) 0    x     :  ?  :   0 ;    // pessimism
          ?   ?   ?   0    x     :  0  :   0 ;    // pessimism

          0   0  (x1) 0    0     :  ?  :   - ;    // possible clocked RS
          0   1  (x1) 0    0     :  1  :   1 ;   
          1   ?  (x1) 0    0     :  0  :   0 ;
          0   0  (0x) 0    0     :  ?  :   - ;
          0   1  (0x) 0    0     :  1  :   1 ;
          1   ?  (0x) 0    0     :  0  :   0 ; 
       
          0   x  (0x) 0    0     :  1  :   1 ;
          x   0  (0x) 0    0     :  0  :   0 ;
          0   x  (x1) 0    0     :  1  :   1 ;
          x   0  (x1) 0    0     :  0  :   0 ;
                                
          *   ?   ?   0    0     :  ?  :   - ;    // Insensitive to 
          ?   *   ?   0    0     :  ?  :   - ;    // transitions on R and S

          ?   ?   ?   1    0     :  ?  :  1  ;    // Clear.
          ?   ?   ?   0    1     :  ?  :  0  ;    // Set.
          ?   ?   ?   1    1     :  ?  :  x  ;    // Illegal output when both are active.

          ?   ? (?0)  0    0     :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)  0    0     :   ? :  -  ;

          x   0   r   0    0     :  0  :  0  ;    // reducing pessimism for unknown S 
          0   x   r   0    0     :  1  :  1  ;    // reducing pessimism for unknown R 

          ?   ?   ?   (?0) ?     :  ?  :  -  ;
          ?   ?   ?   ?    (?0)  :  ?  :  -  ;    // ignore transitions on RST and SET

    endtable

endprimitive

primitive U_FSR_N (Q, S, R, CP);

     output Q; 
     reg    Q;        
     input  S,
            R,
            CP;

// FUNCTION : NEGATIVE EDGE TRIGGERED R-S FLIP-FLOP ( Q OUTPUT UDP ).
                                         

    table
       // S   R   CP      Qtn   Qtn+1

          1   1  (10)    :  ?  :   - ;    // Output retains the previous value
         
          0   ?  (10)    :  ?  :   1 ;    // Clocked R and S.
                      
          1   0  (10)    :  ?  :   0 ;    

          1   1  (1x)    :  ?  :   - ;    // possible clocked RS
          1   0  (1x)    :  0  :   0 ;   
          0   ?  (1x)    :  1  :   1 ;
          1   1  (x0)    :  ?  :   - ;
          1   0  (x0)    :  0  :   0 ;
          0   ?  (x0)    :  1  :   1 ; 
       
          1   x  (x0)    :  0  :   0 ;
          x   1  (x0)    :  1  :   1 ;
          1   x  (1x)    :  0  :   0 ;
          x   1  (1x)    :  1  :   1 ;
                        
          *   ?   ?      :  ?  :   - ;    // Insensitive to 
          ?   *   ?      :  ?  :   - ;    // transitions on R and S


          ?   ? (?1)     :   ? :  -  ;    
          ?   ? (0x)     :   ? :  -  ;

          x   1   f      :  1  :  1  ;    // reducing pessimism for unknown S 
          1   x   f      :  0  :  0  ;    // reducing pessimism for unknown R 

   endtable
endprimitive

primitive U_FSR_N_NO (Q, S, R, CP, NOTIFIER_REG); 

     output Q; 
     reg    Q;        
     input  NOTIFIER_REG,
            S,
            R,
            CP;

// FUNCTION : NEGATIVE EDGE TRIGGERED R-S FLIP-FLOP ( Q OUTPUT UDP ).

    table
       // S   R   CP      NOTIFIER_REG      Qtn   Qtn+1
                     
          1   1  (10)          ?          :  ?  :   - ;    // Output retains the previous value
                     
          0   ?  (10)          ?          :  ?  :   1 ;    // Clocked R and S.
                      
          1   0  (10)          ?          :  ?  :   0 ;    
                     
          1   1  (1x)          ?          :  ?  :   - ;    // possible clocked RS
          1   0  (1x)          ?          :  0  :   0 ;   
          0   ?  (1x)          ?          :  1  :   1 ;
          1   1  (x0)          ?          :  ?  :   - ;
          1   0  (x0)          ?          :  0  :   0 ;
          0   ?  (x0)          ?          :  1  :   1 ; 
                     
          1   x  (x0)          ?          :  0  :   0 ;
          x   1  (x0)          ?          :  1  :   1 ;
          1   x  (1x)          ?          :  0  :   0 ;
          x   1  (1x)          ?          :  1  :   1 ;
                        
          *   ?   ?            ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?            ?          :  ?  :   - ;    // transitions on R and S
                     
                     
          ?   ? (?1)           ?          :   ? :  -  ;    
          ?   ? (0x)           ?          :   ? :  -  ;
                     
          x   1   f            ?          :  1  :  1  ;    // reducing pessimism for unknown S 
          1   x   f            ?          :  0  :  0  ;    // reducing pessimism for unknown R 
          ?   ?   ?            *          :  ?  :  x  ;      

   endtable
endprimitive

primitive U_FSR_N_NO_QN (QN, S, R, CP, NOTIFIER_REG); 

     output QN; 
     reg    QN;        
     input  NOTIFIER_REG,
            S,
            R,
            CP;

// FUNCTION : NEGATIVE EDGE TRIGGERED R-S FLIP-FLOP ( QN OUTPUT UDP ).

    table
       // S   R   CP      NOTIFIER_REG      QNtn   QNtn+1
                     
          1   1  (10)          ?          :  ?  :   - ;    // Output retains the previous value
                     
          0   0  (10)          ?          :  ?  :   1 ;    // Clocked R and S.
          0   1  (10)          ?          :  ?  :   0 ;    // Clocked R and S.
                      
          1   0  (10)          ?          :  ?  :   1 ;    
                     
          1   1  (1x)          ?          :  ?  :   - ;    // possible clocked RS
          1   0  (1x)          ?          :  1  :   1 ;   
          0   0  (1x)          ?          :  1  :   1 ;
          0   1  (1x)          ?          :  0  :   0 ;
          1   1  (x0)          ?          :  ?  :   - ;
          1   0  (x0)          ?          :  1  :   1 ;
          0   0  (x0)          ?          :  1  :   1 ; 
          0   1  (x0)          ?          :  0  :   0 ; 
                     
          1   x  (x0)          ?          :  1  :   1 ;
          x   1  (x0)          ?          :  0  :   0 ;
          1   x  (1x)          ?          :  1  :   1 ;
          x   1  (1x)          ?          :  0  :   0 ;
                        
          *   ?   ?            ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?            ?          :  ?  :   - ;    // transitions on R and S
                     
                     
          ?   ? (?1)           ?          :   ? :  -  ;    
          ?   ? (0x)           ?          :   ? :  -  ;
                     
          x   1   f            ?          :  0  :  0  ;    // reducing pessimism for unknown S 
          1   x   f            ?          :  1  :  1  ;    // reducing pessimism for unknown R 
          ?   ?   ?            *          :  ?  :  x  ;      

   endtable
endprimitive

primitive U_FSR_N_QN (QN, S, R, CP);

     output QN; 
     reg    QN;        
     input  S,
            R,
            CP;

// FUNCTION : NEGATIVE EDGE TRIGGERED R-S FLIP-FLOP ( QN OUTPUT UDP ).

    table
       // S   R   CP      QNtn   QNtn+1

          1   1  (10)    :  ?  :   - ;    // Output retains the previous value
         
          0   0  (10)    :  ?  :   1 ;    // Clocked R and S.
          0   1  (10)    :  ?  :   0 ;    // Clocked R and S.
                      
          1   0  (10)    :  ?  :   1 ;    

          1   1  (1x)    :  ?  :   - ;    // possible clocked RS
          1   0  (1x)    :  1  :   1 ;   
          0   0  (1x)    :  1  :   1 ;
          0   1  (1x)    :  0  :   0 ;
          1   1  (x0)    :  ?  :   - ;
          1   0  (x0)    :  1  :   1 ;
          0   0  (x0)    :  1  :   1 ; 
          0   1  (x0)    :  0  :   0 ; 
       
          1   x  (x0)    :  1  :   1 ;
          x   1  (x0)    :  0  :   0 ;
          1   x  (1x)    :  1  :   1 ;
          x   1  (1x)    :  0  :   0 ;
                        
          *   ?   ?      :  ?  :   - ;    // Insensitive to 
          ?   *   ?      :  ?  :   - ;    // transitions on R and S


          ?   ? (?1)     :   ? :  -  ;    
          ?   ? (0x)     :   ? :  -  ;

          x   1   f      :  0  :  0  ;    // reducing pessimism for unknown S 
          1   x   f      :  1  :  1  ;    // reducing pessimism for unknown R 

   endtable
endprimitive

primitive U_FSR_P (Q, S, R, CP);

     output Q; 
     reg    Q;        
     input  S,
            R,
            CP;

// FUNCTION : POSITIVE EDGE TRIGGERED R-S FLIP-FLOP ( Q OUTPUT UDP ).
                                         

    table
       // S   R   CP      Qtn   Qtn+1

          1   1  (01)    :  ?  :   - ;    // Output retains the previous value
         
          0   ?  (01)    :  ?  :   1 ;    // Clocked R and S.
                      
          1   0  (01)    :  ?  :   0 ;    

          1   1  (x1)    :  ?  :   - ;    // possible clocked RS
          1   0  (x1)    :  0  :   0 ;   
          0   ?  (x1)    :  1  :   1 ;
          1   1  (0x)    :  ?  :   - ;
          1   0  (0x)    :  0  :   0 ;
          0   ?  (0x)    :  1  :   1 ; 
       
          1   x  (0x)    :  0  :   0 ;
          x   1  (0x)    :  1  :   1 ;
          1   x  (x1)    :  0  :   0 ;
          x   1  (x1)    :  1  :   1 ;
                        
          *   ?   ?      :  ?  :   - ;    // Insensitive to 
          ?   *   ?      :  ?  :   - ;    // transitions on R and S


          ?   ? (?0)     :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)     :   ? :  -  ;

          x   1   r      :  1  :  1  ;    // reducing pessimism for unknown S 
          1   x   r      :  0  :  0  ;    // reducing pessimism for unknown R 



   endtable
endprimitive

primitive U_FSR_P_NO (Q, S, R, CP, NOTIFIER_REG); 

     output Q; 
     reg    Q;        
     input  NOTIFIER_REG,
           S,
            R,
            CP;

// FUNCTION : POSITIVE EDGE TRIGGERED R-S FLIP-FLOP ( Q OUTPUT UDP ).

    table
       // S   R   CP      NOTIFIER_REG      Qtn   Qtn+1

          1   1  (01)          ?          :  ?  :   - ;    // Output retains the previous value
         
          0   ?  (01)          ?          :  ?  :   1 ;    // Clocked R and S.
                      
          1   0  (01)          ?          :  ?  :   0 ;    

          1   1  (x1)          ?          :  ?  :   - ;    // possible clocked RS
          1   0  (x1)          ?          :  0  :   0 ;   
          0   ?  (x1)          ?          :  1  :   1 ;
          1   1  (0x)          ?          :  ?  :   - ;
          1   0  (0x)          ?          :  0  :   0 ;
          0   ?  (0x)          ?          :  1  :   1 ; 
       
          1   x  (0x)          ?          :  0  :   0 ;
          x   1  (0x)          ?          :  1  :   1 ;
          1   x  (x1)          ?          :  0  :   0 ;
          x   1  (x1)          ?          :  1  :   1 ;
                        
          *   ?   ?            ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?            ?          :  ?  :   - ;    // transitions on R and S


          ?   ? (?0)           ?          :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)           ?          :   ? :  -  ;

          x   1   r            ?          :  1  :  1  ;    // reducing pessimism for unknown S 
          1   x   r            ?          :  0  :  0  ;    // reducing pessimism for unknown R 
          ?   ?   ?            *          :  ?  :   x ;      



   endtable
endprimitive

primitive U_FSR_P_NO_QN (QN, S, R, CP, NOTIFIER_REG); 

     output QN; 
     reg    QN;        
     input  NOTIFIER_REG,
           S,
            R,
            CP;

// FUNCTION : POSITIVE EDGE TRIGGERED R-S FLIP-FLOP ( QN OUTPUT UDP ).

    table
       // S   R   CP      NOTIFIER_REG      QNtn   QNtn+1

          1   1  (01)          ?          :  ?  :   - ;    // Output retains the previous value
         
          0   0  (01)          ?          :  ?  :   1 ;    // Clocked R and S.
          0   1  (01)          ?          :  ?  :   0 ;    // Clocked R and S.
                      
          1   0  (01)          ?          :  ?  :   1 ;    

          1   1  (x1)          ?          :  ?  :   - ;    // possible clocked RS
          1   0  (x1)          ?          :  1  :   1 ;   
          0   0  (x1)          ?          :  1  :   1 ;
          0   1  (x1)          ?          :  0  :   0 ;
          1   1  (0x)          ?          :  ?  :   - ;
          1   0  (0x)          ?          :  0  :   0 ;
          0   0  (0x)          ?          :  1  :   1 ; 
          0   1  (0x)          ?          :  0  :   0 ; 
       
          1   x  (0x)          ?          :  1  :   1 ;
          x   1  (0x)          ?          :  0  :   0 ;
          1   x  (x1)          ?          :  1  :   1 ;
          x   1  (x1)          ?          :  0  :   0 ;
                        
          *   ?   ?            ?          :  ?  :   - ;    // Insensitive to 
          ?   *   ?            ?          :  ?  :   - ;    // transitions on R and S


          ?   ? (?0)           ?          :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)           ?          :   ? :  -  ;

          x   1   r            ?          :  0  :  0  ;    // reducing pessimism for unknown S 
          1   x   r            ?          :  1  :  1  ;    // reducing pessimism for unknown R 
          ?   ?   ?            *          :  ?  :   x ;      

   endtable
endprimitive

primitive U_FSR_P_QN (QN, S, R, CP);

     output QN; 
     reg    QN;        
     input  S,
            R,
            CP;

// FUNCTION : POSITIVE EDGE TRIGGERED R-S FLIP-FLOP ( QN OUTPUT UDP ).
                                         

    table
       // S   R   CP      QNtn   QNtn+1

          1   1  (01)    :  ?  :   - ;    // Output retains the previous value
         
          0   0  (01)    :  ?  :   1 ;    // Clocked R and S.
          0   1  (01)    :  ?  :   0 ;    // Clocked R and S.
                      
          1   0  (01)    :  ?  :   1 ;    

          1   1  (x1)    :  ?  :   - ;    // possible clocked RS
          1   0  (x1)    :  1  :   1 ;   
          0   0  (x1)    :  1  :   1 ;
          0   1  (x1)    :  0  :   0 ;
          1   1  (0x)    :  ?  :   - ;
          1   0  (0x)    :  0  :   0 ;
          0   0  (0x)    :  1  :   1 ; 
          0   1  (0x)    :  0  :   0 ; 
       
          1   x  (0x)    :  1  :   1 ;
          x   1  (0x)    :  0  :   0 ;
          1   x  (x1)    :  1  :   1 ;
          x   1  (x1)    :  0  :   0 ;
                        
          *   ?   ?      :  ?  :   - ;    // Insensitive to 
          ?   *   ?      :  ?  :   - ;    // transitions on R and S


          ?   ? (?0)     :   ? :  -  ;    // ignore falling clock.
          ?   ? (1x)     :   ? :  -  ;

          x   1   r      :  0  :  0  ;    // reducing pessimism for unknown S 
          1   x   r      :  1  :  1  ;    // reducing pessimism for unknown R 



   endtable
endprimitive
primitive U_FT_N_RB_SB (Q, CP, RB, SB);
                       
//
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ACTIVE LOW  ( Q OUTPUT UDP ).

    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    
    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           f     1     1      :   0   :    1   ;     // Toggle condition.
           f     1     1      :   1   :    0   ;

           ?     0     ?      :   ?   :    0   ;     //asynchronous reset.
           ?     1     0      :   ?   :    1   ;     //asynchronous set.
                         
          (?1)   ?     ?      :   ?   :    -   ;
          (0x)   ?     ?      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           f     x     1      :   1   :    0   ;     // pessimism
           f     1     x      :   0   :    1   ;     // pessimism  
           ?     x     1      :   0   :    0   ;
           ?     1     x      :   1   :    1   ;

    endtable

endprimitive
primitive U_FT_N_RB_SB_NO (Q, CP, RB, SB, NOTIFIER_REG); 
                       
 


    output Q; 
    reg    Q;
    input  NOTIFIER_REG,
           CP,                                     // Clock.
           RB,                                     // Clear input  
           SB;
    
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ACTIVE LOW  ( Q OUTPUT UDP ).



    table
      //   CP    RB    SB        NOTIFIER_REG  :  QTN  :  QTN+1
           f     1     1            ?          :   0   :    1   ;     // Toggle condition.
           f     1     1            ?          :   1   :    0   ;

           ?     0     ?            ?          :   ?   :    0   ;     //asynchronous reset.
           ?     1     0            ?          :   ?   :    1   ;     //asynchronous set.
                         
          (?1)   ?     ?            ?          :   ?   :    -   ;
          (0x)   ?     ?            ?          :   ?   :    -   ;
           ?    (?1)   ?            ?          :   ?   :    -   ;
           ?     ?    (?1)          ?          :   ?   :    -   ;

           f     x     1            ?          :   1   :    0   ;     // pessimism
           f     1     x            ?          :   0   :    1   ;     // pessimism  
           ?     x     1            ?          :   0   :    0   ;
           ?     1     x            ?          :   1   :    1   ;
           ?     ?     ?            *          :   ?   :    x   ;

    endtable

endprimitive
primitive U_FT_N_RB_SB_QN (QN, CP, RB, SB);
                       
//
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ILLEGAL OUPUT WHEN BOTH CLEAR AND PRESET ARE LOW ( QN OUTPUT UDP ).


    output QN; 
    reg    QN;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    

    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           f     1     1      :   1   :    0   ;     // Toggle condition.
           f     1     1      :   0   :    1   ;

           ?     0     1      :   ?   :    1   ;     //asynchronous reset.
           ?     ?     0      :   ?   :    0   ;     //asynchronous set.
                         
          (?1)   ?     ?      :   ?   :    -   ;
          (0x)   ?     ?      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           f     x     1      :   0   :    1   ;     // pessimism
           f     1     x      :   1   :    0   ;     // pessimism  
           ?     x     1      :   1   :    1   ;
           ?     1     x      :   0   :    0   ;

    endtable

endprimitive
primitive U_FT_N_RB_SB_X (Q, CP, RB, SB);
                       
//
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ILLEGAL OUPUT WHEN BOTH CLEAR AND PRESET ARE LOW ( Q OUTPUT UDP ).


    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    

    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           f     1     1      :   0   :    1   ;     // Toggle condition.
           f     1     1      :   1   :    0   ;

           ?     0     1      :   ?   :    0   ;     //asynchronous reset.
           ?     1     0      :   ?   :    1   ;     //asynchronous set.
           ?     0     0      :   ?   :    x   ;     //illegal
                         
          (?1)   ?     ?      :   ?   :    -   ;
          (0x)   ?     ?      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           f     x     1      :   1   :    0   ;     // pessimism
           f     1     x      :   0   :    1   ;     // pessimism  
           ?     x     1      :   0   :    0   ;
           ?     1     x      :   1   :    1   ;

    endtable

endprimitive
primitive U_FT_N_SB_RB (Q, CP, RB, SB);


// FUNCTION : NEGATIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH
//            ASYNCHRONOUS SET AND CLEAR ( ACTIVE LOW ) /STANDARD DRIVE ( Q OUTPUT UDP ).


    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    

    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           f     1     1      :   0   :    1   ;     // Toggle condition.
           f     1     1      :   1   :    0   ;   


           ?     0     1      :   ?   :    0   ;     //asynchronous reset.
           ?     ?     0      :   ?   :    1   ;     //asynchronous set.
                         
          (?1)   ?     ?      :   ?   :    -   ;
          (0x)   ?     ?      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           f     x     1      :   1   :    0   ;     // pessimism
           f     1     x      :   0   :    1   ;     // pessimism  
           ?     x     1      :   0   :    0   ;
           ?     1     x      :   1   :    1   ;

    endtable

endprimitive
primitive U_FT_N_SB_RB_NO (Q, CP, RB, SB, NOTIFIER_REG); 




    output Q; 
    reg    Q;
    input  NOTIFIER_REG,
           CP,                                     // Clock.
           RB,                                     // Clear input 
           SB;
    
// FUNCTION : NEGATIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH
//            ASYNCHRONOUS SET AND CLEAR ( ACTIVE LOW ) /STANDARD DRIVE ( Q OUTPUT UDP ).



    table
      //   CP    RB    SB        NOTIFIER_REG  :  QTN  :  QTN+1
           f     1     1            ?          :   0   :    1   ;     // Toggle condition.
           f     1     1            ?          :   1   :    0   ;   


           ?     0     1            ?          :   ?   :    0   ;     //asynchronous reset.
           ?     ?     0            ?          :   ?   :    1   ;     //asynchronous set.
                         
          (?1)   ?     ?            ?          :   ?   :    -   ;
          (0x)   ?     ?            ?          :   ?   :    -   ;
           ?    (?1)   ?            ?          :   ?   :    -   ;
           ?     ?    (?1)          ?          :   ?   :    -   ;

           f     x     1            ?          :   1   :    0   ;     // pessimism
           f     1     x            ?          :   0   :    1   ;     // pessimism  
           ?     x     1            ?          :   0   :    0   ;
           ?     1     x            ?          :   1   :    1   ;
           ?     ?     ?            *          :   ?   :    x   ;

    endtable

endprimitive
primitive U_FT_N_SB_RB_QN (QN, CP, RB, SB);


// FUNCTION : NEGATIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH
//            ASYNCHRONOUS SET AND CLEAR ( ACTIVE LOW ) /STANDARD DRIVE ( QN OUTPUT UDP ).

    output QN; 
    reg    QN;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    

    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           f     1     1      :   1   :    0   ;     // Toggle condition.
           f     1     1      :   0   :    1   ;   


           ?     0     ?      :   ?   :    1   ;     //asynchronous reset.
           ?     1     0      :   ?   :    0   ;     //asynchronous set.
                          
          (?1)   ?     ?      :   ?   :    -   ;
          (0x)   ?     ?      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           f     x     1      :   0   :    1   ;     // pessimism
           f     1     x      :   1   :    0   ;     // pessimism  
           ?     x     1      :   1   :    1   ;
           ?     1     x      :   0   :    0   ;

    endtable

endprimitive

primitive U_FT_N_TE_RB_SB (Q, TE, CP, RB, SB);

// FUNCTION :  NEGATIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH TOGGLE ENABLE
//             AND ACTIVE LOW ASYNCHRONOUS SET AND RESET ( Q OUTPUT UDP ).
//

    output Q; 
    reg    Q;
    input  TE,
           CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;                                     // Set input
    

    table
      //   TE     CP       RB      SB      :  QTN  :  QTN+1
           1      f        1       1       :   0   :    1   ;     // Toggle condition.
           1      f        1       1       :   1   :    0   ;
                                        
           1     (?1)      ?       ?       :   ?   :    -   ;
           1     (0x)      ?       ?       :   ?   :    -   ;
                                        
           ?      ?       (?1)     ?       :   ?   :    -   ;
           ?      ?        ?      (?1)     :   ?   :    -   ;
           ?      ?        0       ?       :   ?   :    0   ;  
           ?      ?        1       0       :   ?   :    1   ;  
           1      f        x       1       :   1   :    0   ;     // pessimism
           1      f        1       x       :   0   :    1   ;     // pessimism
                                        
           0      ?        1       1       :   ?   :    -   ;  
           ?      ?        x       1       :   0   :    0   ;
           ?      ?        1       x       :   1   :    1   ;  
           *      ?        ?       ?       :   ?   :    -   ;  

    endtable


endprimitive

primitive U_FT_P_PLD  (Q, CP, PD, PLD); 

    output Q;  
    input  
           CP, PD, PLD;
    reg    Q; 
    
    // FUNCTION :  POSITIVE EDGE TRIGGERED TOGGLE FLIP-FLOP WITH
    //             PARALLEL LOAD . ( Q OUTPUT UDP )

    table
 
    // CP      PD PLD    :   Qt  :   Qt+1
                        
       (01)    ?   1     :   0   :   1;  // toggle
       (01)    ?   1     :   1   :   0;
                        
                        
       (?0)    ?   1     :   ?   :   -;  // ignore falling clock
       (1x)    ?   1     :   ?   :   -;  // ignore falling clock
                        
        ?      0   0     :   ?   :   0;  // load parallel data
        ?      1   0     :   ?   :   1;  // load parallel data   

       (01)    1   x     :   0   :   1; // reducing pessimism
       (01)    0   x     :   1   :   0;                      
             
        ?      1   x     :   1   :   1; // reducing pessimism
        ?      0   x     :   0   :   0;


        ?      *   ?     :   ?   :   -;  // ignore edges      
        ?      ?  (?1)   :   ?   :   -;  // ignore edges 

    endtable
endprimitive

primitive U_FT_P_PLD_NO  (Q, CP, PD, PLD, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           CP, PD, PLD;
    reg    Q; 
    
    // FUNCTION :  POSITIVE EDGE TRIGGERED TOGGLE FLIP-FLOP WITH
    //             PARALLEL LOAD . ( Q OUTPUT UDP )


    table
 
    // CP      PD PLD     NOTIFIER_REG  :   Qt  :   Qt+1
                            
       (01)    ?   1         ?          :   0   :   1;  // toggle
       (01)    ?   1         ?          :   1   :   0;
                            
                            
       (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
       (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
                            
        ?     (?0) 0         ?          :   ?   :   0;  // load parallel data
        ?     (?1) 0         ?          :   ?   :   1;  // load parallel data   

        ?      0  (?0)       ?          :   ?   :   0;  // load parallel data
        ?      1  (?0)       ?          :   ?   :   1;  // load parallel data   

       (01)    1   x         ?          :   0   :   1; // reducing pessimism
       (01)    0   x         ?          :   1   :   0;                      
             
        ?      1  (?x)       ?          :   1   :   1; // reducing pessimism
        ?      0  (?x)       ?          :   0   :   0;

        ?    (?1)  x         ?          :   1   :   1; // reducing pessimism
        ?    (?0)  x         ?          :   0   :   0;


        ?      *   1         ?          :   ?   :   -;  // ignore edges      
        ?      ?  (?1)       ?          :   ?   :   -;  // ignore edges 

        ?      ?   ?         *          :   ?   :   x; 
    endtable
endprimitive
primitive U_FT_P_RB (Q, CP, RB);


// FUNCTION :  TOGGLE FLIP FLOP WITH CLEAR ACTIVE LOW / STANDARD DRIVE ( Q OUTPUT UDP )

    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           RB;                                     // Clear input.
    

    table
      //   CP       RB      :  QTN  :  QTN+1
           r        1       :   0   :    1   ;     // Toggle condition.
           r        1       :   1   :    0   ;

          (?0)      1       :   ?   :    -   ;
          (1x)      1       :   ?   :    -   ;

           ?       (?1)     :   ?   :    -   ;
           ?        0       :   ?   :    0   ;  
           r        x       :   1   :    0   ;     // pessimism
           
           ?        x       :   0   :    0   ; 

    endtable

endprimitive
primitive U_FT_P_RB_NO (Q, CP, RB, NOTIFIER_REG); 

 
 
 

    output Q; 
    reg    Q;
    input  NOTIFIER_REG,
           CP,                                     // Clock.
           RB;                                     // Clear input
// FUNCTION :  TOGGLE FLIP FLOP WITH CLEAR ACTIVE LOW / STANDARD DRIVE ( Q OUTPUT UDP )


    table
      //   CP       RB         NOTIFIER_REG  :  QTN  :  QTN+1
           r        1             ?          :   0   :    1   ;     // Toggle condition.
           r        1             ?          :   1   :    0   ;

          (?0)      ?             ?          :   ?   :    -   ;
          (1x)      ?             ?          :   ?   :    -   ;

           ?       (?1)           ?          :   ?   :    -   ;
           ?        0             ?          :   ?   :    0   ;  
           r        x             ?          :   1   :    0   ;     // pessimism
           
           0        x             ?          :   0   :    0   ; 
           x        x             ?          :   0   :    0   ; 
           1       (?x)           ?          :   0   :    0   ; 

           ?        ?             *          :   ?   :    x   ; 

    endtable

endprimitive

primitive U_FT_P_RB_PLD  (Q, CP, PD, PLD, RB);

    output Q;  
    input  CP, PD, PLD, RB;
    reg    Q; 
    
    // FUNCTION :  POSITIVE EDGE TRIGGERED TOGGLE FLIP-FLOP WITH
    //             ACTIVE LOW ASYNCHRONOUS CLEAR AND PARALLEL LOAD . ( Q OUTPUT UDP )

    table
 
   // CP    PD PLD  RB  :   Qt  :   Qt+1
                         
      r      ?   1   1   :   0   :   1;  // toggle
      r      ?   1   1   :   1   :   0;

     (?0)    ?   1   1   :   ?   :   -;  // no toggle
     (1x)    ?   1   1   :   ?   :   -;

      ?      ?   ?   0   :   ?   :   0;  // asynchronous clear

      ?      0   0   1   :   ?   :   0;  // load parallel data
      ?      1   0   1   :   ?   :   1;  // load parallel data

      r      ?   1   x   :   1   :   0;
      ?      ?   1   x   :   0   :   0;

      r      1   x   1   :   0   :   1;  // Reducing pessimism
      r      0   x   1   :   1   :   0;
      ?      1   x   1   :   1   :   1;  // Reducing pessimism
      ?      0   x   1   :   0   :   0;

      r      0   x   x   :   1   :   0;
      ?      0   x   x   :   0   :   0;

      ?      *   ?   ?   :   ?   :   -;  // ignore edges on data     
      ?      ?   *   1   :   ?   :   -;  // ignore edges load data enable
      ?      ?   1  (?1) :   ?   :   -;  // ignore the edges on clear 

    endtable
endprimitive

primitive U_FT_P_RB_PLD_NO  (Q, CP, PD, PLD, RB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           CP, PD, PLD, RB;
    reg    Q; 
    
    // FUNCTION :  POSITIVE EDGE TRIGGERED TOGGLE FLIP-FLOP WITH
    //             ACTIVE LOW ASYNCHRONOUS CLEAR AND PARALLEL LOAD . ( Q OUTPUT UDP )


    table
 
   // CP    PD  PLD  RB     NOTIFIER_REG  :   Qt  :   Qt+1
                         
      r      ?   1   1         ?          :   0   :   1;  // toggle
      r      ?   1   1         ?          :   1   :   0;

     (?0)    ?   ?   1         ?          :   ?   :   -;  // no toggle
     (1x)    ?   ?   1         ?          :   ?   :   -;

      ?      ?   ?   0         ?          :   ?   :   0;  // asynchronous clear
                       
      ?     (?0) 0   1         ?          :   ?   :   0;  // load parallel data
      ?     (?1) 0   1         ?          :   ?   :   1;  // load parallel data   

      ?      0  (?0) 1         ?          :   ?   :   0;  // load parallel data
      ?      1  (?0) 1         ?          :   ?   :   1;  // load parallel data   

     (01)    1   x   1         ?          :   0   :   1; // reducing pessimism
     (01)    0   x   1         ?          :   1   :   0;                      
             
      ?      1  (?x) 1         ?          :   1   :   1; // reducing pessimism
      ?      0  (?x) 1         ?          :   0   :   0;

      ?    (?1)  x   1         ?          :   1   :   1; // reducing pessimism
      ?    (?0)  x   1         ?          :   0   :   0;

      r      ?   1   x         ?          :   1   :   0;
      ?      ?   1  (?x)       ?          :   0   :   0;
      ?      ?  (?1) x         ?          :   0   :   0;

      r      0   x   x         ?          :   1   :   0;
      ?      0  (?x) x         ?          :   0   :   0;
      ?      0   x  (?x)       ?          :   0   :   0;
      ?    (?0)  x   x         ?          :   0   :   0;

      ?      ?   1  (?1)       ?          :   ?   :   -;  // ignore the edges on clear 
      ?      0   0  (?1)       ?          :   ?   :   0;
      ?      1   0  (?1)       ?          :   ?   :   1;

      ?      *   1   1         ?          :   ?   :   -;
      ?      ?  (?1) 1         ?          :   ?   :   -;

      ?      ?   ?   ?         *          :   ?   :   x;

    endtable
endprimitive
primitive U_FT_P_RB_SB (Q, CP, RB, SB);
                       
//
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ACTIVE LOW  ( Q OUTPUT UDP ).


    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    

    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           r     1     1      :   0   :    1   ;     // Toggle condition.
           r     1     1      :   1   :    0   ;

           ?     0     ?      :   ?   :    0   ;     //asynchronous reset.
           ?     1     0      :   ?   :    1   ;     //asynchronous set.
                         
          (?0)   1     1      :   ?   :    -   ;
          (1x)   1     1      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           r     x     1      :   1   :    0   ;     // pessimism
           r     1     x      :   0   :    1   ;     // pessimism  
           ?     x     1      :   0   :    0   ;
           ?     1     x      :   1   :    1   ;

    endtable

endprimitive
primitive U_FT_P_RB_SB_NO (Q, CP, RB, SB, NOTIFIER_REG); 
                       
 


    output Q; 
    reg    Q;
    input  NOTIFIER_REG,
           CP,                                     // Clock.
           RB,                                     // Clear input  
           SB;
    
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ACTIVE LOW  ( Q OUTPUT UDP ).



    table
      //   CP    RB    SB        NOTIFIER_REG  :  QTN  :  QTN+1
           r     1     1            ?          :   0   :    1   ;     // Toggle condition.
           r     1     1            ?          :   1   :    0   ;

           ?     0     ?            ?          :   ?   :    0   ;     //asynchronous reset.
           ?     1     0            ?          :   ?   :    1   ;     //asynchronous set.
                         
          (?0)   ?     ?            ?          :   ?   :    -   ;
          (1x)   ?     ?            ?          :   ?   :    -   ;
           ?    (?1)   1            ?          :   ?   :    -   ;
           ?     ?    (?1)          ?          :   ?   :    -   ;

           r     x     1            ?          :   1   :    0   ;     // pessimism
           r     1     x            ?          :   0   :    1   ;     // pessimism  
    
           0     x     1            ?          :   0   :    0   ;
           x    (?x)   1            ?          :   0   :    0   ;
           1    (?x)   1            ?          :   0   :    0   ;

           0     1     x            ?          :   1   :    1   ;
           x     1    (?x)          ?          :   1   :    1   ;
           1     1    (?x)          ?          :   1   :    1   ;

           ?     ?     ?            *          :   ?   :    x   ;

    endtable

endprimitive
primitive U_FT_P_RB_SB_QN (QN, CP, RB, SB);
                       
//
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ILLEGAL OUPUT WHEN BOTH CLEAR AND PRESET ARE LOW ( QN OUTPUT UDP ).


    output QN; 
    reg    QN;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    

    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           r     1     1      :   1   :    0   ;     // Toggle condition.
           r     1     1      :   0   :    1   ;

           ?     0     1      :   ?   :    1   ;     //asynchronous reset.
           ?     1     0      :   ?   :    0   ;     //asynchronous set.
           ?     0     0      :   ?   :    0   ;    
                         
          (?0)   1     1      :   ?   :    -   ;
          (1x)   1     1      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           r     x     1      :   0   :    1   ;     // pessimism
           r     1     x      :   1   :    0   ;     // pessimism  
           ?     x     1      :   1   :    1   ;
           ?     1     x      :   0   :    0   ;

    endtable

endprimitive
primitive U_FT_P_RB_SB_X (Q, CP, RB, SB);
                       
//
// FUNCTION : TOGGLE FLIP FLOP WITH ASYNCHRONOUS CLEAR AND PRESET
//            ILLEGAL OUPUT WHEN BOTH CLEAR AND PRESET ARE LOW ( Q OUTPUT UDP ).


    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    

    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           r     1     1      :   0   :    1   ;     // Toggle condition.
           r     1     1      :   1   :    0   ;

           ?     0     1      :   ?   :    0   ;     //asynchronous reset.
           ?     1     0      :   ?   :    1   ;     //asynchronous set.
           ?     0     0      :   ?   :    x   ;     //illegal
                         
          (?0)   1     1      :   ?   :    -   ;
          (1x)   1     1      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           r     x     1      :   1   :    0   ;     // pessimism
           r     1     x      :   0   :    1   ;     // pessimism  
           ?     x     1      :   0   :    0   ;
           ?     1     x      :   1   :    1   ;

    endtable

endprimitive
primitive U_FT_P_SB (Q, CP, SB);

//
// FUNCTION : POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH
//            ASYNCHRONOUS SET ( ACTIVE LOW ) /STANDARD DRIVE ( Q OUTPUT UDP ).
//

    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           SB;                                     // Set input.
    

    table
      //   CP       SB      :  QTN  :  QTN+1
           r        1       :   0   :    1   ;     // Toggle condition.
           r        1       :   1   :    0   ;

          (?0)      1       :   ?   :    -   ;
          (1x)      1       :   ?   :    -   ;
           ?       (?1)     :   ?   :    -   ;

           ?        0       :   ?   :    1   ;     
           r        x       :   0   :    1   ;     // pessimism
           
           ?        x       :   1   :    1   ;      

 
   endtable                                  

endprimitive
primitive U_FT_P_SB_NO (Q, CP, SB, NOTIFIER_REG); 

 
 
 

    output Q; 
    reg    Q;
    input  NOTIFIER_REG,
           CP,                                     // Clock.
           SB;                                     // Set input 
// FUNCTION : POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH
//            ASYNCHRONOUS SET ( ACTIVE LOW ) /STANDARD DRIVE ( Q OUTPUT UDP ).
//


    table
      //   CP       SB         NOTIFIER_REG  :  QTN  :  QTN+1
           r        1             ?          :   0   :    1   ;     // Toggle condition.
           r        1             ?          :   1   :    0   ;

          (?0)      1             ?          :   ?   :    -   ;
          (1x)      1             ?          :   ?   :    -   ;
           ?       (?1)           ?          :   ?   :    -   ;

           ?        0             ?          :   ?   :    1   ;     
           r        x             ?          :   0   :    1   ;     // pessimism
           
           0        x             ?          :   1   :    1   ;      
           x        x             ?          :   1   :    1   ;      
           1       (?x)           ?          :   1   :    1   ;      
           ?        ?             *          :   ?   :    x   ;
 
   endtable                                  

endprimitive
primitive U_FT_P_SB_RB (Q, CP, RB, SB);


// FUNCTION : POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH
//            ASYNCHRONOUS SET AND CLEAR ( ACTIVE LOW ) /STANDARD DRIVE ( Q OUTPUT UDP ).


    output Q; 
    reg    Q;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    

    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           r     1     1      :   0   :    1   ;     // Toggle condition.
           r     1     1      :   1   :    0   ;   


           ?     0     1      :   ?   :    0   ;     //asynchronous reset.
           ?     ?     0      :   ?   :    1   ;     //asynchronous set.
                         
          (?0)   1     1      :   ?   :    -   ;
          (1x)   1     1      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           r     x     1      :   1   :    0   ;     // pessimism
           r     1     x      :   0   :    1   ;     // pessimism  
           ?     x     1      :   0   :    0   ;
           ?     1     x      :   1   :    1   ;

    endtable

endprimitive
primitive U_FT_P_SB_RB_NO (Q, CP, RB, SB, NOTIFIER_REG); 




    output Q; 
    reg    Q;
    input  NOTIFIER_REG,
           CP,                                     // Clock.
           RB,                                     // Clear input 
           SB;
    
// FUNCTION : POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH
//            ASYNCHRONOUS SET AND CLEAR ( ACTIVE LOW ) /STANDARD DRIVE ( Q OUTPUT UDP ).



    table
      //   CP    RB    SB        NOTIFIER_REG  :  QTN  :  QTN+1
           r     1     1            ?          :   0   :    1   ;     // Toggle condition.
           r     1     1            ?          :   1   :    0   ;   


           ?     0     1            ?          :   ?   :    0   ;     //asynchronous reset.
           ?     ?     0            ?          :   ?   :    1   ;     //asynchronous set.
                         
          (?0)   1     1            ?          :   ?   :    -   ;
          (1x)   1     1            ?          :   ?   :    -   ;
           ?    (?1)   ?            ?          :   ?   :    -   ;
           ?     ?    (?1)          ?          :   ?   :    -   ;

           r     x     1            ?          :   1   :    0   ;     // pessimism
           r     1     x            ?          :   0   :    1   ;     // pessimism  
           ?     x     1            ?          :   0   :    0   ;
           ?     1     x            ?          :   1   :    1   ;
           ?     ?     ?            *          :   ?   :    x   ;

    endtable

endprimitive
primitive U_FT_P_SB_RB_QN (QN, CP, RB, SB);


// FUNCTION : POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH
//            ASYNCHRONOUS SET AND CLEAR ( ACTIVE LOW ) /STANDARD DRIVE ( QN OUTPUT UDP ).

    output QN; 
    reg    QN;
    input  CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;
    

    table
      //   CP    RB    SB     :  QTN  :  QTN+1
           r     1     1      :   1   :    0   ;     // Toggle condition.
           r     1     1      :   0   :    1   ;   


           ?     0     1      :   ?   :    1   ;     //asynchronous reset.
           ?     1     0      :   ?   :    0   ;     //asynchronous set.
           ?     0     0      :   ?   :    1   ;    // Preset Dominates
                          
          (?0)   1     1      :   ?   :    -   ;
          (1x)   1     1      :   ?   :    -   ;
           ?    (?1)   ?      :   ?   :    -   ;
           ?     ?    (?1)    :   ?   :    -   ;

           r     x     1      :   0   :    1   ;     // pessimism
           r     1     x      :   1   :    0   ;     // pessimism  
           ?     x     1      :   1   :    1   ;
           ?     1     x      :   0   :    0   ;

    endtable

endprimitive

primitive U_FT_P_TE_PLD  (Q, TE, CP, PD, PLD); 

    output Q;  
    input  TE, CP, PD, PLD;

    reg    Q; 
    
    //
    // FUNCTION : POSITIVE EDGE TRIGGERED TOGGLE FLIP-FLOP WITH PARALLEL LOAD
    //            AND TOGGLE ENABLE ( Q OUPUT UDP ).

    table
 
    // TE  CP     PD PLD   :   Qt  :   Qt+1
                         
       1  (01)    ?   0    :   0   :   1;  // toggle
       1  (01)    ?   0    :   1   :   0;
                         
                         
       ?  (?0)    ?   0    :   ?   :   -;  // ignore falling clock
       ?  (1x)    ?   0    :   ?   :   -;  // ignore falling clock
                         
       ?   ?      0   1    :   ?   :   0;  // load parallel data
       ?   ?      1   1    :   ?   :   1;  // load parallel data   

       1  (01)    1   x    :   0   :   1; // reducing pessimism
       1  (01)    0   x    :   1   :   0;                      
             
       ?   ?      1   x    :   1   :   1; // reducing pessimism
       ?   ?      0   x    :   0   :   0; 
       0   ?      ?   0    :   ?   :   -; 


       ?   ?      *   ?    :   ?   :   -;  // ignore edges      
       ?   ?      ?   *    :   ?   :   -;  // ignore edges 
       *   ?      ?   0    :   ?   :   -;

    endtable
endprimitive

primitive U_FT_P_TE_PLD_NO  (Q, TE, CP, PD, PLD, NOTIFIER_REG); 

    output Q;  
    input  TE, CP, PD, PLD, NOTIFIER_REG;

    reg    Q; 
    
    //
    // FUNCTION : POSITIVE EDGE TRIGGERED TOGGLE FLIP-FLOP WITH PARALLEL LOAD
    //            AND TOGGLE ENABLE ( Q OUPUT UDP ).


    table
 
    // TE  CP     PD PLD     NOTIFIER_REG  :   Qt  :   Qt+1
                            
       1  (01)    ?   0         ?          :   0   :   1;  // toggle
       1  (01)    ?   0         ?          :   1   :   0;

       ?  (?0)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
       ?  (1x)    ?   ?         ?          :   ?   :   -;  // ignore falling clock
                            
       ?   ?     (?0) 1         ?          :   ?   :   0;  // load parallel data
       ?   ?     (?1) 1         ?          :   ?   :   1;  // load parallel data   

       ?   ?      0  (?1)       ?          :   ?   :   0;  // load parallel data
       ?   ?      1  (?1)       ?          :   ?   :   1;  // load parallel data   

       1  (01)    1   x         ?          :   0   :   1; // reducing pessimism
       1  (01)    0   x         ?          :   1   :   0;                      
             
       ?   ?      1  (?x)       ?          :   1   :   1; // reducing pessimism
       ?   ?      0  (?x)       ?          :   0   :   0;

       ?   ?    (?1)  x         ?          :   1   :   1; // reducing pessimism
       ?   ?    (?0)  x         ?          :   0   :   0;

       0   ?      ?   0         ?          :   ?   :   -;

       ?   ?      *   0         ?          :   ?   :   -;  // ignore edges      
       ?   ?      ?  (?0)       ?          :   ?   :   -;  // ignore edges 
       *   ?      ?   ?         ?          :   ?   :   -;
 
       ?   ?      ?   ?         *          :   ?   :   x; 

    endtable
endprimitive

primitive U_FT_P_TE_RB (Q, TE, CP, RB);

//
// FUNCTION : POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH ACTIVE LOW CLEAR
//            AND TOGGLE ENABLE ( Q OUTPUT UDP ) .


    output Q; 
    reg    Q;
    input  TE,
           CP,                                     // Clock.
           RB;                                     // Clear input.
    

    table
      //   TE     CP       RB      :  QTN  :  QTN+1
           1      r        1       :   0   :    1   ;     // Toggle condition.
           1      r        1       :   1   :    0   ;
                         
           1     (?0)      1       :   ?   :    -   ;
           1     (1x)      1       :   ?   :    -   ;
                         
           ?      ?       (?1)     :   ?   :    -   ;
           ?      ?        0       :   ?   :    0   ;  
           1      r        x       :   1   :    0   ;     // pessimism
           
           ?      ?        x       :   0   :    0   ;
 
           0      ?        1       :   ?   :    -   ;  
           *      ?        ?       :   ?   :    -   ;  

    endtable

endprimitive

primitive U_FT_P_TE_RB_NO (Q, TE, CP, RB, NOTIFIER_REG); 

 


    output Q; 
    reg    Q;
    input  NOTIFIER_REG,
           TE,
           CP,                                     // Clock
           RB;                                     // Clear input  
    
// FUNCTION : POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH ACTIVE LOW CLEAR
//            AND TOGGLE ENABLE ( Q OUTPUT UDP ) .



    table
      //   TE     CP       RB         NOTIFIER_REG  :  QTN  :  QTN+1
           1      r        1             ?          :   0   :    1   ;     // Toggle condition.
           1      r        1             ?          :   1   :    0   ;
                         
           1     (?0)      1             ?          :   ?   :    -   ;
           1     (1x)      1             ?          :   ?   :    -   ;
                         
           ?      ?       (?1)           ?          :   ?   :    -   ;
           ?      ?        0             ?          :   ?   :    0   ;  
           1      r        x             ?          :   1   :    0   ;     // pessimism
           
           ?      ?        x             ?          :   0   :    0   ;
 
           0      ?        1             ?          :   ?   :    -   ;  
           *      ?        ?             ?          :   ?   :    -   ;  
           ?      ?        ?             *          :   ?   :    x   ;  


    endtable

endprimitive

primitive U_FT_P_TE_RB_SB (Q, TE, CP, RB, SB);

// FUNCTION :  POSITIVE EDGE TRIGGERED TOGGLE FLIP FLOP WITH TOGGLE ENABLE
//             AND ACTIVE LOW ASYNCHRONOUS SET AND RESET ( Q OUTPUT UDP ).
//

    output Q; 
    reg    Q;
    input  TE,
           CP,                                     // Clock.
           RB,                                     // Clear input.
           SB;                                     // Set input
    

    table
      //   TE     CP       RB      SB      :  QTN  :  QTN+1
           1      r        1       1       :   0   :    1   ;     // Toggle condition.
           1      r        1       1       :   1   :    0   ;
                                        
           1     (?0)      1       1       :   ?   :    -   ;
           1     (1x)      1       1       :   ?   :    -   ;
                                        
           ?      ?       (?1)     ?       :   ?   :    -   ;
           ?      ?        ?      (?1)     :   ?   :    -   ;
           ?      ?        0       ?       :   ?   :    0   ;  
           ?      ?        1       0       :   ?   :    1   ;  
           1      r        x       1       :   1   :    0   ;     // pessimism
           1      r        1       x       :   0   :    1   ;     // pessimism
                                        
           0      ?        1       1       :   ?   :    -   ;  
           ?      ?        x       1       :   0   :    0   ;
           ?      ?        1       x       :   1   :    1   ;  
           *      ?        ?       ?       :   ?   :    -   ;  

    endtable


endprimitive
primitive U_IAI_2_3 (YN, A, B, C);

    output  YN;
    input   A, B, C;

// FUNCTION : TO IMPLEMENT THE LOGIC EQUATION  YN = ~( ~A & ~B & C )

    table
    // A  B  C    :  YN

       1  ?  ?    :  1 ;
       ?  1  ?    :  1 ;

       0  0  1    :  0 ;
       ?  ?  0    :  1 ;

    endtable
endprimitive
      

primitive	U_IAOI_2_2 (Z, A1, B1, A2, B2);
	output Z;
	input  A1, B1, A2, B2;

// FUNCTION : TO IMPLEMENT THE LOGIC EQUATION  Z = ~( A1 & ~B1 || A2 & B2 )

	table
	//	A1	B1	A2	B2	:	Z

		0	?	0	?	:	1	;
		?	1	0	?	:	1	;
		0	?	?	0	:	1	;
		?	1	?	0	:	1	;

		?	?	1	1	:	0	;
		1	0	?	?	:	0	;


	endtable
endprimitive
primitive	U_IAO_2_2 (Z, A1, B1, A2, B2);
	output Z;
	input  A1, B1, A2, B2;

// FUNCTION : TO IMPLEMENT THE LOGIC EQUATION  Z = ( A1 & ~B1 || A2 & B2 )

	table
	//	A1	B1	A2	B2	:	Z

		0	?	0	?	:	0	;
		?	1	0	?	:	0	;
		0	?	?	0	:	0	;
		?	1	?	0	:	0	;

		?	?	1	1	:	1	;
		1	0	?	?	:	1	;

	endtable
endprimitive
primitive U_IA_2_3 (Y, A, B, C);

    output  Y;
    input   A, B, C;

// FUNCTION : TO IMPLEMENT THE LOGIC EQUATION  Y = ( ~A & ~B & C )
    
    table
    // A  B  C    :  Y

       1  ?  ?    :  0 ;
       ?  1  ?    :  0 ;

       0  0  1    :  1 ;
       ?  ?  0    :  0 ;

    endtable
endprimitive
      


primitive U_LD_N (Q, D, GN); 

//
// FUNCTION :  D-LATCH, GATED  ACTIVE LOW / STANDARD DRIVE ( Q OUTPUT UDP )
//

    output Q; 
    reg    Q;                               
    input  D, 
           GN;       // Gate- active low

    table
     //  D     GN    : Qt  :   Qt+1

         ?      1    :  ?  :    -   ;   //clock disabled

         0      0    :  ?  :    0   ;  //clock enabled transparent
         1      0    :  ?  :    1   ;  //data

         1      x    :  1  :    1   ;  //reducing pessimism
         0      x    :  0  :    0   ; 
         
         ?      p    :  ?  :    -   ;                   

   endtable

endprimitive

primitive U_LD_N_CEB_NO (Q, D, ACLK, BCLK, NOTIFIER_REG); 

    output Q; 

    input  NOTIFIER_REG,
           D,  ACLK, BCLK;

    reg    Q;                               

// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS ( Q OUTPUT UDP ) .


    table
//   D   ACLK      BCLK      NOTIFIER_REG  :  Qt  :  Qt+1
                      
     1  (?0)      0             ?          :  ?   :   1;
     1  (1x)      0             ?          :  1   :   1;
     1    0      (?0)           ?          :  ?   :   1;
     1    0      (1x)           ?          :  1   :   1;
     0  (?0)      0             ?          :  ?   :   0;
     0  (1x)      0             ?          :  0   :   0;
     0    0      (?0)           ?          :  ?   :   0;
     0    0      (1x)           ?          :  0   :   0;
    
    (?1)  0       0             ?          :  ?   :   1;
    (?0)  0       0             ?          :  ?   :   0;

     *    1       ?             ?          :  ?   :   -;
     *    ?       1             ?          :  ?   :   -;

   (?1)   ?       ?             ?          :  1   :   1;   // Reducing Pessimism
   (?0)   ?       ?             ?          :  0   :   0;
  
     ?    p       ?             ?          :  ?   :   -;  
     ?    n       1             ?          :  ?   :   -;  
     ?    1       n             ?          :  ?   :   -;  
     ?    ?       p             ?          :  ?   :   -;  
     ?    ?       ?             *          :  ?   :   x;

    endtable
endprimitive

primitive U_LD_N_CEB_RB_NO (Q, D, G, E, R, NOTIFIER_REG); 

    output Q; 

    input  NOTIFIER_REG,
           D,  G, E, R;

    reg    Q;                               

// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS  AND RESET ( Q OUTPUT UDP ) .

    table
//       D       G      E      R   NOTIFIER_REG      :  Qt  :  Qt+1
                      
         *       1      ?      1       ?             :  ?  :    -   ;
         *       ?      1      1       ?             :  ?  :    -   ;

         ?       ?      ?      0       ?             :  ?  :    0   ;

         ?      (?1)    ?      ?       ?             :  ?  :    -   ;
         ?      (0x)    ?      ?       ?             :  ?  :    -   ; 
         ?       ?    (?1)     ?       ?             :  ?  :    -   ;
         ?       ?    (0x)     ?       ?             :  ?  :    -   ; 
      
         0      (1x)    0      1       ?             :  0  :    0   ;
         1      (1x)    0      1       ?             :  1  :    1   ;
         0      (x0)    0      1       ?             :  ?  :    0   ;
         1      (x0)    0      1       ?             :  ?  :    1   ;

         0       0    (1x)     1       ?             :  0  :    0   ;
         1       0    (1x)     1       ?             :  1  :    1   ;
         0       0    (x0)     1       ?             :  ?  :    0   ;
         1       0    (x0)     1       ?             :  ?  :    1   ;

        (?0)     0      0      1       ?             :  ?  :    0   ;
        (?1)     0      0      1       ?             :  ?  :    1   ;

         0     (10)     0      1       ?             :  ?  :    0   ;
         0       0     (10)    1       ?             :  ?  :    0   ;
         1     (10)     0      1       ?             :  ?  :    1   ;
         1       0     (10)    1       ?             :  ?  :    1   ;

         ?       1      ?     (?x)     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       ?      1     (?x)     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       1      ?       x      ?             :  0  :    0   ;   // Reducing pessimism//AB
         *       ?      1       x      ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     0      x       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
        (?0)     x      0       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
        (?0)     x      x       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0       0      x       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      0       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      x       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0       0    (1x)      x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (1x)    0       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0      (?0)    0       x      ?             :  ?  :    0   ; // Reducing pessimism.
         0       0     (?0)     x      ?             :  ?  :    0   ; // Reducing pessimism.

        (?0)     0      0       x      ?             :  ?  :    0   ; // Reducing pessimism.
         0       0      0      (?x)    ?             :  ?  :    0   ;   // Reducing pessimism.//AB
 
         ?       1      ?      (?1)    ?             :  ?  :    -   ; // ignore edge on clear
         ?       ?      1      (?1)    ?             :  ?  :    -   ; // ignore edge on clear
         0       0      0      (?1)    ?             :  ?  :    0   ;
         1       0      0      (?1)    ?             :  ?  :    1   ;

        (?1)     0      x       1      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      0       1      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      x       1      ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     0      x       1      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      0       1      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      x       1      ?             :  0  :    0   ; // Reducing pessimism.
 
         ?       n      1       ?      ?             :  ?  :    -   ;
         ?       1      n       ?      ?             :  ?  :    -   ;
         ?       ?      ?       ?      *             :  ?  :    x   ;
 
    endtable
endprimitive

primitive U_LD_N_CEB_R_NO (Q, D, G, E, R, NOTIFIER_REG); 

    output Q; 

    input  NOTIFIER_REG,
           D,  G, E, R;

    reg    Q;                               

// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS  AND RESET ( Q OUTPUT UDP ) .

    table
//       D       G      E      R   NOTIFIER_REG      :  Qt  :  Qt+1
                      
         *       1      ?      0       ?             :  ?  :    -   ;
         *       ?      1      0       ?             :  ?  :    -   ;

         ?       ?      ?      1       ?             :  ?  :    0   ;

         ?      (?1)    ?      ?       ?             :  ?  :    -   ;
         ?      (0x)    ?      ?       ?             :  ?  :    -   ; //AB
         ?       ?    (?1)     ?       ?             :  ?  :    -   ;
         ?       ?    (0x)     ?       ?             :  ?  :    -   ; //AB
      
         0      (1x)    0      0       ?             :  0  :    0   ;
         1      (1x)    0      0       ?             :  1  :    1   ;
         0      (x0)    0      0       ?             :  ?  :    0   ;
         1      (x0)    0      0       ?             :  ?  :    1   ;

         0       0    (1x)     0       ?             :  0  :    0   ;
         1       0    (1x)     0       ?             :  1  :    1   ;
         0       0    (x0)     0       ?             :  ?  :    0   ;
         1       0    (x0)     0       ?             :  ?  :    1   ;

        (?0)     0      0      0       ?             :  ?  :    0   ;
        (?1)     0      0      0       ?             :  ?  :    1   ;

         0     (10)     0      0       ?             :  ?  :    0   ;
         0       0     (10)    0       ?             :  ?  :    0   ;
         1     (10)     0      0       ?             :  ?  :    1   ;
         1       0     (10)    0       ?             :  ?  :    1   ;

         ?       1      ?     (?x)     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       ?      1     (?x)     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       1      ?       x      ?             :  0  :    0   ;   // Reducing pessimism//AB
         *       ?      1       x      ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     0      x       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
        (?0)     x      0       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
        (?0)     x      x       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0       0      x       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      0       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      x       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0       0    (1x)      x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (1x)    0       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0      (?0)    0       x      ?             :  ?  :    0   ; // Reducing pessimism.
         0       0     (?0)     x      ?             :  ?  :    0   ; // Reducing pessimism.

        (?0)     0      0       x      ?             :  ?  :    0   ; // Reducing pessimism.
         0       0      0      (?x)    ?             :  ?  :    0   ;   // Reducing pessimism.//AB
 
         ?       1      ?      (?0)    ?             :  ?  :    -   ; // ignore edge on clear
         ?       ?      1      (?0)    ?             :  ?  :    -   ; // ignore edge on clear
         0       0      0      (?0)    ?             :  ?  :    0   ;
         1       0      0      (?0)    ?             :  ?  :    1   ;
 
        (?1)     0      x       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      0       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      x       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     0      x       0      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      0       0      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      x       0      ?             :  0  :    0   ; // Reducing pessimism.
 
         ?       n      1       ?      ?             :  ?  :    -   ;
         ?       1      n       ?      ?             :  ?  :    -   ;
         ?       ?      ?       ?      *             :  ?  :    x   ;
 
    endtable
endprimitive

primitive U_LD_N_CEB_SB_NO (Q, D, G, E, S, NOTIFIER_REG); 

    output Q; 

    input  NOTIFIER_REG,
           D, G, E, S;

    reg    Q;                               

// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS  AND PRESET ( Q OUTPUT UDP ) .


    table
//       D       G      E      S   NOTIFIER_REG      :  Qt  :  Qt+1
                      
         *       1      ?      1       ?             :  ?  :    -   ;
         *       ?      1      1       ?             :  ?  :    -   ;

         ?       ?      ?      0       ?             :  ?  :    1   ;

         ?      (?1)    ?      ?       ?             :  ?  :    -   ;
         ?      (0x)    ?      ?       ?             :  ?  :    -   ; //AB
         ?       ?    (?1)     ?       ?             :  ?  :    -   ;
         ?       ?    (0x)     ?       ?             :  ?  :    -   ; //AB
      
         0      (1x)    0      1       ?             :  0  :    0   ;
         1      (1x)    0      1       ?             :  1  :    1   ;
         0      (x0)    0      1       ?             :  ?  :    0   ;
         1      (x0)    0      1       ?             :  ?  :    1   ;

         0       0    (1x)     1       ?             :  0  :    0   ;
         1       0    (1x)     1       ?             :  1  :    1   ;
         0       0    (x0)     1       ?             :  ?  :    0   ;
         1       0    (x0)     1       ?             :  ?  :    1   ;

        (?0)     0      0      1       ?             :  ?  :    0   ;
        (?1)     0      0      1       ?             :  ?  :    1   ;

         0     (10)     0      1       ?             :  ?  :    0   ;
         0       0     (10)    1       ?             :  ?  :    0   ;
         1     (10)     0      1       ?             :  ?  :    1   ;
         1       0     (10)    1       ?             :  ?  :    1   ;

         ?       1      ?     (?x)     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       ?      1     (?x)     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       1      ?       x      ?             :  1  :    1   ;   // Reducing pessimism//AB
         *       ?      1       x      ?             :  1  :    1   ;   // Reducing pessimism//AB

        (?1)     0      x       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
        (?1)     x      0       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
        (?1)     x      x       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1       0      x       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      0       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      x       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1       0    (1x)      x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (1x)    0       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1      (?0)    0       x      ?             :  ?  :    1   ; // Reducing pessimism.
         1       0     (?0)     x      ?             :  ?  :    1   ; // Reducing pessimism.

        (?1)     0      0       x      ?             :  ?  :    1   ; // Reducing pessimism.
         1       0      0      (?x)    ?             :  ?  :    1   ;   // Reducing pessimism.//AB
 
         ?       1      ?      (?1)    ?             :  ?  :    -   ; // ignore edge on clear
         ?       ?      1      (?1)    ?             :  ?  :    -   ; // ignore edge on clear
         0       0      0      (?1)    ?             :  ?  :    0   ;
         1       0      0      (?1)    ?             :  ?  :    1   ;
 
        (?1)     0      x       1      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      0       1      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      x       1      ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     0      x       1      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      0       1      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      x       1      ?             :  0  :    0   ; // Reducing pessimism.
 
         ?       n      1       ?      ?             :  ?  :    -   ;
         ?       1      n       ?      ?             :  ?  :    -   ;
         ?       ?      ?       ?      *             :  ?  :    x   ;
 
    endtable
endprimitive

primitive U_LD_N_CEB_S_NO (Q, D, G, E, S, NOTIFIER_REG); 

    output Q; 

    input  NOTIFIER_REG,
           D, G, E, S;

    reg    Q;                               

// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS  AND PRESET ( Q OUTPUT UDP ) .


    table
//       D       G      E      S   NOTIFIER_REG      :  Qt  :  Qt+1
                      
         *       1      ?      0       ?             :  ?  :    -   ;
         *       ?      1      0       ?             :  ?  :    -   ;

         ?       ?      ?      1       ?             :  ?  :    1   ;

         ?      (?1)    ?      ?       ?             :  ?  :    -   ;
         ?      (0x)    ?      ?       ?             :  ?  :    -   ; //AB
         ?       ?    (?1)     ?       ?             :  ?  :    -   ;
         ?       ?    (0x)     ?       ?             :  ?  :    -   ; //AB
      
         0      (1x)    0      0       ?             :  0  :    0   ;
         1      (1x)    0      0       ?             :  1  :    1   ;
         0      (x0)    0      0       ?             :  ?  :    0   ;
         1      (x0)    0      0       ?             :  ?  :    1   ;

         0       0    (1x)     0       ?             :  0  :    0   ;
         1       0    (1x)     0       ?             :  1  :    1   ;
         0       0    (x0)     0       ?             :  ?  :    0   ;
         1       0    (x0)     0       ?             :  ?  :    1   ;

        (?0)     0      0      0       ?             :  ?  :    0   ;
        (?1)     0      0      0       ?             :  ?  :    1   ;

         0     (10)     0      0       ?             :  ?  :    0   ;
         0       0     (10)    0       ?             :  ?  :    0   ;
         1     (10)     0      0       ?             :  ?  :    1   ;
         1       0     (10)    0       ?             :  ?  :    1   ;

         ?       1      ?     (?x)     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       ?      1     (?x)     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       1      ?       x      ?             :  1  :    1   ;   // Reducing pessimism//AB
         *       ?      1       x      ?             :  1  :    1   ;   // Reducing pessimism//AB

        (?1)     0      x       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
        (?1)     x      0       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
        (?1)     x      x       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1       0      x       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      0       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      x       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1       0    (1x)      x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (1x)    0       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1      (?0)    0       x      ?             :  ?  :    1   ; // Reducing pessimism.
         1       0     (?0)     x      ?             :  ?  :    1   ; // Reducing pessimism.

        (?1)     0      0       x      ?             :  ?  :    1   ; // Reducing pessimism.
         1       0      0      (?x)    ?             :  ?  :    1   ;   // Reducing pessimism.//AB
 
         ?       1      ?      (?0)    ?             :  ?  :    -   ; // ignore edge on clear
         ?       ?      1      (?0)    ?             :  ?  :    -   ; // ignore edge on clear
         0       0      0      (?0)    ?             :  ?  :    0   ;
         1       0      0      (?0)    ?             :  ?  :    1   ;
 
        (?1)     0      x       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      0       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      x       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     0      x       0      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      0       0      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      x       0      ?             :  0  :    0   ; // Reducing pessimism.
 
         ?       n      1       ?      ?             :  ?  :    -   ;
         ?       1      n       ?      ?             :  ?  :    -   ;
         ?       ?      ?       ?      *             :  ?  :    x   ;
 
    endtable
endprimitive

primitive U_LD_N_CE_R_NO (Q, D, G, E, R, NOTIFIER_REG); 

    output Q; 

    input  NOTIFIER_REG,
           D,  G, E, R;

    reg    Q;                               

// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS  AND RESET ( Q OUTPUT UDP ) .


    table
//       D       G      E      R   NOTIFIER_REG      :  Qt  :  Qt+1
                      
         *       1      ?      0       ?             :  ?  :    -   ;
         *       ?      0      0       ?             :  ?  :    -   ;

         ?       ?      ?      1       ?             :  ?  :    0   ;

         ?      (?1)    ?      ?       ?             :  ?  :    -   ;
         ?      (0x)    ?      ?       ?             :  ?  :    -   ; //AB
         ?       ?    (?0)     ?       ?             :  ?  :    -   ;
         ?       ?    (1x)     ?       ?             :  ?  :    -   ; //AB
      
         0      (1x)    1      0       ?             :  0  :    0   ;
         1      (1x)    1      0       ?             :  1  :    1   ;
         0      (x0)    1      0       ?             :  ?  :    0   ;
         1      (x0)    1      0       ?             :  ?  :    1   ;

         0       0    (0x)     0       ?             :  0  :    0   ;
         1       0    (0x)     0       ?             :  1  :    1   ;
         0       0    (x1)     0       ?             :  ?  :    0   ;
         1       0    (x1)     0       ?             :  ?  :    1   ;

        (?0)     0      1      0       ?             :  ?  :    0   ;
        (?1)     0      1      0       ?             :  ?  :    1   ;

         0     (10)     1      0       ?             :  ?  :    0   ;
         0       0     (01)    0       ?             :  ?  :    0   ;
         1     (10)     1      0       ?             :  ?  :    1   ;
         1       0     (01)    0       ?             :  ?  :    1   ;

         ?       1      ?     (?x)     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       ?      0     (?x)     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       1      ?       x      ?             :  0  :    0   ;   // Reducing pessimism//AB
         *       ?      0       x      ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     0      x       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
        (?0)     x      1       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
        (?0)     x      x       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0       0      x       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      1       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      x       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0       0    (0x)      x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (1x)    1       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0      (?0)    1       x      ?             :  ?  :    0   ; // Reducing pessimism.
         0       0     (?1)     x      ?             :  ?  :    0   ; // Reducing pessimism.

        (?0)     0      1       x      ?             :  ?  :    0   ; // Reducing pessimism.
         0       0      1      (?x)    ?             :  ?  :    0   ;   // Reducing pessimism.//AB
 
         ?       1      ?      (?0)    ?             :  ?  :    -   ; // ignore edge on clear
         ?       ?      0      (?0)    ?             :  ?  :    -   ; // ignore edge on clear
         0       0      1      (?0)    ?             :  ?  :    0   ;
         1       0      1      (?0)    ?             :  ?  :    1   ;
 
        (?1)     0      x       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      1       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      x       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     0      x       0      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      1       0      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      x       0      ?             :  0  :    0   ; // Reducing pessimism.
 
         ?       n      0       ?      ?             :  ?  :    -   ;
         ?       1      p       ?      ?             :  ?  :    -   ;
         ?       ?      ?       ?      *             :  ?  :    x   ;
 
    endtable
endprimitive

primitive U_LD_N_CE_S_NO (Q, D, G, E, S, NOTIFIER_REG); 

    output Q; 

    input  NOTIFIER_REG,
           D, G, E, S;

    reg    Q;                               

// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS  AND PRESET ( Q OUTPUT UDP ) .


    table
//       D       G      E      S   NOTIFIER_REG      :  Qt  :  Qt+1
                      
         *       1      ?      0       ?             :  ?  :    -   ;
         *       ?      0      0       ?             :  ?  :    -   ;

         ?       ?      ?      1       ?             :  ?  :    1   ;

         ?      (?1)    ?      ?       ?             :  ?  :    -   ;
         ?      (0x)    ?      ?       ?             :  ?  :    -   ; //AB
         ?       ?    (?0)     ?       ?             :  ?  :    -   ;
         ?       ?    (1x)     ?       ?             :  ?  :    -   ; //AB
      
         0      (1x)    1      0       ?             :  0  :    0   ;
         1      (1x)    1      0       ?             :  1  :    1   ;
         0      (x0)    1      0       ?             :  ?  :    0   ;
         1      (x0)    1      0       ?             :  ?  :    1   ;

         0       0    (0x)     0       ?             :  0  :    0   ;
         1       0    (0x)     0       ?             :  1  :    1   ;
         0       0    (x1)     0       ?             :  ?  :    0   ;
         1       0    (x1)     0       ?             :  ?  :    1   ;

        (?0)     0      1      0       ?             :  ?  :    0   ;
        (?1)     0      1      0       ?             :  ?  :    1   ;

         0     (10)     1      0       ?             :  ?  :    0   ;
         0       0     (01)    0       ?             :  ?  :    0   ;
         1     (10)     1      0       ?             :  ?  :    1   ;
         1       0     (01)    0       ?             :  ?  :    1   ;

         ?       1      ?     (?x)     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       ?      0     (?x)     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       1      ?       x      ?             :  1  :    1   ;   // Reducing pessimism//AB
         *       ?      0       x      ?             :  1  :    1   ;   // Reducing pessimism//AB

        (?1)     0      x       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
        (?1)     x      1       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
        (?1)     x      x       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1       0      x       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      1       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      x       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1       0    (0x)      x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (1x)    1       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1      (?0)    1       x      ?             :  ?  :    1   ; // Reducing pessimism.
         1       0     (?1)     x      ?             :  ?  :    1   ; // Reducing pessimism.

        (?1)     0      1       x      ?             :  ?  :    1   ; // Reducing pessimism.
         1       0      1      (?x)    ?             :  ?  :    1   ;   // Reducing pessimism.//AB
 
         ?       1      ?      (?0)    ?             :  ?  :    -   ; // ignore edge on clear
         ?       ?      0      (?0)    ?             :  ?  :    -   ; // ignore edge on clear
         0       0      1      (?0)    ?             :  ?  :    0   ;
         1       0      1      (?0)    ?             :  ?  :    1   ;
 
        (?1)     0      x       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      1       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?1)     x      x       0      ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     0      x       0      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      1       0      ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      x       0      ?             :  0  :    0   ; // Reducing pessimism.
 
         ?       n      0       ?      ?             :  ?  :    -   ;
         ?       1      p       ?      ?             :  ?  :    -   ;
         ?       ?      ?       ?      *             :  ?  :    x   ;
 
    endtable
endprimitive


primitive U_LD_N_NO (Q, D, GN, NOTI_REG); 

 
 
 

    output Q; 
    reg    Q;                               
    input  D,                // data
           GN,                // clock
           NOTI_REG;         // NOTIFY_REG
// FUNCTION :  D-LATCH, GATED  ACTIVE LOW / STANDARD DRIVE ( Q OUTPUT UDP )
//


   table
     //  D       GN    NOTI_REG        : Qt  :   Qt+1

         ?      (0x)    ?             :  ?  :    -   ;
         ?      (?1)    ?             :  ?  :    -   ;

         *       1      ?             :  ?  :    -   ;

       (?0)      0      ?             :  ?  :    0   ;
       (?1)      0      ?             :  ?  :    1   ; 
        0       (10)    ?             :  ?  :    0   ;
        1       (10)    ?             :  ?  :    1   ; 

       (?1)      x      ?             :  1  :    1   ;    // Reducing pessimism.
       (?0)      x      ?             :  0  :    0   ; 

         0      (1x)    ?             :  0  :    0   ;   // Reducing pessimism.
         1      (1x)    ?             :  1  :    1   ;
         0      (x0)    ?             :  ?  :    0   ;
         1      (x0)    ?             :  ?  :    1   ;
         
         ?       ?      *             :  ?  :    x   ;

   endtable

endprimitive

primitive U_LD_N_RB (Q, D, GN, RB); 

//
// FUNCTION : D-LATCH, CLEAR DIRECT( ACTIVE LOW ), GATE ACTIVE LOW 
//             STANDARD DRIVE ( Q OUTPUT UDP )


    output Q; 
    reg    Q;                               
    input  D,
           GN,                                      // Gate- active low
           RB;                                      // Clear- active low

    table
     //  D     GN      RB      : Qt  :   Qt+1
   
         ?      1      1       :  ?  :    -   ;     // latch state

         0      0      1       :  ?  :    0   ;     // latch data
         1      0      1       :  ?  :    1   ;            

         1      x      1       :  1  :    1   ;     // Reducing pessimism.
         0      x      1       :  0  :    0   ;     // Reducing pessimism.

         ?      p      1       :  ?  :    -   ;     // Reducing pessimism. 


         ?      ?      0       :  ?  :    0   ;    // clear    
     
         ?      1      x       :  0  :    0   ;      // Reducing pessimism.
         0      0      x       :  ?  :    0   ;      // Reducing pessimism.
         0      ?      x       :  0  :    0   ;      // Reducing pessimism.

    endtable

endprimitive


primitive U_LD_N_RB_NO (Q, D, GN, RB, NOTI_REG); 



    output Q; 
    reg    Q;                               
    input  D,               // DATA
           GN,               // CLOCK
           RB,              // CLEAR ACTIVE LOW
           NOTI_REG;        // NOTIFY REG
// FUNCTION : D-LATCH, CLEAR DIRECT( ACTIVE LOW ), GATE ACTIVE LOW 
//             STANDARD DRIVE ( Q OUTPUT UDP )



   table
     //  D      GN       RB    NOTI_REG       : Qt  :   Qt+1
                     
         *      1        1      ?             :  ?  :    -   ;
                     
         ?      ?        0      ?             :  ?  :    0   ; // asynchro clear
                     
         ?     (?1)      ?      ?             :  ?  :    -   ; //AB
         ?     (0X)      ?      ?             :  ?  :    -   ; //AB
                     
         0     (X0)      1      ?             :  ?  :    0   ;
         1     (X0)      1      ?             :  ?  :    1   ;
         0     (1X)      1      ?             :  0  :    0   ;
         1     (1X)      1      ?             :  1  :    1   ;
                     
        (?0)    0        1      ?             :  ?  :    0   ;
        (?1)    0        1      ?             :  ?  :    1   ; 
         0     (10)      1      ?             :  ?  :    0   ;
         1     (10)      1      ?             :  ?  :    1   ; 
                     
         ?       1     (?x)     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       1       x      ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     x       x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x       *      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (1x)     x      ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0     (?0)      x      ?             :  ?  :    0   ; // Reducing pessimism.
        (?0)    0        x      ?             :  ?  :    0   ; // Reducing pessimism.
         0      0      (?x)     ?             :  ?  :    0   ;   // Reducing pessimism.//AB
                     
         ?      1       (?1)    ?             :  ?  :    -   ; // ignore edge on clear
         0      0       (?1)    ?             :  ?  :    0   ;
         1      0       (?1)    ?             :  ?  :    1   ;
                     
        (?1)    x        1      ?             :  1  :    1   ; // Reducing pessimism.
        (?0)    x        1      ?             :  0  :    0   ; // Reducing pessimism.
                     
         ?      ?        ?      *             :  ?  :    x   ;
                     
   endtable

endprimitive

primitive U_LD_N_RB_SB_X ( Q, D, CK, RB, SB );
    output Q; 
    reg    Q;
    input  D,
          CK,
          RB,
          SB;

// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).

table
    //  D   CK  RB  SB  :   Qt  :   Qt+1

        1   0   1   1   :   ?   :   1;  // clock enabled transparent data.
        0   0   1   1   :   ?   :   0;

        1   x   1   1   :   1   :   1;  // possible enabled clock.
        0   x   1   1   :   0   :   0;

        ?   ?   0   1   :   ?   :   0;  // asynchronous reset.
        ?   ?   1   0   :   ?   :   1;  // asynchronous set
        ?   ?   0   0   :   ?   :   x;  // Illegal output 

        ?   1   1   1   :   ?   :   -;  // clock disabled.

        0   0   x   1   :   ?   :   0;  // pessimism 
        0   ?   x   1   :   0   :   0;  // pessimism 
        1   0   1   x   :   ?   :   1;  // pessimism 
        1   ?   1   x   :   1   :   1;  // pessimism                       

        ?   1   x   1   :   0  :    0;  // set inactive                    
        ?   1   1   x   :   1  :    1;  // reset inactive 
      
        ?   p   1   1   :   ?  :    -;                 
                                              
    endtable 

endprimitive


primitive U_LD_N_R_S_X ( Q, D, CK, R, S );
    output Q; 
    reg    Q;
    input  D,
          CK,
          R,
          S;

// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).

table
    //  D   CK  R   S   :   Qt  :   Qt+1

        1   0   0   0   :   ?   :   1;  // clock enabled transparent data.
        0   0   0   0   :   ?   :   0;

        1   x   0   0   :   1   :   1;  // possible enabled clock.
        0   x   0   0   :   0   :   0;

        ?   ?   1   0   :   ?   :   0;  // asynchronous reset.
        ?   ?   0   1   :   ?   :   1;  // asynchronous set
        ?   ?   1   1   :   ?   :   x;  // Illegal output 

        ?   1   0   0   :   ?   :   -;  // clock disabled.

        0   0   x   0   :   ?   :   0;  // pessimism 
        0   ?   x   0   :   0   :   0;  // pessimism 
        1   0   0   x   :   ?   :   1;  // pessimism 
        1   ?   0   x   :   1   :   1;  // pessimism                       

        ?   1   x   0   :   0  :    0;  // set inactive                    
        ?   1   0   x   :   1  :    1;  // reset inactive 
      
        ?   p   0   0   :   ?  :    -;                 
                                              
    endtable 

endprimitive



primitive U_LD_N_R_S_X_NO (Q, D, GN, R, S, NOTI_REG); 

 
 

    output Q; 
    reg    Q;                               
    input  D,               // DATA
           GN,               // CLOCK
           R,              // CLEAR ACTIVE HIGH
           S,              // SET ACTIVE HIGH
           NOTI_REG;        // NOTIFY_REG
// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).


   table
     //  D       GN     RB    SB   NOTI_REG       : Qtn :   Qtn+1
                                  
         *       1      0     0     ?             :  ?  :    -   ;
                                  
         ?       ?      1     0     ?             :  ?  :    0   ; // asynchro clear
     
         ?       ?      0     1     ?             :  ?  :    1   ; 

         ?       ?      1     1     ?             :  ?  :    x   ;  // Illegal output 
                                                                    // occurs 
         ?      (?1)    ?     ?     ?             :  ?  :    -   ;  //AB
         ?      (0x)    ?     ?     ?             :  ?  :    -   ;  //AB
                                  
         0      (1x)    0     0     ?             :  0  :    0   ;
         1      (1x)    0     0     ?             :  1  :    1   ;
         0      (x0)    0     0     ?             :  ?  :    0   ;
         1      (x0)    0     0     ?             :  ?  :    1   ;
                                  
        (?0)     0      0     0     ?             :  ?  :    0   ;
        (?1)     0      0     0     ?             :  ?  :    1   ; 
         0      (10)    0     0     ?             :  ?  :    0   ;
         1      (10)    0     0     ?             :  ?  :    1   ; 
                                  
       
         ?       1     (?x)   0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       1      x    (?0)   ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       1      x     0     ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     x      x     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      *     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (1x)    x     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      x    (?0)   ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0      (?0)    x     0     ?             :  ?  :    0   ; // Reducing pessimism.
        (?0)     0      x     0     ?             :  ?  :    0   ; // Reducing pessimism.
         0       0     (?x)   0     ?             :  ?  :    0   ; // Reducing pessimism.//AB
         0       0      x    (?0)   ?             :  ?  :    0   ; // Reducing pessimism.//AB
     
        
         ?       1      0    (?x)   ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       1     (?0)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       1      0     x     ?             :  1  :    1   ;   // Reducing pessimism//AB
 
        (?1)     x      0     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      0     *     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (1x)    0     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x     (?0)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB

      
         1      (?0)    0     x     ?             :  ?  :    1   ; // Reducing pessimism.
        (?1)     0      0     x     ?             :  ?  :    1   ; // Reducing pessimism.
         1       0     (?0)   x     ?             :  ?  :    1   ; // Reducing pessimism.//AB
         1       0      0    (?x)   ?             :  ?  :    1   ; // Reducing pessimism.//AB
                                  
         ?       1     (?0)   0     ?             :  ?  :    -   ;   // ignore edge on clear
         0       0     (?0)   0     ?             :  ?  :    0   ;   // pessimism .
         1       0     (?0)   0     ?             :  ?  :    1   ;  

                                  
         ?       1      0    (?0)   ?             :  ?  :    -   ;   // ignore edge on set
         0       0      0    (?0)   ?             :  ?  :    0   ;   // pessimism .
         1       0      0    (?0)   ?             :  ?  :    1   ;  

        (?1)     x      0     0     ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     x      0     0     ?             :  0  :    0   ; // Reducing pessimism.
                                  
         ?       ?      ?     ?     *             :  ?  :    x   ;

   endtable

endprimitive

primitive U_LD_N_SB ( Q, D, GN, SB );
  
      output Q;
      reg    Q;
      input  D, 
             GN,
            SB;

// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP ).

table
    //  D     GN    SB       :   Qt  :   Qt+1
                  
        1     0    1        :   ?   :   1  ;  // clock enabled transparent data.
        0     0    1        :   ?   :   0  ; 

        1     x    1        :   1   :   1  ;  // possible enabled clock.
        0     x    1        :   0   :   0  ;
                        
        ?     ?    0        :   ?   :   1  ;  // asynchronous set.   

        ?     1    1        :   ?   :   -  ;  // clock disabled.

        1     0    x        :   ?   :   1  ;  // pessimism 
        1     ?    x        :   1   :   1  ;  // pessimism
        ?     1    x        :   1   :   1  ;  // pessimism  

        ?     p    1        :   ?   :   -  ; 

    endtable

endprimitive


primitive U_LD_N_SB_NO (Q, D, GN, SB, NOTI_REG); 

 
 
 

    output Q; 
    reg    Q;                               
    input  D,               // DATA
           GN,               // CLOCK
           SB,              // SET ACTIVE LOW
           NOTI_REG;        // NOTIFY REG
// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP ).


   table
     //  D      GN       SB    NOTI_REG       : Qt  :   Qt+1
                     
         *      1        1      ?             :  ?  :    -   ;
                     
         ?      ?        0      ?             :  ?  :    1   ; // asynchro SET
                     
         ?     (?1)      ?      ?             :  ?  :    -   ; //AB
         ?     (0X)      ?      ?             :  ?  :    -   ; //AB
                     
         0     (X0)      1      ?             :  ?  :    0   ;
         1     (X0)      1      ?             :  ?  :    1   ;
         0     (1X)      1      ?             :  0  :    0   ;
         1     (1X)      1      ?             :  1  :    1   ;
                     
        (?0)    0        1      ?             :  ?  :    0   ;
        (?1)    0        1      ?             :  ?  :    1   ; 
         0     (10)      1      ?             :  ?  :    0   ;
         1     (10)      1      ?             :  ?  :    1   ; 
                     
       
         ?       1     (?x)     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       1       x      ?             :  1  :    1   ;   // Reducing pessimism//AB

        (?1)     x       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (1x)     x      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1     (?0)      x      ?             :  ?  :    1   ; // Reducing pessimism.
        (?1)    0        x      ?             :  ?  :    1   ; // Reducing pessimism.
         1      0       (?x)    ?             :  ?  :    1   ; // Reducing pessimism.
                     
         ?      1       (?1)    ?             :  ?  :    -   ; // ignore edge on clear
         0      0       (?1)    ?             :  ?  :    0   ;
         1      0       (?1)    ?             :  ?  :    1   ;
                     
        (?1)    x        1      ?             :  1  :    1   ; // Reducing pessimism.
        (?0)    x        1      ?             :  0  :    0   ; // Reducing pessimism.
                     
         ?      ?        ?      *             :  ?  :    x   ;
                     
   endtable

endprimitive

primitive U_LD_N_SB_RB ( Q, D, CK, RB, SB );
    output Q; 
    reg    Q;
    input  D,
          CK,
          RB,
          SB;

// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).

table
    //  D   CK  RB  SB  :   Qt  :   Qt+1

        1   0   1   1   :   ?   :   1;  // clock enabled transparent data.
        0   0   1   1   :   ?   :   0;

        1   x   1   1   :   1   :   1;  // possible enabled clock.
        0   x   1   1   :   0   :   0;

        ?   ?   0   1   :   ?   :   0;  // asynchronous reset.
        ?   ?   ?   0   :   ?   :   1;  // asynchronous set override.

        ?   1   1   1   :   ?   :   -;  // clock disabled.

        0   0   x   1   :   ?   :   0;  // pessimism 
        0   ?   x   1   :   0   :   0;  // pessimism 
        1   0   1   x   :   ?   :   1;  // pessimism 
        1   ?   1   x   :   1   :   1;  // pessimism                       

        ?   1   x   1   :   0  :    0;  // set inactive                    
        ?   1   1   x   :   1  :    1;  // reset inactive 
      
        ?   p   1   1   :   ?  :    -;                 
                                              
    endtable 

endprimitive



primitive U_LD_N_SB_RB_NO (Q, D, GN, RB, SB, NOTI_REG); 

 
 

    output Q; 
    reg    Q;                               
    input  D,               // DATA
           GN,               // CLOCK
           RB,              // CLEAR ACTIVE LOW
           SB,              // SET ACTIVE LOW
           NOTI_REG;        // NOTIFY_REG
// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).


   table
     //  D       GN     RB    SB   NOTI_REG       : Qtn :   Qtn+1
                                  
         *       1      1     1     ?             :  ?  :    -   ;
                                  
         ?       ?      0     1     ?             :  ?  :    0   ; // asynchro clear
     
         ?       ?      ?     0     ?             :  ?  :    1   ; 
                                                                    // occurs 
         ?      (?1)    1     1     ?             :  ?  :    -   ;  //AB
         ?      (0x)    1     1     ?             :  ?  :    -   ;  //AB
                                  
         0      (1x)    1     1     ?             :  0  :    0   ;
         1      (1x)    1     1     ?             :  1  :    1   ;
         0      (x0)    1     1     ?             :  ?  :    0   ;
         1      (x0)    1     1     ?             :  ?  :    1   ;
                                  
        (?0)     0      1     1     ?             :  ?  :    0   ;
        (?1)     0      1     1     ?             :  ?  :    1   ; 
         0      (10)    1     1     ?             :  ?  :    0   ;
         1      (10)    1     1     ?             :  ?  :    1   ; 
                                  
//       0       ?      x     1     ?             :  0  :    0   ; // Reducing pessimism.//AB
       
         ?       1     (?x)   1     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       1      x    (?1)   ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       1      x     1     ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     x      x     1     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      *     1     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (1x)    x     1     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      x    (?1)   ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0      (?0)    x     1     ?             :  ?  :    0   ; // Reducing pessimism.
        (?0)     0      x     1     ?             :  ?  :    0   ; // Reducing pessimism.
         0       0     (?x)   1     ?             :  ?  :    0   ; // Reducing pessimism.//AB
         0       0      x    (?1)   ?             :  ?  :    0   ; // Reducing pessimism.//AB
     
//       1       ?      1     x     ?             :  1  :    1   ; // Reducing pessimism.
        
         ?       1      1    (?x)   ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       1     (?1)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       1      1     x     ?             :  1  :    1   ;   // Reducing pessimism//AB
 
        (?1)     x      1     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      1     *     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (1x)    1     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x     (?1)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB

      
         1      (?0)    1     x     ?             :  ?  :    1   ; // Reducing pessimism.
        (?1)     0      1     x     ?             :  ?  :    1   ; // Reducing pessimism.
         1       0     (?1)   x     ?             :  ?  :    1   ; // Reducing pessimism.//AB
         1       0      1    (?x)   ?             :  ?  :    1   ; // Reducing pessimism.//AB
                                  
         ?       1     (?1)   1     ?             :  ?  :    -   ;   // ignore edge on clear
         0       0     (?1)   1     ?             :  ?  :    0   ;   // pessimism .
         1       0     (?1)   1     ?             :  ?  :    1   ;  

                                  
         ?       1      1    (?1)   ?             :  ?  :    -   ;   // ignore edge on set
         0       0      1    (?1)   ?             :  ?  :    0   ;   // pessimism .
         1       0      1    (?1)   ?             :  ?  :    1   ;  

        (?1)     x      1     1     ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     x      1     1     ?             :  0  :    0   ; // Reducing pessimism.
                                  
         ?       ?      ?     ?     *             :  ?  :    x   ;

   endtable

endprimitive

primitive U_LD_N_SB_RB_QN ( QN, D, CK, RB, SB );
    output QN; 
    reg    QN;
    input  D,
          CK,
          RB,
          SB;

// FUNCTION :  NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//             ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).

table
    //  D   CK  RB  SB  :  QNtn :  QNtn+1

        1   0   1   1   :   ?   :   0;  // clock enabled transparent data.
        0   0   1   1   :   ?   :   1;

        1   x   1   1   :   0   :   0;  // possible enabled clock.
        0   x   1   1   :   1   :   1;

        ?   ?   0   1   :   ?   :   1;  // asynchronous reset.
        ?   ?   1   0   :   ?   :   0;  // asynchronous set 
        ?   ?   0   0   :   ?   :   1;  // asynchronous set override.

        ?   1   1   1   :   ?   :   -;  // clock disabled.

        0   0   x   1   :   ?   :   1;  // pessimism 
        0   ?   x   1   :   1   :   1;  // pessimism 
        1   0   1   x   :   ?   :   0;  // pessimism 
        1   ?   1   x   :   0   :   0;  // pessimism                       

        ?   1   x   1   :   1  :    1;  // set inactive                    
        ?   1   1   x   :   0  :    0;  // reset inactive 
      
        ?   p   1   1   :   ?  :    -;                 
                                              
    endtable 

endprimitive


primitive U_LD_N_S_R ( Q, D, CK, R, S );
    output Q; 
    reg    Q;
    input  D,
          CK,
          R,
          S;

// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).

table
    //  D   CK  R   S   :   Qt  :   Qt+1

        1   0   0   0   :   ?   :   1;  // clock enabled transparent data.
        0   0   0   0   :   ?   :   0;

        1   x   0   0   :   1   :   1;  // possible enabled clock.
        0   x   0   0   :   0   :   0;

        ?   ?   1   0   :   ?   :   0;  // asynchronous reset.
        ?   ?   ?   1   :   ?   :   1;  // asynchronous set override.

        ?   1   0   0   :   ?   :   -;  // clock disabled.

        0   0   x   0   :   ?   :   0;  // pessimism 
        0   ?   x   0   :   0   :   0;  // pessimism 
        1   0   0   x   :   ?   :   1;  // pessimism 
        1   ?   0   x   :   1   :   1;  // pessimism                       

        ?   1   x   0   :   0  :    0;  // set inactive                    
        ?   1   0   x   :   1  :    1;  // reset inactive 
      
        ?   p   0   0   :   ?  :    -;                 
                                              
    endtable 

endprimitive



primitive U_LD_N_S_R_NO (Q, D, GN, R, S, NOTI_REG); 


    output Q; 
    reg    Q;                               
    input  D,               // DATA
           GN,              // CLOCK
           R,               // CLEAR ACTIVE HIGH
           S,               // SET ACTIVE HIGH
           NOTI_REG;        // NOTIFY_REG
// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).


   table
     //  D       GN     RB    SB   NOTI_REG       : Qtn :   Qtn+1
                                  
         *       1      0     0     ?             :  ?  :    -   ;
                                  
         ?       ?      1     0     ?             :  ?  :    0   ; // asynchro clear
     
         ?       ?      ?     1     ?             :  ?  :    1   ; 
                                                                    // occurs 
         ?      (?1)    0     0     ?             :  ?  :    -   ;  //AB
         ?      (0x)    0     0     ?             :  ?  :    -   ;  //AB
                                  
         0      (1x)    0     0     ?             :  0  :    0   ;
         1      (1x)    0     0     ?             :  1  :    1   ;
         0      (x0)    0     0     ?             :  ?  :    0   ;
         1      (x0)    0     0     ?             :  ?  :    1   ;
                                  
        (?0)     0      0     0     ?             :  ?  :    0   ;
        (?1)     0      0     0     ?             :  ?  :    1   ; 
         0      (10)    0     0     ?             :  ?  :    0   ;
         1      (10)    0     0     ?             :  ?  :    1   ; 
                                  
//       0       ?      x     0     ?             :  0  :    0   ; // Reducing pessimism.//AB
       
         ?       1     (?x)   0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       1      x    (?0)   ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       1      x     0     ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     x      x     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      *     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (1x)    x     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      x    (?0)   ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0      (?0)    x     0     ?             :  ?  :    0   ; // Reducing pessimism.
        (?0)     0      x     0     ?             :  ?  :    0   ; // Reducing pessimism.
         0       0     (?x)   0     ?             :  ?  :    0   ; // Reducing pessimism.//AB
         0       0      x    (?0)   ?             :  ?  :    0   ; // Reducing pessimism.//AB
     
//       1       ?      0     x     ?             :  1  :    1   ; // Reducing pessimism.
        
         ?       1      0    (?x)   ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       1     (?0)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       1      0     x     ?             :  1  :    1   ;   // Reducing pessimism//AB
 
        (?1)     x      0     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      0     *     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (1x)    0     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x     (?0)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB

      
         1      (?0)    0     x     ?             :  ?  :    1   ; // Reducing pessimism.
        (?1)     0      0     x     ?             :  ?  :    1   ; // Reducing pessimism.
         1       0     (?0)   x     ?             :  ?  :    1   ; // Reducing pessimism.//AB
         1       0      0    (?x)   ?             :  ?  :    1   ; // Reducing pessimism.//AB
                                  
         ?       1     (?0)   0     ?             :  ?  :    -   ;   // ignore edge on clear
         0       0     (?0)   0     ?             :  ?  :    0   ;   // pessimism .
         1       0     (?0)   0     ?             :  ?  :    1   ;  

                                  
         ?       1      0    (?0)   ?             :  ?  :    -   ;   // ignore edge on set
         0       0      0    (?0)   ?             :  ?  :    0   ;   // pessimism .
         1       0      0    (?0)   ?             :  ?  :    1   ;  

        (?1)     x      0     0     ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     x      0     0     ?             :  0  :    0   ; // Reducing pessimism.
                                  
         ?       ?      ?     ?     *             :  ?  :    x   ;

   endtable

endprimitive


primitive U_LD_N_S_R_NO_QN (QN, D, GN, R, S, NOTI_REG); 


    output QN; 
    reg    QN;                               
    input  D,               // DATA
           GN,              // CLOCK
           R,               // CLEAR ACTIVE HIGH
           S,               // SET ACTIVE HIGH
           NOTI_REG;        // NOTIFY_REG
// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP ).


   table
     //  D       GN     RB    SB   NOTI_REG       : QNtn :   QNtn+0
                                  
         *       1      0     0     ?             :  ?  :    -   ;
                                  
         ?       ?      1     ?     ?             :  ?  :    1   ; // asynchro clear
     
         ?       ?      0     1     ?             :  ?  :    0   ; 
                                                                    // occurs 
         ?      (?1)    0     0     ?             :  ?  :    -   ;  //AB
         ?      (0x)    0     0     ?             :  ?  :    -   ;  //AB
                                  
         0      (1x)    0     0     ?             :  1  :    1   ;
         1      (1x)    0     0     ?             :  0  :    0   ;
         0      (x0)    0     0     ?             :  ?  :    1   ;
         1      (x0)    0     0     ?             :  ?  :    0   ;
                                  
        (?0)     0      0     0     ?             :  ?  :    1   ;
        (?1)     0      0     0     ?             :  ?  :    0   ; 
         0      (10)    0     0     ?             :  ?  :    1   ;
         1      (10)    0     0     ?             :  ?  :    0   ; 
                                  
//       0       ?      x     0     ?             :  1  :    1   ; // Reducing pessimism.//AB
       
         ?       1     (?x)   0     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       1      x    (?0)   ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       1      x     0     ?             :  1  :    1   ;   // Reducing pessimism//AB

        (?0)     x      x     0     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         0       x      *     0     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         0      (1x)    x     0     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         0       x      x    (?0)   ?             :  1  :    1   ;   // Reducing pessimism.//AB

         0      (?0)    x     0     ?             :  ?  :    1   ; // Reducing pessimism.
        (?0)     0      x     0     ?             :  ?  :    1   ; // Reducing pessimism.
         0       0     (?x)   0     ?             :  ?  :    1   ; // Reducing pessimism.//AB
         0       0      x    (?0)   ?             :  ?  :    1   ; // Reducing pessimism.//AB
     
//       1       ?      0     x     ?             :  0  :    0   ; // Reducing pessimism.
        
         ?       1      0    (?x)   ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       1     (?0)   x     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       1      0     x     ?             :  0  :    0   ;   // Reducing pessimism//AB
 
        (?1)     x      0     x     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         1       x      0     *     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         1      (1x)    0     x     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         1       x     (?0)   x     ?             :  0  :    0   ;   // Reducing pessimism.//AB

      
         1      (?0)    0     x     ?             :  ?  :    0   ; // Reducing pessimism.
        (?1)     0      0     x     ?             :  ?  :    0   ; // Reducing pessimism.
         1       0     (?0)   x     ?             :  ?  :    0   ; // Reducing pessimism.//AB
         1       0      0    (?x)   ?             :  ?  :    0   ; // Reducing pessimism.//AB
                                  
         ?       1     (?0)   0     ?             :  ?  :    -   ;   // ignore edge on clear
         0       0     (?0)   0     ?             :  ?  :    1   ;   // pessimism .
         1       0     (?0)   0     ?             :  ?  :    0   ;  

                                  
         ?       1      0    (?0)   ?             :  ?  :    -   ;   // ignore edge on set
         0       0      0    (?0)   ?             :  ?  :    1   ;   // pessimism .
         1       0      0    (?0)   ?             :  ?  :    0   ;  

        (?1)     x      0     0     ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      0     0     ?             :  1  :    1   ; // Reducing pessimism.
                                  
         ?       ?      ?     ?     *             :  ?  :    x   ;

   endtable

endprimitive

primitive U_LD_N_S_R_QN ( QN, D, CK, R, S );
    output QN; 
    reg    QN;
    input  D,
          CK,
          R,
          S;

// FUNCTION : NEGATIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP ).

table
    //  D   CK  R   S   :   Qtn :  Qtn+1

        1   0   0   0   :   ?   :   0;  // clock enabled transparent data.
        0   0   0   0   :   ?   :   1;

        1   x   0   0   :   0   :   0;  // possible enabled clock.
        0   x   0   0   :   1   :   1;

        ?   ?   1   0   :   ?   :   1;  // asynchronous reset.
        ?   ?   ?   1   :   ?   :   1;  // asynchronous set override.

        ?   1   0   0   :   ?   :   -;  // clock disabled.

        0   0   x   0   :   ?   :   1;  // pessimism 
        0   ?   x   0   :   1   :   1;  // pessimism 
        1   0   0   x   :   ?   :   0;  // pessimism 
        1   ?   0   x   :   0   :   0;  // pessimism                       

        ?   1   x   0   :   1  :    1;  // set inactive                    
        ?   1   0   x   :   0  :    0;  // reset inactive 
      
        ?   p   0   0   :   ?  :    -;                 
                                              
    endtable 

endprimitive


primitive U_LD_P (Q, D, G); 

//
// FUNCTION : DLATCH, GATED  STANDARD DRIVE / ACTIVE HIGH ( Q OUTPUT UDP )
//

    output Q; 
    reg    Q;                               
    input  D, G;

   table
     //  D      G    : Qt  :   Qt+1

         ?      0    :  ?  :    -   ;    // clock disabled   

         0      1    :  ?  :    0   ;  //clock enabled 
         1      1    :  ?  :    1   ;  //transparent data 

         1      x    :  1  :    x   ;  // Reducing pessimism.
         0      x    :  0  :    x   ; 
	 
                                       
         ?      n    :  ?  :    -   ; 

   endtable

endprimitive



primitive U_LD_P_CEB_NO (Q, D, ACLK, BCLK, NOTIFIER_REG); 

    output Q; 

    input  NOTIFIER_REG,
           D,  ACLK, BCLK;

    reg    Q;                               

// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS ( Q OUTPUT UDP ) .


    table
//   D   ACLK      BCLK      NOTIFIER_REG  :  Qt  :  Qt+1
                      
     1  (?1)      0             ?          :  ?   :   1;
     1  (0x)      0             ?          :  1   :   1;
     1    1      (?0)           ?          :  ?   :   1;
     1    1      (1x)           ?          :  1   :   1;
     0  (?1)      0             ?          :  ?   :   0;
     0  (0x)      0             ?          :  0   :   0;
     0    1      (?0)           ?          :  ?   :   0;
     0    1      (1x)           ?          :  0   :   0;
    
    (?1)  1       0             ?          :  ?   :   1;
    (?0)  1       0             ?          :  ?   :   0;

     *    0       ?             ?          :  ?   :   -;
     *    ?       1             ?          :  ?   :   -;

   (?1)   ?       ?             ?          :  1   :   1;   // Reducing Pessimism
   (?0)   ?       ?             ?          :  0   :   0;
  
     ?    n       ?             ?          :  ?   :   -;  
     ?    p       1             ?          :  ?   :   -;  
     ?    0       n             ?          :  ?   :   -;  
     ?    ?       p             ?          :  ?   :   -;  
     ?    ?       ?             *          :  ?   :   x;

    endtable
endprimitive

primitive U_LD_P_CE_NO (Q, D, G, E, NOTIFIER_REG); 

    output Q; 

    input  NOTIFIER_REG,
           D,  G, E;

    reg    Q;                               

// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS ( Q OUTPUT UDP ) .


    table
//   D    G       E      NOTIFIER_REG      :  Qt  :  Qt+1
                      
     1  (?1)      1             ?          :  ?   :   1; 
     1  (0x)      1             ?          :  1   :   1; //AB
     1    1      (?1)           ?          :  ?   :   1;
     1    1      (0x)           ?          :  1   :   1; //AB
     
     0  (?1)      1             ?          :  ?   :   0;
     0  (0x)      1             ?          :  0   :   0; //AB
     0    1      (?1)           ?          :  ?   :   0;
     0    1      (0x)           ?          :  0   :   0; //AB
    
    (?1)  1       1             ?          :  ?   :   1;
    (?0)  1       1             ?          :  ?   :   0;

     *    0       ?             ?          :  ?   :   -;
     *    ?       0             ?          :  ?   :   -;

   (?1)   ?       ?             ?          :  1   :   1;   // Reducing Pessimism
   (?0)   ?       ?             ?          :  0   :   0;
  
     ?    n       ?             ?          :  ?   :   -;  
     ?    p       0             ?          :  ?   :   -;  
     ?    0       p             ?          :  ?   :   -;  
     ?    ?       n             ?          :  ?   :   -;  
     ?    ?       ?             *          :  ?   :   x;

    endtable
endprimitive




primitive U_LD_P_NO (Q, D, G, NOTI_REG); 

    output Q; 
    reg    Q;                               
    input  D,              // data
           G,              // clock
           NOTI_REG;       
// FUNCTION : DLATCH, GATED  STANDARD DRIVE / ACTIVE HIGH ( Q OUTPUT UDP )
//


   table
     //  D       G    NOTI_REG        : Qtn :   Qtn+1

         *       0      ?             :  ?  :    -   ;
         ?      (?0)    ?             :  ?  :    -   ;
         ?      (1x)    ?             :  ?  :    x   ;
	 0      (0x)    ?             :  0  :    x   ;
         1      (0x)    ?             :  1  :    x   ;
         0      (x1)    ?             :  ?  :    0   ;
         1      (x1)    ?             :  ?  :    1   ;
        (?0)     1      ?             :  ?  :    0   ;
        (?1)     1      ?             :  ?  :    1   ; 
         0      (01)    ?             :  ?  :    0   ;
         1      (01)    ?             :  ?  :    1   ; 
        (?1)     x      ?             :  1  :    1   ;    // Reducing pessimism.
        (?0)     x      ?             :  0  :    0   ; 
         
         ?       ?      *             :  ?  :    x   ;


   endtable

endprimitive



primitive U_LD_P_RB (Q, D, G, RB); 

//
// FUNCTION : D-LATCH, GATED  CLEAR DIRECT /GATE ACTIVE HIGH ( Q OUTPUT UDP ) 
//

    output Q; 
    reg    Q;                               
    input  D,
           G,                                       // Gate- active high
           RB;                                      // Clear-active low

    table
     //  D      G     RB       : Qt  :   Qt+1

         ?      0      1       :  ?  :    -   ;     // latch state 

         0      1      1       :  ?  :    0   ;     // latch data
         1      1      1       :  ?  :    1   ;            

         1      x      1       :  1  :    1   ;     // Reducing pessimism.
         0      x      1       :  0  :    0   ;     // Reducing pessimism
       
         ?      n      1       :  ?  :    -   ; 

         ?      ?      0       :  ?  :    0   ;      // Clear

         0      1      x       :  ?  :    0   ;      // Reducing pessimism.
         0      ?      x       :  0  :    0   ;      // Reducing pessimism.
         
         ?      0      x       :  0  :    0   ;      // Reducing pessimism 
   
      endtable

endprimitive


primitive U_LD_P_RB_NO (Q, D, G, RB, NOTI_REG); 

 

    output Q; 
    reg    Q;                               
    input  D,               // DATA
           G,               // CLOCK
           RB,              // CLEAR ACTIVE LOW
           NOTI_REG;        // NOTIFY REG
// FUNCTION : D-LATCH, GATED  CLEAR DIRECT /GATE ACTIVE HIGH ( Q OUTPUT UDP ) 
//


   table
     //  D       G      RB    NOTI_REG       : Qt  :   Qt+1

         *       0      1      ?             :  ?  :    -   ;

         ?       ?      0      ?             :  ?  :    0   ; // asynchro clear

         ?      (?0)    ?      ?             :  ?  :    -   ; //AB
         ?      (1x)    ?      ?             :  ?  :    -   ; //AB

         0      (0x)    1      ?             :  0  :    0   ;
         1      (0x)    1      ?             :  1  :    1   ;
         0      (x1)    1      ?             :  ?  :    0   ;
         1      (x1)    1      ?             :  ?  :    1   ;

        (?0)     1      1      ?             :  ?  :    0   ;
        (?1)     1      1      ?             :  ?  :    1   ; 
         0      (01)    1      ?             :  ?  :    0   ;
         1      (01)    1      ?             :  ?  :    1   ; 

         ?       0     (?x)    ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       0      x      ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     x      x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      *      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (0x)    x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         
         0      (?1)    x      ?             :  ?  :    0   ;   // Reducing pessimism.
        (?0)     1      x      ?             :  ?  :    0   ;   // Reducing pessimism.
         0       1     (?x)    ?             :  ?  :    0   ;   // Reducing pessimism.//AB

         ?       0     (?1)    ?             :  ?  :    -   ;   // ignore edge on clear
         0       1     (?1)    ?             :  ?  :    0   ;   // pessimism .
         1       1     (?1)    ?             :  ?  :    1   ;  

        (?1)     x      1      ?             :  1  :    1   ;   // Reducing pessimism.
        (?0)     x      1      ?             :  0  :    0   ;   // Reducing pessimism.
         
         ?       ?      ?      *             :  ?  :    x   ;

   endtable

endprimitive

primitive U_LD_P_RB_SB_X ( Q, D, CK, RB, SB );
    output Q; 
    reg    Q;
    input  D, 
          CK,
          RB,
          SB;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET. ILLEGAL OUTPUT WHEN BOTH SET AND
//            RESET ARE LOW ( Q OUTPUT UDP ).


table
    //  D   CK  RB  SB  :   Qt  :   Qt+1

        1   1   1   1   :   ?   :   1;  // clock enabled transparent data.
        0   1   1   1   :   ?   :   0;

        1   x   1   1   :   1   :   1;  // possible enabled clock.
        0   x   1   1   :   0   :   0;

        ?   ?   0   1   :   ?   :   0;  // asynchronous reset.
        ?   ?   1   0   :   ?   :   1;  // asynchronous set.
        ?   ?   0   0   :   ?   :   x;  // illegal output.

        ?   0   1   1   :   ?   :   -;  // clock disabled.

        0   1   x   1   :   ?   :   0;  // pessimism 
        0   ?   x   1   :   0   :   0;  // pessimism 
        1   1   1   x   :   ?   :   1;  // pessimism 
        1   ?   1   x   :   1   :   1;  // pessimism

        ?   0   x   1   :   0   :   0;  // set inactive
        ?   0   1   x   :   1   :   1;  // reset inactive  

        ?   n   1   1   :   ?   :   -;

    endtable

endprimitive


primitive U_LD_P_R_S_X ( Q, D, CK, R, S );
    output Q; 
    reg    Q;
    input  D,
          CK,
          R,
          S;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).

table
    //  D   CK  R   S   :   Qt  :   Qt+1

        1   1   0   0   :   ?   :   1;  // clock enabled transparent data.
        0   1   0   0   :   ?   :   0;

        1   x   0   0   :   1   :   1;  // possible enabled clock.
        0   x   0   0   :   0   :   0;

        ?   ?   1   0   :   ?   :   0;  // asynchronous reset.
        ?   ?   0   1   :   ?   :   1;  // asynchronous set
        ?   ?   1   1   :   ?   :   x;  // Illegal output 

        ?   0   0   0   :   ?   :   -;  // clock disabled.

        0   1   x   0   :   ?   :   0;  // pessimism 
        0   ?   x   0   :   0   :   0;  // pessimism 
        1   1   0   x   :   ?   :   1;  // pessimism 
        1   ?   0   x   :   1   :   1;  // pessimism                       

        ?   0   x   0   :   0  :    0;  // set inactive                    
        ?   0   0   x   :   1  :    1;  // reset inactive 
      
        ?   n   0   0   :   ?  :    -;                 
                                              
    endtable 

endprimitive



primitive U_LD_P_R_S_X_NO (Q, D, G, R, S, NOTI_REG); 

 
 

    output Q; 
    reg    Q;                               
    input  D,               // DATA
           G,               // CLOCK
           R,              // CLEAR ACTIVE HIGH
           S,              // SET ACTIVE HIGH
           NOTI_REG;        // NOTIFY_REG
// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).


   table
     //  D       G     RB    SB   NOTI_REG       : Qtn :   Qtn+1
                                  
         *       0      0     0     ?             :  ?  :    -   ;
                                  
         ?       ?      1     0     ?             :  ?  :    0   ; // asynchro clear
     
         ?       ?      0     1     ?             :  ?  :    1   ; 

         ?       ?      1     1     ?             :  ?  :    x   ;  // Illegal output 
                                                                    // occurs 
         ?      (?0)    ?     ?     ?             :  ?  :    -   ;  //AB
         ?      (1x)    ?     ?     ?             :  ?  :    -   ;  //AB
                                  
         0      (0x)    0     0     ?             :  0  :    0   ;
         1      (0x)    0     0     ?             :  1  :    1   ;
         0      (x1)    0     0     ?             :  ?  :    0   ;
         1      (x1)    0     0     ?             :  ?  :    1   ;
                                  
        (?0)     1      0     0     ?             :  ?  :    0   ;
        (?1)     1      0     0     ?             :  ?  :    1   ; 
         0      (01)    0     0     ?             :  ?  :    0   ;
         1      (01)    0     0     ?             :  ?  :    1   ; 
                                  
       
         ?       0     (?x)   0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       0      x    (?0)   ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       0      x     0     ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     x      x     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      *     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (0x)    x     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      x    (?0)   ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0      (?1)    x     0     ?             :  ?  :    0   ; // Reducing pessimism.
        (?0)     1      x     0     ?             :  ?  :    0   ; // Reducing pessimism.
         0       1     (?x)   0     ?             :  ?  :    0   ; // Reducing pessimism.//AB
         0       1      x    (?0)   ?             :  ?  :    0   ; // Reducing pessimism.//AB
     
        
         ?       0      0    (?x)   ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       0     (?0)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       0      0     x     ?             :  1  :    1   ;   // Reducing pessimism//AB
 
        (?1)     x      0     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      0     *     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (0x)    0     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x     (?0)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB

      
         1      (?1)    0     x     ?             :  ?  :    1   ; // Reducing pessimism.
        (?1)     1      0     x     ?             :  ?  :    1   ; // Reducing pessimism.
         1       1     (?0)   x     ?             :  ?  :    1   ; // Reducing pessimism.//AB
         1       1      0    (?x)   ?             :  ?  :    1   ; // Reducing pessimism.//AB
                                  
         ?       0     (?0)   0     ?             :  ?  :    -   ;   // ignore edge on clear
         0       1     (?0)   0     ?             :  ?  :    0   ;   // pessimism .
         1       1     (?0)   0     ?             :  ?  :    1   ;  

                                  
         ?       0      0    (?0)   ?             :  ?  :    -   ;   // ignore edge on set
         0       1      0    (?0)   ?             :  ?  :    0   ;   // pessimism .
         1       1      0    (?0)   ?             :  ?  :    1   ;  

        (?1)     x      0     0     ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     x      0     0     ?             :  0  :    0   ; // Reducing pessimism.
                                  
         ?       ?      ?     ?     *             :  ?  :    x   ;

   endtable

endprimitive

primitive U_LD_P_SB ( Q, D, G, SB );
  
      output Q;
      reg    Q;
      input  D, 
             G,
            SB;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP ).

table
    //  D     G    SB       :   Qt  :   Qt+1
                  
        1     1    1        :   ?   :   1  ;  // clock enabled transparent data.
        0     1    1        :   ?   :   0  ; 

        1     x    1        :   1   :   1  ;  // possible enabled clock.
        0     x    1        :   0   :   0  ;
                        
        ?     ?    0        :   ?   :   1  ;  // asynchronous set.   

        ?     0    1        :   ?   :   -  ;  // clock disabled.

        1     1    x        :   ?   :   1  ;  // pessimism 
        1     ?    x        :   1   :   1  ;  // pessimism
        ?     0    x        :   1   :   1  ;  // pessimism  

        ?     n    1        :   ?   :   -  ; 

    endtable

endprimitive


primitive U_LD_P_SB_NO (Q, D, G, SB, NOTI_REG); 


    output Q; 
    reg    Q;                               
    input  D,               // DATA
           G,               // CLOCK
           SB,              // SET ACTIVE LOW
           NOTI_REG;        // NOTIFY REG
// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP ).


   table
     //  D      G       SB    NOTI_REG       : Qt  :   Qt+1
                     
         *      0        1      ?             :  ?  :    -   ;
                     
         ?      ?        0      ?             :  ?  :    1   ; // asynchro SET
                     
         ?     (?0)      ?      ?             :  ?  :    -   ; //AB
         ?     (1X)      ?      ?             :  ?  :    -   ; //AB
                     
         0     (X1)      1      ?             :  ?  :    0   ;
         1     (X1)      1      ?             :  ?  :    1   ;
         0     (0X)      1      ?             :  0  :    0   ;
         1     (0X)      1      ?             :  1  :    1   ;
                     
        (?0)    1        1      ?             :  ?  :    0   ;
        (?1)    1        1      ?             :  ?  :    1   ; 
         0     (01)      1      ?             :  ?  :    0   ;
         1     (01)      1      ?             :  ?  :    1   ; 
                     
       
         ?       0     (?x)     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       0       x      ?             :  1  :    1   ;   // Reducing pessimism//AB

        (?1)     x       x      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x       *      ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (0x)     x      ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1     (?1)      x      ?             :  ?  :    1   ; // Reducing pessimism.
        (?1)    1        x      ?             :  ?  :    1   ; // Reducing pessimism.
         1      1       (?x)    ?             :  ?  :    1   ; // Reducing pessimism.
                     
         ?      0       (?1)    ?             :  ?  :    -   ; // ignore edge on clear
         0      1       (?1)    ?             :  ?  :    0   ;
         1      1       (?1)    ?             :  ?  :    1   ;
                     
        (?1)    x        1      ?             :  1  :    1   ; // Reducing pessimism.
        (?0)    x        1      ?             :  0  :    0   ; // Reducing pessimism.
                     
         ?      ?        ?      *             :  ?  :    x   ;
                     
   endtable

endprimitive

primitive U_LD_P_SB_RB ( Q, D, CK, RB, SB );
   output Q; 
   reg    Q;
   input  D, 
         CK, 
         RB, 
         SB;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET ( Q OUTPUT UDP ).



table
    //  D   CK  RB  SB  :   Qt  :   Qt+1

        1   1   1   1   :   ?   :   1;  // clock enabled transparent data.
        0   1   1   1   :   ?   :   0;

        1   x   1   1   :   1   :   1;  // possible enabled clock.
        0   x   1   1   :   0   :   0;

        ?   ?   0   1   :   ?   :   0;  // asynchronous reset.
        ?   ?   ?   0   :   ?   :   1;  // asynchronous set override.

        ?   0   1   1   :   ?   :   -;  // clock disabled.

        0   1   x   1   :   ?   :   0;  // pessimism 
        0   ?   x   1   :   0   :   0;  // pessimism 
        1   1   1   x   :   ?   :   1;  // pessimism 
        1   ?   1   x   :   1   :   1;  // pessimism                       

        ?   0   x   1   :   0  :    0;  // set inactive                    
        ?   0   1   x   :   1  :    1;  // reset inactive    
  
        ?   n   1   1   :   ?  :    -;               
                                              
   endtable  

endprimitive

primitive U_LD_P_SB_RB_NO (Q, D, G, RB, SB, NOTI_REG); 

    output Q; 
    reg    Q;                               
    input  D,               // DATA
           G,               // CLOCK
           RB,              // CLEAR ACTIVE LOW
           SB,              // SET ACTIVE LOW
           NOTI_REG;        // NOTIFY_REG
// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).


   table
     //  D       G      RB    SB   NOTI_REG       : Qtn :   Qtn+1
                                  
         *       0      1     1     ?             :  ?  :    -   ;
                                  
         ?       ?      0     1     ?             :  ?  :    0   ; // asynchro clear
     
         ?       ?      ?     0     ?             :  ?  :    1   ; 
                                                                    // occurs 
         ?      (?0)    1     1     ?             :  ?  :    -   ;  //AB
         ?      (1x)    1     1     ?             :  ?  :    -   ;  //AB
                                  
         0      (0x)    1     1     ?             :  0  :    0   ;
         1      (0x)    1     1     ?             :  1  :    1   ;
         0      (x1)    1     1     ?             :  ?  :    0   ;
         1      (x1)    1     1     ?             :  ?  :    1   ;
                                  
        (?0)     1      1     1     ?             :  ?  :    0   ;
        (?1)     1      1     1     ?             :  ?  :    1   ; 
         0      (01)    1     1     ?             :  ?  :    0   ;
         1      (01)    1     1     ?             :  ?  :    1   ; 
                                  
//       0       ?      x     1     ?             :  0  :    0   ; // Reducing pessimism.//AB
       
         ?       0     (?x)   1     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       0      x    (?1)   ?             :  0  :    0   ;   // Reducing pessimism.//AB
// modified by Hao Hu
//       *       0      x     1     ?             :  0  :    0   ;   // Reducing pessimism//AB
// delete by hua     ?       0      ?     1     ?             :  0  :    0   ;   // Reducing pessimism//AB
// Reason:when RB=z,the output is the same as RB=x.
// the origin line is used to ignore signal changes on D
// use '?' will also ignore changes on D
// end of modification

        (?0)     x      x     1     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      *     1     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (0x)    x     1     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      x    (?1)   ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0      (?1)    x     1     ?             :  ?  :    0   ; // Reducing pessimism.
        (?0)     1      x     1     ?             :  ?  :    0   ; // Reducing pessimism.
         0       1     (?x)   1     ?             :  ?  :    0   ; // Reducing pessimism.//AB
         0       1      x    (?1)   ?             :  ?  :    0   ; // Reducing pessimism.//AB
     
//inserted by Hao Hu
	 0       1      ?     1     ?             :  ?  :    0   ; // When SB=1 D=0 and G=1,no matter what RB is,Q=0.
//delete by hua      1       0      1     ?     ?             :  1  :    1   ; // when Rb=1 D=1 G=0 and Qtn=1,no matter what SB is,Qtn+1=1.
//end of insertion

//       1       ?      1     x     ?             :  1  :    1   ; // Reducing pessimism.
        
         ?       0      1    (?x)   ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       0     (?1)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       0      1     x     ?             :  1  :    1   ;   // Reducing pessimism//AB
 
        (?1)     x      1     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      1     *     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (0x)    1     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x     (?1)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB

      
         1      (?1)    1     x     ?             :  ?  :    1   ; // Reducing pessimism.
        (?1)     1      1     x     ?             :  ?  :    1   ; // Reducing pessimism.
         1       1     (?1)   x     ?             :  ?  :    1   ; // Reducing pessimism.//AB
         1       1      1    (?x)   ?             :  ?  :    1   ; // Reducing pessimism.//AB
                                  
         ?       0     (?1)   1     ?             :  ?  :    -   ;   // ignore edge on clear
//suppress : redundancy warning with Modelsim simulator	 
//         0       1      1     1     ?             :  ?  :    0   ;   // pessimism .
         1       1     (?1)   1     ?             :  ?  :    1   ;  

                                  
         ?       0      1    (?1)   ?             :  ?  :    -   ;   // ignore edge on set
//        0       1      1    (?1)   ?             :  ?  :    0   ;   // pessimism .
         1       1      1    (?1)   ?             :  ?  :    1   ;  

        (?1)     x      1     1     ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     x      1     1     ?             :  0  :    0   ; // Reducing pessimism.
                                  
         ?       ?      ?     ?     *             :  ?  :    x   ;

   endtable

endprimitive

primitive U_LD_P_SB_RB_QN ( QN, D, CK, RB, SB );
   output QN; 
   reg    QN;
   input  D, 
         CK, 
         RB, 
         SB;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET ( QN OUTPUT UDP ).


table
    //  D   CK  RB  SB  :   Qtn : Qtn+1

        1   1   1   1   :   ?   :   0;  // clock enabled transparent data.
        0   1   1   1   :   ?   :   1;

        1   x   1   1   :   0   :   0;  // possible enabled clock.
        0   x   1   1   :   1   :   1;

        ?   ?   0   1   :   ?   :   1;  // asynchronous reset.
        ?   ?   1   0   :   ?   :   0;  // asynchronous set 
        ?   ?   0   0   :   ?   :   1;  // asynchronous set

        ?   0   1   1   :   ?   :   -;  // clock disabled.

        0   1   x   1   :   ?   :   1;  // pessimism 
        0   ?   x   1   :   1   :   1;  // pessimism 
        1   1   1   x   :   ?   :   0;  // pessimism 
        1   ?   1   x   :   0   :   0;  // pessimism                       

        ?   0   x   1   :   1  :    1;  // set inactive                    
        ?   0   1   x   :   0  :    0;  // reset inactive    
  
        ?   n   1   1   :   ?  :    -;               
// added by Rihua Pan
        ?   ?   0   ?   :   ?  :    1; // asynchronous reset
// end of modification
                                              
   endtable  

endprimitive


primitive U_LD_P_S_R ( Q, D, CK, R, S );
    output Q; 
    reg    Q;
    input  D,
          CK,
          R,
          S;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).

table
    //  D   CK  R   S   :   Qt  :   Qt+1

        1   1   0   0   :   ?   :   1;  // clock enabled transparent data.
        0   1   0   0   :   ?   :   0;

        1   x   0   0   :   1   :   1;  // possible enabled clock.
        0   x   0   0   :   0   :   0;

        ?   ?   1   0   :   ?   :   0;  // asynchronous reset.
        ?   ?   ?   1   :   ?   :   1;  // asynchronous set override.

        ?   0   0   0   :   ?   :   -;  // clock disabled.

        0   1   x   0   :   ?   :   0;  // pessimism 
        0   ?   x   0   :   0   :   0;  // pessimism 
        1   1   0   x   :   ?   :   1;  // pessimism 
        1   ?   0   x   :   1   :   1;  // pessimism                       

        ?   0   x   0   :   0  :    0;  // set inactive                    
        ?   0   0   x   :   1  :    1;  // reset inactive 
      
        ?   n   0   0   :   ?  :    -;                 
                                              
    endtable 

endprimitive



primitive U_LD_P_S_R_NO (Q, D, G, R, S, NOTI_REG); 


    output Q; 
    reg    Q;                               
    input  D,               // DATA
           G,               // CLOCK
           R,              // CLEAR ACTIVE HIGH
           S,              // SET ACTIVE HIGH
           NOTI_REG;        // NOTIFY_REG
// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).


   table
     //  D       G     RB    SB   NOTI_REG       : Qtn :   Qtn+1
                                  
         *       0      0     0     ?             :  ?  :    -   ;
                                  
         ?       ?      1     0     ?             :  ?  :    0   ; // asynchro clear
     
         ?       ?      ?     1     ?             :  ?  :    1   ; 
                                                                    // occurs 
         ?      (?0)    0     0     ?             :  ?  :    -   ;  //AB
         ?      (1x)    0     0     ?             :  ?  :    -   ;  //AB
                                  
         0      (0x)    0     0     ?             :  0  :    0   ;
         1      (0x)    0     0     ?             :  1  :    1   ;
         0      (x1)    0     0     ?             :  ?  :    0   ;
         1      (x1)    0     0     ?             :  ?  :    1   ;
                                  
        (?0)     1      0     0     ?             :  ?  :    0   ;
        (?1)     1      0     0     ?             :  ?  :    1   ; 
         0      (01)    0     0     ?             :  ?  :    0   ;
         1      (01)    0     0     ?             :  ?  :    1   ; 
                                  
//       0       ?      x     0     ?             :  0  :    0   ; // Reducing pessimism.//AB
       
         ?       0     (?x)   0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       0      x    (?0)   ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       0      x     0     ?             :  0  :    0   ;   // Reducing pessimism//AB

        (?0)     x      x     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      *     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (0x)    x     0     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      x    (?0)   ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0      (?1)    x     0     ?             :  ?  :    0   ; // Reducing pessimism.
        (?0)     1      x     0     ?             :  ?  :    0   ; // Reducing pessimism.
         0       1     (?x)   0     ?             :  ?  :    0   ; // Reducing pessimism.//AB
         0       1      x    (?0)   ?             :  ?  :    0   ; // Reducing pessimism.//AB
     
//       1       ?      0     x     ?             :  1  :    1   ; // Reducing pessimism.
        
         ?       0      0    (?x)   ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       0     (?0)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       0      0     x     ?             :  1  :    1   ;   // Reducing pessimism//AB
 
        (?1)     x      0     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      0     *     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1      (0x)    0     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x     (?0)   x     ?             :  1  :    1   ;   // Reducing pessimism.//AB

      
         1      (?1)    0     x     ?             :  ?  :    1   ; // Reducing pessimism.
        (?1)     1      0     x     ?             :  ?  :    1   ; // Reducing pessimism.
         1       1     (?0)   x     ?             :  ?  :    1   ; // Reducing pessimism.//AB
         1       1      0    (?x)   ?             :  ?  :    1   ; // Reducing pessimism.//AB
                                  
         ?       0     (?0)   0     ?             :  ?  :    -   ;   // ignore edge on clear
         0       1     (?0)   0     ?             :  ?  :    0   ;   // pessimism .
         1       1     (?0)   0     ?             :  ?  :    1   ;  

                                  
         ?       0      0    (?0)   ?             :  ?  :    -   ;   // ignore edge on set
         0       1      0    (?0)   ?             :  ?  :    0   ;   // pessimism .
         1       1      0    (?0)   ?             :  ?  :    1   ;  

        (?1)     x      0     0     ?             :  1  :    1   ; // Reducing pessimism.
        (?0)     x      0     0     ?             :  0  :    0   ; // Reducing pessimism.
                                  
         ?       ?      ?     ?     *             :  ?  :    x   ;

   endtable

endprimitive


primitive U_LD_P_S_R_NO_QN (QN, D, G, R, S, NOTI_REG); 


    output QN; 
    reg    QN;                               
    input  D,               // DATA
           G,               // CLOCK
           R,              // CLEAR ACTIVE HIGH
           S,              // SET ACTIVE HIGH
           NOTI_REG;        // NOTIFY_REG
// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP ).


   table
     //  D       G     RB    SB   NOTI_REG       : QNtn :   QNtn+0
                                  
         *       0      0     0     ?             :  ?  :    -   ;
                                  
         ?       ?      1     ?     ?             :  ?  :    1   ; // asynchro clear
     
         ?       ?      0     1     ?             :  ?  :    0   ; 
                                                                    // occurs 
         ?      (?0)    0     0     ?             :  ?  :    -   ;  //AB
         ?      (1x)    0     0     ?             :  ?  :    -   ;  //AB
                                  
         0      (0x)    0     0     ?             :  1  :    1   ;
         1      (0x)    0     0     ?             :  0  :    0   ;
         0      (x1)    0     0     ?             :  ?  :    1   ;
         1      (x1)    0     0     ?             :  ?  :    0   ;
                                  
        (?0)     1      0     0     ?             :  ?  :    1   ;
        (?1)     1      0     0     ?             :  ?  :    0   ; 
         0      (01)    0     0     ?             :  ?  :    1   ;
         1      (01)    0     0     ?             :  ?  :    0   ; 
                                  
//       0       ?      x     0     ?             :  1  :    1   ; // Reducing pessimism.//AB
       
         ?       0     (?x)   0     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         ?       0      x    (?0)   ?             :  1  :    1   ;   // Reducing pessimism.//AB
         *       0      x     0     ?             :  1  :    1   ;   // Reducing pessimism//AB

        (?0)     x      x     0     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         0       x      *     0     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         0      (0x)    x     0     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         0       x      x    (?0)   ?             :  1  :    1   ;   // Reducing pessimism.//AB

         0      (?1)    x     0     ?             :  ?  :    1   ; // Reducing pessimism.
        (?0)     1      x     0     ?             :  ?  :    1   ; // Reducing pessimism.
         0       1     (?x)   0     ?             :  ?  :    1   ; // Reducing pessimism.//AB
         0       1      x    (?0)   ?             :  ?  :    1   ; // Reducing pessimism.//AB
     
//       1       ?      0     x     ?             :  0  :    0   ; // Reducing pessimism.
        
         ?       0      0    (?x)   ?             :  0  :    0   ;   // Reducing pessimism.//AB
         ?       0     (?0)   x     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         *       0      0     x     ?             :  0  :    0   ;   // Reducing pessimism//AB
 
        (?1)     x      0     x     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         1       x      0     *     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         1      (0x)    0     x     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         1       x     (?0)   x     ?             :  0  :    0   ;   // Reducing pessimism.//AB

      
         1      (?1)    0     x     ?             :  ?  :    0   ; // Reducing pessimism.
        (?1)     1      0     x     ?             :  ?  :    0   ; // Reducing pessimism.
         1       1     (?0)   x     ?             :  ?  :    0   ; // Reducing pessimism.//AB
         1       1      0    (?x)   ?             :  ?  :    0   ; // Reducing pessimism.//AB
                                  
         ?       0     (?0)   0     ?             :  ?  :    -   ;   // ignore edge on clear
         0       1     (?0)   0     ?             :  ?  :    1   ;   // pessimism .
         1       1     (?0)   0     ?             :  ?  :    0   ;  

                                  
         ?       0      0    (?0)   ?             :  ?  :    -   ;   // ignore edge on set
         0       1      0    (?0)   ?             :  ?  :    1   ;   // pessimism .
         1       1      0    (?0)   ?             :  ?  :    0   ;  

        (?1)     x      0     0     ?             :  0  :    0   ; // Reducing pessimism.
        (?0)     x      0     0     ?             :  1  :    1   ; // Reducing pessimism.
                                  
         ?       ?      ?     ?     *             :  ?  :    x   ;

   endtable

endprimitive

primitive U_LD_P_S_R_QN ( QN, D, CK, R, S );
    output QN; 
    reg    QN;
    input  D,
           CK,
           R,
           S;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET. ( QN OUTPUT UDP ).

table
    //  D   CK  R   S   :   Qtn :  Qtn+1
              
        1   1   0   0   :   ?   :   0;  // clock enabled transparent data.
        0   1   0   0   :   ?   :   1;
              
        1   x   0   0   :   0   :   0;  // possible enabled clock.
        0   x   0   0   :   1   :   1;
              
        ?   ?   1   0   :   ?   :   1;  // asynchronous reset.
        ?   ?   ?   1   :   ?   :   1;  // asynchronous set override.
              
        ?   0   0   0   :   ?   :   -;  // clock disabled.
              
        0   1   x   0   :   ?   :   1;  // pessimism 
        0   ?   x   0   :   1   :   1;  // pessimism 
        1   1   0   x   :   ?   :   0;  // pessimism 
        1   ?   0   x   :   0   :   0;  // pessimism                       
              
        ?   0   x   0   :   1  :    1;  // set inactive                    
        ?   0   0   x   :   0  :    0;  // reset inactive 
              
        ?   n   0   0   :   ?  :    -;                 
                                              
    endtable 

endprimitive


primitive U_LD_SD (Q, D, SI, CLK, ACLK);

//
// FUNCTION : D LATCH WITH SCAN INPUTS ( Q OUTPUT UDP ). 
//


    output Q; 

    input  D, SI, CLK, ACLK;

    reg    Q;                               

    table
//   D   SI   CLK    ACLK  :  Qt  :  Qt+1
                           
     1    ?    1      0    :  ?   :   1;   // System clocked data.
     0    ?    1      0    :  ?   :   0;
                                       
     ?    1    0      1    :  ?   :   1;   // Shift clocked data.
     ?    0    0      1    :  ?   :   0;
                           
     ?    ?    0      0    :  ?   :   -;   // Feedback latched data

     1    1    ?      ?    :  1   :   1;   // pessimism
     0    0    ?      ?    :  0   :   0;  

     1    1    1      1    :  ?   :   1;
     0    0    1      1    :  ?   :   0;  
     
     1    ?    x      0    :  1   :   1;   // Reducing pessimism 
     0    ?    x      0    :  0   :   0;
  
     ?    1    0      x    :  1   :   1;   // Reducing pessimism
     ?    0    0      x    :  0   :   0;   // for unknown clock

     1    1    x      1    :  ?   :   1;  // Reducing pessimism 
     0    0    x      1    :  ?   :   0;
     1    1    1      x    :  ?   :   1;
     0    0    1      x    :  ?   :   0;     

     
    endtable
endprimitive

primitive U_LD_SDA (Q, D, SI, CLK, ACLK);

//
// FUNCTION : D LATCH WITH SCAN INPUTS WITH DATA ANDed ( Q OUTPUT UDP ).
//


    output Q; 

    input  D, SI, CLK, ACLK;

    reg    Q;                               

    table
//   D   SI   CLK    ACLK  :  Qt  :  Qt+1
                           
     1    ?    1      0    :  ?   :   1;   // System clocked data.
     0    ?    1      0    :  ?   :   0;
                                       
     ?    1    0      1    :  ?   :   1;   // Shift clocked data.
     ?    0    0      1    :  ?   :   0;
                           
     ?    ?    0      0    :  ?   :   -;   // Feedback latched data
   
     1    1    ?      ?    :  1   :   1;   // Reducing pessimism
     0    0    ?      ?    :  0   :   0;  
                                          
     1    ?    x      0    :  1   :   1;   // Reducing pessimism 
     0    ?    x      0    :  0   :   0;   // for unknown clock
  
     ?    1    0      x    :  1   :   1;   // Reducing pessimism
     ?    0    0      x    :  0   :   0;   // for unknown clock

     0    ?    1      1    :  ?   :   0;   // possible shift clock enabled.
     ?    0    1      1    :  ?   :   0;   // data ANDed
     1    1    1      1    :  ?   :   1;  
                                             
     1    1    x      1    :  ?   :   1;  // Reducing pessimism 
     0    ?    1      x    :  ?   :   0;
     1    1    1      x    :  ?   :   1;
     ?    0    x      1    :  ?   :   0;     
   
    endtable
endprimitive

primitive U_LD_SDA_NO (Q, D, SI, CLK, ACLK, NOTIFIER_REG); 

    output Q;

    input  NOTIFIER_REG,
           D, SI, CLK, ACLK;

    reg    Q;                               
// FUNCTION : D LATCH WITH SCAN INPUTS WITH DATA ANDed ( Q OUTPUT UDP ).
//



    table
//   D   SI   CLK    ACLK       NOTIFIER_REG  :  Qt  :  Qt+1
                           
     1    ?    1     (?0)          ?          :  ?   :   1;   // System clocked data.
     0    ?    1     (?0)          ?          :  ?   :   0;

    (?1)  ?    1      0            ?          :  ?   :   1;   // System clocked data.
    (?0)  ?    1      0            ?          :  ?   :   0;

     1    ?   (?1)    0            ?          :  ?   :   1;   // System clocked data.
     0    ?   (?1)    0            ?          :  ?   :   0;

     ?    1    0     (?1)          ?          :  ?   :   1;   // Shift clocked data.
     ?    0    0     (?1)          ?          :  ?   :   0;

     ?   (?1)  0      1            ?          :  ?   :   1;   // Shift clocked data.
     ?   (?0)  0      1            ?          :  ?   :   0;

     ?    1   (?0)    1            ?          :  ?   :   1;   // Shift clocked data.
     ?    0   (?0)    1            ?          :  ?   :   0;
                           
     ?    ?   (?0)    0            ?          :  ?   :   -;   // Feedback latched data
     ?    ?    0     (?0)          ?          :  ?   :   -;   // Feedback latched data

    (?1)  1    ?      ?            ?          :  1   :   1;   // pessimism
    (?0)  0    ?      ?            ?          :  0   :   0;  

     1   (?1)  ?      ?            ?          :  1   :   1;   // pessimism
     0   (?0)  ?      ?            ?          :  0   :   0;  
   
     1    1    *      ?            ?          :  1   :   1;   // pessimism
     0    0    *      ?            ?          :  0   :   0;  

     1    1    ?      *            ?          :  1   :   1;   // pessimism
     0    0    ?      *            ?          :  0   :   0;  

     1    ?   (?x)   0             ?          :  1   :   1;   // Reducing pessimism 
     0    ?   (?x)   0             ?          :  0   :   0;   // for unknown clock

     1    ?     x    (?0)          ?          :  1   :   1;   // Reducing pessimism 
     0    ?     x    (?0)          ?          :  0   :   0;   // for unknown clock

    (?1)  ?     x     0            ?          :  1   :   1;   // Reducing pessimism 
    (?0)  ?     x     0            ?          :  0   :   0;   // for unknown clock

     ?    1    (?0)   x            ?          :  1   :   1;   // Reducing pessimism 
     ?    0    (?0)   x            ?          :  0   :   0;   // for unknown clock

     ?    1     0    (?x)          ?          :  1   :   1;   // Reducing pessimism 
     ?    0     0    (?x)          ?          :  0   :   0;   // for unknown clock

     ?   (?1)   0     x            ?          :  1   :   1;   // Reducing pessimism 
     ?   (?0)   0     x            ?          :  0   :   0;   // for unknown clock


    (?0)  ?     1     1            ?          :  ?   :   0;   // possible shift clock enabled.
     ?   (?0)   1     1            ?          :  ?   :   0;   // data ANDed

     0    ?    (?1)   1            ?          :  ?   :   0;   // possible shift clock enabled.
     ?    0     1    (?1)          ?          :  ?   :   0;   // data ANDed

     0    ?     1    (?1)          ?          :  ?   :   0;   // possible shift clock enabled.
     ?    0    (?1)   1            ?          :  ?   :   0;   // data ANDed

     0   (?1)   1     1            ?          :  ?   :   0;   // possible shift clock enabled.
    (?1)  0     1     1            ?          :  ?   :   0;   // data ANDed

     0   (?x)   1     1            ?          :  ?   :   0;   // possible shift clock enabled.
    (?x)  0     1     1            ?          :  ?   :   0;   // data ANDed

    (?1)  1     1     1            ?          :  ?   :   1;  
     1   (?1)   1     1            ?          :  ?   :   1;  

     1    1    (?1)   1            ?          :  ?   :   1;  
     1    1     1    (?1)          ?          :  ?   :   1;  

                                             
     1    1    (?x)   1            ?          :  ?   :   1;  // Reducing pessimism 
     1    1     x    (?1)          ?          :  ?   :   1;  // Reducing pessimism 

    (?1)  1     x     1            ?          :  ?   :   1;  // Reducing pessimism 
     1   (?1)   x     1            ?          :  ?   :   1;  // Reducing pessimism 

    (?0)  ?     1     x            ?          :  ?   :   0;
     0    ?    (?1)   x            ?          :  ?   :   0;
     0    ?     1    (?x)          ?          :  ?   :   0;

    (?1)  1     1     x            ?          :  ?   :   1;
      1  (?1)   1     x            ?          :  ?   :   1;
      1   1    (?1)   x            ?          :  ?   :   1;
      1   1     1    (?x)          ?          :  ?   :   1;

      ?   (?0)   x     1           ?          :  ?   :   0;     
      ?     0   (?x)   1           ?          :  ?   :   0;     
      ?     0    x    (?1)         ?          :  ?   :   0;     
      ?     *    ?     0           ?          :  ?   :   -;
      *     ?    0     ?           ?          :  ?   :   -;

      ?    ?     ?     ?           *          :  ?   :   x;
   
    endtable
endprimitive

primitive U_LD_SDO (Q, D, SI, CLK, ACLK);

//
// FUNCTION : D LATCH WITH SCAN INPUTS WITH DATA ORed ( Q OUTPUT UDP ).
//


    output Q; 

    input  D, SI, CLK, ACLK;

    reg    Q;                               

    table
//   D   SI   CLK    ACLK  :  Qt  :  Qt+1
                           
     1    ?    1      0    :  ?   :   1;   // System clocked data.
     0    ?    1      0    :  ?   :   0;
                                       
     ?    1    0      1    :  ?   :   1;   // Shift clocked data.
     ?    0    0      1    :  ?   :   0;
                           
     ?    ?    0      0    :  ?   :   -;   // Feedback latched data

     1    1    ?      ?    :  1   :   1;   // pessimism
     0    0    ?      ?    :  0   :   0;  
   
     1    ?    x      0    :  1   :   1;   // Reducing pessimism 
     0    ?    x      0    :  0   :   0;   // for unknown clock
  
     ?    1    0      x    :  1   :   1;   // Reducing pessimism
     ?    0    0      x    :  0   :   0;   // for unknown clock

     1    ?    1      1    :  ?   :   1;   // possible shift clock enabled.
     ?    1    1      1    :  ?   :   1;   // data ORed
     0    0    1      1    :  ?   :   0;  
                                             
     0    0    x      1    :  ?   :   0;  // Reducing pessimism 
     1    ?    1      x    :  ?   :   1;
     0    0    1      x    :  ?   :   0;
     ?    1    x      1    :  ?   :   1;     
   
     
    endtable
endprimitive

primitive U_LD_SDO_NO (Q, D, SI, CLK, ACLK, NOTIFIER_REG); 

    output Q;

    input  NOTIFIER_REG,
           D, SI, CLK, ACLK;

    reg    Q;                               
// FUNCTION : D LATCH WITH SCAN INPUTS WITH DATA ORed ( Q OUTPUT UDP ).
//



    table
//   D   SI   CLK    ACLK       NOTIFIER_REG  :  Qt  :  Qt+1
                           
     1    ?    1     (?0)          ?          :  ?   :   1;   // System clocked data.
     0    ?    1     (?0)          ?          :  ?   :   0;

    (?1)  ?    1      0            ?          :  ?   :   1;   // System clocked data.
    (?0)  ?    1      0            ?          :  ?   :   0;

     1    ?   (?1)    0            ?          :  ?   :   1;   // System clocked data.
     0    ?   (?1)    0            ?          :  ?   :   0;

     ?    1    0     (?1)          ?          :  ?   :   1;   // Shift clocked data.
     ?    0    0     (?1)          ?          :  ?   :   0;

     ?   (?1)  0      1            ?          :  ?   :   1;   // Shift clocked data.
     ?   (?0)  0      1            ?          :  ?   :   0;

     ?    1   (?0)    1            ?          :  ?   :   1;   // Shift clocked data.
     ?    0   (?0)    1            ?          :  ?   :   0;
                           
     ?    ?   (?0)    0            ?          :  ?   :   -;   // Feedback latched data
     ?    ?    0     (?0)          ?          :  ?   :   -;   // Feedback latched data

    (?1)  1    ?      ?            ?          :  1   :   1;   // pessimism
    (?0)  0    ?      ?            ?          :  0   :   0;  

     1   (?1)  ?      ?            ?          :  1   :   1;   // pessimism
     0   (?0)  ?      ?            ?          :  0   :   0;  
   
     1    1    *      ?            ?          :  1   :   1;   // pessimism
     0    0    *      ?            ?          :  0   :   0;  

     1    1    ?      *            ?          :  1   :   1;   // pessimism
     0    0    ?      *            ?          :  0   :   0;  

     1    ?   (?x)   0             ?          :  1   :   1;   // Reducing pessimism 
     0    ?   (?x)   0             ?          :  0   :   0;   // for unknown clock

     1    ?     x    (?0)          ?          :  1   :   1;   // Reducing pessimism 
     0    ?     x    (?0)          ?          :  0   :   0;   // for unknown clock

    (?1)  ?     x     0            ?          :  1   :   1;   // Reducing pessimism 
    (?0)  ?     x     0            ?          :  0   :   0;   // for unknown clock

     ?    1    (?0)   x            ?          :  1   :   1;   // Reducing pessimism 
     ?    0    (?0)   x            ?          :  0   :   0;   // for unknown clock

     ?    1     0    (?x)          ?          :  1   :   1;   // Reducing pessimism 
     ?    0     0    (?x)          ?          :  0   :   0;   // for unknown clock

     ?   (?1)   0     x            ?          :  1   :   1;   // Reducing pessimism 
     ?   (?0)   0     x            ?          :  0   :   0;   // for unknown clock


    (?1)  ?     1     1            ?          :  ?   :   1;   // possible shift clock enabled.
     ?   (?1)   1     1            ?          :  ?   :   1;   // data ORed
     

     1    ?    (?1)   1            ?          :  ?   :   1;   // possible shift clock enabled.
     ?    1     1    (?1)          ?          :  ?   :   1;   // data ORed
     
 
     1    ?     1    (?1)          ?          :  ?   :   1;   // possible shift clock enabled.
     ?    1    (?1)   1            ?          :  ?   :   1;   // data ORed
 
     1   (?0)   1     1            ?          :  ?   :   1;   // possible shift clock enabled.
    (?0)  1     1     1            ?          :  ?   :   1;   // data ORed

     1   (?x)   1     1            ?          :  ?   :   1;   // possible shift clock enabled.
    (?x)  1     1     1            ?          :  ?   :   1;   // data ORed


    (?0)  0     1     1            ?          :  ?   :   0;  
     0   (?0)   1     1            ?          :  ?   :   0;  

     0    0    (?1)   1            ?          :  ?   :   0;  
     0    0     1    (?1)          ?          :  ?   :   0;  

                                             
     0    0    (?x)   1            ?          :  ?   :   0;  // Reducing pessimism 
     0    0     x    (?1)          ?          :  ?   :   0;  // Reducing pessimism 

    (?0)  0     x     1            ?          :  ?   :   0;  // Reducing pessimism 
     0   (?0)   x     1            ?          :  ?   :   0;  // Reducing pessimism 

    (?1)  ?     1     x            ?          :  ?   :   1;
     1    ?    (?1)   x            ?          :  ?   :   1;
     1    ?     1    (?x)          ?          :  ?   :   1;

    (?0)  0     1     x            ?          :  ?   :   0;
      0  (?0)   1     x            ?          :  ?   :   0;
      0   0    (?1)   x            ?          :  ?   :   0;
      0   0     1    (?x)          ?          :  ?   :   0;

      ?  (?1)   x     1           ?          :  ?   :   1;     
      ?   1    (?x)   1           ?          :  ?   :   1;     
      ?   1     x    (?1)         ?          :  ?   :   1;     

      ?   *     ?     0           ?          :  ?   :   -;
      *   ?     0     ?           ?          :  ?   :   -;

      ?    ?     ?     ?           *          :  ?   :   x;
   
    endtable
endprimitive

primitive U_LD_SD_NO (Q, D, SI, CLK, ACLK, NOTIFIER_REG); 

    output Q;

    input  NOTIFIER_REG,
           D, SI, CLK, ACLK;

    reg    Q;                               
// FUNCTION : D LATCH WITH SCAN INPUTS ( Q OUTPUT UDP ). 
//



    table
//   D   SI   CLK    ACLK       NOTIFIER_REG  :  Qt  :  Qt+1
                           
     1    ?    1     (?0)          ?          :  ?   :   1;   // System clocked data.
     0    ?    1     (?0)          ?          :  ?   :   0;

    (?1)  ?    1      0            ?          :  ?   :   1;   // System clocked data.
    (?0)  ?    1      0            ?          :  ?   :   0;

     1    ?   (?1)    0            ?          :  ?   :   1;   // System clocked data.
     0    ?   (?1)    0            ?          :  ?   :   0;

     ?    1    0     (?1)          ?          :  ?   :   1;   // Shift clocked data.
     ?    0    0     (?1)          ?          :  ?   :   0;

     ?   (?1)  0      1            ?          :  ?   :   1;   // Shift clocked data.
     ?   (?0)  0      1            ?          :  ?   :   0;

     ?    1   (?0)    1            ?          :  ?   :   1;   // Shift clocked data.
     ?    0   (?0)    1            ?          :  ?   :   0;
                           

    (?1)  1    ?      ?            ?          :  1   :   1;   // pessimism
    (?0)  0    ?      ?            ?          :  0   :   0;  

     1   (?1)  ?      ?            ?          :  1   :   1;   // pessimism
     0   (?0)  ?      ?            ?          :  0   :   0;  
   
     1    1    *      ?            ?          :  1   :   1;   // pessimism
     0    0    *      ?            ?          :  0   :   0;  

     1    1    ?      *            ?          :  1   :   1;   // pessimism
     0    0    ?      *            ?          :  0   :   0;  

     1    ?   (?x)    0            ?          :  1   :   1;   // Reducing pessimism 
     0    ?   (?x)    0            ?          :  0   :   0;   // for unknown clock

     1    ?     x    (?0)          ?          :  1   :   1;   // Reducing pessimism 
     0    ?     x    (?0)          ?          :  0   :   0;   // for unknown clock

    (?1)  ?     x     0            ?          :  1   :   1;   // Reducing pessimism 
    (?0)  ?     x     0            ?          :  0   :   0;   // for unknown clock

     ?    1    (?0)   x            ?          :  1   :   1;   // Reducing pessimism 
     ?    0    (?0)   x            ?          :  0   :   0;   // for unknown clock

     ?    1     0    (?x)          ?          :  1   :   1;   // Reducing pessimism 
     ?    0     0    (?x)          ?          :  0   :   0;   // for unknown clock

     ?   (?1)   0     x            ?          :  1   :   1;   // Reducing pessimism 
     ?   (?0)   0     x            ?          :  0   :   0;   // for unknown clock


    (?1)  1     1     1            ?          :  ?   :   1;   // possible shift clock enabled.
     1   (?1)   1     1            ?          :  ?   :   1;   // data ORed

     1    1    (?1)   1            ?          :  ?   :   1;   // possible shift clock enabled.
     1    1     1    (?1)          ?          :  ?   :   1;   // data ORed

    (?0)  0     1     1            ?          :  ?   :   0;  
     0   (?0)   1     1            ?          :  ?   :   0;  

     0    0    (?1)   1            ?          :  ?   :   0;  
     0    0     1    (?1)          ?          :  ?   :   0;  

    (?0)  0     x     1            ?          :  ?   :   0;  // Reducing pessimism 
     0   (?0)   x     1            ?          :  ?   :   0;  // Reducing pessimism 
     0    0    (?x)   1            ?          :  ?   :   0;  // Reducing pessimism 
     0    0     x    (?1)          ?          :  ?   :   0;  // Reducing pessimism 


    (?1)  1     x     1            ?          :  ?   :   1;
     1   (?1)   x     1            ?          :  ?   :   1;     
     1    1    (?x)   1            ?          :  ?   :   1;     
     1    1     x    (?1)          ?          :  ?   :   1;     

    (?1)  1     1     x            ?          :  ?   :   1;
     1   (?1)   1     x            ?          :  ?   :   1;
     1    1    (?1)   x            ?          :  ?   :   1;
     1    1     1    (?x)          ?          :  ?   :   1;

    (?0)  0     1     x            ?          :  ?   :   0;
      0  (?0)   1     x            ?          :  ?   :   0;
      0   0    (?1)   x            ?          :  ?   :   0;
      0   0     1    (?x)          ?          :  ?   :   0;

     ?    ?   (?0)    0            ?          :  ?   :   -;   // Feedback latched data
     ?    ?     0    (?0)          ?          :  ?   :   -;   // Feedback latched data
     ?    *     ?     0            ?          :  ?   :   -;
     *    ?     0     ?            ?          :  ?   :   -;

     ?    ?     ?     ?            *          :  ?   :   x;

    endtable
endprimitive

primitive U_LD_SD_O (Q, D, CLK, BCLK);

//
// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS ( Q OUTPUT UDP ) .
//

    output Q; 

    input  D,  CLK, BCLK;

    reg    Q;                               

    table
//   D   CLK    BCLK  :  Qt  :  Qt+1
                      
     1    1      0    :  ?   :   1;   // System clocked data.
     0    1      0    :  ?   :   0;
                                  
     ?    0      ?    :  ?   :   -;   
     ?    ?      1    :  ?   :   -; 
 
     1    ?      ?    :  1   :   1;   // Reducing Pessimism
     0    ?      ?    :  0   :   0;
  
     ?    n      ?    :  ?   :   -;  
     ?    ?      p    :  ?   :   -;  
     
    endtable
endprimitive

primitive U_LD_SD_O_NO (Q, D, CLK, BCLK, NOTIFIER_REG); 

//

    output Q; 

    input  NOTIFIER_REG,
           D,  CLK, BCLK;

    reg    Q;                               
// FUNCTION : D LATCH WITH DUAL CLOCK INPUTS ( Q OUTPUT UDP ) .
//


    table
//   D   CLK      BCLK      NOTIFIER_REG  :  Qt  :  Qt+1
                      
     1  (?1)      0             ?          :  ?   :   1;   // System clocked data.
     1    1      (?0)           ?          :  ?   :   1;   // System clocked data.
     0  (?1)      0             ?          :  ?   :   0;
     0    1      (?0)           ?          :  ?   :   0;
    
    (?1)  1       0             ?          :  ?   :   1;
    (?0)  1       0             ?          :  ?   :   0;

     *    0       ?             ?          :  ?   :   -;
     *    ?       1             ?          :  ?   :   -;

   (?1)   ?       ?             ?          :  1   :   1;   // Reducing Pessimism
   (?0)   ?       ?             ?          :  0   :   0;
  
     ?    n       ?             ?          :  ?   :   -;  
     ?    p       1             ?          :  ?   :   -;  
     ?    0       n             ?          :  ?   :   -;  
     ?    ?       p             ?          :  ?   :   -;  
     ?    ?       ?             *          :  ?   :   x;

    endtable
endprimitive
primitive U_L_N_SR_SB_RB  (Q, S, R, SB, RB, G);  

    output  Q; 
    input   S, R, SB, RB, G;   // all inputs are active low.
    reg     Q;

    //
    // FUNCTION : S-R LATCH WITH ASYNCHRONOUS SET AND RESET ( Q OUTPUT UDP )
    // Set and Reset are active low.
    // Asynchronous set and reset are active low.
    // Clock G is active low. 
    // Set and asynchronous set are dominant.
    // This model does not reflect the data ambiguity when set and 
    //    reset are both active and simultaneously change to inactive.

    table 
 
    //  S   R  SB   RB  G   :   Qt  :   Qt+1

        ?   ?   1   1   1   :   ?   :   -   ;   // clock off. //AB
 
        1   1   1   1   ?   :   ?   :   -   ;   // latch state. 

        1   0   1   ?   0   :   ?   :   0   ;   // reset state.
 
        ?   ?   1   0   1   :   ?   :   0   ;   // async reset.
        1   ?   1   0   ?   :   ?   :   0   ;   // async reset.

        0   ?   ?   ?   0   :   ?   :   1   ;   // set state.

        ?   ?   0   ?   ?   :   ?   :   1   ;   // async set 

        1   x   1   1   0   :   0   :   0   ;   // indeter. set and reset.
        x   1   1   1   0   :   1   :   1   ;

        1   0   1   1   x   :   0   :   0   ;   // reset state clock ignore.
        0   1   1   1   x   :   1   :   1   ;   // set state override clock
       
        ?   1   ?   1   ?   :   1   :   1   ;   // pessimism case
        1   ?   1   ?   ?   :   0   :   0   ;   // pessimism case

    endtable
endprimitive


primitive U_L_N_SR_SB_RB_QN  (QN, S, R, SB, RB, G);  

    output  QN; 
    input   S, R, SB, RB, G;   // all inputs are active low.
    reg     QN;

    //
    // FUNCTION :  S-R LATCH WITH ASYNCHRONOUS SET AND RESET
    // Set and Reset are active low.
    // Asynchronous set and reset are active low.
    // Clock G is active low.
    // This model does not reflect the data ambiguity when set and 
    //    reset are both active and simultaneously change to inactive.

    table 

    //  S   R  SB   RB  G   :   QNt  :   QNt+1

        ?   ?   1   1   1   :   ?   :   -   ;   // clock off. //AB

        1   1   1   1   ?   :   ?   :   -   ;   // latch state. 

        0   1   ?   1   0   :   ?   :   0   ;   // sync set. 

        ?   ?   0   1   1   :   ?   :   0   ;   // async set.
        ?   1   0   1   ?   :   ?   :   0   ;   // async set.

        ?   0   ?   ?   0   :   ?   :   1   ;   // reset state.

        ?   ?   ?   0   ?   :   ?   :   1   ;   // async reset 

        1   x   1   1   0   :   1   :   1   ;   // indeter. set and reset.
        x   1   1   1   0   :   0   :   0   ;

        1   0   1   1   x   :   1   :   1   ;   // reset state clock ignore.
        0   1   1   1   x   :   0   :   0   ;   // set state override clock
       
        ?   1   ?   1   ?   :   0   :   0   ;   // pessimism case
        1   ?   1   ?   ?   :   1   :   1   ;   // pessimism case
        

    endtable

endprimitive


primitive U_L_P_S_R ( Q, S, R, G);
output Q; reg Q;
input  S, R, G;

// FUNCTION : POSITIVE LEVEL SENSITIVE S R-TYPE LATCH ( Q OUPUT UDP ) 


table                                   
     // S   R   G       :   Qt  :   Qt+1

        0   0   1       :   ?   :    - ;   // output unchanged

        0   1   1       :   ?   :    0 ;   // clock enabled transparent data.
        1   ?   1       :   ?   :    1 ;
                                           
        0   ?   x       :   0   :    0 ;   // possible enabled clock
        1   ?   x       :   1   :    1 ;
        ?   0   x       :   1   :    1 ;
        0   x   ?       :   0   :    0 ; 
        x   0   ?       :   1   :    1 ;
 
        ?   ?   0       :   ?   :    - ;
        
  
   endtable

endprimitive
primitive U_L_P_S_R_QN (QN, S, R, G);
output QN; reg QN;
input  S, R, G;

// FUNCTION : POSITIVE LEVEL SENSITIVE S R-TYPE LATCH ( QN OUPUT UDP ) 


table                                   
     // S   R   G       :   Qtn :   Qtn+1

        0   0   ?       :   ?   :    - ;   // output unchanged

        ?   1   1       :   ?   :    1 ;   // clock enabled transparent data.
        1   0   1       :   ?   :    0 ;
                                           
        0   ?   x       :   1   :    1 ;   // possible enabled clock
        1   0   x       :   0   :    0 ;
        ?   0   x       :   0   :    0 ;
        0   x   ?       :   1   :    1 ; 
        x   0   ?       :   0   :    0 ;
 
        ?   ?   0       :   ?   :    - ;
        
  
   endtable

endprimitive
primitive U_L_RB_SB ( Q, S, R );

    output Q;
    input  S, R;
    reg    Q;
    
    //
    // FUNCTION : SR LATCH CROSS COUPLED  NAND.  ( Q OUPUT UDP )
 
    table

    //      S   R       Qt    Qt+1

            1   1   :   ?   :   - ;     // Latch state
            1   0   :   ?   :   0 ;     // Reset state
            0   1   :   ?   :   1 ;     // Set state

            0   0   :   ?   :   0 ;     // Reset overrides Set
 
            x   0   :   ?   :   0 ;     // Reducing pessimism
            1   x   :   0   :   0 ;     
            x   1   :   1   :   1 ;
    
    endtable 

endprimitive                          
primitive  U_L_RB_SB_QN ( QN, S, R );

    output QN;
    input  S, R;
    reg    QN;
    
    //
    // FUNCTION : SR LATCH CROSS COUPLED  NAND.  ( QN OUPUT UDP )
   
    table

    //      S   R       QNt    QNt+1

            1   1   :   ?   :   - ;     // Latch state
            1   0   :   ?   :   1 ;     // Reset state

            0   0   :   ?   :   0 ;     // Set state
            0   1   :   ?   :   0 ;     // Set state
            0   x   :   ?   :   0 ;     // Set state

            1   x   :   1   :   1 ;     // Reducing pessimism
            x   1   :   0   :   0 ; 
    
    endtable 

endprimitive                          
primitive U_L_R_S ( Q, S, R);
output Q;	reg Q;
input S, R;

// FUNCTION : SR LATCH CROSS-COUPLED NOR.  SET AND RESET ARE ACTIVE HIGH.  RESET IS
//             DOMINANT ( Q OUPUT UDP )

// This model does not reflect the data ambiguity when set and
// reset are both active and simultaneously change to inactive.

table               
  //    S    R   :  Qt  :  Qt+1                                  
                                                                 
        0    0   :   ?  :     -;  // Latch state.                
        0    1   :   ?  :     0;  // Reset state.                
        1    0   :   ?  :     1;  // set state.                  
        1    1   :   ?  :     0;  // both active, reset overides. 

        x    0   :   1  :     1;  // unknown input determinate 
        x    1   :   ?  :     0; 
    	0    x   :   0  :     0; 

endtable
endprimitive
primitive U_L_R_S_QN (QN, S, R);
output QN;	reg QN;
input S, R;
  
// FUNCTION : SR LATCH CROSS-COUPLED NOR.  SET AND RESET ARE ACTIVE HIGH.  RESET IS
//            DOMINANT . ( QN OUPUT UDP )


// This model does not reflect the data ambiguity when set and
// reset are both active and simultaneously change to inactive.

table               
  //    S    R   :  QNt :  QNt+1                                  
                                                                 
        0    0   :   ?  :     -;  // Latch state.                
        0    1   :   ?  :     1;  // Reset state.                
        1    0   :   ?  :     0;  // set state.                  
        1    1   :   ?  :     0;  // both active, reset overides. 

        x    0   :   0  :     0; // unknown input determinate 
        x    1   :   ?  :     1; 
    	0    x   :   1  :     1; 

endtable
endprimitive
primitive U_L_SB_RB ( Q, SB, RB);
output Q;	reg Q;
input SB, RB;

// FUNCTION : CROSS-COUPLED NAND LATCH.  SET AND RESET ARE ACTIVE LOW.  SET IS
//            DOMINANT ( Q OUTPUT UDP ).

//  This model does not reflect the data ambiguity when set and
//  reset are both active and simultaneously change to inactive.

table
  //   SB   RB  :  Qt  :  Qt+1                                   
                                                                
        1    1  :   ?  :     -;  // Latch state.                
        1    0  :   ?  :     0;  // Reset state.                
        0    1  :   ?  :     1;  // set state.                  
        0    0  :   ?  :     1;  // Set overrides reset.        
                                                                
        0    x  :   ?  :     1;                                 
                                                                
        1    x  :   0  :     0;  // Indeterminate set and reset.
        x    1  :   1  :     1;

endtable
endprimitive

primitive U_L_SB_RB_QN (QN, SB, RB);
output QN;	reg QN;
input SB, RB;

// FUNCTION : CROSS-COUPLED NAND LATCH.  SET AND RESET ARE ACTIVE LOW.  SET IS
//            DOMINANT ( Q OUTPUT UDP ).

//  This model does not reflect the data ambiguity when set and
//  reset are both active and simultaneously change to inactive.

table
  //   SB   RB  :  QNt  :  QNt+1                                   
                                                                
        1    1  :   ?  :     -;  // Latch state.                
        1    0  :   ?  :     1;  // Reset state.                
        0    1  :   ?  :     0;  // set state.                  
        0    0  :   ?  :     1;  // Set overrides reset.        
                                                                
        0    x  :   ?  :     1;                                 
                                                                
        1    x  :   1  :     1;  // Indeterminate set and reset.
        x    1  :   0  :     0;

endtable
endprimitive

primitive U_L_SR_SB_RB (Q, S1, S2, R1, R2, SB, RB);

    output  Q; 
    input   S1, S2, R1, R2, SB, RB;
    reg Q;

    //
    // FUNCTION :  S-R LATCH WITH ASYNCHRONOUS SET AND RESET ( Q OUPUT UDP )
    // Set and Reset are active low.
    // Asynchronous set and reset are active low.
    // Set and asynchronous set are dominant.
    // To be active, both S1 and S2 (or R1 and R2) need to be active.
    // This model does not reflect the data ambiguity when set and 
    // reset are both active and simultaneously change to inactive.

    table 

    //  S1  S2  R1  R2   SB  RB   :   Qt  :   Qt+1


        1   1   1    1   1   1    :   ?   :   -   ;   // latch state.

        0   0   ?    ?   ?   ?    :   ?   :   1   ;   // set state. 
            
        ?   ?   ?    ?   0   ?    :   ?   :   1   ;   // async set.

        1   ?   0    0   1   1    :   ?   :   0   ;   // reset state. 
        ?   1   0    0   1   1    :   ?   :   0   ;   // reset state. 

        1   ?   ?    ?   1   0    :   ?   :   0   ;   // async reset.
        ?   1   ?    ?   1   0    :   ?   :   0   ;   // 

        1   ?   1    ?   1   1    :   ?   :   -   ;   // latch state. 
        1   ?   ?    1   1   1    :   ?   :   -   ;   //
        ?   1   1    ?   1   1    :   ?   :   -   ;   // 
        ?   1   ?    1   1   1    :   ?   :   -   ;   //

        1   ?   1    ?   x   1    :   1   :   1   ;   // pessimism case 
        1   ?   ?    1   x   1    :   1   :   1   ;   // pessimism case 
        ?   1   1    ?   x   1    :   1   :   1   ;   // pessimism case 
        ?   1   ?    1   x   1    :   1   :   1   ;   // pessimism case 

        1   ?   1    ?   1   x    :   0   :   0   ;   // pessimism case        
        1   ?   ?    1   1   x    :   0   :   0   ;   // pessimism case        
        ?   1   1    ?   1   x    :   0   :   0   ;   // pessimism case        
        ?   1   ?    1   1   x    :   0   :   0   ;   // pessimism case                             
                         
    endtable
endprimitive

primitive U_L_SR_SB_RB_QN (QN, S1, S2, R1, R2, SB, RB);

    output  QN; 
    input   S1, S2, R1, R2, SB, RB;
    reg QN;

    //
    // FUNCTION : S-R LATCH WITH ASYNCHRONOUS SET AND RESET ( QN OUPUT UDP )
    // Set and Reset are active low.
    // Asynchronous set and reset are active low.
    // Set and asynchronous set are dominant.
    // To be active, both S1 and S2 (or R1 and R2) need to be active.
    // This model does not reflect the data ambiguity when set and 
    //    reset are both active and simultaneously change to inactive.

    table 

    //  S1  S2  R1  R2   SB  RB     :   QNt  :   QNt+1


        1   1   1    1   1   1      :   ?   :   -   ;   // latch state.

        ?   ?   0    0   ?   ?      :   ?   :   1   ;   // reset state. 
 
        ?   ?   ?    ?   ?   0      :   ?   :   1   ;   // async reset. 

        0   0   1    ?   ?   1      :   ?   :   0   ;   // set state
        0   0   ?    1   ?   1      :   ?   :   0   ;   // set state

        ?   ?   1    ?   0   1      :   ?   :   0   ;   // set state
        ?   ?   ?    1   0   1      :   ?   :   0   ;   // set state

        1   ?   1    ?   1   1      :   ?   :   -   ;   // latch state. 
        1   ?   ?    1   1   1      :   ?   :   -   ;   //
        ?   1   1    ?   1   1      :   ?   :   -   ;   // 
        ?   1   ?    1   1   1      :   ?   :   -   ;   //

        1   ?   1    ?   x   1      :   0   :   0   ;   // pessimism case 
        1   ?   ?    1   x   1      :   0   :   0   ;   // pessimism case 
        ?   1   1    ?   x   1      :   0   :   0   ;   // pessimism case 
        ?   1   ?    1   x   1      :   0   :   0   ;   // pessimism case 

        1   ?   1    ?   1   x      :   1   :   1   ;   // pessimism case        
        1   ?   ?    1   1   x      :   1   :   1   ;   // pessimism case        
        ?   1   1    ?   1   x      :   1   :   1   ;   // pessimism case        
        ?   1   ?    1   1   x      :   1   :   1   ;   // pessimism case                             


    endtable
endprimitive

primitive U_L_S_R ( Q, S, R);
output Q;	reg Q;
input S, R;

// FUNCTION : CROSS-COUPLED NOR LATCH.  SET AND RESET ARE ACTIVE HIGH.  SET IS
//            DOMINANT ( Q OUTPUT UDP ) 

// This model does not reflect the data ambiguity when set and
// reset are both active and simultaneously change to inactive.

table               
  //    S    R   :  Qt  :  Qt+1                                  
                                                                 
        0    0   :   ?  :     -;  // Latch state.                
        0    1   :   ?  :     0;  // Reset state.                
        1    0   :   ?  :     1;  // set state.                  
        1    1   :   ?  :     1;  // both active set overides. 
        1    x   :   ?  :     1;  // set overides. 
                                                                 
        x    0   :   1  :     1; // unknown input determinate 
    	0    x   :   0  :     0; 
endtable
endprimitive

primitive U_L_S_R_QN (QN, S, R);
output QN;	reg QN;
input S, R;

// FUNCTION : CROSS-COUPLED NOR LATCH.  SET AND RESET ARE ACTIVE HIGH.  SET IS
//            DOMINANT ( QN OUTPUT UDP ) 

// This model does not reflect the data ambiguity when set and
// reset are both active and simultaneously change to inactive.

table               
  //    S    R   :  QNt  :  QNt+1                                  
                                                                 
        0    0   :   ?  :     -;  // Latch state.                
        0    1   :   ?  :     1;  // Reset state.                
        1    0   :   ?  :     0;  // set state.                  
        1    1   :   ?  :     1;  // both active set overides. 
        1    x   :   ?  :     0;  // set overides. 
                                                                 
        x    0   :   0  :     0; // unknown input determinate 
    	0    x   :   1  :     1; 
endtable
endprimitive

primitive U_MUX_1  (Q, A, SL);
    output Q;
    reg Q;
    input A, SL;

// FUNCTION :  ONE TO ONE MULTIPLEXER

    table
    //  A   SL  :   Qt  :   Qt+1

        0   0   :   ?   :   0 ;
        1   0   :   ?   :   1 ;
                      
        ?   1   :   ?   :   - ;

        ?   *   :   ?   :   - ;
        *   ?   :   ?   :   - ;
                      
    endtable
endprimitive    
primitive U_MUX_1_INV  (Q, A, SL);
    output Q;
    reg Q;
    input A, SL;

// FUNCTION :  ONE TO ONE MULTIPLEXER WITH INVERTING OUTPUT .

    table
    //  A   SL  :   Qt  :   Qt+1

        0   0   :   ?   :   1 ;
        1   0   :   ?   :   0 ;
                      
        ?   1   :   ?   :   - ;

        ?   *   :   ?   :   - ;
        *   ?   :   ?   :   - ;
                      
    endtable
endprimitive    
primitive U_MUX_2_1 (Q, A, B, SL);
    output Q;
    input A, B, SL;

// FUNCTION :  TWO TO ONE MULTIPLEXER

    table
    //  A   B   SL  :   Q
        0   0   ?   :   0 ;
        1   1   ?   :   1 ;

        0   ?   0   :   0 ;
        1   ?   0   :   1 ;

        ?   0   1   :   0 ;
        ?   1   1   :   1 ;

    endtable
endprimitive    
primitive U_MUX_2_1_INV (Y, D0, D1, S);

    input D0, D1, S;
    output Y;
   
// FUNCTION :  TWO TO ONE MULTIPLEXER  WITH INVERTING OUTPUT

    table
//   D0  D1  S  : Y
  
     0   ?   0  : 1 ;
     1   ?   0  : 0 ;

     ?   0   1  : 1 ;
     ?   1   1  : 0 ;

     0   0   ?  : 1 ;
     1   1   ?  : 0 ;

     endtable
endprimitive
    
primitive U_MUX_2_2  (Q, A, B, S1, S2);
    output Q;
    input A, B, S1, S2;

// FUNCTION :  TWO TO ONE MULTIPLEXER WITH 2 SELECT CONTROLS

    table
    //  A   B   S1   S2  :   Q
        0   ?   0    1   :   0 ;
        1   ?   0    1   :   1 ;
                  
        ?   0   1    0   :   0 ;
        ?   1   1    0   :   1 ;
                  
        1   1   ?    ?   :   1 ;
        0   0   ?    ?   :   0 ;
                  
                 
    endtable
endprimitive    
primitive U_MUX_2_2_INV  (Q, A, B, S1, S2);
    output Q;
    input A, B, S1, S2;

// FUNCTION :  TWO TO ONE MULTIPLEXER WITH 2 SELECT CONTROLS
//             AND INVERTING OUTPUT

    table
    //  A   B   S1   S2  :   Q
        0   ?   0    1   :   1 ;
        1   ?   0    1   :   0 ;
                  
        ?   0   1    0   :   1 ;
        ?   1   1    0   :   0 ;
                  
        1   1   ?    ?   :   0 ;
        0   0   ?    ?   :   1 ;
                  
                 
    endtable
endprimitive    
primitive U_MUX_3_2 (Y, D0, D1, D2, S0, S1);

    input D0, D1, D2, S0, S1;
    output Y;

// FUNCTION :  THREE TO ONE MULTIPLEXER WITH 2 SELECT CONTROLS
//             AND INVERTING OUTPUT 

    table

//   D0  D1  D2   S0 S1 : Y
                       
     0   ?   ?    0  0  : 0 ; 
     1   ?   ?    0  0  : 1 ; 
                                 
     ?   0   ?    1  0  : 0 ; 
     ?   1   ?    1  0  : 1 ; 
                                 
     ?   ?   0    ?  1  : 0 ; 
     ?   ?   1    ?  1  : 1 ; 
                                 
                                 
                                 
     0   0   0    ?  ?  : 0 ;     //pessimism
                       
     1   1   1    ?  ?  : 1 ; 

     0   0   ?    ?  0  : 0 ;     //pessimism
     1   1   ?    ?  0  : 1 ;     //pessimism

     0   ?   0    0  ?  : 0 ; 
     1   ?   1    0  ?  : 1 ; 

     ?   0   0    1  ?  : 0 ; 
     ?   1   1    1  ?  : 1 ; 
                 
     endtable
endprimitive
    
primitive U_MUX_3_2_INV (Y, D0, D1, D2, S0, S1);

    input D0, D1, D2, S0, S1;
    output Y;

// FUNCTION :  THREE TO ONE MULTIPLEXER WITH 2 SELECT CONTROLS
//             AND INVERTING OUTPUT 

    table

//   D0  D1  D2   S0 S1 : Y
                       
     0   ?   ?    0  0  : 1 ; 
     1   ?   ?    0  0  : 0 ; 
                                 
     ?   0   ?    1  0  : 1 ; 
     ?   1   ?    1  0  : 0 ; 
                                 
     ?   ?   0    ?  1  : 1 ; 
     ?   ?   1    ?  1  : 0 ; 
                                 
                                 
                                 
     0   0   0    ?  ?  : 1 ;     //pessimism
                       
     1   1   1    ?  ?  : 0 ; 

     0   0   ?    ?  0  : 1 ;     //pessimism
     1   1   ?    ?  0  : 0 ;     //pessimism

     0   ?   0    0  ?  : 1 ; 
     1   ?   1    0  ?  : 0 ; 

     ?   0   0    1  ?  : 1 ; 
     ?   1   1    1  ?  : 0 ; 
                 
     endtable
endprimitive
    
primitive U_MUX_4_2 (Y, D0, D1, D2, D3, S0, S1);

    input D0, D1, D2, D3, S0, S1;
    output Y;
   
// FUNCTION :  FOUR TO ONE MULTIPLEXER WITH 2 SELECT CONTROLS

    table

//   D0  D1  D2 D3  S0  S1 : Y
                       
     0   ?   ?  ?    0  0  : 0 ; 
     1   ?   ?  ?    0  0  : 1 ; 
                                 
     ?   0   ?  ?    1  0  : 0 ; 
     ?   1   ?  ?    1  0  : 1 ; 
                                 
     ?   ?   0  ?    0  1  : 0 ; 
     ?   ?   1  ?    0  1  : 1 ; 
                                 
     ?   ?   ?  0    1  1  : 0 ; 
     ?   ?   ?  1    1  1  : 1 ; 
                                 
                                 
     0   0   0   0   ?  ?  : 0 ; 
                       
     1   1   1   1   ?  ?  : 1 ; 

     0   0   ?   ?   ?  0  : 0 ;    
     1   1   ?   ?   ?  0  : 1 ; 

     ?   ?   0   0   ?  1  : 0 ; 
     ?   ?   1   1   ?  1  : 1 ; 

     0   ?   0   ?   0  ?  : 0 ; 
     1   ?   1   ?   0  ?  : 1 ; 

     ?   0   ?   0   1  ?  : 0 ; 
     ?   1   ?   1   1  ?  : 1 ; 
                 
     endtable
endprimitive
    
primitive U_MUX_4_2_INV (Y, D0, D1, D2, D3, S0, S1);

    input D0, D1, D2, D3, S0, S1;
    output Y;
 
// FUNCTION :  FOUR TO ONE MULTIPLEXER WITH 2 SELECT CONTROLS
//             AND INVERTING OUTPUT

    table

//   D0  D1  D2 D3   S0 S1 : Y
                       
     0   ?   ?  ?    0  0  : 1 ; 
     1   ?   ?  ?    0  0  : 0 ; 
                                 
     ?   0   ?  ?    1  0  : 1 ; 
     ?   1   ?  ?    1  0  : 0 ; 
                                 
     ?   ?   0  ?    0  1  : 1 ; 
     ?   ?   1  ?    0  1  : 0 ; 
                                 
     ?   ?   ?  0    1  1  : 1 ; 
     ?   ?   ?  1    1  1  : 0 ; 
                                 
                                 
     0   0   0   0   ?  ?  : 1 ;     //pessimism
                       
     1   1   1   1   ?  ?  : 0 ; 

     0   0   ?   ?   ?  0  : 1 ;     //pessimism
     1   1   ?   ?   ?  0  : 0 ;     //pessimism

     ?   ?   0   0   ?  1  : 1 ;     //pessimism
     ?   ?   1   1   ?  1  : 0 ;     //pessimism

     0   ?   0   ?   0  ?  : 1 ; 
     1   ?   1   ?   0  ?  : 0 ; 

     ?   0   ?   0   1  ?  : 1 ; 
     ?   1   ?   1   1  ?  : 0 ; 
                 
     endtable
endprimitive

`ifdef udp_input_ge_10
    
primitive U_MUX_8_3 (Z,I0,I1,I2,I3,I4,I5,I6,I7,S0,S1,S2);

output Z;
input I0,I1,I2,I3,I4,I5,I6,I7,S0,S1,S2;

table
// I0   I1   I2   I3   I4   I5   I6  I7  S0  S1  S2  : Z
   0    ?    ?    ?    ?    ?    ?   ?   0   0   0   : 0 ;
   1    ?    ?    ?    ?    ?    ?   ?   0   0   0   : 1 ;

   ?    0    ?    ?    ?    ?    ?   ?   1   0   0   : 0 ;
   ?    1    ?    ?    ?    ?    ?   ?   1   0   0   : 1 ;

   ?    ?    0    ?    ?    ?    ?   ?   0   1   0   : 0 ;
   ?    ?    1    ?    ?    ?    ?   ?   0   1   0   : 1 ;

   ?    ?    ?    0    ?    ?    ?   ?   1   1   0   : 0 ;
   ?    ?    ?    1    ?    ?    ?   ?   1   1   0   : 1 ;

   ?    ?    ?    ?    0    ?    ?   ?   0   0   1   : 0 ;
   ?    ?    ?    ?    1    ?    ?   ?   0   0   1   : 1 ;

   ?    ?    ?    ?    ?    0    ?   ?   1   0   1   : 0 ;
   ?    ?    ?    ?    ?    1    ?   ?   1   0   1   : 1 ;

   ?    ?    ?    ?    ?    ?    0   ?   0   1   1   : 0 ;
   ?    ?    ?    ?    ?    ?    1   ?   0   1   1   : 1 ;

   ?    ?    ?    ?    ?    ?    ?   0   1   1   1   : 0 ;
   ?    ?    ?    ?    ?    ?    ?   1   1   1   1   : 1 ;

   0    0    0    0    0    0    0   0   ?   ?   ?   : 0 ;
   1    1    1    1    1    1    1   1   ?   ?   ?   : 1 ;

   0    0    ?    ?    ?    ?    ?   ?   ?   0   0   : 0 ;
   1    1    ?    ?    ?    ?    ?   ?   ?   0   0   : 1 ;

   ?    ?    0    0    ?    ?    ?   ?   ?   1   0   : 0 ;
   ?    ?    1    1    ?    ?    ?   ?   ?   1   0   : 1 ;

   ?    ?    ?    ?    0    0    ?   ?   ?   0   1   : 0 ;
   ?    ?    ?    ?    1    1    ?   ?   ?   0   1   : 1 ;

   ?    ?    ?    ?    ?    ?    0   0   ?   1   1   : 0 ;
   ?    ?    ?    ?    ?    ?    1   1   ?   1   1   : 1 ;

   0    ?    0    ?    ?    ?    ?   ?   0   ?   0   : 0 ;
   1    ?    1    ?    ?    ?    ?   ?   0   ?   0   : 1 ;

   ?    0    ?    0    ?    ?    ?   ?   1   ?   0   : 0 ;
   ?    1    ?    1    ?    ?    ?   ?   1   ?   0   : 1 ;

   ?    ?    ?    ?    0    ?    0   ?   0   ?   1   : 0 ;
   ?    ?    ?    ?    1    ?    1   ?   0   ?   1   : 1 ;

   ?    ?    ?    ?    ?    0    ?   0   1   ?   1   : 0 ;
   ?    ?    ?    ?    ?    1    ?   1   1   ?   1   : 1 ;

   0    ?    ?    ?    0    ?    ?   ?   0   0   ?   : 0 ;
   1    ?    ?    ?    1    ?    ?   ?   0   0   ?   : 1 ;

   ?    0    ?    ?    ?    0    ?   ?   1   0   ?   : 0 ;
   ?    1    ?    ?    ?    1    ?   ?   1   0   ?   : 1 ;

   ?    ?    0    ?    ?    ?    0   ?   0   1   ?   : 0 ;
   ?    ?    1    ?    ?    ?    1   ?   0   1   ?   : 1 ;

   ?    ?    ?    0    ?    ?    ?   0   1   1   ?   : 0 ;
   ?    ?    ?    1    ?    ?    ?   1   1   1   ?   : 1 ;

   0    0    0    0    ?    ?    ?   ?   ?   ?   0   : 0 ;
   1    1    1    1    ?    ?    ?   ?   ?   ?   0   : 1 ;

   ?    ?    ?    ?    0    0    0   0   ?   ?   1   : 0 ;
   ?    ?    ?    ?    1    1    1   1   ?   ?   1   : 1 ;

   0    0    ?    ?    0    0    ?   ?   ?   0   ?   : 0 ;
   1    1    ?    ?    1    1    ?   ?   ?   0   ?   : 1 ;

   ?    ?    0    0    ?    ?    0   0   ?   1   ?   : 0 ;
   ?    ?    1    1    ?    ?    1   1   ?   1   ?   : 1 ;

   0    ?    0    ?    0    ?    0   ?   0   ?   ?   : 0 ;
   1    ?    1    ?    1    ?    1   ?   0   ?   ?   : 1 ;

   ?    0    ?    0    ?    0    ?   0   1   ?   ?   : 0 ;
   ?    1    ?    1    ?    1    ?   1   1   ?   ?   : 1 ;

endtable
endprimitive

`endif
primitive U_O2_AI2_AI (Z, A, B, C, D);

    output  Z;
    input   A, B, C, D;        

// FUNCTION :  2-INPUT OR and 2-INPUT NAND  into 2-INPUT NAND 

    
    table
    // A  B  C  D  :  Z

       0  0  ?  ?  :  1 ;
       ?  ?  1  1  :  1 ;

       1  ?  0  ?  :  0 ;
       1  ?  ?  0  :  0 ;

       ?  1  0  ?  :  0 ;
       ?  1  ?  0  :  0 ;
    endtable
endprimitive
primitive U_OAI_2_2(Z, A, B, C, D);

    output  Z;
    input   A, B, C, D;

// FUNCTION : 2-WIDE 2-INPUT OR into 2-INPUT NAND
    
    table
    // A  B  C  D  :  Z
              
       1  ?  1  ?  :  0 ;
       1  ?  ?  1  :  0 ;
       ?  1  1  ?  :  0 ;
       ?  1  ?  1  :  0 ; 
  
       0  0  ?  ?  :  1 ;
       ?  ?  0  0  :  1 ;

    endtable
endprimitive
      

primitive U_OAI_2_3(Y, A, B, C, D, E);

    output  Y;
    input   A, B, C, D, E;

// FUNCTION : 2-INPUT OR and 3-INPUT OR into 2-INPUT NAND
    
    table
    // A  B  C  D  E :  Y
                     
       1  ?  ?  1  ? :  0 ;
       ?  1  ?  1  ? :  0 ;
       ?  ?  1  1  ? :  0 ;
       1  ?  ?  ?  1 :  0 ;
       ?  1  ?  ?  1 :  0 ; 
       ?  ?  1  ?  1 :  0 ; 
                     
       ?  ?  ?  0  0 :  1 ;
       0  0  0  ?  ? :  1 ;

    endtable
endprimitive
      

primitive U_OAI_3_3(Y, A, B, C, D, E, F);

    output  Y;
    input   A, B, C, D, E, F;

// FUNCTION : 2-WIDE 3-INPUT OR into 2-INPUT NAND
    
    table
    // A  B  C  D  E  F   :  Y
      
       1  ?  ?  1  ?  ?   :  0 ;
       1  ?  ?  ?  1  ?   :  0 ;
       1  ?  ?  ?  ?  1   :  0 ;
       
       ?  1  ?  1  ?  ?   :  0 ;
       ?  1  ?  ?  1  ?   :  0 ;
       ?  1  ?  ?  ?  1   :  0 ;

       ?  ?  1  1  ?  ?   :  0 ;
       ?  ?  1  ?  1  ?   :  0 ;
       ?  ?  1  ?  ?  1   :  0 ;

       0  0  0  ?  ?  ?   :  1 ;
       ?  ?  ?  0  0  0   :  1 ;
      
    endtable
endprimitive
      

primitive U_OA_2_2(Z, A, B, C, D);

    output  Z;
    input   A, B, C, D;
 
// FUNCTION : 2-WIDE 2-INPUT OR into 2-INPUT AND
   
    table
    // A  B  C  D  :  Z
              
       1  ?  1  ?  :  1 ;
       1  ?  ?  1  :  1 ;
       ?  1  1  ?  :  1 ;
       ?  1  ?  1  :  1 ; 
  
       0  0  ?  ?  :  0 ;
       ?  ?  0  0  :  0 ;

    endtable
endprimitive
      

primitive	U_OA_2_3 (Q1, D0, D1, D2, D3, D4);
	output Q1;
	input  D0, D1, D2, D3, D4;

// FUNCTION : 2-INPUT OR and 3-INPUT OR into 2-INPUT AND
                  

	table
	//	D0	D1	D2	D3	D4	:	Q1

		?	?	0	0	0	:	0	;
		0	0	?	?	?	:	0	;
		?	1	?	?	1	:	1	;
		1	?	?	?	1	:	1	;
		1	?	1	?	?	:	1	;
		?	1	1	?	?	:	1	;
		1	?	?	1	?	:	1	;
		?	1	?	1	?	:	1	;

	endtable
endprimitive
primitive	U_OA_3_3 (Q0, D0, D1, D2, D3, D4, D5);
	output Q0;
	input  D0, D1, D2, D3, D4, D5;

// FUNCTION : 2-WIDE 3-INPUT OR into 2-INPUT AND

	table
	//	D0	D1	D2	D3	D4	D5	:	Q0

		0	0	0	?	?	?	:	0	;
		?	?	?	0	0	0	:	0	;
		?	?	1	?	?	1	:	1	;
		1	?	?	?	1	?	:	1	;
		?	1	?	?	1	?	:	1	;
		?	?	1	1	?	?	:	1	;
		1	?	?	?	?	1	:	1	;
		?	?	1	?	1	?	:	1	;
		1	?	?	1	?	?	:	1	;
		?	1	?	?	?	1	:	1	;
		?	1	?	1	?	?	:	1	;

	endtable
endprimitive
primitive U_RAM1 (Q, D, WR, WRN ); 

//
// FUNCTION : 1-BIT RAM 
//

    output Q; 
    reg    Q;                               
    input  D, WR, WRN ;

    table
     //  D      WR    WRN      : Q  :   Q+1

         ?      0      1       :  ?  :    -   ;
         0      1      0       :  ?  :    0   ;
         1      1      0       :  ?  :    1   ;            

         0      x      x       :  0  :    0   ;
         1      x      x       :  1  :    1   ;            

    endtable

endprimitive
primitive U_RAM1_QN (QN, D, WR, WRN ); 

//
// FUNCTION : 1-BIT RAM 
//

    output QN; 
    reg    QN;                               
    input  D, WR, WRN ;

    table
     //  D      WR    WRN      : QN  :   QN+1

         ?      0      1       :  ?  :    -   ;
         0      1      0       :  ?  :    1   ;
         1      1      0       :  ?  :    0   ;            

         0      x      x       :  1  :    1   ;
         1      x      x       :  0  :    0   ;            

    endtable

endprimitive
primitive U_SUB2_C (CO, A, B, CI);
    output CO;
    input CI, A, B;
          
// FUNCTION : 1-bit SUBTRACTOR (A - B) carry out term 

// Conventions :  CI = BORROW IN , CO = BORROW OUT
// CI = 0 implies borrow is on  i.e. previous stage is 
// borrowing from this stage and CI =  1 implies  
// no borrow 
// CO = 0 implies borrow out is on  i.e. this stage
// will borrow from next stage  
                                      

    table
    //  A   B   CI  :   CO
        0   ?   0   :   0 ;  // A < B , so borrow from next stage  

        ?   0   1   :   1 ;  // no borrow in and A >= B ,
                             // so don't borrow from next stage

        0   1   ?   :   0 ;  // A < B , so borrow from next stage

        1   0   ?   :   1 ;  // A > B , NO borrow from next stage

        ?   1   0   :   0 ;  // A <= B and borrow in is on , so
                             // borrow from next stage   

        1   ?   1   :   1 ;  // A >= B , and no borrow in ,
                             // so don't borrow from next stage
  
    endtable
endprimitive   

primitive U_SUB2_D (S, A, B, CI);
    output S;
    input CI, A, B;
          
// FUNCTION : 1-bit SUBTRACTOR Difference ( A - B) out term 

// Conventions :  CI = BORROW IN , S = DIFFERENCE 
// CI = 0 implies borrow is on i.e. previous stage is 
// borrowing from this stage and CI =  1 implies
// no borrow

    table
    //  A   B   CI  :   S           Operation performed
        0   0   0   :   1 ;     //  S =  10  - 1 - 0 
        0   0   1   :   0 ;     //  S =  0 - 0
        0   1   0   :   0 ;     //  S =  10 - 1 - 1 
        0   1   1   :   1 ;     //  S =  10 - 1 
        1   0   0   :   0 ;     //  S =  1 - 1 - 0
        1   0   1   :   1 ;     //  S =  1 - 0
        1   1   0   :   1 ;     //  S =  11 - 1 - 1
        1   1   1   :   0 ;     //  S =  1 - 1

    endtable
endprimitive   




primitive s_lanln (QN,EN,D,notifier);

output	QN;
input	EN,D,notifier;
reg	QN;

table
// EN     D    notifier : - : QN ;
    0    (?0)	 ?	: ? :  1 ;
    0    (?1)    ?	: ? :  0 ;
    1     * 	 ?	: ? :  - ;
    f     0	 ?	: ? :  1 ;
    f 	  1	 ? 	: ? :  0 ;
   (1x)   0  	 ?	: 1 :  x ;
   (1x)   1      ?      : 0 :  x ;
   (x0)   0      ? 	: ? :  1 ;
   (x0)   1      ?      : ? :  0 ;
   (0x)   ?	 ? 	: ? :  x ;
   r      0	 ? 	: ? :  - ;
   r      1	 ? 	: ? :  - ;
   ?	  ? 	 *	: ? :  x ;
endtable
endprimitive 





primitive s_lanhn (QN,E,D,notifier);

output QN;
reg    QN;
input  E,D,notifier;

table
// E	D	notifier : - : QN;
   1	(?0)	   ?     : ? :  1;
   1	(?1)	   ?     : ? :  0;
   0     *         ?	 : ? :  -;
   r	 0	   ? 	 : ? :  1;
   r     1	   ? 	 : ? :  0;    
   (0x)  0         ?  	 : 1 :  x;
   (0x)  1	   ?	 : 0 :  x;     
   (x1)  0	   ?     : ? :  1;
   (x1)  1         ?     : ? :  0;      
   (1x)  ?	   ? 	 : ? :  x;
    f    0         ?     : ? :  -;
    f    1         ?     : ? :  -;
    ?    ?         *     : ? :  x;
  
endtable
endprimitive 




primitive s_sdcrn(QN,CP,SC,CDN,SD,D,notifier);

output QN;
reg    QN;
input  CP,SC,CDN,SD,D,notifier;

table
// CP   SC   CDN  SD   D    nfr : - : QN;
    ?    ?    0    ?   ?     ?  : ? :  1;
    r    0    1    ?   0     ?  : ? :  1;
    r    0    1    ?   1     ?  : ? :  0;
    r    1    1    0   ?     ?  : ? :  1;
    r    1    1    1   ?     ?  : ? :  0;
    r    x    1    0   0     ?  : ? :  1;
    r    x    1    1   1     ?  : ? :  0;
    r    ?    x    0   0     ?  : ? :  1;
    r    0    x    ?   0     ?  : ? :  1;
    r    1    x    0   ?     ?  : ? :  1;
    n    ?    ?    ?   ?     ?  : ? :  -;
    ?    *    ?    ?   ?     ?  : ? :  -;
    ?    ?    ?    *   ?     ?  : ? :  -;
    ?    ?    ?    ?   *     ?  : ? :  -;
    ?    ?    r    ?   ?     ?  : ? :  -;
    ?    ?   (?x)  ?   ?     ?  : 1 :  1;    
    ?    ?   (?1)  ?   ?     ?  : ? :  -;    
    ?    ?    ?    ?   ?     *  : ? :  x;
endtable

endprimitive


