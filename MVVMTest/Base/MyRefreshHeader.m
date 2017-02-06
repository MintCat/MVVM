//
//  MyRefreshHeader.m
//  MVVMTest
//
//  Created by ios on 2017/1/11.
//  Copyright © 2017年 c. All rights reserved.
//

#import "MyRefreshHeader.h"

@interface MyRefreshHeader ()

@property (nonatomic ,strong) NSMutableArray *imagesArray;

@end

@implementation MyRefreshHeader

#pragma mark lazyload
-(NSMutableArray *)imagesArray{
    if(!_imagesArray){
        _imagesArray = [NSMutableArray arrayWithCapacity:0];
        for(int i=1;i<=3;i++){
            [_imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gif_%d",i]]];
        }
    }
    return _imagesArray;
}
-(void) prepare{
    [super prepare];
    self.mj_h = 60;
    
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    [self setImages:self.imagesArray forState:MJRefreshStateIdle];
    [self setImages:self.imagesArray forState:MJRefreshStatePulling];
    [self setImages:self.imagesArray forState:MJRefreshStateRefreshing];
    
}

-(void) placeSubviews{
    [super placeSubviews];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            
            break;
        case MJRefreshStatePulling:

            break;
        case MJRefreshStateRefreshing:
            
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
