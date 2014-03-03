//
//  MainViewController.m
//  CoreData
//
//  Created by Xchobo on 2014/3/3.
//  Copyright (c) 2014年 Xchobo. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

static NSString *entityname = @"Orders";
static NSString *namecol = @"name";
static NSString *pricecol = @"price";
static NSString *quantitycol = @"quantity";


@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UITextField *namefield;
@property (strong, nonatomic) IBOutlet UITextField *pricefield;
@property (strong, nonatomic) IBOutlet UITextField *quantityfield;
@property (strong, nonatomic) IBOutlet UILabel *statuslabel;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSManagedObject *matchdata;

- (IBAction)saveData:(id)sender;
- (IBAction)readData:(id)sender;
- (IBAction)upData:(id)sender;
- (IBAction)delData:(id)sender;

- (IBAction)disableKeyboard:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //建立資料庫的操作對象
    _context = [appDelegate managedObjectContext];
    
    [_statuslabel setText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (IBAction)saveData:(id)sender {
    //建立管理物件
    NSManagedObject *newContact = [NSEntityDescription
                                   insertNewObjectForEntityForName:entityname
                                   inManagedObjectContext:_context];
    
    //設定
    [newContact setValue:[_namefield text] forKey:namecol];
    [newContact setValue:[_pricefield text] forKey:pricecol];
    [newContact setValue:[_quantityfield text] forKey:quantitycol];
    
    //儲存
    NSError *error;
    [_context save:&error];
    
    //清空
    [_namefield setText:@""];
    [_pricefield setText:@""];
    [_quantityfield setText:@""];
    [_statuslabel setText:@"Data saved"];
}

- (IBAction)readData:(id)sender {
    //建立實體
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityname
                                                  inManagedObjectContext:_context];
    //建立查詢
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //查詢條件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name = %@)", [_namefield text]];
    [request setPredicate:predicate];
    
    //取回資料
    NSError *error;
    NSArray *orderslist = [_context executeFetchRequest:request error:&error];
    
    if ([orderslist count] == 0) {
        [_statuslabel setText:@"No Match"];
    } else {
        _matchdata = [orderslist objectAtIndex:0];
        [_pricefield setText:[_matchdata valueForKey:pricecol]];
        [_quantityfield setText:[_matchdata valueForKey:quantitycol]];
        [_statuslabel setText:[NSString stringWithFormat:@"%d found", [orderslist count]]];
        NSLog(@"=>%d", [orderslist count]);
    }
}

- (IBAction)upData:(id)sender {
    if (_matchdata) {
        //重新設定資料
        [_matchdata setValue:[_namefield text] forKey:namecol];
        [_matchdata setValue:[_pricefield text] forKey:pricecol];
        [_matchdata setValue:[_quantityfield text] forKey:quantitycol];
        NSError *error;
        [_context save:&error];
        
        //清空
        [_namefield setText:@""];
        [_pricefield setText:@""];
        [_quantityfield setText:@""];
        [_statuslabel setText:@"UPData OK"];
    }else{
        NSLog(@"NO Data Updata");
    }
}

- (IBAction)delData:(id)sender {
    if (_matchdata) {
        
        //刪除資料
        [_context deleteObject:_matchdata];
        
        //清空
        [_namefield setText:@""];
        [_pricefield setText:@""];
        [_quantityfield setText:@""];
        [_statuslabel setText:@"Del Data OK"];
    }else{
        NSLog(@"NO Data Delete");
    }
}

- (IBAction)disableKeyboard:(id)sender {
}
@end
