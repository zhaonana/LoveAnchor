//
//  ConversionViewController.m
//  LoveAnchor
//
//  Created by zhongqinglongtu on 14-11-6.
//  Copyright (c) 2014年 zhongqinglongtu. All rights reserved.
//

#import "ConversionViewController.h"

@interface ConversionViewController ()<UITextFieldDelegate>
{
    UITextField *_conversionTextField;
    UIButton *_QDButton;
}

@end

@implementation ConversionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUI];
}
#pragma mark - showUI
- (void)showUI
{
    
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 50, 44);
    titleButton.tag = 100;
    [titleButton setTitle:@"返回" forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:textFontColor forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:titleButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(107, 0, 110, 44)];
    label.text = @"金豆兑换金币";
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textFontColor;
    [self.navigationController.navigationBar addSubview:label];
    
    UIView *leftInputView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, kScreenWidth, 44)];
    leftInputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftInputView];
    
    UIImageView *hengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    hengxianImage.backgroundColor = [UIColor lightGrayColor];
    [leftInputView addSubview:hengxianImage];
    
    UIImageView *diHengxianImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    diHengxianImage.backgroundColor = [UIColor lightGrayColor];
    [leftInputView addSubview:diHengxianImage];
    
    _conversionTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 145, 44)];
    _conversionTextField.placeholder = @"输入兑换数量";
    _conversionTextField.delegate = self;
    [_conversionTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _conversionTextField.font = [UIFont systemFontOfSize:15];
    _conversionTextField.borderStyle = UITextBorderStyleNone;
    _conversionTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [leftInputView addSubview:_conversionTextField];
    
    UILabel *acquisitionLabel = [[UILabel alloc]initWithFrame:CGRectMake(175, 0, 130, 44)];
    acquisitionLabel.text = [NSString stringWithFormat:@"可获得%d金币",1];
    acquisitionLabel.font = [UIFont systemFontOfSize:15];
    acquisitionLabel.backgroundColor = [UIColor clearColor];
    acquisitionLabel.textColor = [UIColor lightGrayColor];
    acquisitionLabel.textAlignment = NSTextAlignmentRight;
    [leftInputView addSubview:acquisitionLabel];
    
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 64, 170, 25)];
    promptLabel.text = [NSString stringWithFormat:@"金豆余额：%d",1234567];
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:promptLabel];
    
    _QDButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _QDButton.selected = NO;
    _QDButton.frame = CGRectMake(15, 144, 290, 42);
    [_QDButton setTitle:@"确定" forState:UIControlStateNormal];
    [_QDButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_QDButton setBackgroundColor:[UIColor lightGrayColor]];
    [_QDButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_QDButton];

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    if (_conversionTextField.text.length == 0) {
        [_QDButton setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [_QDButton setBackgroundColor:textFontColor];
    }
}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField.text.length == 0) {
//        [_QDButton setBackgroundColor:[UIColor lightGrayColor]];
//    } else {
//        [_QDButton setBackgroundColor:textFontColor];
//    }
//    
//    return YES;
//}
#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
        if (button.selected) {
            [_QDButton setBackgroundColor:textFontColor];
        } else {
            [_QDButton setBackgroundColor:[UIColor grayColor]];
        }
        NSLog(@"回不去了，怎么办呢");
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"真改啊");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
