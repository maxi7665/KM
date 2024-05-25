function [result] = printMpsConsistencyCheck(mps, w)
%Ensure that provided pair comparison matrix is valid and print result
% mps - matrix
% w - normalized

    rows = size(mps, 1);
    cols = size(mps, 2);
    
    if (rows ~= cols)
        error('mps size is not valid');
    end
    
    % максимальное собственное значение матрицы
    eigenValue = max(eig(mps));

    % вектор-столбец ВКА
    w = transpose(w);
    
    disp('МПС:');
    disp(mps);
    
    disp('ВК:');
    disp(w);
    
    disp('Максимальное собственное значение (n):');
    disp(eigenValue);
    
    checkEigenVector1 = mps * w;
    checkEigenVector2 = w * eigenValue;

     % с точностью до 4х - знаков - против арифметики с плавающей запятой
    checkEigenVector1 = round(checkEigenVector1, 4);
    checkEigenVector2 = round(checkEigenVector2, 4);

    disp('A * W =');
    disp(checkEigenVector1);

    disp('n * W =');
    disp(checkEigenVector2);    
    
    if (checkEigenVector1 == checkEigenVector2)
        disp('МПС согласована');

        result = 1;
    else
        error('МПС не согласована');

        result = 0;
    end    
end