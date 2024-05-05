function [solution, score, alternativeScores] = ahp(criteriaWeights, pairComparisonMatrix)

% analytic hierarchy process 
% criteriaWeights: array of the criterias' weights -> array[criteriaNum] =
% criteria weight
% pairComparisonMatrix: matrix[criteria, alternative, alternative] = rate
% returns - number of selected alternative, score, result score vector

    % get numbers of criterias and alternatives
    criteriaNum = size(criteriaWeights, 2);
    alternativeNum = size(pairComparisonMatrix, 2);

    % array[criteria] = array[alternativeNum] = counted weight (rows - w^i) 
    criteriaAlternativeWeightVectorArray = zeros(criteriaNum, alternativeNum);

    % normalize weights vector
    criteriaWeights = criteriaWeights / sum(criteriaWeights);

    bufPairComparisonMatrix = pairComparisonMatrix;

    % iterate on criterias    
    for criteria = 1:criteriaNum    

        % matrix normalization
        for alternative = 1:alternativeNum                         
            
            s = sum(pairComparisonMatrix(criteria, 1:alternativeNum, alternative));            

            normalizedColumn = pairComparisonMatrix(criteria, 1:alternativeNum, alternative) / s;   
            
            pairComparisonMatrix(criteria, 1:alternativeNum, alternative) = normalizedColumn;
                             
        end

        %find score by criteria for alternatives
        for alternative = 1:alternativeNum

            alternativeVector = pairComparisonMatrix(criteria, alternative, :);

            score = mean(alternativeVector);            

            criteriaAlternativeWeightVectorArray(criteria, alternative) = score;
        end  

        mps = permute(bufPairComparisonMatrix(criteria, :, :), [2, 3, 1]);
        vka = criteriaAlternativeWeightVectorArray(criteria, 1:alternativeNum);

        fprintf('Проверка МПС критерия %d на согласованность:\n\n', criteria);

        % check mps consistency
        printMpsConsistencyCheck(mps, vka);

        criteriaWeight = criteriaWeights(criteria);

        criteriaAlternativeWeightVectorArray(criteria, 1:alternativeNum) = ...
        criteriaAlternativeWeightVectorArray(criteria, 1:alternativeNum) * criteriaWeight; 

        % weightedCriteria = score * criteriaWeight;
      
    end

    alternativeScores = zeros(1, alternativeNum);    

    for alternative = 1:alternativeNum

        alternativeScores(alternative) = sum(criteriaAlternativeWeightVectorArray( ...
            1:criteriaNum, ...
            alternative));

    end

    %disp(alternativeScores);
    
    [score, solution] = max(alternativeScores);
end