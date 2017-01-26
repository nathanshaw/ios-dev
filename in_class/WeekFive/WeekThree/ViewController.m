//
//  ViewController.m
//  WeekThree
//
//  Created by Spencer Salazar on 2/8/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import "ViewController.h"
#import "AudioManager.h"

@interface ViewController ()
{
    IBOutlet UIButton *_joyButton;
    IBOutlet UIButton *_fireButton;
    IBOutlet UIButton *_100Button;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)numButtonDown:(id)sender
{
    NSLog(@"num button: %i", (int)[sender tag]);
    
    UIButton *button = (UIButton *) sender;
    
    NSArray *subviews = self.view.subviews;
}

- (IBAction)buttonDown:(id)sender
{
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setGain:1.0];
    
    if(sender == _joyButton)
    {
        NSLog(@"joy button");
        [_joyButton setBackgroundColor:[UIColor blackColor]];
    }
    else if(sender == _fireButton)
    {
        NSLog(@"fireeee");
    }
    else if(sender == _100Button)
    {
        NSLog(@"100 100 100");
    }
}

- (IBAction)buttonUp:(id)sender
{
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setGain:0.0];
    
    if(sender == _joyButton)
    {
        NSLog(@"joy button");
        [_joyButton setBackgroundColor:[UIColor clearColor]];
    }
}

- (IBAction)slider:(id)sender
{
    UISlider *theSlider = (UISlider *)sender;
    float sliderValue = [theSlider value];
    
    AudioManager *audioManager = [AudioManager instance];
    [audioManager setFrequency:sliderValue];
}

@end
