//
//  BFSoundEffect.m
//  缤微纷购
//
//  Created by 程召华 on 16/4/15.
//  Copyright © 2016年 xinxincao. All rights reserved.
//

#import "BFSoundEffect.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation BFSoundEffect

+(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    //    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, NULL, NULL)
    //    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    //AudioServicesPlaySystemSound(soundID);//播放音效
    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

//-(void)soundCompleteCallback (SystemSoundID soundID,voidvoid * clientData){
//    NSLog(@"播放完成...");
//}

@end
