//
//  ViewController.m
//  OpenGLESDemo
//
//  Created by 高明阳 on 2020/7/25.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import "ViewController.h"
#import "MyView.h"

@interface ViewController ()
@property (nonatomic, strong)MyView *myView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(void)commonInit{
    self.title = @"OpenGLES练习";
//    self.view.backgroundColor = [UIColor greenColor];
//    self.myView = (MyView *)self.view;
    self.myView = [[MyView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.myView];
}


@end
