///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

//Base sequence 
class htax_base_seq extends uvm_sequence #(htax_packet_c); //HTAX packet class is passed as parameter

  parameter PORTS = `PORTS;
  parameter VC    = `VC;
  parameter WIDTH = `WIDTH;

	//Factory Registration
	`uvm_object_utils(htax_base_seq)

	//Constructor
	function new ( string name = "htax_base_seq");
		super.new(name);
	endfunction : new

endclass : htax_base_seq

//Sequence 1
//Fix Destination Port Sequence extends from base sequence
class fix_dest_port_seq extends htax_base_seq;

	//Factory Registration
	`uvm_object_utils(fix_dest_port_seq)

	//Constructor
	function new ( string name = "fix_dest_port_seq");
    super.new(name);
  endfunction : new

	//Body task -- 
	virtual task body();
		int i;
		i=$urandom_range(0,3);
		`uvm_info(get_type_name(),"Executing fix destination port sequence with 5 transactions", UVM_NONE)
		//Generate a sequence with 5 packets
		repeat(5) begin
			`uvm_do_with (req, {req.dest_port==i;}) //fix dest_port 
		end
	endtask

endclass : fix_dest_port_seq


//TO DO - Sequence 2
//Short Packet Sequence extends from base sequence

//TO DO - Sequence 3
//Long Packet Short Delay Sequence extends from base sequence

//TO DO - Sequence 4
//Medium Packet fix VC Sequence extends from base sequence

//TO DO - Sequence 5
//True Random VC Sequence extends from base sequence
