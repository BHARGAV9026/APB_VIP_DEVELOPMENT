module top;

import uvm_pkg::*;
import apb_master_package::*;
bit clk;
bit rst_n;

always 
#5 clk=~clk;

apb3_if in0(clk);

apb_slave apb3_slv( .PCLK(clk),
		    .PRESETn(in0.PRESETn),
                    .PENABLE(in0.PENABLE),
		    .PWRITE(in0.PWRITE),
                    .PSELx(in0.PSELx),
                    .PADDR(in0.PADDR),
                    .PWDATA(in0.PWDATA),
                    .PREADY(in0.PREADY),
		    .PSLVERR(in0.PSLVERR),
                    .PRDATA(in0.PRDATA)
                  );

initial
     begin
	uvm_config_db #(virtual apb3_if)::set(null,"*","apb3_if",in0);
        run_test();
      end

endmodule
