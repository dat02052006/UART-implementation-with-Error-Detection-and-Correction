`timescale 1ns/1ps
module transmitter_tb ();
  reg clk, reset, en;
  reg [7:0] in;
  wire out, full;
  transmitter uut (
    .clk_16x(clk),
    .reset(reset),
    .w_en(en),
    .data_in(in),
    .data_out(out),
    .full(full)
  );
  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
  end
  initial begin
    reset = 1'b1;
    en = 1'b0;
    in = 8'd0;
    #10;
    reset = 1'b0;
    in = 8'b1111_1111;
    en = 1'b1;
    #20;
    en = 1'b0;
    #50000;
    $finish;
  end
endmodule