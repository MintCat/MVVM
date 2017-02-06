//
//  StoreViewModel.h
//  MVVMTest
//
//  Created by ios on 2017/1/5.
//  Copyright © 2017年 c. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreViewModel : NSObject

//获取商店模型
@property (nonatomic,strong) RACCommand *fetchStoreModelCommand;

@end
