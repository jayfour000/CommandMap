//
//  Created by Jason Hanson on 3/5/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface GenericTestCommand : NSObject


- (void)execute;
- (void)executeWithNSString:(NSString *)string;
- (void)executeWithNSInteger:(NSInteger *)integer;
- (void)executeWithObject:(NSObject *)object;
- (void)executeWithNSArray:(NSArray *)array;



@end