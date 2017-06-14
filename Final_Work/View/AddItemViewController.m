//
//  AddItemViewController.m
//  Final_Work
//
//  Created by Chang Hao Chao on 2017/6/10.
//  Copyright © 2017年 Chang Hao Chao. All rights reserved.
//

#import "AddItemViewController.h"
#import "RootViewController.h"
#import "CostsListViewController.h"

#import "Item.h"
#import "ItemManager.h"

#import <MagicalRecord/MagicalRecord.h>
#import <GPUImage/GPUImage.h>

@interface AddItemViewController ()

@end

@implementation AddItemViewController {
    UIDatePicker *datePicker;
    NSDateFormatter *formatter;
    
    TZImagePickerController *imagePC;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemName.delegate = self;
    _itemPrice.delegate = self;
    _itemDate.delegate = self;
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    [_itemDate setInputView:datePicker];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    [self chooseDate:datePicker];
    
    if (self.item.name) _itemName.text = self.item.name;
    if (self.item.priceValue) _itemPrice.text = [NSString stringWithFormat:@"%@", self.item.price];
    if (self.item.date) _itemDate.text = [formatter stringFromDate:self.item.date];
    if (self.item.image) {
        UIImage *image = [UIImage imageWithData:self.item.image];
        [_itemImage setImage:image forState:UIControlStateNormal];
    }
    //space
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *nameToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [nameToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *nameDoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(nameDoneButtonPressed)];
    
    [nameToolBar setItems:[NSArray arrayWithObjects:space,nameDoneBtn, nil]];
    [_itemName setInputAccessoryView:nameToolBar];
    //price
    UIToolbar *priceToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [priceToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *priceDoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(priceDoneButtonPressed)];
    
    [priceToolBar setItems:[NSArray arrayWithObjects:space,priceDoneBtn, nil]];
    [_itemPrice setInputAccessoryView:priceToolBar];
    //date
    UIToolbar *dateToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [dateToolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *dateDoneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dateDoneButtonPressed)];
    [dateToolBar setItems:[NSArray arrayWithObjects:space,dateDoneBtn, nil]];
    [_itemDate setInputAccessoryView:dateToolBar];
    //Comfirm button in navigation bar
    UIBarButtonItem *comfirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"Comfirm" style:UIBarButtonItemStyleDone target:self action:@selector(confirmButtonPressed)];
    self.navigationItem.rightBarButtonItem = comfirmBtn;
    [self.navigationItem setTitle:_item.category];
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    imagePC= [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];//设置多选最多支持的最大数量，设置代理
    [imagePC setDidFinishPickingPhotosHandle:^(NSArray *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        _isSelectOriginalPhoto = isSelectOriginalPhoto;
        [_itemImage setImage:_selectedPhotos[0] forState:UIControlStateNormal];
        NSData *imageData = UIImagePNGRepresentation(_selectedPhotos[0]);
        self.item.image = imageData;
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rootViewController setTitle:@"Add Item"];
    //        [self.addItemView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
//    if (self.maxCountTF.text.integerValue > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    imagePickerVc.isStatusBarDefault = NO;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;

}

#pragma mark - UITableViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    if(textField.tag == 0) {
    }
    else if(textField.tag == 1) {
    }
    else if(textField.tag == 2) {
        if (datePicker.superview) {
            [datePicker removeFromSuperview];
        } else {
            [self chooseDate:datePicker];
        }
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    //設定動畫開始時的狀態為目前畫面上的樣子
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    _addItemView.frame = CGRectMake(_addItemView.frame.origin.x,
                                    _addItemView.frame.origin.y - 210,
                                    _addItemView.frame.size.width,
                                    _addItemView.frame.size.height);
    [UIView commitAnimations];
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    //設定動畫開始時的狀態為目前畫面上的樣子
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    _addItemView.frame = CGRectMake(_addItemView.frame.origin.x,
                                    _addItemView.frame.origin.y + 210,
                                    _addItemView.frame.size.width,
                                    _addItemView.frame.size.height);
    
    [UIView commitAnimations];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _itemDate.placeholder = @"YYYY / MM / DD";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - IBAction
- (IBAction)photoButtonPressed:(id)sender {
    [self presentViewController:imagePC animated:YES completion:nil];//跳转
}


#pragma mark - private method
-(void)chooseDate:(UIDatePicker *)datePick
{
    NSDate *selectedDate = datePick.date;
    _itemDate.text = [formatter stringFromDate:selectedDate];
}
-(void)dateDoneButtonPressed
{
    _itemDate.text = [formatter stringFromDate:datePicker.date];
    [_itemDate resignFirstResponder];
}
-(void)priceDoneButtonPressed
{
    [_itemPrice resignFirstResponder];
}
-(void)nameDoneButtonPressed
{
    [_itemName resignFirstResponder];
}

-(void)confirmButtonPressed {
    if (_itemPrice.text.length > 0 & _itemName.text.length > 0) {
        
        self.item.name = _itemName.text;
        self.item.priceValue = [_itemPrice.text floatValue];
        self.item.date = [formatter dateFromString:_itemDate.text];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        //Inform app
        [[NSNotificationCenter defaultCenter] postNotificationName:ItemsSynchronizedNotificationName object:nil];
        
        //dismiss view
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"名字、價錢或日期未填" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:^{}];
    }
}


@end
