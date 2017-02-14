//
//  FFEmotionTextView.m
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/13.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FFEmotionTextView.h"
#import "FFEmotionAttachment.h"

@implementation FFEmotionTextView


- (void)appendEmotion:(FFEmotion *)emotion
{
    if (emotion.emoji) { // emoji表情
        [self insertText:emotion.emoji];
    } else { // 图片表情
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        // 创建一个带有图片表情的富文本
        FFEmotionAttachment *attach = [[FFEmotionAttachment alloc] init];
        attach.emotion = emotion;
        //设置表情向上偏移一点可以设置y的偏移量
        attach.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        // 记录表情的插入位置
        NSUInteger insertIndex = self.selectedRange.location;
        
        // 插入表情图片到光标位置
        [attributedText insertAttributedString:attachString atIndex:insertIndex];
        
        // 设置字体 需要重新设置文本的属性，不然在输入表情后，后面的文本字体大小会变小
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        // 重新赋值(光标会自动回到文字的最后面)
        self.attributedText = attributedText;
        
        // 让光标回到表情后面的位置
        self.selectedRange = NSMakeRange(insertIndex + 1, 0);
        
        //让textView滚动到的可见的位置，即滚动到当前光标的位置，在进行表情输入的时候，光标是不可见的，所以这种方法可以使得textView在输入表情时自动换行
//        [self scrollRangeToVisible:self.selectedRange];
        
    }
}

- (NSString *)realText
{
    // 1.用来拼接所有文字
    NSMutableString *string = [NSMutableString string];
    
    // 2.遍历富文本里面的所有内容
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        FFEmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) { // 如果是带有附件的富文本
            [string appendString:attach.emotion.chs];
        } else { // 普通的文本
            // 截取range范围的普通文本
            NSString *substr = [self.attributedText attributedSubstringFromRange:range].string;
            [string appendString:substr];
        }
    }];
    
    return string;
}


@end
