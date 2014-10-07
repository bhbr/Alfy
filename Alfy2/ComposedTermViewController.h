//
//  ComposedTermViewController.h
//  Alfy2
//
//  Created by Ben Hambrecht on 25.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "ComposedTerm.h"
#import "TermViewController.h"

@interface ComposedTermViewController : TermViewController

@property (nonatomic) ComposedTerm *composedTerm;

- (instancetype)initWithComposedTerm:(ComposedTerm *)initialComposedTerm;
@end
