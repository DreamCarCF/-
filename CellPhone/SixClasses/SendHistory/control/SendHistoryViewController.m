//
//  SendHistoryViewController.m
//  CellPhone
//
//  Created by cf on 16/5/4.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "SendHistoryViewController.h"
#import "AFNetworking.h"
#import "SendHistoryTableViewCell.h"
#import "SendHistoryModel.h"
#import "SVProgressHUD.h"
@interface SendHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSString *QRUrl;
    NSString *userName;
    NSString *password;
}
@property (nonatomic,strong) NSMutableArray * Arrnew;
@end

@implementation SendHistoryViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.Arrnew = [NSMutableArray new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"记录查询";
    [self readNet];
    [SVProgressHUD show];
}

- (void)readNet
{
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    userName = [userdefaults objectForKey:@"userName"];
    password = [userdefaults objectForKey:@"passWord"];
    
    QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_query_MeRedS?phone=%@&pwd=%@",userName,password];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"jsonString === %@",jsonString);
        NSMutableArray * dataArry = [NSMutableArray new];
        dataArry = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"dataArry ==== %@",dataArry);
        SendHistoryModel * model = [SendHistoryModel new];
        _Arrnew = [model sendArryWith:dataArry];
        
        [SVProgressHUD dismiss];
        [self.myTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark UITableViewDatasource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    return _Arrnew.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *resuedID=@"SendHistoryTableViewCell";
    SendHistoryTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuedID];
    if (!cell) {
        cell = [[SendHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuedID];
    }
    if (_Arrnew.count>0) {
        [cell setWithArry:_Arrnew andCellindex:indexPath];
    }
    
    
    return cell;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
