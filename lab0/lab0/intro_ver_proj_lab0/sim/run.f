    +access+rwc                   //allow probes to record signals
    -timescale 1ns/1ns            //set simulation time precision
    -gui                          //launch user interface  

                                  //include directories
    -incdir ../design/common

                                  //compile design files 
    ../design/common/addr_segregator_proc.sv

                                   //compile testbench files
    ../tb/tb_addr_segregator_proc.sv
