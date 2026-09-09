

#################
proc initialize_topmodule { } {
    force clk 1 0 , 0 5 ns -repeat 10 ns
    #####################
    force rxd 1
    force rstb 0

    force PENABLE 0
    force PSEL    0
    force PADDR   16\#00000000
    force PWDATA  16\#00000000
    force PWRITE  0
    #force CLK1MHZ 1 0 , 0 50 ns -repeat 100 ns

    run 100 ns
    
    force rstb 1

    run 3 ns

    run 1 us    

}
##############################
proc register_read { ADDRESS } {

    force PADDR  $ADDRESS
    force PENABLE 1
    force PSEL   1
    force PWRITE 0
    run    30 ns

    force PSEL   0
    force PWRITE 0
    force PENABLE 0
    
    run    30 ns


}

##############################

proc register_write { ADDRESS DATA } {

    force PADDR  $ADDRESS
    force PWDATA $DATA
    force PENABLE 1
    force PSEL   1
    force PWRITE 1
    run    10 ns

    force PSEL   0
    force PWRITE 0
    force PENABLE 0
    
    run    10 ns

}

###################################

proc send_rx_data { BIT7 BIT6 BIT5 BIT4 BIT3 BIT2 BIT1 BIT0 STOP0 STOP1 PARITY } {
    
    # START BIT
    force rxd 0
    run   40960 ns
    
    force rxd   $BIT0
    run   40960 ns

    force rxd   $BIT1
    run   40960 ns

    force rxd   $BIT2
    run   40960 ns

    force rxd   $BIT3
    run   40960 ns

    force rxd   $BIT4
    run   40960 ns

    force rxd   $BIT5
    run   40960 ns

    force rxd   $BIT6
    run   40960 ns

    force rxd   $BIT7
    run   40960 ns

    force rxd   $PARITY
    run   40960 ns

    force rxd   $STOP0
    run   40960 ns

    force rxd   $STOP1
    run   40960 ns

} 


proc send_noise_rx_0 { } {
    force rxd 0
    run 2560 ns
    force rxd 1
    run 2560 ns
    force rxd 0
    run 35840 ns

}


proc send_noise_rx_0_pattern_0 { } {
    force rxd 0
    run 2560 ns
    force rxd 1
    run 2560 ns
    force rxd 0
    run 2560 ns
    force rxd 1
    run 2560 ns
    force rxd 0
    run 30720 ns

}

proc send_noise_startbit { } {

    # must not recognized
    force rxd 0
    run  9000 ns
    force rxd 1
    run  9000 ns

    force rxd 0
    run  9500 ns
    force rxd 1
    run  9000 ns

    force rxd 0
    run  9600 ns
    force rxd 1
    run  9000 ns


    force rxd 0
    run  9700 ns
    force rxd 1
    run  9000 ns

    force rxd 0
    run  9800 ns
    force rxd 1
    run  9000 ns

    force rxd 0
    run  9900 ns
    force rxd 1
    run  9000 ns

    force rxd 0
    run  10000 ns
    force rxd 1
    run  9000 ns

    ######################
    force rxd 0
    run  40960 ns
}

proc send_noise_rx_data  { BIT7 BIT6 BIT5 BIT4 BIT3 BIT2 BIT1 BIT0 STOP0 STOP1 PARITY } {


    # START BIT
    send_noise_startbit

    force rxd   $BIT1
    run   40960 ns

    force rxd   $BIT2
    run   40960 ns

    force rxd   $BIT3
    run   40960 ns

    force rxd   $BIT4
    run   40960 ns

    force rxd   $BIT5
    run   40960 ns

    force rxd   $BIT6
    run   40960 ns

    force rxd   $BIT7
    run   40960 ns

    force rxd   $PARITY
    run   40960 ns

    force rxd   $STOP0
    run   40960 ns

    force rxd   $STOP1
    run   40960 ns

    run   1 ms


}

proc send_noise_rx_data_1  {  } {


    # START BIT
    force rxd 0
    run   40960 ns

    ##### 0
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    #########################

    ##### 1
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    #########################

    ##### 2
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    #########################


    ##### 3
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    #########################

    ##### 4
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    #########################


    ##### 5
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    #########################


    ##### 6
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    #########################


    ##### 7
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 1
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    force rxd 0
    run   2560 ns
    #########################
    
    force rxd 1
    run   40960 ns

    force rxd 1
    run   40960 ns

    force rxd 1
    run   40960 ns

    run   1 ms


}


###################################
proc main { } {

    ####################
    set   REG_MASTER_CMD 16\#0
    set   REG_STATUS   16\#1
    set   REG_CLK_DIV  16\#2
    set   REG_TX_FIFO  16\#3
    set   REG_RX_FIFO  16\#4

    ####################
    restart
    
    initialize_topmodule
    
   
    register_write $REG_CLK_DIV 16\#0100
    
    # Tx FIFO Write
    for { set i 1 } { $i <= 8 } { incr i 1 } {
	register_write $REG_TX_FIFO 16\#$i
    }
    
    # Set Master Command Register
    #   31 :	Enable UART
    #	30 : 	Enable Interrupt Generation
    #	29 : 	Enable Receive Time out interrupt
    #	28 :      Software reset
    #		0 : no effect
    #           1 : software reset
    #	27 : Enable DMA Request
    #		0 : disable
    #		1 : Enable dma request
    # 26~25 : Parity
    #           Even / Odd / None
    #		0x : None
    #		10 : Even
    #		11 : Parity
    #	24 : Data bit
    #		7 bit /  8 bit
    #		0 : 7 bit
    #		1 : 8 bit
    #	23 : Stop bit
    #		1 bit / 2 bit
    #		0 : 1 stop bit
    #           1 : 2 stop bit
    #   22 : Loopback Enable
    #           0 : Disable
    #           1 : Enable
    #	21~16 : Reserved
    #	15~13 : Reserved
    #	12~8  : Tx Water Level
    #		[4:0] TxWater level
    #	7~6 : Reserved
    #   4~0 : Rx Water Level
    #		[4:0] RxWater Level
    #                                   3         2         1 
    #                                  10987654321098765432109876543210
    register_write $REG_MASTER_CMD 32'b11101001110000000000100000001000
    
    run 3 ms

    register_read $REG_STATUS
    run 2 ms

    register_read $REG_STATUS
    run 7 ms

    # Tx FIFO Write
    for { set i 33 } { $i <= 40 } { incr i 1 } {
	register_write $REG_TX_FIFO 16\#$i
    }

    run 2 ms

    # Rx FIFO READ
    for { set i 0 } { $i <= 2 } { incr i 1 } {
	register_read $REG_RX_FIFO 
    }

    run 9 ms

    # Disable loopback
    #                                   3         2         1 
    #                                  10987654321098765432109876543210
    register_write $REG_MASTER_CMD 32'b11101001100000000000100000001000

    ##############################################
    # Rx FIFO READ
    for { set i 0 } { $i <= 17 } { incr i 1 } {
	register_read $REG_RX_FIFO 
    }
    
    #            BIT7 BIT6 BIT5 BIT4 BIT3 BIT2 BIT1 BIT0 STOP0 STOP1 PARITY
    send_rx_data 0    1    0    1    0    1    0    1    1     1     0 
    
    send_noise_rx_data 0    1    0    1    0    1    0    1    1     1     0 

    send_noise_rx_data_1

}
