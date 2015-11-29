//
//  lockView.m
//  手势解锁
//
//  Created by Jusive on 15/11/27.
//  Copyright © 2015年 Jusive. All rights reserved.
//

#import "lockView.h"
@interface lockView()

@property (nonatomic,strong) NSMutableArray *selectBtu;
@property (nonatomic,assign) CGPoint curP;
@end
@implementation lockView

//懒加载
-(NSMutableArray *)selectBtu{
    if (_selectBtu == nil) {
        _selectBtu = [NSMutableArray array];
   }
    return _selectBtu;
}
//加载xib或者storyboard是会调用一次
-(void)awakeFromNib{
    //循环创建按钮
    for (int i = 0; i < 9; i++) {
        UIButton * btu = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btu];
        [btu setImage:[UIImage imageNamed:@"gesture_node_highlighted" ] forState:UIControlStateSelected];
        [btu setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btu addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btu.tag = i;
    }
}
-(void)btnClick:(UIButton *)button{
    button.selected = YES;
}
//布局fram
-(void)layoutSubviews{
    //调用父类
    [super layoutSubviews];
    int count = (int)self.subviews.count;
    CGFloat Wh = 74;
    CGFloat btuX = 0;
    CGFloat btuY = 0;
    //总行数
    int totalCols = 3;
    int col = 0;
    int  row = 0;
    
    CGFloat margin = (self.bounds.size.width - Wh*totalCols)/(totalCols +1);
    //循环设置子控件的位置
    for (int i = 0; i < count; i++) {
        UIButton *btu = self.subviews[i];
        col = i % totalCols;
        row = i / totalCols;
        btuX = margin + col * (margin + Wh);
        btuY = row * (margin +Wh);
        btu.frame = CGRectMake(btuX, btuY, Wh, Wh);
        btu.userInteractionEnabled = NO;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    //获取手指位置
    CGPoint curP = [touch locationInView:self];
    self.curP = curP;
    //遍历所有按钮
//    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (CGRectContainsPoint(obj.frame, curP)) {
//            if (obj.selected == NO) {
//                obj.selected = YES;
//                [self.selectBtu addObject:obj];
//            }
//        }
//    }];
    for (UIButton *btu in self.subviews) {
        if (CGRectContainsPoint(btu.frame, curP)) {
                        if (btu.selected == NO) {
                            btu.selected = YES;
                            [self.selectBtu addObject:btu];
                        }
                    }
    }
    //重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //没有选中的按钮不划线
    if (self.selectBtu.count == 0) return;
    //拼接路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    //遍历所有选中的按钮
    int count = (int)self.selectBtu.count;
    for (int i = 0;i < count; i++) {
        UIButton *selectB = self.selectBtu[i];
        if (i == 0) {//线的起点是第一个选中的起点
            //设置起点
            [path moveToPoint:selectB.center];
        }else{
            //添加线到选中按钮的中心点
            [path addLineToPoint:selectB.center];
        }
    }
    //添加一根线到手指移动的位置
    [path addLineToPoint:self.curP];
    //设置绘图状态
    [[UIColor greenColor]set];
    [path setLineWidth:5];
    //渲染
    [path stroke];
}

//手指抬起的时候要清空数组还有线
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSMutableString *p = [NSMutableString string];
    //遍历所有的按钮
//    [self.selectBtu enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [p appendFormat:@"%ld",obj.tag];
//    }];
    for (UIButton *btu in self.selectBtu) {
        [p appendFormat:@"%ld",btu.tag];
    }
    [self.selectBtu makeObjectsPerformSelector:@selector(setSelected:) withObject:@NO];
    for (UIButton *btn in self.selectBtu) {
        btn.selected = NO;
    }
    //清空选中的按钮
    [self.selectBtu removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

@end
