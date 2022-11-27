///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


class simple_port_port_test extends base_test;

	`uvm_component_utils(simple_port_port_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", simple_port_port_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting simple port-port test",UVM_NONE)
	endtask : run_phase

endclass : simple_port_port_test



///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class simple_port_port_vsequence extends htax_base_vseq;

  `uvm_object_utils(simple_random_vsequence)

  function new (string name = "simple_port_port_vsequence");
    super.new(name);
  endfunction : new

  task body();
		// Exectuing 10 TXNs on fixed port {0,1,2,3} 
    repeat(100) begin
		fork
			`uvm_do_on_with(req, p_sequencer.htax_seqr[0], {req.dest_port==0;})
			`uvm_do_on_with(req, p_sequencer.htax_seqr[1], {req.dest_port==1;})
			`uvm_do_on_with(req, p_sequencer.htax_seqr[2], {req.dest_port==2;})
			`uvm_do_on_with(req, p_sequencer.htax_seqr[3], {req.dest_port==3;})
		join
    end
  endtask : body

endclass : simple_port_port_vsequence
