`timescale 1ns/1ps
module oversampling_tb ();
  reg clk, reset, in;
  reg [3:0] tick;
  wire out;
  oversampling_filter uut (
    .clk_16x(clk), 
    .reset(reset),
    .data_in(in),
    .tick(tick),
    .voted_bit(out)
  );
  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
  end
  always @(posedge clk or posedge reset) begin
    if (reset) tick <= 4'd0;
    else tick <= (tick == 4'd15) ? 4'd0 : tick + 1;
  end
  initial begin
    reset = 1'b1;
    in = 1'b1;
    #10;
    reset = 1'b0;
    @(tick == 4'd6);
    in = 1'b0;
    @(tick == 4'd7);
    in = 1'b1;
    @(tick == 4'd8);
    in = 1'b0;
    @(tick == 4'd9);
    in = 1'b0;
    @(tick == 4'd10);
    if (out == 1'b0) $display ("pass");
    else $display ("fail");
    #50;
    $finish;
  end
endmodule
