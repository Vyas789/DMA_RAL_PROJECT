class dma_monitor extends uvm_monitor;
  `uvm_component_utils(dma_monitor)
  
  dma_seq_item seq;
  virtual dma_intf vif;
  uvm_analysis_port#(dma_seq_item) mon_port;
  
  function new(string name = "dma_monitor", uvm_component parent = null);
    super.new(name, parent);
    mon_port = new("mon_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dma_intf)::get(this, "", "vif", vif))
      `uvm_error(get_type_name(), $sformatf("did not receive the virtual intf handle"))
  endfunction
  
  task run_phase(uvm_phase phase);
    repeat(1) @(vif.mon_cb);
    forever begin
      seq = dma_seq_item::type_id::create("seq");
      repeat(2) @(vif.mon_cb);
      seq.wr_en = vif.wr_en;
      seq.rd_en = vif.rd_en;
      seq.addr = vif.addr;
      seq.wdata = vif.wdata;
      seq.rdata = vif.rdata;
      `uvm_info(get_type_name(), $sformatf("addr = %0d, wdata = %0d,wr_en = %0d, rd_en = %0d, rdata = %0d " , seq.addr, seq.wdata, seq.wr_en, seq.rd_en, seq.rdata), UVM_MEDIUM)
      repeat(2)@(vif.mon_cb);
      mon_port.write(seq);
      end
  endtask
    
endclass
    
      
      
      
