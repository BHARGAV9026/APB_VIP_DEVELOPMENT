class apb_master_sequencer extends uvm_sequencer #(apb_master_transaction);
`uvm_component_utils(apb_master_sequencer);

function new(string name="apb_master_sequencer", uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

endclass
