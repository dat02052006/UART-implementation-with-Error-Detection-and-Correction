`timescale 1ns/1ps
module tx_fsm_tb ();
  reg clk, reset, start;
  reg [12:0] in;
  wire out, done;
  tx_fsm uut (
    .clk_16x(clk),
    .reset(reset),
    .tx_start(start),
    .data_in(in),
    .data_out(out),
    .done(done)
  );
  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
  end
  initial begin
    reset = 1'b1;
    start = 1'b0;
    in = 13'd0;
    #10;
    reset = 1'b0;
    #100;
    in = 13'b1_1110_0011_0001;
    start = 1'b1;
    #20;
    start = 1'b0;
    @(posedge done);
    $display ("Sent");
    #10;
    $finish;
  end
  initial begin
    forever begin
        @(posedge clk);
        if (uut.state == 2'd2 && uut.tick_counter == 4'd8) $display ("Bit %d out: %b", uut.bit_counter, out);
    end
  end
endmodule