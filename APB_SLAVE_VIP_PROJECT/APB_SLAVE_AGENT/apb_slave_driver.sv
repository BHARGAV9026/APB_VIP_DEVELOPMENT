class apb_slave_driver extends uvm_driver#(apb_slave_transaction);
		`uvm_component_utils(apb_slave_driver);

                virtual apb_interface intfh;
		apb_slave_config apb_slv_cfgh;

		function new(string name="apb_slave_driver",uvm_component parent);
	        	super.new(name,parent);
		endfunction

		
		function void build_phase(uvm_phase phase);
				super.build_phase(phase);
                                 apb_slv_cfgh=apb_slave_config::type_id::create("apb_slv_cfgh");

				if(!uvm_config_db #(apb_slave_config)::get(this,"","apb_slave_config",apb_slv_cfgh)) begin
			           `uvm_fatal("APB_AGT_CFG","cannot get apb_slave_config in apb_slave_driver class")
			 	end
		endfunction
                  
                function void connect_phase(uvm_phase phase);
                    intfh=apb_slv_cfgh.vif;
                 endfunction

	    task run_phase (uvm_phase phase);
                   @(intfh.driver_cb);
                    intfh.PRESETn<=1'b0;
                  @(intfh.driver_cb);
                    intfh.PRESETn<=1'b1;
                               forever  begin
                                   	seq_item_port.get_next_item(req);
                                          driver_logic(req);
					seq_item_port.item_done();
                                end
	   	endtask

		task driver_logic(apb_slave_transaction req);
				//@(intfh.driver_cb);
			//	intfh.driver_cb.transfer <= req.transfer;
                                intfh.driver_cb.transfer <= 1;
				intfh.driver_cb.PREADY   <= 0;
				intfh.driver_cb.READ_WRITE <= req.READ_WRITE;

                                apb_slv_cfgh.agt_cfg_randomize();
                                
				if(req.READ_WRITE) begin                                               
						intfh.driver_cb.apb_write_paddr <= req.apb_write_paddr;
						intfh.driver_cb.apb_write_data  <= req.apb_write_data;
                                                
						wait(intfh.PENABLE == 1);
                                                   intfh.driver_cb.transfer <=0;
                                                   req.PSELx <= intfh.PSELx;
                                                   req.PENABLE <= intfh.PENABLE;
                                                   req.PWRITE <= intfh.PWRITE;

                                                if(apb_slv_cfgh.enable_wait_states)begin
                                                  repeat(apb_slv_cfgh.MAX_WAIT)
                                                    @(posedge intfh.PCLK);
                                                       intfh.driver_cb.PREADY <=1;
                                                 end                                                
                                                 else begin
                                                  intfh.driver_cb.PREADY <= 1;
                                                 end
                                               

						@(posedge intfh.PCLK)
					          intfh.driver_cb.PREADY <= 0;
				end
				else begin

                                          if(apb_slv_cfgh.inject_addr_error==1)
                                               	intfh.driver_cb.apb_read_paddr <= apb_slv_cfgh.illegal_addr;
                                          else
						intfh.driver_cb.apb_read_paddr <= req.apb_read_paddr;
                                                
					        wait(intfh.PENABLE == 1);
                                                  intfh.driver_cb.transfer <= 0;

                                                  req.PENABLE <= intfh.PENABLE;
                                                  req.PSELx <= intfh.PSELx;
                                                   req.PWRITE <= intfh.PWRITE;

                                                if(apb_slv_cfgh.enable_wait_states)begin
                                                  repeat(apb_slv_cfgh.MAX_WAIT)
                                                    @(posedge intfh.PCLK);
                                                       intfh.driver_cb.PREADY <=1;
                                                end
                                                
                                                else begin
                                                  intfh.driver_cb.PREADY <= 1;
                                                 end
                                                  intfh.driver_cb.PRDATA <= req.PRDATA;
                                                  
                                                   // if(intfh.PADDR <= `VALID_ADDR)
                                                   if(intfh.PADDR <= apb_slv_cfgh.legal_addr)
                                                       intfh.driver_cb.PSLVERR <= 0;
                                                   else
                                                       intfh.driver_cb.PSLVERR <= 1;

					       	@(posedge intfh.PCLK)
						       intfh.driver_cb.PREADY <= 0;
                                                       intfh.driver_cb.PRDATA <= 0;
                                                       intfh.driver_cb.PSLVERR <= 0;
				end
						
                    `uvm_info(get_type_name(),$sformatf("Printing from APB_SLAVE_DRIVER: %s",req.sprint()),UVM_LOW)
		endtask


endclass

