//
//  MyImage.h
//  MetalLearnDemo
//
//  Created by 高明阳 on 2020/8/26.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyImage : NSObject
//图片的宽高，以像素为单位
@property(nonatomic,readonly)NSUInteger width;
@property(nonatomic,readonly)NSUInteger height;

//图片数据每像素32bit，以RGBA形式的图像数据(相当于MTLPixelFormatRGBA8Unorm)
@property(nonatomic,readonly)NSData * _Nullable data;

//通过加载一个简单的TGA文件初始化这个图像，只支持32bit的TGA文件
-(nullable instancetype)initWithTGAFileAtLocation:(nonnull NSURL *)location;

@end


