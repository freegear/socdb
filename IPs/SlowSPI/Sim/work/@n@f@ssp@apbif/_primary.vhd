library verilog;
use verilog.vl_types.all;
entity nfsspapbif is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        psel            : in     vl_logic;
        pwrite          : in     vl_logic;
        penable         : in     vl_logic;
        paddr           : in     vl_logic_vector(4 downto 2);
        pwdata          : in     vl_logic_vector(15 downto 0);
        bsy             : in     vl_logic;
        txrispulse      : in     vl_logic;
        rxrispulse      : in     vl_logic;
        rorris          : in     vl_logic;
        txmis           : in     vl_logic;
        rxmis           : in     vl_logic;
        rxrisclr        : in     vl_logic;
        roric           : out    vl_logic;
        rxfrddata       : in     vl_logic_vector(15 downto 0);
        prdata          : out    vl_logic_vector(31 downto 0);
        spicon          : out    vl_logic_vector(3 downto 0);
        spipre          : out    vl_logic_vector(15 downto 0);
        spiintdma       : out    vl_logic_vector(1 downto 0);
        spitxdat        : out    vl_logic_vector(15 downto 0);
        spihidden       : out    vl_logic_vector(7 downto 0);
        txris           : out    vl_logic;
        rxris           : out    vl_logic;
        spitxdatwr      : out    vl_logic;
        rxfrdptrinc     : out    vl_logic
    );
end nfsspapbif;
