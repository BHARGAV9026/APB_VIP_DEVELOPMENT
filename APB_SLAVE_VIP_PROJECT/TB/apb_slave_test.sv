class apb_slave_test extends uvm_test;
		`uvm_component_utils(apb_slave_test)

		apb_slave_environment apb_slv_env;

		apb_slave_sequence apb_slv_seq;
                
                apb_slave_config apb_slv_cfgh;

	function new(string name,uvm_component parent);
			super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
               super.build_phase(phase);
                       apb_slv_cfgh=apb_slave_config::type_id::create("apb_slv_cfgh");

                       if(!uvm_config_db #(virtual apb_interface)::get(this,"*","intf1",apb_slv_cfgh.vif))
                           `uvm_fatal("APB_IF","cannot get() apb_if into apb_slave_config")

                        uvm_config_db#(apb_slave_config)::set(this,"*","apb_slave_config",apb_slv_cfgh);
                 
			apb_slv_env = apb_slave_environment::type_id::create("apb_slv_env",this);
			apb_slv_seq = apb_slave_sequence::type_id::create("apb_slv_seq",this);
	endfunction

	 function void end_of_elaboration_phase(uvm_phase phase);
            uvm_top.print_topology();
         endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
                         `uvm_info("apb_slave_test","run_phase",UVM_NONE);
		          apb_slv_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
			phase.phase_done.set_drain_time(this,200);
	 	phase.drop_objection(this);
	endtask
endclass

 
//*****************************Single write test***************************************************************
 
class master_wr_test extends apb_slave_test;
    `uvm_component_utils(master_wr_test)
    master_wr_seq wr_seq;
 
    function new(string name="master_wr_test",uvm_component parent);
       super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       wr_seq=master_wr_seq::type_id::create("wr_seq");
     endfunction

     task run_phase(uvm_phase phase);
      phase.raise_objection(this);
           wr_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
           phase.phase_done.set_drain_time(this,20);
      phase.drop_objection(this);
     endtask
endclass
 
//***************************Single read test ****************************************************************
 
class master_rd_test extends apb_slave_test;
    `uvm_component_utils(master_rd_test)
    master_rd_seq rd_seq;
 
    function new(string name="master_rd_test",uvm_component parent);
       super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       rd_seq=master_rd_seq::type_id::create("rd_seq");
     endfunction

     task run_phase(uvm_phase phase);
      phase.raise_objection(this);
          rd_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
          phase.phase_done.set_drain_time(this,20);
      phase.drop_objection(this);
     endtask

endclass
 
 //********************************SINGLE WRITE_READ ****************************************************************
 
class master_wr_rd_test extends apb_slave_test;
    `uvm_component_utils(master_wr_rd_test)
     master_rd_wr_seq wr_rd_seq;
 
    function new(string name="master_wr_rd_test",uvm_component parent);
       super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
     endfunction

     task run_phase(uvm_phase phase);
            wr_rd_seq= master_rd_wr_seq::type_id::create("wr_rd_seq");
            phase.raise_objection(this);
              wr_rd_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
              phase.phase_done.set_drain_time(this,20);
           phase.drop_objection(this);
     endtask 

endclass


//*****************************************BACK TO BACK WRITE *******************************************************************
 
class master_cont_wr_test extends apb_slave_test;
    `uvm_component_utils(master_cont_wr_test)
    master_cont_wr_seq cont_wr_seq;
 
    function new(string name="master_cont_wr_test",uvm_component parent);
       super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       cont_wr_seq=master_cont_wr_seq::type_id::create("cont_wr_seq");
     endfunction
     task run_phase(uvm_phase phase);
      phase.raise_objection(this);
           cont_wr_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
           phase.phase_done.set_drain_time(this,20);
      phase.drop_objection(this);
     endtask
endclass
 
//***************************************BACK TO BACK READ **************************************************************************
 
class master_cont_rd_test extends apb_slave_test;
    `uvm_component_utils(master_cont_rd_test)
    master_cont_rd_seq cont_rd_seq;
 
    function new(string name="master_cont_rd_test",uvm_component parent);
       super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       cont_rd_seq=master_cont_rd_seq::type_id::create("cont_rd_seq");
     endfunction
 
     task run_phase(uvm_phase phase);
      phase.raise_objection(this);
           cont_rd_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
         phase.phase_done.set_drain_time(this,20);
      phase.drop_objection(this);
     endtask
endclass
  
//**************************************N WRITE N READ [with same ADDR and DATA]**********************************************************************************
 
class master_n_wr_rd_test extends apb_slave_test;
    `uvm_component_utils(master_n_wr_rd_test)
     master_same_wr_rd_seq same_wr_rd_seq;

      function new(string name="master_n_wr_rd_test",uvm_component parent);
       super.new(name,parent);
      endfunction

     function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       same_wr_rd_seq= master_same_wr_rd_seq::type_id::create("same_wr_rd_seq");
     endfunction

     task run_phase(uvm_phase phase);
        phase.raise_objection(this);
           same_wr_rd_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
          phase.phase_done.set_drain_time(this,20);
	phase.drop_objection(this);
     endtask 

endclass  


//******************************toggle transfer test ********************************************/
class toggle_transfer_test extends apb_slave_test;
    `uvm_component_utils(toggle_transfer_test)
     toggle_transfer_seq tgl_trans_seq;
 
    function new(string name="toggle_transfer_test",uvm_component parent);
       super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       tgl_trans_seq = toggle_transfer_seq::type_id::create("tgl_trans_seq");
     endfunction

     task run_phase(uvm_phase phase);
      phase.raise_objection(this);
            tgl_trans_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
            phase.phase_done.set_drain_time(this,20);
      phase.drop_objection(this);
     endtask
endclass

//****************************** ERROR INJECT TEST using sequence*********************************************//

class error_inject_test extends apb_slave_test;
    `uvm_component_utils(error_inject_test)
     error_inject_seq err_seq;

      function new(string name="error_inject_test",uvm_component parent);
       super.new(name,parent);
      endfunction

     function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       err_seq= error_inject_seq::type_id::create("err_seq");
     endfunction

     task run_phase(uvm_phase phase);
        phase.raise_objection(this);
           err_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
          phase.phase_done.set_drain_time(this,20);
	phase.drop_objection(this);
     endtask 

endclass
//****************************** PADDR ERROR INJECT using CONFIG_DB***********************************************//

class inject_addr_error_test extends apb_slave_test;
`uvm_component_utils(inject_addr_error_test)
  master_same_wr_rd_seq same_wr_rd_seq;
  apb_slave_config apb_slv_cfgh;
  master_cont_rd_seq cont_rd_seq;

function new(string name="inject_paddr_error_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  apb_slv_cfgh= apb_slave_config::type_id::create("apb_slv_cfgh");
  same_wr_rd_seq= master_same_wr_rd_seq::type_id::create("same_wr_rd_seq");
  cont_rd_seq=master_cont_rd_seq::type_id::create("cont_rd_seq");

   if(!uvm_config_db#(apb_slave_config)::get(this," ","apb_slave_config",apb_slv_cfgh)) begin
      `uvm_fatal("APB_AGT_CFG","cannot get apb_slave_config in apb_driver class")
   end
   apb_slv_cfgh.inject_addr_error=1;
   
   uvm_config_db#(apb_slave_config)::set(this, "*", "apb_slave_config",apb_slv_cfgh);

endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
            //same_wr_rd_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr); 
              cont_rd_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
         phase.drop_objection(this);
endtask

endclass

//***************************** INJECT NO WAIT STATES using CONFIG_DB *************************************************//
class inject_no_wait_states_test extends apb_slave_test;
`uvm_component_utils(inject_no_wait_states_test)
  master_same_wr_rd_seq same_wr_rd_seq;
  apb_slave_config apb_slv_cfgh;
  master_cont_rd_seq cont_rd_seq;

function new(string name="inject_no_wait_states_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  apb_slv_cfgh= apb_slave_config::type_id::create("apb_slv_cfgh");
  same_wr_rd_seq= master_same_wr_rd_seq::type_id::create("same_wr_rd_seq");
  cont_rd_seq=master_cont_rd_seq::type_id::create("cont_rd_seq");

   if(!uvm_config_db#(apb_slave_config)::get(this," ","apb_slave_config",apb_slv_cfgh)) begin
      `uvm_fatal("APB_AGT_CFG","cannot get apb_slave_config in apb_driver class")
   end
   apb_slv_cfgh.enable_wait_states=0;
   
   uvm_config_db#(apb_slave_config)::set(this, "*", "apb_slave_config",apb_slv_cfgh);

endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
            same_wr_rd_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr); 
              //cont_rd_seq.start(apb_slv_env.apb_slv_agt.apb_slv_seqr);
         phase.drop_objection(this);
endtask

endclass


