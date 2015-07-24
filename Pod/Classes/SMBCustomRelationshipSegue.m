//
//  SMBCustomRelationshipSegue.m
//  Pods
//
//  Created by David Fu on 7/24/15.
//
//

#import "SMBCustomRelationshipSegue.h"
#import "UIViewController+SMBCustomRelationshipSegue.h"

#import <objc/runtime.h>

@implementation SMBCustomRelationshipSegue

- (void)perform {
    UIViewController *sourceViewControlelr = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    NSArray *relationShipComponents = [self.identifier componentsSeparatedByString:@"_"];
    NSString *relationShipName = relationShipComponents[1];
    if (relationShipComponents.count == 2) {
        [sourceViewControlelr setValue:destinationViewController forKey:relationShipName];
    }
    else if (relationShipComponents.count == 3) {
        NSArray *array = [sourceViewControlelr valueForKey:relationShipName];
        NSMutableArray *mutableArray = array? [NSMutableArray arrayWithArray:array]: [NSMutableArray array];
        [mutableArray addObject:destinationViewController];
        [sourceViewControlelr setValue:mutableArray forKey:relationShipName];
    }
}

@end
