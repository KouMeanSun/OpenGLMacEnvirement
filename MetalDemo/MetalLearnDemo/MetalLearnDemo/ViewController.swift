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
    private var renderer:MyImageRender?
    
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
        self.renderer = MyImageRender(metalKitView: self.mtkView!);
        if(self.renderer == nil){
            print("Render failed initializetion");
            return;
        }
        // Initialize our render with the view size
        self.renderer!.mtkView(self.mtkView!, drawableSizeWillChange: self.mtkView!.drawableSize);
        self.mtkView?.delegate = self.renderer;
    }

}

