task MPUIfWrite;
     input [11:0] address;
     input [15:0] data;
begin
		while(!PRDY) @(posedge MCK);
                #DLY PIA  = address[11:0];
                     PIDI = data;
                     XPWE = 0;
		repeat(1) @(posedge MCK);

                #DLY XPWE = 1;
		//repeat(50) @(posedge MCK);
end
endtask

task MPUIfRead;
     input [11:0] address;
begin
		while(!PRDY) @(posedge MCK);
                #DLY PIA  = address[11:0];
                #DLY PIA  = address[11:0];
                     XPOE = 0;
		repeat(2) @(posedge MCK);

                #DLY XPOE = 1;
		 //repeat(50) @(posedge MCK);
end
endtask

//		if(PRDY == 1'b1)  @(posedge MCK);
//		else while(!PRDY) @(posedge MCK);
