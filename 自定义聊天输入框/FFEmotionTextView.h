//
//  FFEmotionTextView.h
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/13.
//  Copyright © 2016年 黄飞. All rights reserved.
//


/**----------------------聊天输入文本框-----------------------------*/

#import "FFTextView.h"
#import "FFEmotion.h"

@interface FFEmotionTextView : FFTextView

/**
 *  拼接表情到最后面
 */
- (void)appendEmotion:(FFEmotion *)emotion;

/**
 *  具体的文字内容
 */
- (NSString *)realText;

@end
