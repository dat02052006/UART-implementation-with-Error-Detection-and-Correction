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
        in = data;
        en = 1'b1;
        #10;
        en = 1'b0;
    end
  endtask
  reg [12:0] captured_data;
  integer i;
  task check;
    input [7:0] raw_data;
    reg [12:0] expected_data;
    begin
        @(negedge out);
        #10;
        expected_data = uut.encoder_out;
        repeat(8) @(posedge clk);
        for (i = 0; i < 4'd13; i = i + 1) begin
            repeat(16) @(posedge clk);
            captured_data[i] = out;
        end
       repeat(16) @(posedge clk);
       if (out != 1'b1) $display ("Error no stop bit");
       if (captured_data == expected_data) $display ("Pass, send: %h, got: %h", expected_data, captured_data);
       else $display ("Fail, send: %h, got: %h", expected_data, captured_data);
    end
  endtask
  initial begin
    reset = 1'b1;
    en = 1'b0;
    in = 8'd0;
    captured_data = 13'd0;
    #10;
    reset = 1'b0;
    #100;
    send (8'haa);
    @(posedge clk);
    @(posedge clk);
    check (8'haa);
    send (8'hbb);
    captured_data = 13'd0;
    @(posedge clk);
    @(posedge clk);
    check (8'hbb);
    send (8'hcc);
    captured_data = 13'd0;
    @(posedge clk);
    @(posedge clk);
    check (8'hcc);
    send (8'hdd);
    captured_data = 13'd0;
    @(posedge clk);
    @(posedge clk);
    check (8'hdd);
    send (8'hee);
    captured_data = 13'd0;
    @(posedge clk);
    @(posedge clk);
    check (8'hee);
    #50000;
    $finish;
  end
endmodule