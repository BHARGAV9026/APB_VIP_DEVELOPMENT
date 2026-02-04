class apb_slave_agent extends uvm_agent;
		`uvm_component_utils(apb_slave_agent);

		apb_slave_sequencer apb_slv_seqr;
		apb_slave_monitor apb_slv_mon;
		apb_slave_driver apb_slv_drv;
	        apb_slave_config apb_slv_cfgh;


		function new(string name="apb_slave_agent",uvm_component parent);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
                          apb_slv_cfgh=apb_slave_config::type_id::create("apb_slv_cfgh");

                              if(!uvm_config_db#(apb_slave_config)::get(this,"*","apb_slave_config",apb_slv_cfgh))
                                `uvm_fatal("APB_AGT_CFG","cannot get apb_slave_config in apb_slave_agent class")
                              apb_slv_mon = apb_slave_monitor::type_id::create("apb_slv_mon",this);
                      
                          if(apb_slv_cfgh.is_active == UVM_ACTIVE)
                            begin
				apb_slv_drv = apb_slave_driver::type_id::create("apb_slv_drv",this);
				apb_slv_seqr = apb_slave_sequencer::type_id::create("apb_slv_seqr",this);
                           end
		endfunction

		function void connect_phase(uvm_phase phase);
		           super.connect_phase(phase);
                          if(apb_slv_cfgh.is_active == UVM_ACTIVE)begin
                            apb_slv_drv.seq_item_port.connect(apb_slv_seqr.seq_item_export);
                          end
		endfunction

endclass


