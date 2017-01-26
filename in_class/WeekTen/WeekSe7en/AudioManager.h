//
//  AudioManager.h
//  WeekThree
//
//  Created by Spencer Salazar on 2/8/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AudioManager : NSObject

+ (instancetype)instance;

- (void)startAudio;

- (void)setGain:(float)gain;

- (void)createSawForTouch:(UITouch *)t;
- (void)setFreq:(float)freq forSawTouch:(UITouch *)t;
- (void)setGain:(float)gain forSawTouch:(UITouch *)t;
- (void)removeSawForTouch:(UITouch *)t;

- (float *)lastAudioBuffer;
- (int)lastAudioBufferSize;

@end


