///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class base_test extends uvm_test;

	uvm_cmdline_processor clp;

	//component macro
  `uvm_component_utils(base_test)

	//Constructor
  function new(string name, uvm_component parent);
      super.new(name, parent);
      clp = uvm_cmdline_processor::get_inst();
  endfunction : new

	//Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction : build_phase 

	function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.phase_done.set_drain_time(this, 500us);
	endtask : run_phase

endclass : base_test
