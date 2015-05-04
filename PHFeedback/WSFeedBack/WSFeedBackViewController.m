//
//  ViewController.m
//  PHFeedback
//
//  Created by penghe on 15/4/30.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import "WSFeedBackViewController.h"
#import "PHPlaceholderTextView.h"
#import "WSFeedBackAddPhotoCell.h"
#import "QBImagePickerController.h"

@interface WSFeedBackViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, QBImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate,UICollectionViewDelegateFlowLayout>
//邮箱或者手机
@property (weak, nonatomic) IBOutlet UITextField *mailOrPhoneTextField;
//反馈内容
@property (weak, nonatomic) IBOutlet PHPlaceholderTextView *feedContent;
//反馈需要添加的图
@property (nonatomic, strong) NSMutableArray *feedAddImagesArray;
//选择相册的controller
@property (nonatomic, strong) QBImagePickerController *imagePickerController;
//意见反馈已经添加的图片
@property (weak, nonatomic) IBOutlet UICollectionView *imageAddCollectionView;
//提交反馈的按钮
@property (weak, nonatomic) IBOutlet UIButton *submitFeedBackButton;
@end

static NSString *const feedPhotoCellIndentifer = @"feedPhotoCellIndentifer";
#define kMailOrPhoneCellHeight 110.0f
#define kFeedBackContentCellHeight 168.0f
#define KAddImagesCollectionViewCellHeight 80.0f
#define kSubmitButtonCellHeight 54.0f

@implementation WSFeedBackViewController
- (NSMutableArray *)feedAddImagesArray
{
    if (_feedAddImagesArray == nil) {
        _feedAddImagesArray = [NSMutableArray array];
    }
    return _feedAddImagesArray;
}

#pragma mark
#pragma mark -- Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupMailOrPhoneTextFiled];
    [self setupFeedContentTextView];
    [self setupTapTableView];
}

#pragma mark
#pragma mark -- setup

- (void)setupTapTableView
{
    [self.view setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:236/255.0 alpha:1.0]];

}
- (void)setupMailOrPhoneTextFiled
{
    self.mailOrPhoneTextField.layer.borderWidth = 1.0;
    self.mailOrPhoneTextField.layer.cornerRadius = 3.0;
    self.mailOrPhoneTextField.layer.borderColor = [UIColor colorWithRed:208/255.0 green:209/255.0 blue:211/255.0 alpha:1.0].CGColor;
    self.mailOrPhoneTextField.text = [self setMyNumber];
    self.mailOrPhoneTextField.delegate = self;
}
- (void)setupFeedContentTextView
{
    self.feedContent.layer.borderWidth = 1.0;
    self.feedContent.layer.cornerRadius = 3.0;
    self.feedContent.delegate = self;
    self.feedContent.layer.borderColor = [UIColor colorWithRed:208/255.0 green:209/255.0 blue:211/255.0 alpha:1.0].CGColor;
    self.feedContent.placeholder = @"反馈内容...";
    self.feedContent.placeholderTextColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1.0];
}

#pragma mark
#pragma mark -- Actions
- (IBAction)tapFeed:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
- (IBAction)submitFeedBackAction:(id)sender
{
    //提交反馈 成功则退出
}
- (IBAction)backFeedBackAction:(id)sender
{
    //如果已经在编辑但是想退出
    if([self.mailOrPhoneTextField.text length]!=0 ||[self.feedContent.text length]!=0||self.feedAddImagesArray.count!=0)
    {
        //弹出是否取消编辑
        UIAlertView *popAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否取消编辑" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [popAlertView show];
        
    }
    else
    {
        //直接退出
       // [self.navigationController popViewControllerAnimated:YES];
        
    }
}
//返回本机手机号
-(NSString *)setMyNumber{
    return CTSettingCopyMyPhoneNumber();
}
//判断电话或者建议的内容是不是空
- (BOOL)checkTextFieldOrTextViewTextIsNilOrNotAction
{
    if ([self.mailOrPhoneTextField.text length]==0) {
        
        return NO;
    }
    else if ([self.feedContent.text length]==0) {
        return NO;
        
    }
    else
    {
        return YES;

    }
    return YES;
}
#pragma mark
#pragma mark -- UITableViewDegate And UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row==0) {
        return kMailOrPhoneCellHeight;
    }
    if (indexPath.row==1) {
        return kFeedBackContentCellHeight;
    }
    if (indexPath.row==2) {

        //获取collectionView 当前的几列
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.imageAddCollectionView.collectionViewLayout;

        CGFloat availableHeight = flowLayout.collectionViewContentSize.height - (flowLayout.sectionInset.top + flowLayout.sectionInset.bottom);
        //向下取整,垂直方向cell的行数
        int itemsAcross = floorf((availableHeight + flowLayout.minimumInteritemSpacing) / (flowLayout.itemSize.height + flowLayout.minimumInteritemSpacing));
        CGRect frame = self.imageAddCollectionView.frame;
        frame.size.height = KAddImagesCollectionViewCellHeight*itemsAcross+flowLayout.itemSize.height + flowLayout.minimumInteritemSpacing;
        self.imageAddCollectionView.frame = frame;
        return KAddImagesCollectionViewCellHeight*itemsAcross+flowLayout.itemSize.height + flowLayout.minimumInteritemSpacing;
    }
    if (indexPath.row==3) {
        return kSubmitButtonCellHeight;
    }
    return 0;
}

#pragma mark
#pragma mark -- UICollectionViewDelegate And UIcolloectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.feedAddImagesArray.count>=4) {
        
        return self.feedAddImagesArray.count;
    }
    else
    {
        return self.feedAddImagesArray.count+1;

    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSFeedBackAddPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:feedPhotoCellIndentifer forIndexPath:indexPath];
    if (self.feedAddImagesArray.count==0)
    {

    }
    else
    {
        if (indexPath.row==self.feedAddImagesArray.count)
        {
            
        }
        else
        {
            UIImage *addedImage = self.feedAddImagesArray[indexPath.row];

            [cell.addImageIconView setImage:addedImage];
            
        }
    }
   
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self tapFeed:nil];
    if (indexPath.row==self.feedAddImagesArray.count) {
        

        self.imagePickerController = [[QBImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        self.imagePickerController.allowsMultipleSelection = YES;
        if (self.feedAddImagesArray.count==0) {
            self.imagePickerController.maximumNumberOfSelection = 4;

        }
        else
        {
            self.imagePickerController.maximumNumberOfSelection = 4-self.feedAddImagesArray.count;
        }
    
        [self.navigationController pushViewController:self.imagePickerController animated:YES];

    }
}


#pragma mark
#pragma mark - PHPhotoBrowser

////设置图片浏览
//- (void)setupPhotoBrowser
//{
//
//    
//    BOOL displayActionButton = NO;
//    BOOL displaySelectionButtons = NO;
//    BOOL displayNavArrows = YES;
//    BOOL enableGrid = NO;
//    BOOL startOnGrid = YES;
//    
//    // Create browser
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = displayActionButton;
//    browser.displayNavArrows = displayNavArrows;
//    browser.displaySelectionButtons = displaySelectionButtons;
//    browser.alwaysShowControls = displaySelectionButtons;
//    browser.zoomPhotosToFill = YES;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//    browser.wantsFullScreenLayout = YES;
//#endif
//    browser.enableGrid = enableGrid;
//    browser.startOnGrid = startOnGrid;
//    browser.enableSwipeToDismiss = NO;
//    [browser showNextPhotoAnimated:YES];
//    [browser showPreviousPhotoAnimated:YES];
//    [browser setCurrentPhotoIndex:tapPhotoIndex];
//    
//    
//    // Push photo browser
//    [self.navigationController pushViewController:browser animated:YES];
//}
#pragma mark
#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    
    [self dismissImagePickerController];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    
    //异步处理
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i =0; i<assets.count; i++) {
            ALAsset *asset = assets[i];
            CGImageRef cgImage = CGImageRetain(asset.thumbnail);
            UIImage *image=[UIImage imageWithCGImage:cgImage];
            CGImageRelease(cgImage);
            [self.feedAddImagesArray addObject:image];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self dismissImagePickerController];
            [self.imageAddCollectionView reloadData];
            [self.tableView reloadData];
            
        });
        
    });
    
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissImagePickerController];
}
//选择相册的取消
- (void)dismissImagePickerController
{
    [self.navigationController
     
     
     popToViewController:self animated:YES];
}
#pragma mark
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   if([textField.text length]!=0)
   {
       //判断手机或者邮箱格式
   }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([self checkTextFieldOrTextViewTextIsNilOrNotAction] == YES )
    {
        [self.submitFeedBackButton setImage:[UIImage imageNamed:@"feedback_Icon"] forState:UIControlStateNormal];
        self.submitFeedBackButton.userInteractionEnabled = YES;
        
    }
    else
    {
        [self.submitFeedBackButton setImage:[UIImage imageNamed:@"feedback_Icon_gray"] forState:UIControlStateNormal];
        
        self.submitFeedBackButton.userInteractionEnabled = NO;
        
    }
    return YES;
}

#pragma mark
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{


}
- (void)textViewDidChange:(UITextView *)textView
{
    if([self checkTextFieldOrTextViewTextIsNilOrNotAction] == YES )
    {
        [self.submitFeedBackButton setImage:[UIImage imageNamed:@"feedback_Icon"] forState:UIControlStateNormal];
        self.submitFeedBackButton.userInteractionEnabled = YES;

    }
    else
    {
        [self.submitFeedBackButton setImage:[UIImage imageNamed:@"feedback_Icon_gray"] forState:UIControlStateNormal];

        self.submitFeedBackButton.userInteractionEnabled = NO;

    }
}
#pragma mark 
#pragma mark -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
        
    }
    if (buttonIndex==1) {
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
}
@end
