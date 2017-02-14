//
//  FFChatFaceView.h
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/10.
//  Copyright © 2016年 黄飞. All rights reserved.
//


/**--------------------表情界面的构建-------------------*/

#import <UIKit/UIKit.h>
#import "FFPageFaceView.h"

@class FFEmotion;
typedef NS_ENUM(NSUInteger, FFShowFaceViewType) {
    FFShowEmojiFace = 0,    //显示emoji
    FFShowRecentFace,       //显示历史表情
    FFShowGifFace,          //显示gif表情
};

@protocol FFChatFaceViewDelegate <NSObject>

/**点击表情代理方法*/
- (void)faceViewSendFace:(FFEmotion *)emotion;
/**点击发送按钮代理方法*/
- (void)sendButtonClick;


@end

@interface FFChatFaceView : UIView

@property (nonatomic, assign) FFShowFaceViewType faceViewType;
@property (nonatomic, weak) id<FFChatFaceViewDelegate> delegate;

@end
