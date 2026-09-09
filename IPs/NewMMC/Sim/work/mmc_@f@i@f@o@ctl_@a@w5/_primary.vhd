library verilog;
use verilog.vl_types.all;
entity mmc_fifoctl_aw5 is
    port(
        clki            : in     vl_logic;
        readeni         : in     vl_logic;
        writeeni        : in     vl_logic;
        nrst            : in     vl_logic;
        flushi          : in     vl_logic;
        fullo           : out    vl_logic;
        fifohalffull    : out    vl_logic;
        fifohalfempty   : out    vl_logic;
        datcnto         : out    vl_logic_vector(4 downto 0);
        almostemptyo    : out    vl_logic;
        emptyo          : out    vl_logic;
        reademptyo      : out    vl_logic;
        writeaddro      : out    vl_logic_vector(4 downto 0);
        readaddro       : out    vl_logic_vector(4 downto 0);
        readallowo      : out    vl_logic;
        writeallowo     : out    vl_logic
    );
end mmc_fifoctl_aw5;
