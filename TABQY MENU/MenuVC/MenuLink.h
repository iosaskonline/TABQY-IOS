#import <Foundation/Foundation.h>

@interface MenuLink : NSObject {
     NSString *itemColor;
    NSString *image;
    NSString *menuName;
    NSString *menuId;

}

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *itemColor;
@property (nonatomic, copy) NSString *menuName;
@property (nonatomic, copy) NSString *menuId;

+ (MenuLink *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
