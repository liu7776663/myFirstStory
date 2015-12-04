//
//  ServiceViewController.h
//  Socket
//
//  Created by MS on 15-12-2.
//  Copyright (c) 2015年 刘贺明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *sendtoTF;
@property (weak, nonatomic) IBOutlet UITextField *ipTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
- (IBAction)onClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *chartV;
- (IBAction)send:(id)sender;

@end
