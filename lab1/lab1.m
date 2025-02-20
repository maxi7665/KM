% "веса" критериев
criteriasWeights = [
    0.4, 0.2, 0.3; 
    0.3, 0.3, 0.4; 
    0.2, 0.5, 0.3];

% оценки по 3-м критериям каждой альтернативы
alternativeCriteriaRates = [
    3,9,1; 
    3,1,1;
    9,5,7;
    5,3,7];

% МПС альтернатив по критериям
criteriaMps = containers.Map('KeyType','int32','ValueType','any');

mpsMatrix = buildPairComparisonMatrix(alternativeCriteriaRates);

for criteria = 1:size(mpsMatrix, 1)
    criteriaMps(criteria) = permute(mpsMatrix(criteria, :, :), [2,3,1]);
end

% расчет решений
disp('Решение 1.'); compare(1, criteriaMps, criteriasWeights(1, :), 3);
disp('Решение 2.'); compare(1, criteriaMps, criteriasWeights(2, :), 3);
disp('Решение 3.'); compare(1, criteriaMps, criteriasWeights(3, :), 3);
disp('Решение 4.'); compare(2, criteriaMps, criteriasWeights(1, :), 3);
disp('Решение 5.'); compare(2, criteriaMps, criteriasWeights(2, :), 3);
disp('Решение 6.'); compare(2, criteriaMps, criteriasWeights(3, :), 3);
disp('Решение 7.'); compare(2, criteriaMps, criteriasWeights(1, :), 4);
disp('Решение 8.'); compare(2, criteriaMps, criteriasWeights(2, :), 4);
disp('Решение 9.'); compare(2, criteriaMps, criteriasWeights(3, :), 4);

function [result] = compare(alg, criteriaAlternateMps, criteriaScores, alternativeNum)
% выполнить поиск наилучшей альтернативы
% alg - используемый алгоритм - 1 - МАИ, 2 - ММАИ
% criteriaMps - containers.Map (№ критерия -> МПС[№ альтернативы, № альтернативы])
% criteriaWeights - веса критериев
% alternateNum - кол-во альтернатив

criteriaNum = size(criteriaScores, 2);

innerCriteriaMps = buildPairComparisonMatrix(transpose(criteriaScores));

criteriaMps = zeros(criteriaNum, criteriaNum);

for i = 1:criteriaNum
    for j = 1:criteriaNum
        criteriaMps(i, j) = innerCriteriaMps(1, i , j);
    end
end

criteriaWeights = zeros(1, criteriaNum);

bufCriteriaMps = criteriaMps;

for i = 1:criteriaNum

    columnSum = sum(bufCriteriaMps(:, i));

    for j = 1:criteriaNum
        val = bufCriteriaMps(j, i);

        val = val / columnSum;

        criteriaWeights(1, j) = criteriaWeights(1, j) + val;
    end
end

criteriaWeights = criteriaWeights ./ criteriaNum;

pairComparisonMatrix = zeros(criteriaNum, alternativeNum, alternativeNum);

% заполнение трехмерной матрицы МПС [критерий - альтернатива - альтернатива]
% -> оценка
for criteria = 1:criteriaNum

    mps = criteriaAlternateMps(criteria);

    mps = mps(1:alternativeNum, 1:alternativeNum);

    pairComparisonMatrix(criteria, :, :) = mps;
end

algs = {'МАИ', 'ММАИ'};

% вывод результатов
disp('алгоритм');
disp(algs(alg));

disp('веса критериев');
disp(criteriaScores);

disp('МПС критериев:');
disp(criteriaMps);

disp('Весовой коэффициент критериев:');
disp(criteriaWeights);

disp('Проверка МПС критериев на согласованность');
printMpsConsistencyCheck(criteriaMps, criteriaWeights);

% for criteria = 1:criteriaNum
%     disp(criteria);
%     disp(permute(pairComparisonMatrix(criteria, :, :), [2,3,1]));
% end


% запуск работы алгоритма
switch (alg)
    case 1
        [solution, score, scores] = ahp(criteriaWeights, pairComparisonMatrix);
    case 2
        [solution, score, scores] = ahpPlus(criteriaWeights, pairComparisonMatrix);
    otherwise
        error('wrong algorithm number');
end


disp('наилучшая альтернатива:'); 
disp(solution);
disp('результат:');
disp(score);
disp('оценки всех альтернатив:');
disp(scores);

result = solution;

end