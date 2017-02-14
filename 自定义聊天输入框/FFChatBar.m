//
//  FFChatBar.m
//  自定义聊天输入框
//
//  Created by 黄飞 on 16/5/10.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FFChatBar.h"
#import "FFChatFaceView.h"
#import "FFEmotionTextView.h"
#import "FFEmotion.h"
#import "XMProgressHUD.h"
#import "UIView+Extension.h"
#import "FFChatBarMoreView.h"
@interface FFChatBar () <UITextViewDelegate,FFChatFaceViewDelegate>

/**切换录音模式按钮 */
@property (nonatomic,strong) UIButton *voiceButton;
/**录音按钮*/
@property (nonatomic,strong) UIButton *voiceRecordButton;
/**表情按钮*/
@property (nonatomic,strong) UIButton *faceButton;
/**更多按钮*/
@property (nonatomic,strong) UIButton *moreButton;
/**输入框*/
@property (nonatomic,strong) FFEmotionTextView *textView;
/**当前活跃的底部view,用来指向faceView*/
@property (nonatomic,strong) FFChatFaceView *faceView;
/**是否正在切换键盘*/
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;
/**键盘的Frame*/
@property (nonatomic, assign) CGRect keyboardFrame;
/**聊天框的初始化高度*/
@property (nonatomic, assign) CGFloat chatBarInitHeight;
/**聊天框当前的高度*/
@property (nonatomic, assign) CGFloat chatBarHeight;

/**更多界面*/
@property (nonatomic,strong) FFChatBarMoreView *chatBarMoreView;

@property (nonatomic, assign) CGSize textViewContentSize;

@end

@implementation FFChatBar
{
    BOOL isKeyBoardShow;
    BOOL isEmojiShow;
}

#pragma mark ----- 懒加载
- (UIButton *)voiceButton{
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.tag = FFFunctionViewShowVoice;
        _voiceButton.translatesAutoresizingMaskIntoConstraints=NO;
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton sizeToFit];
    }
    return _voiceButton;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[FFEmotionTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.delegate = self;
        // 垂直方向上拥有有弹簧效果
        _textView.alwaysBounceVertical=YES;
        _textView.translatesAutoresizingMaskIntoConstraints=NO;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderWidth = .5f;
        _textView.layer.masksToBounds = YES;
        _textView.placehoder=@"请输入。。。";
    }
    return _textView;
}


- (UIButton *)voiceRecordButton{
    if (!_voiceRecordButton) {
        _voiceRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceRecordButton.hidden = YES;
        _voiceRecordButton.frame = self.textView.bounds;
        _voiceRecordButton.backgroundColor=[UIColor greenColor];
        _voiceRecordButton.translatesAutoresizingMaskIntoConstraints=NO;
//        _voiceRecordButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_voiceRecordButton setBackgroundColor:[UIColor lightGrayColor]];
        _voiceRecordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_voiceRecordButton setTitle:@"按住录音" forState:UIControlStateNormal];
        [_voiceRecordButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
        [_voiceRecordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
        [_voiceRecordButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
        [_voiceRecordButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
        [_voiceRecordButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    }
    return _voiceRecordButton;
}

- (UIButton *)faceButton{
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButton.tag = FFFunctionViewShowFace;
        _faceButton.translatesAutoresizingMaskIntoConstraints=NO;
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_face_normal"] forState:UIControlStateNormal];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceButton sizeToFit];
    }
    return _faceButton;
}

- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.tag = FFFunctionViewShowMore;
        _moreButton.translatesAutoresizingMaskIntoConstraints=NO;
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_more_normal"] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton sizeToFit];
    }
    return _moreButton;
}

- (FFChatFaceView *)faceView{
    if (!_faceView) {
        _faceView = [[FFChatFaceView alloc] initWithFrame:CGRectMake(0, self.superViewHeight , self.frame.size.width, kFunctionViewHeight)];
        _faceView.delegate = self;
        _faceView.faceViewType=FFShowEmojiFace;
        _faceView.backgroundColor = self.backgroundColor;
    }
    return _faceView;
}

-(FFChatBarMoreView *)chatBarMoreView{
    if (!_chatBarMoreView) {
        _chatBarMoreView=[[FFChatBarMoreView alloc]initWithFrame:CGRectMake(0, self.superViewHeight , self.frame.size.width, kFunctionViewHeight)];
        _chatBarMoreView.backgroundColor=[UIColor greenColor];
    }
    
    return _chatBarMoreView;
}

#pragma mark ----- 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.chatBarInitHeight=self.height;
        [self setup];
    }
    return self;
}

-(void)setup{
    
    [self addSubview:self.voiceButton];
    [self addSubview:self.textView];
    [self addSubview:self.faceButton];
    [self addSubview:self.moreButton];
    [self.textView addSubview:self.voiceRecordButton];
    
    //添加键盘监听代理方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //加载子视图布局
    [self layoutIfNeeded];
    

}

#pragma mark ----- 键盘监听代理方法
- (void)keyboardFrameWillShow:(NSNotification *)notification{

    
    CGRect kbRect=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrame=kbRect;
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.transform=CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -kbRect.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    
    //当正在切换键盘时不让输入框还原位置
    if (self.isChangingKeyboard) {
        return;
    }
    
    self.keyboardFrame = CGRectZero;
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
    
        self.transform=CGAffineTransformIdentity;
//        self.voiceButton.selected=NO;
        self.faceButton.selected=NO;
        //让表情键盘消失
        if (self.textView.inputView) {

            self.textView.inputView=nil;
        }
        self.moreButton.selected=NO;
    }];
}

- (void)buttonAction:(UIButton *)button{
    
    FFFunctionViewShowType showType=button.tag;
    
    //打开表情键盘
    if (button==self.faceButton) {
        
        [self.faceButton setSelected:!self.faceButton.selected];
        [self.moreButton setSelected:NO];
        [self.voiceButton setSelected:NO];
        
        if (!self.voiceRecordButton.hidden) {
            if (self.chatBarHeight) {
                
                [self changeChatBarHeight:self.chatBarHeight];
            }
            self.voiceRecordButton.hidden=YES;
        }
            [self showFaceView];
    }else if (button == self.moreButton){
        [self.faceButton setSelected:NO];
        [self.moreButton setSelected:!self.moreButton.selected];
        [self.voiceButton setSelected:NO];
        if (!self.voiceRecordButton.hidden) {
            if (self.chatBarHeight) {
                
                [self changeChatBarHeight:self.chatBarHeight];
            }
            self.voiceRecordButton.hidden=YES;
        }

        [self showMoreView];
        
    }else if (button == self.voiceButton){
        [self.faceButton setSelected:NO];
        [self.moreButton setSelected:NO];
        [self.voiceButton setSelected:!self.voiceButton.selected];
        
        [self showVoice];
    }
}


#pragma mark ----- 显示表情键盘
- (void)showFaceView{

        // 正在切换键盘
        self.changingKeyboard = YES;
        
        // 当前显示的是自定义键盘，切换为系统自带的键盘
        if (self.textView.inputView) {
            if ([self.textView.inputView isKindOfClass:[FFChatBarMoreView class]]) {
                self.textView.inputView=self.faceView;
            }else{
                self.textView.inputView=nil;
            }
        }else{
            self.textView.inputView=self.faceView;
            
        }
        
        //关闭键盘
        [self.textView resignFirstResponder];
        
#warning 记录是否正在更换键盘
        // 更换完毕完毕
        self.changingKeyboard = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
    
    
}

#pragma mark ----- 显示录音
-(void)showVoice{
    
    self.voiceRecordButton.hidden =! self.voiceButton.selected;

    if (self.voiceButton.selected) {
      
        [self changeChatBarHeight:self.chatBarInitHeight];
        [self.textView resignFirstResponder];
        
       
    }else{
       
        [self.textView becomeFirstResponder];
        
        //iOS7以后，textView的contentSize不能自动的及时的更新，这种方法可以获得其的内容的高度
        self.textView.contentSize=CGSizeMake(self.textView.frame.size.width, [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)].height);
        
        [self textViewDidChange:self.textView];
       
        
        NSLog(@"改变后的高度为%lf-%lf-",[self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)].height,[[self.textView layoutManager]usedRectForTextContainer:[self.textView textContainer]].size.height);
        
    }
}

#pragma mark ----- 显示更多界面
-(void)showMoreView{
    
    //正在改变键盘
    self.changingKeyboard=YES;
    
    if (self.textView.inputView) {
        if ([self.textView.inputView isKindOfClass:[FFChatFaceView class]]) {
            self.textView.inputView=self.chatBarMoreView;
        }else{
            self.textView.inputView=nil;
        }
    }else{
         self.textView.inputView=self.chatBarMoreView;
    }
    
    
    [self.textView resignFirstResponder];
    
    //改变键盘结束
    self.changingKeyboard=NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
    
    
}

#pragma mark ----- 点击某个表情代理方法  很关键的表情显示在textView上
-(void)faceViewSendFace:(FFEmotion *)emotion{

    NSLog(@"-=====%@",emotion);
    if ([emotion.png isEqualToString:deleteImg]) {

#warning        /**------------很关键的删除方法-----------------------------------*/
        
        if (self.textView.text.length>0) {
            
            [self.textView deleteBackward];
        }
    }else{
    
        [self.textView appendEmotion:emotion];
//         self.textView.contentSize=CGSizeMake(self.textView.frame.size.width, [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)].height);
        //调整键盘的高度
        [self textViewDidChange:self.textView];
    
    }
}

/**
 *  发送按钮   一种为代理方法点击发送按钮发送消息，另一种通过点击回车键进行发送消息 直接点击发送按钮时，这时键盘的高度改变
 */
-(void)sendButtonClick{
    
    
    NSLog(@"发送的消息为--：%@----",[self.textView realText]);
    
    //清除textView的文本
    self.textView.text=nil;
    

      //还原键盘高度
    [self changeChatBarHeight:self.chatBarInitHeight];
    
}

#pragma mark ----- 发送文本消息
-(void)sendTextMessage{
    
}

#pragma mark ----- 改变聊天框的高度
-(void)changeChatBarHeight:(CGFloat)height{
    
  
    //改变当前聊天框的高度
    self.height=height;
    //改变当前聊天框的y值
    self.y = self.superViewHeight-[self bottomHeight]-self.height;
/**-----------------------很关键，更新布局---------------------------------*/
    [self layoutIfNeeded];

}


#pragma mark ----- UITextViewDelegate 代理方法 编辑文本时调用 用来调整键盘高度

-(void)textViewDidChange:(UITextView *)textView{
    
    NSLog(@"textViewDidChange=====++++%@",textView.text);
    [textView flashScrollIndicators];
    CGFloat textViewH = 0;
    CGFloat minHeight = self.chatBarInitHeight - 4 - 4; //textView的最小的高度
    CGFloat maxHeight = 68; //textView的最大的高度
    //得到当前文本框的高度
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight<minHeight) {
        textViewH=minHeight;
    }else if (contentHeight>maxHeight){
        textViewH=maxHeight;
    }else{
        textViewH=contentHeight;
    }
    
    //监听send事件-----判断最后的一个字符是不是换行字符
    if ([textView.text hasSuffix:@"\n"] && textView.text.length>0) {

        NSLog(@"+++++++++开始发送消息了+++++++");
    
        //去除最后的回车
        self.textView.text=[[self.textView realText] substringToIndex:[self.textView realText].length - 1];
        //发送消息
        [self sendButtonClick];
        
        //发送时，textView的高度为最小的高度
        textViewH=minHeight;
        
        
        NSLog(@"------------------------------");
        
    }
    NSLog(@"原来的高度为%lf--",self.textView.contentSize.height);
    self.chatBarHeight=textViewH + 4 + 4;
    
   
    //改变当前聊天框的高度  4是为文本框距离上边和下边的距离 得到的就为当前聊天框的高度
    [self changeChatBarHeight:self.chatBarHeight];
    
    
    //在此处点击录音再回来原来的编辑状态时有可能内容的高度发生变化，没有及时更新
    self.textView.contentSize=CGSizeMake(self.textView.frame.size.width, [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, FLT_MAX)].height);
    
    [textView setContentOffset:CGPointMake(0, self.textView.contentSize.height-textView.frame.size.height)];
    
}


#pragma mark ----- 聊天框下面的键盘的高度
-(CGFloat)bottomHeight{
    //得到当前下面的键盘还是表情 的高度
    if (self.faceView.superview) {
        return MAX(self.keyboardFrame.size.height, self.faceView.frame.size.height);
    }else{
        return MAX(self.keyboardFrame.size.height, CGFLOAT_MIN);
    }
}


#pragma mark ----- 录音  开始录音
-(void)startRecordVoice
{
    [XMProgressHUD show];
    NSLog(@"开始录音");

}

/**
 *  取消录音
 */
- (void)cancelRecordVoice{
//    [XMProgressHUD dismissWithMessage:@"取消录音"];
      NSLog(@"取消录音");
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice{
    [XMProgressHUD dismiss];
      NSLog(@"录音结束");
}


/**
 *  更新录音显示状态,手指向上滑动后提示松开取消录音
 */
- (void)updateCancelRecordVoice{
//    [XMProgressHUD changeSubTitle:@"松开取消录音"];
      NSLog(@"松开取消录音");
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice{
//    [XMProgressHUD changeSubTitle:@"向上滑动取消录音"];
      NSLog(@"向上滑动取消录音");
}


#pragma mark ----- 子视图布局
-(void)updateConstraints{
    
    [super updateConstraints];
    
    //布局录音按钮
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.voiceButton.frame.size.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.voiceButton.frame.size.height]];
    
    //布局更多按钮
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.moreButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    //布局表情按钮
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.faceButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.moreButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.faceButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.faceButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.faceButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    //布局textView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.voiceButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:4]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-4]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.faceButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-10]];
    
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceRecordButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceRecordButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceRecordButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.textView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceRecordButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.textView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceRecordButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.textView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.voiceRecordButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.textView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
}




@end
