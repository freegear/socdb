vlog TbI2C.v

vlog BTransCtl.v
vlog ClkCtl.v
vlog I2cCtl.v
vlog SMCtl.v
vlog StartCtl.v
vlog StopCtl.v

vlog I2cBusDet.v
vlog I2cBusFlt.v
vlog I2cClkDiv.v
vlog I2cIOShft.v
vlog I2cCore.v
vlog I2cReg.v
vlog I2C.v

vlog Include/i2c_slave_model.v

vsim work.TbI2C

destroy .wave
view wave

do wave.do

config wave -signalnamewidth 2

run -all
