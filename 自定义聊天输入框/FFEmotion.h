//
//  FFEmotion.h
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/12.
//  Copyright © 2016年 黄飞. All rights reserved.
//

/**------------------工具类--------------------------------*/

#import <Foundation/Foundation.h>

@interface FFEmotion : NSObject <NSCoding>
/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的文字描述 */
@property (nonatomic, copy) NSString *cht;
/** 表情的文png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的编码 */
@property (nonatomic, copy) NSString *code;


/** 表情的存放文件夹\目录 */
@property (nonatomic, copy) NSString *directory;
/** emoji表情的字符 */
@property (nonatomic, copy) NSString *emoji;
@end

