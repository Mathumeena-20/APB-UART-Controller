module uart_tx (
    input clk,
    input reset,
    input [7:0] data_in,
    input start,
    input baud_tick,
    output reg tx,
    output reg done
);

reg [3:0] bit_cnt;
reg [9:0] shift_reg;
reg active;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx <= 1;
        active <= 0;
        done <= 0;
        bit_cnt <= 0;
    end else begin
        if (start && !active) begin
            shift_reg <= {1'b1, data_in, 1'b0}; // stop + data + start
            active <= 1;
            bit_cnt <= 0;
            done <= 0;
        end else if (baud_tick && active) begin
            tx <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == 9) begin
                active <= 0;
                done <= 1;
            end
        end else begin
            done <= 0;
        end
    end
end

endmodule
