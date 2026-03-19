module baud_gen (
    input clk,
    input reset,
    output reg tick
);

parameter DIV = 434; // for 115200 baud (example)

reg [15:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
        tick <= 0;
    end else begin
        if (count == DIV) begin
            count <= 0;
            tick <= 1;
        end else begin
            count <= count + 1;
            tick <= 0;
        end
    end
end

endmodule
