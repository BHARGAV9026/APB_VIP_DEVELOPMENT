class apb_slave_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(apb_slave_scoreboard);
	 uvm_tlm_analysis_fifo#(apb_slave_transaction) scb_imp;	
         apb_slave_transaction tr;
         apb_slave_config apb_slv_cfgh;


        // virtual apb_interface vif;
         bit PSLVERR_EXP;
         bit [`DATA_WIDTH-1:0]mem[bit[`ADDR_WIDTH-1:0]];

     covergroup apb_slave_cg;
		PADDR   : coverpoint tr.PADDR{ bins valid_addr={[32'h0000_0000:32'h0000_00ff]};
                                               bins invalid_addr={[32'h000_0100:32'hffff_ffff]};}


		PWRITE  : coverpoint tr.PWRITE{ bins read = {0};
						bins write = {1};}

		PSELx   : coverpoint tr.PSELx{ bins b1 = {1};
                                              // bins b0 = {0};
                                              }

                PENABLE : coverpoint tr.PENABLE{ bins b1 = {1};
                                                // bins b0 = {0};
                                                }

		PREADY  : coverpoint tr.PREADY{ bins high={1};
                                                //bins  low={0};
                                                 }
		
                PSLVERR : coverpoint tr.PSLVERR{ bins err={1};
                                                 bins no_err={0};}

	        PWDATA  : coverpoint tr.PWDATA{ bins Pwdata1={[32'h0000_0000:32'h3fff_ffff]};
                                                bins Pwdata2={[32'h4000_0000:32'h7fff_ffff]};
                                                bins Pwdata3={[32'h8000_0000:32'hbfff_ffff]};
                                                bins Pwdata4={[32'hc000_0000:32'hffff_ffff]};}
									

		PRDATA : coverpoint tr.PRDATA{   bins Prdata1={[32'h0000_0000:32'h3fff_ffff]};
                                                 bins Prdata2={[32'h4000_0000:32'h7fff_ffff]};
                                                 bins Prdata3={[32'h8000_0000:32'hbfff_ffff]};
                                                 bins Prdata4={[32'hc000_0000:32'hffff_ffff]};}

		CR_PADDR_PWRITE      : cross PADDR, PWRITE;
                CR_PSELx_PENABLE     : cross PSELx, PENABLE;
                CR_PENABLE_PREADY    : cross PENABLE, PREADY;

                CR_PWRITE_PSLVERR    : cross PWRITE, PSLVERR{
                                          //illegal to check pslverr for writes
                                          illegal_bins no_slv_err= binsof(PWRITE.write) && binsof(PSLVERR.err);}

                CR_PWRITE_PWDATA     : cross PWRITE, PWDATA{
                                         //ignore pwdata,when control is read operation
                                          ignore_bins no_read=
                                           binsof(PWRITE.read)&& 
                                          (binsof(PWDATA.Pwdata1)||
                                           binsof(PWDATA.Pwdata2)||
                                           binsof(PWDATA.Pwdata3)||
                                           binsof(PWDATA.Pwdata4));}

                CR_PWRITE_PRDATA     : cross PWRITE, PRDATA{
                                        //ignore prdata,when control is write operation
                                           ignore_bins no_write=
                                            binsof(PWRITE.write)&& 
                                           (binsof(PRDATA.Prdata1)||
                                            binsof(PRDATA.Prdata2)||
                                            binsof(PRDATA.Prdata3)||
                                            binsof(PRDATA.Prdata4));}

                CR_PADDR_PSLVERR     : cross PADDR, PSLVERR{
                                         //illegal when pslverr=1 for legal/valid paddr 
                                           illegal_bins no_err_vld_addr=
                                            binsof(PADDR.valid_addr) && binsof(PSLVERR.err);}

                CR_PADDR_PWRITE_PSLVERR : cross PADDR, PWRITE, PSLVERR{
                                           //illegal to check pslverr for writes
                                            illegal_bins comb1=binsof(PADDR.invalid_addr) && binsof(PWRITE.write) && binsof(PSLVERR.err);

                                           //illegal when pslverr=0 for illegal/invalid paddr during reads
                                            illegal_bins comb2=binsof(PADDR.invalid_addr) && binsof(PWRITE.read) && binsof(PSLVERR.no_err);

                                           //ilegal when pslverr=1 for legal/valid paddr(during either write or read)
                                            illegal_bins comb3=binsof(PADDR.valid_addr)  && binsof(PSLVERR.err);}
                                           	
	        CR_PADDR_PWRITE_PREADY  : cross PADDR, PWRITE, PREADY;          
      endgroup

    function new(string name,uvm_component parent);
	 super.new(name,parent);
         apb_slave_cg=new();
    endfunction
   
    function void build_phase(uvm_phase phase);
         super.build_phase(phase);
         scb_imp = new("scb_imp",this); 
         tr =apb_slave_transaction::type_id::create("tr");
	if(!uvm_config_db #(apb_slave_config)::get(this,"","apb_slave_config",apb_slv_cfgh)) 
          begin
            `uvm_fatal("APB_AGT_CFG","cannot get apb_slave_config in apb_driver class")
	  end
    endfunction
            
               
  // -------------------------------------------------
  // Run phase
  // -------------------------------------------------
    task run_phase(uvm_phase phase);
	  forever begin
                 scb_imp.get(tr);
                 if(apb_slv_cfgh.enable_coverage)
                    begin
                       apb_slave_cg.sample();
                    end
                 check_tr(tr);
           end
     endtask 

    task check_tr(apb_slave_transaction tr);

              // Only check *completed* APB transfers
                if (!(tr.PSELx && tr.PENABLE && tr.PREADY)) begin
                  `uvm_info(get_type_name(), $sformatf("Ignoring partial APB cycle: PSELx=%0b PENABLE=%0b PREADY=%0b transfer=%0b", tr.PSELx, tr.PENABLE, tr.PREADY, tr.transfer),UVM_LOW)
                   return;
                 end

              // ======================= WRITE ======================= //
                if (tr.READ_WRITE)
                  begin

                      // 1) Check master address path: PADDR vs apb_write_paddr
                             if (tr.PADDR !== tr.apb_write_paddr) begin
                                `uvm_error(get_type_name(),$sformatf("WRITE ADDR MISMATCH: bus PADDR=0x%0h, apb_write_paddr=0x%0h",tr.PADDR, tr.apb_write_paddr))
                              end
                            else begin
                               `uvm_info(get_type_name(),$sformatf("WRITE ADDR OK: PADDR=0x%0h, apb_write_paddr=0x%0h", tr.PADDR, tr.apb_write_paddr),UVM_LOW)
                               end
  
                     // 2) Check master write data path: PWDATA vs apb_write_data
                             if (tr.PWDATA !== tr.apb_write_data) begin
                               `uvm_error(get_type_name(), $sformatf("WRITE DATA MISMATCH: bus PWDATA=0x%0h, apb_write_data=0x%0h",tr.PWDATA, tr.apb_write_data))
                             end
                             else begin
                              `uvm_info(get_type_name(),$sformatf("WRITE DATA OK: PWDATA=0x%0h, apb_write_data=0x%0h", tr.PWDATA,tr.apb_write_data),UVM_LOW)
                             end
                       // 3) NO PSLVERR checking for WRITE 
                               // Just update reference memory
                              mem[tr.PADDR] = tr.PWDATA;
                end

            // ===================== READ ============================//
             else
                begin
                   // 1) Check master address path: PADDR vs apb_read_paddr
                    if (tr.PADDR !== tr.apb_read_paddr) begin
                      `uvm_error(get_type_name(), $sformatf("READ ADDR MISMATCH: bus PADDR=0x%0h, apb_read_paddr=0x%0h",tr.PADDR, tr.apb_read_paddr))
                    end
                    else begin
                     `uvm_info(get_type_name(), $sformatf("READ ADDR OK: PADDR=0x%0h, apb_read_paddr=0x%0h", tr.PADDR,tr.apb_read_paddr),UVM_LOW)
                     end


                  // 2) Data path check: PRDATA (slave) -> apb_read_data_out (master)
                    if (tr.apb_read_data_out !== tr.PRDATA) begin
                        `uvm_error(get_type_name(), $sformatf("READ DATA PATH FAIL: apb_read_data_out=0x%0h, PRDATA=0x%0h",tr.apb_read_data_out, tr.PRDATA))
                    end
                    else begin
                       `uvm_info(get_type_name(), $sformatf("READ DATA PATH OK: PRDATA=0x%0h,apb_read_data_out=0x%0h",tr.PRDATA,tr.apb_read_data_out), UVM_LOW)
                    end


                 // 3) Functional readback using ONLY associative memory
                    if (mem.exists(tr.PADDR))
                     begin
                       if (tr.apb_read_data_out !== mem[tr.PADDR]) begin
                          `uvm_error(get_type_name(),$sformatf("READBACK MISMATCH: addr=0x%0h, exp=0x%0h, act=0x%0h",tr.PADDR, mem[tr.PADDR], tr.apb_read_data_out))
                       end
                       else begin
                          `uvm_info(get_type_name(),$sformatf("READBACK OK: addr=0x%0h, data=0x%0h",tr.PADDR, tr.apb_read_data_out),UVM_LOW)
                       end
                     end
         
                   else
                      begin
                        // No prior write to this address
                         `uvm_info(get_type_name(), $sformatf("READ from addr 0x%0h with no prior write; skipping mem check.",tr.PADDR), UVM_LOW)
                      end

                // 4) Invalid address: expect PSLVERR=1 (Not Mandatory to verify MASTER as DUT, but to check the Slave VIP )
                   
                    if(tr.PADDR <= apb_slv_cfgh.legal_addr)
                        PSLVERR_EXP = 0;
                    else
                        PSLVERR_EXP = 1;
                 
                   
                    if (tr.PSLVERR === PSLVERR_EXP) begin
                     `uvm_info(get_type_name(), $sformatf("READ: PSLVERR MATCHED : PSLVERR_EXP=%0d, PSLVERR = %0d", PSLVERR_EXP, tr.PSLVERR),UVM_LOW)
                    end
              
                   else begin
                    `uvm_error(get_type_name(), $sformatf("READ: PSLVERR MISMATCHED :PSLVERR_EXP=%0d, PSLVERR = %0d", PSLVERR_EXP, tr.PSLVERR))
                   end
             end
      endtask
endclass



