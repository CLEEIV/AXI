module Slave_Mux_R (
    //----- Global -----//
    input  aclk   ,
    input  aresetn,
    //----- Slave 0 -----//
    // Read address
    output [3:0]  s0_axi_arid   ,
    output [31:0] s0_axi_araddr ,
    output [7:0]  s0_axi_arlen  ,
    output [2:0]  s0_axi_arsize ,
    output [1:0]  s0_axi_arburst,
    output        s0_axi_arvalid,
    input         s0_axi_arready,
    // Read data
    input  [3:0]  s0_axi_rid    ,
    input  [31:0] s0_axi_rdata  ,
    input  [1:0]  s0_axi_rresp  ,
    input         s0_axi_rlast  ,
    input         s0_axi_rvalid ,
    output        s0_axi_rready ,
    //----- Slave 1 -----//
    // Read address
    output [3:0]  s1_axi_arid   ,
    output [31:0] s1_axi_araddr ,
    output [7:0]  s1_axi_arlen  ,
    output [2:0]  s1_axi_arsize ,
    output [1:0]  s1_axi_arburst,
    output        s1_axi_arvalid,
    input         s1_axi_arready,
    // Read data
    input  [3:0]  s1_axi_rid    ,
    input  [31:0] s1_axi_rdata  ,
    input  [1:0]  s1_axi_rresp  ,
    input         s1_axi_rlast  ,
    input         s1_axi_rvalid ,
    output        s1_axi_rready ,
    //----- Slave 2 -----//
    // Read address
    output [3:0]  s2_axi_arid   ,
    output [31:0] s2_axi_araddr ,
    output [7:0]  s2_axi_arlen  ,
    output [2:0]  s2_axi_arsize ,
    output [1:0]  s2_axi_arburst,
    output        s2_axi_arvalid,
    input         s2_axi_arready,
    // Read data
    input  [3:0]  s2_axi_rid    ,
    input  [31:0] s2_axi_rdata  ,
    input  [1:0]  s2_axi_rresp  ,
    input         s2_axi_rlast  ,
    input         s2_axi_rvalid ,
    output        s2_axi_rready ,
    //----- Slave 3 -----//
    // Read address
    output [3:0]  s3_axi_arid   ,
    output [31:0] s3_axi_araddr ,
    output [7:0]  s3_axi_arlen  ,
    output [2:0]  s3_axi_arsize ,
    output [1:0]  s3_axi_arburst,
    output        s3_axi_arvalid,
    input         s3_axi_arready,
    // Read data
    input  [3:0]  s3_axi_rid    ,
    input  [31:0] s3_axi_rdata  ,
    input  [1:0]  s3_axi_rresp  ,
    input         s3_axi_rlast  ,
    input         s3_axi_rvalid ,
    output        s3_axi_rready ,
    //----- Master general -----//
    // Read address
    output        m_arready     ,
    // Read data
    output [3:0]  m_rid         ,
    output [31:0] m_rdata       ,
    output [1:0]  m_rresp       ,
    output        m_rlast       ,
    output        m_rvalid      ,
    //----- Slave general -----//
    // Read address
    input  [3:0]  s_arid        ,
    input  [31:0] s_araddr      ,
    input  [7:0]  s_arlen       ,
    input  [2:0]  s_arsize      ,
    input  [1:0]  s_arburst     ,
    input         s_arvalid     ,
    // Read data
    input         s_rready      
);
// ID register
reg [3:0] s_arid_r;
always @(posedge aclk or negedge aresetn) begin
    if (!aresetn)
        s_arid_r = 4'b0000;
    else
        s_arid_r = s_arid;
end
//----- Other signals -----//
reg        m_arready_r;
reg [3:0]  m_rid_r;    
reg [31:0] m_rdata_r;  
reg [1:0]  m_rresp_r;  
reg        m_rlast_r;  
reg        m_rvalid_r; 
always @(*) begin
    case (s_arid_r)
        4'b1000 : begin
            m_arready_r = s0_axi_rready;
            m_rid_r     = s0_axi_rid;
            m_rdata_r   = s0_axi_rdata;
            m_rresp_r   = s0_axi_rresp;
            m_rlast_r   = s0_axi_rlast;
            m_rvalid_r  = s0_axi_rvalid;
        end
        4'b0100 : begin
            m_arready_r = s1_axi_rready;
            m_rid_r     = s1_axi_rid;
            m_rdata_r   = s1_axi_rdata;
            m_rresp_r   = s1_axi_rresp;
            m_rlast_r   = s1_axi_rlast;
            m_rvalid_r  = s1_axi_rvalid;
        end
        4'b0010 : begin
            m_arready_r = s2_axi_rready;
            m_rid_r     = s2_axi_rid;
            m_rdata_r   = s2_axi_rdata;
            m_rresp_r   = s2_axi_rresp;
            m_rlast_r   = s2_axi_rlast;
            m_rvalid_r  = s2_axi_rvalid;
        end
        4'b0001 : begin
            m_arready_r = s3_axi_rready;
            m_rid_r     = s3_axi_rid;
            m_rdata_r   = s3_axi_rdata;
            m_rresp_r   = s3_axi_rresp;
            m_rlast_r   = s3_axi_rlast;
            m_rvalid_r  = s3_axi_rvalid;
        end
        default : begin
            m_arready_r = 1'b0 ;
            m_rid_r     = 4'd0 ;
            m_rdata_r   = 32'd0;
            m_rresp_r   = 2'd0 ;
            m_rlast_r   = 1'b0 ;
            m_rvalid_r  = 1'b0 ;
        end
    endcase
end
assign m_arready = m_arready_r;
assign m_rid     = m_rid_r    ;
assign m_rdata   = m_rdata_r  ;
assign m_rresp   = m_rresp_r  ;
assign m_rlast   = m_rlast_r  ;
assign m_rvalid  = m_rvalid_r ;
//----- ARID -----//
reg [3:0] s0_axi_arid_r;
reg [3:0] s1_axi_arid_r;
reg [3:0] s2_axi_arid_r;
reg [3:0] s3_axi_arid_r;
always @(*) begin
    case (s_arid_r)
        4'b1000 : begin
            s0_axi_arid_r = s_arid;
            s1_axi_arid_r = 4'd0;
            s2_axi_arid_r = 4'd0;
            s3_axi_arid_r = 4'd0;
        end
        4'b0100 : begin
            s0_axi_arid_r = 4'd0;
            s1_axi_arid_r = s_arid;
            s2_axi_arid_r = 4'd0;
            s3_axi_arid_r = 4'd0;
        end
        4'b0010 : begin
            s0_axi_arid_r = 4'd0;
            s1_axi_arid_r = 4'd0;
            s2_axi_arid_r = s_arid;
            s3_axi_arid_r = 4'd0;
        end
        4'b0001 : begin
            s0_axi_arid_r = 4'd0;
            s1_axi_arid_r = 4'd0;
            s2_axi_arid_r = 4'd0;
            s3_axi_arid_r = s_arid;
        end
        default : begin
            s0_axi_arid_r = 4'd0;
            s1_axi_arid_r = 4'd0;
            s2_axi_arid_r = 4'd0;
            s3_axi_arid_r = 4'd0;
        end
    endcase
end
assign s0_axi_arid = s0_axi_arid_r;
assign s1_axi_arid = s1_axi_arid_r;
assign s2_axi_arid = s2_axi_arid_r;
assign s3_axi_arid = s3_axi_arid_r;
//----- ARADDR -----//
reg [31:0] s0_axi_araddr_r;
reg [31:0] s1_axi_araddr_r;
reg [31:0] s2_axi_araddr_r;
reg [31:0] s3_axi_araddr_r;
always @(*) begin
    case (s_arid_r)
        4'b1000 : begin
            s0_axi_araddr_r = s_araddr;
            s1_axi_araddr_r = 32'd0;
            s2_axi_araddr_r = 32'd0;
            s3_axi_araddr_r = 32'd0;
        end
        4'b0100 : begin
            s0_axi_araddr_r = 32'd0;
            s1_axi_araddr_r = s_araddr;
            s2_axi_araddr_r = 32'd0;
            s3_axi_araddr_r = 32'd0;
        end
        4'b0010 : begin
            s0_axi_araddr_r = 32'd0;
            s1_axi_araddr_r = 32'd0;
            s2_axi_araddr_r = s_araddr;
            s3_axi_araddr_r = 32'd0;
        end
        4'b0001 : begin
            s0_axi_araddr_r = 32'd0;
            s1_axi_araddr_r = 32'd0;
            s2_axi_araddr_r = 32'd0;
            s3_axi_araddr_r = s_araddr;
        end
        default : begin
            s0_axi_araddr_r = 32'd0;
            s1_axi_araddr_r = 32'd0;
            s2_axi_araddr_r = 32'd0;
            s3_axi_araddr_r = 32'd0;
        end
    endcase
end
assign s0_axi_araddr = s0_axi_araddr_r;
assign s1_axi_araddr = s1_axi_araddr_r;
assign s2_axi_araddr = s2_axi_araddr_r;
assign s3_axi_araddr = s3_axi_araddr_r;
//----- ARLEN -----//
reg [7:0] s0_axi_arlen_r;
reg [7:0] s1_axi_arlen_r;
reg [7:0] s2_axi_arlen_r;
reg [7:0] s3_axi_arlen_r;
always @(*) begin
    case (s_arid_r)
        4'b1000 : begin
            s0_axi_arlen_r = s_arlen;
            s1_axi_arlen_r = 8'd0;
            s2_axi_arlen_r = 8'd0;
            s3_axi_arlen_r = 8'd0;
        end
        4'b0100 : begin
            s0_axi_arlen_r = 8'd0;
            s1_axi_arlen_r = s_arlen;
            s2_axi_arlen_r = 8'd0;
            s3_axi_arlen_r = 8'd0;
        end
        4'b0010 : begin
            s0_axi_arlen_r = 8'd0;
            s1_axi_arlen_r = 8'd0;
            s2_axi_arlen_r = s_arlen;
            s3_axi_arlen_r = 8'd0;
        end
        4'b0001 : begin
            s0_axi_arlen_r = 8'd0;
            s1_axi_arlen_r = 8'd0;
            s2_axi_arlen_r = 8'd0;
            s3_axi_arlen_r = s_arlen;
        end
        default : begin
            s0_axi_arlen_r = 8'd0;
            s1_axi_arlen_r = 8'd0;
            s2_axi_arlen_r = 8'd0;
            s3_axi_arlen_r = 8'd0;
        end
    endcase
end
assign s0_axi_arlen = s0_axi_arlen_r;
assign s1_axi_arlen = s1_axi_arlen_r;
assign s2_axi_arlen = s2_axi_arlen_r;
assign s3_axi_arlen = s3_axi_arlen_r;
//----- ARSIZE -----//
reg [2:0] s0_axi_arsize_r;
reg [2:0] s1_axi_arsize_r;
reg [2:0] s2_axi_arsize_r;
reg [2:0] s3_axi_arsize_r;
always @(*) begin
    case (s_arid_r)
        4'b1000 : begin
            s0_axi_arsize_r = s_arsize;
            s1_axi_arsize_r = 3'd0;
            s2_axi_arsize_r = 3'd0;
            s3_axi_arsize_r = 3'd0;
        end
        4'b0100 : begin
            s0_axi_arsize_r = 3'd0;
            s1_axi_arsize_r = s_arsize;
            s2_axi_arsize_r = 3'd0;
            s3_axi_arsize_r = 3'd0;
        end
        4'b0010 : begin
            s0_axi_arsize_r = 3'd0;
            s1_axi_arsize_r = 3'd0;
            s2_axi_arsize_r = s_arsize;
            s3_axi_arsize_r = 3'd0;
        end
        4'b0001 : begin
            s0_axi_arsize_r = 3'd0;
            s1_axi_arsize_r = 3'd0;
            s2_axi_arsize_r = 3'd0;
            s3_axi_arsize_r = s_arsize;
        end
        default : begin
            s0_axi_arsize_r = 3'd0;
            s1_axi_arsize_r = 3'd0;
            s2_axi_arsize_r = 3'd0;
            s3_axi_arsize_r = 3'd0;
        end
    endcase
end
assign s0_axi_arsize = s0_axi_arsize_r;
assign s1_axi_arsize = s1_axi_arsize_r;
assign s2_axi_arsize = s2_axi_arsize_r;
assign s3_axi_arsize = s3_axi_arsize_r;
//----- ARBURST -----//
reg [1:0] s0_axi_arburst_r;
reg [1:0] s1_axi_arburst_r;
reg [1:0] s2_axi_arburst_r;
reg [1:0] s3_axi_arburst_r;
always @(*) begin
    case (s_arid_r)
        4'b1000 : begin
            s0_axi_arburst_r = s_arburst;
            s1_axi_arburst_r = 2'd0;
            s2_axi_arburst_r = 2'd0;
            s3_axi_arburst_r = 2'd0;
        end
        4'b0100 : begin
            s0_axi_arburst_r = 2'd0;
            s1_axi_arburst_r = s_arburst;
            s2_axi_arburst_r = 2'd0;
            s3_axi_arburst_r = 2'd0;
        end
        4'b0010 : begin
            s0_axi_arburst_r = 2'd0;
            s1_axi_arburst_r = 2'd0;
            s2_axi_arburst_r = s_arburst;
            s3_axi_arburst_r = 2'd0;
        end
        4'b0001 : begin
            s0_axi_arburst_r = 2'd0;
            s1_axi_arburst_r = 2'd0;
            s2_axi_arburst_r = 2'd0;
            s3_axi_arburst_r = s_arburst;
        end
        default : begin
            s0_axi_arburst_r = 2'd0;
            s1_axi_arburst_r = 2'd0;
            s2_axi_arburst_r = 2'd0;
            s3_axi_arburst_r = 2'd0;
        end
    endcase
end
assign s0_axi_arburst = s0_axi_arburst_r;
assign s1_axi_arburst = s1_axi_arburst_r;
assign s2_axi_arburst = s2_axi_arburst_r;
assign s3_axi_arburst = s3_axi_arburst_r;
//----- ARVALID -----//
reg s0_axi_arvalid_r;
reg s1_axi_arvalid_r;
reg s2_axi_arvalid_r;
reg s3_axi_arvalid_r;
always @(*) begin
    case (s_arid_r)
        4'b1000 : begin
            s0_axi_arvalid_r = s_arvalid;
            s1_axi_arvalid_r = 1'b0;
            s2_axi_arvalid_r = 1'b0;
            s3_axi_arvalid_r = 1'b0;
        end
        4'b0100 : begin
            s0_axi_arvalid_r = 1'b0;
            s1_axi_arvalid_r = s_arvalid;
            s2_axi_arvalid_r = 1'b0;
            s3_axi_arvalid_r = 1'b0;
        end
        4'b0010 : begin
            s0_axi_arvalid_r = 1'b0;
            s1_axi_arvalid_r = 1'b0;
            s2_axi_arvalid_r = s_arvalid;
            s3_axi_arvalid_r = 1'b0;
        end
        4'b0001 : begin
            s0_axi_arvalid_r = 1'b0;
            s1_axi_arvalid_r = 1'b0;
            s2_axi_arvalid_r = 1'b0;
            s3_axi_arvalid_r = s_arvalid;
        end
        default : begin
            s0_axi_arvalid_r = 1'b0;
            s1_axi_arvalid_r = 1'b0;
            s2_axi_arvalid_r = 1'b0;
            s3_axi_arvalid_r = 1'b0;
        end
    endcase
end
assign s0_axi_arvalid = s0_axi_arvalid_r;
assign s1_axi_arvalid = s1_axi_arvalid_r;
assign s2_axi_arvalid = s2_axi_arvalid_r;
assign s3_axi_arvalid = s3_axi_arvalid_r;
//----- RREADY -----//
reg s0_axi_rready_r;
reg s1_axi_rready_r;
reg s2_axi_rready_r;
reg s3_axi_rready_r;
always @(*) begin
    case (s_arid_r)
        4'b1000 : begin
            s0_axi_rready_r = s_rready;
            s1_axi_rready_r = 1'b0;
            s2_axi_rready_r = 1'b0;
            s3_axi_rready_r = 1'b0;
        end
        4'b0100 : begin
            s0_axi_rready_r = 1'b0;
            s1_axi_rready_r = s_rready;
            s2_axi_rready_r = 1'b0;
            s3_axi_rready_r = 1'b0;
        end
        4'b0010 : begin
            s0_axi_rready_r = 1'b0;
            s1_axi_rready_r = 1'b0;
            s2_axi_rready_r = s_rready;
            s3_axi_rready_r = 1'b0;
        end
        4'b0001 : begin
            s0_axi_rready_r = 1'b0;
            s1_axi_rready_r = 1'b0;
            s2_axi_rready_r = 1'b0;
            s3_axi_rready_r = s_rready;
        end
        default : begin
            s0_axi_rready_r = 1'b0;
            s1_axi_rready_r = 1'b0;
            s2_axi_rready_r = 1'b0;
            s3_axi_rready_r = 1'b0;
        end
    endcase
end
assign s0_axi_rready = s0_axi_rready_r;
assign s1_axi_rready = s1_axi_rready_r;
assign s2_axi_rready = s2_axi_rready_r;
assign s3_axi_rready = s3_axi_rready_r;
endmodule