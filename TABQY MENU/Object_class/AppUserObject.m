//
//  AppUserObject.m
//  
//
//  Created by Shreesh Garg on 09/09/14.
//___COPYRIGHT___
//

#define kAppUserObject          @"kAppUserObject"

#import "AppUserObject.h"
#import "Extentions.h"
#import "ECSHelper.h"

@implementation AppUserObject

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {

        self.codePhone=[decoder decodeObjectForKey:@"code_phone"];
        self.resturantAaddress =[decoder decodeObjectForKey:@"resturant_address"];
        self.resturantBgImage =[decoder decodeObjectForKey:@"resturant_background_image"];
        self.resturantColor =[decoder decodeObjectForKey:@"resturant_color"];
        self.resturantCurrency =[decoder decodeObjectForKey:@"resturant_currency"];
        self.resturantId =[decoder decodeObjectForKey:@"resturant_id"];
        self.resturantLogo =[decoder decodeObjectForKey:@"resturant_logo"];
        self.resturantMenuImage =[decoder decodeObjectForKey:@"resturant_menu_image"];
        
        self.resturantName =[decoder decodeObjectForKey:@"resturant_name"];
        self.resturantPhone =[decoder decodeObjectForKey:@"resturant_phone"];
        self.resturantTagline =[decoder decodeObjectForKey:@"resturant_tagline"];
        self.user_id =[decoder decodeObjectForKey:@"user_id"];
        
        self.sidebarActiveColor =[decoder decodeObjectForKey:@"sidebar_active_color"];
        self.sidebarColor =[decoder decodeObjectForKey:@"sidebar_color"];
        

        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //appLogicId
    [encoder encodeObject:self.codePhone forKey:@"code_phone"];
    [encoder encodeBool:self.resturantAaddress forKey:@"resturant_address"];
    [encoder encodeObject:self.resturantBgImage forKey:@"resturant_background_image"];
    [encoder encodeObject:self.resturantColor forKey:@"resturant_color"];
    
    
    [encoder encodeObject:self.resturantCurrency forKey:@"resturant_currency"];
    [encoder encodeObject:self.resturantId forKey:@"resturant_id"];
    [encoder encodeObject:self.resturantLogo forKey:@"resturant_logo"];
    [encoder encodeObject:self.resturantMenuImage forKey:@"resturant_menu_image"];
    [encoder encodeObject:self.resturantName forKey:@"resturant_name"];
    [encoder encodeObject:self.resturantPhone forKey:@"resturant_phone"];
    [encoder encodeObject:self.resturantTagline forKey:@"resturant_tagline"];
    [encoder encodeObject:self.user_id forKey:@"user_id"];
    
    [encoder encodeObject:self.sidebarActiveColor forKey:@"sidebar_active_color"];
    [encoder encodeObject:self.sidebarColor forKey:@"sidebar_color"];
   
    
  
    



}



+ (AppUserObject *)instanceFromDictionary:(NSDictionary *)aDictionary {

    AppUserObject *instance =  [[AppUserObject alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
   
    self.codePhone = [aDictionary nonNullObjectForKey:@"code_phone"];
    self.resturantAaddress=[aDictionary nonNullNumberForKey:@"resturant_address"];
    self.resturantBgImage = [aDictionary objectForKey:@"resturant_background_image"];
    
    self.resturantColor =[aDictionary objectForKey:@"resturant_color"];
    self.resturantCurrency =[aDictionary objectForKey:@"resturant_currency"];
    
    self.resturantId = [aDictionary objectForKey:@"resturant_id"];
    self.resturantLogo = [aDictionary objectForKey:@"resturant_logo"];
    self.resturantMenuImage = [aDictionary objectForKey:@"resturant_menu_image"];
    
    self.resturantName = [aDictionary nonNullNumberForKey:@"resturant_name"];
    self.resturantPhone = [aDictionary objectForKey:@"resturant_phone"];
    self.resturantTagline = [aDictionary objectForKey:@"resturant_tagline"] ;
    self.user_id = [aDictionary objectForKey:@"user_id"];
   
    self.sidebarActiveColor = [aDictionary objectForKey:@"sidebar_active_color"] ;
    self.sidebarColor = [aDictionary objectForKey:@"sidebar_color"];
    
  
    
    
    
    
}


-(void)saveToUserDefault
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [ECSUserDefault saveObject:data ToUserDefaultForKey:kAppUserObject];
}
+(instancetype)getFromUserDefault
{
    NSData * data = [ECSUserDefault getObjectFromUserDefaultForKey:kAppUserObject];
    return[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+(void)removeFromUserDefault
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kAppUserObject];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
