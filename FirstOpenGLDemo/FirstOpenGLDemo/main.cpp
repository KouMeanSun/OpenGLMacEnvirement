//
//  main.cpp
//  FirstOpenGLDemo
//
//  Created by 高明阳 on 2020/7/4.
//  Copyright © 2020 高明阳. All rights reserved.
//

#include "GLTools.h"
#include "GLMatrixStack.h"
#include "GLFrame.h"
#include "GLFrustum.h"
#include "GLGeometryTransform.h"

#include <math.h>
#ifdef __APPLE__
#include <glut/glut.h>
#else
#define FREEGLUT_STATIC
#include <GL/glut.h>
#endif

GLShaderManager     mShaderManager;
//设置观察者帧，作为相机
GLFrame             mCameraFrame;
//绘制甜甜圈的批次类
GLTriangleBatch     mTorusBatch;
//使用GLFrustum类来设置透视投影
GLFrustum           mFrustum;
//投影矩阵
GLMatrixStack       mProjectionMatrix;
//几何图形渲染管线
GLGeometryTransform mTransformPipeline;
//模型视图矩阵
GLMatrixStack       mModelViewMatrix;

//窗口改变
void ChangeSize(int w, int h){
    //1.防止 h变为0
    if(h == 0){
        h = 1;
    }
    //2.设置视窗尺寸
    glViewport(0, 0, w, h);
    //3.设置透视模式，初始化其透视矩阵
    mFrustum.SetPerspective(35.0f, float(w)/float(h), 1.0f, 100.0f);
    //4.把透视矩阵加载到透视矩阵堆栈中
    mProjectionMatrix.LoadMatrix(mFrustum.GetProjectionMatrix());
    //5.初始化渲染管线
    mTransformPipeline.SetMatrixStacks(mModelViewMatrix, mProjectionMatrix);
}

//渲染场景
void RenderScene(){
    //1.清除窗口和深度缓冲区
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //2.开启正背面剔除功能 OpenGL ES
    glEnable(GL_CULL_FACE);
    //3.把摄像机矩阵压入模型矩阵中
    mModelViewMatrix.PushMatrix(mCameraFrame);
    //4.设置绘图颜色
    GLfloat vRed[] = {1.0f,0.0f,0.0f,1.0f};
    //5.使用平面着色器
//     mShaderManager.UseStockShader(GLT_SHADER_FLAT, mTransformPipeline.GetModelViewProjectionMatrix(), vRed);
    //使用光源着色器
    mShaderManager.UseStockShader(GLT_SHADER_DEFAULT_LIGHT,mTransformPipeline.GetModelViewMatrix(),mTransformPipeline.GetProjectionMatrix(),vRed);
    
    //6.绘制
    mTorusBatch.Draw();
    //7.出栈 绘制完成恢复
    mModelViewMatrix.PopMatrix();
    //8.交换缓冲区
    glutSwapBuffers();
}
void SetupRC(){
    //1.设置背景色
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f );
    //2.初始化着色器管理器
    mShaderManager.InitializeStockShaders();
    //3.将相机向后移动7个单位,可以理解为 肉眼和物体之间的距离
    mCameraFrame.MoveForward(7.0);
    //4.创建一个甜甜圈
    //void gltMakeTorus(GLTriangleBatch& torusBatch, GLfloat majorRadius, GLfloat minorRadius, GLint numMajor, GLint numMinor);
    //参数1：GLTriangleBatch 容器帮助类
    //参数2：外边缘半径
    //参数3：内边缘半径
    //参数4、5：主半径和从半径的细分单元数量
    gltMakeTorus(mTorusBatch, 1.0f, 0.3f,52, 26);
    //5.点的大小（方便点填充时，肉眼观察）;
    glPointSize(4.0f);
    
}
//键位设置，通过不同的键位对其进行设置
//控制Camera的移动，从而改变视口
void SpecialKeys(int key, int x, int y)
{
    //1.判断方向
    if(key == GLUT_KEY_UP)
        //2.根据方向调整观察者位置
        mCameraFrame.RotateWorld(m3dDegToRad(-5.0), 1.0f, 0.0f, 0.0f);
    
    if(key == GLUT_KEY_DOWN)
        mCameraFrame.RotateWorld(m3dDegToRad(5.0), 1.0f, 0.0f, 0.0f);
    
    if(key == GLUT_KEY_LEFT)
        mCameraFrame.RotateWorld(m3dDegToRad(-5.0), 0.0f, 1.0f, 0.0f);
    
    if(key == GLUT_KEY_RIGHT)
        mCameraFrame.RotateWorld(m3dDegToRad(5.0), 0.0f, 1.0f, 0.0f);
    
    //3.重新刷新
    glutPostRedisplay();
}
/// 初始化 OpenGL
/// @param arg 入参
int  initOpenGL(int argc, char* argv[]){
    gltSetWorkingDirectory(argv[0]);
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    glutInitWindowSize(800, 600);
    glutCreateWindow("几何测试程序");
    ///注册函数
    glutReshapeFunc(ChangeSize);
    glutSpecialFunc(SpecialKeys);
    glutDisplayFunc(RenderScene);
    
    //初始化检查
    GLenum err = glewInit();
    if(GLEW_OK != err){
        fprintf(stderr, "GLEW 错误 %s\n",glewGetErrorString(err));
        return 1;
    }
    
    //开始设置
    SetupRC();
    glutMainLoop();
    return 0;
}

int main(int argc, char* argv[])
{
   return  initOpenGL(argc,argv);
    
}
