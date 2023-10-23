module Master_Mux_R (
    //----- Global -----//
    input         aclk          ,
    input         aresetn       ,
    //----- Master 0 -----//
    // Read address
    input  [3:0]  m0_axi_arid   ,
    input  [31:0] m0_axi_araddr ,
    input  [7:0]  m0_axi_arlen  ,
    input  [2:0]  m0_axi_arsize ,
    input  [1:0]  m0_axi_arburst,
    input         m0_axi_arvalid,
    output        m0_axi_arready,
    // Read data
    output [3:0]  m0_axi_rid    ,
    output [31:0] m0_axi_rdata  ,
    output [1:0]  m0_axi_rresp  ,
    output        m0_axi_rlast  ,
    output        m0_axi_rvalid ,
    input         m0_axi_rready ,
    //----- Master 1 -----//
    // Read address
    input  [3:0]  m1_axi_arid   ,
    input  [31:0] m1_axi_araddr ,
    input  [7:0]  m1_axi_arlen  ,
    input  [2:0]  m1_axi_arsize ,
    input  [1:0]  m1_axi_arburst,
    input         m1_axi_arvalid,
    output        m1_axi_arready,
    // Read data
    output [3:0]  m1_axi_rid    ,
    output [31:0] m1_axi_rdata  ,
    output [1:0]  m1_axi_rresp  ,
    output        m1_axi_rlast  ,
    output        m1_axi_rvalid ,
    input         m1_axi_rready ,
    //----- Master 2 -----//
    // Read address
    input  [3:0]  m2_axi_arid   ,
    input  [31:0] m2_axi_araddr ,
    input  [7:0]  m2_axi_arlen  ,
    input  [2:0]  m2_axi_arsize ,
    input  [1:0]  m2_axi_arburst,
    input         m2_axi_arvalid,
    output        m2_axi_arready,
    // Read data
    output [3:0]  m2_axi_rid    ,
    output [31:0] m2_axi_rdata  ,
    output [1:0]  m2_axi_rresp  ,
    output        m2_axi_rlast  ,
    output        m2_axi_rvalid ,
    input         m2_axi_rready ,
    //----- Master 3 -----//
    // Read address
    input  [3:0]  m3_axi_arid   ,
    input  [31:0] m3_axi_araddr ,
    input  [7:0]  m3_axi_arlen  ,
    input  [2:0]  m3_axi_arsize ,
    input  [1:0]  m3_axi_arburst,
    input         m3_axi_arvalid,
    output        m3_axi_arready,
    // Read data
    output [3:0]  m3_axi_rid    ,
    output [31:0] m3_axi_rdata  ,
    output [1:0]  m3_axi_rresp  ,
    output        m3_axi_rlast  ,
    output        m3_axi_rvalid ,
    input         m3_axi_rready ,
    //----- Slave general -----//
    // Read address
    output [3:0]  s_arid        ,
    output [31:0] s_araddr      ,
    output [7:0]  s_arlen       ,
    output [2:0]  s_arsize      ,
    output [1:0]  s_arburst     ,
    output        s_arvalid     ,
    // Read data
    output        s_rready      ,
    //----- Master general -----//
    // Read address
    input         m_arready     ,
    // Read data
    input  [3:0]  m_rid         ,
    input  [31:0] m_rdata       ,
    input  [1:0]  m_rresp       ,
    input         m_rlast       ,
    input         m_rvalid      ,
    //----- Control signals -----//
    input         m0_read_accept,
    input         m1_read_accept,
    input         m2_read_accept,
    input         m3_read_accept
);
//----- Other signals -----//
reg [3:0]  s_arid_r   ;
reg [31:0] s_araddr_r ;
reg [7:0]  s_arlen_r  ;
reg [2:0]  s_arsize_r ;
reg [1:0]  s_arburst_r;
reg        s_arvalid_r;
reg        s_rready_r ;
always @(*) begin
    case ({m0_read_accept, m1_read_accept, m2_read_accept, m3_read_accept})
        4'b1000 : begin
            s_arid_r    = m0_axi_arid   ;
            s_araddr_r  = m0_axi_araddr ;
            s_arlen_r   = m0_axi_arlen  ;
            s_arsize_r  = m0_axi_arsize ;
            s_arburst_r = m0_axi_arburst;
            s_arvalid_r = m0_axi_arvalid;
            s_rready_r  = m0_axi_rready ;
        end
        4'b0100 : begin
            s_arid_r    = m1_axi_arid   ;
            s_araddr_r  = m1_axi_araddr ;
            s_arlen_r   = m1_axi_arlen  ;
            s_arsize_r  = m1_axi_arsize ;
            s_arburst_r = m1_axi_arburst;
            s_arvalid_r = m1_axi_arvalid;
            s_rready_r  = m1_axi_rready ;
        end
        4'b0010 : begin
            s_arid_r    = m2_axi_arid   ;
            s_araddr_r  = m2_axi_araddr ;
            s_arlen_r   = m2_axi_arlen  ;
            s_arsize_r  = m2_axi_arsize ;
            s_arburst_r = m2_axi_arburst;
            s_arvalid_r = m2_axi_arvalid;
            s_rready_r  = m2_axi_rready ;
        end
        4'b0001 : begin
            s_arid_r    = m3_axi_arid   ;
            s_araddr_r  = m3_axi_araddr ;
            s_arlen_r   = m3_axi_arlen  ;
            s_arsize_r  = m3_axi_arsize ;
            s_arburst_r = m3_axi_arburst;
            s_arvalid_r = m3_axi_arvalid;
            s_rready_r  = m3_axi_rready ;
        end
        default : begin
            s_arid_r    = 4'd0 ;
            s_araddr_r  = 32'd0;
            s_arlen_r   = 8'd0 ;
            s_arsize_r  = 3'd0 ;
            s_arburst_r = 2'd0 ;
            s_arvalid_r = 1'b0 ;
            s_rready_r  = 1'b0 ;
        end
    endcase
end
assign s_arid    = s_arid_r   ;
assign s_araddr  = s_araddr_r ;
assign s_arlen   = s_arlen_r  ;
assign s_arsize  = s_arsize_r ;
assign s_arburst = s_arburst_r;
assign s_arvalid = s_arvalid_r;
assign s_rready  = s_rready_r ;
//----- ARREADY -----//
reg m0_axi_arready_r;
reg m1_axi_arready_r;
reg m2_axi_arready_r;
reg m3_axi_arready_r;
always @(*) begin
    case ({m0_read_accept, m1_read_accept, m2_read_accept, m3_read_accept})
        4'b1000 : begin
            m0_axi_arready_r = m_arready;
            m1_axi_arready_r = 1'b0;
            m2_axi_arready_r = 1'b0;
            m3_axi_arready_r = 1'b0;
        end
        4'b0100 : begin
            m0_axi_arready_r = 1'b0;
            m1_axi_arready_r = m_arready;
            m2_axi_arready_r = 1'b0;
            m3_axi_arready_r = 1'b0;
        end
        4'b0010 : begin
            m0_axi_arready_r = 1'b0;
            m1_axi_arready_r = 1'b0;
            m2_axi_arready_r = m_arready;
            m3_axi_arready_r = 1'b0;
        end
        4'b0001 : begin
            m0_axi_arready_r = 1'b0;
            m1_axi_arready_r = 1'b0;
            m2_axi_arready_r = 1'b0;
            m3_axi_arready_r = m_arready;
        end
        default : begin
            m0_axi_arready_r = 1'b0;
            m1_axi_arready_r = 1'b0;
            m2_axi_arready_r = 1'b0;
            m3_axi_arready_r = 1'b0;
        end
    endcase
end
assign m0_axi_arready = m0_axi_arready_r;
assign m1_axi_arready = m1_axi_arready_r;
assign m2_axi_arready = m2_axi_arready_r;
assign m3_axi_arready = m3_axi_arready_r;
//----- RID -----//
reg [3:0] m0_axi_rid_r;
reg [3:0] m1_axi_rid_r;
reg [3:0] m2_axi_rid_r;
reg [3:0] m3_axi_rid_r;
always @(*) begin
    case ({m0_read_accept, m1_read_accept, m2_read_accept, m3_read_accept})
        4'b1000 : begin
            m0_axi_rid_r = m_rid;
            m1_axi_rid_r = 4'd0;
            m2_axi_rid_r = 4'd0;
            m3_axi_rid_r = 4'd0;
        end
        4'b0100 : begin
            m0_axi_rid_r = 4'd0;
            m1_axi_rid_r = m_rid;
            m2_axi_rid_r = 4'd0;
            m3_axi_rid_r = 4'd0;
        end
        4'b0010 : begin
            m0_axi_rid_r = 4'd0;
            m1_axi_rid_r = 4'd0;
            m2_axi_rid_r = m_rid;
            m3_axi_rid_r = 4'd0;
        end
        4'b0001 : begin
            m0_axi_rid_r = 4'd0;
            m1_axi_rid_r = 4'd0;
            m2_axi_rid_r = 4'd0;
            m3_axi_rid_r = m_rid;
        end
        default : begin
            m0_axi_rid_r = 4'd0;
            m1_axi_rid_r = 4'd0;
            m2_axi_rid_r = 4'd0;
            m3_axi_rid_r = 4'd0;
        end
    endcase
end
assign m0_axi_rid = m0_axi_rid_r;
assign m1_axi_rid = m1_axi_rid_r;
assign m2_axi_rid = m2_axi_rid_r;
assign m3_axi_rid = m3_axi_rid_r;
//----- RDATA -----//
reg [31:0] m0_axi_rdata_r;
reg [31:0] m1_axi_rdata_r;
reg [31:0] m2_axi_rdata_r;
reg [31:0] m3_axi_rdata_r;
always @(*) begin
    case ({m0_read_accept, m1_read_accept, m2_read_accept, m3_read_accept})
        4'b1000 : begin
            m0_axi_rdata_r = m_rdata;
            m1_axi_rdata_r = 32'd0;
            m2_axi_rdata_r = 32'd0;
            m3_axi_rdata_r = 32'd0;
        end
        4'b0100 : begin
            m0_axi_rdata_r = 32'd0;
            m1_axi_rdata_r = m_rdata;
            m2_axi_rdata_r = 32'd0;
            m3_axi_rdata_r = 32'd0;
        end
        4'b0010 : begin
            m0_axi_rdata_r = 32'd0;
            m1_axi_rdata_r = 32'd0;
            m2_axi_rdata_r = m_rdata;
            m3_axi_rdata_r = 32'd0;
        end
        4'b0001 : begin
            m0_axi_rdata_r = 32'd0;
            m1_axi_rdata_r = 32'd0;
            m2_axi_rdata_r = 32'd0;
            m3_axi_rdata_r = m_rdata;
        end
        default : begin
            m0_axi_rdata_r = 32'd0;
            m1_axi_rdata_r = 32'd0;
            m2_axi_rdata_r = 32'd0;
            m3_axi_rdata_r = 32'd0;
        end
    endcase
end
assign m0_axi_rdata = m0_axi_rdata_r;
assign m1_axi_rdata = m1_axi_rdata_r;
assign m2_axi_rdata = m2_axi_rdata_r;
assign m3_axi_rdata = m3_axi_rdata_r;
//----- RRESP -----//
reg [1:0] m0_axi_rresp_r;
reg [1:0] m1_axi_rresp_r;
reg [1:0] m2_axi_rresp_r;
reg [1:0] m3_axi_rresp_r;
always @(*) begin
    case ({m0_read_accept, m1_read_accept, m2_read_accept, m3_read_accept})
        4'b1000 : begin
            m0_axi_rresp_r = m_rresp;
            m1_axi_rresp_r = 2'd0;
            m2_axi_rresp_r = 2'd0;
            m3_axi_rresp_r = 2'd0;
        end
        4'b0100 : begin
            m0_axi_rresp_r = 2'd0;
            m1_axi_rresp_r = m_rresp;
            m2_axi_rresp_r = 2'd0;
            m3_axi_rresp_r = 2'd0;
        end
        4'b0010 : begin
            m0_axi_rresp_r = 2'd0;
            m1_axi_rresp_r = 2'd0;
            m2_axi_rresp_r = m_rresp;
            m3_axi_rresp_r = 2'd0;
        end
        4'b0001 : begin
            m0_axi_rresp_r = 2'd0;
            m1_axi_rresp_r = 2'd0;
            m2_axi_rresp_r = 2'd0;
            m3_axi_rresp_r = m_rresp;
        end
        default : begin
            m0_axi_rresp_r = 2'd0;
            m1_axi_rresp_r = 2'd0;
            m2_axi_rresp_r = 2'd0;
            m3_axi_rresp_r = 2'd0;
        end
    endcase
end
assign m0_axi_rresp = m0_axi_rresp_r;
assign m1_axi_rresp = m1_axi_rresp_r;
assign m2_axi_rresp = m2_axi_rresp_r;
assign m3_axi_rresp = m3_axi_rresp_r;
//----- RLAST -----//
reg m0_axi_rlast_r;
reg m1_axi_rlast_r;
reg m2_axi_rlast_r;
reg m3_axi_rlast_r;
always @(*) begin
    case ({m0_read_accept, m1_read_accept, m2_read_accept, m3_read_accept})
        4'b1000 : begin
            m0_axi_rlast_r = m_rlast;
            m1_axi_rlast_r = 1'b0;
            m2_axi_rlast_r = 1'b0;
            m3_axi_rlast_r = 1'b0;
        end
        4'b0100 : begin
            m0_axi_rlast_r = 1'b0;
            m1_axi_rlast_r = m_rlast;
            m2_axi_rlast_r = 1'b0;
            m3_axi_rlast_r = 1'b0;
        end
        4'b0010 : begin
            m0_axi_rlast_r = 1'b0;
            m1_axi_rlast_r = 1'b0;
            m2_axi_rlast_r = m_rlast;
            m3_axi_rlast_r = 1'b0;
        end
        4'b0001 : begin
            m0_axi_rlast_r = 1'b0;
            m1_axi_rlast_r = 1'b0;
            m2_axi_rlast_r = 1'b0;
            m3_axi_rlast_r = m_rlast;
        end
        default : begin
            m0_axi_rlast_r = 1'b0;
            m1_axi_rlast_r = 1'b0;
            m2_axi_rlast_r = 1'b0;
            m3_axi_rlast_r = 1'b0;
        end
    endcase
end
assign m0_axi_rlast = m0_axi_rlast_r;
assign m1_axi_rlast = m1_axi_rlast_r;
assign m2_axi_rlast = m2_axi_rlast_r;
assign m3_axi_rlast = m3_axi_rlast_r;
//----- RVALID -----//
reg m0_axi_rvalid_r;
reg m1_axi_rvalid_r;
reg m2_axi_rvalid_r;
reg m3_axi_rvalid_r;
always @(*) begin
    case ({m0_read_accept, m1_read_accept, m2_read_accept, m3_read_accept})
        4'b1000 : begin
            m0_axi_rvalid_r = m_rvalid;
            m1_axi_rvalid_r = 1'b0;
            m2_axi_rvalid_r = 1'b0;
            m3_axi_rvalid_r = 1'b0;
        end
        4'b0100 : begin
            m0_axi_rvalid_r = 1'b0;
            m1_axi_rvalid_r = m_rvalid;
            m2_axi_rvalid_r = 1'b0;
            m3_axi_rvalid_r = 1'b0;
        end
        4'b0010 : begin
            m0_axi_rvalid_r = 1'b0;
            m1_axi_rvalid_r = 1'b0;
            m2_axi_rvalid_r = m_rvalid;
            m3_axi_rvalid_r = 1'b0;
        end
        4'b0001 : begin
            m0_axi_rvalid_r = 1'b0;
            m1_axi_rvalid_r = 1'b0;
            m2_axi_rvalid_r = 1'b0;
            m3_axi_rvalid_r = m_rvalid;
        end
        default : begin
            m0_axi_rvalid_r = 1'b0;
            m1_axi_rvalid_r = 1'b0;
            m2_axi_rvalid_r = 1'b0;
            m3_axi_rvalid_r = 1'b0;
        end 
    endcase
end
assign m0_axi_rvalid = m0_axi_rvalid_r;
assign m1_axi_rvalid = m1_axi_rvalid_r;
assign m2_axi_rvalid = m2_axi_rvalid_r;
assign m3_axi_rvalid = m3_axi_rvalid_r;
endmodule