library verilog;
use verilog.vl_types.all;
entity SspDataStp is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        IncRxTimeOut    : in     vl_logic;
        MRxRT           : in     vl_logic;
        SRxRT           : in     vl_logic;
        RNESync         : in     vl_logic;
        RTICSync        : in     vl_logic;
        DataStp         : out    vl_logic
    );
end SspDataStp;
