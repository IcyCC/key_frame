# coding=gbk
import json
import sys
import os
import re
import scipy.io as sio
import numpy as np
matfn='E:\\大创项目\\最终\\keyframe_extraction\\scripts\\ScriptOfCp\\frame.mat'
data=sio.loadmat(matfn)
data_a=data['frame']
row=data_a.shape[0]
result=[]

for i in range(0,row):
	address=str(data_a[i,0]).replace("'","").replace(r"\n","")
	keyframe=str(data_a[i,1]).replace("'","").replace(r"\n","")
	time=str(data_a[i,2]).replace("'","").replace(r"\n","")
	address=address.strip('['']')
	time=time.strip('['']')
	keyframe=keyframe.strip('['']')
	ex={
		"image":"",
		"address":address,
		"keyframe":keyframe,
		"time":time,
		"video":""
		}
	print(ex)
	result.append(ex)


f=open("E:\\大创项目\\最终\\keyframe_extraction\\scripts\\ScriptOfCp\\1.json","w")
f.write(json.dumps(result))
f.close
