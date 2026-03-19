
module uart_top (
    input clk,
    input reset,
    input [7:0] data_in,
    input tx_start,
    output tx,
    input rx,
    output [7:0] data_out,
    output tx_done,
    output rx_done
);

wire baud_tick;

// Baud generator
baud_gen baud (
    .clk(clk),
    .reset(reset),
    .tick(baud_tick)
);

// TX
uart_tx tx_unit (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .start(tx_start),
    .baud_tick(baud_tick),
    .tx(tx),
    .done(tx_done)
);

// RX
uart_rx rx_unit (
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .baud_tick(baud_tick),
    .data_out(data_out),
    .done(rx_done)
);

endmodule