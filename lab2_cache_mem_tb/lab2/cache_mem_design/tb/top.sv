module top;
  
  timeunit 1ns;
  timeprecision 1ns;
  
  logic clk=0;
  logic rst_n=1;
  
  always #5 clk = ~clk;
  
  initial begin
    #1 rst_n=0;
    #2 rst_n=1;
    $display ("Asynch Memory Reset");
  end 
  
  cache_mem_intf cmbus (clk, rst_n);
  
  cache_mem mem_inst (
    .clk    (clk),
    .rst_n  (rst_n),
    .rd_en  (cmbus.mem.rd_en),
    .wr_en  (cmbus.mem.wr_en),
    .data_in(cmbus.mem.data_in),
    .data_out(cmbus.mem.data_out),
    .addr   (cmbus.mem.addr)
  );
  
  cache_mem_test mem_tb (.cmbus(cmbus.tb));

endmodule
