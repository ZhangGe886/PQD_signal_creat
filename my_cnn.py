# -*- coding: utf-8 -*-
"""
Created on Sat Nov 30 16:39:01 2019

@author: pc
"""

import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers import Conv2D, MaxPooling2D
from keras import backend as K
from pandas import read_csv 
import matplotlib.pyplot as plt

#写一个LossHistory类，保存loss和acc
class LossHistory(keras.callbacks.Callback):
    def on_train_begin(self, logs={}):
        self.losses = {'batch':[], 'epoch':[]}
        self.accuracy = {'batch':[], 'epoch':[]}
        self.val_loss = {'batch':[], 'epoch':[]}
        self.val_acc = {'batch':[], 'epoch':[]}

    def on_batch_end(self, batch, logs={}):
        self.losses['batch'].append(logs.get('loss'))
        self.accuracy['batch'].append(logs.get('acc'))
        self.val_loss['batch'].append(logs.get('val_loss'))
        self.val_acc['batch'].append(logs.get('val_acc'))

    def on_epoch_end(self, batch, logs={}):
        self.losses['epoch'].append(logs.get('loss'))
        self.accuracy['epoch'].append(logs.get('acc'))
        self.val_loss['epoch'].append(logs.get('val_loss'))
        self.val_acc['epoch'].append(logs.get('val_acc'))

    def loss_plot(self, loss_type):
        iters = range(len(self.losses[loss_type]))
        plt.figure()
        # acc
        plt.plot(iters, self.accuracy[loss_type], 'r', label='train acc')
        # loss
        plt.plot(iters, self.losses[loss_type], 'g', label='train loss')
        if loss_type == 'epoch':
            # val_acc
            plt.plot(iters, self.val_acc[loss_type], 'b', label='val acc')
            # val_loss
            plt.plot(iters, self.val_loss[loss_type], 'k', label='val loss')
        plt.grid(True)
        plt.xlabel(loss_type)
        plt.ylabel('acc-loss')
        plt.legend(loc="upper right")
        plt.show()
#创建一个实例history
history = LossHistory()


'''=========数据集导入============='''
#read train_data
train_data = read_csv('train_dataset.csv',header=None) #默认首行为表头，不读取，需要令header=none
train_data = train_data.values
x_train=train_data[:,0:784] #数据集前784列为样本属性
y_train=train_data[:,784]  #数据集第785列为样本标签
#4000个训练集，1000个验证集，8：2
#read val_data
val_data = read_csv('val_dataset.csv',header=None)
val_data = val_data.values
x_val=val_data[:,0:784] #数据集前784列为样本属性
y_val=val_data[:,784]  #数据集第785列为样本标签

'''=========CNN模型构建============='''
batch_size = 256 #批尺寸，即一次训练所选取的样本数，batch_size=1时为在线学习
num_classes = 8 #标签类别总数为8种
epochs = 15  #训练轮数

# input image dimensions  输入图像维度
img_rows, img_cols = 28, 28
input_shape = (img_rows, img_cols, 1)

#改变输入维度为28*28
x_train = x_train.reshape(-1,28,28,1)
x_val = x_val.reshape(-1,28,28,1)

#将整型的类别标签转为onehot编码，num_classes为标签类别总数，none is 数组维数
y_train = keras.utils.to_categorical(y_train, num_classes)
y_val = keras.utils.to_categorical(y_val, num_classes)
#y_test = keras.utils.to_categorical(y_test, num_classes)

model = Sequential()
model.add(Conv2D(16, kernel_size=(5, 5),
                 activation='relu',
                 input_shape=input_shape))
model.add(MaxPooling2D(pool_size=(2, 2))) #pooling为池化，每2*2个像素点变为1个点
model.add(Conv2D(36, (5, 5), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25)) #对25％的节点执行Droupout以减少过拟合，正则化
model.add(Flatten())
model.add(Dense(128, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes, activation='softmax'))
model.summary()

model.compile(loss=keras.losses.categorical_crossentropy,
              optimizer=keras.optimizers.Adadelta(),
              metrics=['accuracy'])

model.fit(x_train, y_train,
          batch_size=batch_size,
          epochs=epochs,
          verbose=1,
          validation_data=(x_val, y_val),#验证集
          callbacks=[history])#回调函数，记录损失和正确率

score = model.evaluate(x_val, y_val, verbose=0)

print('Test loss:', score[0]) #训练集损失函数
print('Test accuracy:', score[1]) #训练集准确率

#绘制acc-loss曲线
history.loss_plot('epoch')

#保存模型
model_save_path = "cnn_model_file.h5"
model.save(model_save_path)
# 删除当前已存在的模型
#del model

