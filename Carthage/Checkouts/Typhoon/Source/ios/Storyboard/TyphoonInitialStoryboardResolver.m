////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonInitialStoryboardResolver.h"
#import "TyphoonStartup.h"
#import "TyphoonStoryboard.h"
#import <objc/runtime.h>

@implementation TyphoonInitialStoryboardResolver

+ (void)load
{
    NSString *initialStoryboardName = [self initialStoryboardName];

    if (initialStoryboardName.length > 0) {
        [self swizzleUIStoryboardWithName:initialStoryboardName];
    }
}

+ (void)swizzleUIStoryboardWithName:(NSString *)storyboardName
{
    SEL sel = @selector(storyboardWithName:bundle:);
    Method method = class_getClassMethod([UIStoryboard class], sel);

    id(*originalImp)(id, SEL, id, id) = (id (*)(id, SEL, id, id)) method_getImplementation(method);

    IMP adjustedImp = imp_implementationWithBlock(^id(id instance, NSString *name, NSBundle *bundle) {
        [TyphoonStartup requireInitialFactory];
        id initialFactory = [TyphoonStartup initialFactory];
        [TyphoonStartup releaseInitialFactory];
        if ([instance class] == [UIStoryboard class] && initialFactory && [name isEqualToString:storyboardName]) {
            return [TyphoonStoryboard storyboardWithName:name factory:initialFactory bundle:bundle];
        } else {
            return originalImp(instance, sel, name, bundle);
        }
    });

    method_setImplementation(method, adjustedImp);
}

+ (NSString *)initialStoryboardName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    NSString *defaultStoryboardName = infoDictionary[@"UIMainStoryboardFile"];

    if (!defaultStoryboardName) {
        defaultStoryboardName = infoDictionary[@"NSExtension"][@"NSExtensionMainStoryboard"];
    }

    return defaultStoryboardName;
}

@end