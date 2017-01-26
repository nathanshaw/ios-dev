//
//  AppDelegate.m
//  Week1
//
//  Created by Spencer Salazar on 1/25/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TheAmazingAudioEngine.h"

@interface AppDelegate ()

@end

float phase = 0;
float freq = 220;
float gain = 0;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.window.rootViewController = [[ViewController alloc] initWithNibName:@"MainView" bundle:nil];
    }

    [self.window makeKeyAndVisible];
    
    AudioStreamBasicDescription audioDescription = [AEAudioController nonInterleavedFloatStereoAudioDescription];
    audioDescription.mSampleRate = 44100;
    
    AEAudioController *audioController = [[AEAudioController alloc] initWithAudioDescription:audioDescription inputEnabled:NO];
    audioController.preferredBufferDuration = 0.005;
    [audioController start:NULL];
    
    [audioController addChannels:@[[AEBlockChannel channelWithBlock:^(const AudioTimeStamp *time,
                                                                      UInt32 frames,
                                                                      AudioBufferList *audio) {
        // play sine wave
        for(int i = 0; i < frames; i++)
        {
            ((float*)(audio->mBuffers[0].mData))[i] = sinf(2*M_PI*phase)*gain;
            ((float*)(audio->mBuffers[1].mData))[i] = sinf(2*M_PI*phase)*gain;
            phase += freq/44100.0;
            if(phase > 1)
                phase -= 1;
        }
    }]]];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
