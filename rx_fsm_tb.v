`timescale 1ns/1ps
module rx_fsm_tb ();
  reg clk, reset, in;
  wire [12:0] frame;
  wire ready;
  rx_fsm uut (
    .clk_16x(clk),
    .reset(reset),
    .data_in(in),
    .rx_frame(frame),
    .done(done)
  );
  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
  end
  task write;
    input [12:0] data;
    integer i;
    begin
      in = 1'b0;
      repeat(16) @(posedge clk);
      for (i = 0; i < 13; i = i + 1) begin
        in = data[i];
        repeat(16) @(posedge clk);
      end
      in = 1'b1;
      repeat(16) @(posedge clk);
    end
  endtask
  initial begin
    reset = 1'b1;
    in = 1'b1;
    #10;  
    reset = 1'b0;
    $display ("Frame received: 0_0100_1101_0110");
    write (13'b0_0100_1101_0110);
    $display ("Received");
    $display ("Frame received: 1_0100_0001_0100");
    write (13'b1_0100_0001_0100);
    $display ("Received");
    #50000;
    $finish;
  end
  initial begin
    forever begin
        @(posedge clk);
        if (uut.state == 2'd2 && uut.tick_counter == 4'd8) begin
            $display ("Bit %d in: %b", uut.bit_counter, in);
        end
    end
  end
endmodule


