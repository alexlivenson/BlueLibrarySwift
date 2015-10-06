////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2012 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>

@class ClassADependsOnB;


@interface ClassBDependsOnA : NSObject

- (ClassADependsOnB *)dependencyOnA;
- (void)setDependencyOnA:(ClassADependsOnB *)dependencyOnA;

@end
