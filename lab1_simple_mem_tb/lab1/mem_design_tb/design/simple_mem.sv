///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : simple_mem.sv
// Created by  : Prof. Quinn and Saumil Gogri
// Specification:
//  Simple Memory is 5-bits wide and address range is 0 to 31
//  Simple Memory access is synchronous with asynchronous reset(rst_n)
//  Write data_in into the simple memory on posedge of clk only when wr_en=1
//  Place simple memory[addr] onto data_out bus on posedge of clk only when rd_en=1
//  Read and Write request cannot be placed simultaneously
//  Reset writes zeros to all the address
// 
///////////////////////////////////////////////////////////////////////////
module simple_mem (
  input        clk,
  input        rst_n,
  input        rd_en,
  input        wr_en,
  input  logic [4:0] addr  ,
  input  logic [7:0] data_in  ,
  output logic [7:0] data_out
     );

  logic [7:0] memory [0:31];

  always @(posedge clk or negedge rst_n) begin
    if (rst_n==0) begin
      for(int i=0; i<32; i++)
        memory[i] <= 8'b0;
    end
    else if ((wr_en==1) && (rd_en==0))
      #1 memory[addr] <= memory[addr] ^ data_in;
    else if ((wr_en==0) && (rd_en==1))
      #1 data_out <= memory[addr];
  end

endmodule
