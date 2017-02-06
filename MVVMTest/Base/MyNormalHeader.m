//
//  MyNormalHeader.m
//  MVVMTest
//
//  Created by ios on 2017/1/11.
//  Copyright © 2017年 c. All rights reserved.
//

#import "MyNormalHeader.h"

#define Defalut_H 60

#define Radius    15

#define topColor    [UIColor blueColor].CGColor

#define leftColor   [UIColor redColor].CGColor

#define bottomColor [UIColor greenColor].CGColor

#define rightColor  [UIColor yellowColor].CGColor

@interface MyNormalHeader ()

//加载时的展示视图
@property (nonatomic ,strong) UIView *layerView;

//四个点图层
@property (nonatomic ,strong) CAShapeLayer *topLayer;

@property (nonatomic ,strong) CAShapeLayer *leftLayer;

@property (nonatomic ,strong) CAShapeLayer *bottomLayer;

@property (nonatomic ,strong) CAShapeLayer *rightLayer;

//点与点之间的连接介质
@property (nonatomic ,strong) CAShapeLayer *lineLayer;

@end

@implementation MyNormalHeader
#pragma mark - 准备视图
-(void) prepare{
    [super prepare];
    self.mj_w = ScreenWeight;
    self.mj_h = Defalut_H;
    
    self.backgroundColor = [RGB(150, 210, 249) colorWithAlphaComponent:0.4];
    self.layerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.layerView];
    
    CGPoint topPoint     =  CGPointMake(Defalut_H/2.0, Defalut_H/2.0-Radius);
    CGPoint leftPoint    =  CGPointMake(Defalut_H/2.0-Radius, Defalut_H/2.0);
    CGPoint bottomPoint  =  CGPointMake(Defalut_H/2.0, Defalut_H/2.0+Radius);
    CGPoint rightPoint   =  CGPointMake(Defalut_H/2.0+Radius, Defalut_H/2.0);
    //上点
    self.topLayer = [self layerWithPoint:topPoint color:topColor];
    [self.layerView.layer addSublayer:self.topLayer];
    
    //左点
    self.leftLayer = [self layerWithPoint:leftPoint color:leftColor];
    [self.layerView.layer addSublayer:self.leftLayer];
   
    //下点
    self.bottomLayer = [self layerWithPoint:bottomPoint color:bottomColor];
    self.bottomLayer.hidden = NO;
    [self.layerView.layer addSublayer:self.bottomLayer];
    
    //右边
    self.rightLayer = [self layerWithPoint:rightPoint color:rightColor];
    [self.layerView.layer addSublayer:self.rightLayer];
    
    //点与点之间的介质
    [self.layerView.layer insertSublayer:self.lineLayer above:self.topLayer];

}

-(CAShapeLayer *) layerWithPoint:(CGPoint ) center color:(CGColorRef ) color{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame         = CGRectMake(center.x-5, center.y-5, 10, 10);
    layer.fillColor     = color;
    layer.path          = [self pointPath:center];
    layer.hidden        = YES;
    return layer;
}

-(CGPathRef) pointPath:(CGPoint) center{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(5, 5) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    return path.CGPath;
}

-(void) addtranslationAniToLayer:(CAShapeLayer *) layer xValue:(CGFloat) x yValue:(CGFloat) y{
    CAKeyframeAnimation *keyFa = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    keyFa.duration = 1.0;
    keyFa.repeatCount = HUGE;
    keyFa.removedOnCompletion = NO;
    keyFa.fillMode = kCAFillModeForwards;
    keyFa.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSValue *fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)];
    NSValue *toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(x, y, 0)];
    keyFa.values = @[fromValue,toValue,fromValue,toValue,fromValue];
    
    [layer addAnimation:keyFa forKey:@"keyfa"];
}

- (void)addRotationAniToLayer:(CALayer *)layer {
    CABasicAnimation * rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @(0);
    rotationAni.toValue = @(M_PI * 2);
    rotationAni.duration = 1.0;
    rotationAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAni.repeatCount = HUGE;
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = NO;
    [layer addAnimation:rotationAni forKey:@"rotationAni"];
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
            [self.layerView.layer removeAllAnimations];
            [self.topLayer removeAllAnimations];
            [self.leftLayer removeAllAnimations];
            [self.bottomLayer removeAllAnimations];
            [self.rightLayer removeAllAnimations];
            break;
        case MJRefreshStatePulling:
            [self.layerView.layer removeAllAnimations];
            [self.topLayer removeAllAnimations];
            [self.leftLayer removeAllAnimations];
            [self.bottomLayer removeAllAnimations];
            [self.rightLayer removeAllAnimations];
            break;
        case MJRefreshStateRefreshing:
            self.bottomLayer.hidden = NO;
            self.bottomLayer.opacity = 1;
            self.leftLayer.hidden = NO;
            self.topLayer.hidden = NO;
            self.rightLayer.hidden = NO;
            
            [self addtranslationAniToLayer:self.topLayer xValue:0 yValue:5];
            [self addtranslationAniToLayer:self.leftLayer xValue:5 yValue:0];
            [self addtranslationAniToLayer:self.bottomLayer xValue:0 yValue:-5];
            [self addtranslationAniToLayer:self.rightLayer xValue:-5 yValue:0];
            
            [self addRotationAniToLayer:self.layerView.layer];

            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
    self.lineLayer.strokeStart = 0;
    self.lineLayer.strokeEnd = 0;
    self.bottomLayer.opacity = 0;
    if(pullingPercent>=0&&pullingPercent<1/6.0){
        [self adjustPointStateWithIndex:0];
    }else if (pullingPercent>=1/6.0&&pullingPercent<1/3.0){
        self.bottomLayer.opacity = (pullingPercent-1/6.0)*6;
        [self adjustPointStateWithIndex:0];
    }else if(pullingPercent>=1/3.0&&pullingPercent<5/12.0){
        self.lineLayer.strokeStart = 0;
        self.lineLayer.strokeEnd = 0.25;
        self.bottomLayer.opacity = 1;
        [self adjustPointStateWithIndex:1];
    }else if (pullingPercent>=5/12.0&&pullingPercent<7/12.0){
        self.lineLayer.strokeStart = 0.25;
        self.lineLayer.strokeEnd = 0.25;
        self.bottomLayer.opacity = 1;
        [self adjustPointStateWithIndex:2];
    }else if (pullingPercent>=7/12.0&&pullingPercent<2/3.0){
        self.lineLayer.strokeStart = 0.25;
        self.lineLayer.strokeEnd = 0.5;
        self.bottomLayer.opacity = 1;
        [self adjustPointStateWithIndex:3];
    }else if (pullingPercent>=2/3.0&&pullingPercent<5/6.0){
        self.lineLayer.strokeStart = 0.5;
        self.lineLayer.strokeEnd = 0.5;
        self.bottomLayer.opacity = 1;
        [self adjustPointStateWithIndex:4];
    }else if (pullingPercent>=5/6.0&&pullingPercent<1){
        self.lineLayer.strokeStart = 0.5;
        self.lineLayer.strokeEnd = 0.75;
        self.bottomLayer.opacity = 1;
        [self adjustPointStateWithIndex:5];
    }else{
        self.lineLayer.strokeStart = 1;
        self.lineLayer.strokeEnd = 1;
        self.bottomLayer.opacity = 1;
        [self adjustPointStateWithIndex:6];
    }
    
}

//跳转连线介质的显隐和颜色
- (void)adjustPointStateWithIndex:(NSInteger)index { //index : 小阶段： 0 ~ 7
    self.leftLayer.hidden = index > 1 ? NO : YES;
    self.topLayer.hidden = index > 3 ? NO : YES;
    self.rightLayer.hidden = index > 5 ? NO : YES;
    self.lineLayer.strokeColor = index > 5 ? rightColor : index > 3 ? topColor : index > 1 ? leftColor : bottomColor;
}

#pragma mark lazyLoad
-(UIView *) layerView{
    if(!_layerView){
        _layerView = [[UIView alloc]init];
        _layerView.bounds = CGRectMake(0, 0, Defalut_H, Defalut_H);
        _layerView.center = CGPointMake(self.mj_w/2.0, self.mj_h/2.0);
        _layerView.backgroundColor = [UIColor whiteColor];
    }
    return _layerView;
}

-(CAShapeLayer *) lineLayer{
    if(!_lineLayer){
        self.lineLayer = [CAShapeLayer layer];
        self.lineLayer.frame = self.layerView.bounds;
        self.lineLayer.lineWidth = 10;
        self.lineLayer.lineCap = kCALineCapRound;
        self.lineLayer.lineJoin = kCALineJoinRound;
        self.lineLayer.fillColor = bottomColor;
        self.lineLayer.strokeColor = bottomColor;
        
        CGPoint topPoint     =  CGPointMake(Defalut_H/2.0, Defalut_H/2.0-Radius);
        CGPoint leftPoint    =  CGPointMake(Defalut_H/2.0-Radius, Defalut_H/2.0);
        CGPoint bottomPoint  =  CGPointMake(Defalut_H/2.0, Defalut_H/2.0+Radius);
        CGPoint rightPoint   =  CGPointMake(Defalut_H/2.0+Radius, Defalut_H/2.0);
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:bottomPoint];
        [linePath addLineToPoint:leftPoint];
        [linePath moveToPoint:leftPoint];
        [linePath addLineToPoint:topPoint];
        [linePath moveToPoint:topPoint];
        [linePath addLineToPoint:rightPoint];
        [linePath moveToPoint:rightPoint];
        [linePath addLineToPoint:bottomPoint];
        self.lineLayer.path = linePath.CGPath;
        self.lineLayer.strokeStart = 0;
        self.lineLayer.strokeEnd   = 0;

    }
    return _lineLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
