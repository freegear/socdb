library verilog;
use verilog.vl_types.all;
entity DmacFifo is
    generic(
        FIFO_INDEX_WIDTH: integer := 3
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        FifoReset       : in     vl_logic;
        NumByte         : in     vl_logic_vector;
        SrcWidth        : in     vl_logic_vector(1 downto 0);
        DataIn          : in     vl_logic_vector(31 downto 0);
        WriteEn         : in     vl_logic;
        SrcAddr         : in     vl_logic_vector(1 downto 0);
        DstWidth        : in     vl_logic_vector(1 downto 0);
        DataOut         : out    vl_logic_vector(31 downto 0);
        DataMask        : out    vl_logic_vector(3 downto 0);
        ReadEn          : in     vl_logic;
        DstAddr         : in     vl_logic_vector(1 downto 0)
    );
end DmacFifo;
