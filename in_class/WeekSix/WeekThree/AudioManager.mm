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

#include "Blit.h"
#include "FileWvIn.h"

#import <vector>

//#define SRATE 44100

@interface AudioManager ()
{
    AEAudioController *_audioController;
    
    float gain;
    
    std::vector<SawOsc> our_sines;
    
    stk::Blit blit;
    stk::Blit blit2;
    stk::Blit blit3;
    stk::FileWvIn file;
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
    AudioStreamBasicDescription audioDescription = [AEAudioController nonInterleavedFloatStereoAudioDescription];
    audioDescription.mSampleRate = MY_COOL_SRATE;
    
    _audioController = [[AEAudioController alloc] initWithAudioDescription:audioDescription
                                                              inputEnabled:NO];
    _audioController.preferredBufferDuration = 0.005;
    
    gain = 0;
    
    stk::Stk::setSampleRate(MY_COOL_SRATE);
    
    our_sines.push_back(SawOsc());
    our_sines.push_back(SawOsc());
    our_sines.push_back(SawOsc());
    our_sines.push_back(SawOsc());
    our_sines.push_back(SawOsc());
    
    for(int i = 0; i < our_sines.size(); i++)
    {
        our_sines[i].setFreq(263*(1+i));
        our_sines[i].setGain(1.0/(1+i));
    }
    
    blit.setFrequency(263);
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"amen.wav" ofType:@""];
    //std::string stdFilepath = std::string([filepath UTF8String]);
    file.openFile([filepath UTF8String]);
    
    [_audioController addChannels:@[[AEBlockChannel channelWithBlock: ^(const AudioTimeStamp *time,
                                                                       UInt32 frames,
                                                                       AudioBufferList *audio) {
        
        for(int i = 0; i < frames; i++)
        {
            float samp = 0;
            
//            for(int i = 0; i < our_sines.size(); i++)
//            {
//                samp += our_sines[i].tick();
//            }
            
            samp += blit.tick();
            samp += blit2.tick();
            samp += blit3.tick();
            
            samp *= gain;
            
            samp += file.tick();
            if(file.isFinished())
                file.reset();
            
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

- (void)setFrequency:(float)frequency
{
    blit.setFrequency(frequency);
}

- (void)setFrequency2:(float)frequency
{
    blit2.setFrequency(frequency);
}

- (void)setFrequency3:(float)frequency
{
    blit3.setFrequency(frequency);
}

@end








