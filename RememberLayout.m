//
//  RememberLayout.m
//  remember_layout
//
//  Created by toy on 2014.12.13.
//  Copyright (c) 2014 Ivan Kuchin. All rights reserved.
//

#import "RememberLayout.h"

#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h>

@implementation RememberLayout

- (id)init {
  self = [super init];
  if (0 != self) {
    inputSources = [[NSMutableDictionary alloc] init];
  }

  [[[NSWorkspace sharedWorkspace] notificationCenter]
      addObserver:self
         selector:@selector(appDeactivated:)
             name:NSWorkspaceDidDeactivateApplicationNotification
           object:nil];

  TISInputSourceRef inputSourceRef =
      TISCopyCurrentASCIICapableKeyboardLayoutInputSource();
  if (inputSourceRef == nil) {
    inputSourceRef = TISCopyCurrentKeyboardLayoutInputSource();
  }
  if (inputSourceRef != nil) {
    defaultInputSource = [NSValue valueWithPointer:inputSourceRef];
  }

  NSString *excludePath =
      [NSHomeDirectory() stringByAppendingPathComponent:@".remember_layout.no"];
  NSString *excludeContents =
      [NSString stringWithContentsOfFile:excludePath
                                encoding:NSUTF8StringEncoding
                                   error:nil];
  if (excludeContents != nil) {
    excludeAppIds = [excludeContents componentsSeparatedByString:@"\n"];
  }

  return self;
}

- (void)appDeactivated:(NSNotification *)notification {
  NSString *deactivatedAppId = [[[notification userInfo]
      objectForKey:NSWorkspaceApplicationKey] bundleIdentifier];
  NSString *activatedAppId =
      [[[NSWorkspace sharedWorkspace] frontmostApplication] bundleIdentifier];

  if (deactivatedAppId != nil) {
    NSValue *previousInputSource = [inputSources objectForKey:deactivatedAppId];
    if (previousInputSource) {
      CFRelease([previousInputSource pointerValue]);
    }

    [inputSources
        setObject:
            [NSValue valueWithPointer:TISCopyCurrentKeyboardLayoutInputSource()]
           forKey:deactivatedAppId];
  }

  NSValue *newInputSource = [inputSources objectForKey:activatedAppId];
  if (newInputSource && (excludeAppIds == nil ||
                         ![excludeAppIds containsObject:activatedAppId])) {
    TISSelectInputSource([newInputSource pointerValue]);
  } else if (defaultInputSource) {
    TISSelectInputSource([defaultInputSource pointerValue]);
  }
}

@end
