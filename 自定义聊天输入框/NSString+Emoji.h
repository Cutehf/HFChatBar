//
//  NSString+Emoji.h
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/12.
//  Copyright © 2016年 黄飞. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (Emoji)
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(int)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;

/**
 *  是否为emoji字符
 */
- (BOOL)isEmoji;
@end
