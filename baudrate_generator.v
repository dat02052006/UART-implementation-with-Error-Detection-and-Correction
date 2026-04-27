module baudrate_generator #(
  parameter sys_clk = 50000000
) ( 
  input clk, reset,
  input [2:0] baud_rate_sel,
  output reg clk_16x
);
  localparam max_limit = ((sys_clk + 16 * 1200)   / (32 * 1200)) - 1; 
  localparam width = $clog2(max_limit + 1);
  reg [width-1:0] limit;
  always @(*) begin
    case (baud_rate_sel)
        3'b000: limit = ((sys_clk + 16 * 115200) / (32 * 115200)) - 1;  // 115200
        3'b001: limit = ((sys_clk + 16 * 57600)  / (32 * 57600)) - 1;   // 57600
        3'b010: limit = ((sys_clk + 16 * 38400)  / (32 * 38400)) - 1;   // 38400
        3'b011: limit = ((sys_clk + 16 * 19200)  / (32 * 19200)) - 1;   // 19200
        3'b100: limit = ((sys_clk + 16 * 9600)   / (32 * 9600)) - 1;    // 9600
        3'b101: limit = ((sys_clk + 16 * 4800)   / (32 * 4800)) - 1;    // 4800
        3'b110: limit = ((sys_clk + 16 * 2400)   / (32 * 2400)) - 1;    // 2400
        3'b111: limit = ((sys_clk + 16 * 1200)   / (32 * 1200)) - 1;    // 1200
        default: limit = ((sys_clk + 16 * 115200) / (32 * 115200)) - 1;    
    endcase
  end
  reg [width-1:0] counter;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= {width{1'b0}};
      clk_16x <= 1'b0;
    end
    else begin
      if (counter >= limit) begin   
        counter <= {width{1'b0}};
        clk_16x <= ~clk_16x;
      end
      else counter <= counter + 1;
    end
  end
endmodule
