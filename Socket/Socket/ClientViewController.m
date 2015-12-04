//
//  ClientViewController.m
//  Socket
//
//  Created by MS on 15-12-2.
//  Copyright (c) 2015年 刘贺明. All rights reserved.
//

#import "ClientViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncSocket+nikeName.h"
@interface ClientViewController ()<GCDAsyncSocketDelegate,UITextFieldDelegate,UITableViewDataSource>

@end

@implementation ClientViewController
{
//    定义客户端sorket
    GCDAsyncSocket *_clientSorket;
//    定义收发消息的数据源
    NSMutableArray *_dataArray;
}
- (void)viewDidLoad {
    _dataArray=[NSMutableArray array];
    [super viewDidLoad];
    self.IPTF.delegate=self;
    self.portTF.delegate=self;
    self.chatConnectTV.delegate=self;
    self.nicknameTF.delegate=self;
    self.cheatTV.dataSource=self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)connect:(id)sender {
    
//    调用创建链接
    [self createClientSorket];
}

- (IBAction)send:(id)sender {
    
    _clientSorket.nikeName=self.nicknameTF.text;
    
    NSData *data=[self.chatConnectTV.text dataUsingEncoding:NSUTF8StringEncoding];
    [_clientSorket writeData:data withTimeout:-1 tag:888];
}
-(void)createClientSorket
{
    _clientSorket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error=nil;
    _clientSorket.delegate=self;
    [_clientSorket connectToHost:self.IPTF.text onPort:[self.portTF.text intValue] error:&error];
    if (error) {
        NSLog(@"链接失败%@",error);
    }else{
        NSLog(@"链接成功");
    }
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"已连接到服务端");
//    读数据
    [_clientSorket readDataWithTimeout:-1 tag:999];
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"失去链接");
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *chatString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding    ];
    [_dataArray addObject:chatString];
    [self.cheatTV reloadData];
    [_clientSorket readDataWithTimeout:-1  tag:999];
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSString *string=[NSString stringWithFormat:@"客户端：%@",self.chatConnectTV.text];
    [_dataArray addObject:string];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"CLIENTCELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text=_dataArray[indexPath.row];
    return cell;
}
@end




