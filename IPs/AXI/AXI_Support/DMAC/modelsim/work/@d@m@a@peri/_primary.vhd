library verilog;
use verilog.vl_types.all;
entity dmaperi is
    generic(
        stream_sink     : integer := 1;
        data_size       : integer := 2;
        last_data       : integer := 1023;
        clk_div         : integer := 128;
        fifo_index_width: integer := 5
    );
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        paddr           : in     vl_logic;
        pwrite          : in     vl_logic;
        psel            : in     vl_logic;
        penable         : in     vl_logic;
        prdata          : out    vl_logic_vector(31 downto 0);
        pwdata          : in     vl_logic_vector(31 downto 0);
        dma_req         : out    vl_logic;
        dma_ack         : in     vl_logic
    );
end dmaperi;
