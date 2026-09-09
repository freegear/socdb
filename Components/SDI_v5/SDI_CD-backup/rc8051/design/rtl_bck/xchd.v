module xchd(in_acc, in_ram, out_acc, out_ram);
input[7:0] in_acc, in_ram;
output[7:0] out_acc, out_ram;

assign out_acc = {in_acc[7:4], in_ram[3:0]};
assign out_ram = {in_ram[7:4], in_acc[3:0]};

endmodule
