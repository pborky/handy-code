// stupid utility that tells the kernel to perform STR
#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[]) {
    FILE *f = fopen("/sys/power/state", "w");
    if (f == NULL) exit(-1);
    fputs("mem", f);
    fclose(f);
}
