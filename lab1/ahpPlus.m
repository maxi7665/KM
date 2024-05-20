function [solution, score, alternativeScores] = ahpPlus(criteriaWeights, pairComparisonMatrix)

% analytic hierarchy process - modified
% criteriaWeights: array of the criterias' weights -> array[criteriaNum] =
% criteria weight
% pairComparisonMatrix: matrix[criteria, alternative, alternative] = rate
% returns - number of selected alternative, score, result score vector

    % get numbers of criterias and alternatives
    criteriaNum = size(criteriaWeights, 2);
    alternativeNum = size(pairComparisonMatrix, 2);

    % array[criteria] = array[alternativeNum] = counted weight (rows - w^i) 
    criteriaAlternativeScoreMatrix = zeros(criteriaNum, alternativeNum);

    % normalize weights vector
    criteriaWeights = criteriaWeights / sum(criteriaWeights);

    bufPairComparisonMatrix = pairComparisonMatrix;

    % STAGE 1 - iterate on criterias and calculate alternative rates
    for criteria = 1:criteriaNum    

        % matrix normalization
        for alternative = 1:alternativeNum                         
            
            s = sum(pairComparisonMatrix(criteria, 1:alternativeNum, alternative));       
      
            pairComparisonMatrix(criteria, 1:alternativeNum, alternative) = ...
                pairComparisonMatrix(criteria, 1:alternativeNum, alternative) / s;            
        end
        
        %find score by criteria for alternatives
        for alternative = 1:alternativeNum

            alternativeVector = pairComparisonMatrix(criteria, alternative, :);

            score = mean(alternativeVector);

            criteriaAlternativeScoreMatrix(criteria, alternative) = score;
        end     

        mps = permute(bufPairComparisonMatrix(criteria, :, :), [2, 3, 1]);
        vka = criteriaAlternativeScoreMatrix(criteria, 1:alternativeNum);

        fprintf('Проверка МПС критерия %d на согласованность:\n\n', criteria);

        % check mps consistency
        printMpsConsistencyCheck(mps, vka);
    end

    % STAGE 2 - create b-matrixes for criterias
    criteriaBMatrixes = containers.Map('KeyType','int32','ValueType','any');

    for criteria = 1:criteriaNum

        bMatrix = zeros(alternativeNum, alternativeNum, 2);

        for alternative1 = 1:alternativeNum
            for alternative2 = 1:alternativeNum

                score1 = criteriaAlternativeScoreMatrix(criteria, alternative1);
                score2 = criteriaAlternativeScoreMatrix(criteria, alternative2);

                s = score1 + score2;

                normScore1 = score1 / s;
                normScore2 = score2 / s;

                bMatrix(alternative1, alternative2, 1) = normScore1;
                bMatrix(alternative1, alternative2, 2) = normScore2;  

            end
        end

        criteriaBMatrixes(criteria) = bMatrix;

        matrixStr = buildVectorMatrixStr(bMatrix);

        fprintf('AHP+: b-матрица для критерия %d:\n%s\n', criteria, matrixStr);

        % fprintf('AHP+: b-матрица для критерия %d, измерение 1\n', criteria);
        % disp(bMatrix(:, :, 1));
        % 
        % fprintf('AHP+: b-матрица для критерия %d, измерение 2\n', criteria);
        % disp(bMatrix(:, :, 2));

    end

    % STAGE 3 - create common W-matrix
    wMatrix = zeros(alternativeNum, alternativeNum, 2);

    for alternative1 = 1:alternativeNum
        for alternative2 = 1:alternativeNum

            sum1 = 0;
            sum2 = 0;

            for criteria = 1:criteriaNum

                bMatrix = criteriaBMatrixes(criteria);

                alternateScore1 = bMatrix(alternative1, alternative2, 1);
                alternateScore2 = bMatrix(alternative1, alternative2, 2);

                criteriaWeight = criteriaWeights(criteria);

                sum1 = sum1 + criteriaWeight * alternateScore1;
                sum2 = sum2 + criteriaWeight * alternateScore2;
            end               

            wMatrix(alternative1, alternative2, 1) = sum1;
            wMatrix(alternative1, alternative2, 2) = sum2;

        end
    end

    fprintf('AHP+: итоговая W-матрица:\n%s\n', buildVectorMatrixStr(wMatrix));

    % disp('AHP+: итоговая W-матрица (измерение 1)');
    % disp(wMatrix(:, :, 1));
    % 
    % disp('AHP+: итоговая W-матрица (измерение 2)');
    % disp(wMatrix(:, :, 2));
    
    % STAGE 4 - count global alternative scores 
    alternativeScores = zeros(1, alternativeNum); 
    scoreSum = 0;

    for alternative1 = 1:alternativeNum
        s = 0;

        for alternative2 = 1:alternativeNum
            
            s = s + wMatrix(alternative1, alternative2, 1);

        end

        alternativeScores(alternative1) = s;
        scoreSum = scoreSum + s;
    end

    alternativeScores = alternativeScores / scoreSum;

    [score, solution] = max(alternativeScores);
        
end