//
//  ViewController.m
//  AVFoundationAudioRecorder
//
//  Created by wanglong on 16/7/31.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<AVAudioRecorderDelegate>
/** 录制音频 */
@property(nonatomic,strong)AVAudioRecorder *audioRecorder;
/** 音频播放器 */
@property (nonatomic, strong) AVAudioPlayer *audioPlay;
@end

@implementation ViewController

#pragma mark - 创建录音对象
- (AVAudioRecorder *)audioRecorder
{
    if (_audioRecorder == nil) {
        //设置录音保存路径
//        NSURL *audioUrl = [NSURL fileURLWithPath:@"/Users/wanglong/Desktop/1audio.wav"];
        NSURL *audioUrl = [self getAudioPath];
#warning  .mp3结尾的会提示错误?The operation couldn’t be completed. (OSStatus error 1718449215.)

        
        //2. 录音机的文件设置
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //设置录音的音频格式
        [dic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //设置录音的采样率 电话采样率为8000
        [dic setObject:@(8000) forKey:AVSampleRateKey];
        //设置通道
        [dic setObject:@(1) forKey:AVNumberOfChannelsKey];
        //采样点位数 8、16、24、32
        [dic setObject:@(8) forKey:AVLinearPCMBitDepthKey];
        //是否采用浮点数采样
        [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        
        //查看错误信息
        NSError *error;
        
        //创建录音对象
        AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioUrl settings:dic error:&error];
        
        if (error) {
            NSLog(@"创建音频播放器的时候出现了错误！%@",[error localizedDescription]);
        }
        
        //准备录音
        [_audioRecorder prepareToRecord];
        
        //设置代理
        audioRecorder.delegate = self;
        _audioRecorder = audioRecorder;
        
    }
    return _audioRecorder;
}


#pragma mark - 获得音频播放器
- (AVAudioPlayer *)audioPlay
{
    if (_audioPlay == nil) {
        
        //获得播放的音频路径
        NSURL *audioUrl = [self getAudioPath];
        
        //查看出错参数
        NSError *error ;
        _audioPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:&error];
        if (error) {
            NSLog(@"获得音频播放对象出错 %@",[error localizedDescription]);
        }
    }
    return _audioPlay;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 开始录音
- (IBAction)startRecorder:(UIButton *)sender {
    
    if (!self.audioRecorder.isRecording) {
        //如果正在播放声音先暂停
        if (self.audioPlay.isPlaying) {
            [_audioPlay stop];
        }

        
        //开始录音
        [_audioRecorder record];
    }
    
}

#pragma mark - 停止录音
- (IBAction)stopRecorder:(UIButton *)sender {
    [self.audioRecorder stop];
    NSLog(@"停止录音...");
}

#pragma mark - 播放录音
- (IBAction)playRecorder:(UIButton *)sender {
    if (!self.audioPlay.isPlaying) {
        [_audioPlay play];
    }
}

#pragma mark - 停止播放
- (IBAction)stopRecoder:(UIButton *)sender {
    if (self.audioPlay.isPlaying) {
        [_audioPlay stop];
    }
}


#pragma mark - 录制音频的时候的回调方法AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"flag == %zd",flag);
    if (flag) {
        if (!self.audioPlay.isPlaying) {
            [_audioPlay play];
        }
    }
}
#pragma mark - 获取得录音存放的路径
- (NSURL *)getAudioPath
{
    //获得doc的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"docPath == %@",docPath);
    //设置录音放的路径以及录音名称
    NSString *audioPath = [docPath stringByAppendingPathComponent:@"123.wav"];
    //返回录音存放的url
    return [NSURL URLWithString:audioPath];
    
}
@end
