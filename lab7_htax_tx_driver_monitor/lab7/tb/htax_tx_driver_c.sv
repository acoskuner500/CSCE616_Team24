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

	virtual interface htax_tx_interface htax_tx_intf;

	//Constructor
	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new


  //UVM build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		if(!uvm_config_db#(virtual htax_tx_interface)::get(this,"","tx_vif",htax_tx_intf))
			`uvm_fatal("NO_TX_VIF",{"Virtual Interface needs to be set for ", get_full_name(),".tx_vif"})
	endfunction : build_phase

	//UVM run_phase	
  task run_phase(uvm_phase phase);
			rst_dut_and_signal();							//Reset the interface signals
		forever begin												//Till end of test
			seq_item_port.get_next_item(req);	//Get next pkt from sequencer
			drive_thru_dut(req);							//Drive pkt to DUT via interface
			seq_item_port.item_done();				//Sends ACK to sequencer
		end
	endtask : run_phase

	task rst_dut_and_signal();
		@(negedge htax_tx_intf.rst_n);
		`uvm_info("TOP", "Resetting the DUT synchronously", UVM_NONE)
		@(posedge htax_tx_intf.clk)
		htax_tx_intf.tx_outport_req  = 'b0;
  	htax_tx_intf.tx_vc_req       = 'b0;
  	htax_tx_intf.tx_sot          = 'b0;
  	htax_tx_intf.tx_release_gnt  = 'b0;
  	htax_tx_intf.tx_eot          = 'b0;
	endtask : rst_dut_and_signal

	extern protected task drive_thru_dut(htax_packet_c pkt);
endclass : htax_tx_driver_c

//TO DO : COMPLETE THE DRIVER CODE BELOW
task htax_tx_driver_c::drive_thru_dut(htax_packet_c pkt);

	`uvm_info (get_type_name(), $sformatf("Input Data Packet to DUT : \n%s", pkt.sprint()),UVM_NONE)

	//Wait for pkt.delay clock cycles
	repeat (pkt.delay) @(posedge htax_tx_intf.clk);
	
	//On next clk-posedge 
	//TO DO : Set htax_tx_intf.tx_outport_req in one-hot fashion from pkt.dest_port
	//TO DO : Assign htax_tx_intf.tx_vc_req from pkt.vc
	@(posedge htax_tx_intf.clk)




	//TO DO : Wait till htax_tx_intf.tx_vc_gnt is received



	//On next clk-posedge
	//TO DO : Set any one bit tx_sot[vc-1:0] to 1 from the ones granted by htax_tx_intf.tx_vc_gnt 
	//				(refer to SPEC doc for more details)
	//TO DO : Drive pkt.data[0] on htax_tx_intf.tx_data
	//TO DO : Reset htax_tx_intf.tx_outport_req and htax_tx_intf.tx_vc_req (to zero)
	@(posedge htax_tx_intf.clk)





	//TO DO : On consecutive clk-posedges drive each of the packet's pkt.data on htax_tx_intf.tx_data
	//TO DO : Assign htax_tx_intf.tx_sot to zero after first cycle
	//TO DO : Assert htax_tx_intf.tx_release_gnt for one clock cycle when driving second last data packet
	//TO DO : Assert htax_tx_intf.tx_eot for one clock cycle when driving last data packet
	for(int i=XXX; i < YYY; i++) begin  //TO DO : Replace XXX and YYY with appropriate values for a packet
		@(posedge htax_tx_intf.clk)




	end

	//On next clk-posedge
	//TO DO : Assign htax_tx_intf.tx_data to X and htax_tx_intf.tx_eot to zero
	@(posedge htax_tx_intf.clk)



	`uvm_info (get_type_name(), $sformatf("Ended Driving Data Packet to DUT"), UVM_NONE)
endtask : drive_thru_dut	
