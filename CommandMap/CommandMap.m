//
//  Created by Jason Hanson on 2/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CommandMap.h"
#import "CommandInvocation.h"
//#import <objc/objc.h>
//#import <objc/objc-class.h>


@implementation CommandMap {

}

@synthesize commandMap;


// Implementation of the sharedSingleton method that returns, or creates and returns, the single shared instance of this class
// @see http://stackoverflow.com/questions/145154/what-does-your-objective-c-singleton-look-like
+ (CommandMap *)sharedSingleton {
    static CommandMap *sharedSingleton;

    @synchronized (self) {
        if (!sharedSingleton) {
            sharedSingleton = [[CommandMap alloc] init];
        }

        return sharedSingleton;
    }
}

- (id)init {
    self = [super init];

    // Overridden by child
    [self mapCommands];

    return self;
}

- (void)onNotification:(NSNotification *)notification {
    NSLog(@"notification caught with key: %@ ", notification.name);
    
    NSArray *arguments = [notification object];
    NSString *key = notification.name;
    
    CommandInvocation *commandInvocation = [commandMap objectForKey:key];
    [commandInvocation setTarget:[[[commandInvocation commandClassType] alloc] init]];
    
    // As a a debugging convenience check that the number of argument is correct
    int expectedArgumentCount = [[commandInvocation methodSignature] numberOfArguments] - 2;
    int sentArgumentCount = [arguments count];
    
    if (expectedArgumentCount != sentArgumentCount) {
        
        NSLog(@"The CommandInvocation with key %@ was send the incorrect number of arguments.  Expected %i by got %i ", key, expectedArgumentCount, sentArgumentCount);
        return; // Not enough arguments in the array
    }
    
    // should start at 2 since 0 and 1 is reserved _self and _cmd
    int i = 2; // start at 2. Index 1 & 2 are reserved.
    if (arguments) {
        for (NSObject *argument in arguments) {
            
            if (argument) {
                NSObject *arg = argument;
                [commandInvocation setArgument:&arg atIndex:i]; // TODO: figure out why I can't use 'argument' and need to create a pointer named arg
                i++;
            }
        }
    }

    // Invoke the command
    [commandInvocation invoke];

    
    // BUNCH OF TEST CODE BELOW HERE
    // Trying to check the type of the arguments. I have not solved this yet. 

    

    // Check argument types
    // TODO: Figure out how to use reflection to verify the TYPE of each argument

//    SEL *selector = [commandInvocation selector];
//
//    Method method = class_getInstanceMethod([commandInvocation commandClassType], selector);
//    Method method2 = class_getClassMethod([commandInvocation commandClassType], selector);

//    NSMethodSignature *signature = [commandInvocation methodSignature];
//
//    const char *argumentTypeAtIndex2 = [signature getArgumentTypeAtIndex:2];
//    Class myClass = nil;
//
//    if (!argumentTypeAtIndex2) {
//        return;
//    }



//    switch (argumentTypeAtIndex2[0]) {
//        case '@': // Is an object
//        {
//            char *className;
//
////            NSUInteger size,align;
////
////            IMP *imp = [signature methodForSelector:selector];
////            NSString *dataType = NSStringFromClass([class]);
////            const char *buffer = NSGetSizeAndAlignment(argumentTypeAtIndex2, size, align);
//
////            char junk1 = argumentTypeAtIndex2[1];
////            char junk2 = argumentTypeAtIndex2[2];
//
//            size_t argumentTypeAtIndex2Length = strlen(argumentTypeAtIndex2);
////            size_t argumentTypeAtIndex2Length_object = strlen(&argumentTypeAtIndex2);
//
////            size_t junkSize1 = sizeof(argumentTypeAtIndex2);
//
//            if (argumentTypeAtIndex2Length > 3) {
//                className = strndup(argumentTypeAtIndex2 + 2, strlen(argumentTypeAtIndex2) - 3);
//                myClass = NSClassFromString([NSString stringWithUTF8String:className]);
//            }
//
//            // Test class here
//
//            NSString *readableClassName = [myClass classNameForClass:[NSString class]];
//
//            if (readableClassName) {
//                NSLog(@"Paramater type is NSString");
//            }
//
//        }
//        default:
//        {
//            break;
//        }
//    }

//    free(argumentTypeAtIndex2);



//    NSLog(@"typeEncoding %s",typeEncoding);
//    NSLog(@"typeEncoding %s",[NSString stringWithUTF8String:typeEncoding]);
//
//    char *arg0 = method_copyArgumentType(method2, 0);
//    char *arg1 = method_copyArgumentType(method2, 1);
//    char *arg2 = method_copyArgumentType(method2, 2);
//
//    NSMethodSignature *signature = [commandInvocation methodSignature];
//
//    const char *argumentType0 = [signature getArgumentTypeAtIndex:0];
//    const char *argumentType1 = [signature getArgumentTypeAtIndex:1];
//    const char *argumentType2 = [signature getArgumentTypeAtIndex:2];


    
}

//@see http://stackoverflow.com/questions/2191594/how-to-send-and-receive-message-through-nsnotificationcenter-in-objective-c
- (void)addNotificationObserverForInvocation:(NSString *)key {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNotification:)
                                                 name:key
                                               object:nil];


}

- (void)mapCommand:(NSInvocation *)invocation
           withKey:(NSString *)key {
    if (!commandMap) {
        commandMap = [[NSMutableDictionary alloc] init];
    }

    if (!invocation || !key) {
        // Do not attempt to map if either parameter is nil
        return;
    }

    // Store in the map
    [commandMap setObject:invocation forKey:key];

    // Register to listen for Notification requests to execute the command
    [self addNotificationObserverForInvocation:key];
}

- (void)unMapCommand:(NSInvocation *)invocation
             withKey:(NSString *)key {
    if (!commandMap) {
        return;
    }

    [commandMap removeObjectForKey:key];
}

- (BOOL)hasCommand:(NSInvocation *)invocation
           withKey:(NSString *)key {
    if (!commandMap) {
        return NO;
    } else {
        return !([commandMap objectForKey:key] == nil);
    }
}

- (BOOL)hasCommandWithKey:(NSString *)key {
    if (!commandMap) {
        return NO;
    } else {
        return !([commandMap objectForKey:key] == nil);
    }
}

- (void)unMapAllCommands {
    if (!commandMap) {
        return;
    }

    [commandMap removeAllObjects];
}

- (CommandInvocation *)buildInvocationWithClassType:(Class)classType
                        withSelector:(SEL)selector
                         andMapToKey:(NSString *)key {
    NSMethodSignature *signature = [classType instanceMethodSignatureForSelector:selector];
    CommandInvocation *invocation = (CommandInvocation *) [CommandInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setCommandClassType:classType];

    [self mapCommand:invocation withKey:key];

    return invocation; // helper for unit testing
}

- (void)mapCommands {
    // To be overridden by class that extends this
}

- (void)unMapCommands {
    //TODO:
}


@end