/****************************************************************************************
*
*    File Name:  tb.v
*      Version:  5.0
*        Model:  BUS Functional
*
* Dependencies:  mobile_ddr.v, ddr_parameters.v
*
*  Description:  Micron SDRAM DDR (Double Data Rate) test bench
*
*         Note:  - Set simulator resolution to "ps" accuracy
*                - Set Debug = 0 to disable $display messages
*
*   Disclaimer   This software code and all associated documentation, comments or other 
*  of Warranty:  information (collectively "Software") is provided "AS IS" without 
*                warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
*                DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
*                TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
*                OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
*                WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
*                OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
*                FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
*                THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
*                ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
*                OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
*                ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
*                INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
*                WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
*                OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
*                THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
*                DAMAGES. Because some jurisdictions prohibit the exclusion or 
*                limitation of liability for consequential or incidental damages, the 
*                above limitation may not apply to you.
*
*                Copyright 2003 Micron Technology, Inc. All rights reserved.
*
* Rev  Author Date        Changes
* ---  ------ ----------  ---------------------------------------
* 4.1  JMK    01/14/2001  - Grouped specify parameters by speed grade
*                         - Fixed mem_sizes parameter
* 2.1  SPH    03/19/2002  - Second Release
*                         - Fix tWR and several incompatability
*                           between different simulators
* 3.0  TFK    02/18/2003  - Added tDSS and tDSH timing checks.
*                         - Added tDQSH and tDQSL timing checks.
* 3.1  CAH    05/28/2003  - update all models to release version 3.1
*                           (no changes to this model)
* 3.2  JMK    06/16/2003  - updated all DDR400 models to support CAS Latency 3
* 3.3  JMK    09/11/2003  - Added initialization sequence checks.
* 4.0  JMK    12/01/2003  - Grouped parameters into "ddr_parameters.v"
*                         - Fixed tWTR check
* 4.2  JMK    03/19/2004  - Fixed pulse width checking on Dqs
* 4.3  JMK    04/27/2004  - Changed BL wire size in tb module
*                         - Changed Dq_buf size to [15:0]
* 5.0  JMK    06/16/2004  - Added read to write checking.
*                         - Added read with precharge truncation to write checking.
*                         - Added associative memory array to reduce memory consumption.
*                         - Added checking for required DQS edges during write.
* 6.0  DMR    12/03/2004  - Updates for T37M
****************************************************************************************/

`timescale 1ns / 1ps

module tb;

`include "ddr_parameters.v"

    reg                         CLK         ;
    reg                         CLK_N       ;
    reg                         CKE         ;
    reg                         CS_N        ;
    reg                         RAS_N       ;
    reg                         CAS_N       ;
    reg                         WE_N        ;
    reg       [DM_BITS - 1 : 0] DM          ;
    reg                 [1 : 0] BA          ;
    reg     [ADDR_BITS - 1 : 0] ADDR        ;
    reg       [DQ_BITS - 1 : 0] Dq          ;
    reg      [DQS_BITS - 1 : 0] Dqs         ;

    reg                [12 : 0] mode_reg    ;                   //Mode Register
    reg                [12 : 0] ext_mode_reg;                   //Extended Mode Register

    wire                [7 : 0] BL       = (1<<mode_reg[2:0]);  //Burst Length
    wire                [3 : 0] WL       = 1                ;   //Write Latency

    wire    [DQ_BITS   - 1 : 0] DQ       = Dq               ;
    wire     [DQS_BITS - 1 : 0] DQS      = Dqs              ;

    mobile_ddr sdramddr (
        DQ, 
        DQS, 
        ADDR, 
        BA, 
        CLK, 
        CLK_N, 
        CKE, 
        CS_N, 
        RAS_N, 
        CAS_N, 
        WE_N, 
        DM
    );

    always begin
        # (tCK/2);
        CLK_N = ~CLK_N;
        CLK   = ~CLK_N;
    end

    initial begin
        CLK     =  1'b0;
        CLK_N   =  1'b1;
        CKE     =  1'b0;
        CS_N    =  1'bz;
        RAS_N   =  1'bz;
        CAS_N   =  1'bz;
        WE_N    =  1'bz;
        DM      =  {DM_BITS{1'bz}};
        ADDR    =  {ADDR_BITS{1'bz}};
        BA      =  2'bzz;
        Dq      =  {DQ_BITS  {1'bz}};
        Dqs     =  {DQS_BITS{1'bz}};
    end

    task power_up;
        begin
            CKE     =  1'b0;
            # (10*tCK);
            $display ("%m at time %t TB:  A 200 us delay is required before CKE can be brought high.", $time);
            @ (negedge CLK) CKE     =  1'b1;
            nop (400/tCK+1);
        end
    endtask

    task load_mode;
        input             [1 : 0] ba;
        input [ADDR_BITS - 1 : 0] addr;
        begin
            case (ba)
                2'b00:  begin
                          mode_reg = addr; 
                        end
                2'b10:  begin
                           ext_mode_reg = addr; 
                        end
            endcase
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b0;
            CAS_N   = 1'b0;
            WE_N    = 1'b0;
            BA      =   ba;
            ADDR    = addr;
            # tCK;
        end
    endtask

    task refresh;
        begin
            CKE     =  1'b1;
            CS_N    =  1'b0;
            RAS_N   =  1'b0;
            CAS_N   =  1'b0;
            WE_N    =  1'b1;
            # tCK;
        end
    endtask
     
    task burst_term;
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b1;
            CAS_N   = 1'b1;
            WE_N    = 1'b0;
            # tCK;
        end
    endtask

    task self_refresh;
        input count;
        integer count;
        begin
            CKE     =  1'b0;
            CS_N    =  1'b0;
            RAS_N   =  1'b0;
            CAS_N   =  1'b0;
            WE_N    =  1'b1;
            # (count*tCK);
        end
    endtask

    task precharge;
        input             [1 : 0] ba;
        input [ADDR_BITS - 1 : 0] addr;
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b0;
            CAS_N   = 1'b1;
            WE_N    = 1'b0;
            BA      =   ba;
            ADDR    = addr;
            # tCK;
        end
    endtask
     
    task activate;
        input             [1 : 0] ba;
        input [ADDR_BITS - 1 : 0] addr;
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b0;
            CAS_N   = 1'b1;
            WE_N    = 1'b1;
            BA      =   ba;
            ADDR    = addr;
            # tCK;
        end
    endtask

    //write task supports burst lengths <= 16
    task write;
        input                [1 : 0] ba;
        input    [ADDR_BITS - 1 : 0] addr;
        input [16*DM_BITS   - 1 : 0] dm;
        input [16*DQ_BITS   - 1 : 0] dq;
        integer i;
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b1;
            CAS_N   = 1'b0;
            WE_N    = 1'b0;
            BA      =   ba;
            ADDR    = addr;
            for (i=0; i<=BL; i=i+1) begin
                if (i%2 === 0) begin
                    Dqs <= #(WL*tCK + i*tCK/2) {DQS_BITS{1'b0}};
                end else begin
                    Dqs <= #(WL*tCK + i*tCK/2) {DQS_BITS{1'b1}};
                end

                case (i)
                    15: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[16*DM_BITS-1 : 15*DM_BITS];
                    14: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[15*DM_BITS-1 : 14*DM_BITS];
                    13: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[14*DM_BITS-1 : 13*DM_BITS];
                    12: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[13*DM_BITS-1 : 12*DM_BITS];
                    11: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[12*DM_BITS-1 : 11*DM_BITS];
                    10: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[11*DM_BITS-1 : 10*DM_BITS];
                     9: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[10*DM_BITS-1 :  9*DM_BITS];
                     8: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 9*DM_BITS-1 :  8*DM_BITS];
                     7: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 8*DM_BITS-1 :  7*DM_BITS];
                     6: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 7*DM_BITS-1 :  6*DM_BITS];
                     5: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 6*DM_BITS-1 :  5*DM_BITS];
                     4: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 5*DM_BITS-1 :  4*DM_BITS];
                     3: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 4*DM_BITS-1 :  3*DM_BITS];
                     2: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 3*DM_BITS-1 :  2*DM_BITS];
                     1: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 2*DM_BITS-1 :  1*DM_BITS];
                     0: DM  <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 1*DM_BITS-1 :  0*DM_BITS];
                endcase
                case (i)
                    15: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[16*DQ_BITS-1 : 15*DQ_BITS];
                    14: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[15*DQ_BITS-1 : 14*DQ_BITS];
                    13: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[14*DQ_BITS-1 : 13*DQ_BITS];
                    12: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[13*DQ_BITS-1 : 12*DQ_BITS];
                    11: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[12*DQ_BITS-1 : 11*DQ_BITS];
                    10: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[11*DQ_BITS-1 : 10*DQ_BITS];
                     9: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[10*DQ_BITS-1 :  9*DQ_BITS];
                     8: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 9*DQ_BITS-1 :  8*DQ_BITS];
                     7: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 8*DQ_BITS-1 :  7*DQ_BITS];
                     6: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 7*DQ_BITS-1 :  6*DQ_BITS];
                     5: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 6*DQ_BITS-1 :  5*DQ_BITS];
                     4: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 5*DQ_BITS-1 :  4*DQ_BITS];
                     3: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 4*DQ_BITS-1 :  3*DQ_BITS];
                     2: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 3*DQ_BITS-1 :  2*DQ_BITS];
                     1: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 2*DQ_BITS-1 :  1*DQ_BITS];
                     0: Dq  <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 1*DQ_BITS-1 :  0*DQ_BITS];
                endcase
                Dqs     <= #(WL*tCK + BL*tCK/2 + tCK/2) {DQS_BITS{1'bz}};
                DM      <= #(WL*tCK + BL*tCK/2 + tCK/4) {DM_BITS{1'bz}};
                Dq      <= #(WL*tCK + BL*tCK/2 + tCK/4) {DQ_BITS{1'bz}}; 
            end
            # tCK;  
        end
    endtask

    task read;
        input             [1 : 0] ba;
        input [ADDR_BITS - 1 : 0] addr;
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b1;
            CAS_N   = 1'b0;
            WE_N    = 1'b1;
            BA      =   ba;
            ADDR    = addr;
            # tCK;
        end
    endtask

    task nop;
        input  count;
        integer count;
        begin
            CKE     =  1'b1;
            CS_N    =  1'b0;
            RAS_N   =  1'b1;
            CAS_N   =  1'b1;
            WE_N    =  1'b1;
            # (count*tCK);
        end
    endtask

    task power_down;
        input  count;
        integer count;
        begin
            CKE     =  1'b0;
            CS_N    =  1'b1;
            RAS_N   =  1'b1;
            CAS_N   =  1'b1;
            WE_N    =  1'b1;
            # (count*tCK);
        end
    endtask

    initial begin
        // POWERUP SECTION 
        power_up;  // 200 us nop delay is handled in here
        $display("Powerup complete");

        // INITIALIZE SECTION
        precharge       (0, 1024);                    // Precharge all banks
        nop             (tRP/tCK);
        
        refresh;
        nop             (tRFC/tCK);

        refresh;
        nop             (tRFC/tCK);
        
        // order of mode and ext_mode not important 
        load_mode       (2'b00, 12'b00010_010_0_010); // Mode Register with DLL Reset (CL=2, BL=4)
        nop             (tMRD);

        load_mode       (2'b10, 12'b000000000000);    // Extended Mode Register with DLL Enable
        nop             (tMRD);
        
        // DLL RESET ENABLE - you will need 200 tCK before any read command.
        nop             (200);

        // ACTIVATE SECTION
        activate        (1, 0);                       // Activate Bank 1, Row 0
        nop             (tRRD/tCK);

        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);

        // WRITE SECTION
        $display("%m At time %t: WRITE Burst", $time);
        write           (0, 10, 0, 10);               // Write  Bank 0, Col 10
        nop             (BL/2);

        $display("%m At time %t: Consecutive WRITE to WRITE", $time);
        write           (0, 10, 0, 10);               // Write  Bank 0, Col 10
        nop             (1);
        write           (0, 20, 0, 20);               // Write  Bank 0, Col 20
        nop             (BL/2);

        $display("%m At time %t: Nonconsecutive WRITE to WRITE", $time);
        write           (0, 10, 0, 10);               // Write  Bank 0, Col 10
        nop             (2);
        write           (0, 20, 0, 20);               // Write  Bank 0, Col 20
        nop             (BL/2);

        $display("%m At time %t: Random WRITE Cycles", $time);
        write           (0, 10, 0, 10);               // Write  Bank 0, Col 10
        write           (0, 20, 0, 20);               // Write  Bank 0, Col 20
        write           (0, 30, 0, 30);               // Write  Bank 0, Col 30
        write           (0, 40, 0, 40);               // Write  Bank 0, Col 40
        nop             (BL/2);

        $display("%m At time %t: WRITE to READ - Uninterrupting", $time);
        write           (0, 10, 0, 10);               // Write  Bank 0, Col 10
        nop             (3);
        read            (0, 10);                      // Read   Bank 0, Col 10
        nop             (3+BL/2);

        $display("%m At time %t: WRITE to READ - Interrupting", $time);
        write           (0, 10, {{2*DM_BITS{1'b1}},{2*DM_BITS{1'b0}}}, 10);  // Write  Bank 0, Col 10
        nop             (2);
        read            (0, 10);                      // Read   Bank 0, Col 10
        nop             (3+BL/2);

        $display("%m At time %t: WRITE to READ - Odd Number of Data, Interrupting", $time);
        write           (0, 10, {{2*DM_BITS+DM_BITS{1'b1}},{2*DM_BITS-DM_BITS{1'b0}}}, {4*DQ_BITS{1'b1}});  // Write  Bank 0, Col 10
        nop             (2);
        read            (0, 10);                      // Read   Bank 0, Col 10
        nop             (3+BL/2);

        $display("%m At time %t: WRITE to PRECHARGE - Uninterrupting", $time);
        write           (0, 10, 0, 10);               // Write  Bank 0, Col 10
        nop             (BL/2 + tWR/tCK);
        precharge       (0, 0);                       // Precharge Bank 0
        nop             (tRP/tCK);
        
        $display("%m At time %t: WRITE to PRECHARGE - Interrupting", $time);
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);
        write           (0, 10, {{2*DM_BITS{1'b1}},{2*DM_BITS{1'b0}}}, 10);  // Write  Bank 0, Col 10
        nop             (1 + tWR/tCK);
        precharge       (0, 0);                       // Precharge Bank 0
        nop             (tRP/tCK);

        $display("%m At time %t: WRITE to PRECHARGE - Odd Number of Data - Interrupting", $time);
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);
        write           (0, 10, {{2*DM_BITS+DM_BITS{1'b1}},{2*DM_BITS-DM_BITS{1'b0}}}, 10);  // Write  Bank 0, Col 10
        nop             (1 + tWR/tCK);
        precharge       (0, 0);                       // Precharge Bank 0
        nop             (tRP/tCK);

                
        // READ SECTION
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);

        $display("%m At time %t: READ Burst", $time);
        read            (0, 10);                      // Read   Bank 0, Col 10
        nop             (3+BL/2);

        $display("%m At time %t: Consecutive READ Bursts", $time);
        read            (0, 10);                      // Read   Bank 0, Col 10
        nop             (BL/2-1);
        read            (0, 20);                      // Read   Bank 0, Col 20
        nop             (3+BL/2);
        
        $display("%m At time %t: Nonconsecutive READ Bursts", $time);
        read            (0, 10);                      // Read   Bank 0, Col 10
        nop             (BL/2);
        read            (0, 20);                      // Read   Bank 0, Col 20
        nop             (3+BL/2);

        $display("%m At time %t: Random READ Accesses", $time);
        read            (0, 10);                      // Read   Bank 0, Col 10
        read            (0, 20);                      // Read   Bank 0, Col 20
        read            (0, 30);                      // Read   Bank 0, Col 30
        read            (0, 40);                      // Read   Bank 0, Col 40
        nop             (3+BL/2);
        
        $display("%m At time %t: Terminating a READ Burst", $time);
        read            (0, 10);                      // Read   Bank 0, Col 10
        burst_term;
        nop             (BL/2);

        $display("%m At time %t: READ to WRITE", $time);
        read            (0, 10);                      // Read   Bank 0, Col 10
        burst_term;
        nop             (1);
        write           (0, 10, 0, 10);               // Write  Bank 0, Col 10
        nop             (1+BL/2);

        $display("%m At time %t: READ to PRECHARGE", $time);
        read            (0, 10);                      // Read   Bank 0, Col 10
        nop             (1);        
        precharge       (0, 1024);                    // Precharge all banks
        nop             (tRP/tCK);

        $display("At time %t: SIMULATION ENDING NORMALLY", $time);
        //$stop;
        //$finish;
    end

endmodule
