///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : simple_mem_tb.sv
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

module mem_test(
// TO DO : INSERT PORT DECLARATION
	);

  //simple mem instantiation
  simple_mem mem_inst (
// TO DO : PORT CONNECTION
	);

  always #10 clk = ~clk;

  initial
  begin : mem_t

    rst_n <= 1;
    #1 rst_n <= 0;
    #1 rst_n <= 1;
    $display ("Asynch Memory Reset");

//TO DO : After reset read from all addresses and confirm reset state

//TO DO : Run a loop to write iter value on the address -- write 5 on memory[5] 

//TO DO : Add your own stimulus to catch the bug in the design. Also display the current vs expected value
   
  $finish; 
  end

  task mem_write (input logic [4:0] addr_in, input logic [7:0] data_wr);
// TO DO : complete the task <insert display statement for debug>
	endtask


  task mem_read (input logic [4:0] addr_in, output logic [7:0] data_rd);
// TO DO : complete the task <insert display statement for debug>
	endtask

endmodule
