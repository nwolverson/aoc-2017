#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_LENGTH 2000

int answer1(int *input, int n) {
    int j = 0;
    for (int i = 0; i >= 0 && i < n; j++) {
        i += input[i]++;
    }
    return j;
}
int answer2(int *input, int n) {
    int j = 0;
    for (int i = 0; i >= 0 && i < n; j++) {
        i += input[i] >= 3 ? input[i]-- : input[i]++;
    }
    return j;
}

int main() {
    int i = 0, n;
    int *input = malloc(sizeof(int) * MAX_INPUT_LENGTH);
    while (i <= MAX_INPUT_LENGTH && scanf("%d", &n) == 1) {
        input[i++] = n;
    }
    int *cpy = malloc(sizeof(int) * i);
    memcpy(cpy, input, sizeof(int) * i);
    printf("%d\n%d\n", answer1(input, i), answer2(cpy, i));
    return 0;
}