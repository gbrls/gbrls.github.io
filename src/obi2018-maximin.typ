#import "@preview/zebraw:0.5.5": *
#import "./lib.typ": flex, svg_inline
#show: zebraw

- #link(
    "https://olimpiada.ic.unicamp.br/pratique/ps/2018/f3/maximin/",
  )[Enunciado]

Como o tamanho máximo do vetor é #svg_inline[10^5] podemos ordená-lo. Fazendo isso podemos ver que o número que estamos procurando está
entre dois números vizinhos no vetor ou está em alguma das extremidades.

#zebraw(numbering: false)[
  ```cpp
  #include <bits/stdc++.h>
  using namespace std;

  int main() {
      int n,r,l;
      scanf("%d%d%d",&n,&r,&l);
      int arr[n];
      for(int i=0;i<n;i++) scanf("%d",&arr[i]);

      sort(arr,arr+n);

      int dif=0;
      for(int i=1;i<n;i++) {
          int mid=(arr[i]+arr[i-1])/2;
          if(mid>=r&&mid<=l) dif=max(dif,min(abs(mid-arr[i]),abs(mid-arr[i-1])));
      }

      if(l>arr[n-1]) dif=max(dif, l-arr[n-1]);
      if(r<arr[0]) dif=max(dif,arr[0]-r);

      printf("%d\n",dif);

      return 0;
  }
  ```
]

#include "./html_elements.typ"
