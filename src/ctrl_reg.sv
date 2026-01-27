class ctrl_reg extends uvm_reg;
  
  `uvm_object_utils(ctrl_reg)
  
  rand uvm_reg_field start_dma;
  rand uvm_reg_field w_count;
  rand uvm_reg_field io_mem;
  uvm_reg_field reserved;

  function new(string name="ctrl_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
  endfunction
  
  function void build();
    start_dma = uvm_reg_field::type_id::create("start_dma");
    start_dma.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("RW"),
      .volatile(1),
      .reset(1'b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );

    w_count = uvm_reg_field::type_id::create("w_count");
    w_count.configure(
      .parent(this),
      .size(15),
      .lsb_pos(1),
      .access("RW"),
      .volatile(0),
      .reset(15'b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );

    io_mem = uvm_reg_field::type_id::create("io_mem");
    io_mem.configure(
      .parent(this),
      .size(1),
      .lsb_pos(16),
      .access("RW"),
      .volatile(0),
      .reset(1'b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );

    reserved = uvm_reg_field::type_id::create("reserved");
    reserved.configure(
      .parent(this),
      .size(15),
      .lsb_pos(17),
      .access("RO"),
      .volatile(0),
      .reset(15'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(0)
    );
  endfunction
endclass
