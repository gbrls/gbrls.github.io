#import "html_elements.typ": post
#show: post

#import "@preview/zebraw:0.5.5": *
#import "./lib.typ": flex, svg_inline
#show: zebraw


- #link("https://olimpiada.ic.unicamp.br/pratique/ps/2018/f3/bolas/")[Enunciado].

Como o tamano do vetor é #svg_inline[$8$] e temos sempre #svg_inline[$8$] números para escolher, existem #svg_inline[$8!$] permutações possíveis. Como #svg_inline[$8!$] é pequeno, podemos fazer uma solução de busca completa. Existem de varias soluções possíveis como com _next_permutation_. Segue uma solução de backtracking:

#zebraw(
  numbering: false,
)[
  ```cpp
  #include <bits/stdc++.h>
  using namespace std;

  int vet[9]={};

  int solve(int pos, int n) {
      if(pos==8) return 1;

      int ans=0;

      for(int i=0;i<=9;i++) {
          if(n != i && vet[i]) {
              vet[i]--;
              ans|=solve(pos+1,i);
              vet[i]++;
          }
      }

      return ans;
  }

  int main() {

      for(int i=0;i<8;i++) {
          int aux;
          scanf("%d",&aux);
          vet[aux]++;
      }

      int ans=solve(0,-1);
      puts(ans?"S":"N");

      return 0;
  }
  ```
]

