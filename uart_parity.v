module uart_parity (
    input [7:0] data,
    output parity
);

assign parity = ^data; // even parity

endmodule
