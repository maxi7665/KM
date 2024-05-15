% Определение системы дифференциальных уравнений
dxdt = @(t, x) 4*x(1) - x(2);
dydt = @(t, x) x(1) + 2*x(2);

% Начальные условия
x0 = -1;
y0 = 0;
tspan = [0 1]; % Диапазон времени для решения

out = sim("lab3_2.slx");

% Решение системы дифференциальных уравнений
[t, sol] = ode45(@(t, x) [dxdt(t, x); dydt(t, x)], tspan, [x0; y0]);

% Нахождение значений производной для построения фазового портрета
dx = zeros(size(t, 1), 1);
dy = zeros(size(t, 1), 1);

for i = 1 : size(t, 1)
    dx(i) = dxdt(t(i), sol(i, :));
    dy(i) = dydt(t(i), sol(i, :));
end

% Построение фазового портрета координата - производная
figure
subplot(2, 2, 1);
hold on;
plot(sol(:, 1), dx, "b");
plot(sol(:, 2), dy, "r");
plot(out.x, out.dx, "y");
plot(out.y, out.dy, "m");
hold off;
legend('x:dx', 'y:dy', 'simulated x:dx', 'simulated y:dy');
xlabel('x/y');
ylabel('dx/dy');
title('Фазовый портрет 1');

% Построение графиков x(t) и y(t)
subplot(2, 2, 2);
hold on;
plot(t, sol(:, 1), 'b', t, sol(:, 2), 'r');
plot(out.t, out.x, 'y', out.t, out.y, 'm');
hold off;
legend('x(t)', 'y(t)', 'simulated x(t)', 'simulated y(t)');
xlabel('t');
ylabel('Значения');
title('Решение');

% Построение фазового портрета в плоскости x-y
subplot(2, 2, 3);
hold on;
plot(sol(:, 1), sol(:, 2), "b", "LineWidth", 3);
plot(out.x, out.y, "r", "LineWidth", 2);
% plot(dx, dy, "LineWidth", 3);
% plot(out.dx, out.dy, "LineWidth", 2);

hold off;
legend('x:y', 'simulated x:y');
% 'dx:dy', 'simulated dx:dy');
xlabel('x');
ylabel('y');
title('Фазовый портрет 2');
