//
//  UIViewController+SMBCustomRelationshipSegue.m
//  Pods
//
//  Created by David Fu on 7/23/15.
//
//

#import "UIViewController+SMBCustomRelationshipSegue.h"

#import <objc/runtime.h>

@implementation NSObject (SMBSwizzling)

+ (void)smb_swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector {
}

@end

@implementation UIViewController (SMBCustomRelationshipSegue)

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

- (NSArray *)relationships {
    return nil;
}

+ (void)load {
    SEL origSelector = @selector(viewDidLoad);
    SEL newSelector = @selector(smb_viewDidLoad);
    Method origMethod = class_getInstanceMethod(self, origSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    if(class_addMethod(self, origSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(self, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

- (void)smb_viewDidLoad {
    NSArray *realationshipsArray = [self relationships];
    if (realationshipsArray && realationshipsArray.count) {
        [self setOriginalIMPDictionary:[[NSMutableDictionary alloc] init]];
        for (NSString *propertyName in realationshipsArray) {
            objc_property_t theProperty = class_getProperty([self class], [propertyName UTF8String]);
            const char * propertyAttrs = property_getAttributes(theProperty);
            NSString * typeString = [NSString stringWithUTF8String:propertyAttrs];
            NSArray * attributes = [typeString componentsSeparatedByString:@","];
            NSString * typeAttribute = [attributes objectAtIndex:0];
            NSString * propertyType = [typeAttribute substringWithRange:NSMakeRange(3, typeAttribute.length - 4)];
            Class propertyClass = NSClassFromString(propertyType);
            
            Method propertyMethod = class_getInstanceMethod([self class], NSSelectorFromString(propertyName));
            IMP propertyIMP = method_getImplementation(propertyMethod);
            [self originalIMPDictionary][propertyName] = [NSValue valueWithPointer:propertyIMP];
            
            if ([propertyClass isSubclassOfClass:[NSArray class]]) {
                Method method = class_getInstanceMethod([self class], @selector(smb_oneToManyRelationShip));
                IMP imp = method_getImplementation(method);
                
                method_setImplementation(propertyMethod, imp);
            }
            else if ([propertyClass isSubclassOfClass:[UIViewController class]]) {
                Method method = class_getInstanceMethod([self class], @selector(smb_oneToOneRelationShip));
                IMP imp = method_getImplementation(method);
                
                method_setImplementation(propertyMethod, imp);
            }
            else {
                //TODO
            }
        }
    }
    else {
            
    }

    [self smb_viewDidLoad];
}

- (NSString *)selectorStringAndResetSelector:(SEL)selector {
    NSString *selectorString = NSStringFromSelector(selector);
    IMP originalIMP = [[self originalIMPDictionary][selectorString] pointerValue];
    Method propertyMethod = class_getInstanceMethod([self class], selector);
    method_setImplementation(propertyMethod, originalIMP);
    [[self originalIMPDictionary] removeObjectForKey:selectorString];
    return selectorString;
}

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

- (NSArray *)smb_oneToManyRelationShip {
    NSString *selectorString = [self selectorStringAndResetSelector:_cmd];

    BOOL flag = YES;
    NSUInteger index = 0;
    while (flag) {
        NSString *segueIdentifier = [NSString stringWithFormat:@"relationship_%@_%u", selectorString, index];
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

@end
