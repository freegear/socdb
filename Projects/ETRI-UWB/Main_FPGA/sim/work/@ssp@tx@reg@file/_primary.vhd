library verilog;
use verilog.vl_types.all;
entity SspTxRegFile is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PWDATAIn        : in     vl_logic_vector(15 downto 0);
        RegFileWrEn     : in     vl_logic;
        WrPtr           : in     vl_logic_vector(2 downto 0);
        RdPtr           : in     vl_logic_vector(2 downto 0);
        TxFRdData       : out    vl_logic_vector(15 downto 0)
    );
end SspTxRegFile;
