library verilog;
use verilog.vl_types.all;
entity dmacchlliload is
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        busavlblm1      : in     vl_logic;
        busavlblm2      : in     vl_logic;
        dataerrorm1     : in     vl_logic;
        dataerrorm2     : in     vl_logic;
        dmacen          : in     vl_logic;
        channelen       : in     vl_logic;
        channelenlow    : in     vl_logic;
        lliselforpkt    : in     vl_logic;
        llistart        : in     vl_logic;
        unsetlliloadmsk : out    vl_logic;
        unsetsrce2lmsk  : out    vl_logic;
        llierr          : out    vl_logic;
        disabledlli     : out    vl_logic;
        llilliregwr     : out    vl_logic;
        llicntlwr       : out    vl_logic;
        llidstwr        : out    vl_logic;
        llisrcwr        : out    vl_logic;
        finishedlli     : out    vl_logic;
        unsetllireq     : out    vl_logic
    );
end dmacchlliload;
