class htax_tx_monitor_c extends uvm_monitor;
	
	parameter PORTS = `PORTS;	

	`uvm_component_utils(htax_tx_monitor_c)

	uvm_analysis_port #(htax_tx_mon_packet_c)	tx_collect_port;
	
	virtual interface htax_tx_interface htax_tx_intf;
	htax_tx_mon_packet_c tx_mon_packet;
	int pkt_len;
		
	//constructor
	function new (string name, uvm_component parent);
		super.new(name,parent);
		tx_collect_port = new("tx_collect_port",this);
		tx_mon_packet 	= new();
	endfunction : new

  //UVM build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		if(!uvm_config_db#(virtual htax_tx_interface)::get(this,"","tx_vif",htax_tx_intf))
			`uvm_fatal("NO_TX_VIF",{"Virtual Interface needs to be set for ", get_full_name(),".tx_vif"})
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			pkt_len=0;
			
			//Assign tx_mon_packet.dest_port from htax_tx_intf.tx_outport_req
			@(posedge |htax_tx_intf.tx_vc_gnt) begin
				for(int i=0; i < PORTS; i++)
					if(htax_tx_intf.tx_outport_req[i]==1'b1)
						tx_mon_packet.dest_port = i;
			end		
					
			@(posedge htax_tx_intf.clk)
			//On consequtive cycles append htax_tx_intf.tx_data to tx_mon_packet.data[] till htax_tx_intf.tx_eot pulse
			while(htax_tx_intf.tx_eot==0) begin
					@(posedge htax_tx_intf.clk)
					tx_mon_packet.data = new[++pkt_len] (tx_mon_packet.data);
					tx_mon_packet.data[pkt_len-1]=htax_tx_intf.tx_data;
			end
			tx_collect_port.write(tx_mon_packet);
		end
	endtask : run_phase

endclass : htax_tx_monitor_c
