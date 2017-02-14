//
//  FFChatBarMoreView.h
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/16.
//  Copyright © 2016年 黄飞. All rights reserved.
//


    /**---------------------显示更多界面----------------------------*/

#import <UIKit/UIKit.h>

@interface FFChatBarMoreView : UIView

/**
 *  moreItem类型
 */
typedef NS_ENUM(NSUInteger, FFChatMoreItemType){
    FFChatMoreItemCamera = 0 /** 显示拍照 */,
    FFChatMoreItemAlbum /** 显示相册 */,
    FFChatMoreItemLocation /** 显示地理位置 */,
};




@end
