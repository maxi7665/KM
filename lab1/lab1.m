% "веса" критериев
criteriasWeights = [
    0.4, 0.2, 0.3; 
    0.3, 0.3, 0.4; 
    0.2, 0.5, 0.3];

% МПС альтернатив по критериям
criteriaMps = containers.Map('KeyType','int32','ValueType','any');

criteriaMps(1) = [
    1,	1,	1/9, 1/3;
    1,	1,	1/9, 1/3;
    9,	9,	1,   7;
    3,	3,	1/7, 1
];

criteriaMps(2) = [
    1,	 9,	5,	 7;
    1/9, 1,	1/5, 1/3;
    1/5, 5,	1,	 3;
    1/7, 3,	1/3, 1
];

criteriaMps(3) = [
    1,	1,	1/7, 1/5;
    1,	1,	1/7, 1/5;
    7,	7,	1,	 3;
    5,	5,	1/3, 1
];

% расчет решений
compare(1, criteriaMps, criteriasWeights(1, :), 3);
compare(1, criteriaMps, criteriasWeights(2, :), 3);
compare(1, criteriaMps, criteriasWeights(3, :), 3);
compare(2, criteriaMps, criteriasWeights(1, :), 3);
compare(2, criteriaMps, criteriasWeights(2, :), 3);
compare(2, criteriaMps, criteriasWeights(3, :), 3);
compare(2, criteriaMps, criteriasWeights(1, :), 4);
compare(2, criteriaMps, criteriasWeights(2, :), 4);
compare(2, criteriaMps, criteriasWeights(3, :), 4);



function [result] = compare(alg, criteriaMps, criteriaWeights, alternativeNum)
% выполнить поиск наилучшей альтернативы
% alg - используемый алгоритм - 1 - МАИ, 2 - ММАИ
% criteriaMps - containers.Map (№ критерия -> МПС[№ альтернативы, № альтернативы])
% criteriaWeights - веса критериев
% alternateNum - кол-во альтернатив

criteriaNum = size(criteriaWeights, 2);

pairComparisonMatrix = zeros(criteriaNum, alternativeNum, alternativeNum);

% заполнение трехмерной матрицы МПС [критерий - альтернатива - альтернатива]
% -> оценка
for criteria = 1:criteriaNum

    mps = criteriaMps(criteria);

    mps = mps(1:alternativeNum, 1:alternativeNum);

    pairComparisonMatrix(criteria, :, :) = mps;
end

% запуск работы алгоритма
switch (alg)
    case 1
        [solution, score, scores] = ahp(criteriaWeights, pairComparisonMatrix);
    case 2
        [solution, score, scores] = ahpPlus(criteriaWeights, pairComparisonMatrix);
    otherwise
        error('wrong algorithm number');
end

algs = {'МАИ', 'ММАИ'};

% вывод результатов
disp('алгоритм');
disp(algs(alg));

disp('веса критериев');
disp(criteriaWeights);

disp('МПС критериев');

for criteria = 1:criteriaNum
    disp(criteria);
    disp(permute(pairComparisonMatrix(criteria, :, :), [2,3,1]));
end

disp('наилучшая альтернатива:'); 
disp(solution);
disp('результат:');
disp(score);
disp('оценки всех альтернатив:');
disp(scores);

result = solution;

end