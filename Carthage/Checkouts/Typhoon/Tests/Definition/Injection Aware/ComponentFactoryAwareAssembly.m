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

#import "ComponentFactoryAwareAssembly.h"
#import "TyphoonDefinition.h"
#import "ComponentFactoryAwareObject.h"
#import "Typhoon.h"

@implementation ComponentFactoryAwareAssembly

- (id)injectionAwareObject
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class]];
}

- (id)injectionFactoryByProperty
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(componentFactory) with:self];
    }];
}

- (id)injectionAssemblyByProperty
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(assembly) with:self];
    }];
}

- (id)injectionByInitialization
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithComponentFactory:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self];
        }];
    }];
}

- (id)injectionByPropertyAssemblyType
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(assembly)];
    }];
}

- (id)injectionByPropertyFactoryType
{
    return [TyphoonDefinition withClass:[ComponentFactoryAwareObject class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(componentFactory)];
    }];
}


@end

@implementation ComponentFactoryAwareCollabortingAssembly

- (id)collaboratingAssemblyObject {
    return [TyphoonDefinition withClass:[NSNumber class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(numberWithInt:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@1];
        }];
    }];
}

@end

@implementation AnotherComponentFactoryAwareCollabortingAssembly

- (id)anotherCollaboratingAssemblyObject {
    return [TyphoonDefinition withClass:[NSNumber class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(numberWithInt:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@2];
        }];
    }];
}

@end
