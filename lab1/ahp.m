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

    % iterate on criterias    
    for criteria = 1:criteriaNum    

        % matrix normalization
        for alternative = 1:alternativeNum
                          
            s = 0;
            for row = 1:alternativeNum
                s = s + pairComparisonMatrix(criteria, row, alternative);
            end

            for row = 1:alternativeNum
                pairComparisonMatrix(criteria, row, alternative) = pairComparisonMatrix(criteria, row, alternative) / s;
            end
        end

        criteriaWeight = criteriaWeights(criteria);

        %find score by criteria for alternatives
        for alternative = 1:alternativeNum

            alternativeVector = pairComparisonMatrix(criteria, alternative, :);

            score = mean(alternativeVector);
            weightedCriteria = score * criteriaWeight;

            criteriaAlternativeWeightVectorArray(criteria, alternative) = weightedCriteria;

        end        
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