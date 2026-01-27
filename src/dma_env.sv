class dma_env extends uvm_env;
  `uvm_component_utils(dma_env)

  dma_agent                     agent_inst;
  dma_reg_block                 reg_block;
  dma_adapter                   adapter_inst;
  uvm_reg_predictor#(dma_seq_item) predictor_inst;
  dma_subscriber sub;

  function new(string name = "dma_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    predictor_inst = uvm_reg_predictor#(dma_seq_item)::type_id::create("predictor_inst", this);
    agent_inst     = dma_agent::type_id::create("agent_inst", this);
    reg_block      = dma_reg_block::type_id::create("reg_block", this);
    reg_block.build();
    adapter_inst   = dma_adapter::type_id::create("adapter_inst", this);
    sub = dma_subscriber::type_id::create("sub", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    reg_block.default_map.set_sequencer(agent_inst.seqr, adapter_inst);
    reg_block.default_map.set_base_addr(0);
    
    predictor_inst.map     = reg_block.default_map;
    predictor_inst.adapter = adapter_inst;
    
    agent_inst.mon.mon_port.connect(predictor_inst.bus_in);
    agent_inst.mon.mon_port.connect(sub.analysis_export);
    reg_block.default_map.set_auto_predict(0);
  endfunction
endclass
