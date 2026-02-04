class apb_master_transaction extends uvm_sequence_item;

  logic pready,pslverr,penable,presetn;
  logic pselx;
  rand logic pwrite;
  rand logic [`ADDR_WIDTH-1:0] paddr;
  rand logic [`DATA_WIDTH-1:0] pwdata;
  logic[`DATA_WIDTH-1:0] prdata;
  
`uvm_object_utils_begin(apb_master_transaction)
 `uvm_field_int(presetn, UVM_ALL_ON)
 `uvm_field_int(pready, UVM_ALL_ON)
 `uvm_field_int(pwrite, UVM_ALL_ON)
 `uvm_field_int(pslverr,  UVM_ALL_ON)
 `uvm_field_int(pselx,  UVM_ALL_ON)
 `uvm_field_int(penable,  UVM_ALL_ON)
 `uvm_field_int(paddr,  UVM_ALL_ON)
 `uvm_field_int(pwdata,  UVM_ALL_ON)
 `uvm_field_int(prdata,  UVM_ALL_ON)
`uvm_object_utils_end

 

 function new(string name="apb_master_transaction");
	super.new(name);
 endfunction


endclass
