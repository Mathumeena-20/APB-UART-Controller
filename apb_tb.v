`timescale 1ns/1ps

module apb_tb;

// APB Signals
reg PCLK;
reg PRESETn;
reg [7:0] PWDATA;
reg PWRITE;
reg PENABLE;
reg PSEL;
wire [7:0] PRDATA;
wire PREADY;

// Clock generation (10ns period)
initial PCLK = 0;
always #5 PCLK = ~PCLK;

// DUT
apb_uart dut (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PWDATA(PWDATA),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PSEL(PSEL),
    .PRDATA(PRDATA),
    .PREADY(PREADY)
);

// --------------------
// APB WRITE TASK
// --------------------
//task apb_write(input [7:0] data);
//begin
   // @(posedge PCLK);
 //   PSEL   = 1;
   // PWRITE = 1;
  //  PENABLE= 0;
  //  PWDATA = data;

   // @(posedge PCLK);
  //  PENABLE = 1;

  //  @(posedge PCLK);
   // PSEL    = 0;
    //PENABLE = 0;
//end
//endtask

task apb_write(input [7:0] data);
begin
    // SETUP phase
    @(posedge PCLK);
    PSEL   = 1;
    PWRITE = 1;
    PENABLE= 0;
    PWDATA = data;

    // ENABLE phase
    @(posedge PCLK);
    PENABLE = 1;

    // HOLD phase (VERY IMPORTANT)
    @(posedge PCLK);

    // COMPLETE
    @(posedge PCLK);
    PSEL    = 0;
    PENABLE = 0;
    PWRITE  = 0;
    // WAIT one more cycle
    @(posedge PCLK);
end
endtask
// --------------------
// APB READ TASK
// --------------------
//task apb_read;
//begin
//    @(posedge PCLK);
//    PSEL   = 1;
//    PWRITE = 0;
//    PENABLE= 0;

//   @(posedge PCLK);
//    PENABLE = 1;

//    @(posedge PCLK);
//    $display("Read Data = %h", PRDATA);

 //   PSEL    = 0;
  //  PENABLE = 0;
//end
//endtask

task apb_read;
begin
    @(posedge PCLK);
    PSEL   = 1;
    PWRITE = 0;
    PENABLE= 0;

    @(posedge PCLK);
    PENABLE = 1;

    @(posedge PCLK);
    //$display("Read Data = %h", PRDATA);

    @(posedge PCLK);
    PSEL    = 0;
    PENABLE = 0;
end
endtask
// --------------------
// TEST SEQUENCE
// --------------------
initial begin
    // Initialize
    PRESETn = 0;
    PSEL = 0;
    PENABLE = 0;
    PWRITE = 0;
    PWDATA = 0;

    // Reset
    #20 PRESETn = 1;

    // Write operation
    #10;
    apb_write(8'hA5);

    // Read operation
    #10;
    apb_read();

    // Another write
    #10;
    apb_write(8'h3C);

    // Read again
    #10;
    apb_read();
    
    #10;
    apb_write(8'hFF);
    apb_read();

    #10;
    apb_write(8'h00);
    apb_read();

    #10;
    apb_write(8'hAA);
    apb_read();

    #10;
    apb_write(8'h55);
    apb_read();

    #50;
    //$stop;
    
end

// --------------------
// MONITOR (VERY USEFUL)
// --------------------
initial begin
    $monitor("Time=%0t | PSEL=%b PENABLE=%b PWRITE=%b PWDATA=%h PRDATA=%h",
              $time, PSEL, PENABLE, PWRITE, PWDATA, PRDATA);
end

endmodule
