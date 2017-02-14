//
//  FFEmotionPopView.h
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/13.
//  Copyright © 2016年 黄飞. All rights reserved.
//


/**-------------------长按某个表情弹出视图----------------------------------*/


#import <UIKit/UIKit.h>
#import "FFEmotionView.h"

@interface FFEmotionPopView : UIView

/**默认背景*/
@property (nonatomic, strong) UIImageView *backgroundImageView;
/**
 *  显示表情弹出控件
 *
 *  @param fromEmotionView 从哪个表情上面弹出
 */
- (void)showFromEmotionView:(FFEmotionView *)fromEmotionView;
- (void)dismiss;


@end
