//
//  MenuItemVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/04/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "MenuItemVC.h"
#import "ECSServiceClass.h"
#import "AppUserObject.h"
#import "ECSHelper.h"
#import "MenuItemCell.h"
#import "MenuLink.h"
#import "UIExtensions.h"
#import "MBProgressHUD.h"
#import "MenuCousineVC.h"
#import "PlaceOrderVC.h"
#import "SearchFoodVC.h"
@interface MenuItemVC (){
    NSMutableArray *arrMenuItem;
}
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;

@property(weak,nonatomic)IBOutlet UIImageView *menuImage;
@property(weak,nonatomic)IBOutlet UIImageView *headerImage;
@property(weak,nonatomic)IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@end

@implementation MenuItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrMenuItem=[[NSMutableArray alloc]init];
     // [self.viewTop setBackgroundColor:[JKSColor  colorwithHexString:self.appUserObject.resturantColor alpha:1.0]];
     [self settingTopView:self.viewTop onController:self andTitle:[NSString stringWithFormat:@"%@ Menu",self.appUserObject.resturantName] andImg:@"arrow-left.png"];
    [self.lblHeader setText:[NSString stringWithFormat:@"%@ Menu",self.appUserObject.resturantName]];
    
    [self.menuCollectionView  registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil]forCellWithReuseIdentifier:@"Cell"];
     NSLog(@"ttt %@",self.appUserObject.resturantMenuImage);
    if (self.appUserObject.resturantMenuImage ==(id)[NSNull null] ||[self.appUserObject.resturantMenuImage isEqualToString:@""]) {
        NSLog(@"ttt %@",self.appUserObject.resturantMenuImage);
        // [self.btnEdit setButtonTitle:@"Upload"];
        
    }else{
        [self.activityInd startAnimating];
        NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantMenuImage];
        [self.menuImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
            [self.activityInd stopAnimating];
         }];
        
        
    }
  //  self.menuImage.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"logo %@",self.appUserObject.resturantLogo);
    if (self.appUserObject.resturantLogo ==(id)[NSNull null] ||[self.appUserObject.resturantLogo isEqualToString:@""]) {
        NSLog(@"ttt %@",self.appUserObject.resturantLogo);
        // [self.btnEdit setButtonTitle:@"Upload"];
        
    }else{
       // [self.activityInd startAnimating];
        NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORANTLOGO,self.appUserObject.resturantLogo];
        [self.headerImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
              //[self.activityInd stopAnimating];
         }];
        
        
    }
   // [self.activityInd startAnimating];
    NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         //[self.activityInd stopAnimating];
     }];
    [self callMenu];
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)onClickBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)callMenu

{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url=[NSString stringWithFormat:@"%@menu",SERVERURLPATH];
//    NSString *emailfeild=@"harish";
//    NSString *passwordfeild=@"123456";
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]init];
    
    
    
    [request setURL:[NSURL URLWithString:url]];
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.appUserObject.resturantId, @"resturant_id",
                         
                          nil];//{"resturant_id":"8"}
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postdata];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *conn =[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(conn)
    {
        NSLog(@"Success");
        
        
        
    }
    else
    {
        NSLog(@"Error in connection");
        
    }
    recieveData= [[NSMutableData alloc]init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [recieveData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [recieveData appendData:data];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error %@",error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
    NSError *error;
    
    
    NSDictionary *responseDict = [NSDictionary new];
    responseDict = [NSJSONSerialization JSONObjectWithData:recieveData options:0 error:&error];
    NSLog(@"<---------->responseDict ==%@ ",responseDict);
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSString *success = [responseDict objectForKey:@"success"];
    
    NSArray *arr=[responseDict valueForKey:@"menu"];
    for (NSDictionary * dictionary in arr)
    {
        MenuLink  *object=[MenuLink instanceFromDictionary:dictionary];
        
        [arrMenuItem addObject:object];
    }
    NSLog(@"menuItem %@",arrMenuItem);
    [self.menuCollectionView reloadData];
    if ([[responseDict objectForKey:@"msg"] isEqualToString:@"Successfully LoggedIn"]) {

       
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else if ([success isEqualToString:@"false"]) {
        
        NSString *message = [responseDict objectForKey:@"message"];
        // [self showAlert:message];
        
        
    }else{
        
        
    }
}



//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView   viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footer" forIndexPath:indexPath];
//        
//        [headerView addSubview:_viewFooter];
//        reusableview = headerView;
//    }
//    return reusableview;
//}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return arrMenuItem.count;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(250, 250);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MenuItemCell *cell =
    (MenuItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                forIndexPath:indexPath];
    
    
    
    MenuLink * connectionObject = [arrMenuItem objectAtIndex:indexPath.row];
    NSString *strimage = connectionObject.image;
      NSString *imgurl=[NSString stringWithFormat:@"%@%@",MENUIMAGEURLPATH,connectionObject.image];
    
    if ([strimage isKindOfClass:[NSNull class]]) {
        cell.img_view.image = [UIImage imageNamed:@"Pasted image.png"];
        
    }
    else if([strimage isEqualToString:@""] ){
        cell.img_view.image = [UIImage imageNamed:@"Pasted image.png"];
    }
    else{
         [cell.activityInd startAnimating];
        [cell.img_view ecs_setImageWithURL:[NSURL URLWithString:[imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"User-image.png"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.activityInd stopAnimating];
            
        }];
        
    }
    
    [cell.viewBg setBackgroundColor:[JKSColor  colorwithHexString:connectionObject.itemColor alpha:1.0]];
    cell.lblName.text=connectionObject.menuName;
    
    [cell.lblName setFontKalra:13];
    [cell.lblCity setHidden:YES];
    
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    MenuLink * object = [arrMenuItem objectAtIndex:indexPath.item];
  
    MenuCousineVC *nav=[[MenuCousineVC alloc]initWithNibName:@"MenuCousineVC" bundle:nil];
    nav.menuId=object.menuId;
    nav.menuName=object.menuName;
    nav.addMoreSel=self.addMoreSelectedOrder;
    [self.navigationController pushViewController:nav animated:YES];
//    if ([object.url containsString:@"http"]) {
//        url =[NSString stringWithFormat:@"%@",object.url];
//        contentScreen = [[BC_WebPageVC alloc]initWithURL:url andTitle:object.label];
//        
//        if(contentScreen){
//            [self.sideMenuController.navigationController pushViewController:contentScreen animated:NO];
//            
//        }
//        
//    }else if([object.url isEqualToString:@""]){
//        // [ECSAlert showAlert:@"No website Available!"];
//        self.viewAlert.hidden=NO;
//        self.viewAlert.frame=CGRectMake(0, self.view.frame.size.height-75, 290, 70);
//        [self.view addSubview:self.viewAlert];
//        [self performSelector:@selector(dismissVC) withObject:self afterDelay:3.0];
//        
//    }else{
//        url =[NSString stringWithFormat:@"http://%@",object.url];
//        contentScreen = [[BC_WebPageVC alloc]initWithURL:url andTitle:object.label];
//        
//        if(contentScreen){
//            [self.sideMenuController.navigationController pushViewController:contentScreen animated:NO];
//            
//        }
//        
//    }
    
    
    
}


- (void)clickToOpenSearch:(id)sender{
    
    SearchFoodVC *spl=[[SearchFoodVC alloc ]initWithNibName:@"SearchFoodVC" bundle:nil];
    [self.navigationController pushViewController:spl animated:YES];
    
}

-(void)clickToPlaceOrderList:(id)sender{
    PlaceOrderVC *nav=[[PlaceOrderVC alloc]initWithNibName:@"PlaceOrderVC" bundle:nil];
    [self.navigationController pushViewController:nav animated:YES];
    
    NSLog(@"placeOrderClicked");
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
