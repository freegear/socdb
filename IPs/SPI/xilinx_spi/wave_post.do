onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -label vcc /spi_cpld_tb/vcc
add wave -noupdate -divider {FPGA Interface}
add wave -noupdate -format Logic -label cclk /spi_cpld_tb/fpga_cclk
add wave -noupdate -format Logic -label init/spi_d /spi_cpld_tb/fpga_init
add wave -noupdate -format Logic -label din/spi_q /spi_cpld_tb/fpga_din
add wave -noupdate -format Logic -label done /spi_cpld_tb/fpga_done
add wave -noupdate -format Logic -label fpga_io_clk /spi_cpld_tb/fpga_io_clk
add wave -noupdate -format Logic -label fpga_io_sn /spi_cpld_tb/fpga_io_sn
add wave -noupdate -format Logic -label fpga_io_wn /spi_cpld_tb/fpga_io_wn
add wave -noupdate -format Logic -label fgpa_io_holdn /spi_cpld_tb/fpga_io_holdn
add wave -noupdate -divider {SPI Flash Interface}
add wave -noupdate -format Logic -label c /spi_cpld_tb/spi_c
add wave -noupdate -format Logic -label d /spi_cpld_tb/spi_d
add wave -noupdate -format Logic -label q /spi_cpld_tb/spi_q
add wave -noupdate -format Logic -label sn /spi_cpld_tb/spi_sn
add wave -noupdate -format Logic -label wn /spi_cpld_tb/spi_wn
add wave -noupdate -format Logic -label holdn /spi_cpld_tb/spi_holdn
add wave -noupdate -divider {Control Signals}
add wave -noupdate -format Logic -label ext_spi /spi_cpld_tb/ext_spi
add wave -noupdate -divider Troubleshooting
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {6799896 ps} 0}
WaveRestoreZoom {0 ps} {94500 ns}
configure wave -namecolwidth 190
configure wave -valuecolwidth 92
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
