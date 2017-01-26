//
//  ViewController.m
//  WeekSiete
//
//  Created by Spencer Salazar on 3/5/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import "ViewController.h"
#import "ShaderHelper.h"
#import "Texture.h"
#import "AudioManager.h"
#import "Random.h"

#import <map>
#import <list>
#import <vector>

// global variables for now
// TODO: put into some sort of object state
GLuint _shaderProgram;
GLuint _mvpUniform;
GLuint _normalMatrixUniform;

GLuint _texShaderProgram;
GLuint _texMvpUniform;
GLuint _texNormalMatrixUniform;
GLuint _texTexUniform;

GLKMatrix4 projection;
GLKMatrix4 modelView;



class RenderObject
{
public:
    virtual void update() = 0;
    virtual void draw() = 0;
    
    virtual bool done() { return true; }
};



class Rectangle : public RenderObject
{
public:
    Rectangle();
    Rectangle(float width, float height);
    
    virtual void update();
    virtual void draw();
    
    void setColor(float _r, float _g, float _b, float _a)
    {
        r = _r;
        g = _g;
        b = _b;
        a = _a;
    }
    
    void setPosition(float _x, float _y, float _z)
    {
        x = _x;
        y = _y;
        z = _z;
    }
    
private:
    float r, g, b, a;
    float x, y, z;
    
    GLfloat geo[4*2];
};

Rectangle::Rectangle()
{
    float width = 1;
    float height = 1;
    
    r = g = b = a = 1;
    x = y = z = 0;
    
    // lower left corner
    geo[0] = -width/2.0; geo[1] = -height/2.0;
    // lower right corner
    geo[2] =  width/2.0; geo[3] = -height/2.0;
    // top left corner
    geo[4] = -width/2.0; geo[5] =  height/2.0;
    // upper right corner
    geo[6] =  width/2.0; geo[7] =  height/2.0;
}

Rectangle::Rectangle(float width, float height)
{
    r = g = b = a = 1;
    x = y = z = 0;
    
    // lower left corner
    geo[0] = -width/2.0; geo[1] = -height/2.0;
    // lower right corner
    geo[2] =  width/2.0; geo[3] = -height/2.0;
    // top left corner
    geo[4] = -width/2.0; geo[5] =  height/2.0;
    // upper right corner
    geo[6] =  width/2.0; geo[7] =  height/2.0;
}

void Rectangle::update()
{
    
}

void Rectangle::draw()
{
    glUseProgram(_shaderProgram);
    
    //GLKMatrix4Translate(GLKMatrix4 matrix, float tx, float ty, float tz)
    //GLKMatrix4Scale(GLKMatrix4 matrix, float sx, float sy, float sz)
    GLKMatrix4 myModelView = GLKMatrix4Translate(modelView, x, y, z);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, geo);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttrib4f(GLKVertexAttribColor, r, g, b, a);
    glVertexAttrib3f(GLKVertexAttribNormal, 0, 0, 1);
    
    GLKMatrix4 mvp = GLKMatrix4Multiply(projection, myModelView);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(myModelView), NULL);
    glUniformMatrix4fv(_mvpUniform, 1, GL_FALSE, mvp.m);
    glUniformMatrix3fv(_normalMatrixUniform, 1, GL_FALSE, normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}


class Pizza : public RenderObject
{
public:
    Pizza();
    Pizza(float width, float height);
    
    virtual void update();
    virtual void draw();
    
    void fadeOut()
    {
        isFadingOut = true;
    }
    
    virtual bool done()
    {
        if(a < 0.05) return true;
        else return false;
    }
    
    void setColor(float _r, float _g, float _b, float _a)
    {
        r = _r;
        g = _g;
        b = _b;
        a = _a;
    }
    
    void setPosition(float _x, float _y, float _z)
    {
        x = _x;
        y = _y;
        z = _z;
    }
    
    void setTexture(GLuint _tex)
    {
        tex = _tex;
    }
    
private:
    float r, g, b, a;
    float x, y, z;
    float rotation;
    bool isFadingOut;
    
    // geometry
    GLfloat geo[4*2];
    // texture coordinates
    GLfloat texcoord[4*2];
    // pointer to texture
    GLuint tex;
};

Pizza::Pizza()
{
    tex = loadOrRetrieveTexture(@"otter.png");
    
    isFadingOut = false;
    
    float width = 1;
    float height = 1;
    
    r = g = b = a = 1;
    x = y = z = 0;
    
    // lower left corner
    geo[0] = -width/2.0; geo[1] = -height/2.0;
    // lower right corner
    geo[2] =  width/2.0; geo[3] = -height/2.0;
    // top left corner
    geo[4] = -width/2.0; geo[5] =  height/2.0;
    // upper right corner
    geo[6] =  width/2.0; geo[7] =  height/2.0;
    
    rotation = 0;
}

Pizza::Pizza(float width, float height)
{
    tex = loadOrRetrieveTexture(@"flare.png");
    
    isFadingOut = false;
    
    r = g = b = a = 1;
    x = y = z = 0;
    
    // lower left corner
    geo[0] = -width/2.0; geo[1] = -height/2.0;
    // lower right corner
    geo[2] =  width/2.0; geo[3] = -height/2.0;
    // top left corner
    geo[4] = -width/2.0; geo[5] =  height/2.0;
    // upper right corner
    geo[6] =  width/2.0; geo[7] =  height/2.0;
    
    // set up texcoords / uv
    texcoord[0] = 0; texcoord[1] = 0;
    texcoord[2] = 1; texcoord[3] = 0;
    texcoord[4] = 0; texcoord[5] = 1;
    texcoord[6] = 1; texcoord[7] = 1;
    
    rotation = 0;
}

void Pizza::update()
{
    rotation += M_PI*2/60.0;
    if(isFadingOut)
        a *= 0.995;
}

void Pizza::draw()
{
    glUseProgram(_texShaderProgram);
    
    glEnable(GL_TEXTURE_2D);
    
    //GLKMatrix4Translate(GLKMatrix4 matrix, float tx, float ty, float tz)
    //GLKMatrix4Scale(GLKMatrix4 matrix, float sx, float sy, float sz)
    GLKMatrix4 myModelView = GLKMatrix4Translate(modelView, x, y, z);
    myModelView = GLKMatrix4Rotate(myModelView, rotation, 0, 0, 1);
    myModelView = GLKMatrix4Scale(myModelView, 1+0.25*sin(rotation), 1+0.25*sin(rotation), 1);

    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, geo);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, texcoord);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glBindTexture(GL_TEXTURE_2D, tex);
    glUniform1f(_texTexUniform, 0);
    
    glVertexAttrib4f(GLKVertexAttribColor, r, g, b, a);
//    glDisableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttrib3f(GLKVertexAttribNormal, 0, 0, 1);
    
    GLKMatrix4 mvp = GLKMatrix4Multiply(projection, myModelView);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(myModelView), NULL);
    glUniformMatrix4fv(_texMvpUniform, 1, GL_FALSE, mvp.m);
    glUniformMatrix3fv(_texNormalMatrixUniform, 1, GL_FALSE, normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}


#define WAVEFORM_GEO_SIZE 2048


@interface ViewController ()
{
    float _rotation;
    
    Pizza *myPizza;
    //std::list
    std::vector<RenderObject *> renderList;
    std::map<UITouch *, Pizza *> touchPizzaz;
    std::list<RenderObject *> removeList;
    
    GLKVector2 _waveformGeo[WAVEFORM_GEO_SIZE];
    GLKVector4 _waveformColor[WAVEFORM_GEO_SIZE];
}

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation ViewController

- (GLKVector3)worldCoordinateForScreenCoordinate:(CGPoint)p z:(GLfloat)z
{
    int viewport[] = { (int)self.view.bounds.origin.x, (int)self.view.bounds.origin.y,
        (int)self.view.bounds.size.width, (int)self.view.bounds.size.height };
    bool success;
    GLKVector3 vec = GLKMathUnproject(GLKVector3Make(p.x, self.view.bounds.size.height-p.y, z),
                                      modelView, projection, viewport, &success);
    
    return vec;
}

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
    
    _texShaderProgram = createProgramWithDefaultAttributes(@"TextureShader.vsh", @"TextureShader.fsh");
    _texMvpUniform = glGetUniformLocation(_texShaderProgram, "modelViewProjectionMatrix");
    _texNormalMatrixUniform = glGetUniformLocation(_texShaderProgram, "normalMatrix");
    _texTexUniform = glGetUniformLocation(_texShaderProgram, "tex");
        
    Rectangle *r;
    
//    r = new Rectangle(1, 1);
//    r->setPosition(0, 0, 0);
//    r->setColor(0.11, 0.9, 0.09, 0.8);
//    
//    renderList.push_back(r);
//    
//    r = new Rectangle(0.25, 1.75);
//    r->setPosition(0, 0.62, 0);
//    r->setColor(0.9, 0.4, 0.12, 0.8);
//    
//    renderList.push_back(r);
//    
//    r = new Rectangle(1.2, 0.8);
//    r->setPosition(0, -0.62, 0);
//    r->setColor(0.6, 0.1, 0.9, 0.8);
//    
//    renderList.push_back(r);
    
//    GLuint tex = loadOrRetrieveTexture(@"pizza.png");
//    
//    Pizza *p = new Pizza(1, 1);
//    p->setColor(0.9, 0.4, 0.12, 0.8);
//    p->setPosition(0, 0, 0);
//    p->setTexture(tex);
//    myPizza = p;
//    
//    renderList.push_back(p);
    
//    p = new Pizza(1, 1);
//    p->setPosition(-0.5, 0.2, 0);
//    p->setColor(0.11, 0.9, 0.09, 0.8);
//    p->setTexture(tex);
//
//    renderList.push_back(p);
//    
//    p = new Pizza(1, 1);
//    p->setPosition(1.0, -0.7, 0);
//    p->setColor(0.6, 0.1, 0.9, 0.8);
//    p->setTexture(tex);
//
//    renderList.push_back(p);
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
    _rotation += 0.01;
    
    for(auto r = renderList.begin(); r != renderList.end(); r++)
        (*r)->update();
    for(auto r = touchPizzaz.begin(); r != touchPizzaz.end(); r++)
    {
        Pizza *p = r->second;
        p->update();
    }
    
    for(auto r = removeList.begin(); r != removeList.end();)
    {
        RenderObject *ro = *r;
        ro->update();
        // advance iterator before potential remove
        r++;
        
        if(ro->done())
        {
            removeList.remove(ro);
            delete ro;
        }
    }
}

// render
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.1, 0.1, 0.1, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    // normal alpha blending
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // additive blending
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    
    // set up projection matrix
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    projection = GLKMatrix4MakeFrustum(-1, 1, -1/aspect, 1/aspect, 0.1, 100);
    modelView = GLKMatrix4Identity;
    modelView = GLKMatrix4Translate(modelView, 0, 0, -0.101);
    
    int audioFrameSize = [[AudioManager instance] lastAudioBufferSize];
    assert(audioFrameSize <= WAVEFORM_GEO_SIZE);
    
    float *audioFrame = [[AudioManager instance] lastAudioBuffer];
    
    for(int i = 0; i < audioFrameSize; i++)
    {
        float x = ((float)i)/audioFrameSize*2.0f-1.0f;
        _waveformGeo[i].x = x;
        _waveformGeo[i].y = audioFrame[i];
        
        _waveformColor[i].r = Random::unit();
        _waveformColor[i].g = Random::unit();
        _waveformColor[i].b = Random::unit();
        _waveformColor[i].a = 1;
    }
    
    // render waveform
    glUseProgram(_shaderProgram);
    
    glLineWidth(4.0);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, _waveformGeo);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
//    glVertexAttrib3f(GLKVertexAttribColor, Random::unit(), Random::unit(), Random::unit());
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_TRUE, 0, _waveformColor);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    GLKMatrix4 mvp = GLKMatrix4Multiply(projection, modelView);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelView), NULL);
    glUniformMatrix4fv(_mvpUniform, 1, GL_FALSE, mvp.m);
    glUniformMatrix3fv(_normalMatrixUniform, 1, GL_FALSE, normalMatrix.m);
    
    glDrawArrays(GL_LINE_LOOP, 0, audioFrameSize);
    
    
    for(auto r = renderList.begin(); r != renderList.end(); r++)
        (*r)->draw();
    for(auto r = touchPizzaz.begin(); r != touchPizzaz.end(); r++)
    {
        Pizza *p = r->second;
        p->draw();
    }
    
    for(auto r = removeList.begin(); r != removeList.end(); r++)
    {
        RenderObject *ro = *r;
        ro->draw();
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        // location in view coordinates (top left == (0,0)
        CGPoint position = [touch locationInView:self.view];
        GLKVector3 glPos = [self worldCoordinateForScreenCoordinate:position z:0];
        Pizza *p = new Pizza(0.5, 0.5);
        p->setPosition(glPos.x, glPos.y, glPos.z);
        //renderList.push_back(p);
        //renderList[0]
        
        touchPizzaz[touch] = p;
        
        [[AudioManager instance] createSawForTouch:touch];
        
        [[AudioManager instance] setFreq:100+position.x
                             forSawTouch:touch];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        // location in view coordinates (top left == (0,0)
        CGPoint position = [touch locationInView:self.view];
        GLKVector3 glPos = [self worldCoordinateForScreenCoordinate:position z:0];
        
        touchPizzaz[touch]->setPosition(glPos.x, glPos.y, glPos.z);
        
        [[AudioManager instance] setFreq:100+position.x
                             forSawTouch:touch];
        
        //myPizza->setPosition(glPos.x, glPos.y, glPos.z);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        removeList.push_back(touchPizzaz[touch]);
        touchPizzaz[touch]->fadeOut();
        touchPizzaz.erase(touch);
        
        [[AudioManager instance] removeSawForTouch:touch];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


@end
