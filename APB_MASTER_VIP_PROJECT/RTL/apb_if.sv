`include "define.sv"
interface apb3_if(input logic PCLK);

logic PRESETn;
logic [`ADDR_WIDTH-1:0] PADDR;
logic [`DATA_WIDTH-1:0] PWDATA;
logic PSELx;
logic PENABLE;
logic PWRITE;
logic PREADY;
logic [`DATA_WIDTH-1:0] PRDATA;
logic PSLVERR;

clocking apb_drv_cb@(posedge PCLK);
default input #1 output #1;
input PRDATA, PREADY, PSLVERR;
output PADDR, PWDATA,PSELx,PENABLE,PWRITE,PRESETn;
endclocking

clocking apb_mon_cb@(posedge PCLK);
default input #1 output #1;
input PRDATA,PSLVERR,PADDR,PWDATA,PSELx,PENABLE,PWRITE,PREADY;
endclocking

modport apb3_master_drv(clocking apb_drv_cb);
modport apb3_master_mon(clocking apb_mon_cb);


///***********************SIMULATION CHECKS/ASSERTIONS ********************************************************///

//========default clock====================//
 default clocking def_clk @(posedge PCLK);
 endclocking

  sequence idle;
    !PSELx && !PENABLE;
  endsequence

  sequence setup;
    PSELx && !PENABLE;
  endsequence

 sequence access;
   PSELx && PENABLE;
 endsequence 

 property reset_check;
   !PRESETn |-> !PSLVERR && !PRDATA && !PREADY;
 endproperty
 AST_RESET_CHECK:assert property(reset_check)
                    $display("================== A1:reset_check PASSED =================");
                 else
                    $display("================== A1:reset_check FAILED =================");


  property setup_to_access;
    disable iff(!PRESETn) setup|-> ##1 access;
  endproperty
 AST_SETUP_TO_ACCESS:assert property(setup_to_access)
                         $display("================== A2:setup_to_access PASSED =================");
                      else
                          $display("================== A2:setup_to_access FAILED =================");


 property access_to_setup;
   disable iff(!PRESETn) (access ##0 PREADY) |-> ##1 setup;
 endproperty
 AST_ACCESS_TO_SETUP:assert property(access_to_setup)
                        $display("================== A3: access_to_setup PASSED =================");
                    else
                        $display("================== A3: access_to_setup FAILED =================");


 property access_to_idle;
   disable iff(!PRESETn) (access ##0 PREADY) |-> ##1 idle;
 endproperty
 AST_ACCESS_TO_IDLE:assert property(access_to_idle)
                        $display("================== A3: access_to_idle PASSED =================");
                    else
                        $display("================== A3: access_to_idle FAILED =================");

 property stable_access;
    disable iff(!PRESETn) (access ##0 !PREADY) |-> ##1 access;
 endproperty
 AST_STABLE_ACCESS:assert property(stable_access)
                     $display("================== A4: stable_access PASSED =================");
                    else
                     $display("================== A4: stbale_access FAILED =================");


 
 property pready_low_in_setup;
  disable iff(!PRESETn) setup|-> !PREADY;
 endproperty
AST_NO_PREADY_IN_SETUP:assert property(pready_low_in_setup)
                         $display("================== A5: pready_low_in_setup PASSED =================");
                       else
                         $display("================== A5: pready_low_in_setup FAILED =================");



 property no_pslverr_with_legal_addr;
  disable iff(!PRESETn) access ##0 (PADDR <= 255)|-> !PSLVERR;
 endproperty
AST_NO_PSLERR_LEGAL_ADDR:assert property(no_pslverr_with_legal_addr)
                            $display("================== A6: no_pslverr_with_legal_addr PASSED =================");
                         else
                             $display("================== A6: no_pslverr_with_legal_addr FAILED =================");



property pslverr_with_illegal_addr;
  disable iff(!PRESETn) access ##0 (PADDR > 255)|-> PSLVERR;
 endproperty
AST_PSLERR_ILLEGAL_ADDR:assert property(no_pslverr_with_legal_addr)
                            $display("================== A7: pslverr_with_illegal_addr PASSED =================");
                         else
                             $display("================== A7: pslverr_with_illegal_addr FAILED =================");



property no_enable_after_pready;
  disable iff(!PRESETn) access ##0 PREADY |-> ##1 !PENABLE ;
endproperty
AST_NO_ENABLE_AFTER_PREADY:assert property(no_enable_after_pready)
                                $display("================== A8: no_enable_after_pready PASSED =================");
                           else
                                $display("================== A8: no_enable_after_pready FAILED =================");
  


property paddr_stable_in_access;
  disable iff(!PRESETn) access ##0 !PREADY |-> ##1 $stable(PADDR);
endproperty
AST_PADDR_STABLE:assert property(paddr_stable_in_access)
                     $display("================== A9: addr_stable PASSED =================");
                 else
                     $display("================== A9: addr_stable FAILED =================");



property pwdata_stable_in_access;
  disable iff(!PRESETn) access ##0 (!PREADY && PWRITE) |-> ##1 $stable(PWDATA);
endproperty
AST_PWDATA_STABLE:assert property(pwdata_stable_in_access)
                    $display("================== A9: pwdata_stable PASSED =================");
                 else
                     $display("================== A9: pwdata_stable FAILED =================");

                   

 property pready_within_maxwait;
   disable iff(!PRESETn) access ##0 !PREADY |-> ##[1:`MAX_WAIT+1] PREADY;
 endproperty
 AST_PREADY_WITHIN_MAXWAIT:assert property(pready_within_maxwait)
                                  $display("================== A10: pready_within_maxwait PASSED =================");
                           else
                                  $display("================== A10: pready_within_maxwait FAILED =================");


property paddr_stable_setup_to_access;
   disable iff (!PRESETn)
    setup |-> ##1 (access ##0 (PADDR == $past(PADDR)));
endproperty
AST_PADDR_STABLE_SETUP_TO_ACCESS:assert property(paddr_stable_setup_to_access)
                                    $display("================== A11:paddr_stable_setup_to_access PASSED =================");
                                 else
                                    $display("================== A11: paddr_stable_setup_to_access FAILED =================");


 property pwdata_stable_setup_to_access;
   disable iff (!PRESETn)
    setup |-> ##1 (access ##0 (PWDATA == $past(PWDATA)));
endproperty
AST_PWDATA_STABLE_SETUP_TO_ACCESS:assert property(pwdata_stable_setup_to_access)
                                   $display("================== A12:pwdata_stable_setup_to_access PASSED =================");
                           else
                                  $display("================== A12: pwdata_stable_setup_to_access FAILED =================");



endinterface

 
