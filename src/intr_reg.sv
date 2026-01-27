class intr_reg extends uvm_reg;
  
  `uvm_object_utils(intr_reg)
 
  rand uvm_reg_field intr_status;
  rand uvm_reg_field intr_mask;

  covergroup intr_cov;
    option.per_instance = 1;

    intr_mask_cp : coverpoint intr_mask.value{
      bins zero = {16'h0000};
      bins low  = {[16'h0001:16'h00FF]};
      bins mid  = {[16'h0100:16'h0FFF]};
      bins high = {[16'h1000:16'hFFFF]};
    }
  endgroup

  function new(string name="intr_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
     if (has_coverage(UVM_CVR_FIELD_VALS))
      intr_cov = new();
  endfunction
  
   virtual function void sample(uvm_reg_data_t data,
                               uvm_reg_data_t byte_en,
                               bit is_read,
                               uvm_reg_map map);
    intr_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    intr_cov.sample();
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
