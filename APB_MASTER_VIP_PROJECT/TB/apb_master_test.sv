class apb_master_test extends uvm_test;
`uvm_component_utils(apb_master_test)

apb_master_environment apb_master_env;
apb_master_config apb_master_cfgh;

function new(string name="apb_master_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 `uvm_info(get_full_name(),"entering into build_phase", UVM_MEDIUM)
  super.build_phase(phase);
  apb_master_cfgh= apb_master_config::type_id::create("apb_master_cfgh");

  if(!uvm_config_db#(virtual apb3_if)::get(this, "*", "apb3_if", apb_master_cfgh.inf))
	`uvm_error(get_full_name(), "cannot get the interface from top")

   uvm_config_db #(apb_master_config)::set(this, "*", "apb_master_config", apb_master_cfgh);

   apb_master_env=apb_master_environment::type_id::create("apb_master_env", this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
 uvm_top.print_topology();
endfunction

endclass

///=============================== SINGLE WRITE TEST ====================================================//

class single_write_test extends apb_master_test;
`uvm_component_utils(single_write_test)
apb_single_write_seq single_wr_seq;

function new(string name="apb_master_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  single_wr_seq=apb_single_write_seq::type_id::create("single_wr_seq");
endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
             single_wr_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
             #20;
         phase.drop_objection(this);
endtask

endclass


///================================= SINGLE READ TEST ========================================================//

class single_read_test extends apb_master_test;
`uvm_component_utils(single_read_test)
apb_single_read_seq single_rd_seq;

function new(string name="single_read_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  single_rd_seq=apb_single_read_seq::type_id::create("single_rd_seq");
endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
             single_rd_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
             #20;
         phase.drop_objection(this);
endtask

endclass


///================================= SINGLE RANDOM WRITE TEST =====================================================//

class single_rand_wr_test extends apb_master_test;
`uvm_component_utils(single_rand_wr_test)
apb_single_random_write_seq single_rand_wr_seq;

function new(string name="single_rand_wr_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 single_rand_wr_seq=apb_single_random_write_seq::type_id::create("single_rand_wr_seq");
endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
             single_rand_wr_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
         phase.drop_objection(this);
endtask

endclass


///======================================= SINGLE RANDOM READ TEST =========================================================//

class single_rand_rd_test extends apb_master_test;
`uvm_component_utils(single_rand_rd_test)
apb_single_random_read_seq single_rand_rd_seq;

function new(string name="single_rand_rd_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 single_rand_rd_seq=apb_single_random_read_seq::type_id::create("single_rand_rd_seq");
endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
             single_rand_rd_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
         phase.drop_objection(this);
endtask

endclass


///======================================= BACK TO BACK/CONTINOUS RANDOM WRITE =================================================///
 
class multi_rand_wr_test extends apb_master_test;
`uvm_component_utils(multi_rand_wr_test)
 apb_cont_write_seq cnt_wr_seq;

function new(string name="multi_rand_wr_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 cnt_wr_seq =apb_cont_write_seq::type_id::create("cnt_wr_seq");
endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
            cnt_wr_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
         phase.drop_objection(this);
endtask

endclass

///======================================= BACK TO BACK/CONTINOUS RANDOM READ =================================================///


class multi_rand_rd_test extends apb_master_test;
`uvm_component_utils(multi_rand_rd_test)
 apb_cont_read_seq cnt_rd_seq;

function new(string name="multi_rand_rd_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 cnt_rd_seq =apb_cont_read_seq::type_id::create("cnt_rd_seq");
endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
            cnt_rd_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
         phase.drop_objection(this);
endtask

endclass


///========================================== MIXED WRITE & READ TEST =============================================================///

class mixed_wr_rd_test extends apb_master_test;
`uvm_component_utils(mixed_wr_rd_test)
 apb_write_read_seq wr_rd_seq;

function new(string name="mixed_wr_rd_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 wr_rd_seq =apb_write_read_seq::type_id::create("wr_rd_seq");
endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
            wr_rd_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
         phase.drop_objection(this);
endtask

endclass



///====================================== ERROR INJECTION TEST Using SEQUENCE =================================================///

class error_inject_test extends apb_master_test;
`uvm_component_utils(error_inject_test)
 apb_error_inject_seq err_inject_seq;

function new(string name="mixed_wr_rd_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 err_inject_seq =apb_error_inject_seq::type_id::create("err_inject_seq");
endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
            err_inject_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
            #20;
         phase.drop_objection(this);
endtask

endclass


///======================================= PROTOCOL ERROR INJECTION TEST Using CONFIG_DB ===================================================///


class inject_penable_error_test extends apb_master_test;
`uvm_component_utils(inject_penable_error_test)
 apb_write_read_seq wr_rd_seq;
 apb_master_config apb_master_cfgh;

function new(string name="inject_penable_error_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  apb_master_cfgh= apb_master_config::type_id::create("apb_master_cfgh");
  wr_rd_seq= apb_write_read_seq::type_id::create("wr_rd_seq");

  if(!uvm_config_db#(apb_master_config)::get(this, "*", "apb_master_config", apb_master_cfgh))
           `uvm_fatal(get_full_name, "configuration not get properly")

   apb_master_cfgh.inject_penable_error=1;
   
   uvm_config_db #(apb_master_config)::set(this, "*", "apb_master_config", apb_master_cfgh);

endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
            wr_rd_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
         phase.drop_objection(this);
endtask

endclass



///======================================= PADDR ERROR INJECTION TEST Using CONFIG_DB=================================================///

class inject_paddr_error_test extends apb_master_test;
`uvm_component_utils(inject_paddr_error_test)
 apb_write_read_seq wr_rd_seq;
 apb_master_config apb_master_cfgh;

function new(string name="inject_paddr_error_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  apb_master_cfgh= apb_master_config::type_id::create("apb_master_cfgh");
  wr_rd_seq= apb_write_read_seq::type_id::create("wr_rd_seq");

  if(!uvm_config_db#(apb_master_config)::get(this, "*", "apb_master_config", apb_master_cfgh))
           `uvm_fatal(get_full_name, "configuration not get properly")

   apb_master_cfgh.inject_paddr_error=1;
   
   uvm_config_db #(apb_master_config)::set(this, "*", "apb_master_config", apb_master_cfgh);

endfunction

task run_phase(uvm_phase phase);
         phase.raise_objection(this);
            wr_rd_seq.start(apb_master_env.apb_master_agt.apb_master_seqr);
         phase.drop_objection(this);
endtask

endclass





