//
//  UIViewController+SMBCustomRelationshipSegue.m
//  Pods
//
//  Created by David Fu on 7/23/15.
//
//

#import "UIViewController+SMBCustomRelationshipSegue.h"

#import <objc/runtime.h>

@implementation UIViewController (SMBCustomRelationshipSegue)

#pragma mark - life cycle

/** inject method awakeFromNib by method swizzlling on class load method invoked */
+ (void)load {
    SEL origSelector = @selector(awakeFromNib);
    SEL newSelector = @selector(smb_awakeFromNib);
    Method origMethod = class_getInstanceMethod(self, origSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    if(class_addMethod(self, origSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(self, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

/** private awakeFromNib */
- (void)smb_awakeFromNib {
    NSArray *realationshipsArray = [self relationships];
    if (realationshipsArray && realationshipsArray.count) {
        [self setOriginalIMPDictionary:[[NSMutableDictionary alloc] init]];
        for (NSString *propertyName in realationshipsArray) {
            /* get property class for each property name */
            objc_property_t theProperty = class_getProperty([self class], [propertyName UTF8String]);
            const char * propertyAttrs = property_getAttributes(theProperty);
            NSString * typeString = [NSString stringWithUTF8String:propertyAttrs];
            NSArray * attributes = [typeString componentsSeparatedByString:@","];
            NSString * typeAttribute = [attributes objectAtIndex:0];
            NSString * propertyType = [typeAttribute substringWithRange:NSMakeRange(3, typeAttribute.length - 4)];
            Class propertyClass = NSClassFromString(propertyType);
            
            /* save the implementation of property's getter method */
            Method propertyMethod = class_getInstanceMethod([self class], NSSelectorFromString(propertyName));
            IMP propertyIMP = method_getImplementation(propertyMethod);
            [self originalIMPDictionary][propertyName] = [NSValue valueWithPointer:propertyIMP];
            
            /* go to different handle logic depends on relationship's class */
            if ([propertyClass isSubclassOfClass:[NSArray class]]) {
                /* one to many relationship */
                Method method = class_getInstanceMethod([self class], @selector(smb_oneToManyRelationShip));
                IMP imp = method_getImplementation(method);
                
                method_setImplementation(propertyMethod, imp);
            }
            else if ([propertyClass isSubclassOfClass:[UIViewController class]]) {
                /* one to one relationship */
                Method method = class_getInstanceMethod([self class], @selector(smb_oneToOneRelationShip));
                IMP imp = method_getImplementation(method);
                
                method_setImplementation(propertyMethod, imp);
            }
            else {
                // maybe there is other relationship
            }
        }
    }
    else {
        
    }
    
    /* call the origin method awakeFromNib */
    [self smb_awakeFromNib];
}

#pragma mark - delegate methods

#pragma mark - event response

#pragma mark - private methods

/** reset selector implementation to its origin version and return the selector's string */
- (NSString *)selectorStringAndResetSelector:(SEL)selector {
    NSString *selectorString = NSStringFromSelector(selector);
    IMP originalIMP = [[self originalIMPDictionary][selectorString] pointerValue];
    Method propertyMethod = class_getInstanceMethod([self class], selector);
    method_setImplementation(propertyMethod, originalIMP);
    [[self originalIMPDictionary] removeObjectForKey:selectorString];
    return selectorString;
}

/** one to one relationship handle logic */
- (UIViewController *)smb_oneToOneRelationShip {
    NSString *selectorString = [self selectorStringAndResetSelector:_cmd];
    
    NSString *segueIdentifier = [NSString stringWithFormat:@"relationship_%@", selectorString];
    NSLog(@"%@", segueIdentifier);
    [self performSegueWithIdentifier:segueIdentifier sender:self];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:_cmd];
#pragma clang diagnostic pop
}

/** one to many relationship handle logic */
- (NSArray *)smb_oneToManyRelationShip {
    NSString *selectorString = [self selectorStringAndResetSelector:_cmd];
    
    BOOL flag = YES;
    NSUInteger index = 0;
    while (flag) {
        NSString *segueIdentifier = [NSString stringWithFormat:@"relationship_%@_%lu", selectorString, (unsigned long)index];
        /* 
         use perform segue to try relationship one by one until an exception to indicate
         it reach the end
         */
        @try {
            [self performSegueWithIdentifier:segueIdentifier sender:self];
        }
        @catch (NSException *exception) {
            if (exception.name == NSInvalidArgumentException) {
                flag = NO;
            }
            else {
                // TODO
            }
        }
        @finally {
            index ++;
        }
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:_cmd];
#pragma clang diagnostic pop
}

#pragma mark - accessor methods

- (void)setOriginalIMPDictionary:(NSMutableDictionary *)originalIMPDictionary {
    objc_setAssociatedObject(self, @selector(originalIMPDictionary), originalIMPDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)originalIMPDictionary {
    return objc_getAssociatedObject(self, @selector(originalIMPDictionary));
}

- (void)setRelationShipsArray:(NSArray *)relationShipsArray {
    objc_setAssociatedObject(self, @selector(relationShipsArray), relationShipsArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)relationShipsArray {
    return objc_getAssociatedObject(self, @selector(relationShipsArray));
}

#pragma mark - api methods

- (NSArray *)relationships {
    return nil;
}

@end
