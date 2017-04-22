//
//  ViewController.m
//  LifeTool
//
//  Created by Zzy on 9/2/14.
//  Copyright (c) 2014 Chihya Tsang. All rights reserved.
//

#import "PhoneViewController.h"
#import "Person.h"
#import "selectNumberViewController.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
typedef void (^RequestAddressBookBlock)(BOOL success);

@interface PhoneViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,MFMessageComposeViewControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray * imgArry;
    NSString * _currentPhone;
    NSString * _msgStr;
    NSString * userName;
    NSString * password;
    NSString * QRUrl;
    NSUInteger  calloutstatus;
    NSUInteger picnumber;
    
    UIImage * caiXinimg;
    float timerFloat;
    NSString *startDate;
    float startFloat;

    BOOL _isblack;
    int iscall;
    int countnumber;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSMutableArray *addressBook;
@property (strong, nonatomic) NSMutableArray *matchAddressBook;
@property (nonatomic, getter = isMatching) BOOL matching;
@property (nonatomic,strong) NSTimer * timer2;
@property(strong,nonatomic) CTCallCenter *callCenter;

@end

@implementation PhoneViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        imgArry = [NSMutableArray new];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//   _timer2 = [[NSTimer alloc]init];
    iscall =0;
     countnumber = 1;
    self.title = @"拨打电话";
    self.addressBook = [[NSMutableArray alloc] init];
    self.matchAddressBook = [[NSMutableArray alloc] init];
    
    
    self.webView = [[UIWebView alloc] init];
    self.webView.hidden = YES;
    self.webView.delegate =self;
    [self.view addSubview:self.webView];
    [self.inputTextField becomeFirstResponder];
    [self requestAddressBookAccessWithBlock:^(BOOL success) {
        if (success) {
            [self.tableView reloadData];
        } else {
            
        }
    }];
    
    
    //4、创建并接收回调等
    
    _callCenter = [[CTCallCenter alloc] init];
    
    _callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            NSLog(@"挂断了电话咯 Call has been disconnected");
//            [_timer2 setFireDate:[NSDate distantFuture]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self mGoTimer];
            });
           
            
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            NSLog(@"电话通了 Call has just been connected");
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            NSLog(@"来电话了 Call is incoming");
            
            
            
            // 用来做暂停录音之类的。
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            NSLog(@" 正在播出电话 call is dialing");
           
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            //[dateFormatter setDateFormat:@"hh:mm:ss"] // 输出格式
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSSSSS"];  // 输出格式
            
            //[dateFormatter setDateFormat:@"yyMMddHHmmssSSSSSS"]; // 输出格式
            // 时间字符串
            startDate = [dateFormatter stringFromDate:[NSDate date]] ;
           

           

            
        }
        else
        {
            NSLog(@"嘛都没做 Nothing is done");
        }
    };

    
}

- (void)mGoTimer
{
    NSDateFormatter *formatters = [[NSDateFormatter alloc]init];
    
    [formatters setDateStyle:NSDateFormatterMediumStyle];
    [formatters setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"] // 输出格式
    
    [formatters setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSSSSS"];  // 输出格式
    
    
    NSDate *dateS = [formatters dateFromString:startDate];
    float endFloat = [[NSDate date] timeIntervalSinceDate:dateS];
    NSLog(@"%f",endFloat);
    
    iscall = (int)endFloat;
    NSMutableArray* blackItemDataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"blackItemData"];
    
    if(blackItemDataArr.count >0){
        for (NSString * phNStr in blackItemDataArr) {
            if ([phNStr isEqualToString: _currentPhone]) {
                
                //不进行网络请求
                _isblack =YES;
                
            }else
            {
                _isblack = NO;
                
            }
        }
    }
    
    if (_isblack == NO) {
        [self gosendmsg:_currentPhone and:iscall];
    }else{
        [self gosendmsg:_currentPhone and:iscall];
    }
    
    
    
    
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
    {
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent)
    {
        NSLog(@"Message sent");
    }
    else
    {
        NSLog(@"Message failed");
    }
}

- (void)sendCaiXin:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients and:(NSMutableArray *)imgpicArry
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
        
    {
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        for ( int i =0; i<imgArry.count;i++) {
            
            UIImage *img = imgArry[i];
        NSData *imgData = UIImageJPEGRepresentation(img, 0.2);
        BOOL success =[controller addAttachmentData:imgData typeIdentifier:@"img.data" filename:@"image.jpg"];
        if (!success) {
            NSLog(@"图片传输失败");
            return;
        }
        }
        [self performSelector:@selector(performSelector:withObject:afterDelay:) withObject:controller afterDelay:5];
      
        
        
    }
}

-(void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay
{
    [self presentViewController:anArgument animated:YES completion:nil];
}


- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    
    
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
        
    {
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }   
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden= NO;
    [self.inputTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isMatching) {
        return self.matchAddressBook.count;
    }
    return self.addressBook.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Phone"];
    Person *person;
    if (self.isMatching) {
        person = [self.matchAddressBook objectAtIndex:indexPath.row];
    } else {
        person = [self.addressBook objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", (person.lastName ? person.lastName : @""), (person.firstName ? person.firstName : @"")];
    cell.detailTextLabel.text = person.phoneNumber;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Person *person;
    if (self.isMatching) {
        person = [self.matchAddressBook objectAtIndex:indexPath.row];
    } else {
        person = [self.addressBook objectAtIndex:indexPath.row];
    }
    [self callWithPhoneNumber:person.phoneNumber];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *inputNumber = @"";
    if ([string isEqualToString:@""]) {
        NSInteger index = textField.text.length - 1;
        if (index < 0) {
            index = 0;
        }
        inputNumber = [textField.text substringToIndex:index];
    } else {
        inputNumber = [textField.text stringByAppendingString:string];
    }
    if (inputNumber.length > 0) {
        self.matching = YES;
        [self.matchAddressBook removeAllObjects];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (Person *item in self.addressBook) {
            NSString *phoneNumer = [item.phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phoneNumer = [phoneNumer stringByReplacingOccurrencesOfString:@"+" withString:@""];
            if ([phoneNumer hasPrefix:inputNumber]) {
                [self.matchAddressBook addObject:item];
            } else if ([phoneNumer rangeOfString:inputNumber].length > 0) {
                [tempArray addObject:item];
            }
        }
        [self.matchAddressBook addObjectsFromArray:tempArray];
    } else {
        self.matching = NO;
    }
    [self.tableView reloadData];
    return YES;
}

- (void)requestAddressBookAccessWithBlock:(RequestAddressBookBlock)block
{
    CFErrorRef error = nil;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            [self getAddressBookWithRef:addressBookRef];
            if (block) {
                block(YES);
            }
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [self getAddressBookWithRef:addressBookRef];
        if (block) {
            block(YES);
        }
    } else {
        if (block) {
            block(NO);
        }
    }
}

- (void)getAddressBookWithRef:(ABAddressBookRef)addressBookRef
{
    CFArrayRef addressArr = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    for (NSInteger i = 0; i < CFArrayGetCount(addressArr); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(addressArr, i);
        NSString *firstName = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int j = 0; j < ABMultiValueGetCount(phone); j++) {
            NSString *phoneNumber = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, j));
            Person *person = [[Person alloc] initWithFirstName:firstName lastName:lastName phoneNumber:phoneNumber];
            [self.addressBook addObject:person];
        }
        CFRelease(phone);
        CFRelease(person);
    }
    CFRelease(addressArr);
}

- (void)callWithPhoneNumber:(NSString *)phoneNumber
{
    _currentPhone = phoneNumber  ;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    

    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [self.inputTextField becomeFirstResponder];

    
}


- (void)gosendmsg:(NSString *)phoneNumber and:(int)calllength
{
   
    countnumber++;
    if (countnumber == 2) {
        
    
    //进行网络请求
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    userName = [userdefaults objectForKey:@"userName"];
    password = [userdefaults objectForKey:@"passWord"];
    calloutstatus = [userdefaults integerForKey:@"calloutValue"];
 _msgStr = [userdefaults objectForKey:@"userDefineMMS"];
    
    NSLog(@"===============\n\n\n\\n\n\n %lu \n\n\n\n\n\n",calloutstatus);
    
   if (calloutstatus == 4){
        
        selectNumberViewController * seleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"selectNumberViewController"];
        seleVC.calllength = calllength;
        seleVC.phoneNumber = phoneNumber;
       seleVC.isHandSend = NO;
        [self.navigationController pushViewController:seleVC animated:YES];
        
    }else if (calloutstatus == 6)
    {
        selectNumberViewController * seleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"selectNumberViewController"];
        seleVC.calllength = calllength;
        seleVC.phoneNumber = phoneNumber;
        seleVC.isHandSend = YES;
        [self.navigationController pushViewController:seleVC animated:YES];
    }
    else if(calloutstatus == 8){
        return;
    }
    else{

    
        NSLog(@"what a fuck ???!!! \n\n\n\n\n\n\n\n\n");
    
    
    QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_send?localTelephone=%@&pwd=%@&talkDuration=%d&connectStatus=2&pressKeyValue=0&electricType=%d&toSendTelephone=%@",userName,password,calllength,2,phoneNumber];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString === %@",jsonString);
        if ([jsonString isEqualToString:@"15"]) {
            [SVProgressHUD showInfoWithStatus:@"彩信,短信发送成功"];
            UILocalNotification *localNoti=[[UILocalNotification alloc]init];
            localNoti.fireDate=[NSDate dateWithTimeIntervalSinceNow:2];
            localNoti.alertBody=@"彩信,短信发送成功";
            localNoti.applicationIconBadgeNumber=1;
            
           [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
        }
        if ([jsonString isEqualToString:@"11"]) {
             [SVProgressHUD showInfoWithStatus:@"发送信息数量已达上限，本次信息没有发送"];
            UILocalNotification *localNoti=[[UILocalNotification alloc]init];
            localNoti.fireDate=[NSDate dateWithTimeIntervalSinceNow:2];
            localNoti.alertBody=@"发送信息数量已达上限，本次信息没有发送";
            localNoti.applicationIconBadgeNumber=1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];

        }
        if([jsonString isEqualToString:@"12"]){
            [SVProgressHUD showInfoWithStatus:@"发送短信数目今日已达上限，信息没有发送"];
            UILocalNotification *localNoti=[[UILocalNotification alloc]init];
            localNoti.fireDate=[NSDate dateWithTimeIntervalSinceNow:2];
            localNoti.alertBody=@"发送短信数目今日已达上限，信息没有发送";
            localNoti.applicationIconBadgeNumber=1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
        }
        if (calloutstatus == 2 || calloutstatus == 8|| calloutstatus == 10) {
            
        }else if(calloutstatus == 14)
        {
            _msgStr = [userdefaults objectForKey:@"CaiXin"];
            picnumber = [userdefaults integerForKey:@"caixincount"];
            
            for (int i =0; i<picnumber; i++) {
                NSString*doucuments=[NSHomeDirectory()
                                     stringByAppendingPathComponent:@"Documents"];
                
                NSString* path = [doucuments stringByAppendingPathComponent:[NSString stringWithFormat:@"CaiXin%d",i]];
                
                caiXinimg = [UIImage imageWithContentsOfFile:path];
                if (caiXinimg) {
                    [imgArry addObject:caiXinimg];
                
                
                [SVProgressHUD show];
                
                [self gocaixin];
                }
                
                
                
            }
         
            
           
        }
        else{
            [self sendSMS:_msgStr recipientList:@[_currentPhone]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        _msgStr = [userdefaults objectForKey:@"userDefineMMS"];
//        [self sendSMS:_msgStr recipientList:@[_currentPhone]];

    }];
    
    }
    }
    
}
-(void)gocaixin
{
    [SVProgressHUD dismiss];
    [self sendCaiXin:_msgStr recipientList:@[_currentPhone] and:imgArry];
}



- (void)smsWithPhoneNumber:(NSString *)phoneNumber
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)onClickSendMessage:(id)sender
{
    if (self.inputTextField.text.length > 0) {
        [self smsWithPhoneNumber:self.inputTextField.text];
    }
}

- (IBAction)onClickCallNumber:(id)sender
{
    if (self.inputTextField.text.length > 0) {
        [self callWithPhoneNumber:self.inputTextField.text];
        
    }
}
@end
