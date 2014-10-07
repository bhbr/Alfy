//
//  ArrowView.h
//  Alfy
//
//  Created by Ben Hambrecht on 28.03.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ArrowView : UIView

@property (nonatomic) NSMutableArray *lines;

- (void)addLinesFromFrames:(NSArray *)parentFrames toFrame:(CGRect)frame2;
- (void)drawArrows;

@end
