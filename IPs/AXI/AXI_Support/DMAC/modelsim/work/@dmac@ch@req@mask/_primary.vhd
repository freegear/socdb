library verilog;
use verilog.vl_types.all;
entity dmacchreqmask is
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        seterrmsksrc    : in     vl_logic;
        setsrce2lmsk    : in     vl_logic;
        setsrcaxsonmsk  : in     vl_logic;
        unsetsrcaxsonmsk: in     vl_logic;
        errcycmasksrc   : in     vl_logic;
        seterrmskdst    : in     vl_logic;
        setlliloadmsk   : in     vl_logic;
        setdstaxsonmsk  : in     vl_logic;
        unsetdstaxsonmsk: in     vl_logic;
        errcycmaskdst   : in     vl_logic;
        unseterrmsk     : in     vl_logic;
        channelen       : in     vl_logic;
        trfsizesrc      : in     vl_logic_vector(11 downto 0);
        flowcntl2msb    : in     vl_logic_vector(2 downto 1);
        sourceen        : in     vl_logic;
        desten          : in     vl_logic;
        disabledsrc     : in     vl_logic;
        trfsizedst      : in     vl_logic_vector(13 downto 0);
        disableddst     : in     vl_logic;
        unsetsrce2lmsk  : in     vl_logic;
        unsetlliloadmsk : in     vl_logic;
        halt            : in     vl_logic;
        actemptylevel   : in     vl_logic_vector(4 downto 0);
        actfilllevel    : in     vl_logic_vector(4 downto 0);
        chdstbreq       : in     vl_logic;
        chdstlbreq      : in     vl_logic;
        chdstsreq       : in     vl_logic;
        chdstlsreq      : in     vl_logic;
        ldsrcindstflow  : in     vl_logic;
        sourcemask      : out    vl_logic;
        destmask        : out    vl_logic
    );
end dmacchreqmask;
