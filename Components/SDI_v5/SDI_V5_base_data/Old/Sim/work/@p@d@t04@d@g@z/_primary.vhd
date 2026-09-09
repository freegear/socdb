library verilog;
use verilog.vl_types.all;
entity PDT04DGZ is
    port(
        I               : in     vl_logic;
        OEN             : in     vl_logic;
        PAD             : out    vl_logic
    );
end PDT04DGZ;
