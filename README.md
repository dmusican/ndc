# ndc
NDC: Normally Distributed Cluster centers data generator

There are two pieces of software in this repository.

1. NORMALLY DISTRIBUTED CLUSTERS is a data generator. It generates a series of
   random centers for multivariate normal distributions. NDC randomly generates
   a fraction of data for each center, i.e. what fraction of data points will
   come from this center. NDC randomly generates a separating plane. Based on
   this plane, classes for are chosen for each center. NDC then randomly
   generates the points from the distributions. NDC can increase inseparability
   by increasng variances of distributions. A measure of "true" separability is
   obtained by looking at how many points end up on the wrong side of the
   separating plane. All values are taken as integers for simplicity.

2. MULTI CLASS NORMALLY DISTRIBUTED CLUSTERS is a variation on NDC which works
   on multiple classes.

Find both NDC and MC_NDC in the appropriate subdirectories, along with copyright and citation information.
