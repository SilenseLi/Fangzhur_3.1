//
//  UncaughtExceptionHandler.h
//  Fangzhur
//
//  Created by --超-- on 14-9-10.
//  Copyright (c) 2014年 Fangzhur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject
<UIAlertViewDelegate>
{
    BOOL dismissed;
}

@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);