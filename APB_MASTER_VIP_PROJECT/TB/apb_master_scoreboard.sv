class apb_master_scoreboard extends uvm_scoreboard;
`uvm_component_utils(apb_master_scoreboard)
 apb_master_config apb_master_cfgh;

//uvm_tlm_analysis_fifo #(apb_master_transaction) apb_drv_fifo;
uvm_tlm_analysis_fifo #(apb_master_transaction) apb_mon_fifo;

apb_master_transaction apb_txn;

covergroup apb_master_cg;
		option.per_instance = 1;
		PADDR : coverpoint apb_txn.paddr{bins valid_addr={[32'h0000_0000:32'h0000_00ff]};
                                                     bins invalid_addr={[32'h000_0100:32'hffff_ffff]};}
                                            						
		PSELx : coverpoint  apb_txn.pselx{bins high={1};
                                                      //bins low={0};
                                                        }
                                                     
                                                     					        	
                PWRITE : coverpoint apb_txn.pwrite{bins read={0};
                                                       bins write={1};}

                PENABLE : coverpoint apb_txn.penable{bins high={1};
                                                         //bins low={0};
                                                         }
                                                         
                
                PSLVERR : coverpoint apb_txn.pslverr{bins err={1};
                                                         bins no_err={0};}

                PREADY : coverpoint apb_txn.pready{bins high={1};}
                                                      


                PWDATA  : coverpoint apb_txn.pwdata{bins Pwdata1={[32'h0000_0000:32'h3fff_ffff]};
                                                        bins Pwdata2={[32'h4000_0000:32'h7fff_ffff]};
                                                        bins Pwdata3={[32'h8000_0000:32'hbfff_ffff]};
                                                        bins Pwdata4={[32'hc000_0000:32'hffff_ffff]};}

                PRDATA  : coverpoint apb_txn.prdata{bins Prdata1={[32'h0000_0000:32'h3fff_ffff]};
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


function new(string name="apb_master_scoreboard", uvm_component parent);
	super.new(name,parent);
        apb_mon_fifo=new("apb_mon_fifo");
       // apb_drv_fifo=new("apb_drv_fifo");
        apb_master_cg = new();
 endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
           if(!uvm_config_db #(apb_master_config)::get(this, "*", "apb_master_config", apb_master_cfgh))begin
               `uvm_fatal(get_full_name, "configuration not get properly in APB_ENV")
           end
endfunction

task run_phase(uvm_phase phase);
 
`uvm_info(get_full_name(), "entering into scoreboard run_phase", UVM_MEDIUM);
//apb_txn=apb_master_transaction::type_id::create("apb_txn");
apb_txn=apb_master_transaction::type_id::create("apb_txn");
   fork
      begin
        forever 
            begin
                apb_mon_fifo.get(apb_txn);
                if(apb_master_cfgh.enable_coverage)
                  begin
                    apb_master_cg.sample();
                  end
               mem_read_write(apb_txn);
	      check_data(apb_txn);
           end
     end
  
   join

endtask


bit[`DATA_WIDTH-1:0]mem[255:0];
bit[`DATA_WIDTH-1:0] pref;
bit pslv_expected;

task mem_read_write(apb_master_transaction apb_txn);

if(apb_txn.pwrite) begin
`uvm_info(get_full_name(), "entered into mem_write task", UVM_MEDIUM);
 mem[apb_txn.paddr]=apb_txn.pwdata;
end

else begin
    	if(apb_txn.paddr<=255)
          begin
             pref=mem[apb_txn.paddr];
	     pslv_expected=0;
          end
        else
          pslv_expected=1;
      end
endtask

task check_data(apb_master_transaction apb_txn);
    if(apb_txn.pwrite===0) 
     begin
       if(pref===apb_txn.prdata)begin
         `uvm_info(get_full_name(),"************data matched************", UVM_MEDIUM)
          $display("PREF =%0h, prdata=%0h",pref,apb_txn.prdata);
        end
       else begin
         `uvm_info(get_full_name(),"************data mismatched**********", UVM_MEDIUM)
         $display("PREF =%0h, prdata=%0h",pref,apb_txn.prdata);
       end
      
       if(pslv_expected===apb_txn.pslverr)begin
	if(apb_txn.pslverr===0) begin
         `uvm_info(get_full_name(),"************error matched and it is zero*************", UVM_MEDIUM)
          $display("PSLV_EXP =%0d, pslverr=%0d",pslv_expected,apb_txn.pslverr);
	end
	else begin
		`uvm_info(get_full_name(),"************error matched and it is one*************", UVM_MEDIUM)
          	$display("PSLV_EXP =%0d, pslverr=%0d",pslv_expected,apb_txn.pslverr); 
        end
     end
 end
	 else
     `uvm_info(get_full_name(),"*************SCOREBOARD (not applicable for WRITES)**********", UVM_MEDIUM)

       endtask

endclass




  



