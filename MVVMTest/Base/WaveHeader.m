//
//  WaveHeader.m
//  MVVMTest
//
//  Created by ios on 2017/1/13.
//  Copyright © 2017年 c. All rights reserved.
//

#import "WaveHeader.h"

@interface WaveHeader ()
//前置波浪图层
@property (nonatomic, strong) UIBezierPath *preWave;

//当前波浪图层
@property (nonatomic, strong) UIBezierPath *startWave;

//后置波浪图层
@property (nonatomic, strong) UIBezierPath *endWave;

@end

@implementation WaveHeader

#pragma mark - 准备视图
-(void) prepare{
    [super prepare];
    
    self.mj_w = ScreenWeight;
    self.mj_h = 60;
    
    [self setLayerAndAnimation];
}

#pragma mark 设置图层和动画
-(void) setLayerAndAnimation{
    CAShapeLayer *preWavelayer = [[CAShapeLayer alloc]init];
    preWavelayer.path = self.preWave.CGPath;
    preWavelayer.fillColor = [RGB(150, 210, 249) colorWithAlphaComponent:0.4].CGColor;
    CABasicAnimation * preani = [CABasicAnimation animationWithKeyPath:@"path"];
    preani.fromValue = (__bridge id _Nullable)(self.preWave.CGPath);
    preani.toValue = (__bridge id _Nullable)(self.startWave.CGPath);
    preani.duration = 2.5;
    preani.repeatCount = HUGE;
    preani.fillMode = kCAFillModeRemoved;
    preani.removedOnCompletion = NO;
    [preWavelayer addAnimation:preani forKey:nil];
    
    CAShapeLayer *waveLayer = [[CAShapeLayer alloc]init];
    waveLayer.path = self.startWave.CGPath;
    waveLayer.fillColor = [RGB(150, 210, 249) colorWithAlphaComponent:0.4].CGColor;
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"path"];
    ani.fromValue = (__bridge id _Nullable)(self.startWave.CGPath);
    ani.toValue = (__bridge id _Nullable)(self.endWave.CGPath);
    ani.duration = 2.5;
    ani.repeatCount = HUGE;
    ani.fillMode = kCAFillModeRemoved;
    ani.removedOnCompletion = NO;
    [waveLayer addAnimation:ani forKey:nil];
    
    [self.layer addSublayer:preWavelayer];
    [self.layer addSublayer:waveLayer];
}

#pragma mark 布置视图
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

#pragma mark lazyLoad
-(UIBezierPath *) preWave{
    if(!_preWave){
        _preWave = [UIBezierPath bezierPath];
        [_preWave moveToPoint:CGPointMake(-self.mj_w, self.mj_h/2.0)];
        [_preWave addLineToPoint:CGPointMake(-self.mj_w, self.mj_h)];
        [_preWave addLineToPoint:CGPointMake(0, self.mj_h)];
        [_preWave addLineToPoint:CGPointMake(0, self.mj_h/2.0)];
        [_preWave addCurveToPoint:CGPointMake(-self.mj_w, self.mj_h/2.0) controlPoint1:CGPointMake(-self.mj_w/2.0+20, 0) controlPoint2:CGPointMake(-self.mj_w/2.0-20, 60)];
        [_preWave closePath];
    }
    return _preWave;
}

-(UIBezierPath *) startWave{
    if(!_startWave){
        _startWave = [UIBezierPath bezierPath];
        [_startWave moveToPoint:CGPointMake(0, self.mj_h/2.0)];
        [_startWave addLineToPoint:CGPointMake(0, self.mj_h)];
        [_startWave addLineToPoint:CGPointMake(self.mj_w, self.mj_h)];
        [_startWave addLineToPoint:CGPointMake(self.mj_w, self.mj_h/2.0)];
        [_startWave addCurveToPoint:CGPointMake(0, self.mj_h/2.0) controlPoint1:CGPointMake(self.mj_w/2.0+20, 0) controlPoint2:CGPointMake(self.mj_w/2.0-20, 60)];
        [_startWave closePath];
    }
    return _startWave;
}

-(UIBezierPath *) endWave{
    if(!_endWave){
        _endWave = [UIBezierPath bezierPath];
        [_endWave moveToPoint:CGPointMake(self.mj_w, self.mj_h/2.0)];
        [_endWave addLineToPoint:CGPointMake(self.mj_w, self.mj_h)];
        [_endWave addLineToPoint:CGPointMake(self.mj_w*2, self.mj_h)];
        [_endWave addLineToPoint:CGPointMake(self.mj_w*2, self.mj_h/2.0)];
        [_endWave addCurveToPoint:CGPointMake(self.mj_w, self.mj_h/2.0) controlPoint1:CGPointMake(self.mj_w*3/2.0+20, 0) controlPoint2:CGPointMake(self.mj_w*3/2.0-20, 60)];
        [_endWave closePath];
    }
    return _endWave;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
