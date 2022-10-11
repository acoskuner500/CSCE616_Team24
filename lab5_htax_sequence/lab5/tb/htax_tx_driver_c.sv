///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class htax_tx_driver_c extends uvm_driver #(htax_packet_c);

	parameter PORTS = `PORTS;
	parameter VC 		= `VC;
	parameter WIDTH = `WIDTH;
	
	`uvm_component_utils(htax_tx_driver_c)


	//Constructor
	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new


  //UVM build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	endfunction : build_phase

	//UVM run_phase	
  task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			drive_thru_dut(req);
			seq_item_port.item_done();
		end
	endtask : run_phase


	extern protected task drive_thru_dut(htax_packet_c pkt);
endclass : htax_tx_driver_c

task htax_tx_driver_c::drive_thru_dut(htax_packet_c pkt);

	`uvm_info (get_type_name(), $sformatf("Input Data Packet to DUT : \n%s", pkt.sprint()),UVM_NONE)
	`uvm_info (get_type_name(), $sformatf("Ended Driving Data Packet to DUT"), UVM_NONE)
endtask : drive_thru_dut	
