//
//  CaiXinViewController.m
//  CellPhone
//
//  Created by cf on 16/6/2.
//  Copyright © 2016年 zhiai. All rights reserved.
//

#import "CaiXinViewController.h"
#import "SVProgressHUD.h"
#import "WebModel.h"

#define caixin_URL @"http://112.124.20.86:8080/jsy_1.0/client!down_MMS?content=20140624165637"
@interface CaiXinViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,NSURLConnectionDataDelegate>
{
     BOOL alreadyEidtText;
    BOOL isdownload;
    NSMutableAttributedString *string;
    NSMutableArray * imgArry;
    NSMutableArray * strArry;
    UIImage * caiXinimg;
    NSUInteger picnumber;
    NSMutableData *_recData;//用于接收下载数据
    NSString * downStr;
    NSString * downLoadWay; //下载路径
    
}
@property (weak, nonatomic) IBOutlet UITextView *CaiXinTextView;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@end

@implementation CaiXinViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        imgArry = [[NSMutableArray alloc]init];
        strArry = [[NSMutableArray alloc]init];
        
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
    self.title = @"自定义彩信";
    // Do any additional setup after loading the view.
    _CaiXinTextView.layer.borderColor = [UIColor blueColor].CGColor;
    _CaiXinTextView.layer.borderWidth = 0.8f;
    _CaiXinTextView.delegate = self;
     alreadyEidtText = NO;
    NSUserDefaults *userdefualts = [NSUserDefaults standardUserDefaults];
    picnumber = [userdefualts integerForKey:@"caixincount"];
    self.CaiXinTextView.text=[userdefualts objectForKey:@"CaiXin"];
    
    if (![[userdefualts objectForKey:@"CaiXin"] isEqualToString:@""]) {
        alreadyEidtText = YES;
        if (picnumber!= 0) {
            
        
        for (int i =0; i<picnumber; i++) {
            
            
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            
            NSString *documentsDirectory=[paths objectAtIndex:0];
              string = [[NSMutableAttributedString alloc] initWithAttributedString:self.CaiXinTextView.attributedText];
            
            NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"CaiXin%d",i]];
            
            caiXinimg = [UIImage imageWithContentsOfFile:path];
            if(caiXinimg){
            [imgArry addObject:caiXinimg];
            
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
            caiXinimg = [self scaleImage:caiXinimg  toScale:0.3];
            textAttachment.image = caiXinimg; //要添加的图片
            
            NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
            
            [string insertAttributedString:textAttachmentString atIndex:self.CaiXinTextView.text.length];//index为用户指定要插入图片的位置
            self.CaiXinTextView.attributedText = string;
            }
        
        }
        
       
        
        
        
    }else
    {
        
    }
        
    }
}

- (IBAction)gotoPhtotoLibrary:(id)sender {
    alreadyEidtText = YES;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil, nil];
    }else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil ,nil];
    }
    
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //来源:相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //来源:相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        }
        else {
            if (buttonIndex == 2) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
   
    [imgArry addObject:image];
  
         string = [[NSMutableAttributedString alloc] initWithAttributedString:self.CaiXinTextView.attributedText];
    
   
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    image = [self scaleImage:image toScale:0.3];
    textAttachment.image = image; //要添加的图片
    
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    
    [string insertAttributedString:textAttachmentString atIndex:self.CaiXinTextView.text.length];//index为用户指定要插入图片的位置
    self.CaiXinTextView.attributedText = string;
   

}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                return scaledImage;
                                
}
                                
                                
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [_CaiXinTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(alreadyEidtText == NO){
        textView.text = @"";
        alreadyEidtText = YES;
    }
    return YES;
}


- (IBAction)downLoad:(id)sender {
    [self removeThepic];
     _recData=[NSMutableData new];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //通过链接地址对象生成请求对象；
    //HHTP协议 超文本传输协议
    //这个HTTP有两种请求数据的方式，POST 和GET
    //默认就是GET；
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:caixin_URL]];
    
    //二、 通过代理那请求结果
    
    //通过request发起一个数据连接，使用代理接收
    
    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
    //状态栏数据加载动画
    
    //状态栏数据加载动画（开始转圈）
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    //取消下载
    //    [connection cancel];
    /*
     1.使用Block          ：Block只关注结果，不关注过程
     
     2.使用代理            ：关注下载过程，可以拿到每次数据大小，便于断点续传；
     
     
     */

}




- (IBAction)saveBtn:(id)sender {
    
  
    [self saveThePicAndMSS];
    [SVProgressHUD showInfoWithStatus:@"添加成功"];

}

-(void)removeThepic
{
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    NSUserDefaults *userdefualts = [NSUserDefaults standardUserDefaults];
    picnumber = [userdefualts integerForKey:@"caixincount"];
    if (picnumber!=0) {
        for (int i = 0; i<picnumber; i++) {
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            
            NSString *documentsDirectory=[paths objectAtIndex:0];
            
            NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"CaiXin%d",i]];
            
            [fileManager removeItemAtPath:savedImagePath error:nil];
        }
    }
}


-(void)saveThePicAndMSS
{
    
    [self removeThepic];
    
    for (int i=0; i<imgArry.count;i++ ) {
        //        NSData *imagedata=UIImagePNGRepresentation(imgArry[i]);
        //JEPG格式
        NSData *imagedata=UIImageJPEGRepresentation(imgArry[i],1.0);
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        
        NSString *documentsDirectory=[paths objectAtIndex:0];
        
        NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"CaiXin%d",i]];
        
        [imagedata writeToFile:savedImagePath atomically:YES];
    }
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_CaiXinTextView.text forKey:@"CaiXin"];
    [defaults setInteger:imgArry.count forKey:@"caixincount"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)cancelSaveBtn:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark -NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //这里的响应，其实是HTTP的响应
    NSHTTPURLResponse*httpResponse=(NSHTTPURLResponse *)response;
    //取得文件名；
    //    NSString *flieName=httpResponse.suggestedFilename;
    //取得文件大小；
    NSString *fileName,*str;
    const char *byte = NULL;
    fileName = [response suggestedFilename];
    byte = [fileName cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    str = [[NSString alloc] initWithCString:byte encoding:
           enc];
    
    
    
    long long fileSize = httpResponse.expectedContentLength;
    
    NSLog(@"flieName==%@,fileSize==%lld",str,fileSize);
    
    //将_recData置零，便于下一次下载；
    _recData.length=0;
    
}

//接收到了数据，如果数据比较大，那么这个方法会调用多次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"每次书局的长度==%ld",data.length);
    
    //拼接二进制数据
    [_recData appendData:data];
    
}
#pragma mark--------------下载成功后的处理
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    isdownload =YES;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];
    
    NSError* fileError = nil;
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:documentsDirectory]) {
        [fm removeItemAtPath:documentsDirectory error:&fileError];
        NSLog(@"删除之前的目标文件%@", fileError);
    }
    

    
    
    
    self.CaiXinTextView.text =@"";
    alreadyEidtText =YES;
    NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/CaiXindoc"];
    NSLog(@"path==%@",path);
    
    //写入沙盒
    [_recData writeToFile:path atomically:YES];
    
    //下载完毕，停止转圈；
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    NSString* toPath = [[self getZIPPath] stringByAppendingPathComponent:@"text"];
    NSLog(@"解压后文件的位置%@", toPath);
    
    
    [WebModel unArchiveFromPath:path toPath:toPath progress:^(CGFloat percentDecompressed) {
        NSLog(@"解压进度%f", percentDecompressed);
    }];
    
    NSLog(@"toPath======%@",toPath);
    downLoadWay = toPath;
    
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:toPath error:nil];
    
    NSString *searchimg = @".jpg";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",[NSString stringWithFormat:@"%@", searchimg]];
   
    NSArray *imgFromDownLoadArray = [files filteredArrayUsingPredicate:predicate];
    
    
    NSString *searchStr = @".txt";
    NSPredicate *predicateStr = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",[NSString stringWithFormat:@"%@", searchStr]];
    NSArray *StrFromDownLoadArray = [files filteredArrayUsingPredicate:predicateStr];
    for (int i =0; i<StrFromDownLoadArray.count; i++) {
        NSString * newstr =[toPath stringByAppendingPathComponent:StrFromDownLoadArray[i]];
        NSLog(@"%@",newstr);
        
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        NSData *data = [fileManager contentsAtPath:newstr];
        
        NSLog(@"%@",data);
        
        
        NSString * bnewstr =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",bnewstr);
        
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* contents = [NSString stringWithContentsOfFile:newstr encoding:gbkEncoding error:nil];
        NSLog(@"%@",contents);
        
        [strArry addObject:contents];
        

    }
    for (int i =0; i<strArry.count-1; i++) {
        
    }
    downStr = [strArry[0] stringByAppendingString:strArry[1]];
    downStr =[downStr stringByAppendingString:strArry[2]];

    NSLog(@"downStrdownStrdownStrdownStrdownStr======================%@",downStr);
   
    NSLog(@"downStr  == ==== ==== %@",downStr);
    self.CaiXinTextView.text = downStr;
    for (int i = 0; i<imgFromDownLoadArray.count; i++) {
         string = [[NSMutableAttributedString alloc] initWithAttributedString:self.CaiXinTextView.attributedText];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
//        caiXinimg = [self scaleImage:imgArry[i] toScale:0.1];
        NSString * newstr =[toPath stringByAppendingPathComponent:imgFromDownLoadArray[i]];
     textAttachment.image =    [UIImage imageWithContentsOfFile:newstr];
        
        [imgArry addObject:textAttachment.image];
        
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
        
        [string insertAttributedString:textAttachmentString atIndex:self.CaiXinTextView.text.length];//index为用户指定要插入图片的位置
        self.CaiXinTextView.attributedText = string;
    }
    
    [SVProgressHUD showSuccessWithStatus:@"下载成功"];
   
}





//解压zip包
-(void)unArchive{
    NSString* fromPath = [[self getZIPPath] stringByAppendingPathComponent:@"/CaiXindoc/20140624165637.zip"];
    NSString* toPath = [[self getZIPPath] stringByAppendingPathComponent:@"text"];
    NSLog(@"解压后文件的位置%@", toPath);
    [WebModel unArchiveFromPath:fromPath toPath:toPath progress:^(CGFloat percentDecompressed) {
        NSLog(@"解压进度%f", percentDecompressed);
    }];
    //
    

}




#pragma mark -
#pragma mark - publicMethod
- (NSString*)getZIPPath{
    
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* userPath = [docPath stringByAppendingPathComponent:@"webZIP"];
    
    BOOL isDir = NO;
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL existed = [fm fileExistsAtPath:userPath isDirectory:&isDir];
    
    if (!(isDir && existed)) {
        [fm createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return userPath;
    
}

//删除ZIP包 需要名字
-(void)deleteFileByName:(NSString*)fileName{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSError* error = nil;
    
    NSString* filePath = [[self getZIPPath] stringByAppendingPathComponent:fileName];
    if ([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:&error];
        NSLog(@"文件删除了");
    }
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    
    NSLog(@"数据请求失败，error==%@",error);
    
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
