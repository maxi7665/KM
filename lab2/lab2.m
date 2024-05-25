% все точки
sourceX = [1, 2, 3, 4, 5, 6, 7];
sourceY = [8.16, 8.25, 8.41, 8.76, 9.2, 9.78, 10.1];

% точки для составления моделей
x = sourceX(1, 1:6);
y = sourceY(1, 1:6);

% точка для проверки прогноза
prognosisX = sourceX(1, 7);
prognosisY = sourceY(1, 7);

% x = [1, 2, 3, 4, 5, 6, 7];
% y = [8.16, 8.25, 8.41, 8.76, 9.2, 9.78, 10.1];

n = size(sourceX, 2);

approxPointsNum = size(x, 2);

A = [sum(x.^4), sum(x.^3), sum(x.^2);
    sum(x.^3), sum(x.^2), sum(x);
    sum(x.^2), sum(x), approxPointsNum];

b = [sum((x.^2) .* y);
    sum(x .* y);
    sum(y)];

coeff = A\b;

syms x1

hold on;

scatter(x, y , "k");

f2 = fit(transpose(x), transpose(y), "poly3");
plot(f2, "r");
f2 = fit(transpose(x), transpose(y), "poly4");
plot(f2, "g");
f2 = fit(transpose(x), transpose(y), "poly5");
plot(f2, "b");
% f2 = fit(transpose(x), transpose(y), "poly6");
% plot(f2, "c");
legend("Исходные даные", "p = 3", "p = 4", "p = 5");

hold off;

f1 = coeff(1) * x1 ^ 2 + coeff(2) * x1 + coeff(3);
f2 = fit(transpose(x), transpose(y), "poly5");
f3 = (x1 * 78.4206 + 464.918) ^ (1/3);

fprintf("f1 = %s\n", f1);
fprintf("f2 = %s\n", f2);
fprintf("f3 = %s\n", f3);

syms r k

y1 = zeros(1, approxPointsNum);
y2 = zeros(1, approxPointsNum);
y3 = zeros(1, approxPointsNum);

for i = 1:approxPointsNum
    y1(1, i) = subs(f1, x1, i);
    y2(1, i) = f2(i);
    y3(1, i) = subs(f3, x1, i);
end

Radj = 1 - (1 - r) * (approxPointsNum - 1) / (approxPointsNum - k);

% расчет скорректированного коэффициента детерминации модели
Radj1 = subs(subs(Radj, r, R(x, y, y1, 3)), k , 3);
Radj2 = subs(subs(Radj, r, R(x, y, y2, 6)), k , 6);
Radj3 = subs(subs(Radj, r, R(x, y, y3, 2)), k , 2);

fprintf("Radj f1 - %f\n", Radj1);
fprintf("Radj f2 - %f\n", Radj2);
fprintf("Radj f3 - %f\n", Radj3);

% расчет отклонений прогноза
prognosisFail1 = abs(prognosisY - subs(f1, x1, prognosisX));
prognosisFail2 = abs(prognosisY - f2(prognosisX));
prognosisFail3 = abs(prognosisY - subs(f3, x1, prognosisX));

fprintf("Ошибка прогноза f1 - %f\n", prognosisFail1);
fprintf("Ошибка прогноза f2 - %f\n", prognosisFail2);
fprintf("Ошибка прогноза f3 - %f\n", prognosisFail3);

plot(sourceX, sourceY, "ok");
hold on;
fplot(f1, [sourceX(1), sourceX(n)]);
plot(f2);
fplot(f3, [sourceX(1), sourceX(n)]);
legend("off");
legend("source", "f1", "f2", "f3");
hold off;