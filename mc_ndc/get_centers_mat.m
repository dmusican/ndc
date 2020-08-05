function [centers_matrix] = get_centers_mat(centers_list, n_features);
    n_centers = 6 * n_features;
    centers_matrix = zeros(n_centers, n_features);
    for i = 1:3
        for j = 1:n_features
            centers_matrix((i-1)*2*n_features + (2*j)-1, j)   =  centers_list(i);
            centers_matrix((i-1)*2*n_features + (2*j), j) = -centers_list(i);
        end
    end
end