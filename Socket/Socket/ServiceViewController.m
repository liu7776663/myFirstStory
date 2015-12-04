//
//  ServiceViewController.m
//  Socket
//
//  Created by MS on 15-12-2.
//  Copyright (c) 2015年 刘贺明. All rights reserved.
//

#import "ServiceViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncSocket+nikeName.h"

@interface ServiceViewController ()<UITableViewDataSource,UITableViewDelegate,GCDAsyncSocketDelegate,UITextFieldDelegate>

@end

@implementation ServiceViewController
{
//    定义服务端sorket对象
    GCDAsyncSocket *_serviceSocket;
//    定义用于装载客户端对象的数组
    NSMutableArray *_clientSockets;
//    消息数据源
    NSMutableArray *_dataArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ipTF.delegate=self;
    self.portTF.delegate=self;
    self.chartV.delegate=self;
    self.chartV.dataSource=self;
    self.sendtoTF.delegate=self;
//    数据源初始化
    _dataArray=[NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)onClick:(id)sender {
//    调用服务端sorket初始化方法并且启动监听
    [self createServiceSocket];
    
}

#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"CELLID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text=_dataArray[indexPath.row];
    return cell;
}

#pragma mark Socket
-(void)createServiceSocket
{
    _clientSockets=[NSMutableArray array];
//    初始化
//    参数1：代理类 参数2：代理队列
    if(_serviceSocket == nil){
        _serviceSocket=[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
   //    监听端口
    NSError *error=nil;
    [_serviceSocket acceptOnPort:[self.portTF.text intValue] error:&error];
    if (error) {
        NSLog(@"监听失败：%@",error);
    }else{
        NSLog(@"监听成功");
    }
}

//协议，监听到新的客户端sorket
//sock代表_serviceSocket
//newSocket 代表客户端socket
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
//     存储
    [_clientSockets addObject:newSocket];
//    先被动的读信息，才能接收到发送过来的信息
    for (GCDAsyncSocket *cSocket in _clientSockets) {
//        读信息，监听有没有发送信息
//        第一个参数：时间限制 -1不限制时间
//        参数2：消息tag
        [cSocket readDataWithTimeout:-1 tag:888];
        
    }
//    每读一次只能处理发送过来的一条信息
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    将data转化成消息string
    NSString *charString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    tableView
    [_dataArray addObject:charString];
    [self.chartV reloadData];
//    继续读
    for (GCDAsyncSocket *cSorket in _clientSockets) {
        [cSorket readDataWithTimeout:-1 tag:888];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)send:(id)sender {
    
//    发送消息到客户端
    NSData *data=[self.ipTF.text dataUsingEncoding:NSUTF8StringEncoding];
    GCDAsyncSocket *toSocket=nil;
    for (GCDAsyncSocket *cSocket in _clientSockets) {
        if ([self.sendtoTF.text isEqualToString:cSocket.nikeName]) {
            toSocket=cSocket;
        }
    }
    if (toSocket==nil) {
        NSLog(@"用户不存在");
    }else{
        [toSocket writeData:data withTimeout:-1 tag:999];
    }
}


-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [_dataArray addObject:[NSString stringWithFormat:@"服务器：%@",self.ipTF.text]];
    [self.chartV reloadData];
}

@end
