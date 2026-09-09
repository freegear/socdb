vlib work
vmap work work

vcom -reportprogress 300 -work work mem_util_pkg.vhd
vcom -reportprogress 300 -work work Internal_Logic.vhd
vcom -reportprogress 300 -work work Memory_Access.vhd
vcom -reportprogress 300 -work work ACDC_check.vhd
vcom -reportprogress 300 -work work M25P20.vhd
vcom -reportprogress 300 -work work varcount.vhd
vcom -reportprogress 300 -work work spi_cpld.vhd
vcom -reportprogress 300 -work work spi_tb.vhd

vsim work.spi_cpld_tb

view signals
view structure

do wave_func.do

run 90 us