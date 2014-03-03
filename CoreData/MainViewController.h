//
//  MainViewController.h
//  CoreData
//
//  Created by Xchobo on 2014/3/3.
//  Copyright (c) 2014年 Xchobo. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
