//
//  AppUserObject.h
//  
//
//  Created by Shreesh Garg on 09/09/14.
//___COPYRIGHT___
//

#import <Foundation/Foundation.h>

@class LocationObject;

@interface AppUserObject : NSObject 

{
   


}
//"sidebar_active_color" = "<null>";
//"sidebar_color" = "<null>";

@property (nonatomic, copy) NSString *sidebarActiveColor;
@property (nonatomic, copy) NSString *sidebarColor;

@property (nonatomic, copy) NSString *codePhone;
@property (nonatomic, copy) NSString *resturantAaddress;
@property (nonatomic, copy) NSString *resturantBgImage;
@property (nonatomic, copy) NSString *resturantColor;
@property (nonatomic, copy) NSString *resturantCurrency;
@property (nonatomic, copy) NSString *resturantId;
@property (nonatomic, copy) NSString *resturantLogo;
@property (nonatomic, copy) NSString *resturantMenuImage;

@property (nonatomic, copy) NSString *resturantName;
@property (nonatomic, copy) NSString *resturantPhone;
@property (nonatomic, copy) NSString *resturantTagline;

@property (nonatomic, copy) NSString *user_id;



+ (AppUserObject *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
-(void)saveToUserDefault;
+(instancetype)getFromUserDefault;
+(void)removeFromUserDefault;
@end


