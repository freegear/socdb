task FunctionTest;
begin

APBWrite(12'h000, 16'h001D);//          3
                            //         15         SD1I(R)=0xC98B4  SD2I(R)= 0xB3A65

repeat (12) @(posedge MCK);
SerialEn = 1;
@(negedge MLRCK);
repeat (35) @(posedge MCK);

PcmRxEn = 1;

APBWrite(12'h001, 16'h00DF);//         50
APBWrite(12'h014, 16'h0010);//         58   
APBWrite(12'h015, 16'h1000);//         61
APBWrite(12'h016, 16'h0040);//         67(62)
APBWrite(12'h017, 16'h8000);//         71   
APBWrite(12'h148, 16'hAAAA);//         86   
APBWrite(12'h018, 16'h0000);//        143
APBWrite(12'h330, 16'h4440);//        198
APBWrite(12'h331, 16'h000E);//        261   
APBWrite(12'h332, 16'h4001);//        331(262)
APBWrite(12'h333, 16'h4000);//        401
APBWrite(12'h334, 16'h4444);//        471   
APBWrite(12'h335, 16'h41DE);//        548
APBWrite(12'h336, 16'hA5A5);//        625   
APBWrite(12'h534, 16'h7070);//        793
APBWrite(12'h535, 16'h7676);//        866(795)
APBWrite(12'h536, 16'h4040);//        942
APBWrite(12'h537, 16'h7070);//       1013 
APBWrite(12'h732, 16'h0660);//       1095   
APBWrite(12'h733, 16'h0660);//       1178 
APBWrite(12'h734, 16'h0660);//       1259
APBWrite(12'h735, 16'h0740);//       1384
APBWrite(12'h736, 16'h060D);//       1464
APBWrite(12'h737, 16'h4060);//       1490

                            //       1610           SD1I(L)=0x6374B  SD2I(L)= 0x4C59A 
@(posedge MLRCK);
repeat (30) @(posedge MCK);

APBWrite(12'h2D4, 16'h7777);//       1910

//READ	0x010 			 2190
//READ	0x011
//READ	0x012
//READ	0x013
APBRead(12'h010);
APBRead(12'h011);
APBRead(12'h012);
APBRead(12'h013);

APBWrite(12'h010,	16'h0410);
APBWrite(12'h011,	16'h1008);
APBWrite(12'h012,	16'h4040);
APBWrite(12'h013,	16'h8020);

@(negedge MLRCK);
repeat (30) @(posedge MCK);

APBWrite(12'h1CA,	16'h4444);

APBWrite(12'h1DB,	16'h0000);
APBWrite(12'h1BC,	16'h3333);
APBWrite(12'h1CD,	16'h5555);
APBWrite(12'h19D,	16'h7777);
APBWrite(12'h494,	16'h7070);

@(posedge MLRCK);
repeat (30) @(posedge MCK);

APBWrite(12'h6E3,	16'h4444);
APBWrite(12'h385,	16'h3333);
APBWrite(12'h180,	16'h6666);
APBWrite(12'h591,	16'h1111);

@(negedge MLRCK);
//repeat (7) @(posedge MCK);
repeat (35) @(posedge MCK);

APBWrite(12'h777,	16'h7777);

APBRead(12'h010);
APBRead(12'h011);
APBRead(12'h012);
APBRead(12'h013);

repeat (100) @(posedge MCK);

@(posedge MLRCK);
repeat (148) @(posedge MCK);

APBWrite(12'h011,	16'h000B);
APBWrite(12'h013,	16'h0020);

repeat (100) @(posedge MCK);

end
endtask
