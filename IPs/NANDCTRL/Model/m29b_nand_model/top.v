`timescale 1ns / 1ns

module top (Io, Cle, Ale, Ce_n, We_n, Re_n, Wp_n, Pre, Rb_n);

`include "parameters.v"

    // Ports Declaration
    inout  [data_bits - 1 : 0] Io;
    input                      Cle;
    input                      Ale;
    input                      Ce_n;
    input                      Ce_n2;
    input                      We_n;
    input                      Re_n;
    input                      Wp_n;
    input                      Pre;
    output                     Rb_n;
    output                     Rb_n2;

    wire [data_bits - 1 : 0] IO = Io;

    // Instantiate Device
    nand_model_0 uut_0  (IO, Cle, Ale, Ce_n,  We_n, Re_n, Wp_n, Pre, Rb_n );
    nand_model_1 uut_1  (IO, Cle, Ale, Ce_n2, We_n, Re_n, Wp_n, Pre, Rb_n2);
endmodule
