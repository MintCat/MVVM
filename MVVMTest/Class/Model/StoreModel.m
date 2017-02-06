//
//  StoreModel.m
//  ReconstructionDemo
//
//  Created by ios on 2016/12/5.
//  Copyright © 2016年 c. All rights reserved.
//

#import "StoreModel.h"

@implementation StoreModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"iconStr"  : @"store_label",
             @"titleStr" : @"store_name",
             @"aboutStr" : @"goods_count",
             @"desStr"   : @"store_zy",
             @"storeID"  : @"store_id"
             };
}

@end
