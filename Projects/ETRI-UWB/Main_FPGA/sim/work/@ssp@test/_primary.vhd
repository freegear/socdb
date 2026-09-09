library verilog;
use verilog.vl_types.all;
entity SspTest is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        LBM             : in     vl_logic;
        SSPRXD          : in     vl_logic;
        TXMIS           : in     vl_logic;
        RXMIS           : in     vl_logic;
        RORINTR         : in     vl_logic;
        RTINTR          : in     vl_logic;
        INTR            : in     vl_logic;
        FSSOUT          : in     vl_logic;
        CLKOUT          : in     vl_logic;
        TXD             : in     vl_logic;
        nCTLOE          : in     vl_logic;
        nOE             : in     vl_logic;
        IntSSPRXD       : out    vl_logic;
        IntSSPINTR      : out    vl_logic;
        IntSSPTXINTR    : out    vl_logic;
        IntSSPRXINTR    : out    vl_logic;
        IntSSPRTINTR    : out    vl_logic;
        IntSSPRORINTR   : out    vl_logic;
        IntSSPFSSOUT    : out    vl_logic;
        IntSSPCLKOUT    : out    vl_logic;
        IntSSPTXD       : out    vl_logic;
        IntnSSPCTLOE    : out    vl_logic;
        IntnSSPOE       : out    vl_logic
    );
end SspTest;
