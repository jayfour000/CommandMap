//
//  Test.m
//  esloop
//
//  Created by Jason Hanson on 03/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import "CommandMapTest.h"
#import "CommandMap.h"
#import "CommandInvocation.h"
#import "GenericTestCommand.h"

#import <UIKit/UIKit.h>




@interface CommandMapTest ()
- (CommandInvocation *)helper_buildCommandInvocationWith0Params;

- (CommandInvocation *)helper_buildCommandInvocationWith1Params;

- (CommandInvocation *)helper_buildCommandInvocationWith1ParamOfTypeNSString;


@end

@implementation CommandMapTest

//- (void) testEquals
//{
//    NSString  *theBiscuit = @"Ginger";
//    NSString *myBiscuit = @"Ginger";
//    assertThat(theBiscuit, equalTo(myBiscuit));
//}


- (void)setUp {
    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

// TODO: Look into OCHamcrest for better asserts

- (void)test_sharedSingleton_instanceCreated {
    CommandMap *sharedSingleton = [CommandMap sharedSingleton];
    STAssertNotNil(sharedSingleton, @"sharedSingleton is nil");
}

- (void)test_sharedSingleton_instanceCreatedOnlyOnce {
    CommandMap *sharedSingleton1 = [CommandMap sharedSingleton];
    CommandMap *sharedSingleton2 = [CommandMap sharedSingleton];
    STAssertEqualObjects(sharedSingleton1, sharedSingleton2, @"Multiple instances of sharedSingleton created by static accessor.");
}

- (void)test_mapCommand_nullInvocation_commandNotMapped {
    CommandMap *sharedSingleton = [CommandMap sharedSingleton];
    [sharedSingleton mapCommand:nil withKey:@"myTestKey001"];
    BOOL isCommandMappedToKey = [sharedSingleton hasCommandWithKey:@"myTestKey001"];
    STAssertFalse(isCommandMappedToKey, @"mapCommand called with nil invocation was mapped when it should not have been.");
}


- (void)test_mapCommand_nullKey_commandNotMapped {
    CommandMap *sharedSingleton = [CommandMap sharedSingleton];
    CommandInvocation *invocation = [self helper_buildCommandInvocationWith0Params];
    [sharedSingleton mapCommand:invocation withKey:nil];
    BOOL isCommandMappedToKey = [sharedSingleton hasCommandWithKey:nil];
    STAssertFalse(isCommandMappedToKey, @"mapCommand called with nil key was mapped when it should not have been.");
}

- (void)test_mapCommand_commandMapped {
    CommandMap *sharedSingleton = [CommandMap sharedSingleton];
    CommandInvocation *invocation2 = [self helper_buildCommandInvocationWith0Params];
    [sharedSingleton mapCommand:invocation2 withKey:@"myTestKey"];
    BOOL isCommandMappedToKey = [sharedSingleton hasCommandWithKey:@"myTestKey"];
    STAssertTrue(isCommandMappedToKey, @"mapCommand called and invocation was not mapped when it should have been.");
}


- (void)test_mapCommandWithOneParam_commandMapped {
    CommandMap *sharedSingleton = [CommandMap sharedSingleton];
    CommandInvocation *invocation2 = [self helper_buildCommandInvocationWith1ParamOfTypeNSString];
    [sharedSingleton mapCommand:invocation2 withKey:@"myTestKey"];
    BOOL isCommandMappedToKey = [sharedSingleton hasCommandWithKey:@"myTestKey"];
    STAssertTrue(isCommandMappedToKey, @"mapCommand called with one param and invocation was not mapped when it should have been.");
}


- (void)test_postNotificationWithOneArgument_argumentWasApplied{
    // First we have to map a notification to a selector
    CommandMap *sharedSingleton = [CommandMap sharedSingleton];
    CommandInvocation *invocation = [self helper_buildCommandInvocationWith1ParamOfTypeNSString];
    [sharedSingleton mapCommand:invocation withKey:@"myTestKey"];

    // Second set post a notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myTestKey"
                                                        object:[[NSArray alloc] initWithObjects:@"MyArgumentString",nil]];

    NSObject *arg;
    [invocation getArgument:&arg atIndex:2];

    STAssertEqualObjects(@"MyArgumentString", arg, @"Argument was not set on the CommandInvocation");
}

//- (void)test_postNotificationWithOneParam_selectorInvoked {
//
//    // Build a mock object
////    id mock = [OCMockObject mockForClass:[GenericTestCommand class]];
////    [[mock expect] executeWithNSString:@"MyArgumentString"];
//
//    id mock = [OCMockObject mockForClass:[CommandInvocation class]];
//    [mock stub]
//
//    // First we have to map a notification to a selector
//    CommandMap *sharedSingleton = [CommandMap sharedSingleton];
//    CommandInvocation *invocation = [sharedSingleton buildInvocationWithClassType:NSClassFromString(@"GenericTestCommand") withSelector:@selector(executeWithNSString:) andMapToKey:@"myTestKey02"];
//
////    [invocation get]
//
//    // Second set post a notification
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"myTestKey02"
//                                                        object:[[NSArray alloc] initWithObjects:@"MyArgumentString",nil]];
//
//
//    [mock verify];
//
////    STFail(@"TODO: Figure out how to mock my selector. OCMock may be the way to go.");
//
//}

- (NSString *)fakeSelector:foo {
    
    STAssertTrue(true, @"Fake selector called");
    
}





- (CommandInvocation *)helper_buildCommandInvocationWith0Params {
    NSMethodSignature *sig = [NSClassFromString(@"NSObject") instanceMethodSignatureForSelector:@selector(isProxy)];
    CommandInvocation *invocation = (CommandInvocation *) [CommandInvocation invocationWithMethodSignature:sig];

    return invocation;
}

- (CommandInvocation *)helper_buildCommandInvocationWith1Params {
    SEL selector = NSSelectorFromString(@"fakeSelector:");
    NSMethodSignature *sig = [NSClassFromString(@"NSObject") instanceMethodSignatureForSelector:selector];
    CommandInvocation *invocation = (CommandInvocation *) [CommandInvocation invocationWithMethodSignature:sig];
    [invocation setSelector:selector];

    return invocation;
}

- (CommandInvocation *)helper_buildCommandInvocationWith1ParamOfTypeNSString {
    SEL sel3 = NSSelectorFromString(@"executeWithNSString:");
    NSMethodSignature *sig = [NSClassFromString(@"GenericTestCommand") instanceMethodSignatureForSelector:sel3];

//    const char *argumentType = [sig getArgumentTypeAtIndex:2];


    CommandInvocation *invocation = (CommandInvocation *) [CommandInvocation invocationWithMethodSignature:sig];
    [invocation setSelector:sel3];

    return invocation;
}


- (CommandInvocation *)helper_buildCommandInvocationWith1ParamOfTypeNSArray {
    SEL sel4 =NSSelectorFromString(@"executeWithNSArray:");
    NSMethodSignature *signature = [NSClassFromString(@"GenericTestCommand") instanceMethodSignatureForSelector:sel4];
    CommandInvocation *invocation = (CommandInvocation *) [CommandInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:sel4];

    return invocation;
}

@end
