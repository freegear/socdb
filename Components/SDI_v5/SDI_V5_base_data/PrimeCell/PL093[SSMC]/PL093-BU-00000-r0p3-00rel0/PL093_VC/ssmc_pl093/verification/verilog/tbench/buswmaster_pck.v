// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version  and  Release Control Information:
//
// File Name              : buswmaster_pck.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// ---------------------------------------------------------------------
// Purpose :
//           Function/procedures package for the master buswatcher
//
// --=================================================================--

// ---------------------------------------------------------------------
//
//                             buswmaster_pck
//                             ==============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
// o CheckForX :- This procedure "screams" error, if there is X on its
//   argument signal.
// o NoOfBeatsIn :- This function returns the no. of beats (as integer
//   value) by taking HBURST as argument.
// o NoOfBytesIn :- This function gives the no. of bytes (as integer
//   value) by taking HSIZE as argument.
// o CheckAddress :- This is an "involved" procedure, which checks
//   whether the address is "proper" or not, by looking at HADDR,
//   PrevAddr  and  control signals. This uses two more functions
//   - FlashWrapErr  and  ChkAddrNormal.
// o FlashAlignErr, FlashHoldErr  and  FlashValidErr :- These functions 
//   display the corresponding error messages. These take HADDR  and
//   one string as their input argument. All functions assert a
//   severity of error.
// 
// ---------------------------------------------------------------------

// --============================ BODY ===============================--
 
// ---------------------------------------------------------------------
// This function returns the no. of beats (as integer value) by taking
// HBURST as argument.
// ---------------------------------------------------------------------
function integer  NoOfBeatsIn;
input [2:0] Sig; 
begin
  case (Sig) 
    3'b000:
      NoOfBeatsIn = 1; 
    3'b001:
      NoOfBeatsIn = 1; 
    3'b010:
      NoOfBeatsIn = 4; 
    3'b011:
      NoOfBeatsIn = 4; 
    3'b100:
      NoOfBeatsIn = 8; 
    3'b101:
      NoOfBeatsIn = 8; 
    3'b110:
      NoOfBeatsIn = 16; 
    3'b111:
      NoOfBeatsIn = 16; 
    default:
      NoOfBeatsIn = 1; 
  endcase
end
endfunction

// ---------------------------------------------------------------------
// This function gives the no. of bytes (as integer value) by taking
// HSIZE as argument.
// ---------------------------------------------------------------------
function integer NoOfBytesIn;
input [2:0] Sig; 
begin
  case (Sig)
    3'b000:
      NoOfBytesIn = 1;
    3'b001:
      NoOfBytesIn = 2;
    3'b010:
      NoOfBytesIn = 4;
    3'b011:
      NoOfBytesIn = 8;
    3'b100:
      NoOfBytesIn = 16;
    3'b101:
      NoOfBytesIn = 32;
    3'b110:
      NoOfBytesIn = 64;
    3'b111:
      NoOfBytesIn = 128;
    default:
      NoOfBytesIn = 1;
  endcase
end
endfunction

// ---------------------------------------------------------------------
// Flashes error message if there is a wrap-error
// ---------------------------------------------------------------------
task FlashWrapErr;
input [31:0] HADDR;
  $display("BWERRHA : Address wrapping is not correct at HADDR : %h. ",
           HADDR, "TIME : %t", $time);
endtask

// ---------------------------------------------------------------------
// This procedure "screams" error, if there is X on its argument signal.
// ---------------------------------------------------------------------
task CheckForX;
input [(8 * 10 - 1):0] SigName;
// assumed that any signal name does not exceed 10 characters

input [64:0]           Sig;             
// assumed that no signal is wider than 64, at the present
// implementation

begin
  if ((Sig == 64'b0) === 1'bX)
    $display("%0sU : %0s is unknown at TIME : %t",
             SigName, SigName, $time);
end
endtask

// ---------------------------------------------------------------------
// task for checking whether HADDR has been properly incremented.
// ---------------------------------------------------------------------
task ChkAddrNormal;
input [31:0] HADDR;
input [2:0]  HSIZE;  
input [31:0] PrevAddr;
begin
  if(~(HADDR == (PrevAddr + NoOfBytesIn(HSIZE))))
    $display ("BWERRHA : HADDR not incremented properly according to HSIZE",
              " at HADDR : %h TIME : %t", HADDR, $time);
end
endtask

// ---------------------------------------------------------------------
// This is an "involved" procedure, which checks whether the address is 
// "proper" or not, by looking at HADDR, PrevAddr  and  control signals.
// This uses two more functions - FlashWrapErr  and  ChkAddrNormal.
// ---------------------------------------------------------------------
task CheckAddress; 
input [2:0]  HBURST; 
input [2:0]  HSIZE; 
input [31:0] HADDR;
input [31:0] PrevAddr;
begin
  if (HBURST == 3'b010)
  begin
    case (HSIZE)
      3'b000:
        if ((PrevAddr[1:0] == 2'b11)) 
        begin
          if ((HADDR[10:2] != PrevAddr[10:2])|| (HADDR[1:0] != 2'b00)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b001:
        if ((PrevAddr[2:1] == 2'b11)) 
        begin
          if ((HADDR[10:3] != PrevAddr[10:3]) || (HADDR[2:1] != 2'b00)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b010:
        if ((PrevAddr[3:2] == 2'b11)) 
        begin
          if ((HADDR[10:4] != PrevAddr[10:4]) || (HADDR[3:2] != 2'b00))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b011:
        if ((PrevAddr[4:3] == 2'b11)) 
        begin
          if ((HADDR[10:5] != PrevAddr[10:5]) || (HADDR[4:3] != 2'b00)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b100:
        if ((PrevAddr[5:4] == 2'b11)) 
        begin
          if ((HADDR[10:6] != PrevAddr[10:6]) || (HADDR[5:4] != 2'b00)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b101:
        if ((PrevAddr[6:5] == 2'b11)) 
        begin
          if ((HADDR[10:7] != PrevAddr[10:7]) || (HADDR[6:5] != 2'b00)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b110:
        if ((PrevAddr[7:6] == 2'b11)) 
        begin
          if ((HADDR[10:8] != PrevAddr[10:8]) || (HADDR[7:6] != 2'b00)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b111:
        if ((PrevAddr[8:7] == 2'b11)) 
        begin
          if ((HADDR[10:9] != PrevAddr[10:9]) || (HADDR[8:7] != 2'b00)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
     default:;
    endcase
  end
  else if (HBURST == 3'b100)
  begin
    case (HSIZE)
      3'b000:
        if ((PrevAddr[2:0] == 3'b111)) 
        begin
          if ((PrevAddr[10:3] != HADDR[10:3]) || (HADDR[2:0] != 3'b000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b001:
        if ((PrevAddr[3:1] == 3'b111)) 
        begin
          if ((PrevAddr[10:4] != HADDR[10:4]) || (HADDR[3:1] != 3'b000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b010:
        if ((PrevAddr[4:2] == 3'b111)) 
        begin
          if ((PrevAddr[10:5] != HADDR[10:5]) || (HADDR[4:2] != 3'b000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b011:
        if ((PrevAddr[5:3] == 3'b111)) 
        begin
          if ((PrevAddr[10:6] != HADDR[10:6]) || (HADDR[5:3] != 3'b000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b100:
        if ((PrevAddr[6:4] == 3'b111)) 
        begin
          if ((PrevAddr[10:7] != HADDR[10:7]) || (HADDR[6:4] != 3'b000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b101:
        if ((PrevAddr[7:5] == 3'b111))
        begin
          if ((PrevAddr[10:8] != HADDR[10:8]) || (HADDR[7:5] != 3'b000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b110:
        if ((PrevAddr[8:6] == 3'b111)) 
        begin
          if ((PrevAddr[10:9] != HADDR[10:9]) || (HADDR[8:6] != 3'b000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b111:
        if (PrevAddr[9:7] == 3'b111) 
        begin
          if ((PrevAddr[10] != HADDR[10]) || (HADDR[9:7] != 3'b000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      default:;
    endcase
  end
  else if (HBURST == 3'b110) 
  begin
    case (HSIZE)
      3'b000:
        if ((PrevAddr[3:0] == 4'b1111)) 
        begin
          if ((PrevAddr[10:4] != HADDR[10:4]) ||
              (HADDR[3:0] != 4'b0000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b001:
        if ((PrevAddr[4:1] == 4'b1111)) 
        begin
          if ((PrevAddr[10:5] != HADDR[10:5]) ||
              (HADDR[4:1] != 4'b0000)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b010:
        if ((PrevAddr[5:2] == 4'b1111)) 
        begin
          if ((PrevAddr[10:6] != HADDR[10:6]) ||
              (HADDR[5:2] != 4'b0000)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b011:
        if ((PrevAddr[6:3] == 4'b1111)) 
        begin
          if ((PrevAddr[10:7] != HADDR[10:7]) ||
              (HADDR[6:3] != 4'b0000)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b100:
        if ((PrevAddr[7:4] == 4'b1111)) 
        begin
          if ((PrevAddr[10:8] != HADDR[10:8]) ||
              (HADDR[7:4] != 4'b0000)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b101:
        if ((PrevAddr[8:5] == 4'b1111)) 
        begin
          if ((PrevAddr[10:9] != HADDR[10:9]) ||
              (HADDR[8:5] != 4'b0000)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b110:
        if ((PrevAddr[9:6] == 4'b1111)) 
        begin
          if ((PrevAddr[10] != HADDR[10]) || (HADDR[9:6] != 4'b0000)) 
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      3'b111:
        // illegal stage, however the address-checking is done
        if ((PrevAddr[10:7] == 4'b1111)) 
        begin
          if ((HADDR[10:7] != 4'b0000))
            FlashWrapErr(HADDR);
        end
        else
          ChkAddrNormal(HADDR, HSIZE, PrevAddr);
      default:;
    endcase
  end
  else
    ChkAddrNormal(HADDR, HSIZE, PrevAddr);
end
endtask

// ---------------------------------------------------------------------
// Flashes if there is an address misalignment error.
// ---------------------------------------------------------------------
task FlashAlignErr;
input [31:0] HADDR; 
input [2:0]  HSIZE;
begin
  $display("BWERRHAM : Address is misaligned for HSIZE %h at HADDR :",
           HSIZE, " %h at TIME : %t", HADDR, $time);
end
endtask

//endmodule

// --============================= End ===============================--
