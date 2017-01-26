//
//  ViewController.m
//  WeekSiete
//
//  Created by Spencer Salazar on 3/5/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import "ViewController.h"
#import "ShaderHelper.h"


GLuint _shaderProgram;
GLuint _mvpUniform;
GLuint _normalMatrixUniform;

GLKMatrix4;
GLKMatrix4;

class Rectangle
{
public:
    Rectangle(float width, float height);
    void update();
    void draw();
    
    void setColor(float _r, float _g, float _b, float _a) {
        r = _r;
        g = _g;
        b = _b;
        a = _a;
    }
    
    void setPosition(float _x, float _y, float _z) {
        x = _x;
        y = _y;
        z = _z;
    }
    
private:
    float r, g, b, a;
    float x, y, z;
    GLfloat geo[4*2];
};

Rectangle::Rectangle(float width, float height)
{
    r = g = b = a = 1;
    x = y = z = 0;
    // lower left corner
    geo[0] = -width/2.0; geo[1] = -height/2.0;
   
    geo[2] = width/2.0; geo[3] = -height/2.0;
   
    geo[4] = -width/2.0; geo[5] = height/2.0;

    geo[6] = width/2.0; geo[7] = height/2.0;
}

void Rectangle::update() {
    
}

void Rectangle::draw() {
    
}


@interface ViewController ()
{
    GLuint _shaderProgram;
    GLuint _mvpUniform;
    GLuint _normalMatrixUniform;
    
    float _rotation;
}

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
    _shaderProgram = createProgramWithDefaultAttributes(@"Shader.vsh", @"Shader.fsh");
    _mvpUniform = glGetUniformLocation(_shaderProgram, "modelViewProjectionMatrix");
    _normalMatrixUniform = glGetUniformLocation(_shaderProgram, "normalMatrix");
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_DEPTH_TEST);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

// update
- (void)update
{
    _rotation += 1;
}

// render
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.1, 0.1, 0.1, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    // set up projection matrix
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projection = GLKMatrix4MakeFrustum(-1, 1, -1/aspect, 1/aspect, 0.1, 100);
    GLKMatrix4 modelView = GLKMatrix4Identity;
    
    glUseProgram(_shaderProgram);
    
    
    //GLKMatrix4Translate(GLKMatrix4 matrix, float tx, float ty, float tz)
    //GLKMatrix4Scale(GLKMatrix4 matrix, float sx, float sy, float sz)
    GLKMatrix4 blueyMatrix = GLKMatrix4Rotate(modelView, _rotation, 0, 0, 1);
    
    float z = -0.1001;
    GLfloat vertices[] = {
        -0.5, -0.5, z,
         0.5, -0.5, z,
        -0.5,  0.5, z,
         0.5,  0.5, z
    };
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttrib4f(GLKVertexAttribColor, 0.1, 0.1, 0.9, 1.0);
    glVertexAttrib3f(GLKVertexAttribNormal, 0, 0, 1);
    
    GLKMatrix4 mvp = GLKMatrix4Multiply(projection, blueyMatrix);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(blueyMatrix), NULL);
    glUniformMatrix4fv(_mvpUniform, 1, GL_FALSE, mvp.m);
    glUniformMatrix3fv(_normalMatrixUniform, 1, GL_FALSE, normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end
