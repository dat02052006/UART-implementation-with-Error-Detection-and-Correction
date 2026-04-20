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
    .ready(ready)
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
      #320;
      for (i = 0; i < 13; i = i + 1) begin
        in = data[i];
        #320;
      end
      in = 1'b1;
      #320;
    end
  endtask
  initial begin
    reset = 1'b1;
    in = 1'b1;
    #10;  
    reset = 1'b0;
    write (13'b0_0100_1101_0110);
    #10000;
    if (ready) $display("Expected: 0010011010110, got: %b", frame);
    else $display("TIMEOUT - ready không lên");
    #100;
    $finish;
  end
endmodule


