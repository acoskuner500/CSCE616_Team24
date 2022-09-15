interface cache_mem_intf (input clk, input rst_n);
  logic [4:0] addr;
  logic [7:0] data_in;
  logic [7:0] data_out;
  logic rd_en;
  logic wr_en;

//TO DO : Define modport for tb   
modport tb (
  //input clk,
  //input rst_n,
  output rd_en,
  output wr_en,
  output addr,
  output data_in,
  input data_out,
  import mem_write,
  import mem_read
);
//TO DO : Define modport for mem
modport mem (
  //input clk,
  //input rst_n,
  input rd_en,
  input wr_en,
  input addr  ,
  input data_in  ,
  output data_out
);
              
task mem_write (input logic [4:0] addr_in, input logic [7:0] data_wr);
  @(negedge clk);
  wr_en <= 1;
  rd_en <= 0;
  addr <= addr_in;
  data_in <= data_wr;

  @(negedge clk);
  wr_en <= 0;
  //$display ("Write Address : %0d with data : %0h", addr, data_wr);
endtask


task mem_read (input logic [4:0] addr_in, output logic [7:0] data_rd);
  @(negedge clk);
  wr_en <= 0;
  rd_en <= 1;
  addr <= addr_in;

  @(negedge clk);
  data_rd = data_out;
  rd_en <= 0;
  //$display ("Read Address : %0d with data : %0h", addr, data_rd);
endtask
              
endinterface
