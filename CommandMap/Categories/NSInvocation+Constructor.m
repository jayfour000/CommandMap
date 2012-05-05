//
//  Created by Jason Hanson on 2/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSInvocation+Constructor.h"
//#import "GTMObjC2Runtime.h"

// @see http://www.a-coding.com/2010/10/making-nsinvocations.html
@implementation NSInvocation (Constructor)

+ (id)invocationWithTarget:(NSObject*)targetObject
                  selector:(SEL)selector {
    NSMethodSignature* signature = [targetObject methodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:targetObject];
    [invocation setSelector:selector];
    return invocation;
}

+ (id)invocationWithTarget:(NSObject*)targetObject
                  selector:(SEL)selector
                 arguments:(NSArray *)arguments {
    NSMethodSignature* signature = [targetObject methodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:targetObject];
    [invocation setSelector:selector];

    for (int i = 0; i < [arguments count]; i++) {
        int j = i + 2;
        // TODO: Test this. No clue if it will work or not ..
        NSObject * arg = [arguments objectAtIndex:i];
        [invocation setArgument:&arg atIndex:j];
    }
    
    return invocation;
}



//+ (id)invocationWithClass:(Class)targetClass selector:(SEL)selector {
//    Method method = class_getInstanceMethod(targetClass, selector);
//    struct objc_method_description* desc = method_getDescription(method);
//    if (desc == NULL || desc->name == NULL)
//        return nil;
//
//    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc->types];
//    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
//    [inv setSelector:selector];
//    return inv;
//}

//+ (id)invocationWithProtocol:(Protocol*)targetProtocol selector:(SEL)selector {
//    struct objc_method_description desc;
//    BOOL required = YES;
//    desc = protocol_getMethodDescription(targetProtocol, selector, required, YES);
//    if (desc.name == NULL) {
//        required = NO;
//        desc = protocol_getMethodDescription(targetProtocol, selector, required, YES);
//    }
//    if (desc.name == NULL)
//        return nil;
//
//    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc.types];
//    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
//    [inv setSelector:selector];
//    return inv;
//}

@end