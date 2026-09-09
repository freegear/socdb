library verilog;
use verilog.vl_types.all;
entity nfsspdatastp is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        incrxtimeout    : in     vl_logic;
        mrxrt           : in     vl_logic;
        srxrt           : in     vl_logic;
        rnesync         : in     vl_logic;
        rticsync        : in     vl_logic;
        datastp         : out    vl_logic
    );
end nfsspdatastp;
