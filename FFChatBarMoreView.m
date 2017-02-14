//
//  FFChatBarMoreView.m
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/16.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FFChatBarMoreView.h"


typedef enum{
    FFMoreViewPicture = 0,  //图片
    FFMoreViewCamera,       //照片
    FFMoreViewLocation,     //位置
    FFMoreViewPhone,        //通话
}FFMoreViewType;

@interface FFChatBarMoreView ()

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation FFChatBarMoreView

-(NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray=@[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_location"];
    }
    return _imageArray;
}

-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray=@[@"照片",@"拍照",@"位置",@"通话"];
    }
    return _titleArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
//        [self createUI];
        [self button];
    }
    
    return self;
}



-(void)button{
    
    
    NSInteger count=3;
    CGFloat btnW=80;
    CGFloat btnH=80;
    CGFloat btnY=0;
    CGFloat marginX=(self.frame.size.width-count*btnW)/(count+1);
    CGFloat marginY=(self.frame.size.height-2*btnH)/3;
    
    for (int i=0; i<self.imageArray.count; i++) {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        btnY=i/3*btnH;
        
        button.frame=CGRectMake(marginX+(i%count)*(btnW+marginX),marginY + (i/3)*(btnY+marginY), btnW, btnH);
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        button.imageEdgeInsets=UIEdgeInsetsMake(-30, 0, 0, 0);
//        button.backgroundColor=[UIColor redColor];
        [button addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [self addSubview:button];
       
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.imageView.frame), btnW, 30)];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text=self.titleArray[i];
        
        [button addSubview:titleLabel];

    }
}

-(void)buttonClickMethod:(UIButton*)button{
    
    switch (button.tag) {
        case 0:
        
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
            
    }
    
    NSLog(@"点击了%@",self.titleArray[button.tag]);
}


@end
