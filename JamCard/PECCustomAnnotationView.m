//
//  CustomAnnotationView.m
//  CustomAnnotation
//
//  Created by akshay on 8/17/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import "PECCustomAnnotationView.h"
#import "PECAnnotation.h"

@implementation PECCustomAnnotationView{
    
    UIImage * imageViewBaloon;
    
}

@synthesize calloutView;
@synthesize conteinerView;


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch");
    UITouch *touch = [touches anyObject];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    PECAnnotation *ann = self.annotation;
    if(selected)
    {
        calloutView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"baloon.png"]];
        [calloutView setFrame:CGRectMake(-24, 35, 0, 0)];
        [calloutView sizeToFit];
        [self animateCalloutAppearance];
        conteinerView = [[UIView alloc] initWithFrame: CGRectMake(-30, -100, 50, 50)];
        
        UILabel * nickName = [[UILabel alloc] initWithFrame:CGRectMake(-10, 65, 100, 20)];
        nickName.font = [UIFont fontWithName:@"Helvetica" size:12];
        [nickName setTextColor:[UIColor orangeColor]];
        [nickName setText:ann.title];
        
        [conteinerView addSubview:calloutView];
        [conteinerView addSubview:nickName];
        
        [self addSubview:conteinerView];
        
    }else
    {
        [conteinerView removeFromSuperview];
    }
}

- (void)didAddSubview:(UIView *)subview{
    
    PECAnnotation *ann = self.annotation;
    //if (![ann.locationType isEqualToString:@"dropped"]) {
        if ([[[subview class] description] isEqualToString:@"UICalloutView"]) {
            for (UIView *subsubView in subview.subviews) {
                if ([subsubView class] == [UIImageView class]) {
                    UIImageView *imageView = ((UIImageView *)subsubView);
                    [imageView removeFromSuperview];
                }else if ([subsubView class] == [UILabel class]) {
                    UILabel *labelView = ((UILabel *)subsubView);
                    [labelView removeFromSuperview];
                }
            }
       // }
    }
}


- (void)animateCalloutAppearance {
    CGFloat scale = 0.001f;
    conteinerView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -50);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        CGFloat scale = 1.1f;
        conteinerView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGFloat scale = 0.95;
            conteinerView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                CGFloat scale = 1.0;
                conteinerView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
            } completion:nil];
        }];
    }];
}

@end
