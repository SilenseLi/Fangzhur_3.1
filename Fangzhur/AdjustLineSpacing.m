//
//  AdjustLineSpacing.m
//  Fangzhur
//
//  Created by --超-- on 14/12/10.
//  Copyright (c) 2014年 Zc. All rights reserved.
//

#import "AdjustLineSpacing.h"

@implementation AdjustLineSpacing

+ (NSAttributedString *)adjustString:(NSString *)aString withLineSpacing:(CGFloat)spacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:spacing];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [aString length])];
    
    return attributedString;
}

@end
