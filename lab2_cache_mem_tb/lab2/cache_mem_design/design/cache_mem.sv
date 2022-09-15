///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : cache_mem.sv
// Created by  : Prof. Quinn and Saumil Gogri
// Specification:
//  Cache-Memory is 5-bits wide and address range is 0 to 31.
//  Cache-Memory access is synchronous with asynchronous reset
//  Write data_in into the cache-memory on posedge of clk only when wr_en=1
//  Place cache-memory data onto data_out bus on posedge of clk only when rd_en=1
//  Read and Write request cannot be placed simultaneously.
//  Cache has 4 entries; There is an entry corresponding to set of 8 addresses, total 32 addresses. ie entry 2 in cache corresponds to address range 16-23
//	Cache Hit - For a read/write request if the cache entry is same as requested address, read/write request is served from cache
//  Cache Miss - For a read/write request if the cache entry is different than requested address, read/write request is served from main memory
//  Cache writeback - For a cache miss, the stored cache entry is written back to main memory and read/write request is stored into cache 
//	
///////////////////////////////////////////////////////////////////////////
module cache_mem (
  input        clk,
  input        rst_n,
  input        rd_en,
  input        wr_en,
  input  logic [4:0] addr  ,
  input  logic [7:0] data_in  ,
  output logic [7:0] data_out
     );

  typedef struct {
    logic [4:0] addr;
    logic [7:0] data;
  } tran_t;
  
  logic [7:0] memory [0:31];
  tran_t cache [0:3];
  int j;
  

  always @(posedge clk or negedge rst_n) begin
    if (rst_n==0) begin
      for(int i=0; i<32; i++)
        memory[i] <= 8'b0;
      for (int i=0; i<4; i++) begin
        cache[i].addr <= 5'b0;
        cache[i].data <= 8'b0;
      end
    end
    // Write
    else if ((wr_en==1) && (rd_en==0)) begin
      j = addr/8;
      // Cache Write Hit
      if (cache[j].addr == addr) begin
        // $display("Cache write hit: addr:%0d with data:%0h", cache[j].addr, data_in);
        // #1 cache[j].addr <= data_in; //bug
        #1 cache[j].data <= data_in;
      end
      // Cache Write Miss
      else begin
        // $display("Cache write miss");
        memory[cache[j].addr]=cache[j].data;
        // $display("Kicking out from cache entry [%0d] to mem addr: %0d with data: %0h", j, cache[j].addr, cache[j].data);
        
        #1 cache[j].addr <= addr;
        cache[j].data <= data_in;
        // $display("Write from mem to evacuated cache entry [%0d] addr: %0d with data: %0h", j, addr, data_in);
      end
    end 
    // Read
    else if ((wr_en==0) && (rd_en==1)) begin
      j = addr/8;
      #1 data_out <= memory[addr];
      // Cache Read Hit
      if (cache[j].addr == addr) begin
        // $display("Cache read hit: addr:%0d with data:%0h", cache[j].addr, cache[j].data);
       	#1 data_out <= cache[j].data;
      end
      // Cache Read Miss
      else begin
        // $display("Cache read miss");
        #1 data_out <= memory[addr];
        // $display("Reading directly from mem addr: %0d with data:%0h", addr, memory[addr]);

        memory[cache[j].addr]=cache[j].data;
        // $display("Kicking out from cache entry [%0d] to mem addr: %0d with data: %0h", j, cache[j].addr, cache[j].data);

        cache[j].addr <= addr;
        cache[j].data <= memory[addr];
        // $display("Write from mem to evacuated cache entry [%0d] addr: %0d with data: %0h", j, addr, memory[addr]);
      end 
    end
  end

endmodule
