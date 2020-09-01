project_KNN.py uses KNN algorithm to detect a hardware trojan.
The input of project_KNN.py is ROFreq which from 'Chip 1.xlsx' to 'Chip 33.xlsx'
The output of project_KNN.py is two figures and three tables.
Figure 1 is 'Average Training Time and Evaluation Time', 
Figure 2 is 'Accuracy Rate(%) comparison for training size = 6, 12, 24'
table 1('6.csv') is 4*24 which include Avg, SD, Max, Min Accuracy of TF, T1-T23 for train size =6
table 2('12.csv') is 4*24 which include Avg, SD, Max, Min Accuracy of TF, T1-T23 for train size =12
table 3('24.csv') is 4*24 which include Avg, SD, Max, Min Accuracy of TF, T1-T23 for train size =24


project_KNN.py uses probability generative model to detect a hardware trojan.
The code file should be put  in the 'ROFreq' directory which contains the files from 'Chip 1.xlsx' to 'Chip 33.xlsx'.
The code can read the frequency data from these .xlsx files and generate three figures.
Figure 1 is 'True positive rate(x100%) comparison for different Trojan inserted model and different train size.
Figure 2 is 'False positive rate(x100%) comparison for different Trojan inserted model and different train size.
Figure 3 is 'Accuracy (x100%) comparison for different Trojan inserted model and different train size.