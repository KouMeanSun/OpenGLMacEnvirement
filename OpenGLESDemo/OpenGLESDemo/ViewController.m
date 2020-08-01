//
//  ViewController.m
//  OpenGLESDemo
//
//  Created by 高明阳 on 2020/7/25.
//  Copyright © 2020 高明阳. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "ViewController.h"
#import "MyView.h"
#import "TriangleViewController.h"

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
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(nextVCClick:)];
    self.navigationItem.rightBarButtonItem = nextBtn;
    self.myView = [[MyView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.myView];
}

-(void)nextVCClick:(UIBarButtonItem *)btn{
    [self.navigationController pushViewController:[TriangleViewController  new
    ] animated:YES];
}
@end
