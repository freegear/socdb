library verilog;
use verilog.vl_types.all;
entity SspTxLJustify is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        FRFPCLK         : in     vl_logic_vector(1 downto 0);
        DSSPCLK         : in     vl_logic_vector(3 downto 0);
        TxFRdData       : in     vl_logic_vector(15 downto 0);
        MS              : in     vl_logic;
        TxFRdDataIn     : out    vl_logic_vector(15 downto 0)
    );
end SspTxLJustify;
