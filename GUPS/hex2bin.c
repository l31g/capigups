#include<stdio.h>
#define MAX 16
#define BINMAX 64

int main(){
        char binaryNumber[BINMAX],hexaDecimal[MAX];
        int i=0;
		FILE *f1,*f2;

		f1 = fopen ("hex_address.txt", "r");  /* open the file for reading */
        f2 = fopen ("bin_address.txt","w+");
        while(fscanf(f1, "%s", hexaDecimal) == 1)
		//while(!feof(f1))
		{
            //fscanf(f1,"%s",hexaDecimal);
          //  printf("%s\n",hexaDecimal);
            //sscanf  ( hexaDecimal ,"%s" );
            i=0;
            while(hexaDecimal[i]){
                switch(hexaDecimal[i]){
                    case '0': fprintf(f2,"0000"); break;
                    case '1': fprintf(f2,"0001"); break;
                    case '2': fprintf(f2,"0010"); break;
                    case '3': fprintf(f2,"0011"); break;
                    case '4': fprintf(f2,"0100"); break;
                    case '5': fprintf(f2,"0101"); break;
                    case '6': fprintf(f2,"0110"); break;
                    case '7': fprintf(f2,"0111"); break;
                    case '8': fprintf(f2,"1000"); break;
                    case '9': fprintf(f2,"1001"); break;
                    case 'A': fprintf(f2,"1010"); break;
                    case 'B': fprintf(f2,"1011"); break;
                    case 'C': fprintf(f2,"1100"); break;
                    case 'D': fprintf(f2,"1101"); break;
                    case 'E': fprintf(f2,"1110"); break;
                    case 'F': fprintf(f2,"1111"); break;
                    case 'a': fprintf(f2,"1010"); break;
                    case 'b': fprintf(f2,"1011"); break;
                    case 'c': fprintf(f2,"1100"); break;
                    case 'd': fprintf(f2,"1101"); break;
                    case 'e': fprintf(f2,"1110"); break;
                    case 'f': fprintf(f2,"1111"); break;
                    default:  printf("\nInvalid hexadecimal digit %c ",hexaDecimal[i]); return 0;
                }
                //printf("%d",i);
                i++;
                
            }
            fprintf(f2,"\n");
            //printf("%d",i);
            //i=0;
		}
	  fclose(f1);
      fclose(f2);

    return 0;
}
