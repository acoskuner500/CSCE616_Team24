    +access+rwc                   //allow probes to record signals
    -timescale 1ns/1ps            //set simulation time precision
//    -gui                          //launch user interface
    -input waves.tcl

//setup UVM home
    -uvmhome $UVMHOME

//UVM options
    +UVM_VERBOSITY=UVM_LOW

//file list containing design and TB files to compiled
    -f file_list.f
