library verilog;
use verilog.vl_types.all;
entity oversampling_filer is
    port(
        clk_16x         : in     vl_logic;
        data_in         : in     vl_logic;
        reset           : in     vl_logic;
        tick            : in     vl_logic_vector(3 downto 0);
        voted_bit       : out    vl_logic
    );
end oversampling_filer;
