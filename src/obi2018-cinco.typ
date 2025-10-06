#import "@preview/zebraw:0.5.5": *
#import "./lib.typ": flex, svg_inline
#show: zebraw

- #link("https://olimpiada.ic.unicamp.br/pratique/pu/2018/f3/cinco/")[Enunciado]

Podemos criar um algoritmo guloso simples, trocar sempre (em ordem):

1. O dígito mais significativo que for trocado por um número maior do que ele
2. (na falha do primeiro) O dígito menos significativo que for trocado por um número menor do que ele

#zebraw(numbering: false)[
  ```cpp
  #include <bits/stdc++.h>
  using namespace std;

  int main() {

      int n;
      scanf("%d",&n);
      int arr[n];

      for(int i=0;i<n;i++) scanf("%d",&arr[i]);

      for(int i=0;i<n;i++) {
          if(arr[i]<arr[n-1]&&(arr[i]==0||arr[i]==5)) {
              swap(arr[i],arr[n-1]);
              for(int j=0;j<n;j++) printf("%d%c",arr[j],j==n-1?'\n':' ');
              exit(0);
          }
      }

      for(int i=n-1;i>=0;i--) {
          if(arr[i]==0||arr[i]==5) {
              swap(arr[i],arr[n-1]);
              for(int j=0;j<n;j++) printf("%d%c",arr[j],j==n-1?'\n':' ');
              exit(0);
          }
      }

      puts("-1");

      return 0;
  }
  ```
]

#include "./html_elements.typ"
