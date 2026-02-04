class apb_master_driver extends uvm_driver #(apb_master_transaction);
`uvm_component_utils(apb_master_driver);

virtual apb3_if m_inf;
apb_master_config apb_master_cfgh;
//uvm_analysis_port #(apb_master_transaction) apb_drv_ap;
 bit[31:0] wait_cnt;

function new(string name="apb_master_driver", uvm_component parent);
	super.new(name,parent);
       // apb_drv_ap=new("apb_drv_ap",this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
        if(!uvm_config_db#(apb_master_config)::get(this, "*", "apb_master_config", apb_master_cfgh))
           `uvm_fatal(get_full_name, "configuration not set properly")
endfunction

function void connect_phase(uvm_phase phase);
   m_inf=apb_master_cfgh.inf;
endfunction



task run_phase(uvm_phase phase);

@(m_inf.apb_drv_cb);
 m_inf.apb_drv_cb.PRESETn<=0;
 m_inf.apb_drv_cb.PSELx   <= 0;
 m_inf.apb_drv_cb.PENABLE <= 0;
 
@(m_inf.apb_drv_cb);
 m_inf.apb_drv_cb.PRESETn<=1;

// -------- MAIN DRIVER LOOP --------
forever
      begin
          seq_item_port.get_next_item(req);
           send_to_dut(req);
          seq_item_port.item_done();
       end
endtask

// ==========================================================
// Drive APB transfer (normal or error-injected)
// ==========================================================
task send_to_dut(apb_master_transaction req);
$display("entering into driver run_phase");


@(m_inf.apb_drv_cb);
 // --------------------------------------------------------
 // ERROR INJECTION: PENABLE without PSELx (Protocol Error)
 // --------------------------------------------------------
 if(apb_master_cfgh.inject_penable_error==1) begin
   `uvm_info(get_type_name(), "Injecting protocol error: PENABLE=1 without PSELx", UVM_MEDIUM)

  //Illegal ACCESS phase
      m_inf.apb_drv_cb.PSELx <= 'b0;
      m_inf.apb_drv_cb.PENABLE<='b1;
      m_inf.apb_drv_cb.PWRITE<= req.pwrite;
      m_inf.apb_drv_cb.PADDR <= req.paddr;
      m_inf.apb_drv_cb.PWDATA <= (req.pwrite) ? req.pwdata:'b0;

   //Return to idle
    @(m_inf.apb_drv_cb);
       m_inf.apb_drv_cb.PSELx   <= 0;
       m_inf.apb_drv_cb.PENABLE <= 0;

      // Sample slave response
      req.pready  = m_inf.apb_drv_cb.PREADY;
      req.pslverr = m_inf.apb_drv_cb.PSLVERR;
       
      return;
    end

 //else if(apb_master_cfgh.inject_penable_error==0) begin
  
   // --------------------------------------------------------
   // NORMAL APB TRANSFER
   // --------------------------------------------------------

    //------------------ [[SETUP phase]]-------------------------
      m_inf.apb_drv_cb.PSELx <= 1;
      m_inf.apb_drv_cb.PENABLE<=0;
      m_inf.apb_drv_cb.PWRITE<= req.pwrite;
      m_inf.apb_drv_cb.PWDATA<= (req.pwrite)? req.pwdata:'b0;

          if(apb_master_cfgh.inject_paddr_error==1)
            begin
             apb_master_cfgh.gen_illegal_paddr(); 
             m_inf.apb_drv_cb.PADDR <= apb_master_cfgh.illegal_paddr;
            end
          else
            begin
               m_inf.apb_drv_cb.PADDR <= req.paddr;
            end
  
       
    
     @(m_inf.apb_drv_cb);

   //-----------------[[ACCESS phase]]-------------------------

      //  if(m_inf.PSELx ==1)
             m_inf.apb_drv_cb.PENABLE<=1;
 
        //if(req.pselx==1)
        // if(m_inf.PSELx ==1)
             wait(m_inf.apb_drv_cb.PREADY) begin
                req.pready = m_inf.apb_drv_cb.PREADY;
                req.pslverr = m_inf.apb_drv_cb.PSLVERR;
                if(!req.pwrite)
                  req.prdata = m_inf.apb_drv_cb.PRDATA;
             end
        `uvm_info(get_type_name(),$sformatf("Printing from APB_MASTER_DRIVER: %s",req.sprint()),UVM_LOW)
  

 //--------------------[[IDLE phase]]----------------------------
  @(m_inf.apb_drv_cb);
    m_inf.apb_drv_cb.PSELx <= 0;
    m_inf.apb_drv_cb.PENABLE<=0;

//@(m_inf.apb_drv_cb);
 
// apb_drv_ap.write(req);

endtask

   
endclass
