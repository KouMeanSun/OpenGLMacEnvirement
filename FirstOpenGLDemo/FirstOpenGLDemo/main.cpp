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
#include "GLBatch.h"
#include "GLGeometryTransform.h"

#include <math.h>
#ifdef __APPLE__
#include <glut/glut.h>
#else
#define FREEGLUT_STATIC
#include <GL/glut.h>
#endif

GLBatch squareBatch;
GLShaderManager shaderManager;

GLfloat blockSize = 0.1f;
GLfloat vVerts[] = {
        -blockSize,-blockSize,0.0f,
        blockSize,-blockSize,0.0f,
        blockSize,blockSize,0.0f,
        -blockSize,blockSize,0.0f
};

GLfloat xPos = 0.0f;
GLfloat yPos = 0.0f;
//每次绘制，旋转5度
float yRot = 0.0f;

void SetupRC(){
    //1.初始化
    glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
    shaderManager.InitializeStockShaders();

    //2.加载三角形
    squareBatch.Begin(GL_TRIANGLE_FAN, 4);
    squareBatch.CopyVertexData3f(vVerts);
    squareBatch.End();
}

//移动 (移动只计算了x，y移动的距离，以及碰撞检测)
void SpecialKeys(int key,int x,int y){
    GLfloat stepSize = 0.025f;
    if(key == GLUT_KEY_UP){
        yPos += stepSize;
        yRot -= 5.0f;
    }
    if(key == GLUT_KEY_DOWN){
        yPos -= stepSize;
        yRot += 5.0f;
    }
    if(key == GLUT_KEY_LEFT){
        xPos -= stepSize;
        yRot += 5.0f;
    }
    if(key == GLUT_KEY_RIGHT){
        xPos += stepSize;
        yRot -= 5.0f;
    }
    // 碰撞检测
    if(xPos <(-1.0f + blockSize)){
        xPos = -1.0f + blockSize;
    }
    if(xPos> (1.0f-blockSize)){
        xPos = 1.0f-blockSize;
    }
    if(yPos < (-1.0f+blockSize)){
        yPos = -1.0f+blockSize;
    }
    if(yPos > (1.0f - blockSize)){
        yPos = 1.0f -blockSize;
    }
    glutPostRedisplay();
}

void RenderScence(void){
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    GLfloat  vRed[] = {1.0f,0.0f,0.0f,1.0f};
    M3DMatrix44f mFinalTransform ,mTranslationMatrix,mRotationMatrix;

    // 平移 xPos，yPos
    m3dTranslationMatrix44(mTranslationMatrix, xPos, yPos, 0.0f);


    m3dRotationMatrix44(mRotationMatrix, m3dDegToRad(yRot), 0.0f, 0.0f, 1.0f);

    //将旋转和平移的结果合并到mFinalTransform 中
    m3dMatrixMultiply44(mFinalTransform, mTranslationMatrix, mRotationMatrix);

    //将矩阵结果提交到固定着色器(平面着色器)中.
    shaderManager.UseStockShader(GLT_SHADER_FLAT,mFinalTransform,vRed);
    squareBatch.Draw();

    //执行交换缓冲区
    glutSwapBuffers();
}

void ChangeSize(int w,int h){
    glViewport(0, 0, w, h);
}

int main(int argc,char* argv[]){
    gltSetWorkingDirectory(argv[0]);

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    glutInitWindowSize(600, 600);
    glutCreateWindow("Move box with arrow keys");

    GLenum err = glewInit();
    if(GLEW_OK != err){
        fprintf(stderr, "Error:%s\n", glewGetErrorString(err));
    }

    glutReshapeFunc(ChangeSize);
    glutDisplayFunc(RenderScence);
    glutSpecialFunc(SpecialKeys);

    SetupRC();

    glutMainLoop();
    return 0;
}









