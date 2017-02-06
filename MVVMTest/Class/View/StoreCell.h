//
//  StoreCell.h
//  ReconstructionDemo
//
//  Created by ios on 2016/12/5.
//  Copyright © 2016年 c. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"

@interface StoreCell : UITableViewCell
//商家logo
@property (nonatomic,strong) UIImageView  * iconLog;

//商家名字
@property (nonatomic,strong) UILabel      * titleLabel;

//商家关于
@property (nonatomic,strong) UILabel      * aboutLabel;

//商家描述
@property (nonatomic,strong) UILabel      * desLabel;

//商家ID
@property (nonatomic,strong) NSString     * storeID;

-(void) setModel:(StoreModel *) model;

@end
