//---------------------------------------------------------
/*
parameter I2CCTL    = 8'h00;
parameter I2CSTS    = 8'h04;
parameter I2CADR    = 8'h08;
parameter I2CDAT    = 8'h0C;
parameter I2CCCR    = 8'h10;
parameter I2CRST    = 8'h14;
*/

parameter I2CCTL    = 8'h80;
parameter I2CSTS    = 8'h84;
parameter I2CADR    = 8'h88;
parameter I2CDAT    = 8'h8C;
parameter I2CCCR    = 8'h90; // M[3:0],N[2:0](Prescale, 2^n)
parameter I2CRST    = 8'h94;

parameter IEN  = 8'b0010_0000;
parameter Enab = 8'b0001_0000;
parameter STA  = 8'b0010_0000;
parameter STP  = 8'b0000_0000;

task i2c_task;
			  	   // IEN  : Interrupt enable
			  	   // Enab : I2C Bus enable
			  	   // STA  : Master mode Start
			  	   // STP  : Master mode Stop
			  	   // IFLG : Interrupt Flag
			  	   // AAK  : Assert acknowledge
begin
 	      APBWrite(I2CRST, 8'hff);
	      repeat (30) @(posedge PClk);
//--------------------------------------------------------------------
// eeprom write

	      APBWrite(I2CCCR, 8'h15); 	// load prescaler
	      //APBWrite(I2CCCR, 8'hff); 	// load prescaler
	      APBWrite(I2CCTL, IEN);
	      
	      APBWrite(I2CSTS, Enab | STA); // clear stop
	      wait(I2cInt[1]) @(posedge PClk);
	      repeat (10) @(posedge PClk);
	      APBRead(I2CSTS);

	      APBWrite(I2CDAT, 8'ha0); // write
	      wait(I2cInt[1]) @(posedge PClk);
	      repeat (10) @(posedge PClk);
	      APBRead(I2CSTS);

//	      APBWrite(I2CCCR, 8'h01); 	// load prescaler
	      APBWrite(I2CDAT, 8'h00);
	      wait(I2cInt[1]) @(posedge PClk);
	      repeat (10) @(posedge PClk);
	      APBRead(I2CSTS);

	      APBWrite(I2CDAT, 8'h55);
	      wait(I2cInt[1]) @(posedge PClk);
	      repeat (10) @(posedge PClk);

	      APBRead(I2CSTS);

	      APBWrite(I2CSTS, Enab | STP);
	      repeat (10) @(posedge PClk);
	      APBRead(I2CSTS);


// eeprom read

	      APBWrite(I2CSTS, Enab | STA);
	      wait(I2cInt[1]) @(posedge PClk);
	      repeat (10) @(posedge PClk);
	      APBRead(I2CSTS);

	      APBWrite(I2CDAT, 8'ha1); // read
	      wait(I2cInt[1]) @(posedge PClk);
	      repeat (10) @(posedge PClk);

//	      APBWrite(I2CCCR, 8'h05); 	// load prescaler
	      APBWrite(I2CDAT, 8'h00);
	      wait(I2cInt[1]) @(posedge PClk);
	      repeat (10) @(posedge PClk);

	      APBRead(I2CSTS);

	      APBWrite(I2CSTS, Enab | STP);
	      repeat (10) @(posedge PClk);
//	      APBRead(I2CSTS);
	      APBRead(I2CDAT);

end
endtask

