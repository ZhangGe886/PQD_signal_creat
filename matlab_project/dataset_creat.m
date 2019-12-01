% filename:dataset_creat.m
% author:gdx_2019.11.30
% function: creat a dataset,row of dataset is 8*Iteration_times
clc;
clear all;
Iteration_times=500; %set the times

%creat dataset's mat
for i=1:Iteration_times; 
    if i==1
        data=signal_creat(3915);
    else
        data=[data;signal_creat(3915)]; %Êı×éÆ´½Ó
    end
end
size(data)

%creat data.csv
creat_csv(data,'train_dataset.csv','w+');
