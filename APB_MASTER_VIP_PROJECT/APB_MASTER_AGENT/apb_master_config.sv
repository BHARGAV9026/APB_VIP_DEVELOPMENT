class apb_master_config extends uvm_object;

`uvm_object_utils(apb_master_config)

uvm_active_passive_enum is_active=UVM_ACTIVE;

virtual apb3_if inf;

bit enable_master_vip      = 1;

bit enable_scoreboard      = 1;
  
bit enable_coverage        = 1;

bit inject_penable_error   = 0;

bit inject_paddr_error     = 0;

rand bit[`ADDR_WIDTH-1:0]illegal_paddr; // = $urandom_range(32'h0000_00FF,32'hFFFF_FFFF);

constraint illegal_addr_c {illegal_paddr >= 256;}


function new(string name="apb_master_config");
	super.new(name);
endfunction

 function void gen_illegal_paddr();
    if (!this.randomize())
      `uvm_fatal("MASTER_VIP_CFG", "Failed to randomize illegal_paddr")
 endfunction


endclass
