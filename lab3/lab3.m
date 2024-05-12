
[t,x] = ode45(@var11,[0 10],[2]);
% figure

plot(t,x(:,1),'-k',t,x(:,2),'--k','LineWidth',1.5)
grid on, hold on,
% plot(out.x,'-r');
% plot(out.dx,'--r');


function dxdt = var11(t,x) % Функция примера 5.4
    dxdt = [x(2); - 0.4*x(2) - 1.2*x(1)];
end