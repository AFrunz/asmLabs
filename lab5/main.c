#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#include <time.h>

const char filename[] = "imgs/cat.png";
const char resFilename1[] = "imgs/resC.png";
const char resFilename2[] = "imgs/resAs.png";

void imageProcAsm(unsigned char* data, unsigned char* newData, int x, int y);

void imageProc(unsigned char* data, unsigned char* newData, int x, int y){
    for (int i = 0; i < x * y * 3; i += 3){
        newData[i / 3] = data[i] * 0.3 + data[i + 1] * 0.59 + data[i + 2] * 0.11;
    }
}




int main() {

    struct timespec t, t1, t2;

    // 1. Open image file
    int x, y, n;
    unsigned char* data = stbi_load(filename, &x, &y, &n, 3);
    unsigned char* newData1 = calloc(x * y, sizeof(char));
    unsigned char* newData2 = calloc(x * y, sizeof(char));

    // 2. Processing image in C lang
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
    imageProc(data, newData1, x, y);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
    t.tv_sec = t2.tv_sec - t1.tv_sec;
    if ((t.tv_nsec=t2.tv_nsec-t1.tv_nsec)<0){
        t.tv_sec--;
        t.tv_nsec+=1000000000;
    }
    printf("C lang time:    %ld.%09ld\n", t.tv_sec, t.tv_nsec);
    // 3. Processing image in AS lang
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
    imageProcAsm(data, newData2, x, y);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
    t.tv_sec = t2.tv_sec - t1.tv_sec;
    if ((t.tv_nsec=t2.tv_nsec-t1.tv_nsec)<0){
        t.tv_sec--;
        t.tv_nsec+=1000000000;
    }
    printf("ASM lang time:  %ld.%09ld\n", t.tv_sec, t.tv_nsec);
    // 4. Save new image
    stbi_write_png(resFilename1, x, y, 1, newData1, 0);
    stbi_write_png(resFilename2, x, y, 1, newData2, 0);
    // 5. free data
    free(newData1);
    free(newData2);
    stbi_image_free(data);
    return 0;
}
