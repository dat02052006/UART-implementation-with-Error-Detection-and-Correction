module tx_fsm (
  input clk_16x, reset, tx_start,
  input [12:0] data_in,
  output reg data_out,
  output done
);
  parameter idle=2'd0, start=2'd1, data=2'd2, stop=2'd3;
  reg [1:0] state, next_state;
  reg [3:0] tick_counter, bit_counter;
  always @(*) begin
    case (state)
      idle: next_state = (tx_start) ? start : idle;
      start: next_state = (tick_counter == 4'd15) ? data : start;
      data: next_state = (tick_counter == 4'd15 && bit_counter == 4'd12) ? stop : data;
      stop: next_state = (tick_counter == 4'd15) ? idle : stop;
    endcase
  end
  reg [12:0] shift_reg;
  always @(posedge clk_16x or posedge reset) begin
    if (reset) begin
      state <= idle;
      data_out <= 1'b1;
      tick_counter <= 4'd0;
      bit_counter <= 4'd0;
      shift_reg <= 13'd0;
    end
    else begin
      state <= next_state;
      case (state)
        idle: begin
          data_out <= 1'b1;
          tick_counter <= 4'd0;
          bit_counter <= 4'd0;
          if (tx_start) shift_reg <= data_in;
        end
        start: begin
          data_out <= 1'b0;
          tick_counter <= (tick_counter == 4'd15) ? 4'd0 : tick_counter + 1'b1;
        end
        data: begin
          data_out <= shift_reg[0];
          if (tick_counter == 4'd15) begin
            tick_counter <= 4'd0;
            bit_counter <= bit_counter + 1'b1;
            shift_reg <= shift_reg >> 1;
          end
          else tick_counter <= tick_counter + 1'b1;
        end
        stop: begin
          data_out <= 1'b1;
          tick_counter <= (tick_counter == 4'd15) ? 4'd0 : tick_counter + 1'b1;
        end
      endcase
    end
  end 
  assign done = (state == stop && tick_counter == 4'd15);
endmodule