//
//  MyImageRender.h
//  MetalLearnDemo
//
//  Created by 高明阳 on 2020/8/26.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MetalKit;


@interface MyImageRender : NSObject<MTKViewDelegate>
- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end


