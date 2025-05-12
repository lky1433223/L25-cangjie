#include"cstruct.h"
#include<stdio.h>
#include<stdlib.h>
Point3D* buildPoint()
{
    Point3D* a = (Point3D*)malloc(sizeof(Point3D));
    a->x = 10;
    a->y = 2;
    a->z = 3;
    // a->c = 'a';
    return a;
}
