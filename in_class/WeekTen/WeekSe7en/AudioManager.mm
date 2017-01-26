//
//  AudioManager.m
//  WeekThree
//
//  Created by Spencer Salazar on 2/8/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import "AudioManager.h"
#import "TheAmazingAudioEngine/TheAmazingAudioEngine.h"
#import "AudioGenerators.h"
#import <UIKit/UIKit.h>

#include "BlitSaw.h"
#include "CircularBuffer.h"
//#include "FileWvIn.h"

#import <vector>
#import <map>

//#define SRATE 44100

typedef void (^Block)();

@interface AudioManager ()
{
    AEAudioController *_audioController;
    
    std::map<UITouch *, stk::BlitSaw *> saws;
    
    float gain;
    
    float *_lastAudioBuffer;
    int _lastAudioBufferSize;
    
    CircularBuffer<Block> *_opBuffer;
}

@end


@implementation AudioManager

+ (instancetype)instance
{
    static AudioManager *_instance = nil;
    @synchronized(self) {
        if(_instance == nil)
            _instance = [AudioManager new];
    }
    return _instance;
}

- (void)startAudio
{
    _opBuffer = new CircularBuffer<Block>(64);
    
    AudioStreamBasicDescription audioDescription = [AEAudioController nonInterleavedFloatStereoAudioDescription];
    audioDescription.mSampleRate = MY_COOL_SRATE;
    
    _audioController = [[AEAudioController alloc] initWithAudioDescription:audioDescription
                                                              inputEnabled:NO];
    _audioController.preferredBufferDuration = 0.005;
    _lastAudioBufferSize = _audioController.preferredBufferDuration*MY_COOL_SRATE*4;
    _lastAudioBuffer = new float[_lastAudioBufferSize];
    
    gain = 0;
    
    stk::Stk::setSampleRate(MY_COOL_SRATE);
    
    [_audioController addChannels:@[[AEBlockChannel channelWithBlock: ^(const AudioTimeStamp *time,
                                                                       UInt32 frames,
                                                                       AudioBufferList *audio) {
        
        Block block;
        while(_opBuffer->get(block))
            block();
        
        for(int i = 0; i < frames; i++)
        {
            float samp = 0;
            
            for(auto i : saws)
            {
                stk::BlitSaw *saw = i.second;
                // thread paused here?
                samp += saw->tick();
            }
            
            _lastAudioBuffer[i] = samp;
            _lastAudioBufferSize = frames;
            
            ((float*)(audio->mBuffers[0].mData))[i] = samp;
            ((float*)(audio->mBuffers[1].mData))[i] = samp;
        }
        
    }]]];
    
    [_audioController start:NULL];
}

- (void)setGain:(float)the_gain
{
    gain = the_gain;
}

- (void)createSawForTouch:(UITouch *)t
{
    _opBuffer->put(^{
        saws[t] = new stk::BlitSaw;
    });
}

- (void)setFreq:(float)freq forSawTouch:(UITouch *)t
{
    _opBuffer->put(^{
        saws[t]->setFrequency(freq);
    });
}

- (void)setGain:(float)gain forSawTouch:(UITouch *)t
{
}

- (void)removeSawForTouch:(UITouch *)t
{
    _opBuffer->put(^{
        delete saws[t];
        saws.erase(t);
    });
}

- (float *)lastAudioBuffer
{
    return _lastAudioBuffer;
}

- (int)lastAudioBufferSize
{
    return _lastAudioBufferSize;
}

@end








