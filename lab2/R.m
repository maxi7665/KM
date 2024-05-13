function [result] = R(X, Y, approximatedY)
% Посчитать коэффициент детерминации модели
% X - координаты исходных точек по X
% Y - координаты исходных точек по Y, сответствующие вектору X
% approximatedY - аппроксимированные значения Y, соответствующие вектору X

% кол-во точек
n = size(X, 2);

% функция одной переменной, k = 1
k = 1;

dispersion = sum((approximatedY - Y) .^ 2) / (n - k - 1);

result = 1 - (dispersion) / (std(Y) ^ 2);

end