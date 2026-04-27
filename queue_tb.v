`timescale 1ns/1ps
module queue_tb ();
  reg clk, reset, we, re;
  reg [7:0] in;
  wire [7:0] out;
  wire full, empty;
  queue #(
    .data_width(8),
    .addr_width(2)
  ) uut (
    .clk(clk),
    .rs(reset),
    .w_en(we),
    .r_en(re),
    .in(in),
    .out(out),
    .full(full),
    .empty(empty)
  );
  task write;
    input [7:0] data;
    begin
      in = data;
      we  = 1'b1;
      @(posedge clk);
      #1;
      we = 1'b0;
    end
  endtask
  task read;
    begin
      re = 1'b1;
      @(posedge clk);
      #1;
      re = 1'b0;
    end
  endtask
  always #5 clk = ~clk;
  initial begin
    clk = 1'b0;
    re = 1'b0;
    we = 1'b0;
    in = 8'd0;
    reset = 1'b1;
    #10;
    reset = 1'b0;
    write (8'haa);
    write (8'hbb);
    write (8'hcc);
    read;
    $display ("Expect: aa, got: %h", out);
    read;
    $display ("Expect: bb, got: %h", out);
    read;
    $display ("Expect: cc, got: %h", out);
    $display ("Expect empty, empty: %b", empty);
    #50;
    $finish;
  end
endmodule