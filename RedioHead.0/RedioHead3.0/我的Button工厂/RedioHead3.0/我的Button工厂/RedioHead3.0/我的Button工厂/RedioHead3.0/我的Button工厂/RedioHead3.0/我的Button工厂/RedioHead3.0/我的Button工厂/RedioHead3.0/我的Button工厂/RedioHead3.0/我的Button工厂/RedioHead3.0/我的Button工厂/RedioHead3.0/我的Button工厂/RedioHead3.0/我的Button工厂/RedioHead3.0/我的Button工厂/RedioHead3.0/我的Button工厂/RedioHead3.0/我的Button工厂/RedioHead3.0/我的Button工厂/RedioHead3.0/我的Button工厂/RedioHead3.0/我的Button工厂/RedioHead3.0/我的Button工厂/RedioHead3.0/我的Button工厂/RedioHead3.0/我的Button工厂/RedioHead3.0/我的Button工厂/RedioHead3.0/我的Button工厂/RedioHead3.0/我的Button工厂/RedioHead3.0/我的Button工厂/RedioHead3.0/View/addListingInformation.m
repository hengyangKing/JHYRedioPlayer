//
//  addListingInformation.m
//  RedioHead3.0
//
//  Created by J on 15/8/16.
//  Copyright (c) 2015年 J. All rights reserved.
//

#import "addListingInformation.h"
#import "MyButtonShop.h"
#import "RootViewController.h"
#import "MusicListingDBManager.h"
@interface addListingInformation ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *goHomeButton;
@property(nonatomic,strong)UIButton *downButton;
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation addListingInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    [self createTitleUI];
    [self createUI];
    [self.textField becomeFirstResponder];
    
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    UIView *textFieldView=[[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 50)];
    textFieldView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.95];
    [self.view addSubview:textFieldView];
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(5, 5, textFieldView.frame.size.width-10, 40)];
    _textField.placeholder=@"请输入列表名";
    [_textField setBorderStyle:(UITextBorderStyleNone)];
    _textField.returnKeyType=UIReturnKeyDefault;
    [textFieldView addSubview:_textField];

}
-(void)createTitleUI
{
    _titleView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 64)];
    _titleView.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
    [self.view addSubview:_titleView];
    
    _goHomeButton=[MyButtonShop createButtonWithFrame:CGRectMake(5, 20, 50, 44-10) andTitle:@"取消" andImage:nil andBgImage:nil andSelecter:@selector(toListingViewController) andTarget:self];
    _goHomeButton.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [_titleView addSubview:_goHomeButton];
    
    _downButton=[MyButtonShop createButtonWithFrame:CGRectMake(self.view.frame.size.width-55, 20, 50, 44-10) andTitle:@"完成" andImage:nil andBgImage:nil andSelecter:@selector(saveInformation) andTarget:self];
    _downButton.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [_titleView addSubview:_downButton];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 20, 100, 44-10)];
    _titleLabel.text=@"创建新列表";
    _titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [_titleView addSubview:_titleLabel];
    
    
}
-(void)saveInformation
{
 
    MusicListingDBManager *musicListDBManager=[MusicListingDBManager sharedManager];
    if (_textField.text.length>0)
    {
        musicListDBManager.listName=_textField.text;
    }
    
    
}
-(void)toListingViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
