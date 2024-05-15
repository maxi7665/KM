% x(t+1) = x(t) + d(4x(t) - y(t))
% y(t+1) = y(t) + d(x(t) + 2y(t))

nextX = @(xt, yt, delta) xt + delta .* (4 .* xt - yt);
nextY = @(xt, yt, delta) yt + delta .* (xt + 2 .* yt);

run("lab3_34.m");

% Начальные условия
x0 = -1;
y0 = 0;

% набор различных параметров дискретизации
deltas = [0.01, 0.05, 0.1, 0.5];
% deltas = [0.1];

deltaNum = size(deltas, 2);

% интервал расчета
fromT = 0;
toT = 1;

timeSpan = [fromT toT];

oldT = t;

for i = 1:deltaNum

    delta = deltas(i);

    steps = int32((toT - fromT) ./ delta) + 1;

    % запуск симуляции для заданного параметра дискретизации
    out = sim("lab3_3.slx");

    simulatedT = out.t(1 : steps);
    simulatedX = out.x(1:size(simulatedT, 1));
    simulatedY = out.y(1:size(simulatedT, 1));
    
    
    [t, x, y] = eiler(nextX, nextY, x0, y0, fromT, toT, delta); 

    subplot(1,2,1);
    hold on;
    plot(t, x, "DisplayName", sprintf("x: delta %f", delta), "LineWidth", 3);
    plot(simulatedT, simulatedX, "DisplayName", sprintf("simulated x: delta %f", delta));
    hold off;
    subplot(1,2,2);
    hold on;
    plot(t, y, "DisplayName", sprintf("y: delta %f", delta), "LineWidth", 3);
    plot(simulatedT, simulatedY, "DisplayName", sprintf("simulated y: delta %f", delta));
    hold off;

end

% hold off;
subplot(1,2,1);
hold on;
plot(oldT, sol(:, 1), "DisplayName", "x");
hold off;
legend;
subplot(1,2,2);
hold on;
plot(oldT, sol(:, 2), "DisplayName", "y");
hold off;
legend;

% решение системы двух дифференциальных уравнений методом дискретизации
% эйлера
function [t, x, y] = eiler(nextX, nextY, startX, startY, fromT, toT, delta)

    % кол-во шагов алгоритма для заданного параметра дискретизации
    steps = int32((toT - fromT) ./ delta) + 1;

    t = zeros(steps, 1);
    x = zeros(steps, 1);
    y = zeros(steps, 1);

    prevX = startX;
    prevY = startY;    

    % первые элементы - начальные значения
    x(1) = startX;
    y(1) = startY;
    t(1) = fromT;

    for i = 2:steps

        x(i) = nextX(prevX, prevY, delta);
        y(i) = nextY(prevX, prevY, delta);

        localT = delta * double(i - 1);
        t(i) = localT;

        prevX = x(i);
        prevY = y(i);
    end
end



