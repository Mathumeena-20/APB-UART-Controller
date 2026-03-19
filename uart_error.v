module uart_error (
    input parity_rx,
    input parity_calc,
    input stop_bit,
    output parity_error,
    output frame_error
);

assign parity_error = (parity_rx != parity_calc);
assign frame_error  = (stop_bit != 1);

endmodule
