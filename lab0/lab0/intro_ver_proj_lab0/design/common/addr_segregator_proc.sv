//=====================================================================
// Project : 4 core MESI cache design
// File Name : addr_segregator_proc.sv
// Description : divide address into different parts
//=====================================================================
// Notable Change History:
// Date By   Version Change Description
// 2016/4/2  1.0     Initial Release
// 2016/8/29 tmp1    For tool demo lab
//=====================================================================

module addr_segregator_proc #(
                              parameter ADDR_WID   = 32 ,
                              parameter INDEX_MSB  = 19 ,
                              parameter INDEX_LSB  = 2  ,
                              parameter OFFSET_MSB = 1  ,
                              parameter OFFSET_LSB = 0  ,
                              parameter TAG_MSB    = 31 ,
                              parameter TAG_LSB    = 20
                            
                              )(
                              input                                  cmd_rd          ,
                              input                                  cmd_wr          ,
                              input      [ADDR_WID - 1 : 0]          address         ,
                              output reg [INDEX_MSB    : INDEX_LSB]  index_proc      ,
                              output reg [TAG_MSB      : TAG_LSB]    tag_proc        ,
                              output reg [OFFSET_MSB   : OFFSET_LSB] blk_offset_proc 
                              );
    reg [ADDR_WID - 1 : 0] zeros = 0;
    
    always @ * begin 
        if(cmd_rd || cmd_wr) begin 
            index_proc      = address[INDEX_MSB : INDEX_LSB];
            tag_proc        = address[TAG_MSB : TAG_LSB];
            blk_offset_proc = address[OFFSET_MSB : OFFSET_LSB];
        end
        else begin 
            index_proc      = zeros[INDEX_MSB : INDEX_LSB];
            tag_proc        = zeros[TAG_MSB : TAG_LSB];
          blk_offset_proc = zeros[OFFSET_MSB : OFFSET_LSB];
      end
  end
             
endmodule
