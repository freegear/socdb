library verilog;
use verilog.vl_types.all;
entity nfssptxnofifo is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        ms              : in     vl_logic;
        dsspclk         : in     vl_logic_vector(3 downto 0);
        spitxdatwr      : in     vl_logic;
        txfrdptrinc     : in     vl_logic;
        txrxbsy         : in     vl_logic;
        pwdatain        : in     vl_logic_vector(15 downto 0);
        txdataavlbl     : out    vl_logic;
        spitxdatrd      : out    vl_logic;
        bsy             : out    vl_logic;
        spitxoutdat     : out    vl_logic_vector(15 downto 0)
    );
end nfssptxnofifo;
