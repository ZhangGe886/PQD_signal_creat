% filename:creat_csv.m
% author:gdx_2019.11.30
% function: input a mat,auto creat a csv file
function [] = creat_csv( data,filename,permission )
%data is inputed mat;
% filename's type is str 
% permission may be "a,r,w,w+  £¬£¬"

%creat a file of csv
fid=fopen(filename,permission);
if fid<0
	errordlg('File creation failed','Error');
end

%write data in file.csv
[row,column]=size(data); %get data's size
for j=1:row
    for k=1:column
        if k==column %a row's last one,then should \n
           fprintf(fid, ['%f','\n'],data(j,k)); 
        else
           fprintf(fid, ['%f',','],data(j,k)); 
        end
    end
end




