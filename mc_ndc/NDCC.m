%{
MULTI CLASS NORMALLY DISTRIBUTED CLUSTERS is a multi-class data generator. 
It generates a series of random centers for multivariate
normal distributions. NDC randomly generates a fraction
of data for each center, i.e. what fraction of data points
will come from this center. NDC randomly generates a 
separating plane. Based on this plane, classes for are 
chosen for each center. NDC then randomly generates the 
points from the distributions. NDC can increase 
inseparability by increasng variances of distributions.
A measure of "true" separability is obtained by looking 
at how many points end up on the wrong side of the 
separating plane. All values are taken as integers 
for simplicity.
%}
%Authors: Hossein Moosaei, David R. Musicant, Saeed Khosravi, Milan Hladík



centers_list = [100, 300, 500];
n_samples  = input('Enter the number of samples:\n');
n_features = input('Enter the number of features:\n');
n_classes  = input('Enter the number of classes:\n');


centers_matrix = get_centers_mat(centers_list, n_features);
n_centers = 2*length(centers_list)*n_features;
class_locations = class_center_locations(n_classes, n_centers);
ss = sample_spliter(n_samples, n_classes, n_centers);

ds = generate_dataset(centers_matrix, ss,class_locations, n_features);

writematrix(ds, 'dataset.csv');
    