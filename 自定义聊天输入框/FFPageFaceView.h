//
//  PageFaceView.h
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/10.
//  Copyright © 2016年 黄飞. All rights reserved.
//  

            /**-----------------表情界面每页显示的表情--------------------*/

#import <UIKit/UIKit.h>
@class FFEmotion;
#import "FFEmotionView.h"

@protocol FFFacePageViewDelegate <NSObject>

- (void)selectedFaceImage:(FFEmotion *)emotion;

@end
@interface FFPageFaceView : UIView
/**最大的列数*/
@property (nonatomic, assign) NSUInteger columnsPerRow;
/**每页表情的数据*/
@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, weak) id<FFFacePageViewDelegate> delegate;

@end
