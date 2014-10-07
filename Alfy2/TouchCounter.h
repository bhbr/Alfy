//
//  TouchCounter.h
//  Toucher
//
//  Created by Ben Hambrecht on 02.10.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlfyViewController.h"

@interface TouchCounter : UIGestureRecognizer

@property (weak, nonatomic) id <TermSelectionHandler> delegate;

@end
