//
//  selecCheckViewController.m
//  CellPhone
//
//  Created by cf on 16/5/4.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "selecCheckViewController.h"
#import "AFNetworking.h"
#import "selecCheckModel.h"
#import "selecCheckTableViewCell.h"
@interface selecCheckViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *QRUrl;
    NSString *userName;
    NSString *password;
    
}
@property (nonatomic,strong) NSMutableArray * Arrnew;
@end

@implementation selecCheckViewController
//-(NSMutableArray *)Arrnew
//{
//    if (!_Arrnew) {
//        _Arrnew = [NSMutableArray new];
//    }
//    return _Arrnew;
//}
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
    self.title = @"内容查询";
    [self readNet];
}

- (void)readNet
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    userName = [userdefaults objectForKey:@"userName"];
    password = [userdefaults objectForKey:@"passWord"];
    
    QRUrl = [NSString stringWithFormat:@"http://112.124.20.86:8080/jsy_1.0/android!ad_key_value?phone=%@&pwd=%@",userName,password];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:QRUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray * dataArry = [NSMutableArray new];
        dataArry = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"dataArry ==== %@",dataArry);
        for (NSDictionary *dic in dataArry) {
            selecCheckModel * model = [selecCheckModel new];
            model.user_name = [NSString stringWithFormat:@"%d",(int)dic[@"Id"]];
            model.selecBtn_Value = dic[@"Kvalue"];
            model.msgAndColorMsg = dic[@"Mstype"];
            model.contentTitle = dic[@"Title"];
            [_Arrnew addObject:model];
            
        }
     
        
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
    
    
    static NSString *resuedID=@"selecCheckTableViewCell";
    selecCheckTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:resuedID];
    if (!cell) {
        cell = [[selecCheckTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuedID];
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
