//
//  SecondViewController.m
//  MVVMTest
//
//  Created by ios on 2017/1/9.
//  Copyright © 2017年 c. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface SecondViewController ()

@property (nonatomic ,strong) UIButton          *btn;

@property (nonatomic ,strong) UIButton          *alertBtn;

@property (nonatomic ,strong) UITextField       *textField;

@property (nonatomic ,strong) UIAlertController *alert;

@property (nonatomic ,strong) UIButton          *nextBtn;

@end

@implementation SecondViewController

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"页面二";
    
    [self.view addSubview:self.btn];
    [self.view addSubview:self.alertBtn];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.nextBtn];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *userInfo = noti.userInfo;
        CGRect rect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        float height = rect.size.height;
        float zhaZhi = ScreenHeight-64-self.textField.frame.origin.y-self.textField.frame.size.height;
        if(zhaZhi<height){
            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = CGRectMake(0, zhaZhi-height+64, self.view.bounds.size.width, self.view.bounds.size.height);
            }];
        }
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        if(self.view.frame.origin.y != 64){
            [UIView animateWithDuration:0.25 animations:^{
                self.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height);
            }];
        }
        
    }];
    
}

-(void) btnClick:(UIButton *) btn{
    @weakify(self);
    if(self.delegateSubject){
        @strongify(self);
        [self.delegateSubject sendNext:self.title];
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

#pragma mark - lazyLoad
-(RACSubject *)delegateSubject{
    if(!_delegateSubject){
        _delegateSubject = [RACSubject subject];
    }
    return _delegateSubject;
}

-(UIButton *) btn{
    if(!_btn){
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.bounds = CGRectMake(0, 0, 120, 50);
        _btn.center = self.view.center;
        _btn.layer.borderColor = [UIColor blueColor].CGColor;
        _btn.layer.borderWidth = 1.0;
        _btn.layer.cornerRadius = 5;
        [_btn setTitle:@"RACSubject" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        //[btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //使用RAC监听按钮的点击事件
        //    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {;
        //        if(self.delegateSubject){
        //            [self.delegateSubject sendNext:self.title];
        //        }
        //    }];
        
        //filter 过滤,可以筛选出需要的信号
        @weakify(self);
        [[[_btn rac_signalForControlEvents:UIControlEventTouchUpInside]filter:^BOOL(id value) {
            UIButton *btn = (UIButton *)value;
            if([btn.currentTitle isEqualToString:@"RACSubject"]){
                return YES;
            }else{
                return NO;
            }
        }]subscribeNext:^(id x) {
            @strongify(self);
            if(self.delegateSubject){
                [self.delegateSubject sendNext:self.title];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"title" object:nil userInfo:@{@"title":@"页面一"}];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _btn;
}

-(UIButton *) alertBtn{
    if(!_alertBtn){
        _alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _alertBtn.bounds = CGRectMake(0, 0, 120, 50);
        _alertBtn.center = CGPointMake(self.view.center.x, self.view.center.y-60);
        _alertBtn.layer.borderColor = [UIColor blueColor].CGColor;
        _alertBtn.layer.borderWidth = 1.0;
        _alertBtn.layer.cornerRadius = 5;
        [_alertBtn setTitle:@"AlertRAC" forState:UIControlStateNormal];
        [_alertBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        @weakify(self);
        [[_alertBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self presentViewController:self.alert animated:YES completion:^{
                self.alert.textFields.firstObject.text = nil;
            }];
        }];
    }
    return _alertBtn;
}

-(UITextField *) textField{
    if(!_textField){
        _textField                    =  [[UITextField alloc]init];
        _textField.bounds             =  CGRectMake(0, 0, 200, 40);
        _textField.center             =  CGPointMake(self.view.center.x, self.view.center.y+55);
        _textField.font               =  [UIFont systemFontOfSize:14];
        _textField.textColor          =  [UIColor blueColor];
        _textField.layer.borderColor  =  [UIColor blueColor].CGColor;
        _textField.layer.borderWidth  =  1.0;
        _textField.layer.cornerRadius =  5;
        UIView *blankView             =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 40)];
        _textField.leftView           =  blankView;
        _textField.leftViewMode       =  UITextFieldViewModeAlways;
        _textField.placeholder        =  @"请输入内容";
        
        //使用RAC,不用再导入协议,同时通过使用block语句块,不用另开方法,使代码简洁
        [_textField.rac_textSignal subscribeNext:^(id x) {
            NSString *text = (NSString *)x;
            if(text.length > 5){
                _textField.text = [text substringToIndex:5];
                [LCProgressHUD showInfoMsg:@"请输入不多于5个字符"];
            }
        }];
        
        //map是映射,即数学中的映射
        [[_textField.rac_textSignal map:^id(id value) {
            return _textField.text.length?[UIColor redColor]:[UIColor blueColor];
        }] subscribeNext:^(id x) {
            _textField.textColor = (UIColor *)x;
        }];
        
        //filter是过滤,是一张删选
       [[_textField.rac_textSignal filter:^BOOL(id value) {
           return [value length]>3;
       }] subscribeNext:^(id x) {
           NSLog(@"text---%@",(NSString *)x);
       }];
    }
    return _textField;
}

-(UIAlertController *) alert{
    if(!_alert){
        _alert = [UIAlertController alertControllerWithTitle:@"RAC" message:@"RAC Alert" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"canle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"已取消");
        }];
        UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"ensure" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"已确认");
        }];
        
        [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField.rac_textSignal subscribeNext:^(id x) {
                NSLog(@"text----%@",(NSString *)x);
            }];
        }];
        
        [_alert addAction:cancle];
        [_alert addAction:ensure];
        
#warning UIAlertView的RAC不适用于UIAlertController,UIAlertController也不需要用到ARC,因为每个action的创建后面自带block定义其用法
//        [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
//            NSLog(@"first---%@",tuple.first);
//            NSLog(@"second---%@",tuple.second);
//            NSLog(@"third---%@",tuple.third);
//        }];
        
    
//        [_alert.rac_buttonClickedSignal subscribeNext:^(id x) {
//            NSLog(@"x---%@",x);
//        }];
    }
    return _alert;
}

-(UIButton *) nextBtn{
    if(!_nextBtn){
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.bounds = CGRectMake(0, 0, 120, 50);
        _nextBtn.center = CGPointMake(self.view.center.x, self.textField.center.y+55);
        _nextBtn.layer.borderColor = [UIColor blueColor].CGColor;
        _nextBtn.layer.borderWidth = 1.0;
        _nextBtn.layer.cornerRadius = 5;
        [_nextBtn setTitle:@"NextVC" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        @weakify(self);
        [[_nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            ThirdViewController *vc = [[ThirdViewController alloc]init];
            [[vc.nomralCommand execute:nil] subscribeNext:^(id x) {
                NSLog(@"x---%@",x);
            } error:^(NSError *error) {
                NSLog(@"error---%@",error);
            }];
            
//            [[vc.nomralCommand executionSignals].switchToLatest subscribeNext:^(id x) {
//                NSLog(@"xx----%@",x);
//            } error:^(NSError *error) {
//                NSLog(@"error----%@",error);
//            }];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _nextBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
