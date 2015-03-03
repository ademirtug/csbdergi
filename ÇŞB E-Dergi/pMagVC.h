//
//  ViewController.h
//  UIPageViewControllerDemo
//
//  Created by Uppal'z on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pPPVC.h"

@interface pMagVC : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSString* pdf_path;
@property (nonatomic) CFURLRef pdfURL;
@property (nonatomic) CGPDFDocumentRef pdf;
@property (nonatomic) NSUInteger year, month;

- (pPPVC*)viewControllerAtIndex:(NSUInteger)index;

- (id)initS:(NSUInteger)_year m:(NSUInteger)_month;


@end
