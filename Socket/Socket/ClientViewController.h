//
//  ClientViewController.h
//  Socket
//
//  Created by MS on 15-12-2.
//  Copyright (c) 2015年 刘贺明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *IPTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
- (IBAction)connect:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *cheatTV;
@property (weak, nonatomic) IBOutlet UITextField *chatConnectTV;
- (IBAction)send:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;

@end
