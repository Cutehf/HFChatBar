//
//  PageFaceView.m
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/10.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FFPageFaceView.h"
#import "FFEmotion.h"
#import "FFEmotionView.h"
#import "FFEmotionTool.h"
#import "FFEmotionPopView.h"

@interface FFPageFaceView ()

@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) FFEmotionPopView *popView;

@end

@implementation FFPageFaceView

-(FFEmotionPopView *)popView{
    if (!_popView) {
        _popView=[[FFEmotionPopView alloc]init];
    }
    return _popView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {

        self.imageViews = [NSMutableArray array];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPress];
        self.userInteractionEnabled = YES;
        
//        [self setup];

    }
    return self;
}


- (void)setup {
    
    //判断是否需要重新添加所有的imageView 重用使用，除了第一次，后面的数据重用，只需要改变imageView的图片就可以
    if (self.imageViews && self.imageViews.count >= self.datas.count) {

        //这样的目的是为了如果为最后一页的表情，则对于index默认重用最大值为每页的表情数量，这样可以过滤掉大于当前页面所需要的实际表情

        for (FFEmotionView *imageView in self.imageViews) {
            NSUInteger index = [self.imageViews indexOfObject:imageView];
            
            imageView.hidden = index >= self.datas.count;
            FFEmotion *emotion;
            if (!imageView.hidden) {
                
                //如果改组表情的数量小于最大的表情数量时过滤掉最后的删除图片
                if (self.datas.count<([FFEmotionTool pageEmotionCount]+1)) {
                    
                    continue;
                }
                emotion = self.datas[index];
                imageView.emotion=emotion;

                
            }else{
                //得到最后一个元素
                if (index == self.imageViews.count-1) {
                    imageView.hidden=NO;
                    emotion=self.datas.lastObject;
                    imageView.emotion=emotion;
                }
            }
        }
    } else {
     
        //计算每个item的大小
        CGFloat itemWidth = (self.frame.size.width - 40) / self.columnsPerRow;
        
        //当前的列数
        NSUInteger currentColumn = 0;
        //当前的行数
        NSUInteger currentRow = 0;
        // datas 中已经包含了删除图片
            for (FFEmotion *emation in self.datas) {
            
            //当超过一行的最大的表情数量时换行
            if (currentColumn >= self.columnsPerRow) {
                //行数增加
                currentRow ++ ;
                //列数初始化
                currentColumn = 0;
            }
            
            //计算每一个图片的起始X位置 20(左边距) + 第几列*itemWidth + 第几页*一页的宽度
            CGFloat startX = 20 + currentColumn * itemWidth;
            //计算每一个图片的起始Y位置  第几行*每行高度
            CGFloat startY = currentRow * itemWidth;
                
//            NSLog(@"图片emation--%@--%@",emation,emation.png);
            if (emation) {
                
                //datas中包含了删除图片
                NSInteger index = [self.datas indexOfObject:emation];
                
                //为最后一个元素的时候并且改组表情数量小于最大的一页的表情数量时 这时应该把删除图片添加到最后右下角的位置
                if (index == self.datas.count-1  && self.datas.count < ([FFEmotionTool pageEmotionCount]+1)) {
                    
                    startX = 20 + ([FFEmotionTool columnPerRow]-1) * itemWidth;
                    startY = ([FFEmotionTool maxRow]-1) * itemWidth;
                }
                    FFEmotionView *imageView = [self faceImageEmation:emation];
                    [imageView setFrame:CGRectMake(startX, startY, itemWidth, itemWidth)];
                    [self addSubview:imageView];
                    [self.imageViews addObject:imageView];
                    currentColumn ++ ;
                
            }
        }
    }
}

/**
 *  根据emation获取一个imageView实例
 *
 *  @return
 */
- (FFEmotionView *)faceImageEmation:(FFEmotion *)emation{
    
    
    FFEmotionView *imageView = [[FFEmotionView alloc] init];
    imageView.emotion=emation;
    imageView.contentMode = UIViewContentModeCenter;
    
    //添加图片的点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [imageView addGestureRecognizer:tap];
    
    return imageView;
}

/**
 *  根据点击位置获取点击的imageView
 *
 *  @param point 点击的位置
 *
 *  @return 被点击的imageView
 */
- (UIImageView *)faceViewWitnInPoint:(CGPoint)point{
    for (UIImageView *imageView in self.imageViews) {
        if (CGRectContainsPoint(imageView.frame, point)) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - Response Methods
- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFaceImage:)]) {
        FFEmotionView *emotionView=(FFEmotionView *)tap.view;
        [self.delegate selectedFaceImage:emotionView.emotion];
    }
}



/**
 *  根据触摸点返回对应的表情控件
 */
- (FFEmotionView *)emotionViewWithPoint:(CGPoint)point
{
    __block FFEmotionView *foundEmotionView = nil;
    [self.imageViews enumerateObjectsUsingBlock:^(FFEmotionView *emotionView, NSUInteger idx, BOOL *stop) {
#warning 没有显示的表情就不需要处理
        if (CGRectContainsPoint(emotionView.frame, point) && emotionView.hidden == NO) {
            foundEmotionView = emotionView;
            // 停止遍历
            *stop = YES;
        }
    }];
    return foundEmotionView;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    
    // 1.捕获触摸点
    CGPoint touchPoint = [longPress locationInView:longPress.view];
//    CGPoint windowPoint = [longPress locationInView:[UIApplication sharedApplication].windows.lastObject];[[UIApplication sharedApplication].windows.lastObject addSubview:self.facePreviewView];
  FFEmotionView *emotionView = [self emotionViewWithPoint:touchPoint];
    
//    UIImageView *touchFaceView = [self faceViewWitnInPoint:touchPoint];
//    if (longPress.state == UIGestureRecognizerStateBegan) {
////        [self.facePreviewView setCenter:CGPointMake(windowPoint.x, windowPoint.y - 40)];
////        [self.facePreviewView setFaceImage:touchFaceView.image];
////        [[UIApplication sharedApplication].keyWindow addSubview:self.facePreviewView];
//    }else if (longPress.state == UIGestureRecognizerStateChanged){
////        [self.facePreviewView setCenter:CGPointMake(windowPoint.x, windowPoint.y - 40)];
////        [self.facePreviewView setFaceImage:touchFaceView.image];
//    }else if (longPress.state == UIGestureRecognizerStateEnded) {
////        [self.facePreviewView removeFromSuperview];
//        // 手松开了
//        // 移除表情弹出控件
//        [self.popView dismiss];
//        // 选中表情
//        [self selecteEmotion:emotionView.emotion];
//    }
    
    
    if (longPress.state == UIGestureRecognizerStateEnded) { // 手松开了
        // 移除表情弹出控件
        [self.popView dismiss];
        
        // 选中表情
        [self selecteEmotion:emotionView.emotion];
    } else { // 手没有松开
        // 显示表情弹出控件
        [self.popView showFromEmotionView:emotionView];
    }
}

-(void)selecteEmotion:(FFEmotion *)emotion{
    if (emotion == nil) return;
    
    // 保存使用记录
//    [FFEmotionTool addRecentEmotion:emotion];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFaceImage:)]) {
        [self.delegate selectedFaceImage:emotion];
    }
}

#pragma mark - Setters
- (void)setDatas:(NSArray *)datas {
    _datas = [datas copy];
    [self setup];
}

//- (void)setColumnsPerRow:(NSUInteger)columnsPerRow {
//    if (_columnsPerRow != columnsPerRow) {
//        _columnsPerRow = columnsPerRow;
//        [self.imageViews removeAllObjects];
//        for (UIView *subView in self.subviews) {
//            [subView removeFromSuperview];
//        }
//    }
//}

@end
