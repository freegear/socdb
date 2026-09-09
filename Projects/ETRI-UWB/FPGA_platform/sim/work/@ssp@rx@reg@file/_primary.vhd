library verilog;
use verilog.vl_types.all;
entity SspRxRegFile is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        MS              : in     vl_logic;
        RegFileWrEn     : in     vl_logic;
        WrPtr           : in     vl_logic_vector(2 downto 0);
        RdPtr           : in     vl_logic_vector(2 downto 0);
        SRxFWrData      : in     vl_logic_vector(15 downto 0);
        MRxFWrData      : in     vl_logic_vector(15 downto 0);
        RxFRdData       : out    vl_logic_vector(15 downto 0)
    );
end SspRxRegFile;
