module uart_rx (
    input clk,
    input reset,
    input rx,
    input baud_tick,
    output reg [7:0] data_out,
    output reg done
);

reg [3:0] bit_cnt;
reg [9:0] shift_reg;
reg active;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        active <= 0;
        done <= 0;
    end else begin
        if (!active && !rx) begin // start bit detect
            active <= 1;
            bit_cnt <= 0;
        end else if (baud_tick && active) begin
            shift_reg <= {rx, shift_reg[9:1]};
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == 9) begin
                active <= 0;
                data_out <= shift_reg[8:1];
                done <= 1;
            end
        end else begin
            done <= 0;
        end
    end
end

endmodule
