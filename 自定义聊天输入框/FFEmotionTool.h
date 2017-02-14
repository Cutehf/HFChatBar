//
//  HMEmotionTool.h
//  黑马微博
//
//  Created by apple on 14-7-17.
//  Copyright (c) 2014年 heima. All rights reserved.
//  管理表情数据：加载表情数据、存储表情使用记录

#import <UIKit/UIKit.h>
@class FFEmotion;

@interface FFEmotionTool : NSObject
/**
 *  默认表情
 */
+ (NSArray *)defaultEmotions;
/**
 *  emoji表情
 */
+ (NSArray *)emojiEmotions;
/**
 *  浪小花表情
 */
+ (NSArray *)lxhEmotions;
/**
 *  最近表情
 */
+ (NSArray *)recentEmotions;

/**
 *  根据表情的文字描述找出对应的表情对象
 */
+ (FFEmotion *)emotionWithDesc:(NSString *)desc;

/**
 *  保存最近使用的表情
 */
+ (void)addRecentEmotion:(FFEmotion *)emotion;

/**
 *  得到每页最大的表情数量 这里面的数量已经减去了删除这个图片
 */
+ (NSInteger)pageEmotionCount;

/**
 *  得到表情最大的行数
 */
+ (NSInteger)maxRow;

/**
 *  得到表情最大的列数
 */
+ (NSInteger)columnPerRow;


@end
