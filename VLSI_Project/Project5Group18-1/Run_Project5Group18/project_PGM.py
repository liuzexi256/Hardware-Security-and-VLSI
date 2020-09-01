import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import multivariate_normal
import xlrd
import random
import datetime

def prob(train,test, threshold):
    # calculate the mean and cov
    #input: row vector
    #train
    start = datetime.datetime.now()
    mean = np.mean(train, axis=0)
    cov = np.cov(train.T)
    # label the test data
    prob_class1 = multivariate_normal.pdf(test, mean=mean, cov=cov,allow_singular=True)
    end = datetime.datetime.now()
    print("Train time used:", end - start)
    start = datetime.datetime.now()
    label_pos = []
    for k_label in range(0, test.shape[0]):
        if prob_class1[k_label] < threshold:
            labelk = 1
        else:
            labelk = 0
        label_pos.append(labelk)
    end = datetime.datetime.now()
    print("Test time used:", end - start)
    return label_pos



def loaddata():
    TF = np.zeros((1,8))
    TI = np.zeros((1,8))
    for i in range(1,34):
        name = 'Chip%d.xlsx'%i
        data = xlrd.open_workbook(name)
        table = data.sheet_by_index(0)
        TF = np.vstack((TF, np.array(table.row_values(0))))
        TF = np.vstack((TF, np.array(table.row_values(24))))
        for j in range(1,24):
            TI = np.vstack((TI, np.array(table.row_values(j))))
    return TF[1:, :], TI[1:, :]

def test(TF,TI,sample_number,threshold,row_number):
    index = range(0,66)
    index = np.array(index)
    random.shuffle(index)
    train = np.zeros((sample_number,8))
    test_TI = np.zeros((33,8))
    test_TF = np.zeros((66-sample_number,8))
    for i in range(0,sample_number):
        train[i,:] = TF[index[i],:]
    for i in range(0, 66-sample_number):
        test_TF[i,:] = TF[index[i+sample_number],:]
    for i in range(0,33):
        test_TI[i,:] = TI[row_number+i*23,:]
    lable_predict_TI = prob(train, test_TI, threshold)
    lable_predict_TF = prob(train, test_TF, threshold)
    TPR = sum(lable_predict_TI)/len(lable_predict_TI)
    FPR = sum(lable_predict_TF) / len(lable_predict_TF)
    accuracy = (sum(lable_predict_TI)+len(lable_predict_TF)-sum(lable_predict_TF))/(len(lable_predict_TI)+len(lable_predict_TF))
    return TPR,FPR,accuracy



'''calculate the TPR, FPR and accuracy'''
TF,TI = loaddata()
TPR_track = np.zeros((3,23))
FPR_track = np.zeros((3,23))
TPR_TF = np.zeros((3,23))
FPR_TF = np.zeros((3,23))
Accuracy = np.zeros((3,23))
for row in range(0,23):
    # 6 samples
    TPR = []
    FPR = []
    Accu = []
    for i in range (0,25):
        tpr,fpr,accuracy = test(TF,TI,6,10**(-7),row)
        TPR.append(tpr)
        FPR.append(fpr)
        Accu.append(accuracy)
    ave_tpr = np.mean(TPR)
    ave_fpr = np.mean(FPR)
    std_tpr = np.std(TPR)
    std_fpr = np.std(FPR)
    max_tpr = np.max(TPR)
    max_fpr = np.max(FPR)
    Accuracy[0,row] = np.mean(Accu)
    TPR_track[0, row] = ave_tpr
    FPR_track[0, row] = ave_fpr
    TPR_TF[0, row] = 1-ave_fpr
    FPR_TF[0, row] = 1 - ave_tpr



    # 12 samples
    TPR = []
    FPR = []
    Accu = []
    for i in range (0,25):
        tpr,fpr,accuracy = test(TF,TI,12,10**(-10),row)
        TPR.append(tpr)
        FPR.append(fpr)
        Accu.append(accuracy)
    ave_tpr = np.mean(TPR)
    ave_fpr = np.mean(FPR)
    std_tpr = np.std(TPR)
    std_fpr = np.std(FPR)
    max_tpr = np.max(TPR)
    max_fpr = np.max(FPR)
    Accuracy[1, row] = np.mean(Accu)
    TPR_track[1, row] = ave_tpr
    FPR_track[1, row] = ave_fpr
    TPR_TF[1, row] = 1 - ave_fpr
    FPR_TF[1, row] = 1 - ave_tpr

    # 24 samples
    TPR = []
    FPR = []
    Accu = []
    for i in range (0,25):
        tpr,fpr,accuracy = test(TF,TI,24,10**(-6),row)
        TPR.append(tpr)
        FPR.append(fpr)
        Accu.append(accuracy)
    ave_tpr = np.mean(TPR)
    ave_fpr = np.mean(FPR)
    std_tpr = np.std(TPR)
    std_fpr = np.std(FPR)
    max_tpr = np.max(TPR)
    max_fpr = np.max(FPR)
    Accuracy[2, row] = np.mean(Accu)
    TPR_track[2, row] = ave_tpr
    FPR_track[2, row] = ave_fpr
    TPR_TF[2, row] = 1 - ave_fpr
    FPR_TF[2, row] = 1 - ave_tpr

Accuracy_tf_0 = np.mean(Accuracy[0,:])
Accuracy_tf_1 = np.mean(Accuracy[1,:])
Accuracy_tf_2 = np.mean(Accuracy[2,:])
tpr_tf_0 = np.mean(TPR_TF[0,:])
fpr_tf_0 = np.mean(FPR_TF[0,:])
tpr_tf_1 = np.mean(TPR_TF[1,:])
fpr_tf_1 = np.mean(FPR_TF[1,:])
tpr_tf_2 = np.mean(TPR_TF[2,:])
fpr_tf_2 = np.mean(FPR_TF[2,:])
'''plot the TPR, FPR, and Accuracy figures'''
# TPR figure
plt.figure(1)
name_list = ['TF','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12','T13','T14','T15','T16','T17','T18','T19','T20','T21','T22','T23']
num_list1 = np.append(tpr_tf_0, TPR_track[0,:])
num_list2 = np.append(tpr_tf_1, TPR_track[1,:])
num_list3 = np.append(tpr_tf_2, TPR_track[2,:])
x =list(range(len(num_list1)))
total_width, n = 0.8, 3
width = total_width / n
plt.bar(x, num_list1, width=width, label='6 samples',fc = 'y')
for i in range(len(x)):
    x[i] = x[i] + width
plt.bar(x, num_list2, width=width, label='12 samples',tick_label = name_list,fc = 'r')
for i in range(len(x)):
    x[i] = x[i] + width
plt.bar(x, num_list3, width=width, label='24 samples',fc = 'b')
plt.ylabel('true positive rate (x 100%)')
plt.legend()
# FPR figure
plt.figure(2)
name_list = ['TF','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12','T13','T14','T15','T16','T17','T18','T19','T20','T21','T22','T23']
num_list1 = np.append(fpr_tf_0, FPR_track[0,:])
num_list2 = np.append(fpr_tf_1, FPR_track[1,:])
num_list3 = np.append(fpr_tf_2, FPR_track[2,:])
x =list(range(len(num_list1)))
total_width, n = 0.8, 3
width = total_width / n
plt.bar(x, num_list1, width=width, label='6 samples',fc = 'y')
for i in range(len(x)):
    x[i] = x[i] + width
plt.bar(x, num_list2, width=width, label='12 samples',tick_label = name_list,fc = 'r')
for i in range(len(x)):
    x[i] = x[i] + width
plt.bar(x, num_list3, width=width, label='24 samples',fc = 'b')
plt.ylabel('false positive rate (x 100%)')
plt.legend()
# Accuracy figure
plt.figure(3)
name_list = ['TF','T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12','T13','T14','T15','T16','T17','T18','T19','T20','T21','T22','T23']
num_list1 = np.append(Accuracy_tf_0, Accuracy[0,:])
num_list2 = np.append(Accuracy_tf_1, Accuracy[1,:])
num_list3 = np.append(Accuracy_tf_2, Accuracy[2,:])
x =list(range(len(num_list1)))
total_width, n = 0.8, 3
width = total_width / n
plt.bar(x, num_list1, width=width, label='6 samples',fc = 'y')
for i in range(len(x)):
    x[i] = x[i] + width
plt.bar(x, num_list2, width=width, label='12 samples',tick_label = name_list,fc = 'r')
for i in range(len(x)):
    x[i] = x[i] + width
plt.bar(x, num_list3, width=width, label='24 samples',fc = 'b')
plt.ylabel('Accuracy (x 100%)')
plt.legend()
plt.show()
