#ifndef CSTRUCT
#define CSTRUCT
typedef struct {
    long long x;
    long long y;
    long long z;
    // char c;
    
} Point3D;

__attribute__((visibility("default"))) 
Point3D* buildPoint();
#endif