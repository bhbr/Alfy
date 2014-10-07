//
//  VariableViewController.h
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "TermViewController.h"
#import "NumberpadViewController.h"
#import "Variable.h"
#import "AlfyViewController.h"


@interface VariableViewController : TermViewController <UIPopoverControllerDelegate,
    NumberpadVCDelegate>

@property (nonatomic) Variable *variable;
@property (nonatomic) id <TermUpdater> updaterDelegate;

- (instancetype)init;
- (instancetype)initWithVariable:(Variable *)initialVariable;

@end
