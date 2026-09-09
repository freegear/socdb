module busholder(Y);
inout Y;
    buf #0.1 (n1, Y);
    buf (pull1, pull0) #0 (Y, n1);
endmodule
