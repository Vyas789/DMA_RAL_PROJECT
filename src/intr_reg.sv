class intr_reg extends uvm_reg;
  
  `uvm_object_utils(intr_reg)
 
  rand uvm_reg_field intr_status;
  rand uvm_reg_field intr_mask;

  function new(string name="intr_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
  endfunction

  virtual function void build();
    
    intr_status = uvm_reg_field::type_id::create("intr_status");
    intr_status.configure(
      .parent(this),
      .size(16),
      .lsb_pos(0),
      .access("RO"),
      .volatile(0),
      .reset(16'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(0)
    );
  	intr_mask = uvm_reg_field::type_id::create("intr_mask");
    intr_mask.configure(
      .parent(this),
      .size(16),
      .lsb_pos(16),
      .access("RW"),
      .volatile(0),
      .reset(16'b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );
  endfunction
endclass
