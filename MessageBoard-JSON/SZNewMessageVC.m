//
//  SZNewMessageVC.m
//  MessageBoard-JSON
//
//  Created by comfouriertech on 17/1/17.
//  Copyright © 2017年 ronghua_li. All rights reserved.
//

#import "SZNewMessageVC.h"

@interface SZNewMessageVC ()
{
    NSString* inputName;
    NSString* inputMessage;
    
}
@end

@implementation SZNewMessageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.activityView setHidden:YES];
    [self.activityIndicator stopAnimating];
    
}
- (IBAction)cancle:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender
{
    //注销键盘第一响应者
    [self.inputTextField resignFirstResponder];
    [self.displayTextView resignFirstResponder];
    //显示加载示意视图
    [self.activityView setHidden:NO];
    [self.activityIndicator  startAnimating];
    //获取输入名字及信息
    inputName=[self.inputTextField text];
    inputMessage=[self.displayTextView text];
    NSDate* date=[NSDate date];
    NSString* formatStr=@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
    NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    
    //构建发送的数据
    NSMutableDictionary* messageDict=[[NSMutableDictionary alloc] initWithCapacity:1];
    [messageDict setObject:inputName forKey:@"name"];
    [messageDict setObject:inputMessage forKey:@"message"];
    [messageDict setObject:[dateFormatter stringFromDate:date] forKey:@"message_date"];
    NSDictionary* postDict=[NSDictionary dictionaryWithObject:messageDict forKey:@"message"];
    //将数据转换为JSON格式
    NSError* JSONSerialerror=nil;
    NSData* jsonData=[NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&JSONSerialerror];
    if (!JSONSerialerror)
    {
        ;
    }
    //创建请求
    NSURL* messageURL=[NSURL URLWithString:kRequestURLString];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:messageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accect"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"&d",[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    //根据请求创建连接
    NSURLConnection* sendConnecttion=[[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    if (sendConnecttion)
    {
        
    }

}
#pragma -mark NSURLConnectionDeleagte
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"the connection is error:%@,%@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.activityView setHidden:YES];
    [self.activityIndicator stopAnimating];
    [NSThread sleepForTimeInterval:1];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark UITextFieleDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.inputTextField resignFirstResponder];
    [self.inputView becomeFirstResponder];
    
}
#pragma mark - Text Field delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTextField resignFirstResponder];
    [self.inputView becomeFirstResponder];
    return  YES;
}
@end
