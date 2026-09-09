## ISLAND 1 ##

set start1 [define_coll  [find -inst {TxBLK.fifo_rdpos[2:0]} -hier] [find -inst {TxBLK.txfifo[7:0]} -hier]  ]
set end1 [find -inst {TxBLK.shiftreg[7:0]} -hier] 
set sel1 [expand -from $start1 -to $end1 -hier]
select $sel1
create_region island1 0 0 5 5 
assign_to_region island1 $sel1


## ISLAND 2 ##

set start2 [find -inst {RegBlock.timeoutcnt_int[19:0]} -hier] 
set end2 [find -inst {RegBlock.timeoutcnt_int[19:0]} -hier] 
set sel2 [expand -from $start2 -to $end2 -hier]
select $sel2
create_region island2 1 1 6 6 
assign_to_region island2 $sel2


