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
    /* analyse segue identifier to get the relationship meta data */
    UIViewController *sourceViewControlelr = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    NSArray *relationShipComponents = [self.identifier componentsSeparatedByString:@"_"];
    NSString *relationShipName = relationShipComponents[1];
    /* relationship type depend on segue identifier's components count*/
    if (relationShipComponents.count == 2) {
        /* one to one */
        [sourceViewControlelr setValue:destinationViewController forKey:relationShipName];
    }
    else if (relationShipComponents.count == 3) {
        /* one to many */
        NSArray *array = [sourceViewControlelr valueForKey:relationShipName];
        NSMutableArray *mutableArray = array? [NSMutableArray arrayWithArray:array]: [NSMutableArray array];
        [mutableArray addObject:destinationViewController];
        [sourceViewControlelr setValue:mutableArray forKey:relationShipName];
    }
}

@end
