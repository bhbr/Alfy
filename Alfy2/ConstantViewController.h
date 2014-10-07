//
//  ConstantViewController.h
//  Alfy2
//
//  Created by Ben Hambrecht on 24.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "TermViewController.h"
#import "NumberpadViewController.h"
#import "Constant.h"

@interface ConstantViewController : TermViewController <UIPopoverControllerDelegate,
NumberpadVCDelegate>

@property (nonatomic) Constant *constant;
@property (nonatomic) id <TermUpdater> updaterDelegate;

- (instancetype)init;
- (instancetype)initWithConstant:(Constant *)initialConstant;
- (void)openNumberpad2;

@end

