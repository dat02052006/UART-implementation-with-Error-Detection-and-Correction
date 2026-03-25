library verilog;
use verilog.vl_types.all;
entity Emitter is
    port(
        d               : in     vl_logic_vector(7 downto 0);
        encoded_data    : out    vl_logic_vector(12 downto 0)
    );
end Emitter;
