#include <time.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef LONG64
typedef long s64Int;
typedef unsigned long u64Int;
#else
typedef long long s64Int;
typedef unsigned long long u64Int;
#endif


unsigned rand256()
{
    static unsigned const limit = RAND_MAX - RAND_MAX % 256;
    unsigned result = rand();
    while ( result >= limit ) {
        result = rand();
    }
    return result % 256;
}

unsigned long long rand64bits()
{
    unsigned long long results = 0ULL;
    for ( int count = 8; count > 0; -- count ) {
        results = 256U * results + rand256();
    }
    return results;
}

int main(int narg, char **arg)
{
  FILE *file;
  int me,nprocs;
  int i,j,iterate,niterate;
  int nlocal,nlocalm1,logtable,index,logtablelocal;
  int chunk,chunkbig,logprocs,ndata;
  u64Int *table,*data,*send;
  u64Int ran_add,datum,procmask,nglobal,offset,nupdates;
  u64Int ilong,nexcess_long,nbad_long;
  time_t t;	
  srand((unsigned) time(&t));
  u64Int mask;
  u64Int constant;
	
 
  if (narg != 5) {
    printf("Usage is num_procs, updates, chunk: num of addresses, mask_size:\n");
    printf("Ex. : executable 1 2 10000 4");
    exit(1);
  }

  logtable = atoi(arg[1]);
  niterate = atoi(arg[2]);
  chunk = atoi(arg[3]);
  u64Int mask_size = atoi(arg[4]);
  i = 1;
  while (i < nprocs) i *= 2;
  logprocs = 0;
  while (1 << logprocs < nprocs) logprocs++;

  nglobal = ((u64Int) 1) << logtable;
  nlocal = nglobal / nprocs;
  nlocalm1 = nlocal - 1;
  logtablelocal = logtable - logprocs;
  offset = (u64Int) nlocal * me;

  chunkbig = 16*chunk;

  table = (u64Int *) malloc(nlocal*sizeof(u64Int));
  data = (u64Int *) malloc(chunkbig*sizeof(u64Int));
  send = (u64Int *) malloc(chunkbig*sizeof(u64Int));

  if (!table || !data || !send) {
    //if (me == 0)
     printf("Table allocation failed\n");
  }


  
	//file = fopen(atoi(arg[4]),"w+");
	//if (file == NULL)
	//{
	  //  printf("Error opening file!\n");
    //exit(1);
	//}
	constant = 1;
	
	mask = (constant << (mask_size*4)) - 1;
	//printf ("%d,\n%d\n",mask,mask_size);
	//mask = 3;
		
  for (iterate = 0; iterate < niterate; iterate++) {
    for (i = 0; i < chunk; i++) {
     ran_add = rand64bits();//rand();
      ran_add = ran_add & mask ;
      data[i] = data[i]+ran_add; //update
	//fprintf(file, "%016llx\n",ran_add);
	  printf("%016llx\n",ran_add);
    }
    ndata = chunk;
    }
		//fclose(file);

  /* clean up */

  free(table);
  free(data);
  free(send);
}



