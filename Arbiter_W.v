module Arbiter_W (
    //----- Global -----//
    input         aclk           ,
    input         aresetn        ,
    //----- Master 0 -----//
    // Write adress
    input         m0_awvalid     ,
    // Write data
    input         m0_wvalid      ,
    // Write response
    input         m0_bready      ,
    //----- Master 1 -----//
    // Write adress
    input         m1_awvalid     ,
    // Write data
    input         m1_wvalid      ,
    // Write response
    input         m1_bready      ,
    //----- Master 2 -----//
    // Write adress
    input         m2_awvalid     ,
    // Write data
    input         m2_wvalid      ,
    // Write response
    input         m2_bready      ,
    //----- Master 3 -----//
    // Write adress
    input         m3_awvalid     ,
    // Write data
    input         m3_wvalid      ,
    // Write response
    input         m3_bready      ,
    //----- General signals -----//
    input         m_awready      ,
    input         m_wready       ,
    input         m_bvalid       ,
    output        m0_write_accept,
    output        m1_write_accept,
    output        m2_write_accept,
    output        m3_write_accept 
);
//----- Local parameter -----//
localparam MASTER_0 = 2'b00;
localparam MASTER_1 = 2'b01;
localparam MASTER_2 = 2'b10;
localparam MASTER_3 = 2'b11;
//----- FSM -----//
reg [1:0] CURRENT_STATE;
reg [1:0] NEXT_STATE;
always @(*) begin
    case (CURRENT_STATE)
        MASTER_0 : begin
            if (m0_awvalid)
                NEXT_STATE = MASTER_0;
            else if (m0_wvalid || m_wready)
                NEXT_STATE = MASTER_0;
            else if (m_bvalid && m0_bready)
                NEXT_STATE = MASTER_1;
            else if (m1_awvalid)
                NEXT_STATE = MASTER_1;
            else if (m2_awvalid)
                NEXT_STATE = MASTER_2;
            else if (m3_awvalid)
                NEXT_STATE = MASTER_3;
            else
                NEXT_STATE = MASTER_0;
        end
        MASTER_1 : begin
            if (m1_awvalid)
                NEXT_STATE = MASTER_1;
            else if (m1_wvalid || m_wready)
                NEXT_STATE = MASTER_1;
            else if (m_bvalid && m1_bready)
                NEXT_STATE = MASTER_2;
            else if (m2_awvalid)
                NEXT_STATE = MASTER_2;
            else if (m3_awvalid)
                NEXT_STATE = MASTER_3;
            else if (m0_awvalid)
                NEXT_STATE = MASTER_0;
            else
                NEXT_STATE = MASTER_1;
        end
        MASTER_2 : begin
            if (m2_awvalid)
                NEXT_STATE = MASTER_2;
            else if (m2_wvalid || m_wready)
                NEXT_STATE = MASTER_2;
            else if (m_bvalid && m2_bready)
                NEXT_STATE = MASTER_3;
            else if (m3_awvalid)
                NEXT_STATE = MASTER_3;
            else if (m0_awvalid)
                NEXT_STATE = MASTER_0;
            else if (m1_awvalid)
                NEXT_STATE = MASTER_1;
            else
                NEXT_STATE = MASTER_2;
        end
        MASTER_3 : begin
            if (m3_awvalid)
                NEXT_STATE = MASTER_3;
            else if (m3_wvalid || m_wready)
                NEXT_STATE = MASTER_3;
            else if (m_bvalid && m3_bready)
                NEXT_STATE = MASTER_0;
            else if (m0_awvalid)
                NEXT_STATE = MASTER_0;
            else if (m1_awvalid)
                NEXT_STATE = MASTER_1;
            else if (m2_awvalid)
                NEXT_STATE = MASTER_2;
            else
                NEXT_STATE = MASTER_3;
        end
        default : begin
            NEXT_STATE = MASTER_0;
        end
    endcase
end
// State register
always @(posedge aclk or negedge aresetn) begin
    if (!aresetn)
        CURRENT_STATE <= MASTER_0;
    else
        CURRENT_STATE <= NEXT_STATE;
end
// State control
reg m0_write_accept_r;
reg m1_write_accept_r;
reg m2_write_accept_r;
reg m3_write_accept_r;
always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
        m0_write_accept_r <= 1'b0;
        m1_write_accept_r <= 1'b0;
        m2_write_accept_r <= 1'b0;
        m3_write_accept_r <= 1'b0;
    end
    else begin
        m0_write_accept_r <= m0_write_accept;
        m1_write_accept_r <= m1_write_accept;
        m2_write_accept_r <= m2_write_accept;
        m3_write_accept_r <= m3_write_accept;
    end
end
always @(*) begin
    case (CURRENT_STATE)
        MASTER_0 : {m0_write_accept_r, m1_write_accept_r, m2_write_accept_r, m3_write_accept_r} = 4'b1000;
        MASTER_1 : {m0_write_accept_r, m1_write_accept_r, m2_write_accept_r, m3_write_accept_r} = 4'b0100;
        MASTER_2 : {m0_write_accept_r, m1_write_accept_r, m2_write_accept_r, m3_write_accept_r} = 4'b0010;
        MASTER_3 : {m0_write_accept_r, m1_write_accept_r, m2_write_accept_r, m3_write_accept_r} = 4'b0001;
        default  : {m0_write_accept_r, m1_write_accept_r, m2_write_accept_r, m3_write_accept_r} = 4'b0000;
    endcase
end
endmodule