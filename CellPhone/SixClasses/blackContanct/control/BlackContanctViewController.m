//
//  BlackContanctViewController.m
//  CellPhone
//
//  Created by cf on 16/5/4.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "BlackContanctViewController.h"
#import "PersonModel.h"
#import "XHJAddressBook.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "PersonCell.h"



@interface BlackContanctViewController()<UITableViewDataSource, UITableViewDelegate>{
    UITableView    *_tableShow;
    XHJAddressBook *_addBook;
}
@property(nonatomic,strong)   NSMutableArray *listContent;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) PersonModel *people;
@property (strong,nonatomic) NSIndexPath *currentSelIndexPath;
@property (strong,nonatomic) NSMutableArray *blackItemArr;
@property (strong,nonatomic) NSMutableArray *listContentFilter;
@property (strong,nonatomic) UISwitch *switchView;
@property (strong,nonatomic) UIView *topView;


@end

@implementation BlackContanctViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑白名单";
    
    NSMutableArray* blackItemDataArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"blackItemData"];
    
    if(blackItemDataArr != nil){
        _blackItemArr = [[NSMutableArray alloc] initWithArray:blackItemDataArr];
    }else{
        _blackItemArr = [[NSMutableArray alloc] init];
    }
    
    [self addTableView];
    [self showContactList];
//    

//    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    _tableShow.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseCall) name:@"endCall" object:nil];
}


- (void)showContactList
{
    _sectionTitles = [NSMutableArray new];
    _tableShow.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableShow.sectionIndexColor = [UIColor blackColor];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [MBProgressHUD showMessage:@"联系人列表加载中,请稍等..."];
        [self initData];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self setTitleList];
            [_tableShow reloadData];
//            [MBProgressHUD hideHUD];
        });
    });
}


-(void)initData
{
    _addBook = [[XHJAddressBook alloc]init];
    _listContent = [_addBook getAllPerson];
    if(_listContent==nil)
    {
        NSLog(@"数据为空或通讯录权限拒绝访问，请到系统开启");
        return;
    }
}

-(void)setTitleList
{
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[theCollation sectionTitles]];
    NSMutableArray * existTitles = [NSMutableArray array];
    for(int i=0; i < [_listContent count];i++)//过滤 就取存在的索引条标签
    {
        PersonModel *pm = _listContent[i][0];
        for(int j=0;j < _sectionTitles.count;j++)
        {
            if(pm.sectionNumber == j)
                [existTitles addObject:self.sectionTitles[j]];
        }
    }
    
    [self.sectionTitles removeAllObjects];
    self.sectionTitles = existTitles;
}

- (void) addTableView
{
    if(([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        //self.view.frame.origin.y会下移64像素至navigationBar下方。
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    _sectionTitles = [NSMutableArray new];
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 40)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];

    UILabel *titlelab = [[UILabel alloc] initWithFrame:CGRectMake(7, 2, 110, 40)];
    titlelab.text = @"仅显示黑名单";
    titlelab.textColor = [UIColor blackColor];
    [_topView addSubview:titlelab];
    
    self.switchView = [[UISwitch alloc] initWithFrame:CGRectMake(mainWidth-70, 3, 60, 20)];
    self.switchView.on = NO;
    [self.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_topView addSubview:self.switchView];
    
    
    _tableShow = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, mainWidth, mainHeigth-40)];
    _tableShow.delegate = self;
    _tableShow.dataSource = self;
    [self.view addSubview:_tableShow];
    _tableShow.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableShow.sectionIndexColor = [UIColor blackColor];
}

-(void)switchAction:(UISwitch *)sender{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if(sender.on == YES){
            [_listContent removeAllObjects];
            _listContent = [_addBook getFilterPerson:_blackItemArr];
        }else{
            _listContent = [_addBook getAllPerson];
        }
        [_tableShow reloadData];
    });
}

- (void)loadNewData
{
    if (self.switchView.on) {
        
    }else{
    //[MBProgressHUD showMessage:@"联系人列表加载中,请稍等..."];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),
                   ^{
                       [_tableShow.mj_header endRefreshing];
                       //[MBProgressHUD hideHUD];
                       
                       _sectionTitles = [NSMutableArray new];
                       
                       _tableShow.sectionIndexBackgroundColor = [UIColor clearColor];
                       _tableShow.sectionIndexColor = [UIColor blackColor];
                       
                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                           [self initData];
                           
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [self setTitleList];
                               [_tableShow reloadData];
                           });
                       });
                       
                   });
    }
}



#pragma make -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listContent count];
}

//对应的section有多少row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_listContent objectAtIndex:(section)] count];
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
//section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.sectionTitles == nil || self.sectionTitles.count == 0)
        return nil;
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"uitableviewbackground"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    NSString *sectionStr = [self.sectionTitles objectAtIndex:(section)];
    [label setText:sectionStr];
    [contentView addSubview:label];
    return contentView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfer = @"addressCell";
    PersonCell *personcell=(PersonCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
    if(personcell == nil)
    {
        personcell = [[PersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfer];
    }
    
    NSArray *sectionArr = [_listContent objectAtIndex:indexPath.section];
    _people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
    [personcell setData:_people];
    [personcell setItemInBlackList:[self checkItemIsBlackItem:_people.tel]];
    return personcell;
}

-(BOOL)checkItemIsBlackItem:(NSString *)tel{
    for(NSUInteger i=0; i < _blackItemArr.count; i++){
        if( [[_blackItemArr objectAtIndex:i] isEqualToString:tel]){
            return  YES;
        }
    }
    return NO;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentSelIndexPath = indexPath;
    NSArray *sectionArr = [_listContent objectAtIndex:indexPath.section];
    self.people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
    NSString * btnTitle = [self checkItemIsBlackItem:_people.tel] ? @"加入白名单" : @"加入黑名单";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_people.phonename
                                                    message:_people.tel
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:btnTitle, nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSArray *sectionArr = [_listContent objectAtIndex:_currentSelIndexPath.section];
        PersonModel * model = (PersonModel *)[sectionArr objectAtIndex:_currentSelIndexPath.row];
        PersonCell *personcell = (PersonCell*)[_tableShow cellForRowAtIndexPath:_currentSelIndexPath];
        if([self checkItemIsBlackItem:model.tel] == YES){
            NSInteger index = -1;
            for(NSUInteger i=0; i < _blackItemArr.count; i++){
                if( [[_blackItemArr objectAtIndex:i] isEqualToString:model.tel]){
                    index = i;
                }
            }
            if(index > -1){
                [_blackItemArr removeObjectAtIndex:index];
                [personcell setItemInBlackList:NO];
            }
         }else{
            [_blackItemArr addObject:[model.tel copy]];
            [personcell setItemInBlackList:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    if(_blackItemArr != nil){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_blackItemArr forKey:@"blackItemData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
