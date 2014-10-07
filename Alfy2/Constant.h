//
//  Constant.h
//  Alfy
//
//  Created by Ben Hambrecht on 06.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Term.h"

@interface Constant : NSObject <NSCoding, Term>

@property (nonatomic) float value;

@end