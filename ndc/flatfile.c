/* flatfile.c
 Takes an int matrix passed in, and outputs as a comma delimited flat file.
 The second argument indicates the filename.
 The third argument indicates whether a new file should be created, or
 whether it should be appended.

 Copyright (C) 2000 David R. Musicant.
 Version 1.0
 This software is free for academic and research use only.
 For commercial use, contact musicant@cs.wisc.edu.*/

#include <math.h>
#include "mex.h"
#include "matrix.h"

/* Input Arguments */

#define	MATRIX_IN	prhs[0]
#define FILENAME_IN     prhs[1]
#define	APPEND_IN	prhs[2]
#define NUM_ARGS        3

static void doit(
		   double	matrix[],
		   char*        fileName,
		   int          append,
		   unsigned int rows,
		   unsigned int cols
		   )
{
  FILE *fp;
  int i,j;

  /* Open up the file */
  if (append)
    fp = fopen(fileName,"a");
  else
    fp = fopen(fileName,"w");

  /* Write out the rows and columns */
  for (i=0; i < rows; i++) {
    for (j=0; j < cols-1; j++)
      fprintf(fp,"%d, ",(int)matrix[i + j*rows]);
    fprintf(fp,"%d\n",(int)matrix[i + (cols-1)*rows]);
  }

  /* Close it up */
  fclose(fp);

  return;
}

void mexFunction(
                 int nlhs,       mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]
		 )
{
  double	*matrix,*pAppend;
  unsigned int	rows,cols;
  int           status,buflen,append;
  char          fileName[1000];

  /* Check for proper number of arguments */
  
  if (nrhs != NUM_ARGS)
    mexErrMsgTxt("Incorrect number of arguments.");

  /* Check the dimensions */
  
  rows = mxGetM(MATRIX_IN);
  cols = mxGetN(MATRIX_IN);

  /* Assign pointers to the various parameters */
  
  matrix = (double *)mxGetPr(MATRIX_IN);

  buflen = (mxGetM(FILENAME_IN) * mxGetN(FILENAME_IN)) + 1;
  status = mxGetString(FILENAME_IN, fileName, buflen);
  if (status != 0)
    mexErrMsgTxt("Could not convert string data.");

  pAppend = (double *)mxGetPr(APPEND_IN);
  append = (int)*pAppend;

  /* Do the actual computations in a subroutine */
  doit(matrix,fileName,append,rows,cols);
  return;
}
