database -open waves -into ../out/wave/i1-basic-nocache -default
probe -create -shm xess_top -all -variables -depth all
probe -create -shm or1200_monitor -all -variables -depth all
stop -create -time 500ms -relative
run
quit
