library verilog;
use verilog.vl_types.all;
entity pci_arbiter_model is
    generic(
        master_no       : integer := 4;
        target_no       : integer := 4;
        latency_limit   : integer := 8
    );
    port(
        rstn            : in     vl_logic;
        clk             : in     vl_logic;
        ad              : in     vl_logic_vector(31 downto 0);
        cbe             : in     vl_logic_vector(3 downto 0);
        framen          : in     vl_logic;
        reqn            : in     vl_logic_vector;
        gntn            : out    vl_logic_vector;
        idsel           : out    vl_logic_vector
    );
end pci_arbiter_model;
