module fifo #(parameter DEPTH = 16)(
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
);

reg [7:0] mem [0:DEPTH-1];
reg [4:0] wr_ptr, rd_ptr;

assign full  = (wr_ptr + 1 == rd_ptr);
assign empty = (wr_ptr == rd_ptr);

always @(posedge clk) begin
    if (write_en && !full)
        mem[wr_ptr] <= data_in;

    if (read_en && !empty)
        data_out <= mem[rd_ptr];
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
    end else begin
        if (write_en && !full)
            wr_ptr <= wr_ptr + 1;

        if (read_en && !empty)
            rd_ptr <= rd_ptr + 1;
    end
end

endmodule
