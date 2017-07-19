//
//  PrintInvoiceVC.m
//  TABQY MENU
//
//  Created by ASK ONLINE  on 01/06/17.
//  Copyright © 2017 ASK ONLINE . All rights reserved.
//

#import "PrintInvoiceVC.h"
#import "AppUserObject.h"
#import "UIExtensions.h"
#import "ECSServiceClass.h"
#import "MenuItemVC.h"
#import "ECSHelper.h"
#import "UIExtensions.h"
#import "MBProgressHUD.h"
#import "PrintTableCell.h"
#import "FoodObject.h"
#import "PrintTaxTableCell.h"
#import "FeedBackVC.h"
#import "ShowMsg.h"

#define KEY_RESULT                  @"Result"
#define KEY_METHOD                  @"Method"
#define PAGE_AREA_HEIGHT    500
#define PAGE_AREA_WIDTH     500
#define FONT_A_HEIGHT       24
#define FONT_A_WIDTH        12
#define BARCODE_HEIGHT_POS  70
#define BARCODE_WIDTH_POS   110


@interface PrintInvoiceVC ()<Epos2PtrReceiveDelegate>
{
    CGFloat subtotalPrice;
    CGFloat totaltaxPrice;
    CGFloat discountPrice;
    int totalFoodCount;
}

@property(strong,nonatomic)IBOutlet UIView *viewHeader;
@property(strong,nonatomic)IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UITableView  *tblContacts;

@property(weak,nonatomic)IBOutlet UILabel *lblReceipt;
@property(strong,nonatomic)NSMutableArray *arrayFood;
@property(strong,nonatomic)NSMutableArray *arrayTax;

@property(weak,nonatomic)IBOutlet UILabel *lblDate;
@property(weak,nonatomic)IBOutlet UILabel *lblTable;
@property(weak,nonatomic)IBOutlet UILabel *lblWaiterName;

@property(weak,nonatomic)IBOutlet UIImageView *imglogo;
@property(weak,nonatomic)IBOutlet UIView *viewTop;
@property(weak,nonatomic)IBOutlet UIImageView *restorentBGImage;
@property(weak,nonatomic)IBOutlet UILabel *lblTotalAmount;
@property(weak,nonatomic)IBOutlet UILabel *lblDiscountAmount;
@property(weak,nonatomic)IBOutlet UILabel *lblTotalPayableAmount;
@property(weak,nonatomic)IBOutlet UILabel *lblDiscount;
@property(weak,nonatomic)IBOutlet UILabel *lblTableName;
@end

@implementation PrintInvoiceVC
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        printer_ = nil;
        printerSeries_ = EPOS2_TM_M10;
        lang_ = EPOS2_MODEL_ANK;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    totalFoodCount=0;
    printerList_ = [[PickerTableView alloc] init];
//    if ([self.selectedPrinter isEqualToString:@"kitchen"]) {
//        NSString *kitchenPrinter=[ECSUserDefault getStringFromUserDefaultForKey:@"selectedPrinterForKitchen"];
//        
//        self.textTarget=kitchenPrinter;
//    }else{
//        NSString *cashierPrinter=[ECSUserDefault getStringFromUserDefaultForKey:@"selectedPrinterForCashier"];
//        
//        self.textTarget=cashierPrinter;
//    }
//    if (self.textTarget.length) {
//        self.buttonDiscovery.backgroundColor =[UIColor lightGrayColor];
//        
//    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:NSLocalizedString(@"printerseries_m10", @"")];
    [items addObject:NSLocalizedString(@"printerseries_m30", @"")];
    [items addObject:NSLocalizedString(@"printerseries_p20", @"")];
    [items addObject:NSLocalizedString(@"printerseries_p60", @"")];
    [items addObject:NSLocalizedString(@"printerseries_p60ii", @"")];
    [items addObject:NSLocalizedString(@"printerseries_p80", @"")];
    [items addObject:NSLocalizedString(@"printerseries_t20", @"")];
    [items addObject:NSLocalizedString(@"printerseries_t60", @"")];
    [items addObject:NSLocalizedString(@"printerseries_t70", @"")];
    [items addObject:NSLocalizedString(@"printerseries_t81", @"")];
    [items addObject:NSLocalizedString(@"printerseries_t82", @"")];
    [items addObject:NSLocalizedString(@"printerseries_t83", @"")];
    [items addObject:NSLocalizedString(@"printerseries_t88", @"")];
    [items addObject:NSLocalizedString(@"printerseries_t90", @"")];
    [items addObject:NSLocalizedString(@"printerseries_t90kp", @"")];
    [items addObject:NSLocalizedString(@"printerseries_u220", @"")];
    [items addObject:NSLocalizedString(@"printerseries_u330", @"")];
    [items addObject:NSLocalizedString(@"printerseries_l90", @"")];
    [items addObject:NSLocalizedString(@"printerseries_h6000", @"")];
    
    [printerList_ setItemList:items];
    [_buttonPrinter setTitle:[printerList_ getItem:0] forState:UIControlStateNormal];
    printerList_.delegate = self;
    
    langList_ = [[PickerTableView alloc] init];
    items = [[NSMutableArray alloc] init];
    [items addObject:NSLocalizedString(@"language_ank", @"")];
    [items addObject:NSLocalizedString(@"language_japanese", @"")];
    [items addObject:NSLocalizedString(@"language_chinese", @"")];
    [items addObject:NSLocalizedString(@"language_taiwan", @"")];
    [items addObject:NSLocalizedString(@"language_korean", @"")];
    [items addObject:NSLocalizedString(@"language_thai", @"")];
    [items addObject:NSLocalizedString(@"language_southasia", @"")];
    
    [langList_ setItemList:items];
    [_buttonLang setTitle:[langList_ getItem:0] forState:UIControlStateNormal];
    langList_.delegate = self;
    
    _textWarnings.text = @"";
    
    [self setDoneToolbar];
    
    int result = [Epos2Log setLogSettings:EPOS2_PERIOD_TEMPORARY output:EPOS2_OUTPUT_STORAGE ipAddress:nil port:0 logSize:1 logLevel:EPOS2_LOGLEVEL_LOW];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"setLogSettings"];
    }

    
    
    
    
    
    subtotalPrice=0;
    totaltaxPrice=0;
    
    if ([self.selectedPrinter isEqualToString:@"kitchen"]) {
        NSString *scrName=[NSString stringWithFormat:@"%@ Kitchen Print",self.appUserObject.resturantName];
        [self settingTopView:self.viewTop onController:self andTitle:scrName andImg:@"arrow-left.png"];
    }else{
        NSString *scrName=[NSString stringWithFormat:@"%@ Cashier Print",self.appUserObject.resturantName];
        [self settingTopView:self.viewTop onController:self andTitle:scrName andImg:@"arrow-left.png"];

    }
    
    //@"restorentgp.jpg"
    UIImage *img=[UIImage imageWithName:@"restorentgp.jpg"];
   // NSString *imgurl=[NSString stringWithFormat:@"%@%@",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    NSString *imgurl;
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    
    if (selectedIp.length) {
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",selectedIp,RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }else{
        imgurl=[NSString stringWithFormat:@"http://%@%@%@",@"tabqy.com",RESTORENTBGIMAGE,self.appUserObject.resturantBgImage];
    }
    [self.restorentBGImage ecs_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:img options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }];
    
    self.tblContacts.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tblContactsAlert.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tblContacts.tableHeaderView=self.viewHeader;
    self.tblContacts.tableFooterView=self.viewFooter;
    // Do any additional setup after loading the view from its nib.
    [self startServiceToGetInvoice];
}

- (void)setDoneToolbar
{
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    [doneToolbar sizeToFit];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneKeyboard:)];
    
    NSMutableArray *items = [NSMutableArray arrayWithObjects:space, doneButton, nil];
    [doneToolbar setItems:items animated:YES];
   // _textTarget.inputAccessoryView = doneToolbar;
}

- (void)doneKeyboard:(id)sender
{
  //  [_textTarget resignFirstResponder];
}






-(void)startServiceToGetInvoice
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetInvoice) withObject:nil];
    
}

-(void)serviceToGetInvoice
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
     NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if ([self.selectedPrinter isEqualToString:@"kitchen"]) {
       
        if (selectedIp.length) {
            [class setServiceURL:[NSString stringWithFormat:@"http://%@%@kitchen_print",selectedIp,SERVERURLPATH]];
        }else{
            [class setServiceURL:[NSString stringWithFormat:@"http://%@%@kitchen_print",@"tabqy.com",SERVERURLPATH]];
        }
        // [class setServiceURL:[NSString stringWithFormat:@"%@kitchen_print",SERVERURLPATH]];
    }else{
        
        if (selectedIp.length) {
            [class setServiceURL:[NSString stringWithFormat:@"http://%@%@invoice",selectedIp,SERVERURLPATH]];
        }else{
            [class setServiceURL:[NSString stringWithFormat:@"http://%@%@invoice",@"tabqy.com",SERVERURLPATH]];
        }
        // [class setServiceURL:[NSString stringWithFormat:@"%@invoice",SERVERURLPATH]];
    }
   
    NSMutableDictionary *dict;
    if (self.orderNumber.length) {
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     self.orderNumber, @"order_no",
                                     nil];
    }else{
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self.orderObj.orderNum, @"order_no",
                                 nil];
    }
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetInvoice:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetInvoice:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid)
    {
        discountPrice=0;
        self.arrayTax=[[NSMutableArray alloc]init];
        self.arrayFood=[[NSMutableArray alloc]init];
        NSArray *arr=[rootDictionary valueForKey:@"food_details"];
        self.arrayTax=[rootDictionary valueForKey:@"tax_type"];
        NSString *totalValue=[rootDictionary valueForKey:@"sub_total"];
        NSString *totalTaxValue=[rootDictionary valueForKey:@"tax_total"];
        subtotalPrice=totalValue.floatValue;
        totaltaxPrice=(totalTaxValue.floatValue + subtotalPrice);
        NSString *couponDiscount=[[rootDictionary objectForKey:@"coupon"] valueForKey:@"coupon_discount"];
        discountPrice=totaltaxPrice*couponDiscount.floatValue/100;
        self.lblTotalAmount.text=[NSString stringWithFormat:@"%.2f %@",totaltaxPrice,self.appUserObject.resturantCurrency];
        self.lblDiscount.text=[NSString stringWithFormat:@"Discount %@ %@ %@",@"@",[[rootDictionary objectForKey:@"coupon"] valueForKey:@"coupon_discount"],@"%"];
       
        
        self.lblDiscountAmount.text=[NSString stringWithFormat:@"- %.2f %@",discountPrice,self.appUserObject.resturantCurrency];
        self.lblTotalPayableAmount.text=[NSString stringWithFormat:@"%.2f %@",totaltaxPrice-discountPrice,self.appUserObject.resturantCurrency];
       // [ECSToast showToast:[rootDictionary valueForKey:@"msg"] view:self.view];
        for (NSDictionary * dictionary in arr)
        {
            
            FoodObject  *object=[FoodObject instanceFromDictionary:dictionary];
            
            [self.arrayFood addObject:object];
            totalFoodCount=totalFoodCount+object.foodqty.intValue;
            if (object.associatedFood.count) {
                 NSArray *arr2=object.associatedFood;
                for (NSDictionary * assoDict in arr2){
                FoodObject  *object=[FoodObject instanceFromDictionary:assoDict];
                 totalFoodCount=totalFoodCount+object.foodqty.intValue;
                [self.arrayFood addObject:object];
                }
            }
        }
        
        NSLog(@" self.arrayFood %@",self.arrayFood);
        [self.tblContacts reloadData];

        
        NSDictionary *dict=[rootDictionary objectForKey:@"invoice"];
        
        self.lblReceipt.text=[NSString stringWithFormat:@"Receipt No. : %@",[dict objectForKey:@"order_no"]];
        self.lblDate.text=[NSString stringWithFormat:@"     Date        : %@ %@",[dict objectForKey:@"order_date"],[dict objectForKey:@"order_time"]];
        self.lblTable.text=[NSString stringWithFormat:@"     Table       : %@",[dict objectForKey:@"table_name"]];
        if ([[dict objectForKey:@"table_name"] isKindOfClass:[NSNull class]]) {
            self.lblTable.text=@"Home Delivery";
        }
        
        self.lblWaiterName.text=[NSString stringWithFormat:@"Served By    : %@",[dict objectForKey:@"waiter_name"]];
    }
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
        return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return self.arrayFood.count;
    }else{
        return self.arrayTax.count;
    }

      //  return self.arrayFood.count;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//   
//        return 240.0;
//    
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    
//    return 440.0;
//    
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(350, 0, 100, 40)];
    lbl.text=@"Sub Total";
    lbl.textColor=[UIColor whiteColor];
    UILabel *lbl2=[[UILabel alloc]initWithFrame:CGRectMake(600, 0, 398, 40)];
//    lbl2.text=[NSString stringWithFormat:@"        %d                                         %.2f %@",totalFoodCount,subtotalPrice,self.appUserObject.resturantCurrency];
    
    lbl2.text=[NSString stringWithFormat:@"%.2f %@",subtotalPrice,self.appUserObject.resturantCurrency];
    //[lbl2 setFont:[UIFont systemFontOfSize:20]];
    lbl2.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
lbl2.textAlignment = NSTextAlignmentRight;
  //  [lbl setFont:[UIFont systemFontOfSize:20]];
    lbl2.textColor=[UIColor whiteColor];
    if (tableView == self.tblContacts){
        if (section == 1)
        {
            [headerView addSubview:lbl];
            [headerView addSubview:lbl2];
            [headerView setBackgroundColor:[UIColor colorWithRed:(65/255.0) green:(187/255.0) blue:(211/255.0) alpha:1]];
        }
    }
    return headerView;
}
//
//
//- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
//    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, tableView.bounds.size.width, 30)];
//    lbl.text=@"Member List";
//    lbl.textColor=[UIColor whiteColor];
//    
//   
//            [headerView addSubview:self.viewFooter];
//           // [headerView setBackgroundColor:[UIColor colorWithRed:(65/255.0) green:(187/255.0) blue:(211/255.0) alpha:1]];
//    
//    return headerView;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 45;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
     
   
            static NSString *CellIdentifier = @"Cell";
            PrintTableCell *cell = (PrintTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            FoodObject * groupObject = [self.arrayFood objectAtIndex:indexPath.row];
            
            if(!cell){
                UINib *nib = [UINib nibWithNibName:@"PrintTableCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.lblItemQty setText:[NSString stringWithFormat:@"%@",groupObject.foodqty]];
        
           // [cell.lblItemPrice setText:[NSString stringWithFormat:@"%@ %.2f",self.appUserObject.resturantCurrency,groupObject.price.floatValue/groupObject.foodqty.intValue]];
//            [cell.lblItemTotalPrice setText:[NSString stringWithFormat:@"%@ %.2f",self.appUserObject.resturantCurrency,groupObject.price.floatValue]];
        NSString *SingleitemPrice=[NSString stringWithFormat:@"%.2f",groupObject.price.floatValue/groupObject.foodqty.intValue];

        if (SingleitemPrice.length==4){
            SingleitemPrice=[NSString stringWithFormat:@"          %.2f %@",SingleitemPrice.floatValue,self.appUserObject.resturantCurrency];
        }else if (SingleitemPrice.length==5){
            SingleitemPrice=[NSString stringWithFormat:@"      %.2f %@",SingleitemPrice.floatValue,self.appUserObject.resturantCurrency];
        }else if (SingleitemPrice.length==6){
            SingleitemPrice=[NSString stringWithFormat:@"    %.2f %@",SingleitemPrice.floatValue,self.appUserObject.resturantCurrency];
        }else if (SingleitemPrice.length==7){
            SingleitemPrice=[NSString stringWithFormat:@"  %.2f %@",SingleitemPrice.floatValue,self.appUserObject.resturantCurrency];
        }
        else if (SingleitemPrice.length==8){
            SingleitemPrice=[NSString stringWithFormat:@" %.2f %@",SingleitemPrice.floatValue,self.appUserObject.resturantCurrency];
        }
        
        cell.lblItemPrice.text=SingleitemPrice;
       // [cell.lblItemPrice setText:[NSString stringWithFormat:@"%@",SingleitemPrice]];
        
        
        NSString *totalitemPrice=[NSString stringWithFormat:@"%.2f",groupObject.price.floatValue];
       
       if (totalitemPrice.length==4){
            totalitemPrice=[NSString stringWithFormat:@"         %.2f %@",groupObject.price.floatValue,self.appUserObject.resturantCurrency];
        }else if (totalitemPrice.length==5){
            totalitemPrice=[NSString stringWithFormat:@"     %.2f %@",groupObject.price.floatValue,self.appUserObject.resturantCurrency];
        }else if (totalitemPrice.length==6){
            totalitemPrice=[NSString stringWithFormat:@"   %.2f %@",groupObject.price.floatValue,self.appUserObject.resturantCurrency];
        }else if (totalitemPrice.length==7){
            totalitemPrice=[NSString stringWithFormat:@" %.2f %@",groupObject.price.floatValue,self.appUserObject.resturantCurrency];
        }
        else if (totalitemPrice.length==8){
            totalitemPrice=[NSString stringWithFormat:@"%.2f %@",groupObject.price.floatValue,self.appUserObject.resturantCurrency];
        }
        
        
              // NSString *singlePriceString = [singleitemPrice substringToIndex:8];
        cell.lblItemTotalPrice.text=totalitemPrice;
        
        
        
        
        
            [cell.lblItemName setText:[NSString stringWithFormat:@"%@",groupObject.foodName]];
        
            return cell;
    
        
    }else{
        static NSString *CellIdentifier = @"Cell2";
        PrintTaxTableCell *cell2 = (PrintTaxTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSDictionary * dict = [self.arrayTax objectAtIndex:indexPath.row];
       
        if(!cell2){
            UINib *nib = [UINib nibWithNibName:@"PrintTaxTableCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
         cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *taxvalue=[dict valueForKey:@"tax_amount"];
        
        [cell2.lbltaxType setText:[NSString stringWithFormat:@"%@ %@ %@ %@",[dict valueForKey:@"tax_name"],@"@",[dict valueForKey:@"tax_value"],@"%"]];
       // [cell2.lblTaxValue setText:[NSString stringWithFormat:@"%@ %.2f",self.appUserObject.resturantCurrency,taxvalue.floatValue]];
        NSString *taxPrice=[NSString stringWithFormat:@"%.2f",taxvalue.floatValue];
        
        if (taxPrice.length==3) {
            taxPrice=[NSString stringWithFormat:@"           %.2f %@",taxPrice.floatValue,self.appUserObject.resturantCurrency];
        }else if (taxPrice.length==4){
            taxPrice=[NSString stringWithFormat:@"          %.2f %@",taxPrice.floatValue,self.appUserObject.resturantCurrency];
        }else if (taxPrice.length==5){
            taxPrice=[NSString stringWithFormat:@"       %.2f %@",taxPrice.floatValue,self.appUserObject.resturantCurrency];
        }else if (taxPrice.length==6){
            taxPrice=[NSString stringWithFormat:@"      %.2f %@",taxPrice.floatValue,self.appUserObject.resturantCurrency];
        }else if (taxPrice.length==7){
            taxPrice=[NSString stringWithFormat:@"   %.2f %@",taxPrice.floatValue,self.appUserObject.resturantCurrency];
        }
        else if (taxPrice.length==8){
            taxPrice=[NSString stringWithFormat:@" %.2f %@",taxPrice.floatValue,self.appUserObject.resturantCurrency];
        }
        cell2.lblTaxValue.text=taxPrice;

        return cell2;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 40.0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)eventButtonDidPush:(id)sender
{
    switch (((UIView *)sender).tag) {
        case 1:
            [printerList_ show];
            break;
        case 2:
            [langList_ show];
            break;
        case 3:
            //Sample Receipt
            [self updateButtonState:NO];
            if (![self runPrintReceiptSequence]) {
                [self updateButtonState:YES];
            }
            break;
        case 4:
            //Sample Coupon
            [self updateButtonState:NO];
            if (![self runPrintCouponSequence]) {
                [self updateButtonState:YES];
            }
            break;
        default:
            break;
    }
}

- (BOOL)runPrintReceiptSequence
{
    _textWarnings.text = @"";
    
    if (![self initializeObject]) {
        return NO;
    }
    
    if (![self createReceiptData]) {
        [self finalizeObject];
        return NO;
    }
    
    if (![self printData]) {
        [self finalizeObject];
        return NO;
    }
    
    return YES;
}

- (BOOL)runPrintCouponSequence
{
    _textWarnings.text = @"";
    
    if (![self initializeObject]) {
        return NO;
    }
    
    if (![self createCouponData]) {
        [self finalizeObject];
        return NO;
    }
    
    if (![self printData]) {
        [self finalizeObject];
        return NO;
    }
    
    return YES;
}

- (void)updateButtonState:(BOOL)state
{
    _buttonReceipt.enabled = state;
    _buttonCoupon.enabled = state;
}

- (BOOL)createReceiptData
{
    int result = EPOS2_SUCCESS;
    
    const int barcodeWidth = 2;
    const int barcodeHeight = 100;
    
    if (printer_ == nil) {
        return NO;
    }
    
    NSMutableString *textData = [[NSMutableString alloc] init];
    UIImage *logoData = [UIImage imageNamed:@"Logo-01-new.png"];
    
    if (textData == nil || logoData == nil) {
        return NO;
    }
    
    result = [printer_ addTextAlign:EPOS2_ALIGN_CENTER];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addTextAlign"];
        return NO;
    }
    
    result = [printer_ addImage:logoData x:0 y:0
                          width:logoData.size.width
                         height:logoData.size.height
                          color:EPOS2_COLOR_1
                           mode:EPOS2_MODE_MONO
                       halftone:EPOS2_HALFTONE_DITHER
                     brightness:EPOS2_PARAM_DEFAULT
                       compress:EPOS2_COMPRESS_AUTO];
    
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addImage"];
        return NO;
    }
    
    // Section 1 : Store infomation
    result = [printer_ addFeedLine:1];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addFeedLine"];
        return NO;
    }
    if ([self.selectedPrinter isEqualToString:@"kitchen"]) {
        [textData appendString:[NSString stringWithFormat:@"%@ - %@\n",self.appUserObject.resturantName,@"Kitchen"]];

    }else{
        [textData appendString:[NSString stringWithFormat:@"%@ - %@\n",self.appUserObject.resturantName,@"Cashier"]];

    }
    NSString *spaceString1 = @"                    ";
     NSString *spaceString2 = @"     ";
    NSString *waiterName = [NSString stringWithFormat:@"%@%@%@",spaceString2,self.lblWaiterName.text,spaceString1];
    NSString *fwaiterName = [waiterName substringToIndex:42];
    [textData appendString:[NSString stringWithFormat:@"%@\n",fwaiterName]];
    [textData appendString:@"\n"];
     NSDate *today = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    
    
    NSString *dateString = [format stringFromDate:today];
    NSString *waiterDate = [NSString stringWithFormat:@"     Date        : %@%@",dateString,spaceString1];
    
    
    NSString *ReceiptDate = [waiterDate substringToIndex:40];
    [textData appendString:[NSString stringWithFormat:@"%@\n",ReceiptDate]];
    NSString *tableName;
    if ([self.lblTable.text isEqualToString:@"Home Delivery"]) {
        NSString *spaceString4 = @"                          ";
       tableName = [NSString stringWithFormat:@"     %@%@",self.lblTable.text,spaceString4];
    }else{
   tableName = [NSString stringWithFormat:@"%@%@",self.lblTable.text,spaceString1];
    }
    NSString *ttableName = [tableName substringToIndex:40];
    
    [textData appendString:[NSString stringWithFormat:@"%@\n",ttableName]];
    
    NSString *orderNum = [NSString stringWithFormat:@"%@%@%@",spaceString2,self.lblReceipt.text,spaceString1];
    NSString *orderN = [orderNum substringToIndex:40];
     [textData appendString:[NSString stringWithFormat:@"%@\n",orderN]];
   // [textData appendString:@"ST# 21 OP# 001 TE# 01 TR# 747\n"];
    [textData appendString:@"---------------------------------------------\n"];
    result = [printer_ addText:textData];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addText"];
        return NO;
    }
    [textData setString:@""];
    [textData appendString:[NSString stringWithFormat:@"     Item          Price    Qty   Amount(%@)\n",self.appUserObject.resturantCurrency]];
    [textData appendString:@"---------------------------------------------\n"];
    // Section 2 : Purchaced items
   
    for (int i=0; i<self.arrayFood.count; i++) {
         FoodObject * groupObject = [self.arrayFood objectAtIndex:i];
       
        NSString *spaceString = @"                    ";
        NSString *finalString = [NSString stringWithFormat:@"%@%@",groupObject.foodName,spaceString];
        NSString *foodNameString = [finalString substringToIndex:15];
        NSString *strFloatCount;
        if (groupObject.price.floatValue) {
           strFloatCount=[NSString stringWithFormat:@"%.2f",groupObject.price.floatValue];
            NSLog(@"%lu",(unsigned long)strFloatCount.length);
        }
        NSString *Pricestring;
        NSString *newStringPrice;
        if (strFloatCount.length==3) {
           Pricestring=[NSString stringWithFormat:@"    %.2f%@",groupObject.price.floatValue,spaceString];
          
        }else if (strFloatCount.length==4){
        Pricestring=[NSString stringWithFormat:@"   %.2f%@",groupObject.price.floatValue,spaceString];
       
        }else if (strFloatCount.length==5){
            Pricestring=[NSString stringWithFormat:@"  %.2f%@",groupObject.price.floatValue,spaceString];
           
        }
        else if (strFloatCount.length==6){
            Pricestring=[NSString stringWithFormat:@" %.2f%@",groupObject.price.floatValue,spaceString];
          
        }
        else if (strFloatCount.length==7){
            Pricestring=[NSString stringWithFormat:@"%.2f%@",groupObject.price.floatValue,spaceString];
            
        }else{
            Pricestring=[NSString stringWithFormat:@"%.2f%@",groupObject.price.floatValue,spaceString];

        }
            newStringPrice = [Pricestring substringToIndex:9];
            
        NSString *singleitemPrice=[NSString stringWithFormat:@"%.2f",groupObject.price.floatValue/groupObject.foodqty.intValue];

         if (singleitemPrice.length==3) {
             singleitemPrice=[NSString stringWithFormat:@"    %.2f%@",groupObject.price.floatValue/groupObject.foodqty.intValue,spaceString];
         }else if (singleitemPrice.length==4){
              singleitemPrice=[NSString stringWithFormat:@"   %.2f%@",groupObject.price.floatValue/groupObject.foodqty.intValue,spaceString];
         }else if (singleitemPrice.length==5){
              singleitemPrice=[NSString stringWithFormat:@"  %.2f%@",groupObject.price.floatValue/groupObject.foodqty.intValue,spaceString];
         }else if (singleitemPrice.length==6){
             singleitemPrice=[NSString stringWithFormat:@" %.2f%@",groupObject.price.floatValue/groupObject.foodqty.intValue,spaceString];
         }else if (singleitemPrice.length==7){
             singleitemPrice=[NSString stringWithFormat:@"%.2f%@",groupObject.price.floatValue/groupObject.foodqty.intValue,spaceString];
         }
        NSString *singlePriceString = [singleitemPrice substringToIndex:8];
        
        NSString *foodCount=[NSString stringWithFormat:@"%@ %@",groupObject.foodqty,@"   "];
        NSString *foodCountString = [foodCount substringToIndex:4];
        
        NSString *strdata=[NSString stringWithFormat:@"%@ %@ %@  %@\n",foodNameString,singlePriceString,foodCountString,newStringPrice];
        
        [textData appendString:strdata];
         }
   
    [textData appendString:@"----------------------------------------\n"];
//    [textData appendString:@"400 OHEIDA 3PK SPRINGF  9.99 R\n"];

    
    result = [printer_ addText:textData];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addText"];
        return NO;
    }
    
    [textData setString:@""];
    
   
    
    //
    if ([self.selectedPrinter isEqualToString:@"kitchen"]) {
        
    }else{
        [textData appendString:[NSString stringWithFormat:@"Sub Total                      %.2f\n",subtotalPrice]];
        [textData appendString:@"----------------------------------------\n"];
    for (int i=0; i<self.arrayTax.count; i++) {
        NSDictionary * dict = [self.arrayTax objectAtIndex:i];
        
        
        NSString *taxvalue=[dict valueForKey:@"tax_amount"];
        NSString *spaceString = @"                            ";
       // NSString *finalString = [NSString stringWithFormat:@"%@%@",groupObject.foodName,spaceString];
        NSString *taxNamewithPer=[NSString stringWithFormat:@"%@ %@ %@ %@%@",[dict valueForKey:@"tax_name"],@"@",[dict valueForKey:@"tax_value"],@"%",spaceString];
         NSString *stringfix = [taxNamewithPer substringToIndex:25];
       // NSString *taxValue=[NSString stringWithFormat:@"%@ %.2f",self.appUserObject.resturantCurrency,taxvalue.floatValue];
        
        NSString *taxValue=[NSString stringWithFormat:@"%.2f",taxvalue.floatValue];
        
        if (taxValue.length==3) {
            taxValue=[NSString stringWithFormat:@"%@     %.2f",self.appUserObject.resturantCurrency,taxvalue.floatValue];
        }else if (taxValue.length==4){
            taxValue=[NSString stringWithFormat:@"%@    %.2f",self.appUserObject.resturantCurrency,taxvalue.floatValue];
        }else if (taxValue.length==5){
            taxValue=[NSString stringWithFormat:@"%@   %.2f",self.appUserObject.resturantCurrency,taxvalue.floatValue];
        }else if (taxValue.length==6){
            taxValue=[NSString stringWithFormat:@"%@  %.2f",self.appUserObject.resturantCurrency,taxvalue.floatValue];
        }else if (taxValue.length==7){
            taxValue=[NSString stringWithFormat:@"%@ %.2f",self.appUserObject.resturantCurrency,taxvalue.floatValue];
        }
        
        [textData appendString:[NSString stringWithFormat:@"%@:%@\n",stringfix,taxValue]];
    }
    
    
     [textData appendString:@"----------------------------------------\n"];
    [textData appendString:[NSString stringWithFormat:@"Total Amount             :%@ %.2f\n",self.appUserObject.resturantCurrency,totaltaxPrice]];
     [textData appendString:@"----------------------------------------\n"];
    //
    
    [textData appendString:[NSString stringWithFormat:@"%@       :%@ -%.2f\n",self.lblDiscount.text,self.appUserObject.resturantCurrency,discountPrice]];
    [textData appendString:@"----------------------------------------\n"];

    
    result = [printer_ addText:textData];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addText"];
        return NO;
    }
    [textData setString:@""];
    
    result = [printer_ addTextSize:2 height:2];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addTextSize"];
        return NO;
    }
    
    result = [printer_ addText:[NSString stringWithFormat:@"Grand Total Amount\n%@\n",self.lblTotalPayableAmount.text]];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addText"];
        return NO;
    }
    
    result = [printer_ addTextSize:1 height:1];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addTextSize"];
        return NO;
    }
    
    result = [printer_ addFeedLine:1];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addFeedLine"];
        return NO;
    }
    
//    [textData appendString:@"CASH                    200.00\n"];
//    [textData appendString:@"CHANGE                   25.19\n"];
    [textData appendString:@"----------------------------------------\n\n"];
    result = [printer_ addText:textData];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addText"];
        return NO;
    }
    [textData setString:@""];
        
    }
    
    // Section 4 : Advertisement
   // [textData appendString:@"Purchased item total number\n"];
     [textData appendString:@"Thank you for dinner with us!\n"];
    [textData appendString:@"Please come again !\n"];
    //[textData appendString:@"With Preferred Saving Card\n"];
    result = [printer_ addText:textData];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addText"];
        return NO;
    }
    [textData setString:@""];
    
    result = [printer_ addFeedLine:2];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addFeedLine"];
        return NO;
    }
    
//    result = [printer_ addBarcode:@"01209457"
//                             type:EPOS2_BARCODE_CODE39
//                              hri:EPOS2_HRI_BELOW
//                             font:EPOS2_FONT_A
//                            width:barcodeWidth
//                           height:barcodeHeight];
//    if (result != EPOS2_SUCCESS) {
//        [ShowMsg showErrorEpos:result method:@"addBarcode"];
//        return NO;
//    }
    
    result = [printer_ addCut:EPOS2_CUT_FEED];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addCut"];
        return NO;
    }
    
    return YES;
}



- (void)openSideMenuButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateToRootVC" object:nil];

 
        [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (BOOL)createCouponData
{
    int result = EPOS2_SUCCESS;
    
    const int barcodeWidth = 2;
    const int barcodeHeight = 64;
    
    if (printer_ == nil) {
        return NO;
    }
    
    UIImage *coffeeData = [UIImage imageNamed:@"coffee.png"];
    UIImage *wmarkData = [UIImage imageNamed:@"wmark.png"];
    
    if (coffeeData == nil || wmarkData == nil) {
        return NO;
    }
    
    result = [printer_ addPageBegin];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addPageBegin"];
        return NO;
    }
    
    result = [printer_ addPageArea:0 y:0 width:PAGE_AREA_WIDTH height:PAGE_AREA_HEIGHT];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addPageArea"];
        return NO;
    }
    
    result = [printer_ addPageDirection:EPOS2_DIRECTION_TOP_TO_BOTTOM];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addPageDirection"];
        return NO;
    }
    
    result = [printer_ addPagePosition:0 y:coffeeData.size.height];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addPagePosition"];
        return NO;
    }
    
    result = [printer_ addImage:coffeeData x:0 y:0
                          width:coffeeData.size.width
                         height:coffeeData.size.height
                          color:EPOS2_PARAM_DEFAULT
                           mode:EPOS2_PARAM_DEFAULT
                       halftone:EPOS2_PARAM_DEFAULT
                     brightness:3
                       compress:EPOS2_PARAM_DEFAULT];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addImage"];
        return NO;
    }
    
    result = [printer_ addPagePosition:0 y:wmarkData.size.height];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addPagePosition"];
        return NO;
    }
    
    result = [printer_ addImage:wmarkData x:0 y:0
                          width:wmarkData.size.width
                         height:wmarkData.size.height
                          color:EPOS2_PARAM_DEFAULT
                           mode:EPOS2_PARAM_DEFAULT
                       halftone:EPOS2_PARAM_DEFAULT
                     brightness:EPOS2_PARAM_DEFAULT
                       compress:EPOS2_PARAM_DEFAULT];
    
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addImage"];
        return NO;
    }
    
    result = [printer_ addPagePosition:FONT_A_WIDTH * 4 y:(PAGE_AREA_HEIGHT / 2) - (FONT_A_HEIGHT * 2)];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addPagePosition"];
        return NO;
    }
    
    result = [printer_ addTextSize:3 height:3];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addTextSize"];
        return NO;
    }
    
    result = [printer_ addTextStyle:EPOS2_PARAM_DEFAULT ul:EPOS2_PARAM_DEFAULT em:EPOS2_TRUE color:EPOS2_PARAM_DEFAULT];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addTextStyle"];
        return NO;
    }
    
    result = [printer_ addTextSmooth:EPOS2_TRUE];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addTextSmooth"];
        return NO;
    }
    
    result = [printer_ addText:@"FREE Coffee\n"];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addText"];
        return NO;
    }
    
    result = [printer_ addPagePosition:(PAGE_AREA_WIDTH / barcodeWidth) - BARCODE_WIDTH_POS y:coffeeData.size.height + BARCODE_HEIGHT_POS];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addPagePosition"];
        return NO;
    }
    
    result = [printer_ addBarcode:@"01234567890" type:EPOS2_BARCODE_UPC_A hri:EPOS2_PARAM_DEFAULT font: EPOS2_PARAM_DEFAULT width:barcodeWidth height:barcodeHeight];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addBarocde"];
        return NO;
    }
    
    result = [printer_ addPageEnd];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addPageEnd"];
        return NO;
    }
    
    result = [printer_ addCut:EPOS2_CUT_FEED];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"addCut"];
        return NO;
    }
    
    return YES;
}

- (BOOL)printData
{
    int result = EPOS2_SUCCESS;
    
    Epos2PrinterStatusInfo *status = nil;
    
    if (printer_ == nil) {
        return NO;
    }
    
    if (![self connectPrinter]) {
        return NO;
    }
    
    status = [printer_ getStatus];
    [self dispPrinterWarnings:status];
    
    if (![self isPrintable:status]) {
        [ShowMsg show:[self makeErrorMessage:status]];
        [printer_ disconnect];
        return NO;
    }
    
    result = [printer_ sendData:EPOS2_PARAM_DEFAULT];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"sendData"];
        [printer_ disconnect];
        return NO;
    }
    
    return YES;
}

- (BOOL)initializeObject
{
    printer_ = [[Epos2Printer alloc] initWithPrinterSeries:printerSeries_ lang:lang_];
    
    if (printer_ == nil) {
        [ShowMsg showErrorEpos:EPOS2_ERR_PARAM method:@"initiWithPrinterSeries"];
        return NO;
    }
    
    [printer_ setReceiveEventDelegate:self];
    
    return YES;
}

- (void)finalizeObject
{
    if (printer_ == nil) {
        return;
    }
    
    [printer_ clearCommandBuffer];
    
    [printer_ setReceiveEventDelegate:nil];
    
    printer_ = nil;
}

-(BOOL)connectPrinter
{
    int result = EPOS2_SUCCESS;
    
    if (printer_ == nil) {
        return NO;
    }
    
    result = [printer_ connect:_textTarget timeout:EPOS2_PARAM_DEFAULT];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"connect"];
        return NO;
    }
    
    result = [printer_ beginTransaction];
    if (result != EPOS2_SUCCESS) {
        [ShowMsg showErrorEpos:result method:@"beginTransaction"];
        [printer_ disconnect];
        return NO;
    }
    
    return YES;
}

- (void)disconnectPrinter
{
    int result = EPOS2_SUCCESS;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (printer_ == nil) {
        return;
    }
    
    result = [printer_ endTransaction];
    if (result != EPOS2_SUCCESS) {
        [dict setObject:[NSNumber numberWithInt:result] forKey:KEY_RESULT];
        [dict setObject:@"endTransaction" forKey:KEY_METHOD];
        [self performSelectorOnMainThread:@selector(showEposErrorFromThread:) withObject:dict waitUntilDone:NO];
    }
    
    result = [printer_ disconnect];
    if (result != EPOS2_SUCCESS) {
        [dict setObject:[NSNumber numberWithInt:result] forKey:KEY_RESULT];
        [dict setObject:@"disconnect" forKey:KEY_METHOD];
        [self performSelectorOnMainThread:@selector(showEposErrorFromThread:) withObject:dict waitUntilDone:NO];
    }
    [self finalizeObject];
}

- (void)showEposErrorFromThread:(NSDictionary *)dict
{
    int result = EPOS2_SUCCESS;
    NSString *method = @"";
    result = [[dict valueForKey:KEY_RESULT] intValue];
    method = [dict valueForKey:KEY_METHOD];
    [ShowMsg showErrorEpos:result method:method];
}

- (BOOL)isPrintable:(Epos2PrinterStatusInfo *)status
{
    if (status == nil) {
        return NO;
    }
    
    if (status.connection == EPOS2_FALSE) {
        return NO;
    }
    else if (status.online == EPOS2_FALSE) {
        return NO;
    }
    else {
        ;//print available
    }
    
    return YES;
}

- (void) onPtrReceive:(Epos2Printer *)printerObj code:(int)code status:(Epos2PrinterStatusInfo *)status printJobId:(NSString *)printJobId
{
    if (code==0) {
        NSLog(@"%d",code);
       // OrderHistryObject *object=[self.arrayOrderProgress objectAtIndex:btn.tag];
        //NSString *tableName=[ECSUserDefault getStringFromUserDefaultForKey:@"tablename"];
        NSString *tableid=[ECSUserDefault getStringFromUserDefaultForKey:@"tableId"];
       // NSString *orderNum=[ECSUserDefault getStringFromUserDefaultForKey:@"orderNum"];
        if (tableid.length) {
            
            
            
            if ([self.selectedPrinter isEqualToString:@"kitchen"]) {
                [self startServiceToGetKitchenUpdate];
            }else{
                [ECSToast showToast:@"Receipt generated successfully" view:self.view];
                FeedBackVC *nav=[[FeedBackVC alloc]initWithNibName:@"FeedBackVC" bundle:nil];
                // nav.orderObj=self.orderObj;
                [self.navigationController pushViewController:nav animated:YES];
            }
            
            
            
        }else{

           
            
             if ([self.selectedPrinter isEqualToString:@"kitchen"]) {
                 [self startServiceToGetKitchenUpdate];
             }else{
                 [ECSToast showToast:@"Receipt generated successfully" view:self.view];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateToRootVC" object:nil];
                 
                 
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
        }
    }else{
        
    [ShowMsg showResult:code errMsg:[self makeErrorMessage:status]];
    
    [self dispPrinterWarnings:status];
    [self updateButtonState:YES];
    
    [self performSelectorInBackground:@selector(disconnectPrinter) withObject:nil];
    }
}
-(void)startServiceToGetKitchenUpdate
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelectorInBackground:@selector(serviceToGetUpdate) withObject:nil];
    
}


-(void)serviceToGetUpdate
{
    ECSServiceClass * class = [[ECSServiceClass alloc]init];
    [class setServiceMethod:POST];
    NSString *selectedIp=[ECSUserDefault getStringFromUserDefaultForKey:@"ResetIP"];
    if ([self.selectedPrinter isEqualToString:@"kitchen"]) {
        
        if (selectedIp.length) {
            [class setServiceURL:[NSString stringWithFormat:@"http://%@%@kitchen_print_update",selectedIp,SERVERURLPATH]];
        }else{
            [class setServiceURL:[NSString stringWithFormat:@"http://%@%@kitchen_print_update",@"tabqy.com",SERVERURLPATH]];
        }
    }
    NSMutableDictionary *dict;
    if (self.orderNumber.length) {
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                self.orderNumber, @"order_no",
                nil];
    }else{
        dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                self.orderObj.orderNum, @"order_no",
                nil];
    }
    [class addJson:dict];
    [class setCallback:@selector(callBackServiceToGetUpdate:)];
    [class setController:self];
    
    [class runService];
}

-(void)callBackServiceToGetUpdate:(ECSResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:response.data options:0 error:nil];
    if(response.isValid){
        
        [ECSAlert showAlert:@"Receipt generated successfully"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigateToRootVC" object:nil];
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
}




















- (void)dispPrinterWarnings:(Epos2PrinterStatusInfo *)status
{
    NSMutableString *warningMsg = [[NSMutableString alloc] init];
    
    if (status == nil) {
        return;
    }
    
    _textWarnings.text = @"";
    
    if (status.paper == EPOS2_PAPER_NEAR_END) {
        [warningMsg appendString:NSLocalizedString(@"warn_receipt_near_end", @"")];
    }
    
    if (status.batteryLevel == EPOS2_BATTERY_LEVEL_1) {
        [warningMsg appendString:NSLocalizedString(@"warn_battery_near_end", @"")];
    }
    
    

    
    _textWarnings.text = warningMsg;
}

- (NSString *)makeErrorMessage:(Epos2PrinterStatusInfo *)status
{
    NSMutableString *errMsg = [[NSMutableString alloc] initWithString:@""];
    
    if (status.getOnline == EPOS2_FALSE) {
        [errMsg appendString:NSLocalizedString(@"err_offline", @"")];
    }
    if (status.getConnection == EPOS2_FALSE) {
        [errMsg appendString:NSLocalizedString(@"err_no_response", @"")];
    }
    if (status.getCoverOpen == EPOS2_TRUE) {
        [errMsg appendString:NSLocalizedString(@"err_cover_open", @"")];
    }
    if (status.getPaper == EPOS2_PAPER_EMPTY) {
        [errMsg appendString:NSLocalizedString(@"err_receipt_end", @"")];
    }
    if (status.getPaperFeed == EPOS2_TRUE || status.getPanelSwitch == EPOS2_SWITCH_ON) {
        [errMsg appendString:NSLocalizedString(@"err_paper_feed", @"")];
    }
    if (status.getErrorStatus == EPOS2_MECHANICAL_ERR || status.getErrorStatus == EPOS2_AUTOCUTTER_ERR) {
        [errMsg appendString:NSLocalizedString(@"err_autocutter", @"")];
        [errMsg appendString:NSLocalizedString(@"err_need_recover", @"")];
    }
    if (status.getErrorStatus == EPOS2_UNRECOVER_ERR) {
        [errMsg appendString:NSLocalizedString(@"err_unrecover", @"")];
    }
    
    if (status.getErrorStatus == EPOS2_AUTORECOVER_ERR) {
        if (status.getAutoRecoverError == EPOS2_HEAD_OVERHEAT) {
            [errMsg appendString:NSLocalizedString(@"err_overheat", @"")];
            [errMsg appendString:NSLocalizedString(@"err_head", @"")];
        }
        if (status.getAutoRecoverError == EPOS2_MOTOR_OVERHEAT) {
            [errMsg appendString:NSLocalizedString(@"err_overheat", @"")];
            [errMsg appendString:NSLocalizedString(@"err_motor", @"")];
        }
        if (status.getAutoRecoverError == EPOS2_BATTERY_OVERHEAT) {
            [errMsg appendString:NSLocalizedString(@"err_overheat", @"")];
            [errMsg appendString:NSLocalizedString(@"err_battery", @"")];
        }
        if (status.getAutoRecoverError == EPOS2_WRONG_PAPER) {
            [errMsg appendString:NSLocalizedString(@"err_wrong_paper", @"")];
        }
    }
    if (status.getBatteryLevel == EPOS2_BATTERY_LEVEL_0) {
        [errMsg appendString:NSLocalizedString(@"err_battery_real_end", @"")];
    }
    
    return errMsg;
}

- (void)onSelectPrinter:(NSString *)target
{
    _textTarget = target;
//    if ([self.selectedPrinter isEqualToString:@"kitchen"]) {
//    [ECSUserDefault saveString:target ToUserDefaultForKey:@"selectedPrinterForKitchen"];
//    }else{
//       [ECSUserDefault saveString:target ToUserDefaultForKey:@"selectedPrinterForCashier"];
//    }
    if (self.textTarget.length) {
        self.buttonDiscovery.backgroundColor =[UIColor lightGrayColor];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *view = nil;
    
    if ([segue.identifier isEqualToString:@"DiscoveryView"]) {
        
        view = (DiscoveryViewController *)[segue destinationViewController];
        
        ((DiscoveryViewController *)view).delegate = self;
    }
}

- (void)onSelectPickerItem:(NSInteger)position obj:(id)obj
{
    if (obj == printerList_) {
        [_buttonPrinter setTitle:[printerList_ getItem:position] forState:UIControlStateNormal];
        printerSeries_ = (int)printerList_.selectIndex;
    }
    else if (obj == langList_) {
        [_buttonLang setTitle:[langList_ getItem:position] forState:UIControlStateNormal];
        lang_ = (int)langList_.selectIndex;
        
    }
    else {
        ; //do nothing
    }
}

-(IBAction)onClickDiscovery:(id)sender{
    
    
    
    DiscoveryViewController *nav=[[DiscoveryViewController alloc]initWithCoder:nil];

   
    nav.delegate=self;
    ((DiscoveryViewController *)nav).delegate = self;

    [self.navigationController pushViewController:nav animated:YES];
    
}
-(IBAction)onClickPrinterSeries:(id)sender{
     [printerList_ show];
//    break;
//case 2:
//    [langList_ show];
//    break;
//case 3:
//    //Sample Receipt
//  
//    break;
//case 4:
//    //Sample Coupon
//    [self updateButtonState:NO];
//    if (![self runPrintCouponSequence]) {
//        [self updateButtonState:YES];
//    }
//    break;
//default:
//    break;

}
-(IBAction)onClickPrint:(id)sender{
   
    [self updateButtonState:NO];
    if (![self runPrintReceiptSequence]) {
        [self updateButtonState:YES];
    }
}
@end
