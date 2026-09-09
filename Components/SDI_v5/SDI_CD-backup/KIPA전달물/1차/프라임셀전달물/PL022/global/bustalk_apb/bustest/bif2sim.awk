#!/bin/csh -f
#- --=================================================================--
#- This confidential and proprietary software may be used only as
#- authorised by a licensing agreement from ARM Limited
#-   (C) COPYRIGHT 2000 ARM Limited
#-       ALL RIGHTS RESERVED
#- The entire notice above must be reproduced on all authorised
#- copies and copies may only be made to the extent permitted
#- by a licensing agreement from ARM Limited.
#-
#- ---------------------------------------------------------------------
#- Version and Release Control Information:
#-
#- File Name              : bif2sim.awk.rca
#- File Revision          : 1.1
#-
#- Release Information    : PrimeCell(TM)-GLOBAL-REL1v5
#-
#- ---------------------------------------------------------------------
#- Purpose : This awk script converts a bif file for a VHDL
#-           simulation environment into a sim file format for the
#-           Verilog test bench simulation.
#-           Usage:  awk -f bif2sim.awk
#-           Restriction on Use:  This script does not deal correctly 
#-           with tag fields that contain white spaces
#-
#- --=================================================================--


# Replace BIF comments beginning with characters ;- with a $display statement

/^;-/ { printf "$display(\"Time: %%t "; 
       for (i = 2; i <= NF; i = i + 1) { printf "%s ", $i};
       printf "\", $time);\n" }

# Replace BIF comments beginning with characters -- with a $display statement
# without Time.

/^--/ { printf "$display(\"--  "; 
       for (i = 2; i <= NF; i = i + 1) { printf "%s ", $i};
       printf "\");\n" }

# Reset Commands

/^RE/ {printf "RE(\"%s\", 8'h%s, 8'h%s);\n", $2, $3, $4}

# System Bus Slave Commands

/^SA/ { printf "SA( 32'h%s, 8'h%s, \"%s\", \"%s\", \"%s\", %s);\n", $2, $3, $4, $5, $6, $7} 
/^SW/ { printf "SW( 32'h%s, 32'h%s, 8'h%s, \"%s\", \"%s\", \"%s\", %s);\n", $2, $3, $4, $5, $6, $7, $8} 
/^SR/ { printf "SR( 32'h%s, 32'h%s, 32'h%s, 8'h%s, \"%s\", \"%s\", \"%s\", %s);\n", $2, $3, $4, $5, $6, $7, $8, $9} 

# Arbitration Commands

/^RQL/ { printf"RQL( 16'h%s, \"%s\", 4'h%s, \"%s\");\n", $2, $3, $4, $5}
/^RNL/ { printf"RNL( 16'h%s, \"%s\", 4'h%s, \"%s\");\n", $2, $3, $4, $5}

# Peripheral Bus Commands

/^PNW/ || /^NW/ { printf "NW(32'h%s, 32'h%s, ", $2, $3;
       for (i = 4; i <= NF; i = i + 1) { printf "%s ", $i};
       printf ");\n" }
/^PSW/ || /^LW/ { printf "LW(32'h%s, 32'h%s, ", $2, $3;
       for (i = 4; i <= NF; i = i + 1) { printf "%s ", $i};
       printf ");\n" }
/^PNR/ || /^NR/ { printf "NR(32'h%s, ", $2;
       for (i = 3; i <= NF; i = i + 1) { printf "%s ", $i};
       printf ");\n" }
/^PSR/ || /^LR/ { printf "LR(32'h%s, 32'h%s, 32'h%s, ", $2, $3, $4;
       for (i = 5; i <= NF; i = i + 1) { printf "%s ", $i};
       printf ");\n" }
/^PW/ { printf "PW(4'h%s, 32'h%s, 32'h%s, ", $2, $3, $4;
       for (i = 5; i <= NF; i = i + 1) { printf "%s ", $i};
       printf ");\n" }
/^PR/ { printf "PR(4'h%s, 32'h%s, 32'h%s, ", $2, $3, $4;
       for (i = 5; i <= NF; i = i + 1) { printf "%s ", $i};
       printf ");\n" }
/^PI/           { printf "PI(16'h%s, ", $2;
       for (i = 3; i <= NF; i = i + 1) { printf "%s ", $i};
       printf ");\n" }
/^PO/ { printf "PO(32'h%s, 32'h%s, 32'h%s, 32'h%s, ", $2, $3, $4, $5;
       for (i = 6; i <= NF; i = i + 1) { printf "%s ", $i};
       printf ");\n" }

# Virtual Register Commands

/^VW/ { printf "VW( \"%s\", 32'h%s, 32'h%s, \"%s\", 8'h%s);\n", $2, $3, $4, $5, $6}
/^VR/ { if ($5 == "\\") {
          edge = "\\\\"
        }
        else edge = "/"
        printf "VR( \"%s\", 32'h%s, 32'h%s, \"%s\", 8'h%s, ", $2, $3, $4, edge, $6;
        for (i = 7; i <= NF; i = i + 1) { printf "%s ", $i};
        printf ");\n" }

# Miscellaneous Commands

/^TE/ { printf "TE;\nTE;\n" }

# Tic Commands

/^A / { printf "A(32'h%s);\n", $2}
/^W / { printf "W(32'h%s);\n", $2}
/^R / { printf "R(32'h%s, 32'h%s);\n", $2 ,$3}
/^L / { printf "L(32'd%s);\n", $2}
/^E / { printf "E(32'h%s);\n", $2}

#- --=========================== End =================================--
