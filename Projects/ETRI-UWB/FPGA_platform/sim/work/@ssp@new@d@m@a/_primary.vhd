library verilog;
use verilog.vl_types.all;
entity SspNewDMA is
    port(
        TxFFillLevel    : in     vl_logic_vector(3 downto 0);
        RxFFillLevel    : in     vl_logic_vector(3 downto 0);
        TxDMALevel      : in     vl_logic_vector(3 downto 0);
        RxDMALevel      : in     vl_logic_vector(3 downto 0);
        TxDMAReqEn      : in     vl_logic;
        RxDMAReqEn      : in     vl_logic;
        TxDMAReq        : out    vl_logic;
        RxDMAReq        : out    vl_logic
    );
end SspNewDMA;
