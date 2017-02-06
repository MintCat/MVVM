//
//  SecondViewController.h
//  MVVMTest
//
//  Created by ios on 2017/1/9.
//  Copyright © 2017年 c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (nonatomic,strong) RACSubject *delegateSubject;

@end
