`timescale 1ns / 1ps
module receiver_tb ();
    reg clk, reset, in, en;
    wire [7:0] out;
    wire sec, ded, empty, full;
    receiver uut (
        .clk_16x(clk),
        .reset(reset),
        .data_in(in),
        .data_out(out),
        .r_en(en),
        .error_sec(sec),
        .error_ded(ded),
        .full(full),
        .empty(empty)
    );
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    integer i;
    task get;
        input [12:0] data;
        begin
            in = 1'b0;
            repeat(16) @(posedge clk);
            for (i = 0; i < 4'd13; i = i + 1'b1) begin
                in = data[i];
                repeat(16) @(posedge clk);
            end
            in = 1'b1;
            repeat(16) @(posedge clk);
        end 
    endtask 
    task check_fifo;
        input [7:0] expected_fifo_out;
        begin
            en = 1'b1;
            @(posedge clk);
            @(posedge clk);
            if (out == expected_fifo_out) $display ("FIFO Pass, receive: %h, fifo_out: %h", expected_fifo_out, out);
            else $display ("FIFO Fail, receive: %h, fifo_out: %h", expected_fifo_out, out);
            en = 1'b0;
        end
    endtask
    function [12:0] encoder;
        input [7:0] d;
        reg [3:0] p;
        reg p_total;
        reg [11:0] temp;
        begin
            p[0] = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6];
            p[1] = d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6];
            p[2] = d[1] ^ d[2] ^ d[3] ^ d[7];
            p[3] = d[4] ^ d[5] ^ d[6] ^ d[7];
            temp = {d[7:4], p[3], d[3:1], p[2], d[0], p[1:0]};
            p_total = ^temp;
            encoder = {p_total, temp};
        end
    endfunction
    reg [12:0] receive_data;
    initial begin
        reset = 1'b1;
        in = 1'b1;
        en = 1'b0;
        #100;
        reset = 1'b0;
        #100;
        receive_data = encoder(8'haa);
        get (receive_data);
        $display ("Frame in: %b", uut.rx_frame);
        check_fifo (8'haa);
        receive_data = encoder(8'hbb);
        get (receive_data);
        $display ("Frame in: %b", uut.rx_frame);
        check_fifo (8'hbb);
        receive_data = encoder(8'hcc);
        get (receive_data);
        $display ("Frame in: %b", uut.rx_frame);
        check_fifo (8'hcc);
        #50000;
        $finish;
    end
    initial begin   
        forever begin
            @(posedge clk);
            if (uut.inst0.state == 2'd2 && uut.inst0.tick_counter == 4'd8) $display ("Bit in %d: %b", uut.inst0.bit_counter, in);
        end
    end
endmodule
