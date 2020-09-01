""" =======================  Import dependencies ========================== """
import numpy as np
import math
import re
import config
from PyQt5 import QtCore, QtGui, QtWidgets, Qt
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
import sys
""" ======================  Function definitions ========================== """
def write_io(fp, name):
    fp.write('module ' + name + '_top(\n')
    fp.write('           wb_adr_i, wb_cyc_i, wb_dat_i, wb_sel_i,\n')
    fp.write('           wb_stb_i, wb_we_i,\n')
    fp.write('           wb_ack_o, wb_err_o, wb_dat_o,\n')
    fp.write('           wb_clk_i, wb_rst_i, int_o\n')
    fp.write('       );\n')
    fp.write('parameter dw = 32;\n')
    fp.write('parameter aw = 32;\n')
    fp.write('input [aw-1:0] wb_adr_i;\n')
    fp.write('input   wb_cyc_i;\n')
    fp.write('input [dw-1:0]  wb_dat_i;\n')
    fp.write('input [3:0]   wb_sel_i;\n')
    fp.write('input   wb_stb_i;\n')
    fp.write('input   wb_we_i;\n')
    fp.write('output   wb_ack_o;\n')
    fp.write('output   wb_err_o;\n')
    fp.write('output reg [dw-1:0]  wb_dat_o;\n')
    fp.write('output  int_o;\n')
    fp.write('input   wb_clk_i;\n')
    fp.write('input   wb_rst_i;\n')
    fp.write('\n')
    fp.write('\n')
    fp.write('\n')


    fp.write("assign wb_ack_o = 1'b1;\n")
    fp.write("assign wb_err_o = 1'b0;\n")
    fp.write("assign int_o = 1'b0;\n")

def write_reg(fp, name):
    fp.write("reg startHash, startHash_r;\n")
    if name == 'sha256':
        fp.write("reg newMessage, newMessage_r;\n")
        fp.write("reg [31:0] data [0:15];\n")
    if name == 'md5':
        fp.write("reg newMessage, newMessage_r;\n")
        fp.write("reg [31:0] data [0:15];\n")
    fp.write("wire [511:0] bigData = {data[15], data[14], data[13], data[12], data[11], data[10], data[9], data[8], data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};\n")
    fp.write("wire [255:0] hash;\n")
    fp.write("wire ready;\n")
    fp.write("wire hashValid;\n")

def write_ws(fp, name):
    fp.write("always @(posedge wb_clk_i)\n")
    fp.write("    begin\n")
    fp.write("        if(!wb_rst_i)\n")
    fp.write("            begin\n")
    fp.write("                startHash       <= 0;\n")
    fp.write("                startHash_r     <= 0;\n")
    if name == 'sha256':
        fp.write("                newMessage      <= 0;\n")
        fp.write("                newMessage_r    <= 0;\n")
    if name == 'md5':
        fp.write("                message_reset   <= 0;\n")
        fp.write("                message_reset_r <= 0;\n")
    for i in range(16):
        fp.write("                data[" + str(i) + "] <= 0;\n")
    fp.write("            end\n")
    fp.write("        else begin\n")
    if name == 'sha256':
        fp.write("            startHash_r         <= startHash;\n")
        fp.write("            newMessage_r        <= newMessage;\n")
        fp.write("            if(wb_stb_i & wb_we_i) begin\n")
        fp.write("                case(wb_adr_i[6:2])\n")
        fp.write("                    0:  begin\n")
        fp.write("                            startHash <= wb_dat_i[0];\n")
        fp.write("                            newMessage <= wb_dat_i[1];\n")
        fp.write("                        end\n")
        for i in range(16):
            fp.write('                    ' + str(i + 1) + ':  data[' + str(i) + '] <= wb_dat_i;\n')
    if name == 'md5':
        fp.write("            startHash_r         <= startHash;\n")
        fp.write("            message_reset_r     <= message_reset;\n")
        fp.write("            if(wb_stb_i & wb_we_i) begin\n")
        fp.write("                case(wb_adr_i[6:2])\n")
        fp.write("                    0: startHash        <= wb_dat_i[0];\n")
        for i in range(15):
            fp.write('                    ' + str(i + 1) + ': data[' + str(15 - i) + ']         <= wb_dat_i;\n')
        fp.write("                    22: message_reset   <= wb_dat_i[0];\n")
    fp.write("                    default:\n")
    fp.write("                        ;\n")
    fp.write("                endcase\n")
    fp.write("            end else begin\n")
    fp.write("                startHash           <= 1'b0;\n")
    fp.write("                newMessage          <= 1'b0;\n")
    fp.write("            end\n")
    fp.write("        end\n")
    fp.write("    end\n")

def write_rs(fp, name):
    fp.write("always @(*)\n")
    fp.write("    begin\n")
    fp.write("        case(wb_adr_i[6:2])\n")
    fp.write("            0:  wb_dat_o = {31'b0, ready};\n")
    if name == 'sha256':
        for i in range(16):
            fp.write("            " + str(i + 1) + ":  wb_dat_o = data[" + str(i) + "];\n")
        fp.write("            17: wb_dat_o = {31'b0, hashValid};\n")
        fp.write("            18: wb_dat_o = hash[31:0];\n")
        fp.write("            19: wb_dat_o = hash[63:32];\n")
        fp.write("            20: wb_dat_o = hash[95:64];\n")
        fp.write("            21: wb_dat_o = hash[127:96];\n")
        fp.write("            22: wb_dat_o = hash[159:128];\n")
        fp.write("            23: wb_dat_o = hash[191:160];\n")
        fp.write("            24: wb_dat_o = hash[223:192];\n")
        fp.write("            25: wb_dat_o = hash[255:224];\n")

    if name == 'md5':
        for i in range(16):
            fp.write("            " + str(i + 1) + ":  wb_dat_o = data[" + str(15 - i) + "];\n")
        fp.write("            17: wb_dat_o = {31'b0, hashValid};\n")
        fp.write("            21: wb_dat_o = hash[127:96];\n")
        fp.write("            20: wb_dat_o = hash[95:64];\n")
        fp.write("            19: wb_dat_o = hash[63:32];\n")
        fp.write("            18: wb_dat_o = hash[31:0];\n")
    fp.write("            default:\n")
    fp.write("                wb_dat_o = 32'b0;\n")
    fp.write("        endcase\n")
    fp.write("    end\n")

def write_ip(fp, name):
    if name == 'sha256':
        fp.write("sha256_core sha256_core(\n")
        fp.write("           .clk(wb_clk_i),\n")
        fp.write("           .rst_n(wb_rst_i),\n")
        fp.write("           .init(startHash && ~startHash_r),\n")
        fp.write("           .next(newMessage && ~newMessage_r),\n")
        fp.write("           .block(bigData),\n")
        fp.write("           .digest(hash),\n")
        fp.write("           .digest_valid(hashValid),\n")
        fp.write("           .ready(ready)\n")
        fp.write("       );\n")
    if name == 'md5':
        fp.write("pancham pancham(\n")
        fp.write("            .clk(wb_clk_i),\n")
        fp.write("            .rst(wb_rst_i | (message_reset & ~message_reset_r)),\n")
        fp.write("            .msg_padded(bigData),\n")
        fp.write("            .msg_in_valid(startHash && ~startHash_r),\n")
        fp.write("            .msg_output(hash),\n")
        fp.write("            .msg_out_valid(hashValid),\n")
        fp.write("            .ready(ready)\n")
        fp.write("        );\n")
    fp.write("endmodule\n")


""" ====================== GUI ========================== """
class Ui_MainWindow(QtWidgets.QMainWindow):

    def __init__(self):
        super(Ui_MainWindow,self).__init__()
        self.setupUi(self)
        self.retranslateUi(self)

    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(700, 300)
        self.centralWidget = QtWidgets.QWidget(MainWindow)
        self.centralWidget.setObjectName("centralWidget")
        self.retranslateUi(MainWindow)

        self.pushButton = QtWidgets.QPushButton(self.centralWidget)
        self.pushButton.setGeometry(QtCore.QRect(10, 10, 75, 23))
        self.pushButton.setObjectName("pushButton")
        self.pushButton.setText("Open")
        MainWindow.setCentralWidget(self.centralWidget)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

        self.pushButton.clicked.connect(self.openfile)

        self.textEdit = QtWidgets.QTextEdit(self.centralWidget)
        self.setCentralWidget(self.textEdit)
        self.statusBar()
         
        a = 1
    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "Wishbone Bus Generator"))


    def openfile(self):
        openfile_name = QFileDialog.getOpenFileName(self,'Choose File')
        openfile_name = "".join(list(openfile_name[0]))
        self.textEdit.setText(openfile_name)
""" ====================== Variable Declaration ========================== """
#NAME = 'sha256'                            # tb name 

""" ====================== Input Generation ========================== """
#fp = open('%s_wrapper.txt' % NAME, 'w')

if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())

write_io(fp, NAME)
write_reg(fp, NAME)
write_ws(fp, NAME)
write_rs(fp, NAME)
write_ip(fp, NAME)
fp.close()

