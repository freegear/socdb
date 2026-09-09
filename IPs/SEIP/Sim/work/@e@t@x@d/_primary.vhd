library verilog;
use verilog.vl_types.all;
entity ETXD is
    port(
        EDBR            : in     vl_logic_vector(15 downto 0);
        XRST            : in     vl_logic;
        ESYNC           : in     vl_logic;
        TI              : in     vl_logic;
        TXRDY           : in     vl_logic;
        TXEN            : in     vl_logic;
        TE              : in     vl_logic;
        TXLDLE          : in     vl_logic;
        MCK             : in     vl_logic;
        TXRDLE          : in     vl_logic;
        TXD             : out    vl_logic_vector(31 downto 0);
        TXSYNC          : out    vl_logic;
        TXRD            : out    vl_logic;
        \TO\            : out    vl_logic
    );
end ETXD;
