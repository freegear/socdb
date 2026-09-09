library verilog;
use verilog.vl_types.all;
entity dmacfifo is
    generic(
        fifo_index_width: integer := 3
    );
    port(
        aclk            : in     vl_logic;
        fiforeset       : in     vl_logic;
        numbyte         : in     vl_logic_vector;
        srcwidth        : in     vl_logic_vector(1 downto 0);
        datain          : in     vl_logic_vector(31 downto 0);
        writeen         : in     vl_logic;
        srcaddr         : in     vl_logic_vector(1 downto 0);
        dstwidth        : in     vl_logic_vector(1 downto 0);
        dataout         : out    vl_logic_vector(31 downto 0);
        datamask        : out    vl_logic_vector(3 downto 0);
        readen          : in     vl_logic;
        dstaddr         : in     vl_logic_vector(1 downto 0)
    );
end dmacfifo;
