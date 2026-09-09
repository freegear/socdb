library verilog;
use verilog.vl_types.all;
entity dmacregfile2ch is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        penable         : in     vl_logic;
        psel            : in     vl_logic;
        pwrite          : in     vl_logic;
        paddr           : in     vl_logic_vector(5 downto 2);
        pwdata          : in     vl_logic_vector(31 downto 0);
        prdata          : out    vl_logic_vector(31 downto 0);
        active          : in     vl_logic_vector(1 downto 0);
        enabled         : out    vl_logic_vector(1 downto 0);
        memory2memory   : out    vl_logic_vector(1 downto 0);
        control         : out    vl_logic_vector(31 downto 0);
        srcaddr         : out    vl_logic_vector(31 downto 0);
        destaddr        : out    vl_logic_vector(31 downto 0);
        descriptor      : out    vl_logic_vector(31 downto 0);
        status          : out    vl_logic_vector(31 downto 0);
        controlwe       : in     vl_logic;
        srcaddrwe       : in     vl_logic;
        destaddrwe      : in     vl_logic;
        descriptorwe    : in     vl_logic;
        controlwdata    : in     vl_logic_vector(31 downto 0);
        srcaddrwdata    : in     vl_logic_vector(31 downto 0);
        destaddrwdata   : in     vl_logic_vector(31 downto 0);
        descriptorwdata : in     vl_logic_vector(31 downto 0);
        startinterruptin: in     vl_logic;
        endinterruptin  : in     vl_logic;
        errorinterruptin: in     vl_logic;
        stopinterruptin : in     vl_logic;
        interrupt       : out    vl_logic_vector(1 downto 0)
    );
end dmacregfile2ch;
