int collatz_lenght(int N) {
  if (N == 1) { return 0; }
  else if (N == 2) { return 1; }
  else {
    int i = N;
    int j = 2;
    while (i>2) {
      if (i%2==0) {
        i = i/2;
      }
      else {
        i = 3*i+1;
      }
      j++;
    }
  return j;
  }
}
