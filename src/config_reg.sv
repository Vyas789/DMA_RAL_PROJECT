
class config_reg extends uvm_reg;
  
   `uvm_object_utils(config_reg)
  
  rand uvm_reg_field priority_field;
  rand uvm_reg_field auto_restart;
  rand uvm_reg_field interrupt_enable;
  rand uvm_reg_field burst_size;
  rand uvm_reg_field data_width;
  rand uvm_reg_field descriptor_mode;
  uvm_reg_field reserved;

  function new(string name="config_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
  endfunction

   function void build();
     priority_field = uvm_reg_field::type_id::create("priority_field");
    priority_field.configure(
      .parent(this),
      .size(2),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset(2'b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );

    auto_restart = uvm_reg_field::type_id::create("auto_restart");
    auto_restart.configure(
      .parent(this),
      .size(1),
      .lsb_pos(2),
      .access("RW"),
      .volatile(0),
      .reset(1'b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );

    interrupt_enable = uvm_reg_field::type_id::create("interrupt_enable");
    interrupt_enable.configure(
      .parent(this),
      .size(1),
      .lsb_pos(3),
      .access("RW"),
      .volatile(0),
      .reset(1'b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );

    burst_size = uvm_reg_field::type_id::create("burst_size");
    burst_size.configure(
      .parent(this),
      .size(2),
      .lsb_pos(4),
      .access("RW"),
      .volatile(0),
      .reset(2'b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );

    data_width = uvm_reg_field::type_id::create("data_width");
    data_width.configure(
      .parent(this),
      .size(2),
      .lsb_pos(6),
      .access("RW"),
      .volatile(0),
      .reset(2'b0),
      .has_reset(1),
      .is_rand(1),
      .individually_accessible(1)
    );

    descriptor_mode = uvm_reg_field::type_id::create("descriptor_mode");
    descriptor_mode.configure(
      .parent(this),
      .size(1),
      .lsb_pos(8),
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
      .size(23),
      .lsb_pos(9),
      .access("RO"),
      .volatile(0),
      .reset(23'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(0)
    );
  endfunction
endclass
