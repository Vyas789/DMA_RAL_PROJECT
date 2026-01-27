class dma_driver extends uvm_driver #(dma_seq_item);
  `uvm_component_utils(dma_driver)
  
  dma_seq_item seq;
  virtual dma_intf vif;
  
  function new(string name = "dma_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dma_intf)::get(this, "", "vif", vif))
      `uvm_error(get_type_name(), $sformatf("did not receive the virtual interface handle"))
  endfunction
      
   task run_phase(uvm_phase phase);
    repeat(1)@(vif.drv_cb);
    forever begin
      seq = dma_seq_item::type_id::create("seq");
      seq_item_port.get_next_item(seq);
      drive_item(seq);
      seq_item_port.item_done();
    end
    endtask
   
    task drive_item(dma_seq_item req);
      repeat(1)@(vif.drv_cb);
      vif.wr_en<=req.wr_en;
      vif.addr<=req.addr;
      vif.rd_en<=req.rd_en;
      if(req.wr_en) begin
        vif.wdata <= req.wdata;
      end
      `uvm_info(get_type_name(), $sformatf("addr = %0d, wdata = %0d,wr_en = %0d, rd_en = %0d " , req.addr, req.wdata, req.wr_en, req.rd_en), UVM_MEDIUM)
      repeat(1) @(vif.drv_cb);
      if(req.rd_en) begin
        req.rdata <= vif.rdata;
      end
      repeat(2)@(vif.drv_cb);
    endtask
    endclass
  
