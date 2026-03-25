library verilog;
use verilog.vl_types.all;
entity receiver is
    port(
        data_in         : in     vl_logic_vector(12 downto 0);
        data_out        : out    vl_logic_vector(7 downto 0);
        error_sec       : out    vl_logic;
        error_dec       : out    vl_logic
    );
end receiver;
