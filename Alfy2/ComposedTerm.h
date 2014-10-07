//
//  ComposedTerm.h
//  Alfy2
//
//  Created by Ben Hambrecht on 25.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Term.h"

@interface ComposedTerm : NSObject <NSCoding, Term>

@property (nonatomic) NSMutableArray *parents;
@property (nonatomic) NSMutableString *operatorString;

- (instancetype)initWithParents:(NSArray *)parents andOperator:(NSString *)operatorString;


@end
