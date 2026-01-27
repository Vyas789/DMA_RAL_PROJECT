class dma_reg_block extends uvm_reg_block;
  `uvm_object_utils(dma_reg_block)
  
  rand mem_addr_reg mem_addr_inst;
  rand ctrl_reg ctrl_inst;
  rand extra_info_reg extra_info_inst;
  rand status_reg status_inst;
  rand intr_reg intr_inst;
  rand io_addr_reg io_addr_inst;
  rand transfer_count_reg transfer_count_inst;
  rand descriptor_addr_reg descriptor_addr_inst;
  rand error_status_reg error_status_inst;
  rand config_reg config_inst;
  
  function new(string name = "dma_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
  
  function void build();
    
    add_hdl_path("tb.dut", "RTL");
    
    mem_addr_inst = mem_addr_reg::type_id::create("mem_addr_inst");
    mem_addr_inst.configure(this);
    mem_addr_inst.build();
    mem_addr_inst.add_hdl_path_slice("mem_addr", 0, 32);
     
    ctrl_inst = ctrl_reg::type_id::create("ctrl_inst");
    ctrl_inst.configure(this);
    ctrl_inst.build();
    ctrl_inst.add_hdl_path_slice("ctrl_start_dma", 0, 1);
    ctrl_inst.add_hdl_path_slice("ctrl_w_count", 1, 15);
    ctrl_inst.add_hdl_path_slice("ctrl_io_mem", 16, 1);
  
    extra_info_inst = extra_info_reg::type_id::create("extra_info_inst");
    extra_info_inst.configure(this);
    extra_info_inst.build();
    extra_info_inst.add_hdl_path_slice("extra_info", 0, 32);
    
    status_inst = status_reg::type_id::create("status_inst");
    status_inst.configure(this);
    status_inst.build();
    status_inst.add_hdl_path_slice("status_busy", 0, 1);
    status_inst.add_hdl_path_slice("status_done", 1, 1);
    status_inst.add_hdl_path_slice("status_error", 2, 1);
    status_inst.add_hdl_path_slice("status_paused", 3, 1);
    status_inst.add_hdl_path_slice("status_current_state", 4, 4);
    status_inst.add_hdl_path_slice("status_fifo_level", 8, 8);
       
    intr_inst = intr_reg::type_id::create("intr_inst");
    intr_inst.configure(this);
    intr_inst.build();
    intr_inst.add_hdl_path_slice("intr_mask", 16, 16);
    intr_inst.add_hdl_path_slice("intr_status", 0, 16);
      
    io_addr_inst = io_addr_reg::type_id::create("io_addr_inst");
    io_addr_inst.configure(this);
    io_addr_inst.build();
    io_addr_inst.add_hdl_path_slice("io_addr", 0, 32);
     
    transfer_count_inst = transfer_count_reg::type_id::create("transfer_count_inst");
    transfer_count_inst.configure(this);
    transfer_count_inst.build();
    transfer_count_inst.add_hdl_path_slice("transfer_count", 0, 32);
     
    descriptor_addr_inst = descriptor_addr_reg::type_id::create("descriptor_addr_inst");
    descriptor_addr_inst.configure(this);
    descriptor_addr_inst.build();
    descriptor_addr_inst.add_hdl_path_slice("descriptor_addr", 0, 32);
    
    error_status_inst = error_status_reg::type_id::create("error_status_inst");
    error_status_inst.configure(this);
    error_status_inst.build();
    error_status_inst.add_hdl_path_slice("error_bus",          0, 1);
    error_status_inst.add_hdl_path_slice("error_timeout",      1, 1);
    error_status_inst.add_hdl_path_slice("error_alignment",    2, 1);
    error_status_inst.add_hdl_path_slice("error_overflow",     3, 1);
    error_status_inst.add_hdl_path_slice("error_underflow",    4, 1);
    error_status_inst.add_hdl_path_slice("error_code",         8, 8);
    error_status_inst.add_hdl_path_slice("error_addr_offset", 16, 16);
      
    config_inst = config_reg::type_id::create("config_inst");
    config_inst.configure(this);
    config_inst.build();
    config_inst.add_hdl_path_slice("config_priority",         0, 2);
    config_inst.add_hdl_path_slice("config_auto_restart",     2, 1);
    config_inst.add_hdl_path_slice("config_interrupt_enable", 3, 1);
    config_inst.add_hdl_path_slice("config_burst_size",       4, 2);
    config_inst.add_hdl_path_slice("config_data_width",       6, 2);
    config_inst.add_hdl_path_slice("config_descriptor_mode",  8, 1);
       
    default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN);

    default_map.add_reg(intr_inst,                'h400, "RW");
    default_map.add_reg(ctrl_inst,                'h404, "RW");
    default_map.add_reg(io_addr_inst,             'h408, "RW");
    default_map.add_reg(mem_addr_inst,            'h40C, "RW");
    default_map.add_reg(extra_info_inst,          'h410, "RW");
    default_map.add_reg(status_inst,              'h414, "RO");
    default_map.add_reg(transfer_count_inst,      'h418, "RO");
    default_map.add_reg(descriptor_addr_inst,     'h41C, "RW");
    default_map.add_reg(error_status_inst,        'h420, "RW");
    default_map.add_reg(config_inst,              'h424, "RW");
    
    default_map.set_auto_predict(0);

    lock_model();
  endfunction
endclass

    
    
  
  
  
  
