//
//  StoreModel.h
//  ReconstructionDemo
//
//  Created by ios on 2016/12/5.
//  Copyright © 2016年 c. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreModel : NSObject
//图片路径
@property (nonatomic,copy) NSString * iconStr;

//标题文本
@property (nonatomic,copy) NSString * titleStr;

//关于文本
@property (nonatomic,copy) NSString * aboutStr;

//描述文本
@property (nonatomic,copy) NSString * desStr;

//商家ID
@property (nonatomic,copy) NSString * storeID;


@end
