//
//  FFEmotionPopView.m
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/13.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FFEmotionPopView.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"

@interface FFEmotionPopView ()

@property (nonatomic,strong) FFEmotionView *emotionView;

@end

@implementation FFEmotionPopView


-(FFEmotionView *)emotionView{
    if (!_emotionView) {
        _emotionView=[[FFEmotionView alloc] init];
    }
    
    return _emotionView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview_background"]];
        [self addSubview:backgroundImageView];
        [self addSubview:self.emotionView];
        self.bounds=backgroundImageView.bounds;
        self.backgroundImageView=backgroundImageView;
        self.backgroundColor=[UIColor clearColor];
    }
    
    return self;
}

-(void)showFromEmotionView:(FFEmotionView *)fromEmotionView{
    if (fromEmotionView == nil) return;
    // 1.显示表情
    self.emotionView.emotion = fromEmotionView.emotion;
    [self.emotionView sizeToFit];
    self.emotionView.center=self.backgroundImageView.center;
    // 2.添加到窗口上
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 3.设置位置   背景的位置
    CGFloat centerX = fromEmotionView.centerX;
    CGFloat centerY = fromEmotionView.centerY - self.height * 0.5;
    CGPoint center = CGPointMake(centerX, centerY);
    self.center = [window convertPoint:center fromView:fromEmotionView.superview];
    
    //设置表情的动画显示
    [UIView animateWithDuration:.3 animations:^{
        self.emotionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            self.emotionView.transform = CGAffineTransformIdentity;
        }];
    }];
    
}

- (void)dismiss
{
    [self removeFromSuperview];
}

/**
 *  当一个控件显示之前会调用一次（如果控件在显示之前没有尺寸，不会调用这个方法） 设置背景图片
 *
 *  @param rect 控件的bounds
 */
- (void)drawRect:(CGRect)rect
{
    [[UIImage imageWithName:@"preview_background"] drawInRect:rect];
}


@end
