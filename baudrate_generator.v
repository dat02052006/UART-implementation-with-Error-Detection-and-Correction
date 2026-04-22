module baudrate_generator (
  input clk, reset,
  output reg clk_16x
);
  reg [7:0] counter;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 8'd0;
      clk_16x <= 1'b0;
    end
    else begin
      if (counter == 8'd13) begin
        counter <= 8'd0;
        clk_16x <= ~clk_16x;
      end
      else counter <= counter + 1;
    end
  end
endmodule
