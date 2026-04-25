`timescale 1ns/1ps
module uart_top_tb ();
  reg clk, reset, send, receive;
  reg [7:0] send_data;
  wire [7:0] receive_data;
  wire tx_pin;
  wire rx_sec, rx_ded, tx_full, rx_full, tx_empty, rx_empty;
  wire rx_pin;
  assign rx_pin = tx_pin; 
  uart_top uut (
    .clk(clk),
    .reset(reset),
    .send_data(send_data),
    .send(send),
    .receive_data(receive_data),
    .receive(receive),
    .rx_pin(rx_pin),
    .tx_pin(tx_pin),
    .rx_sec(rx_sec),
    .rx_ded(rx_ded),
    .tx_full(tx_full),
    .rx_full(rx_full),
    .tx_empty(tx_empty),
    .rx_empty(rx_empty)
  );

  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk; 
  end

  task send_byte;
    input [7:0] data;
    begin
      send_data = data;
      send = 1'b1;
      @(posedge uut.clk_16x);
      #10; 
      send = 1'b0;
    end
  endtask

  task check;
    input [7:0] expected;
    begin
      receive = 1'b1;
      @(posedge uut.inst2.done);
      @(posedge uut.clk_16x);
      @(posedge uut.clk_16x);
      #10;
      if (receive_data == expected) 
        $display ("PASS, sent: %h, got %h", expected, receive_data);
      else 
        $display ("FAIL, sent: %h, got %h", expected, receive_data);
      receive = 1'b0;
    end
  endtask

  initial begin
    reset = 1'b1;
    send = 1'b0;
    send_data = 8'd0;
    receive = 1'b0;
    #200;
    reset = 1'b0;
    #200; 
    
    send_byte (8'haa);
    check (8'haa);
    
    send_byte (8'hbb);
    check (8'hbb);
    
    send_byte (8'hcc);
    check (8'hcc);
    
    // Test FIFO burst
    send_byte (8'h11);
    send_byte (8'h22);
    send_byte (8'h33);
    send_byte (8'h11);
    send_byte (8'h22);
    send_byte (8'h33);
    send_byte (8'h11);
    send_byte (8'h22);
    send_byte (8'h33);
    send_byte (8'h11);
    send_byte (8'h22);
    send_byte (8'h33);
    send_byte (8'h11);
    send_byte (8'h22);
    send_byte (8'h33);
    send_byte (8'h11);
    send_byte (8'h22);
    send_byte (8'h33);
    if (tx_full) $display ("FIFO tx_full flag works, last byte sent: %h:", uut.inst1.fifo_out);
    wait (rx_full == 1'b1);
    if (rx_full) $display ("FIFO rx_full flag works, last byte received: %h", uut.inst2.decoded);
    #1000000; 
    $finish;
  end
endmodule