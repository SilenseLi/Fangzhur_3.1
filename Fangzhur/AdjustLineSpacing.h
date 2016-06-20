//
//  AdjustLineSpacing.h
//  Fangzhur
//
//  Created by --超-- on 14/12/10.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdjustLineSpacing : NSObject

+ (NSAttributedString *)adjustString:(NSString *)aString withLineSpacing:(CGFloat)spacing;

@end
