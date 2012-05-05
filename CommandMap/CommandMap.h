//
//  Created by Jason Hanson on 2/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "NotificationConstants.h"

@class CommandInvocation;
//#import <objc/objc.h>


@interface CommandMap : NSObject {

}

// Static variable that holds a Singleton instance of this Class
// @see http://stackoverflow.com/questions/145154/what-does-your-objective-c-singleton-look-like
+ (CommandMap *)sharedSingleton;


// Holds a list of NSInvocation objects
@property(nonatomic, retain) NSMutableDictionary *commandMap;

- (void)mapCommand:(NSInvocation *)invocation
           withKey:(NSString *)key;

- (void)unMapCommand:(NSInvocation *)invocation
             withKey:(NSString *)key;

- (BOOL)hasCommandWithKey:(NSString *)key;

- (BOOL)hasCommand:(NSInvocation *)invocation
           withKey:(NSString *)key;

- (void)unMapAllCommands;

- (CommandInvocation *)buildInvocationWithClassType:(Class)classType
                        withSelector:(SEL)selector
                         andMapToKey:(NSString *)key;

// Method to be overridden by subclass
- (void)mapCommands;

- (void)unMapCommands;




@end


