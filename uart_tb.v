`timescale 1ns/1ps

module uart_tb;

reg clk = 0;
always #20 clk = ~clk;

reg reset;
reg [7:0] data_in;
reg tx_start;
wire tx, rx;
wire [7:0] data_out;
wire tx_done, rx_done;

assign rx = tx;

uart_top uut (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .tx_start(tx_start),
    .tx(tx),
    .rx(rx),
    .data_out(data_out),
    .tx_done(tx_done),
    .rx_done(rx_done)
);

initial begin
    reset = 1;
    #20 reset = 0;

    data_in = 8'hA5;
    tx_start = 1;
    #10 tx_start = 0;

    #2000;
    //$finish;
end

endmodule
