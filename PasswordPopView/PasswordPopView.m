//
//  PasswordPopView.m
//  fishingLights
//
//  Created by 杨晨 on 2017/1/3.
//  Copyright © 2017年 覃盼. All rights reserved.
//

#import "PasswordPopView.h"
static PasswordPopView *sharedManager = nil;
@implementation PasswordPopView
{
    //第一次输入密码
    UITextField *passwordText;
    //第二次输入密码
    UITextField *resetPasswordText;
}

+(PasswordPopView *)sharedSingleton
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[PasswordPopView alloc] init];
    });
    return sharedManager;
}
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [super allocWithZone:zone];
    });
    return sharedManager;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return sharedManager ;
    
}
-(id)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0,kScreenW , kScreenH);
        
        //阴影层
        UIView *blackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        blackV.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        //为图片添加手势
        [blackV addGestureRecognizer:singleTap];
        blackV.userInteractionEnabled = YES;
        [self addSubview:blackV];
        blackV.alpha = 0.5;
        
        
        UIView *popView= [[UIView alloc]initWithFrame:CGRectMake(40, kScreenW/2-70, kScreenW-80, 200)];
        popView.backgroundColor = UIColorFromRGB(0xEBEBEB);
        popView.layer.cornerRadius = 8;
        popView.layer.masksToBounds = YES;
        [self addSubview:popView];
        
        UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, popView.frame.size.width, 45)];
        promptLabel.backgroundColor=UIColorFromRGB(0xB40613);
        promptLabel.textColor=[UIColor whiteColor];
        promptLabel.font = [UIFont systemFontOfSize:15];
        promptLabel.text = @"重置密码";
        promptLabel.textAlignment=NSTextAlignmentCenter;
        [popView addSubview:promptLabel];
        
        UIView *rithView = [[UIView alloc]initWithFrame:CGRectMake(popView.frame.size.width-134/3, 0, 134/3, 134/3)];
        rithView.backgroundColor = [UIColor clearColor];
        [popView addSubview:rithView];
        
        UIButton *disappear=[UIButton buttonWithType:UIButtonTypeCustom];
        disappear.frame = CGRectMake(10, 10, 88/3, 88/3);
        [disappear setBackgroundImage:[UIImage imageNamed:@"pop_shut"] forState:UIControlStateNormal];
        [disappear addTarget:self action:@selector(disappearBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rithView addSubview:disappear];
        
        
        //密码框提示
        passwordText = [[UITextField alloc]initWithFrame:CGRectMake(5, promptLabel.frame.size.height/2+35, popView.frame.size.width-10, 40)];
        passwordText.clearButtonMode = UITextFieldViewModeAlways;
        passwordText.placeholder = @"请输入密码";
        passwordText.layer.cornerRadius = 8;
        passwordText.secureTextEntry = YES;
        passwordText.layer.masksToBounds = YES;
        passwordText.backgroundColor =[UIColor whiteColor];
        passwordText.clearsOnBeginEditing = YES;
        passwordText.textAlignment = NSTextAlignmentLeft;
        passwordText.returnKeyType =UIReturnKeyDone;
        passwordText.delegate = self;
        [popView addSubview:passwordText];
        
        //重置密码
        resetPasswordText = [[UITextField alloc]initWithFrame:CGRectMake(5, passwordText.frame.size.height+passwordText.frame.origin.y+6, popView.frame.size.width-10, 40)];
        resetPasswordText.clearButtonMode = UITextFieldViewModeAlways;
        resetPasswordText.layer.cornerRadius = 8;
        resetPasswordText.placeholder = @"请重新输入密码";
        resetPasswordText.secureTextEntry = YES;
        resetPasswordText.layer.masksToBounds = YES;
        resetPasswordText.backgroundColor =[UIColor whiteColor];
        resetPasswordText.clearsOnBeginEditing = YES;
        resetPasswordText.textAlignment = NSTextAlignmentLeft;
        resetPasswordText.returnKeyType =UIReturnKeyDone;
        resetPasswordText.delegate = self;
        [popView addSubview:resetPasswordText];
        
        UIButton *determine=[UIButton buttonWithType:UIButtonTypeCustom];
        determine.frame = CGRectMake(0, popView.frame.size.height-126/3, popView.frame.size.width, 126/3);
        [determine setTitle:@"提   交" forState:UIControlStateNormal];
        [determine setBackgroundColor:UIColorFromRGB(0xB40613)];
        [determine addTarget:self action:@selector(determineBtn:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:determine];
    }
    return self;
}
-(void)shouBusyViewPrompt:(UIView *)aSuperView
{
    [aSuperView addSubview:sharedManager];
}
//确定
-(void)determineBtn:(UIButton *)btn
{
    if ([sharedManager isPasswordText]) {
        
        if ([self.delegate respondsToSelector:@selector(PasswordPopViewText:resetPasswordText:)]) {
            [self.delegate PasswordPopViewText:passwordText.text resetPasswordText:resetPasswordText.text];
        }
    }
   [sharedManager removeFromSuperview];
  
}
//取消
-(void)disappearBtn:(UIButton *)btn
{
    [sharedManager removeFromSuperview];
}
//阴影层触摸关闭
-(void)singleTapAction
{
   [sharedManager removeFromSuperview];
}
-(BOOL)isPasswordText
{
    if (passwordText.text.length<=0) {
         [sharedManager removeFromSuperview];
        [HHPointHUD showErrorWithTitle:@"请输入密码"];
        return NO;
    }
    if (resetPasswordText.text.length<=0) {
         [sharedManager removeFromSuperview];
        [HHPointHUD showErrorWithTitle:@"请输入二次密码"];
        return NO;
    }
    if (![passwordText.text isEqualToString:resetPasswordText.text]) {
         [sharedManager removeFromSuperview];
        [HHPointHUD showErrorWithTitle:@"两次密码不一致"];
        return NO;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
