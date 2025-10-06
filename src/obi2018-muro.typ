#import "@preview/zebraw:0.5.5": *
#import "./lib.typ": flex, svg_inline
#show: zebraw

- #link("https://olimpiada.ic.unicamp.br/pratique/pu/2018/f3/muro/")[Enunciado]

Podemos criar uma função recursiva #svg_inline[f]:

#html.frame()[
  #text(fill: white)[
    $
      & f(0) = 1 \
      & f(n) = f(n-1) + 4f(n-2) + 2f(n-3) "para" n > 0
    $
  ]
]

#html.frame()[]

Como existem estados que irão se repetir, podemos
usar um vetor para guardar o valor da função já computados.


#zebraw(numbering: false)[
  ```cpp
  #include <bits/stdc++.h>
  #define int long long int
  using namespace std;

  const int mod = 1e9+7;
  const int MAX = 1e4+20;

  int dp[MAX]={};

  int solve(int pos) {
      if(pos==0) return 1;
      if(~dp[pos]) return dp[pos];

      int ans=0;

      ans = (ans+solve(pos-1))%mod;
      if(pos>=2) ans = (ans+4*solve(pos-2))%mod;
      if(pos>=3) ans = (ans+2*solve(pos-3))%mod;

      return dp[pos]=ans;
  }

  int32_t main() {

      memset(dp,-1,sizeof(dp));
      int n;
      scanf("%lld",&n);

      printf("%lld\n",solve(n));

      return 0;
  }
  ```
]

#include "./html_elements.typ"
