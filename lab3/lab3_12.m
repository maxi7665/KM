% Определение функции, задающей дифференциальное уравнение
diff_eq = @(x, y) x * exp(-x^2) - 2*x*y;

% Решение дифференциального уравнения для заданного диапазона x
x = linspace(0, 2, 500);
y0 = 2; % Начальное условие y(0) = 2
[t, y] = ode45(diff_eq, x, y0);

out = sim("lab3_1.slx");

% получение значения производной для каждого значения функции и аргумента
% для построения фазового портрета
diffValues = zeros(size(y, 1), 1);

for i = 1:size(y,1)
    diffValues(i) = diff_eq(x(i), y(i));
end

% Построение фазового портрета
figure
subplot(1, 2, 1);
hold on;
plot(diffValues, y);
plot(out.dy, out.y);
hold off;
xlabel('dy/dx');
ylabel('y');
title('Фазовый портрет');

% Построение графика решения
subplot(1, 2, 2);
hold on;
plot(t, y);
plot(out.x, out.y);
hold off;
xlabel('x');
ylabel('y');
title('График');