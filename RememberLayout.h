//
//  RememberLayout.h
//  remember_layout
//
//  Created by toy on 2014.12.13.
//  Copyright (c) 2014 Ivan Kuchin. All rights reserved.
//

@interface RememberLayout : NSObject {
  NSValue *defaultInputSource;
  NSMutableDictionary *inputSources;
  NSArray *excludeAppIds;
}

- (void)appDeactivated:(NSNotification *)notification;

@end
