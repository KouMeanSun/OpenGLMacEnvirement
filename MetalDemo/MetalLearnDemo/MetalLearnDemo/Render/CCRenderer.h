//
//  CCRenderer.h
//  MetalLearnDemo
//
//  Created by 高明阳 on 2020/8/26.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import <Foundation/Foundation.h>
//导入MetalKit工具包
@import MetalKit;

//这是一个独立于平台的渲染类
//MTKViewDelegate协议:允许对象呈现在视图中并响应调整大小事件
@interface CCRenderer : NSObject<MTKViewDelegate>

//初始化一个MTKView
-(nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;
@end


