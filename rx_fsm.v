module rx_fsm (
  input clk_16x, reset, data_in,
  output [12:0] rx_frame,
  output done
);
  reg [3:0] tick_counter, bit_counter;  // bo dem tick va so bit nhan duoc
  wire voted_bit;                       // output cua oversampling filter
  oversampling_filter inst0 (
    .clk_16x(clk_16x),
    .reset(reset),
    .data_in(data_in),
    .tick(tick_counter),
    .voted_bit(voted_bit)
  );
  parameter idle=2'b00, start=2'b01, data=2'b10, stop=2'b11;
  reg [1:0] state, next_state;
  reg [12:0] shift_reg;
  always @(*) begin
    case (state)
      idle: next_state = (!data_in) ? start : idle; // start bit = 0 
      start: begin
        if (tick_counter == 4'd7) next_state = (!data_in) ? data : idle;    // xac dinh dung start bit thi nhan hang
        else next_state = start;
      end
      data: begin
        if (tick_counter == 4'd15) next_state = (bit_counter == 4'd12) ? stop : data; // nhan lan luot tung bit
        else next_state = data;
      end
      stop: next_state = (tick_counter == 4'd15) ? idle : stop; // nhan xong thi dung
    endcase
  end
  always @(posedge clk_16x or posedge reset) begin
    if (reset) begin
      state <= idle;
      tick_counter <= 4'd0;
      bit_counter <= 4'd0;
      shift_reg <= 13'd0;
    end
    else begin
      state <= next_state;
      case (state) 
        idle: begin
          tick_counter <= 4'd0;
          bit_counter <= 4'b0;
        end
        start: tick_counter <= (tick_counter == 4'd7)? 4'd0 : tick_counter + 1;
        data: begin
          if (tick_counter == 4'd15) begin
            shift_reg <= {voted_bit, shift_reg[12:1]};  // dich vao tung bit nhan
            bit_counter <= bit_counter + 1;
            tick_counter <= 4'd0;
          end
          else tick_counter <= tick_counter + 1;
        end
        stop: tick_counter <= (tick_counter == 4'd15) ? 4'd0 : tick_counter + 1;
      endcase
    end
  end
  assign done = (state == stop && tick_counter == 4'd15) ? 1'b1 : 1'b0;
  assign rx_frame = shift_reg;
endmodule
