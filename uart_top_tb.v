`timescale 1ns/1ps

module uart_top_tb ();
  reg clk, reset, send;
  reg [7:0] send_data;
  wire [7:0] receive_data;
  wire tx_pin;
  wire rx_sec, rx_ded, tx_full, rx_full;
  wire rx_pin;
  
  assign rx_pin = tx_pin; // Loopback
  
  uart_top uut (
    .clk(clk),
    .reset(reset),
    .send_data(send_data),
    .send(send),
    .receive_data(receive_data),
    .rx_pin(rx_pin),
    .tx_pin(tx_pin),
    .rx_sec(rx_sec),
    .rx_ded(rx_ded),
    .tx_full(tx_full),
    .rx_full(rx_full)
  );

  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk; // 50MHz
  end

  task send_byte;
    input [7:0] data;
    begin
      send_data = data;
      send = 1'b1;
      // Ch? s??n lên c?a chính clk_16x bên trong b? uut ?? ??ng b? chính xác
      @(posedge uut.clk_16x);
      
      // Delay thêm 1 chút (ví d? 10ns) ?? tránh l?i hold-time violation trong mô ph?ng
      #10; 
      
      send = 1'b0;
    end
  endtask

  task check;
    input [7:0] expected;
    begin
      #300000; // T?ng delay lên 5ms ?? ??m b?o truy?n xong m?i Baud rate thông d?ng
      if (receive_data == expected) 
        $display ("PASS, sent: %h, got %h", expected, receive_data);
      else 
        $display ("FAIL, sent: %h, got %h", expected, receive_data);
    end
  endtask

  initial begin
    reset = 1'b1;
    send = 1'b0;
    send_data = 8'd0;
    
    #200;
    reset = 1'b0;
    #200; // ??i m?t chút sau reset r?i m?i g?i
    
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
    
    // ??i 15ms cho 3 byte truy?n xong (n?u test baud rate ch?m)
    #1000000; 
    
    if (tx_full) $display ("FIFO tx_full flag works");
    
    $finish;
  end
endmodule