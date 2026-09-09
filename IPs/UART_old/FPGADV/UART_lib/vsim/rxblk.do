echo "RXBlock Simulation"
restart

force rstb 0
force clk 1 0 , 0 5 ns -repeat 10 ns
force baudx16clk 1 0 , 0 10 ns -repeat 50 ns
force databit 1
force parity  00
force rxd 1
force stopbit 1
force fifordb 1
force statusrstb 1
force swrstb 1
force uartenb 1

run 103 ns

force rstb 1

run 100 ns
force uartenb 0
run 100 ns

############################
# Start bit
force rxd 0
run 800 ns

force rxd 0
run 800 ns
force rxd 1
run 800 ns
force rxd 0
run 800 ns
force rxd 1
run 800 ns

force rxd 0
run 800 ns
force rxd 1
run 800 ns
force rxd 0
run 800 ns
force rxd 1
run 800 ns

# Stop Bit
force rxd 1
run 800 ns

force rxd 1
run 800 ns


########
run 100 ns

# Set even parity
force parity  10

############
############################
# Start bit
force rxd 0
run 800 ns

force rxd 0
run 800 ns
force rxd 1
run 800 ns
force rxd 0
run 800 ns
force rxd 1
run 800 ns

force rxd 0
run 800 ns
force rxd 1
run 800 ns
force rxd 0
run 800 ns
force rxd 1
run 800 ns

# Parity bit
force rxd 0
run 800 ns

# Stop Bit
force rxd 1
run 800 ns

# Stop Bit
force rxd 1
run 800 ns

force rxd 1
run 800 ns


#################################
# Start bit
force rxd 0
run 800 ns

force rxd 1
run 800 ns
force rxd 0
run 800 ns
force rxd 0
run 800 ns
force rxd 1
run 800 ns

force rxd 1
run 800 ns
force rxd 1
run 800 ns
force rxd 0
run 800 ns
force rxd 1
run 800 ns

# Parity bit
force rxd 0
run 800 ns

# Stop Bit
force rxd 1
run 800 ns

# Stop Bit
force rxd 1
run 800 ns

force rxd 1
run 800 ns



#################################
# Start bit
force rxd 0
run 800 ns

force rxd 1
run 800 ns
force rxd 0
run 800 ns
force rxd 0
run 800 ns
force rxd 1
run 800 ns

force rxd 1
run 800 ns
force rxd 1
run 800 ns
force rxd 0
run 800 ns
force rxd 1
run 800 ns

# Parity bit
force rxd 0
run 800 ns

# Stop Bit
force rxd 1
run 800 ns

# Stop Bit
echo "Frame Error"
force rxd 0
run 800 ns

force rxd 1
run 800 ns




