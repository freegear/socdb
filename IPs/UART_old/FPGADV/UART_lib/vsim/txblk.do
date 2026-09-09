restart


force rstb 0
force clk   1 0 , 0 5 ns -repeat 10 ns
#force txclk 1 0 , 0 10 ns  -repeat 160 ns
force baudx16clk 1 0 , 0 5 ns  -repeat 30 ns

force uartenb  1
run 100 ns
run 3 ns

# Even Parity
force parity  10
 # none parity
force stopbit  1 
# two stop bit


force rstb 1

# FIFO Write

force fifowrb 0
force fifodata_tx 16#AA
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#A5
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#81
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#85
run   10 ns
force fifowrb 1
run   10 ns


force fifowrb 0
force fifodata_tx 16#01
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#02
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#03
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#04
run   10 ns
force fifowrb 1
run   10 ns


force fifowrb 0
force fifodata_tx 16#AA
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#A5
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#81
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#85
run   10 ns
force fifowrb 1
run   10 ns


force fifowrb 0
force fifodata_tx 16#01
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#02
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#03
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#04
run   10 ns
force fifowrb 1
run   10 ns


force fifowrb 0
force fifodata_tx 16#AA
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#A5
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#81
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#85
run   10 ns
force fifowrb 1
run   10 ns


force fifowrb 0
force fifodata_tx 16#01
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#02
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#03
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#04
run   10 ns
force fifowrb 1
run   10 ns


force fifowrb 0
force fifodata_tx 16#AA
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#A5
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#81
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#85
run   10 ns
force fifowrb 1
run   10 ns


force fifowrb 0
force fifodata_tx 16#01
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#02
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#03
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#04
run   10 ns
force fifowrb 1
run   10 ns


run 1000 ns

force uartenb 0

run 30000 ns

force fifowrb 0
force fifodata_tx 16#01
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#02
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#03
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#04
run   10 ns
force fifowrb 1
run   10 ns

force fifowrb 0
force fifodata_tx 16#05
run   10 ns
force fifowrb 1
run   10 ns

run 30000 ns

