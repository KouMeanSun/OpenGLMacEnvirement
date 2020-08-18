//
//  ViewController.m
//  OpenGLESDemo
//
//  Created by 高明阳 on 2020/7/25.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "ViewController.h"
#import <Photos/Photos.h>

#import "LongLegView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<LongLegViewViewDelegate>

@property (nonatomic,strong) LongLegView *springView;

@property (nonatomic,strong)UIButton *saveBottom;
@property (nonatomic,strong)UISlider *saveSlider;

//top按钮
@property ( nonatomic,strong)  UIButton *topButton;
//bottom按钮
@property ( nonatomic,strong)  UIButton *bottomButton;

//topline
@property (nonatomic,strong)  UIView *topLine;
//bottomline
@property (nonatomic,strong)  UIView *bottomLine;

//遮罩层
@property (nonatomic,strong)  UIView *mask;

// 上方横线距离纹理顶部的高度
@property (nonatomic, assign) CGFloat currentTop;
// 下方横线距离纹理顶部的高度
@property (nonatomic, assign) CGFloat currentBottom;

@property (nonatomic,assign) CGFloat topLineSpace;
@property (nonatomic,assign) CGFloat bottomLineSpace;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //自动计算滚动视图的内容边距
    self.automaticallyAdjustsScrollViewInsets = NO; //不自动计算
    [self commonInit];
}

-(void)commonInit{
    self.title = @"OpenGLES练习";
   //设置背景色
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    
}

-(void)initViews{
    self.saveBottom = [UIButton buttonWithType:UIButtonTypeSystem];
    self.saveBottom.backgroundColor = [UIColor systemPinkColor];
    [self.saveBottom setTitle:@"save" forState:UIControlStateNormal];
    self.saveBottom.frame = CGRectMake(10, SCREEN_HEIGHT - 60, 50, 50);
    [self.saveBottom addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBottom];
    
    self.saveSlider = [[UISlider alloc] init];
    self.saveSlider.backgroundColor = [UIColor systemPinkColor];
    self.saveSlider.frame = CGRectMake(70, SCREEN_HEIGHT - 60, SCREEN_WIDTH-80, 50);
    [self.view addSubview:self.saveSlider];
    
    [self.saveSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [self.saveSlider addTarget:self action:@selector(sliderDidTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.saveSlider addTarget:self action:@selector(sliderDidTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveSlider addTarget:self action:@selector(sliderDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    
    self.topButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.topButton.backgroundColor = [UIColor systemPinkColor];
        [self.topButton setTitle:@"top" forState:UIControlStateNormal];
        self.topButton.frame = CGRectMake(SCREEN_WIDTH-70, 70, 50, 50);
        
    //    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *topPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanTop:)];
        [self.topButton addGestureRecognizer:topPan];
        
        self.bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.bottomButton.backgroundColor = [UIColor systemPinkColor];
        [self.bottomButton setTitle:@"bottom" forState:UIControlStateNormal];
        self.bottomButton.frame = CGRectMake(SCREEN_WIDTH-70, 130, 50, 50);
       
    //    [self.bottomButton addTarget:self action:@selector(buttonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *bottomPan = [[UIPanGestureRecognizer alloc]
        initWithTarget:self
        action:@selector(actionPanBottom:)];
        [self.bottomButton addGestureRecognizer:bottomPan];
        
        self.topLine = [[UIView alloc] initWithFrame:CGRectMake(10, 93, SCREEN_WIDTH-80, 1)];
        self.topLine.backgroundColor = [UIColor greenColor];
       
        
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, 153, SCREEN_WIDTH-80, 1)];
        self.bottomLine.backgroundColor = [UIColor greenColor];
       
        
        self.mask = [[UIView alloc] initWithFrame:CGRectMake(10, 94, SCREEN_WIDTH-80, 153-94)];
        self.mask.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.2f];
       
    
    self.springView = [[LongLegView alloc] initWithFrame:CGRectMake(0, 93, SCREEN_WIDTH, SCREEN_HEIGHT - 60-93)];
    [self.view addSubview:self.springView];
    //2. 设置SpringView 代理方法;
    self.springView.springDelegate = self;
    //3. 设计SpringView 上加载的图片(可修改~)
    [self.springView updateImage:[UIImage imageNamed:@"ym3.jpg"]];
    //4. 设置初始化的拉伸区域
    [self setupStretchArea];
    
    
    [self.view addSubview:self.topLine];
    [self.view addSubview:self.bottomLine];
    [self.view addSubview:self.mask];
    [self.view addSubview:self.topButton];
    [self.view addSubview:self.bottomButton];
}
// 设置初始的拉伸区域位置
- (void)setupStretchArea {
   
    //currentTop/currentBottom 是比例值; 初始化比例是25%~75%
    self.currentTop = 0.25f;
    self.currentBottom = 0.75f;
  
    // 初始纹理占 View 的比例
    CGFloat textureOriginHeight = 0.7f;

    self.topLineSpace = self.currentTop * self.springView.bounds.size.height;
    NSLog(@"topLineSpace %f",self.topLineSpace);
    CGFloat marginImgTop = self.topLineSpace + self.springView.frame.origin.y;
    
    CGRect toplineFrame = self.topLine.frame;
    self.topLine.frame = CGRectMake(toplineFrame.origin.x, marginImgTop, toplineFrame.size.width, toplineFrame.size.height);
    
    self.bottomLineSpace = ((self.currentBottom * textureOriginHeight) + (1 - textureOriginHeight) / 2) * self.springView.bounds.size.height;
    NSLog(@"bottomLineSpace %f",self.bottomLineSpace);
    CGFloat marginImgBottom = self.bottomLineSpace + self.springView.frame.origin.y;
    
    CGRect bottomLineFrame = self.bottomLine.frame;
    self.bottomLine.frame = CGRectMake(bottomLineFrame.origin.x, marginImgBottom, bottomLineFrame.size.width, bottomLineFrame.size.height);
    
    CGRect topButtomFrame =  self.topButton.frame;
    self.topButton.frame = CGRectMake(topButtomFrame.origin.x, marginImgTop-24, topButtomFrame.size.width, topButtomFrame.size.height);
    
    CGRect bottomBtnFrame = self.bottomButton.frame;
    self.bottomButton.frame = CGRectMake(bottomBtnFrame.origin.x, marginImgBottom-24, bottomBtnFrame.size.width, bottomBtnFrame.size.height);
    
    CGRect maskFrame = self.mask.frame;
    self.mask.frame = CGRectMake(maskFrame.origin.x, marginImgTop, maskFrame.size.width, marginImgBottom - marginImgTop);
}
- (CGFloat)stretchAreaYWithLineSpace:(CGFloat)lineSpace {
    
    return (lineSpace / self.springView.bounds.size.height - self.springView.textureTopY) / self.springView.textureHeight;
}
-(void)buttonBtnClick:(UIButton *)btn{
    NSLog(@"点击了 bottomClick");
}
-(void)topButtonClick:(UIButton *)btn{
    NSLog(@"点击了 topClick");
}
#pragma mark - Action
//当调用buttopTop按钮时,界面变换(需要重新子view的位置以及约束信息)
- (void)actionPanTop:(UIPanGestureRecognizer *)pan {
   
    //1.判断springView是否发生改变
    if ([self.springView hasChange]) {
        //2.给springView 更新纹理
        [self.springView updateTexture];
        //3.重置滑杆位置(因为此时相当于对一个张新图重新进行拉伸处理~)
        self.saveSlider.value = 0.5f;
    }
    
    //修改约束信息;
    CGPoint translation = [pan translationInView:self.view];
    NSLog(@"------actionPanTop translation:%f",translation.y);
    //修改topLineSpace的预算条件;
    self.topLineSpace = MIN(self.topLineSpace + translation.y,
                                     self.bottomLineSpace);
    
    //纹理Top = springView的height * textureTopY
    //606
    CGFloat textureTop = self.springView.bounds.size.height * self.springView.textureTopY;
//    NSLog(@"%f,%f",self.springView.bounds.size.height,self.springView.textureTopY);
//    NSLog(@"%f",textureTop);
    
    //设置topLineSpace的约束常量;
    self.topLineSpace = MAX(self.topLineSpace, textureTop);
    //将pan移动到view的Zero位置;
    [pan setTranslation:CGPointZero inView:self.view];
    
    //计算移动了滑块后的currentTop和currentBottom
//    self.currentTop = [self stretchAreaYWithLineSpace:self.topLineSpace.constant];
//    self.currentBottom = [self stretchAreaYWithLineSpace:self.bottomLineSpace.constant];
}

-(void)updateControlViews{
       CGFloat marginImgTop = self.topLineSpace + self.springView.frame.origin.y;
       
       CGRect toplineFrame = self.topLine.frame;
       self.topLine.frame = CGRectMake(toplineFrame.origin.x, marginImgTop, toplineFrame.size.width, toplineFrame.size.height);
       
       CGFloat marginImgBottom = self.bottomLineSpace + self.springView.frame.origin.y;
       
       CGRect bottomLineFrame = self.bottomLine.frame;
       self.bottomLine.frame = CGRectMake(bottomLineFrame.origin.x, marginImgBottom, bottomLineFrame.size.width, bottomLineFrame.size.height);
       
//       CGRect topButtomFrame =  self.topButton.frame;
//       self.topButton.frame = CGRectMake(topButtomFrame.origin.x, marginImgTop-24, topButtomFrame.size.width, topButtomFrame.size.height);
//
//       CGRect bottomBtnFrame = self.bottomButton.frame;
//       self.bottomButton.frame = CGRectMake(bottomBtnFrame.origin.x, marginImgBottom-24, bottomBtnFrame.size.width, bottomBtnFrame.size.height);
       
       CGRect maskFrame = self.mask.frame;
       self.mask.frame = CGRectMake(maskFrame.origin.x, marginImgTop, maskFrame.size.width, marginImgBottom - marginImgTop);
}
//与buttopTop 按钮事件所发生的内容几乎一样,不做详细注释了.
- (void)actionPanBottom:(UIPanGestureRecognizer *)pan {
    if ([self.springView hasChange]) {
        [self.springView updateTexture];
        self.saveSlider.value = 0.5f;
    }
    
    CGPoint translation = [pan translationInView:self.view];
//    self.bottomLineSpace.constant = MAX(self.bottomLineSpace.constant + translation.y,
//                                        self.topLineSpace.constant);
    CGFloat textureBottom = self.springView.bounds.size.height * self.springView.textureBottomY;
//    self.bottomLineSpace.constant = MIN(self.bottomLineSpace.constant, textureBottom);
    [pan setTranslation:CGPointZero inView:self.view];
    
//    self.currentTop = [self stretchAreaYWithLineSpace:self.topLineSpace.constant];
//    self.currentBottom = [self stretchAreaYWithLineSpace:self.bottomLineSpace.constant];
    
    NSLog(@"-------actionPanBottom");
}
-(void)sliderValueDidChanged:(UISlider *)sender{
//    NSLog(@"触发了 sliderValueDidChanged");
    
       //获取图片的中间拉伸区域高度;
       //获取图片的中间拉伸区域高度: (currentBottom - currentTop)*sliderValue + 0.5;
       CGFloat newHeight = (self.currentBottom - self.currentTop) * ((sender.value) + 0.5);
        NSLog(@"%f",sender.value);
       NSLog(@"%f",newHeight);
    
    //将currentTop和currentBottom以及新图片的高度传给springView,进行拉伸操作;
    [self.springView stretchingFromStartY:self.currentTop
                                   toEndY:self.currentBottom
                            withNewHeight:newHeight];
}
- (void)sliderDidTouchDown:(id)sender {
  NSLog(@"触发了 sliderDidTouchDown");
    [self setViewsHidden:YES];
}
- (void)sliderDidTouchUp:(id)sender {
   NSLog(@"触发了 sliderDidTouchUp");
     [self setViewsHidden:NO];
}

-(void)saveAction:(UIButton *)sender{
    NSLog(@"点击了保存按钮");
    //1.获取处理后的图片;
    UIImage *image = [self.springView createResult];
    //2.将图片存储到系统相册中;
    [self saveImage:image];
}


// 保存图片到相册
- (void)saveImage:(UIImage *)image {
    //将图片通过PHPhotoLibrary保存到系统相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@ 图片已保存到相册", success, error);
    }];
}
//相关控件隐藏功能
- (void)setViewsHidden:(BOOL)hidden {
    self.topLine.hidden = hidden;
    self.bottomLine.hidden = hidden;
    self.topButton.hidden = hidden;
    self.bottomButton.hidden = hidden;
    self.mask.hidden = hidden;
}
#pragma mark - LongLegViewViewDelegate
//代理方法(SpringView拉伸区域修改)
- (void)springViewStretchAreaDidChanged:(LongLegView *)springView {
    
    //拉伸结束后,更新topY,bottomY,topLineSpace,bottomLineSpace 位置;
    CGFloat topY = self.springView.bounds.size.height * self.springView.stretchAreaTopY;
    CGFloat bottomY = self.springView.bounds.size.height * self.springView.stretchAreaBottomY;
//    self.topLineSpace.constant = topY;
//    self.bottomLineSpace.constant = bottomY;
}
@end
