//
//  ViewController.swift
//  MetalLearnDemo
//
//  Created by 高明阳 on 2020/8/20.
//  Copyright © 2020 高明阳. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    private var mtkView:MTKView?;
    private var myRender:MyRender?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit();
    }

    private func commonInit(){
        self.title = "Metal";
        self.initViews();
    }
    
    private func initViews(){
        //1.获取 mtkview
        self.mtkView = MTKView(frame: self.view.bounds);
        self.view.addSubview(self.mtkView!);
        //2.为 mtkview 设置MTLDeview(必须)
        //一个MTLDevice 对象就代表这着一个GPU,通常我们可以调用方法MTLCreateSystemDefaultDevice()来获取代表默认的GPU单个对象.
        self.mtkView?.device  = MTLCreateSystemDefaultDevice();
        //3.判断是否成功
        if(self.mtkView == nil){
            print("Metal is not supported on this device");
            return;
        }
        //4. 创建CCRenderer
        //分开你的渲染循环:
        //在我们开发Metal 程序时,将渲染循环分为自己创建的类,是非常有用的一种方式,使用单独的类,我们可以更好管理初始化Metal,以及Metal视图委托.
        self.myRender = MyRender(metalKitView: self.mtkView);
        //5.判断myRender是否创建成功
        if(self.myRender == nil){
            print("Render failed initialization");
            return;
        }
       //6.设置MTKView 的代理(由CCRender来实现MTKView 的代理方法)
        self.mtkView?.delegate = self.myRender;
        //7.视图可以根据视图属性上设置帧速率(指定时间来调用drawInMTKView方法--视图需要渲染时调用)
        self.mtkView?.preferredFramesPerSecond = 60;
    }

}

