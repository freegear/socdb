// ===================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : COS_ROM_FPGA.v
// File Revision       : 0.1
// -----------------------------------------------------------------------
// Purpose            : This module is cos rom table in 
//                      video Encoder
// =======================================================================

module COS_ROM_FPGA (
   Q,
   CLK,
   CEN,
   A
);
    output [8:0] Q;
    input CLK;
    input CEN;
    input [7:0] A;

    reg [8:0] Q;

always @(posedge CLK) begin
    if(!CEN) begin
    case (A) //cos table
        8'd0: Q = 9'h000;
        8'd1: Q = 9'h000;
        8'd2: Q = 9'h000;
        8'd3: Q = 9'h000;
        8'd4: Q = 9'h000;
        8'd5: Q = 9'h000;
        8'd6: Q = 9'h000;
        8'd7: Q = 9'h000;
        8'd8: Q = 9'h000;
        8'd9: Q = 9'h000;
        8'd10: Q = 9'h000;
        8'd11: Q = 9'h000;
        8'd12: Q = 9'h000;
        8'd13: Q = 9'h000;
        8'd14: Q = 9'h1ff;
        8'd15: Q = 9'h1ff;
        8'd16: Q = 9'h1ff;
        8'd17: Q = 9'h1ff;
        8'd18: Q = 9'h1ff;
        8'd19: Q = 9'h1ff;
        8'd20: Q = 9'h1ff;
        8'd21: Q = 9'h1ff;
        8'd22: Q = 9'h1ff;
        8'd23: Q = 9'h1ff;
        8'd24: Q = 9'h1ff;
        8'd25: Q = 9'h1fe;
        8'd26: Q = 9'h1fe;
        8'd27: Q = 9'h1fe;
        8'd28: Q = 9'h1fe;
        8'd29: Q = 9'h1fe;
        8'd30: Q = 9'h1fe;
        8'd31: Q = 9'h1fe;
        8'd32: Q = 9'h1fd;
        8'd33: Q = 9'h1fd;
        8'd34: Q = 9'h1fd;
        8'd35: Q = 9'h1fd;
        8'd36: Q = 9'h1fd;
        8'd37: Q = 9'h1fd;
        8'd38: Q = 9'h1fc;
        8'd39: Q = 9'h1fc;
        8'd40: Q = 9'h1fc;
        8'd41: Q = 9'h1fc;
        8'd42: Q = 9'h1fc;
        8'd43: Q = 9'h1fb;
        8'd44: Q = 9'h1fb;
        8'd45: Q = 9'h1fb;
        8'd46: Q = 9'h1fb;
        8'd47: Q = 9'h1fb;
        8'd48: Q = 9'h1fa;
        8'd49: Q = 9'h1fa;
        8'd50: Q = 9'h1fa;
        8'd51: Q = 9'h1fa;
        8'd52: Q = 9'h1f9;
        8'd53: Q = 9'h1f9;
        8'd54: Q = 9'h1f9;
        8'd55: Q = 9'h1f9;
        8'd56: Q = 9'h1f8;
        8'd57: Q = 9'h1f8;
        8'd58: Q = 9'h1f8;
        8'd59: Q = 9'h1f7;
        8'd60: Q = 9'h1f7;
        8'd61: Q = 9'h1f7;
        8'd62: Q = 9'h1f7;
        8'd63: Q = 9'h1f6;
        8'd64: Q = 9'h1f6;
        8'd65: Q = 9'h1f6;
        8'd66: Q = 9'h1f5;
        8'd67: Q = 9'h1f5;
        8'd68: Q = 9'h1f5;
        8'd69: Q = 9'h1f4;
        8'd70: Q = 9'h1f4;
        8'd71: Q = 9'h1f4;
        8'd72: Q = 9'h1f3;
        8'd73: Q = 9'h1f3;
        8'd74: Q = 9'h1f3;
        8'd75: Q = 9'h1f2;
        8'd76: Q = 9'h1f2;
        8'd77: Q = 9'h1f2;
        8'd78: Q = 9'h1f1;
        8'd79: Q = 9'h1f1;
        8'd80: Q = 9'h1f0;
        8'd81: Q = 9'h1f0;
        8'd82: Q = 9'h1f0;
        8'd83: Q = 9'h1ef;
        8'd84: Q = 9'h1ef;
        8'd85: Q = 9'h1ee;
        8'd86: Q = 9'h1ee;
        8'd87: Q = 9'h1ee;
        8'd88: Q = 9'h1ed;
        8'd89: Q = 9'h1ed;
        8'd90: Q = 9'h1ec;
        8'd91: Q = 9'h1ec;
        8'd92: Q = 9'h1ec;
        8'd93: Q = 9'h1eb;
        8'd94: Q = 9'h1eb;
        8'd95: Q = 9'h1ea;
        8'd96: Q = 9'h1ea;
        8'd97: Q = 9'h1e9;
        8'd98: Q = 9'h1e9;
        8'd99: Q = 9'h1e8;
        8'd100: Q = 9'h1e8;
        8'd101: Q = 9'h1e7;
        8'd102: Q = 9'h1e7;
        8'd103: Q = 9'h1e6;
        8'd104: Q = 9'h1e6;
        8'd105: Q = 9'h1e5;
        8'd106: Q = 9'h1e5;
        8'd107: Q = 9'h1e4;
        8'd108: Q = 9'h1e4;
        8'd109: Q = 9'h1e3;
        8'd110: Q = 9'h1e3;
        8'd111: Q = 9'h1e2;
        8'd112: Q = 9'h1e2;
        8'd113: Q = 9'h1e1;
        8'd114: Q = 9'h1e1;
        8'd115: Q = 9'h1e0;
        8'd116: Q = 9'h1e0;
        8'd117: Q = 9'h1df;
        8'd118: Q = 9'h1df;
        8'd119: Q = 9'h1de;
        8'd120: Q = 9'h1dd;
        8'd121: Q = 9'h1dd;
        8'd122: Q = 9'h1dc;
        8'd123: Q = 9'h1dc;
        8'd124: Q = 9'h1db;
        8'd125: Q = 9'h1db;
        8'd126: Q = 9'h1da;
        8'd127: Q = 9'h1d9;
        8'd128: Q = 9'h1d9;
        8'd129: Q = 9'h1d8;
        8'd130: Q = 9'h1d8;
        8'd131: Q = 9'h1d7;
        8'd132: Q = 9'h1d6;
        8'd133: Q = 9'h1d6;
        8'd134: Q = 9'h1d5;
        8'd135: Q = 9'h1d4;
        8'd136: Q = 9'h1d4;
        8'd137: Q = 9'h1d3;
        8'd138: Q = 9'h1d2;
        8'd139: Q = 9'h1d2;
        8'd140: Q = 9'h1d1;
        8'd141: Q = 9'h1d1;
        8'd142: Q = 9'h1d0;
        8'd143: Q = 9'h1cf;
        8'd144: Q = 9'h1cf;
        8'd145: Q = 9'h1ce;
        8'd146: Q = 9'h1cd;
        8'd147: Q = 9'h1cc;
        8'd148: Q = 9'h1cc;
        8'd149: Q = 9'h1cb;
        8'd150: Q = 9'h1ca;
        8'd151: Q = 9'h1ca;
        8'd152: Q = 9'h1c9;
        8'd153: Q = 9'h1c8;
        8'd154: Q = 9'h1c8;
        8'd155: Q = 9'h1c7;
        8'd156: Q = 9'h1c6;
        8'd157: Q = 9'h1c5;
        8'd158: Q = 9'h1c5;
        8'd159: Q = 9'h1c4;
        8'd160: Q = 9'h1c3;
        8'd161: Q = 9'h1c2;
        8'd162: Q = 9'h1c2;
        8'd163: Q = 9'h1c1;
        8'd164: Q = 9'h1c0;
        8'd165: Q = 9'h1bf;
        8'd166: Q = 9'h1bf;
        8'd167: Q = 9'h1be;
        8'd168: Q = 9'h1bd;
        8'd169: Q = 9'h1bc;
        8'd170: Q = 9'h1bc;
        8'd171: Q = 9'h1bb;
        8'd172: Q = 9'h1ba;
        8'd173: Q = 9'h1b9;
        8'd174: Q = 9'h1b8;
        8'd175: Q = 9'h1b8;
        8'd176: Q = 9'h1b7;
        8'd177: Q = 9'h1b6;
        8'd178: Q = 9'h1b5;
        8'd179: Q = 9'h1b4;
        8'd180: Q = 9'h1b3;
        8'd181: Q = 9'h1b3;
        8'd182: Q = 9'h1b2;
        8'd183: Q = 9'h1b1;
        8'd184: Q = 9'h1b0;
        8'd185: Q = 9'h1af;
        8'd186: Q = 9'h1ae;
        8'd187: Q = 9'h1ae;
        8'd188: Q = 9'h1ad;
        8'd189: Q = 9'h1ac;
        8'd190: Q = 9'h1ab;
        8'd191: Q = 9'h1aa;
        8'd192: Q = 9'h1a9;
        8'd193: Q = 9'h1a8;
        8'd194: Q = 9'h1a8;
        8'd195: Q = 9'h1a7;
        8'd196: Q = 9'h1a6;
        8'd197: Q = 9'h1a5;
        8'd198: Q = 9'h1a4;
        8'd199: Q = 9'h1a3;
        8'd200: Q = 9'h1a2;
        8'd201: Q = 9'h1a1;
        8'd202: Q = 9'h1a0;
        8'd203: Q = 9'h19f;
        8'd204: Q = 9'h19e;
        8'd205: Q = 9'h19e;
        8'd206: Q = 9'h19d;
        8'd207: Q = 9'h19c;
        8'd208: Q = 9'h19b;
        8'd209: Q = 9'h19a;
        8'd210: Q = 9'h199;
        8'd211: Q = 9'h198;
        8'd212: Q = 9'h197;
        8'd213: Q = 9'h196;
        8'd214: Q = 9'h195;
        8'd215: Q = 9'h194;
        8'd216: Q = 9'h193;
        8'd217: Q = 9'h192;
        8'd218: Q = 9'h191;
        8'd219: Q = 9'h190;
        8'd220: Q = 9'h18f;
        8'd221: Q = 9'h18e;
        8'd222: Q = 9'h18d;
        8'd223: Q = 9'h18c;
        8'd224: Q = 9'h18b;
        8'd225: Q = 9'h18a;
        8'd226: Q = 9'h189;
        8'd227: Q = 9'h188;
        8'd228: Q = 9'h187;
        8'd229: Q = 9'h186;
        8'd230: Q = 9'h185;
        8'd231: Q = 9'h184;
        8'd232: Q = 9'h183;
        8'd233: Q = 9'h182;
        8'd234: Q = 9'h181;
        8'd235: Q = 9'h180;
        8'd236: Q = 9'h17f;
        8'd237: Q = 9'h17e;
        8'd238: Q = 9'h17d;
        8'd239: Q = 9'h17c;
        8'd240: Q = 9'h17b;
        8'd241: Q = 9'h17a;
        8'd242: Q = 9'h179;
        8'd243: Q = 9'h178;
        8'd244: Q = 9'h177;
        8'd245: Q = 9'h176;
        8'd246: Q = 9'h174;
        8'd247: Q = 9'h173;
        8'd248: Q = 9'h172;
        8'd249: Q = 9'h171;
        8'd250: Q = 9'h170;
        8'd251: Q = 9'h16f;
        8'd252: Q = 9'h16e;
        8'd253: Q = 9'h16d;
        8'd254: Q = 9'h16c;
        8'd255: Q = 9'h16b;
    endcase
    end
end

endmodule
