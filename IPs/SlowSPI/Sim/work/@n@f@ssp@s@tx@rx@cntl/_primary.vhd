library verilog;
use verilog.vl_types.all;
entity nfsspstxrxcntl is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        txd             : in     vl_logic;
        noe             : in     vl_logic;
        dss             : in     vl_logic_vector(3 downto 0);
        scr             : in     vl_logic_vector(7 downto 0);
        spo             : in     vl_logic;
        sph             : in     vl_logic;
        sspclkdiv       : in     vl_logic;
        clkinsync       : in     vl_logic;
        fssinsync       : in     vl_logic;
        ssesync         : in     vl_logic;
        mssync          : in     vl_logic;
        sodsync         : in     vl_logic;
        txfrddatain     : in     vl_logic_vector(15 downto 0);
        txfrdptrinc     : in     vl_logic;
        rxfwr           : in     vl_logic;
        txrxbsy         : in     vl_logic;
        intssprxd       : in     vl_logic;
        nxtstxfrdptrinc : out    vl_logic;
        nextstxrxbsy    : out    vl_logic;
        nextsrxfwr      : out    vl_logic;
        nextnsoe        : out    vl_logic;
        nextstxd        : out    vl_logic;
        srxfwrdata      : out    vl_logic_vector(15 downto 0);
        srxrt           : out    vl_logic
    );
end nfsspstxrxcntl;
