// Baud rate == 115200
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
      if (counter == 8'd13) begin   // 50Mhz / 16*115200 = 27 -> dem den 13 thi dao clk
        counter <= 8'd0;
        clk_16x <= ~clk_16x;
      end
      else counter <= counter + 1;
    end
  end
endmodule
