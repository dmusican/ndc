function cls_locs = class_center_locations(n_classes, n_centers);
    locs = datasample(1:n_centers,n_centers,'Replace',false);

    n_cen_fe_cls = int32(floor(n_centers/n_classes));
    cls_locs = zeros(n_classes,n_cen_fe_cls);
    k = 1;
    for i = 1:n_classes
        for j = 1:n_cen_fe_cls
            cls_locs(i,j) = locs(k);
            k = k+1;
        end
    end

end