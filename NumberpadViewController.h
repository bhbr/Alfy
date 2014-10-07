//
//  NumberpadViewController.h
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberpadVCDelegate

- (void)updateSelectedValueTo:(float)newValue;

@end


@interface NumberpadViewController : UIViewController

@property id <NumberpadVCDelegate> delegate;


@end
