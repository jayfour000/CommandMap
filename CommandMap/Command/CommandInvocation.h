//
//  Created by Jason Hanson on 2/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "CommandProtocol.h"

@interface CommandInvocation : NSInvocation <CommandProtocol>


@property(nonatomic, retain) Class commandClassType;

@end