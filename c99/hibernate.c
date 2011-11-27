// stupid utility that tells the kernel to perform STD
#include <stdio.h>
#include <stdlib.h>

int main (int argc, char *argv[]) {
    FILE *f = fopen("/sys/power/state", "w");
    if (f == NULL) exit(-1);
    fputs("disk", f);
    fclose(f);
}
