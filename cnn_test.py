# -*- coding: utf-8 -*-
"""
Created on Sun Dec  1 22:03:06 2019

@author: pc
"""

#import keras as keras
from keras.models import load_model
from pandas import read_csv

#read test_data
test_data = read_csv('test_dataset02.csv',header=None)
test_data = test_data.values
x_test=test_data[:,0:784] #数据集前784列为样本属性
y_test=test_data[:,784]  #数据集第785列为样本标签
x_test = x_test.reshape(-1,28,28,1)#转化为标准输入格式
data_sum = y_test.shape[0] #数据集的样本数量

#load model
model = load_model("cnn_model_file.h5")
test_value = model.predict_classes(x_test)

#测试模型准确性，计算测试集正确率
acc_num = 0 #变量acc_num用来记录分类正确的数量
for i in range(data_sum):
    if (y_test[i]==test_value[i]) :
        acc_num = acc_num + 1
acc_test = (100.0*acc_num)/data_sum  #正确率计算

#print('Test_value_1:',test_value1)
print('acc_test: %%%2.3f'%(acc_test))