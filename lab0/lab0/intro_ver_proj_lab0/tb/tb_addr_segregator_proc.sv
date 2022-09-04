module tb_addr_segregator_proc;
    //parameters
    parameter ADDR_WID   = 32 ;
    parameter INDEX_MSB  = 19 ;
    parameter INDEX_LSB  = 2  ;
    parameter OFFSET_MSB = 1  ;
    parameter OFFSET_LSB = 0  ;
    parameter TAG_MSB    = 31 ;
    parameter TAG_LSB    = 20 ;

    // signal definition
    reg                              cmd_rd          ;
    reg                              cmd_wr          ;
    reg  [ADDR_WID - 1 : 0]          address         ;
    wire [INDEX_MSB    : INDEX_LSB]  index_proc      ;
    wire [TAG_MSB      : TAG_LSB]    tag_proc        ;
    wire [OFFSET_MSB   : OFFSET_LSB] blk_offset_proc ;

    // instantiation    
    addr_segregator_proc inst_addr_segregator_proc (
                            .cmd_rd          (cmd_rd),
                            .cmd_wr          (cmd_wr),
                            .address         (address),
                            .index_proc      (index_proc),
                            .tag_proc        (tag_proc),
                            .blk_offset_proc (blk_offset_proc)
                        );



    // simulation control                        
    initial begin 
        //testcase 1: no read or write requests
        cmd_rd = 1'b0;
        cmd_wr = 1'b0;
        address = 32'h2333_2333;
        
        //testcase 2: read requests
        #10 cmd_rd = 1'b1;
            cmd_wr = 1'b0;
            address = 32'hFFFF_0000;
        
        //testcase 3: write requests
        #10 cmd_rd = 1'b0;
            cmd_wr = 1'b1;
            address = 32'hABCD_DCBA;
        
        // write more testcases

      
        #10 $finish;
    end                    
                        
                        


                              
endmodule

