library verilog;
use verilog.vl_types.all;
entity SspIntGen is
    port(
        TXMIS           : in     vl_logic;
        RXMIS           : in     vl_logic;
        RORMIS          : in     vl_logic;
        DataStp         : in     vl_logic;
        RTIMSync        : in     vl_logic;
        RORIC           : in     vl_logic;
        RTIC            : in     vl_logic;
        RORINTR         : out    vl_logic;
        RTINTR          : out    vl_logic;
        INTR            : out    vl_logic
    );
end SspIntGen;
