///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


class short_packet_test extends base_test;

	`uvm_component_utils(short_packet_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", short_packet_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting short packet test",UVM_NONE)
	endtask : run_phase

endclass : short_packet_test



///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class short_packet_vsequence extends htax_base_vseq;

  `uvm_object_utils(short_packet_vsequence)

  rand int port;

  function new (string name = "short_packet_vsequence");
    super.new(name);
  endfunction : new

  task body();
		// Executing 10 TXNs on ports {0,1,2,3} randomly 
		// Packet length between 3 and 10, inclusive
    repeat(100) begin
		fork
			`uvm_do_on_with(req, p_sequencer.htax_seqr[0], {req.length inside {[3:10]};})
			`uvm_do_on_with(req, p_sequencer.htax_seqr[1], {req.length inside {[3:10]};})
			`uvm_do_on_with(req, p_sequencer.htax_seqr[2], {req.length inside {[3:10]};})
			`uvm_do_on_with(req, p_sequencer.htax_seqr[3], {req.length inside {[3:10]};})
		join
    end
  endtask : body

endclass : short_packet_vsequence
