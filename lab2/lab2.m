x = [1, 2, 3, 4, 5, 6, 7];
y = [8.16, 8.25, 8.41, 8.76, 9.2, 9.78, 10.1];

n = size(x, 2);
k = 1;

A = [sum(x.^4), sum(x.^3), sum(x.^2);
    sum(x.^3), sum(x.^2), sum(x);
    sum(x.^2), sum(x), n];

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
f2 = fit(transpose(x), transpose(y), "poly6");
plot(f2, "c");
legend("Исходные даные", "p = 3", "p = 4", "p = 5", "p = 6");

hold off;

f1 = coeff(1) * x1 ^ 2 + coeff(2) * x1 + coeff(3);
f2 = fit(transpose(x), transpose(y), "poly5");
f3 = (x1 * 81.1604 + 462.178) ^ (1/3);

fprintf("Radj f1 - %s\n", f1);
fprintf("Radj f2 - %s\n", f2);
fprintf("Radj f3 - %s\n", f3);

syms r

y1 = zeros(1, n);
y2 = zeros(1, n);
y3 = zeros(1, n);

for i = 1:n
    y1(1, i) = subs(f1, x1, i);
    y2(1, i) = f2(i);
    y3(1, i) = subs(f3, x1, i);
end

Radj = 1 - (1 - r) * (n - 1) / (n - k);

Radj1 = subs(Radj, r, R(x, y, y1));
Radj2 = subs(Radj, r, R(x, y, y2));
Radj3 = subs(Radj, r, R(x, y, y3));

fprintf("Radj f1 - %f\n", Radj1);
fprintf("Radj f2 - %f\n", Radj2);
fprintf("Radj f3 - %f\n", Radj3);

plot(x, y, "ok");
hold on;
fplot(f1, [x(1), x(n)]);
plot(f2);
fplot(f3, [x(1), x(n)]);
legend("off");
hold off;