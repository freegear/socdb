-- --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : README_SIM_ERR_MSG.txt.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--            This file gives the list of error messages in the Verilog RTL log
              files for netlist simulation
-- --=========================================================================--
The following messages that appear in the simulation log file for Verilog-XL
netlist simulations can be ignored:

../uut/<netlist file name>.sdf21  LXXXXXX: SDFA Warning: Negative
timing check limit -X.XXXXX set to 0

===================================================================================

Below is a mail from Cadence support with regards to SDFA Warning: Negative
timing check limit.

The following provides information as to how to disable warning in verilog XL and NC Verilog:

Verilog XL
  - to disable all timing check warning messages use +no_tchk_msg on your command line

  - to disable a specific warning, type +nowarn<specific_warning_code> on your command line.
  i.e.   +nowarnTFNPC
        
NC Verilog
  - if you are using ncverilog execution, to disable a specific warning use 
+ncnowarn+<specific_warning>.
  i.e.  +ncnowarn+TFNPC

  - if your are using ncverilog execution, to disable output of ALL warnings use +ncneverwarn

  - if you are using ncverilog execution, to disable timing check warnings use +ncno_tchk_msg

  - if you are using the three step execution, then to disable ALL warnings then use -neverwarn at 
each step
  
  - if you are using the three step execution, then to disable a specific warning then use -nowarn 
<specific_warning> in the step where the warning is occuring 

  - if you are using the three step execution, then to disable timing check messages type 
-no_tchk_msg during the ncelab phase of the execution.



From the log file you sent, I see you are using the +neg_tchk option, the negative timing checks 
could still
be set to zero.

It is due to the negative hold times and that fact that the regions for the setup and hold do not 
overlap and therefore Verilog does not converge and it sets the hold time to zero such that it can 
converge.  

This makes the timing for the adjusted flip flop very pessimistic now and hence the warning that a 
timing violation has occured will be issued.

The following is an explanation in detail of why it occurs along with an example. 

The problem is caused when an SDF file has 2 or more timing checks with respect 
to an event edge, (like posedge clock) and the violation regions created by 
these timing checks do not overlap each other. This condition causes the 
negative timing check algorithm not to converge. Verilog forces convergence by 
setting negative values in the timing check to zero. Verilog sets one value to 
zero and then checks to see if the timing converged. The process is repeated 
until the timing converges or all the negative values are set to zero.

Example:
        ....4....3....2....1....0....1....2....3
                                 _______________
clock   ________________________/

        ....4....3....2....1....0....1....2....3
        
Positive and negative timing checks in SDF file

             ___________________________________
d(pos)  ____/____/

        ___________________
d(neg)                \____\____________________

  (TIMINGCHECK
    (SETUP (posedge D) (posedge CK) (4.000:4.000:4.000))
    (HOLD (posedge D) (posedge CK) (-3.000:-3.000:-3.000))
    (SETUP (negedge D) (posedge CK) (2.000:2.000:2.000))
    (HOLD (negedge D) (posedge CK) (-1.000:-1.000:-1.000))
  )
        ....4....3....2....1....0....1....2....3

Positive and negative timing checks in verilog after convergence. Both negative 
hold values set to zero.

             ___________________________________
d(pos)  ____/___________________/

        ________________________
d(neg)                \_________\_______________

After annotation:
   $setuphold(posedge CK, posedge D, 4, 0);
   $setuphold(posedge CK, posedge D, 2, 0);

        ....4....3....2....1....0....1....2....3

Test data changes at (0.5)

        ______________________ _________________
d       ______________________X_________________

The SDF file has a violation region of (4, -3) for the positive edge of (D) and
(2, -1) for the negative violation region. After convergence both negative hold 
values get set to zero, (4, 0) for positive edge and (2, 0) for negative edge. 

During simulation the (D) input is changed (0.5) time units before the postive
edge of (CK). This should be a good time, but a setup time voilation is issued.

*Solution:

Currently the only solution to make Verilog converge, is to make the violation
regions overlap a little bit. This way Verilog will converge. The SDF file has 
to be edited by hand to change the values in the timing check so that the 
violation regions over lap. Scripts can be created to help automate to the 
editing process.

Example: Change the (-3) hold time on the positive edge to (-1.9).
        ....4....3....2....1....0....1....2....3 
                                 _______________ 
clock   ________________________/ 
 
        ....4....3....2....1....0....1....2....3 
Positive and negative timing checks in SDF file 
             ___________________________________ 
d(pos)  ____/__________/   
 
        ___________________ 
d(neg)                \____\____________________

  (TIMINGCHECK
    (SETUP (posedge D) (posedge CK) (4.000:4.000:4.000))
    (HOLD (posedge D) (posedge CK) (-1.900:-1.900:-1.900))
    (SETUP (negedge D) (posedge CK) (2.000:2.000:2.000))
    (HOLD (negedge D) (posedge CK) (-1.000:-1.000:-1.000))
  )


The timing check algorithm is defined by the LRM and requires multiple timing 
arcs between the same reference and data signals to overlap in order to 
correctly trigger the violation message and to create a delayed data or 
reference signal for proper functional simulation.

The reason you need overlapping regions is because, with negative timing checks, 
you are trying to solve more than one problem:

1) To generate the violations 

The solution to this is trivial if there are no other constraints

2) To generate a delayed signal

Since the library cells are usually modeled as UDPs, to get useable simulation 
results you need to delay the signal input to the UDP. This is what the NTC 
algorithm does. 

The way the NTC algorithm works is: it delays either the data or the clock so 
that the timecheck event for setup and the timestamp event for hold happens in 
the middle of the violation region. In other words shift the clock signal so 
that it is in the middle of the violation region for the times of interest to 
the model. Since the model has two separate non-overlapping constraints on 
posedge and negedge of data, there is no way to shift it so that it meets both 
the constraints.

The SDF is correct for static timing analysis, but negative limits and 
non-overlapping regions pose problems for event simulation because histories 
of all events are not saved.
