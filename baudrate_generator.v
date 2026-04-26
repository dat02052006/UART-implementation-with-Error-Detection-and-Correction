module baudrate_generator (
  input clk, reset,
  input [2:0] baud_rate_sel,
  output reg clk_16x
);
  reg [10:0] limit;
  always @(*) begin
    case (baud_rate_sel)
        3'b000: limit = 11'd13;     // 115200
        3'b001: limit = 11'd26;     // 57600
        3'b010: limit = 11'd40;     // 38400
        3'b011: limit = 11'd80;     // 19200
        3'b100: limit = 11'd162;    // 9600
        3'b101: limit = 11'd325;    // 4800
        3'b110: limit = 11'd650;    // 2400
        3'b111: limit = 11'd1301;   // 1200
        default: limit = 11'd13;
    endcase
  end
  reg [10:0] counter;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 11'd0;
      clk_16x <= 1'b0;
    end
    else begin
      if (counter >= limit) begin   
        counter <= 11'd0;
        clk_16x <= ~clk_16x;
      end
      else counter <= counter + 1;
    end
  end
endmodule
