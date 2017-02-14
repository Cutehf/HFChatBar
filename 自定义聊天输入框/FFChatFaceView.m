//
//  FFChatFaceView.m
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/10.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FFChatFaceView.h"
#import "SwipeView.h"
#import "FFEmotionTool.h"
#import "FFEmotion.h"


@interface FFChatFaceView () <SwipeViewDataSource,SwipeViewDelegate,FFFacePageViewDelegate>

/**滚动视图*/
@property (nonatomic, strong) SwipeView *swipeView;
/**翻页视图*/
@property (nonatomic, strong) UIPageControl *pageControl;
/**表情框底部的工具*/
@property (nonatomic, strong) UIView *bottomView;
/**显示最近表情的按钮*/
@property (nonatomic, strong) UIButton *recentButton;
/**显示emoji表情按钮*/
@property (nonatomic, strong) UIButton *emojiButton;

/**每页显示的行数 默认emoji 3行  最近表情2行  gif表情2行 */
@property (nonatomic, assign) NSUInteger maxRows;
/**每行显示的表情数量,6,6plus可能相应多显示 默认emoji 5s显示7个 最近表情显示4个  gif表情显示4个 */
@property (nonatomic, assign) NSUInteger columnPerRow;
/**每一页显示的表情数量*/
@property (nonatomic, assign ,readonly) NSUInteger itemsPerPage;
/**页数*/
@property (nonatomic, assign) NSUInteger pageCount;
/**表情数组*/
@property (nonatomic, strong) NSMutableArray *faceArray;
/**删除*/
@property (nonatomic, strong) FFEmotion *deleteEmation;

@end

@implementation FFChatFaceView

#pragma mark ----- 懒加载
- (SwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 60)];
        _swipeView.delegate = self;
        _swipeView.dataSource = self;
    }
    return _swipeView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.swipeView.frame.size.height, self.frame.size.width, 20)];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
        
        //划分割线
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 70, 1.0f)];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [_bottomView addSubview:topLine];
        
        //发送按钮
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 0, 70, 40)];
        sendButton.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:70.0f/255.0f blue:1.0f alpha:1.0f];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:sendButton];
        
        //最近历史表情按钮
        UIButton *recentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recentButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_recent_normal"] forState:UIControlStateNormal];
        [recentButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_recent_highlight"] forState:UIControlStateHighlighted];
        [recentButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_recent_highlight"] forState:UIControlStateSelected];
        recentButton.tag = FFShowRecentFace;
        [recentButton addTarget:self action:@selector(changeFaceType:) forControlEvents:UIControlEventTouchUpInside];
        [recentButton sizeToFit];
        [_bottomView addSubview:recentButton];
        [recentButton setFrame:CGRectMake(0, _bottomView.frame.size.height/2-recentButton.frame.size.height/2, recentButton.frame.size.width, recentButton.frame.size.height)];
        self.recentButton=recentButton;
        
        //emoji按钮
        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_emoji_normal"] forState:UIControlStateNormal];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_emoji_highlight"] forState:UIControlStateHighlighted];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_emoji_highlight"] forState:UIControlStateSelected];
        emojiButton.tag = FFShowEmojiFace;
        [emojiButton addTarget:self action:@selector(changeFaceType:) forControlEvents:UIControlEventTouchUpInside];
        [emojiButton sizeToFit];
        [_bottomView addSubview:emojiButton];
        [emojiButton setFrame:CGRectMake(recentButton.frame.size.width, _bottomView.frame.size.height/2-emojiButton.frame.size.height/2, emojiButton.frame.size.width, emojiButton.frame.size.height)];
        self.emojiButton=emojiButton;
        
    }
    return _bottomView;
}

-(FFEmotion *)deleteEmation{
    if (!_deleteEmation) {
        
        _deleteEmation=[[FFEmotion alloc] init];
        _deleteEmation.png=deleteImg;
        _deleteEmation.chs=@"删除";
    }
    return _deleteEmation;
}


#pragma mark ----- 初始化
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    
    [self addSubview:self.swipeView];
    [self addSubview:self.pageControl];
    [self addSubview:self.bottomView];
    
    self.faceArray = [NSMutableArray array];
    self.faceViewType = FFShowEmojiFace;
    
    [self setupFaceView];
    
}

-(void)setFaceViewType:(FFShowFaceViewType)faceViewType{
    _faceViewType=faceViewType;
    if (faceViewType==FFShowEmojiFace) {
        self.emojiButton.selected=YES;
        self.recentButton.selected=NO;
    }else{
        self.emojiButton.selected=NO;
        self.recentButton.selected=YES;
    }
}

/**
 *  显示表情界面
 */
- (void)setupFaceView{
    [self.faceArray removeAllObjects];
    //显示表情
    if (self.faceViewType == FFShowEmojiFace) {
        [self setupEmojiFaces];
    //显示最近表情
    }else if (self.faceViewType == FFShowRecentFace){
        [self setupRecentFaces];
    }
    [self.swipeView reloadData];
    
}

/**
 *  每一页显示的表情数量 = M每行数量*N行
 */
- (NSUInteger)itemsPerPage {
    return self.maxRows * self.columnPerRow;
}

/**
 *  初始化所有的emoji表情数组,添加删除按钮
 */
- (void)setupEmojiFaces{
    
    //显示3行
    self.maxRows = 3;
    //显示列数，即每行的表情数量
    self.columnPerRow = [UIScreen mainScreen].bounds.size.width > 320 ? 8 : 7;
    
    //计算每一页最多显示多少个表情 - 1(删除按钮)
    NSInteger pageItemCount = self.itemsPerPage - 1;
    //添加表情到数组
    [self.faceArray addObjectsFromArray:[FFEmotionTool defaultEmotions]];
    //获取所有的face表情
//    NSMutableArray *allFaces = [NSMutableArray arrayWithArray:[FFEmotionTool defaultEmotions]];
    
    //计算页数 
    self.pageCount = [self.faceArray count] % pageItemCount == 0 ? [self.faceArray count] / pageItemCount : ([self.faceArray count] / pageItemCount) + 1;
    
    //配置pageControl的页数
    self.pageControl.numberOfPages = self.pageCount;
    
    //循环,给每一页末尾加上一个delete图片,如果是最后一页直接在最后一个加上delete图片
       for (int i = 0; i < self.pageCount; i++) {
        //最后一页
        if (i == self.pageCount - 1) {
            
            [self.faceArray addObject:self.deleteEmation];
        }else{
            
            [self.faceArray insertObject:self.deleteEmation atIndex:(i + 1) * pageItemCount + i];
        }
    }
}

/**
 *  初始化最近使用的表情数组
 */
- (void)setupRecentFaces{
    
    //设置swipeView为多少页
    self.pageCount = 1;
    self.pageControl.numberOfPages=1;
    [self.faceArray removeAllObjects];
    NSArray *recentEmotions=[NSArray arrayWithArray:[FFEmotionTool recentEmotions]];
    [self.faceArray addObjectsFromArray:recentEmotions];
    if (recentEmotions.count>0) {
        [self.faceArray addObject:self.deleteEmation];
    }
    
}

#pragma mark ----- bottom上的按钮点击方法
- (void)sendAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendButtonClick)]) {
        [self.delegate sendButtonClick];
    }
}

- (void)changeFaceType:(UIButton *)button{
    self.faceViewType = button.tag;
    self.recentButton.selected=self.faceViewType==FFShowRecentFace;
    self.emojiButton.selected=self.faceViewType==FFShowEmojiFace;
    [self setupFaceView];
}

#pragma mark ----- SwipeViewDelegate & SwipeViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return self.pageCount ;
}

//翻页
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.pageControl.currentPage = swipeView.currentPage;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    FFPageFaceView *facePageView = (FFPageFaceView *)view;
    if (!view) {
        facePageView = [[FFPageFaceView alloc] initWithFrame:swipeView.frame];
    }
    //设置每行的最大表情数量，即列数
    [facePageView setColumnsPerRow:self.columnPerRow];
    //最后一页  每页是满的表情，那么最后一页时总得数量将>=总的表情数量
    if ((index + 1) * self.itemsPerPage  >= self.faceArray.count) {
        //截取最后一组的数据时，它的数据长度不一定是每页最大的表情数量
        [facePageView setDatas:[self.faceArray subarrayWithRange:NSMakeRange(index * self.itemsPerPage, self.faceArray.count - index * self.itemsPerPage)]];
    }else {
        
        //截取每组数据
        [facePageView setDatas:[self.faceArray subarrayWithRange:NSMakeRange(index * self.itemsPerPage, self.itemsPerPage)]];
    }
    facePageView.delegate = self;
    return facePageView;
}

#pragma mark ----- FFFacePageViewDelegate 代理方法点击某个表情
- (void)selectedFaceImage:(FFEmotion *)emotion {

    if (![emotion.png isEqualToString:deleteImg]) {
        [FFEmotionTool addRecentEmotion:emotion];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceViewSendFace:)]) {
        [self.delegate faceViewSendFace:emotion];
    }
}


@end
