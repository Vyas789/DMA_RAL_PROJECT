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
