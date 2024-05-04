function [pairComparisonMatrix] = buildPairComparisonMatrix(alternativeCriteriaRates)

%create pair-comparison matrix from alternative-criteria matrix rates

    criteriaNum = size(alternativeCriteriaRates, 2);
    alternativeNum = size(alternativeCriteriaRates, 1);

    pairComparisonMatrix = zeros(alternativeNum, alternativeNum, criteriaNum);

    % fill the pair comparison matrix
    for criteria = 1:criteriaNum
        for alternative1 = 1:alternativeNum
            for alternative2 = 1:alternativeNum
                
                % get alternatives' rates on current criteria
                rate1 = alternativeCriteriaRates(alternative1, criteria);         
                rate2 = alternativeCriteriaRates(alternative2, criteria);
        
                rate = rate1 / rate2;
        
                pairComparisonMatrix(criteria, alternative1, alternative2) = rate;
        
            end
        end
    end
end