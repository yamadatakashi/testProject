//
//  VoiceList.m
//  HiromiGoAlarmClock
//
//  Created by 山田 卓史 on 2013/06/11.
//  Copyright (c) 2013年 SWEET ROOM. All rights reserved.
//

#import "VoiceList.h"

@implementation VoiceList


+ (NSMutableArray *)alarmVoiceSet{
    NSMutableArray *alarmVoiceList = [[NSMutableArray alloc] initWithCapacity:0];
    [alarmVoiceList addObject:@"おはよう！郷ひろみです！そろそろ起きる時間だよ♪"];
    [alarmVoiceList addObject:@"GO、GO、GO！そろそろ起きてくださーい！"];
    [alarmVoiceList addObject:@"位置について、用意スタート！さぁ、画面をタッチして！ゴー！タッチ！ゴー！"];
    [alarmVoiceList addObject:@"ランダム設定"];
    return alarmVoiceList;
}

+ (NSMutableArray *)finishVoiceSet{
    NSMutableArray *finishVoiceList = [[NSMutableArray alloc] initWithCapacity:0];
    [finishVoiceList addObject:@"おはよう、今日も一日頑張ろうね♪いってらっしゃい♪"];
    [finishVoiceList addObject:@"おはよう！あれ？まだ寝ぼけてるかな？もっとすっきり起きられるように、今夜は早く寝るんだよ♪"];
    [finishVoiceList addObject:@"おはよう、やっと起きたね。今日は何をする？今日も良い一日になりますように♪"];
    [finishVoiceList addObject:@"お目覚めかな？今日も一日元気に行きましょう♪GO！！GO！！GO！！"];
    [finishVoiceList addObject:@"おはよう♪よく頑張って起きたね♪二度寝しないように♪LET’S GO！！"];
    [finishVoiceList addObject:@"おはよう♪今日も素晴らしい一日になりますように♪いいことあるよー♪いってらっしゃい♪"];
    [finishVoiceList addObject:@"おはよう、よく眠れたかな？今日も可愛い寝顔だったよ♪"];
    [finishVoiceList addObject:@"ランダム設定"];
    
    return finishVoiceList;
}


+ (NSString *)alarmVoiceNameToString:(int)num {
    return  [[VoiceList alarmVoiceSet] objectAtIndex:num -1];
}


+ (NSString *)finishVoiceNameToString:(int)num{
    return [[VoiceList finishVoiceSet] objectAtIndex:num - 1];
}


@end
