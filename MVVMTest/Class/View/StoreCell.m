//
//  StoreCell.m
//  ReconstructionDemo
//
//  Created by ios on 2016/12/5.
//  Copyright © 2016年 c. All rights reserved.
//

#import "StoreCell.h"

@implementation StoreCell

#pragma mark - 初始化
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.iconLog];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.aboutLabel];
        [self.contentView addSubview:self.desLabel];
    }
    return self;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    [self.iconLog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.mas_equalTo(60);
        make.width.equalTo(self.iconLog.mas_height).multipliedBy(1);
    }];
    
    self.iconLog.layer.cornerRadius  =  30;
    self.iconLog.layer.masksToBounds =  YES;
    self.iconLog.layer.borderColor   =  DefaultColor.CGColor;
    self.iconLog.layer.borderWidth   =  1.0;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.iconLog.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.height.equalTo(self.iconLog.mas_width).multipliedBy(0.4);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconLog.mas_bottom).offset(0);
        make.left.equalTo(self.iconLog.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.height.equalTo(self.iconLog.mas_height).multipliedBy(0.25);
    }];
    
    [self.aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.desLabel.mas_top).offset(0);
        make.left.equalTo(self.iconLog.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.height.equalTo(self.desLabel.mas_height).multipliedBy(1);
    }];

}

#pragma mark - 懒加载
-(UIImageView *) iconLog{
    if(!_iconLog){
        _iconLog = [[UIImageView alloc]init];
    }
    return _iconLog;
}

-(UILabel *) titleLabel{
    if(!_titleLabel){
        _titleLabel           =  [[UILabel alloc]init];
        _titleLabel.text      =  @"我是标题";
        _titleLabel.font      =  [UIFont systemFontOfSize:15];
        _titleLabel.textColor =  RGB(51, 51, 51);
    }
    return _titleLabel;
}

-(UILabel *) aboutLabel{
    if(!_aboutLabel){
        _aboutLabel           =  [[UILabel alloc]init];
        _aboutLabel.text      =  @"我是关于";
        _aboutLabel.font      =  [UIFont systemFontOfSize:12];
        _aboutLabel.textColor =  RGB(153, 153, 153);
    }
    return _aboutLabel;
}

-(UILabel *) desLabel{
    if(!_desLabel){
        _desLabel             =  [[UILabel alloc]init];
        _desLabel.text        =  @"我是描述";
        _desLabel.font        =  [UIFont systemFontOfSize:12];
        _desLabel.textColor   =  RGB(153, 153, 153);
    }
    return _desLabel;
}

#pragma mark - 设置内容
-(void) setModel:(StoreModel *) model{
   
    [self.iconLog sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageNameUrl,model.iconStr]] placeholderImage:[UIImage imageNamed:@"87"]];
    self.titleLabel.text =  model.titleStr;
    self.aboutLabel.text =  [NSString stringWithFormat:@"相关商品%@种", model.aboutStr];
    self.desLabel.text   =  [NSString stringWithFormat:@"主营商品:%@",model.desStr];
    self.storeID         =  model.storeID;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
