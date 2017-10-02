import matlab.engine

eng = matlab.engine.start_matlab()

eng.cd('keyframe_extraction/scripts/ScriptOfCp',nargout=0)
s = eng.genpath('./code')
s2 = eng.genpath('./libsvm-3.22/matlab')
s3 = eng.genpath('./libsvm-3.22')
print(eng.cd())
eng.addpath(s)
eng.addpath(s2)
eng.addpath(s3)


print("MATLAB INIT FINISH")
print("MATLAB PATH %s" % (eng.cd()))