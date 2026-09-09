library verilog;
use verilog.vl_types.all;
entity pci_genack64 is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        decode_phase    : in     vl_logic;
        frameni         : in     vl_logic;
        t_abort         : in     vl_logic;
        ltrdyno         : in     vl_logic;
        lstopno         : in     vl_logic;
        hit             : in     vl_logic;
        req64nid        : in     vl_logic;
        lack64no        : out    vl_logic;
        new_ack64no     : out    vl_logic
    );
end pci_genack64;
