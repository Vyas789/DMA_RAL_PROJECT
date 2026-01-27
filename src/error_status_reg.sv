class error_status_reg extends uvm_reg;
   
   `uvm_object_utils(error_status_reg)
  
  rand uvm_reg_field bus_error;
  rand uvm_reg_field timeout_error;
  rand uvm_reg_field alignment_error;
  rand uvm_reg_field overflow_error;
  rand uvm_reg_field underflow_error;
  uvm_reg_field reserved;
  uvm_reg_field error_code;
  uvm_reg_field error_addr_offset;

 covergroup error_cov;
  option.per_instance = 1;

  bus_error_cp       : coverpoint bus_error.value       { bins no_err = {0}; bins err = {1}; }
  timeout_error_cp   : coverpoint timeout_error.value   { bins no_err = {0}; bins err = {1}; }
  alignment_error_cp : coverpoint alignment_error.value { bins no_err = {0}; bins err = {1}; }
  overflow_cp        : coverpoint overflow_error.value  { bins no_err = {0}; bins err = {1}; }
  underflow_cp       : coverpoint underflow_error.value { bins no_err = {0}; bins err = {1}; }

  error_code_cp : coverpoint error_code.value {
    bins no_error_code = {0};
    bins valid_codes = {[1:255]};
  }

  error_addr_cp : coverpoint error_addr_offset.value {
    bins zero_offset = {0};
    bins non_zero    = {[1:$]};
  }

endgroup
 
  function new(string name = "error_status_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      error_cov = new();
  endfunction

  virtual function void sample(uvm_reg_data_t data,
                               uvm_reg_data_t byte_en,
                               bit is_read,
                               uvm_reg_map map);
    error_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    error_cov.sample();
  endfunction 

    function void build();
    bus_error = uvm_reg_field::type_id::create("bus_error");
    bus_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(0),
      .access("W1C"),
      .volatile(1),
      .reset(1'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );

    timeout_error = uvm_reg_field::type_id::create("timeout_error");
    timeout_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(1),
      .access("W1C"),
      .volatile(1),
      .reset(1'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );

    alignment_error = uvm_reg_field::type_id::create("alignment_error");
    alignment_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(2),
      .access("W1C"),
      .volatile(1),
      .reset(1'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );

    overflow_error = uvm_reg_field::type_id::create("overflow_error");
    overflow_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(3),
      .access("W1C"),
      .volatile(1),
      .reset(1'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );

    underflow_error = uvm_reg_field::type_id::create("underflow_error");
    underflow_error.configure(
      .parent(this),
      .size(1),
      .lsb_pos(4),
      .access("W1C"),
      .volatile(1),
      .reset(1'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(1)
    );

    reserved = uvm_reg_field::type_id::create("reserved");
    reserved.configure(
      .parent(this),
      .size(3),
      .lsb_pos(5),
      .access("RO"),
      .volatile(0),
      .reset(3'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(0)
    );

    error_code = uvm_reg_field::type_id::create("error_code");
    error_code.configure(
      .parent(this),
      .size(8),
      .lsb_pos(8),
      .access("RO"),
      .volatile(1),
      .reset(8'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(0)
    );

    error_addr_offset = uvm_reg_field::type_id::create("error_addr_offset");
    error_addr_offset.configure(
      .parent(this),
      .size(16),
      .lsb_pos(16),
      .access("RO"),
      .volatile(1),
      .reset(16'b0),
      .has_reset(1),
      .is_rand(0),
      .individually_accessible(0)
    );
  endfunction
endclass
