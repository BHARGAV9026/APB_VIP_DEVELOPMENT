module tb_top();
  import uvm_pkg::*;
  import apb_slave_package::*;

logic clk=0;
always #5 clk = ~clk;

apb_interface intf1(clk);
apb_master dut1(.PCLK(clk),
	        .PRESETn(intf1.PRESETn),
                .PADDR(intf1.PADDR),
	        .PSELx(intf1.PSELx),
	        .PENABLE(intf1.PENABLE),
	       	.PWRITE(intf1.PWRITE),
		.PWDATA(intf1.PWDATA),
		.PRDATA(intf1.PRDATA),
		.PREADY(intf1.PREADY),
		.PSLVERR(intf1.PSLVERR),
		.apb_wr_addr(intf1.apb_write_paddr), 
		.apb_wr_data(intf1.apb_write_data),
		.apb_rd_addr(intf1.apb_read_paddr),
	        .apb_rd_data_out(intf1.apb_read_data_out),
		.READ_WRITE(intf1.READ_WRITE),
	        .transfer(intf1.transfer));
	initial 
           begin
                uvm_config_db #(virtual apb_interface)::set(null, "*", "intf1", intf1);
        	run_test("apb_slave_test");
           end

endmodule

