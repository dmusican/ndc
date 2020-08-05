function M = generate_dataset(centers_matrix, ss,class_locations, n_features)
    [r, c] = size(class_locations);
    M = zeros(0, n_features);
    l = zeros(0, 1);
    for i = 1:r
        for j = 1:c
            tmp = normrnd(centers_matrix(int32(class_locations(i,j))), 5,[int32(ss(i,j)), n_features]);
            label_tmp = ones(int32(ss(i,j)), 1)*(i);
            l = [l; label_tmp];
            M = [M; tmp];
        end
    end
    M = [M, l];
end