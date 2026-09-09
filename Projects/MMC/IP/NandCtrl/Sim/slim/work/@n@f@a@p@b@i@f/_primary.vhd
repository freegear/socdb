library verilog;
use verilog.vl_types.all;
entity NFAPBIF is
    generic(
        QSIZE           : integer := 8
    );
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        EXT_SFR_ADDR    : in     vl_logic_vector(3 downto 0);
        EXT_SFR_WR      : in     vl_logic;
        EXT_SFR_DOUT    : in     vl_logic_vector(7 downto 0);
        EXT_SFR_DIN     : out    vl_logic_vector(7 downto 0);
        CS              : in     vl_logic;
        WDATA           : in     vl_logic_vector(7 downto 0);
        RDATA           : out    vl_logic_vector(7 downto 0);
        We              : in     vl_logic;
        Oe              : in     vl_logic;
        IntReqOut       : out    vl_logic;
        NFCtrlBusyIn    : in     vl_logic;
        NFStatValidIn   : in     vl_logic;
        NFStatusIn      : in     vl_logic_vector(15 downto 0);
        WrEndIn         : in     vl_logic;
        RdEndIn         : in     vl_logic;
        RdFIFOReadyIn   : in     vl_logic;
        WrFIFOReadyIn   : in     vl_logic;
        FiltRnB3In      : in     vl_logic;
        FiltRnB2In      : in     vl_logic;
        FiltRnB1In      : in     vl_logic;
        FiltRnB0In      : in     vl_logic;
        FIFOFlushIn     : in     vl_logic;
        FIFORdDataOut   : out    vl_logic_vector(15 downto 0);
        FIFORdDataEnIn  : in     vl_logic;
        FIFOWrDataIn    : in     vl_logic_vector(15 downto 0);
        FIFOWrDataEnIn  : in     vl_logic;
        BeforeFullOut   : out    vl_logic;
        FIFORdReadyOut  : out    vl_logic;
        FIFOFullOut     : out    vl_logic;
        FIFOHalfFullOut : out    vl_logic;
        FIFOEmpty1Out   : out    vl_logic;
        FIFOEmpty0Out   : out    vl_logic;
        WrRdyOut        : out    vl_logic;
        RdRdyOut        : out    vl_logic;
        NFOpRdEnIn      : in     vl_logic;
        NFOpOut         : out    vl_logic_vector(31 downto 0);
        QLevelOut       : out    vl_logic_vector(3 downto 0);
        ControlOut0     : out    vl_logic_vector(7 downto 0);
        ControlOut1     : out    vl_logic_vector(7 downto 0);
        ConfigOut0      : out    vl_logic_vector(7 downto 0);
        ConfigOut1      : out    vl_logic_vector(7 downto 0);
        ConfigOut2      : out    vl_logic_vector(7 downto 0);
        TransSize       : in     vl_logic
    );
end NFAPBIF;
