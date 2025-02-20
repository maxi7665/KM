criteriaWeights = [0.5, 0.5];

alternativeCriteriaRates = [1,4; 2,1];
% alternativeCriteriaRates = [1,4; 2,1; 1/3, 8];
% alternativeCriteriaRates = [7, 15; 10, 10; 5, 20];

% [solution, score, scores] = ahp(criteriaWeights, buildPairComparisonMatrix(alternativeCriteriaRates));
[solution, score, scores] = ahpPlus(criteriaWeights, buildPairComparisonMatrix(alternativeCriteriaRates));

disp('solution:'); 
disp(solution);
disp('score:');
disp(score);
disp('rates:');
disp(scores);
