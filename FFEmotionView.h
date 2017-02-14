//
//  FFEmotionView.h
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/12.
//  Copyright © 2016年 黄飞. All rights reserved.
//


/**----------------emoji图片的封装---------------------*/

#import <UIKit/UIKit.h>

#define deleteImg @"compose_emotion_delete"

@class FFEmotion;
@interface FFEmotionView : UIImageView

@property (nonatomic,strong) FFEmotion *emotion;

@end
