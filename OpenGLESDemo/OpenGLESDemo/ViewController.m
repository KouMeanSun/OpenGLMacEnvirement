//
//  ViewController.m
//  OpenGLESDemo
//
//  Created by 高明阳 on 2020/7/25.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface ViewController ()
{
    EAGLContext *context;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(void)commonInit{
    self.title = @"OpenGLES练习";
    self.view.backgroundColor = [UIColor greenColor];
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    //判断context是否创建成功
    if(!context){
        NSLog(@"Create ES context Failed");
    }
    //设置当前上下文
    [EAGLContext setCurrentContext:context];
    
    //创建GLKView
    GLKView *glkView = [[GLKView alloc] initWithFrame:self.view.bounds context:context];
    glkView.delegate = self;
    
    [self.view addSubview:glkView];
    //设置背景颜色
    glClearColor(1, 0, 0, 1);
}

#pragma mark -- GLKViewDelegate
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
