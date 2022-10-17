///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class htax_env extends uvm_env;

	`uvm_component_utils(htax_env)

	htax_tx_agent_c tx_port[0:3];

	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		tx_port[0] = htax_tx_agent_c::type_id::create("tx_port[0]",this);
		tx_port[1] = htax_tx_agent_c::type_id::create("tx_port[1]",this);
		tx_port[2] = htax_tx_agent_c::type_id::create("tx_port[2]",this);
		tx_port[3] = htax_tx_agent_c::type_id::create("tx_port[3]",this);
	endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	endfunction : connect_phase

endclass : htax_env
