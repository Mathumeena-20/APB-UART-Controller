module apb_uart (
    input PCLK,
    input PRESETn,
    input [7:0] PWDATA,
    input PWRITE,
    input PENABLE,
    input PSEL,
    output reg [7:0] PRDATA,
    output PREADY
);

reg [7:0] reg_data;

assign PREADY = 1;

always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
        reg_data <= 0;
      
    // APB write happens in setup phase (PENABLE = 0)
    else if (PSEL && PWRITE && !PENABLE)   
        reg_data <= PWDATA;
end

always @(*) begin
    if (PSEL && !PWRITE)
        PRDATA = reg_data;
    else
        PRDATA = 0;
end

endmodule
