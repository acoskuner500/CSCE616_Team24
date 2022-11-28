///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


class long_packet_test extends base_test;

	`uvm_component_utils(long_packet_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", long_packet_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting long packet test",UVM_NONE)
	endtask : run_phase

endclass : long_packet_test



///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class long_packet_vsequence extends htax_base_vseq;

  `uvm_object_utils(long_packet_vsequence)

  rand int port;

  function new (string name = "long_packet_vsequence");
    super.new(name);
  endfunction : new

  task body();
		// Executing 10 TXNs on ports {0,1,2,3} randomly 
		// Packet length between 36 and 60, inclusive
    repeat(100) begin
		// fork
			`uvm_do_on_with(req, p_sequencer.htax_seqr[0], {req.length inside {[36:60]};})
			`uvm_do_on_with(req, p_sequencer.htax_seqr[1], {req.length inside {[36:60]};})
			`uvm_do_on_with(req, p_sequencer.htax_seqr[2], {req.length inside {[36:60]};})
			`uvm_do_on_with(req, p_sequencer.htax_seqr[3], {req.length inside {[36:60]};})
		// join
    end
  endtask : body

endclass : long_packet_vsequence
