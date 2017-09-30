#!usr/bin/python 
#coding=utf-8 

import matlab.engine
from celery import Celery

from . import celery_config
from redis_middle.redis_middle_class import Conn_db

redis_db = Conn_db()

app = Celery()
app.config_from_object(celery_config)

eng = matlab.engine.start_matlab()
s = eng.genpath('./code')
s2 = eng.genpath('./libsvm-3.22')
print(s)
print(s2)
eng.addpath(s)
eng.addpath(s2)

print("MATLAB INIT FINISH")
print("MATLAB PATH %s" % (eng.cd()))

@app.task(queue='words',name = 'wrods')
def words(words):
    result = eng.get_info(words)
    return result

@app.task(queue='test', name='test')
def add(a,b):
    return a+b
