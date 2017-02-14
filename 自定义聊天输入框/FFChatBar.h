//
//  FFChatBar.h
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/10.
//  Copyright © 2016年 黄飞. All rights reserved.
//



/**--------------------聊天框界面的构建-------------------*/

#import <UIKit/UIKit.h>

#define kMaxHeight 60.0f
#define kMinHeight 45.0f
#define kFunctionViewHeight 216.0f
/**
 *  functionView 类型
 */
typedef NS_ENUM(NSUInteger, FFFunctionViewShowType){
    FFFunctionViewShowNothing /**< 不显示functionView */,
    FFFunctionViewShowFace /**< 显示表情View */,
    FFFunctionViewShowVoice /**< 显示录音view */,
    FFFunctionViewShowMore /**< 显示更多view */,
    FFFunctionViewShowKeyboard /**< 显示键盘 */,
};
@interface FFChatBar : UIView

@property (assign, nonatomic) CGFloat superViewHeight;

@end
