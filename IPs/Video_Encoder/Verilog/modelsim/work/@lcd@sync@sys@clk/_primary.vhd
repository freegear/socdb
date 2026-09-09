library verilog;
use verilog.vl_types.all;
entity LcdSyncSysClk is
    port(
        SysClk          : in     vl_logic;
        nRST            : in     vl_logic;
        SWReset         : in     vl_logic;
        FrameStart      : in     vl_logic;
        FrameRst        : in     vl_logic;
        PlaneMixerEn    : in     vl_logic;
        EvenField       : in     vl_logic;
        FrStSyncSysClk  : out    vl_logic;
        FrRstSyncSysClk : out    vl_logic;
        PlaneMixerEnSyncSysClk: out    vl_logic;
        EvenFieldSyncSysClk: out    vl_logic
    );
end LcdSyncSysClk;
