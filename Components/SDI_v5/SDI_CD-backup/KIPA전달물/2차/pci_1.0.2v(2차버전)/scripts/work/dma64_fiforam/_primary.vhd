library verilog;
use verilog.vl_types.all;
entity dma64_fiforam is
    port(
        wclk            : in     vl_logic;
        we              : in     vl_logic;
        waddr           : in     vl_logic_vector(3 downto 0);
        raddr           : in     vl_logic_vector(3 downto 0);
        din             : in     vl_logic_vector(31 downto 0);
        dout            : out    vl_logic_vector(31 downto 0)
    );
end dma64_fiforam;
