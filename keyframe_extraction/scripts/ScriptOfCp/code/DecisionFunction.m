function [y,w] = DecisionFunction(x,model)



len = length(model.Alpha);
w = 0;

for i = 1:len

w = w + model.Alpha(i);  %决策函数部分
end
b = -model.Bias;
y = w + b;
