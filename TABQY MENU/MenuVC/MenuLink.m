#import "MenuLink.h"

@implementation MenuLink
+ (MenuLink *)instanceFromDictionary:(NSDictionary *)aDictionary {

    MenuLink *instance = [[MenuLink alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.itemColor = [aDictionary objectForKey:@"color_code"];
    self.image = [aDictionary objectForKey:@"image"];
    self.menuName = [aDictionary objectForKey:@"name"];
    self.menuId = [aDictionary objectForKey:@"id"];

}


@end
