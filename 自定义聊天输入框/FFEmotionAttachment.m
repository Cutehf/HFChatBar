//
//  FFEmotionAttachment.m
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/12.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FFEmotionAttachment.h"
#import "FFEmotion.h"
#import "UIImage+Extension.h"

@implementation FFEmotionAttachment

- (void)setEmotion:(FFEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png]];
}

@end
