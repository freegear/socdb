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
#- Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
#-
#- ---------------------------------------------------------------------
#- Purpose : This awk script converts a bif file for a VHDL
#-           simulation environment into a sim file format for the
#-           AHB_Slave Verilog test bench simulation.
#-
#- Usage:  awk -f bif2sim.awk
#-
#- Restriction on Use:  This script does not deal correctly with tag
#-                      fields that contain white spaces.
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

/^SW/ { printf "SW( 64'h%s, 32'h%s, \"%s\", \"%s\", \"%s\", \"%s\", 32'h%s, 32'h%s, \"%s\", 32'h%s, 32'h%s, 32'h%s, \"%s\", \"%s\", %s);\n", $2, $3, $4, $5, $6, $7, $8,$9, $10, $11, $12, $13, $14, $15, $16 }
 
/^SR/ { printf "SR(64'h%s,64'h%s, 32'h%s, \"%s\", \"%s\", \"%s\", \"%s\", 32'h%s, 32'h%s, 1'b%s, 32'h%s, 32'h%s, 32'h%s, \"%s\", 4'h%s, %s);\n", $2, $3, $4, $5, $6, $7, $8,$9, $10, $11, $12, $13, $14, $15, $16, $17}

/^PO/ { printf "PO(64'h%s,64'h%s, 32'h%s, \"%s\", \"%s\", \"%s\", \"%s\", 32'h%s, 32'h%s, 1'b%s, 32'h%s, 32'h%s, 32'h%s, \"%s\", 1'b%s, 32'h%s, %s);\n", $2, $3, $4, $5, $6, $7, $8,$9, $10, $11, $12, $13, $14, $15, $16, $17, $18}

/^SP/ {printf "SP( 16'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s, 32'h%s);\n", $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19}
/^EN/ {printf "EN( \"%s\");\n", $2}

# Arbitration Commands

/^RQL/ { printf"RQL( 16'h%s, \"%s\", 4'h%s, \"%s\");\n", $2, $3, $4, $5}
/^RNL/ { printf"RNL( 16'h%s, \"%s\", 4'h%s, \"%s\");\n", $2, $3, $4, $5}

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

#- --============================ End ================================--
