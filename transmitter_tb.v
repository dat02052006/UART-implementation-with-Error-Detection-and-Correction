`timescale 1ns/1ps
module transmitter_tb ();
  reg clk, reset, en;
  reg [7:0] in;
  wire out, full, empty;
  transmitter uut (
    .clk_16x(clk),
    .reset(reset),
    .w_en(en),
    .data_in(in),
    .data_out(out),
    .empty(empty),
    .full(full)
  );
  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
  end
  task send;
    input [7:0] data;
    begin
        @(negedge clk);
        in = data;
        en = 1'b1;
        @(negedge clk);
        en = 1'b0;
    end
  endtask
  task check_fifo;
    input [7:0] expected_fifo_out;
    begin
        @(posedge clk);
        @(posedge clk);
        if (uut.fifo_out == expected_fifo_out) $display ("FIFO Pass, send: %h, fifo_out: %h", expected_fifo_out, uut.fifo_out);
        else $display ("FIFO Fail, send: %h, fifo_out: %h", expected_fifo_out, uut.fifo_out);
    end
  endtask
  initial begin
    reset = 1'b1;
    en = 1'b0;
    in = 8'd0;
    #100;
    reset = 1'b0;
    #100;
    send (8'haa);
    check_fifo (8'haa);
    $display ("Frame out: %b", uut.encoder_out);
    wait (uut.done == 1'b1);
    send (8'hbb);
    check_fifo (8'hbb);
    $display ("Frame out: %b", uut.encoder_out);
    #50000;
    $finish;
  end
  initial begin
    forever begin
        @(posedge clk);
        if (uut.inst2.state == 2'd2 && uut.inst2.tick_counter == 4'd8) $display ("Bit out %d: %b", uut.inst2.bit_counter, out);
    end
  end
endmodule