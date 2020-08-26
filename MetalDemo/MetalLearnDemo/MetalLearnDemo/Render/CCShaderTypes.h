//
//  CCShaderTypes.h
//  MetalLearnDemo
//
//  Created by 高明阳 on 2020/8/26.
//  Copyright © 2020 高明阳. All rights reserved.
//

#ifndef CCShaderTypes_h
#define CCShaderTypes_h
#include <simd/simd.h>

// 缓存区索引值 共享与 shader 和 C 代码 为了确保Metal Shader缓存区索引能够匹配 Metal API Buffer 设置的集合调用

typedef enum CCVertexInputIndex{
   //顶点
    CCVertexInputIndexVertices = 0,
    //视图大小
    CCVertexInputIndexViewportSize = 1,
}CCVertexInputIndex;

//结构体：顶点/颜色值
typedef struct {
    //像素空间的位置
    //像素中心点(100,100)
    //float float
    vector_float2 position;
    //RGBA颜色
    // float float float float
    vector_float4 color;
}CCVertex;

#endif /* CCShaderTypes_h */
