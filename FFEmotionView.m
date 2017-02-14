//
//  FFEmotionView.m
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/12.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FFEmotionView.h"
#import "FFEmotion.h"
@implementation FFEmotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setEmotion:(FFEmotion *)emotion{
    _emotion=emotion;
    
    NSString *imgName=nil;
    if ([emotion.png isEqualToString:deleteImg]) {
        imgName=emotion.png;
    }else{
        imgName=[NSString stringWithFormat:@"%@/%@",emotion.directory,emotion.png];
    }
    
    self.image=[UIImage imageNamed:imgName];
    
}

@end
