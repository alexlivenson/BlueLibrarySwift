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

#import <XCTest/XCTest.h>
#import "ComponentFactoryAwareObject.h"
#import "TyphoonBlockComponentFactory.h"
#import "ComponentFactoryAwareAssembly.h"

@interface TyphoonComponentFactoryAwareTests : XCTestCase

@end


@implementation TyphoonComponentFactoryAwareTests
{
    ComponentFactoryAwareObject *object;
    ComponentFactoryAwareAssembly *factory;
}

- (void)setUp
{
    factory = (id) [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[[ComponentFactoryAwareAssembly assembly], [ComponentFactoryAwareCollabortingAssembly assembly], [AnotherComponentFactoryAwareCollabortingAssembly assembly]]];
}

- (void)test_reference_to_assembly_set_on_injection_aware_object
{
    object = [factory injectionAwareObject];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_factory_injection_by_property
{
    object = [factory injectionFactoryByProperty];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_assembly_injection_by_property
{
    object = [factory injectionAssemblyByProperty];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_factory_injection_by_initialization
{
    object = [factory injectionFactoryByProperty];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_factory_injection_by_property_assembly_type
{
    object = [factory injectionByPropertyAssemblyType];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_factory_injection_by_property_factory_type
{
    object = [factory injectionByPropertyFactoryType];
    XCTAssertTrue(object.factory == factory);
}

- (void)test_factory_with_collaborating_assembly_vending_object {
    XCTAssertEqualObjects([(id) factory collaboratingAssemblyObject], @1);
    XCTAssertEqualObjects([(id) factory anotherCollaboratingAssemblyObject], @2);
}

@end
