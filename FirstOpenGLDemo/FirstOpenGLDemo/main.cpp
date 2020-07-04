//
//  main.cpp
//  FirstOpenGLDemo
//
//  Created by 高明阳 on 2020/7/4.
//  Copyright © 2020 高明阳. All rights reserved.
//

#include "GLTools.h"
#include <glut/glut.h>


GLBatch triangleBatch;
GLShaderManager shaderManager;

void ChangeSize(int w,int h){
    glViewport(0, 0, w, h);
}

void SetupRC(){
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    shaderManager.InitializeStockShaders();
    GLfloat vVerts[] = {
        -0.5f,0.0f,0.0f,
        0.5f,0.0f,0.0f,
        0.0f,0.5f,0.0f,
        
    };
    triangleBatch.Begin(GL_TRIANGLES, 3);
    triangleBatch.CopyVertexData3f(vVerts);
    triangleBatch.End();
}

void RenderScene(void){
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);
    GLfloat vRed[] = {1.0f,0.0f,0.0f,1.0f};
    
    shaderManager.UseStockShader(GLT_SHADER_IDENTITY,vRed);
    
    triangleBatch.Draw();
    
    glutSwapBuffers();
    
}
int main(int argc,  char * argv[]) {
//    // insert code here...
//    std::cout << "Hello, World!\n";
    gltSetWorkingDirectory(argv[0]);
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE|GLUT_RGBA|GLUT_DEPTH|GLUT_STENCIL);
    glutInitWindowSize(800, 600);
    
    glutCreateWindow("三角形");
    
    ///注册回调函数，函数都是自定义的
    glutReshapeFunc(ChangeSize);
    glutDisplayFunc(RenderScene);
    /// end 注册回调函数
    
    //驱动程序初始化过程中没有出现任何问题
    GLenum err = glewInit();
    
    if(GLEW_OK != err){
        fprintf(stderr, "glew error :%s \n",glewGetErrorString(err));
        return 1;
    }
    
    //调用 设置
    SetupRC();
    
    glutMainLoop();
    
    return 0;
}
