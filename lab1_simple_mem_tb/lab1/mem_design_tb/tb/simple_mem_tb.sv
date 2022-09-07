///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : simple_mem_tb.sv
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

module mem_test;
// TO DO : INSERT PORT DECLARATION
 
  reg clk;
  reg rst_n;
  reg rd_en;
  reg wr_en;
  reg [4:0] addr;
  reg [7:0] data_in;
  logic [7:0] data_out;

  //simple mem instantiation
  simple_mem mem_inst (
// TO DO : PORT CONNECTION
    .clk      (clk),
    .rst_n    (rst_n),
    .rd_en    (rd_en),
    .wr_en    (wr_en),
    .addr     (addr),
    .data_in  (data_in),
    .data_out (data_out)
	);

  int success, ra, rn = 0;  // success counter, random address, random number

  initial begin
    {clk, rd_en, wr_en, data_in} = 0;
  end
  always #10 clk = ~clk;

  initial
  begin : mem_t
    rst_n <= 1;
    #1 rst_n <= 0;
    #1 rst_n <= 1;
    $display ("Asynch Memory Reset");

//TO DO : After reset read from all addresses and confirm reset state
    $display("Check Memory Reset");
    for (int i = 0; i < 32; i++) begin
      mem_read(i, data_out);
      compare(i, 0);
    end
    $display("Memory reset successes:%d/32\n", success);

  
//TO DO : Run a loop to write iter value on the address -- write 5 on memory[5] 
    $display("Write iterator value to address of the same value");
    success = 0;
    for (int i = 0; i < 32; i++) begin
      mem_write(i, i);
      mem_read(i, data_out);
      compare(i, i);
    end
    $display("Write iterator successes:%d/32\n", success);
   
//TO DO : Add your own stimulus to catch the bug in the design. Also display the current vs expected value
    $display("Brute force regression");
    success = 0;
    for (int i = 0; i < 32; i++) begin
      for (int j = 0; j < 256; j++) begin
        mem_write(i,j);
        mem_read(i,data_out);
        compare(i, j);
      end
    end
    $display("Brute force regression successes:%d/8192\n", success);

    success = 0;
    $display("Random regression");
    for (int i = 0; i < 1000; i++) begin
      ra = $urandom%32;  // new random address
      rn = $urandom%256; // new random number
      mem_write(ra, rn);
      mem_read(ra, data_out);
      compare(ra, rn);
    end
    $display("Random regression successes:%d/1000\n", success);
    $finish;
  end

  task mem_write (input logic [4:0] addr_in, input logic [7:0] data_wr);
// TO DO : complete the task <insert display statement for debug>
  begin
    wr_en <= 1'b1;
    rd_en <= 1'b0;

    @(posedge clk)
    addr = addr_in;
    data_in = data_wr;
    
    @(negedge clk)
    wr_en = 1'b0;
  end
	endtask


  task mem_read (input logic [4:0] addr_in, output logic [7:0] data_rd);
// TO DO : complete the task <insert display statement for debug>
  begin
    rd_en <= 1'b1;
    wr_en <= 1'b0;

    @(posedge clk)
    addr = addr_in;

    @(negedge clk)
    data_rd = data_out;
    rd_en = 1'b0;
  end
	endtask

  function void compare(int address, int expected);
    if (expected == data_out) success++; // increment success counter when data read from memory matches expected value
    else $display("%t Expected: %d,  Read: %d  from addr: %d", $time, expected, data_out, address);
  endfunction

endmodule
