//
//  SZMessageVC.h
//  MessageBoard-JSON
//
//  Created by comfouriertech on 17/1/17.
//  Copyright © 2017年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionary+nullChange.h"
#import "SZNewMessageVC.h"
@interface SZMessageVC : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NewBtn;
@property (weak, nonatomic) IBOutlet UITableView *MessageTableView;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *refreshLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
