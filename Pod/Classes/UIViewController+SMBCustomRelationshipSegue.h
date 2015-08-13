//
//  UIViewController+SMBCustomRelationshipSegue.h
//  Pods
//
//  Created by David Fu on 7/23/15.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (SMBCustomRelationshipSegue)

/**
 
 overwrite point, you must overwrite this method to provide the relationships 
 to SMBCustomRelationshipSegue and you must consider the relationship order
 
 @return array of relationships
 */
- (NSArray *)relationships;

@end
