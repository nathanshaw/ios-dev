//
//  ViewController.m
//  Week1
//
//  Created by Spencer Salazar on 1/25/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)sliderValueChanged:(UISlider *)slider
{
//    UISlider *slider = (UISlider *)sender;
    float f = [slider value];
    NSLog(@"the value of the slider is: %f", f);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gainOn:(id)sender {
    gain = 1;
}

- (IBAction)gainOff:(id)sender {
    gain = 0;
}

- (IBAction)sliderChanged:(id)sender {
    freq = 220+[(UISlider *)sender value]*220;
}

@end
