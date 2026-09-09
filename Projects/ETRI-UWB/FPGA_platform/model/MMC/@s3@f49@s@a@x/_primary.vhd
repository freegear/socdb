library verilog;
use verilog.vl_types.all;
entity s3f49sax is
    port(
        mclk            : in     vl_logic;
        mcmd            : inout  vl_logic;
        mdat7           : inout  vl_logic;
        mdat6           : inout  vl_logic;
        mdat5           : inout  vl_logic;
        mdat4           : inout  vl_logic;
        mdat3           : inout  vl_logic;
        mdat2           : inout  vl_logic;
        mdat1           : inout  vl_logic;
        mdat0           : inout  vl_logic
    );
end s3f49sax;
