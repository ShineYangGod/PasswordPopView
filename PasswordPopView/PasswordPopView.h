//
//  PasswordPopView.h
//  fishingLights
//
//  Created by 杨晨 on 2017/1/3.
//  Copyright © 2017年 覃盼. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasswordPopViewDelegate <NSObject>
/**
 
参数：passwordTextFild  密码
     resetPasswordTextFild  二次密码
 **/
- (void)PasswordPopViewText:(NSString *)passwordTextFild resetPasswordText:(NSString *)resetPasswordTextFild;

@end
@interface PasswordPopView : UIView<UITextFieldDelegate>

@property (weak,nonatomic)id<PasswordPopViewDelegate>delegate;

+(PasswordPopView *)sharedSingleton;

-(void)shouBusyViewPrompt:(UIView *)aSuperView;
@end
