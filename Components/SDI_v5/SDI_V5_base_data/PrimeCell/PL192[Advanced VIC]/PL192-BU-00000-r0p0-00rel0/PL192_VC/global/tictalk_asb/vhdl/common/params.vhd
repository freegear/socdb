-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : params.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
--
-- ---------------------------------------------------------------------
-- Purpose : Package defining standard delay times for AMBA and APB.
--           Note that delayed constants are not used as these 
--           are not accepted by the Compass Synthesis tools
--
-- --=================================================================--

package params is

  -- latches and flip-flops
  -- synopsys synthesis_off
  constant DLPG   : time :=   2 ns ;     -- D-Latch Propagate Time
                                         -- (D or CLK to Q)
  constant DSET   : time :=   1 ns ;     -- D-Latch Setup time
  constant DHOL   : time :=   1 ns ;     -- D-Latch hold time

  constant TLPG   : time :=   2 ns ;     -- Transparent Latch 
                                         -- Propagate Time
  constant TSET   : time :=   1 ns ;     -- Transparent Latch Setup time
  constant THOL   : time :=   1 ns ;     -- Transparent Latch hold time

  constant RAMR   : time :=  20 ns ;     -- RAM Read time
  constant RAMW   : time :=  15 ns ;     -- RAM Write time

  -- combinatorial logic
  constant GAT1   : time :=   1 ns ;     -- single gate delay
  constant GAT2   : time :=   2 ns ;     -- two gate delay
  constant GAT3   : time :=   4 ns ;     -- three gate delay
  constant CGAT   : time :=   2 ns ;     -- complex gate delay

  constant BUF1   : time :=   2 ns ;     -- Buffer delay

  -- bus driving
  constant BUSE   : time :=   4 ns ;     -- Bus Enable time
                                         -- time to drive a tri-state 
                                         -- bus
                                         -- from 'Z' to a specific value
  constant BUSD   : time :=   3 ns ;     -- Bus Disable time
                                         -- time to stop driving a 
                                         -- tri-state bus : from value 
                                         -- to 'Z'
  -- pads

  constant OPPD   : time :=   8 ns ;     -- Output pad drive time
  constant IPPD   : time :=   4 ns ;     -- Input pad drive time
  constant ENPD   : time :=  12 ns ;     -- Tri-state pad enable time
                                         -- time to drive a tri-state 
                                         -- bus from 'Z' to a specific 
                                         -- value
  constant DIPD   : time :=   9 ns ;     -- Tri-state pad disable time
                                         -- time to stop driving a 
                                         -- tri-state bus : from value 
                                         -- to 'Z'
   -- synopsys synthesis_on
  
end params ;
 
-- --============================== End ==============================--
