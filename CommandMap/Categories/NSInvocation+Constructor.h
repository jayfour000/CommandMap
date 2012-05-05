//
//  Created by Jason Hanson on 2/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

// @see http://www.a-coding.com/2010/10/making-nsinvocations.html
@interface NSInvocation (Constructor)

// Returns an initialized invocation from a target and a selector.
+ (id)invocationWithTarget:(NSObject*)targetObject selector:(SEL)selector;

// Returns an invocation from a class and a selector. The selector property of the
// invocation is initialized but you still need to set the target before invoking it.
//+ (id)invocationWithClass:(Class)targetClass selector:(SEL)selector;

// Returns an invocation from a protocol and a selector. The selector property of the
// invocation is initialized but you still need to set the target before invoking it.
//+ (id)invocationWithProtocol:(Protocol*)targetProtocol selector:(SEL)selector;

@end