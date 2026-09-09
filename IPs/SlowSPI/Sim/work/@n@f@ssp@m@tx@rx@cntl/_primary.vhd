library verilog;
use verilog.vl_types.all;
entity nfsspmtxrxcntl is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        dss             : in     vl_logic_vector(3 downto 0);
        scr             : in     vl_logic_vector(7 downto 0);
        spo             : in     vl_logic;
        sph             : in     vl_logic;
        ssesync         : in     vl_logic;
        sspclkdiv       : in     vl_logic;
        txdataavlblsync : in     vl_logic;
        txfrddatain     : in     vl_logic_vector(15 downto 0);
        intssprxd       : in     vl_logic;
        mssync          : in     vl_logic;
        nextnsoe        : in     vl_logic;
        nextstxd        : in     vl_logic;
        nextsrxfwr      : in     vl_logic;
        nxtstxfrdptrinc : in     vl_logic;
        nextstxrxbsy    : in     vl_logic;
        rnesync         : in     vl_logic;
        clkout          : out    vl_logic;
        fssout          : out    vl_logic;
        txd             : out    vl_logic;
        nctloe          : out    vl_logic;
        noe             : out    vl_logic;
        txfrdptrinc     : out    vl_logic;
        rxfwr           : out    vl_logic;
        mrxfwrdata      : out    vl_logic_vector(15 downto 0);
        txrxbsy         : out    vl_logic;
        mrxrt           : out    vl_logic
    );
end nfsspmtxrxcntl;
