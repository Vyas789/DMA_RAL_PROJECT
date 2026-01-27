class transfer_count_reg extends uvm_reg;
  
  `uvm_object_utils(transfer_count_reg)
 
  uvm_reg_field transfer_count;

  function new(string name="transfer_count_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
  endfunction

  function void build();
    transfer_count = uvm_reg_field::type_id::create("transfer_count");
    transfer_count.configure(
      .parent(this),
      .size(32),
      .lsb_pos(0),
      .access("RO"),
      .volatile(1),
      .reset(32'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(0)
    );
  endfunction
endclass
