//
//  TriangleRenderTypes.h
//  MetalLearnDemo
//
//  Created by 高明阳 on 2020/8/20.
//  Copyright © 2020 高明阳. All rights reserved.
//
/*
 介绍:
 头文件包含了 Metal shaders 与C/OBJC 源之间共享的类型和枚举常数
*/

#ifndef TriangleRenderTypes_h
#define TriangleRenderTypes_h

// 缓存区索引值 共享与 shader 和 C 代码 为了确保Metal Shader缓存区索引能够匹配 Metal API Buffer 设置的集合调用
typedef enum TriangleVertexInputIndex{
    //顶点
    TriangleVertexInputIndexVertices = 0,
    TriangleVertexInputViewPortSize  = 1
}TriangleVertexInputIndex;

//结构体：顶点/颜色
typedef struct {
    //像素空间的位置
    //像素中心点(100,100)
    vector_float4 position;
    vector_float4 color;
}TriangleVertex;




#endif /* TriangleRenderTypes_h */
