library verilog;
use verilog.vl_types.all;
entity Sync_RST2 is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        Flag_Neg_Det_1d : in     vl_logic;
        STC_Pulse       : in     vl_logic;
        Reg0            : out    vl_logic
    );
end Sync_RST2;
