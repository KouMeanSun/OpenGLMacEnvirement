//
// Created by 高明阳 on 2020/7/31.
// Copyright (c) 2020 高明阳. All rights reserved.
//

#import "CubeViewController.h"
#import <GLKit/GLKit.h>
///顶点数
#define kCoordCount  36

typedef struct {
    ///顶点坐标
    GLKVector3 positionCoord;
    ///纹理坐标
    GLKVector2 textureCoord;
    ///法线
    GLKVector3 vnormal;
}MyVertex;
@interface CubeViewController()<GLKViewDelegate>

@property (nonatomic, strong)GLKView *glkView;
@property (nonatomic, strong)GLKBaseEffect *baseEffect;
@property (nonatomic, assign)MyVertex *vertices;

@property (nonatomic, strong)CADisplayLink *displayLink;
@property (nonatomic, assign)NSInteger angle;
@property (nonatomic, assign)GLuint vertexBuffer;

@end

@implementation CubeViewController

-(void)dealloc{
    if([EAGLContext currentContext] == self.glkView.context){
        [EAGLContext setCurrentContext:nil];
    }
    if(_vertices){
        free(_vertices);
        _vertices = nil;
    }
    if(_vertexBuffer){
        glDeleteBuffers(1, &_vertexBuffer);
        _vertexBuffer = 0;
    }
    //display 失效
    [self.displayLink invalidate];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    //1.View 背景色
    self.view.backgroundColor = [UIColor blackColor];
    //2.OpenGL ES 相关初始化
    [self commonInit];
    //3.添加CADisplayLink
    [self addCADisplayLink];
}

-(void)commonInit{
    //1.创建context
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //是指当前的context
    [EAGLContext setCurrentContext:context];

    //2.创建GLKView 并设置代理
    CGRect frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width);
    self.glkView = [[GLKView alloc] initWithFrame:frame context:context];
    self.glkView.backgroundColor = [UIColor clearColor];
    self.glkView.delegate = self;

    //3.使用深度缓存 (如果不用，或者用错(eg:GLKViewDrawableColorFormat)，会造成深度测试失效)
    self.glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    //默认是(0,1) ,这里用于翻转z轴，使正方向朝屏幕歪
    glDepthRangef(1, 0);

    //4.将GLKView 添加self.view 上
    [self.view addSubview:self.glkView];

    //5.获取纹理图片
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"kunkun.jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

    //6.设置纹理参数
    NSDictionary *options = @{GLKTextureLoaderOriginBottomLeft:@(YES)};
    NSError *error;
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:[image CGImage] options:options error:&error];
    if (error){
        NSLog(@"textureWithCGImage failed!");
        return;
    }
    //7.使用baseEffect
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    //开启光照效果
    self.baseEffect.light0.enabled = YES;
    //漫反射颜色
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1, 1, 1, 1);
    //光照位置
    self.baseEffect.light0.position = GLKVector4Make(-0.5, -0.5, 5, 1);

    /*
     解释一下:
     这里我们不复用顶点，使用每 3 个点画一个三角形的方式，需要 12 个三角形，则需要 36 个顶点
     以下的数据用来绘制以（0，0，0）为中心，边长为 1 的立方体
     */
    //8.开辟顶点数据空间(数据结构SenceVertex 大小 * 顶点个数kCoordCount)
    self.vertices = malloc(sizeof(MyVertex )*kCoordCount);


    // 前面
    self.vertices[0] = (MyVertex){{-0.5, 0.5, 0.5}, {0, 1}, {0, 0, 1}};
    self.vertices[1] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 0}, {0, 0, 1}};
    self.vertices[2] = (MyVertex){{0.5, 0.5, 0.5}, {1, 1}, {0, 0, 1}};
    self.vertices[3] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 0}, {0, 0, 1}};
    self.vertices[4] = (MyVertex){{0.5, 0.5, 0.5}, {1, 1}, {0, 0, 1}};
    self.vertices[5] = (MyVertex){{0.5, -0.5, 0.5}, {1, 0}, {0, 0, 1}};

    // 上面
    self.vertices[6] = (MyVertex){{0.5, 0.5, 0.5}, {1, 1}, {0, 1, 0}};
    self.vertices[7] = (MyVertex){{-0.5, 0.5, 0.5}, {0, 1}, {0, 1, 0}};
    self.vertices[8] = (MyVertex){{0.5, 0.5, -0.5}, {1, 0}, {0, 1, 0}};
    self.vertices[9] = (MyVertex){{-0.5, 0.5, 0.5}, {0, 1}, {0, 1, 0}};
    self.vertices[10] = (MyVertex){{0.5, 0.5, -0.5}, {1, 0}, {0, 1, 0}};
    self.vertices[11] = (MyVertex){{-0.5, 0.5, -0.5}, {0, 0}, {0, 1, 0}};

    // 下面
    self.vertices[12] = (MyVertex){{0.5, -0.5, 0.5}, {1, 1}, {0, -1, 0}};
    self.vertices[13] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 1}, {0, -1, 0}};
    self.vertices[14] = (MyVertex){{0.5, -0.5, -0.5}, {1, 0}, {0, -1, 0}};
    self.vertices[15] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 1}, {0, -1, 0}};
    self.vertices[16] = (MyVertex){{0.5, -0.5, -0.5}, {1, 0}, {0, -1, 0}};
    self.vertices[17] = (MyVertex){{-0.5, -0.5, -0.5}, {0, 0}, {0, -1, 0}};

    // 左面
    self.vertices[18] = (MyVertex){{-0.5, 0.5, 0.5}, {1, 1}, {-1, 0, 0}};
    self.vertices[19] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 1}, {-1, 0, 0}};
    self.vertices[20] = (MyVertex){{-0.5, 0.5, -0.5}, {1, 0}, {-1, 0, 0}};
    self.vertices[21] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 1}, {-1, 0, 0}};
    self.vertices[22] = (MyVertex){{-0.5, 0.5, -0.5}, {1, 0}, {-1, 0, 0}};
    self.vertices[23] = (MyVertex){{-0.5, -0.5, -0.5}, {0, 0}, {-1, 0, 0}};

    // 右面
    self.vertices[24] = (MyVertex){{0.5, 0.5, 0.5}, {1, 1}, {1, 0, 0}};
    self.vertices[25] = (MyVertex){{0.5, -0.5, 0.5}, {0, 1}, {1, 0, 0}};
    self.vertices[26] = (MyVertex){{0.5, 0.5, -0.5}, {1, 0}, {1, 0, 0}};
    self.vertices[27] = (MyVertex){{0.5, -0.5, 0.5}, {0, 1}, {1, 0, 0}};
    self.vertices[28] = (MyVertex){{0.5, 0.5, -0.5}, {1, 0}, {1, 0, 0}};
    self.vertices[29] = (MyVertex){{0.5, -0.5, -0.5}, {0, 0}, {1, 0, 0}};

    // 后面
    self.vertices[30] = (MyVertex){{-0.5, 0.5, -0.5}, {0, 1}, {0, 0, -1}};
    self.vertices[31] = (MyVertex){{-0.5, -0.5, -0.5}, {0, 0}, {0, 0, -1}};
    self.vertices[32] = (MyVertex){{0.5, 0.5, -0.5}, {1, 1}, {0, 0, -1}};
    self.vertices[33] = (MyVertex){{-0.5, -0.5, -0.5}, {0, 0}, {0, 0, -1}};
    self.vertices[34] = (MyVertex){{0.5, 0.5, -0.5}, {1, 1}, {0, 0, -1}};
    self.vertices[35] = (MyVertex){{0.5, -0.5, -0.5}, {1, 0}, {0, 0, -1}};

    //开辟顶点缓存区
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    GLsizeiptr bufferSizeBytes = sizeof(MyVertex)*kCoordCount;
    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, self.vertices, GL_STATIC_DRAW);

    //顶点数据
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(MyVertex), NULL+ offsetof(MyVertex, positionCoord));

    //纹理数据
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(MyVertex), NULL+ offsetof(MyVertex, textureCoord));

    //法线数据
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(MyVertex), NULL+ offsetof(MyVertex, vnormal));


}
-(void)addCADisplayLink{
    //CADisplayLink 类似定时器,提供一个周期性调用。输入QuartzCore.frame中.
    //具体可以参考该博客 https://www.cnblogs.com/panyangjun/p/4421904.html
    self.angle = 0;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
#pragma mark -GLKViewDelegate
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //1.开启深度测试
    glEnable(GL_DEPTH_TEST);
    //2.清除颜色缓冲区&深度缓冲区
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //3.准备绘制
    [self.baseEffect prepareToDraw];
    //4.绘图
    glDrawArrays(GL_TRIANGLES, 0, kCoordCount);
}

#pragma mark - update
-(void)update{
    //1.计算旋转角度
    self.angle = (self.angle + 1) % 360;
    //2.修改baseEffect.transform.movelviewmatrix
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(self.angle), 0.3, 1, 0.7);
    //3.重新渲染
    [self.glkView display];
}


@end