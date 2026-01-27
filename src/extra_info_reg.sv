class extra_info_reg extends uvm_reg;
  `uvm_object_utils(extra_info_reg)
 
rand uvm_reg_field extra_info;
 
  covergroup extra_info_cov;
    option.per_instance = 1;

    info_cp : coverpoint extra_info.value {
      bins zero = {32'h0};
      bins non_zero = {[32'h1:32'hFFFF_FFFF]};
    }
  endgroup

  function new(string name = "extra_info_reg");
    super.new(name, 32, UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      extra_info_cov = new();
  endfunction

  virtual function void sample(uvm_reg_data_t data,
                               uvm_reg_data_t byte_en,
                               bit is_read,
                               uvm_reg_map map);
    extra_info_cov.sample();
  endfunction

  virtual function void sample_values();
    super.sample_values();
    extra_info_cov.sample();
  endfunction 
 
function void build;
extra_info=uvm_reg_field::type_id::create("extra_info");
extra_info.configure(.parent(this),.size(32),.lsb_pos(0),.access("RW"),.volatile(0),.reset(32'b0),.has_reset(1),.is_rand(1),.individually_accessible(1));
 
endfunction
 
endclass
