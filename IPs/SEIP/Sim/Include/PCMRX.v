task PCMRXWrite;
     input [31:0] data;
begin
		while(!RXRDY) @(posedge MCK);
                #DLY RXD  = data;
                     RXWE = 1;
		repeat(1) @(posedge MCK);

                #DLY RXWE = 0;
		repeat(3) @(posedge MCK);
end
endtask
