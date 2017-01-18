//
//  SZMessageVC.m
//  MessageBoard-JSON
//
//  Created by comfouriertech on 17/1/17.
//  Copyright © 2017年 ronghua_li. All rights reserved.
//

#import "SZMessageVC.h"

@interface SZMessageVC ()
{
    NSArray* messageArray;
    NSMutableData* connectData;
}
@end

@implementation SZMessageVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.MessageTableView.dataSource=self;
    self.MessageTableView.delegate=self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.activityView setHidden:NO];
    [self.activityIndicator startAnimating];
    NSURL* requestURL=[NSURL URLWithString:kRequestURLString];
    NSURLRequest* request=[[NSURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.];
    NSURLConnection* theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    if (theConnection)
    {
        connectData=[[NSMutableData alloc] init];
        NSLog(@"the Connection is scuess:%@",theConnection);
    }
    else
    {
        NSLog(@"Connection Failed!");
        self.activityView.hidden=YES;
        [self.activityIndicator stopAnimating];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [connectData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [connectData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* responseStr=[NSString stringWithUTF8String:[connectData bytes]];
    NSLog(@"responseStr:%@",responseStr);
    
    NSError* error=nil;
    NSArray* jsonArray=[NSJSONSerialization JSONObjectWithData:connectData options:0 error:&error];
    if (!error)
    {
        messageArray=jsonArray;
        NSLog(@"messageArray:%@",messageArray);
        [self.MessageTableView reloadData];
    }
    else
    {
        NSLog(@"parsing error:%@",error);
    }
    [self.activityView setHidden:YES];
    [self.activityIndicator stopAnimating];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"[messageArray count]:%lu\n",(unsigned long)[messageArray count]);
    return [messageArray count]-1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* const cellID=@"cellID";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSDictionary* messageDict=[[messageArray objectAtIndex:indexPath.row] objectForKey:@"message"];
    //从后台获取的部分数据的详细message为空，，防止程序崩溃,将空的数据NSNull转换为@“<NSNull>”
    messageDict=[NSDictionary changeType:messageDict];
    NSString* detailStr=[NSString stringWithFormat:@"by %@ on %@",[messageDict objectForKey:@"name" ],[messageDict objectForKey:@"message_date"]];
    NSString* titleStr=[messageDict objectForKey:@"message"];
    cell.textLabel.text=titleStr;
    cell.detailTextLabel.text=detailStr;
    return cell;
}
- (IBAction)NewMessage:(id)sender
{
    SZNewMessageVC* newMessageVC=[[SZNewMessageVC alloc] init];
    [self.navigationController pushViewController:newMessageVC animated:YES];
}
@end
