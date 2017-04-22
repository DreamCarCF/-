
#import "DemoViewController.h"
#import "SettingStyleViewController.h"
#import "SendHistoryViewController.h"
#import "selecCheckViewController.h"
#import "DIYmsgViewController.h"
#import "CheckMoneyViewController.h"
#import "BlackContanctViewController.h"
#import "SystemNoticeViewController.h"
#import "PhoneViewController.h"
@interface DemoViewController ()

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

-(void)pretendData{
    data_source_ary = [NSMutableArray new];
    for (int x = 0; x < USER_MAX; x++){
        NSMutableDictionary *add_user_dict=[NSMutableDictionary new];
        [add_user_dict setValue:[NSString stringWithFormat:@"User%i",x]
                         forKey:KEY_USER_NAME];
        
        [add_user_dict setValue:[NSString stringWithFormat:@"home_mbank_%i_normal.png",x+1]
                         forKey:KEY_USER_IMAGE];
        [data_source_ary addObject:add_user_dict];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self pretendData];
    rotary=[[RotarySelector alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80,self.view.frame.size.width-80)];
    [rotary setDelegate:self];
    rotary.center=CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-400);
    [self.view addSubview:rotary];
    // Do any additional setup after loading the view.
}

-(UIColor *)rotarySelectorBackgroundColor{
    return [UIColor clearColor];
}

-(UIImage *)rotarySelectorBackgroundImage{
    return [UIImage imageNamed:@"ee.png"];
}

-(UIImage *)rotarySelectorCircleImageAtIndx:(int)indx{
    return [UIImage imageNamed:[[data_source_ary objectAtIndex:indx]
                                objectForKey:KEY_USER_IMAGE]];
}

-(BOOL)rotarySelectorCircleHaveSameDirection{
    return NO;
}

-(void)rotarySelectorClickCircleAtIndx:(int)indx{
    NSLog(@"click  %@'s picture",[[data_source_ary objectAtIndex:indx]
                                  objectForKey:KEY_USER_NAME]);

    if (indx == 0) {
        SettingStyleViewController * setVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingStyleViewController"];
        [self.navigationController pushViewController:setVC animated:YES];}
    else if (indx ==1 )
    {
        CheckMoneyViewController * checkVC =[self.storyboard instantiateViewControllerWithIdentifier:@"CheckMoneyViewController"];
        [self.navigationController pushViewController:checkVC animated:YES];
    }else if (indx == 2 )
    {
        DIYmsgViewController * DIYVC =[self.storyboard instantiateViewControllerWithIdentifier:@"DIYmsgViewController"];
        [self.navigationController pushViewController:DIYVC animated:YES];
    }else if (indx == 3 )
    {
        SendHistoryViewController * sendVC =[self.storyboard instantiateViewControllerWithIdentifier:@"SendHistoryViewController"];
        [self.navigationController pushViewController:sendVC animated:YES];
    }else if (indx == 4 )
    {
        BlackContanctViewController * blackVC =[self.storyboard instantiateViewControllerWithIdentifier:@"BlackContanctViewController"];
        [self.navigationController pushViewController:blackVC animated:YES];
    }else if (indx == 5 )
    {
        selecCheckViewController * seleVC =[self.storyboard instantiateViewControllerWithIdentifier:@"selecCheckViewController"];
        [self.navigationController pushViewController:seleVC animated:YES];
    }else if (indx == 6)
    {
        SystemNoticeViewController * sysNotVC =[self.storyboard instantiateViewControllerWithIdentifier:@"SystemNoticeViewController"];
        [self.navigationController pushViewController:sysNotVC animated:YES];
    }else if (indx == 7)
    {
        PhoneViewController * phoneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhoneViewController"];
        [self.navigationController pushViewController:phoneVC animated:YES];
    }
    
    
}

-(void)rotarySelectorDidChangeToIndx:(int)indx{
    NSLog(@"rotary change to user : %@",[[data_source_ary objectAtIndex:indx]
                                         objectForKey:KEY_USER_NAME]);
}

-(int)rotarySelectorCircleCount{
    return [data_source_ary count];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
