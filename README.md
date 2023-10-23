# AXI
#### 項目介紹

#### 工程結構
- Top.v
  - Master.v
  - Interconnect.v
    - Arbiter_R
    - Arbiter_W
    - Master_Mux_R
    - Master_Mux_W
    - Slave_Mux_R
    - Slave_Mux_W
  - Slave.v

##### 筆記
* 2023.10.23
  * 4個AXI Master
  * 4個AXI Slave
  * 可支援FIXED、INCR和WRAP模式
  * 功能覆蓋率完成One2One testbench
