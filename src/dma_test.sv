class dma_test extends uvm_test;
  `uvm_component_utils(dma_test)

  function new(string name = "dma_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  dma_env env;
  dma_sequence bseq;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = dma_env::type_id::create("env", this);
    bseq  = dma_sequence::type_id::create("bseq");
  endfunction

  virtual task run_phase(uvm_phase phase);
     phase.phase_done.set_drain_time(this, 200);
    phase.raise_objection(this);
    bseq.reg_block = env.reg_block;
    bseq.start(env.agent_inst.seqr);
    phase.drop_objection(this);
  endtask
endclass

class intr_test extends dma_test;
  `uvm_component_utils(intr_test)

  intr_reg_sequence seq;

  function new(string name = "intr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq = intr_reg_sequence::type_id::create("seq");
      seq.reg_block = env.reg_block;
      seq.start(env.agent_inst.seqr);
      phase.drop_objection(this);
  endtask
endclass

class ctrl_test extends dma_test;
  `uvm_component_utils(ctrl_test)

  ctrl_reg_sequence seq;

  function new(string name = "ctrl_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq = ctrl_reg_sequence::type_id::create("seq");
      seq.reg_block = env.reg_block;
      seq.start(env.agent_inst.seqr);
      phase.drop_objection(this);
  endtask
endclass

class io_addr_test extends dma_test;
  `uvm_component_utils(io_addr_test)

  io_addr_reg_sequence seq;

  function new(string name = "io_addr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq = io_addr_reg_sequence::type_id::create("seq");
      seq.reg_block = env.reg_block;
      seq.start(env.agent_inst.seqr);
      phase.drop_objection(this);
  endtask
endclass

class mem_addr_test extends dma_test;
  `uvm_component_utils(mem_addr_test)
  
  mem_addr_reg_sequence seq;
  
  function new(string name = "mem_addr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq = mem_addr_reg_sequence::type_id::create("seq");
      seq.reg_block = env.reg_block;
      seq.start(env.agent_inst.seqr);
      phase.drop_objection(this);
  endtask
endclass

class extra_info_test extends dma_test;
  `uvm_component_utils(extra_info_test)
  
  extra_info_reg_sequence seq;
  
  function new(string name = "extra_info_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq = extra_info_reg_sequence::type_id::create("seq");
      seq.reg_block = env.reg_block;
      seq.start(env.agent_inst.seqr);
      phase.drop_objection(this);
  endtask
endclass

class descriptor_addr_test extends dma_test;
  `uvm_component_utils(descriptor_addr_test)
  
  descriptor_addr_reg_sequence seq;
  
  function new(string name = "descriptor_addr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq = descriptor_addr_reg_sequence::type_id::create("seq");
      seq.reg_block = env.reg_block;
      seq.start(env.agent_inst.seqr);
      phase.drop_objection(this);
  endtask
endclass

class config_test extends dma_test;
  `uvm_component_utils(config_test)
  
  config_reg_sequence seq;
  
  function new(string name = "config_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq = config_reg_sequence::type_id::create("seq");
      seq.reg_block = env.reg_block;
      seq.start(env.agent_inst.seqr);
      phase.drop_objection(this);
  endtask
endclass

class error_status_test extends dma_test;
  `uvm_component_utils(error_status_test)
  
  error_status_reg_sequence seq;
  
  function new(string name = "error_status_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq = error_status_reg_sequence::type_id::create("seq");
      seq.reg_block = env.reg_block;
      seq.start(env.agent_inst.seqr);
      phase.drop_objection(this);
  endtask
endclass

class transfer_count_test extends dma_test;
  `uvm_component_utils(transfer_count_test)
  
  transfer_count_reg_sequence seq;
  
  function new(string name = "transfer_count_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      seq = transfer_count_reg_sequence::type_id::create("seq");
      seq.reg_block = env.reg_block;
      seq.start(env.agent_inst.seqr);
      phase.drop_objection(this);
  endtask
endclass

