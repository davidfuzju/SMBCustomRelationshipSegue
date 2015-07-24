//
//  ContainerViewControllerDelegate.m
//  SMBRelationShipSegue
//
//  Created by David Fu on 7/24/15.
//  Copyright (c) 2015 David Fu. All rights reserved.
//

#import "ContainerDelegate.h"
#import "Animator.h"

@implementation ContainerDelegate

- (id<UIViewControllerAnimatedTransitioning>)containerViewController:(ContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    return [[Animator alloc] init];
}

@end
