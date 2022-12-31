#include <stdio.h>
#include <stdlib.h>

int main(void){


  srand(10000);

  int matriz[3][6],linhas[3],colunas[6];
  int soma=0,total=0;

  for(int i=0;i<3;i++){
    for (int j=0;j<6;j++){
      matriz[i][j]=rand()%9;
      printf("%d ",matriz[i][j]);
      total+=matriz[i][j];
      }
    printf("\n");
    }

  for(int l=0;l<3;l++){
    soma=0;
    for (int c=0;c<6;c++){
      soma+=matriz[l][c];
    }
    linhas[l]=soma;
  }

  for(int c=0;c<6;c++){
    soma=0;
    for(int l=0;l<3;l++){
      soma+=matriz[l][c];
    }
    colunas[c]=soma;
  }
  

  printf("\n");
  printf("Linhas: ");
  for(int c=0;c<3;c++)
    printf(" %d",linhas[c]);

  printf("\n");

  printf("Colunas: ");
  for(int c=0;c<6;c++)
    printf(" %d",colunas[c]);
    
  printf("\n");

  for(int i=0;i<3;i++){
    printf("+---+-+---+-+---+-+---+-+---+-+---+-----|\n");
    for(int j=0;j<6;j++){
      printf("| %d | ",matriz[i][j]);
    }
    printf("  %d\n",linhas[i]);
  }
  printf("+---+-+---+-+---+-+---+-+---+-+---+-----|\n");
  for(int c=0;c<6;c++)
    printf("| %2d| ",colunas[c]);
  printf("  %2d ",total);
  printf("\n");
  return 0;}

