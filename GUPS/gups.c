#include <time.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX(a,b) ((a) > (b) ? (a) : (b))


#ifdef LONG64
#define POLY 0x0000000000000007UL
#define PERIOD 1317624576693539401L
#define ZERO64B 0L
typedef long s64Int;
typedef unsigned long u64Int;
#else
#define POLY 0x0000000000000007ULL
#define PERIOD 1317624576693539401LL
#define ZERO64B 0LL
typedef long long s64Int;
typedef unsigned long long u64Int;
#endif


unsigned 
rand256()
{
    static unsigned const limit = RAND_MAX - RAND_MAX % 256;
    unsigned result = rand();
    while ( result >= limit ) {
        result = rand();
    }
    return result % 256;
}

unsigned long long
rand64bits()
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
  int logprocs,ipartner,ndata,nsend,nkeep,nrecv,maxndata,maxnfinal,nexcess;
  int nbad,chunk,chunkbig;
  double t0,t0_all,Gups;
  u64Int *table,*data,*send;
  u64Int ran,datum,procmask,nglobal,offset,nupdates;
  u64Int ilong,nexcess_long,nbad_long;
  time_t t;	
  srand((unsigned) time(&t));
	
  /* command line args = N M chunk
     N = length of global table is 2^N
     M = # of update sets per proc
     chunk = # of updates in one set */

  if (narg != 4) {
    if (me == 0) printf("Syntax: gups N M chunk\n");
  }

  logtable = atoi(arg[1]);
  niterate = atoi(arg[2]);
  chunk = atoi(arg[3]);


  i = 1;
  while (i < nprocs) i *= 2;
  if (i != nprocs) {
    //if (me == 0) printf("Must run on power-of-2 procs\n");
  }

  logprocs = 0;
  while (1 << logprocs < nprocs) logprocs++;

  nglobal = ((u64Int) 1) << logtable;
  nlocal = nglobal / nprocs;
  nlocalm1 = nlocal - 1;
  logtablelocal = logtable - logprocs;
  offset = (u64Int) nlocal * me;

  /* allocate local memory
     16 factor insures space for messages that (randomly) exceed chunk size */

  chunkbig = 16*chunk;

  table = (u64Int *) malloc(nlocal*sizeof(u64Int));
  data = (u64Int *) malloc(chunkbig*sizeof(u64Int));
  send = (u64Int *) malloc(chunkbig*sizeof(u64Int));

  if (!table || !data || !send) {
    if (me == 0) printf("Table allocation failed\n");
  }

  /* initialize my portion of global array
     global array starts with table[i] = i */

  for (i = 0; i < nlocal; i++) table[i] = i + offset;


 
   
   		
  nupdates = (u64Int) nprocs * chunk * niterate;
  


 
  maxndata = 0;
  maxnfinal = 0;
  nexcess = 0;
  nbad = 0;

  
	//file = fopen(atoi(arg[4]),"w+");
	//if (file == NULL)
	//{
	  //  printf("Error opening file!\n");
    //exit(1);
	//}
	u64Int mask_size = atoi(arg[4]);
	u64Int mask;
	u64Int constant;
	constant = 1;
	
	mask = (constant << (mask_size*4)) - 1;
	//printf ("%d,\n%d\n",mask,mask_size);
	//mask = 3;
		
  for (iterate = 0; iterate < niterate; iterate++) {
    for (i = 0; i < chunk; i++) {
     ran = rand64bits();//rand();
      ran = ran & mask  ;
      data[i] = ran;
			//fprintf(file, "%016llx\n",ran);
	  printf("%016llx\n",ran);
    }
    ndata = chunk;
		//fclose(file);

  
  /* clean up */

  free(table);
  free(data);
  free(send);
}



