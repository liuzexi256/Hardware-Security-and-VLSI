""" =======================  Import dependencies ========================== """
import numpy as np 
from matplotlib import pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn import neighbors
import pandas as pd
import random
import csv
from time import time

""" =======================  Function definitions  ========================== """
def SplitData(data, num):
    number = np.arange(33)
    train_num = random.sample(number.tolist(), num)
    data_true_train = np.zeros((num*2, 8))
    data_false_train = np.zeros((num*23, 8))
    data_true_test = np.zeros(((33 - num)*2, 8))
    data_false_test = np.zeros(((33 - num)*23, 8))
    n1 = 0
    m1 = 0
    n2 = 0
    m2 = 0
    for i in range(33):
        if i in train_num:
            data_true_train[n1:n1 + 2, :] = data[i*2:i*2 + 2, :]
            data_false_train[m1:m1 + 23, :] = data[66 + i*23:66 + i*23 + 23, :]
            n1 = n1 + 2
            m1 = m1 + 23
        else:
            data_true_test[n2:n2 + 2, :] = data[i*2:i*2 + 2, :]
            data_false_test[m2:m2 + 23, :] = data[66 + i*23:66 + i*23 + 23, :]
            n2 = n2 + 2
            m2 = m2 + 23

    data_train = np.vstack((data_true_train, data_false_train))
    data_test = np.vstack((data_true_test, data_false_test))
    target_train = np.hstack((np.zeros(num*2), np.ones(num*23)))
    target_test = np.hstack((np.zeros(66 - num*2), np.ones(759 - num*23)))
    return data_train, target_train, data_test, target_test

def ACC(pre, target_test):
    tp_KNN = 0
    fp_KNN = 0
    fn_KNN = 0
    tn_KNN = 0
    for i in range(len(target_test)):
        if pre[i] == 1:
            if pre[i] == target_test[i]:
                tp_KNN = tp_KNN + 1
            else:
                fp_KNN = fp_KNN + 1
        else:
            if pre[i] == target_test[i]:
                tn_KNN = tn_KNN + 1
            else:
                fn_KNN = fn_KNN + 1
    acc = (tp_KNN + tn_KNN)/(len(target_test))
    return acc

def calmeanacc(trainnum):
    trainnum = trainnum
    testnum = 33 -trainnum
    n_neighbors = 4
    acc = np.zeros((20, 24))
    meanacc = np.zeros(24)
    for i in range(20):
        data_train, target_train, data_test, target_test = SplitData(data, trainnum)
        classifiers = neighbors.KNeighborsClassifier(n_neighbors, weights='distance')
        clffinal = classifiers.fit(data_train, target_train)
        pre = clffinal.predict(data_test)
        for j in range(testnum*2):
            if pre[j] == target_test[j]:
                acc[i,0] = acc[i,0] + 1
        for n in range(testnum):
            for m in range(23):
                if pre[testnum*2 + m + n*23] == target_test[testnum*2 + m + n*23]:
                    acc[i, m + 1] = acc[i, m + 1] + 1

    acc[:,0] = acc[:,0]/(testnum*2)
    acc[:,1::] = acc[:,1::]/testnum
    for i in range(24):
        meanacc[i] = acc[:, i].mean()
    return meanacc

def calruntime(trainnum):
    n_neighbors = 4
    tp_KNN = 0
    fp_KNN = 0
    fn_KNN = 0
    tn_KNN = 0
    time_train = np.zeros(20)
    time_test = np.zeros(20)
    for i in range(20):
        data_train, target_train, data_test, target_test = SplitData(data, trainnum)

        train_start = time()
        classifiers = neighbors.KNeighborsClassifier(n_neighbors, weights='distance')
        clffinal = classifiers.fit(data_train, target_train)
        train_end = time()
        time_train[i] = train_end - train_start

        test_start = time()
        pre = clffinal.predict(data_test)
        test_end = time()
        time_test[i] = test_end - test_start

    mean_train_time = time_train.mean()
    mean_test_time = time_test.mean()
    return mean_train_time, mean_test_time

def calall(trainnum):
    trainnum = trainnum
    testnum = 33 -trainnum
    n_neighbors = 4
    acc = np.zeros((20, 24))
    allacc = np.zeros((4,24))
    for i in range(20):
        data_train, target_train, data_test, target_test = SplitData(data, trainnum)
        classifiers = neighbors.KNeighborsClassifier(n_neighbors, weights='distance')
        clffinal = classifiers.fit(data_train, target_train)
        pre = clffinal.predict(data_test)
        for j in range(testnum*2):
            if pre[j] == target_test[j]:
                acc[i,0] = acc[i,0] + 1
        for n in range(testnum):
            for m in range(23):
                if pre[testnum*2 + m + n*23] == target_test[testnum*2 + m + n*23]:
                    acc[i, m + 1] = acc[i, m + 1] + 1

    acc[:,0] = acc[:,0]/(testnum*2)
    acc[:,1::] = acc[:,1::]/testnum
    for i in range(24):
        allacc[0, i] = acc[:, i].mean()*100
        allacc[1, i] = acc[:, i].std()*100
        allacc[2, i] = acc[:, i].max()*100
        allacc[3, i] = acc[:, i].min()*100
    return allacc

""" =======================  Load Training Data ======================= """
data = np.zeros((33, 25, 8))
data_true = []
data_false = []
for i in range (33):
    filename = 'ROFreq\\Chip' + str(i + 1) + '.xlsx'
    datatemp = pd.read_excel(filename, header = None)
    datatemp = np.array(datatemp)
    data[i,:,:] = datatemp
    data_true.append(datatemp[0,:])
    data_true.append(datatemp[24,:])
    for j in range(23):
        data_false.append(datatemp[j + 1,:])

data = np.vstack((np.array(data_true),np.array(data_false)))
target = np.hstack((np.zeros(66), np.ones(759)))

""" =======================  Train and Test KNN Model and Calculate TP/FP/TN/FN  ======================= """
trainnum = 6
n_neighbors = 4
tp_KNN = 0
fp_KNN = 0
fn_KNN = 0
tn_KNN = 0
time_train = np.zeros(20)
time_test = np.zeros(20)
for i in range(20):
    data_train, target_train, data_test, target_test = SplitData(data, trainnum)
    classifiers = neighbors.KNeighborsClassifier(n_neighbors, weights='distance')
    clffinal = classifiers.fit(data_train, target_train)
    pre = clffinal.predict(data_test)
    for i in range(len(target_test)):
        if pre[i] == 1:
            if pre[i] == target_test[i]:
                tp_KNN = tp_KNN + 1
            else:
                fp_KNN = fp_KNN + 1
        else:
            if pre[i] == target_test[i]:
                tn_KNN = tn_KNN + 1
            else:
                fn_KNN = fn_KNN + 1

""" =======================  Calculate Run Time and Plot ======================= """
train_time = np.zeros(3)
test_time = np.zeros(3)

train_time[0], test_time[0] = calruntime(6)
train_time[1], test_time[1] = calruntime(12)
train_time[2], test_time[2] = calruntime(24)

plt.figure(1)
x_run = ['6', '12', '24']
plt.bar(np.arange(3) - 0.1, train_time, width = 0.2, tick_label = x_run, label = 'Training Time')
plt.bar(np.arange(3) + 0.1, test_time, width = 0.2, tick_label = x_run, label = 'Evaluation Time')
plt.xlabel('Training Size')
plt.ylabel('Run Time(s)')
plt.title('Average Training Time and Evaluation Time')
plt.legend()

""" ==========================  Figure Accuracy  ============================ """
all6 = calall(6)
all12 = calall(12)
all24 = calall(24)
np.savetxt("6.csv", all6, delimiter=",")
np.savetxt("12.csv", all12, delimiter=",")
np.savetxt("24.csv", all24, delimiter=",")

""" ==========================  Plot Accuracy  ============================ """
accforplot = np.zeros((3, 24))

accforplot[0,:] = calmeanacc(6) * 100
accforplot[1,:] = calmeanacc(12) * 100
accforplot[2,:] = calmeanacc(24) * 100
name_list = ['TF', 'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12', 'T13', 'T14', 'T15', 'T16', 'T17', 'T18', 'T19', 'T20', 'T21', 'T22', 'T23']

plt.figure(2)
plt.bar(np.arange(24), accforplot[0,:], width = 0.2, tick_label = name_list, label = '6')
plt.bar(np.arange(24) + 0.2, accforplot[1,:], width = 0.2, tick_label = name_list, label = '12')
plt.bar(np.arange(24) + 0.4, accforplot[2,:], width = 0.2, tick_label = name_list, label = '24')
plt.xlabel('Trojan')
plt.ylabel('Accuracy Rate(%)')
plt.title('Accuracy Rate(%) comparison for training size = 6, 12, 24')
plt.legend()
plt.show()



