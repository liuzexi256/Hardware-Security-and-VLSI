module aes_192_top(
           wb_adr_i, wb_cyc_i, wb_dat_i, wb_sel_i,
           wb_stb_i, wb_we_i,
           wb_ack_o, wb_err_o, wb_dat_o,
           wb_clk_i, wb_rst_i, int_o
       );
parameter dw = 32;
parameter aw = 32;
input [aw-1:0] wb_adr_i;
input   wb_cyc_i;
input [dw-1:0]  wb_dat_i;
input [3:0]   wb_sel_i;
input   wb_stb_i;
input   wb_we_i;
output   wb_ack_o;
output   wb_err_o;
output reg [dw-1:0]  wb_dat_o;
output  int_o;
input   wb_clk_i;
input   wb_rst_i;
assign wb_ack_o = 1'b1;
assign wb_err_o = 1'b0;
assign int_o = 1'b0;
reg start, start_r;
reg [31:0] data [0:3];
wire [127:0] bigData = {data[3], data[2], data[1], data[0]};
wire [127:0] valid;
wire ready_for_res;
reg wb_stb_i_r;
reg [31:0] key [0:5];
wire [191:0] bigKey = {key[5], key[4], key[3], key[2], key[1], key[0]};
always @(posedge wb_clk_i)
    begin
        if(!wb_rst_i)
            begin
                start       <= 0;
                start_r     <= 0;
                data[0] <= 0;
                data[1] <= 0;
                data[2] <= 0;
                data[3] <= 0;
                key[0] <= 0;
                key[1] <= 0;
                key[2] <= 0;
                key[3] <= 0;
                key[4] <= 0;
                key[5] <= 0;
                wb_stb_i_r  <= 1'b0;
            end
        else begin
            start_r         <= start;
            wb_stb_i_r      <= wb_stb_i;
            if(wb_stb_i & wb_we_i) begin
                case(wb_adr_i[6:2])
                    0:  start <= wb_dat_i[0]
                    1:  data[0] <= wb_dat_i;
                    2:  data[1] <= wb_dat_i;
                    3:  data[2] <= wb_dat_i;
                    4:  data[3] <= wb_dat_i;
                    5:  key[0] <= wb_dat_i;
                    6:  key[1] <= wb_dat_i;
                    7:  key[2] <= wb_dat_i;
                    8:  key[3] <= wb_dat_i;
                    9:  key[4] <= wb_dat_i;
                    10:  key[5] <= wb_dat_i;
                    default:
                        ;
                endcase
            end else begin
                start           <= 1'b0;
            end
        end
    end
always @(*)
    begin
        case(wb_adr_i[6:2])
            5:  wb_dat_o = key[0];
            6:  wb_dat_o = key[1];
            7:  wb_dat_o = key[2];
            8:  wb_dat_o = key[3];
            9:  wb_dat_o = key[4];
            10:  wb_dat_o = key[5];
            1:  wb_dat_o = data[0];
            2:  wb_dat_o = data[1];
            3:  wb_dat_o = data[2];
            4:  wb_dat_o = data[3];
            11:  wb_dat_o = {31'b0, ready_for_res};
            12: wb_dat_o = valid[31:0];
            13: wb_dat_o = valid[63:32];
            14: wb_dat_o = valid[95:64];
            15: wb_dat_o = valid[127:96];
            default:
                wb_dat_o = 32'b0;
        endcase
    end
aes_192 aes_192(
           .clk(wb_clk_i),
           .rst(wb_rst_i),
           .start(start && ~start_r),
           .key(bigKey),
           .state(bigData),
           .out_valid(ready_for_res),
           .out(valid)
        );
endmodule
