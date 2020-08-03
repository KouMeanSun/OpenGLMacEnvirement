//
//  TriangleViewController.m
//  OpenGLESDemo
//
//  Created by 高明阳 on 2020/8/1.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import "TriangleViewController.h"


@interface TriangleViewController ()

@property(nonatomic,strong)EAGLContext *mContext;
@property(nonatomic,strong)GLKBaseEffect *mEffect;

@property(nonatomic,assign)int count;

//旋转的度数
@property(nonatomic,assign)float XDegree;
@property(nonatomic,assign)float YDegree;
@property(nonatomic,assign)float ZDegree;

//是否旋转X,Y,Z
@property(nonatomic,assign) BOOL XB;
@property(nonatomic,assign) BOOL YB;
@property(nonatomic,assign) BOOL ZB;

@property (nonatomic, strong)UIButton *xButton;
@property (nonatomic, strong)UIButton *yButton;
@property (nonatomic, strong)UIButton *zButton;

@end

@implementation TriangleViewController
{
    dispatch_source_t timer;
}
-(void)initSubViews{
    self.xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xButton.frame = CGRectMake(50, self.view.bounds.size.height-100, 50, 50);
    self.xButton.backgroundColor = [UIColor blueColor];
    [self.xButton setTitle:@"X" forState:UIControlStateNormal];

    self.yButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.yButton.frame = CGRectMake(110, self.view.bounds.size.height-100, 50, 50);
    self.yButton.backgroundColor = [UIColor blueColor];
    [self.yButton setTitle:@"Y" forState:UIControlStateNormal];

    self.zButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zButton.frame = CGRectMake(170, self.view.bounds.size.height-100, 50, 50);
    self.zButton.backgroundColor = [UIColor blueColor];
    [self.zButton setTitle:@"Z" forState:UIControlStateNormal];

    [self.view addSubview:self.xButton];
    [self.view addSubview:self.yButton];
    [self.view addSubview:self.zButton];

    [self.xButton addTarget:self action:@selector(XClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.yButton addTarget:self action:@selector(YClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.zButton addTarget:self action:@selector(ZClick:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    //1.新建图层
    [self setupContext];
//
//    //2.渲染图形
    [self render];
    
    [self initSubViews];
}
//1.新建图层
-(void)setupContext
{
    //1.新建OpenGL ES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *view = (GLKView *)self.view;
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.mContext];
    glEnable(GL_DEPTH_TEST);
}

//2.渲染图形
-(void)render
{
    //1.顶点数据
        //前3个元素，是顶点数据；中间3个元素，是顶点颜色值，最后2个是纹理坐标
    //    GLfloat attrArr[] =
    //    {
    //        -0.5f, 0.5f, 0.0f,      1.0f, 0.0f, 1.0f,       0.0f, 1.0f,//左上
    //        0.5f, 0.5f, 0.0f,       1.0f, 0.0f, 1.0f,       1.0f, 1.0f,//右上
    //        -0.5f, -0.5f, 0.0f,     1.0f, 1.0f, 1.0f,       0.0f, 0.0f,//左下
    //
    //        0.5f, -0.5f, 0.0f,      1.0f, 1.0f, 1.0f,       1.0f, 0.0f,//右下
    //        0.0f, 0.0f, 1.0f,       0.0f, 1.0f, 0.0f,       0.5f, 0.5f,//顶点
    //    };
        
        GLfloat attrArr[] =
        {
            -0.5f, 0.5f, 0.0f,      1.0f, 0.0f, 1.0f,       0.0f,1.0f,//左上
            0.5f, 0.5f, 0.0f,       1.0f, 0.0f, 1.0f,       1.0f,1.0f,//右上
            -0.5f, -0.5f, 0.0f,     1.0f, 1.0f, 1.0f,       0.0f,0.0f,//左下
            
            0.5f, -0.5f, 0.0f,      1.0f, 1.0f, 1.0f,       1.0f,0.0f,//右下
            0.0f, 0.0f, 1.0f,       0.0f, 1.0f, 0.0f,       0.5f,0.5f,//顶点
        };
        
        //2.绘图索引
        GLuint indices[] =
        {
            0, 3, 2,
            0, 1, 3,
            0, 2, 4,
            0, 4, 1,
            2, 3, 4,
            1, 4, 3,
        };
    //顶点个数
    self.count = sizeof(indices)/sizeof(GLuint);
    
    //将顶点数组放入数组缓冲区中 GL_ARRAY_BUFFER
    GLuint bufferID;
    glGenBuffers(1, &bufferID);
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_STATIC_DRAW);
    
    //将索引数组存储到索引缓冲区 GL_ELEMENT_ARRAY_BUFFER
    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    //使用顶点数据
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, NULL);
    
    //使用颜色数据
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, (GLfloat *)NULL + 3);
    
    //使用纹理数据
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, (GLfloat *)NULL + 6);
    
    //1.获取纹理图片路径
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"kunkun" ofType:@"jpg"];
    
    //2.设置纹理从参数
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(0), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filepath options:options error:nil];
    
    //着色器
    self.mEffect = [[GLKBaseEffect alloc] init];
    
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name  = textureInfo.name;
    //投影视图
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width/size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective( GLKMathDegreesToRadians(90.0f), aspect, 0.1f, 100.0f);
    projectionMatrix = GLKMatrix4Scale(projectionMatrix, 1.0f, 1.0f, 1.0f);
    self.mEffect.transform.projectionMatrix = projectionMatrix;
    
    //模型视图
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f );
    self.mEffect.transform.modelviewMatrix = modelViewMatrix;
    
    //定时器
    double seconds = 0.1;
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, seconds*NSEC_PER_SEC, 0.0);
    dispatch_source_set_event_handler(timer, ^{
        self.XDegree += 0.1f * self.XB;
        self.YDegree += 0.1f * self.YB;
        self.ZDegree += 0.1f * self.ZB;
    });
    dispatch_resume(timer);
    
}
//场景数据变化
-(void)update{
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.5f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, self.XDegree);
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, self.YDegree);
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, self.ZDegree);
    
    self.mEffect.transform.modelviewMatrix = modelViewMatrix;
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.mEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.count, GL_UNSIGNED_INT, 0);
}
-(void)XClick:(UIButton *)btn{
    _XB = !_XB;
}
-(void)YClick:(UIButton *)btn{
     _YB = !_YB;
}
-(void)ZClick:(UIButton *)btn{
    _ZB = !_ZB;
}
@end
