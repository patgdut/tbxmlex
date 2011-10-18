//
//  ParsingDemoAppDelegate.h
//  ParsingDemo
//
//  Created by Rafael Steil on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParsingDemoViewController;

@interface ParsingDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ParsingDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ParsingDemoViewController *viewController;

@end

