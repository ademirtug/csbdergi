//
//  ContentViewController.h
//  UIPageViewControllerDemo
//
//  Created by Uppal'z on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pPPVC : UIViewController

@property (assign, nonatomic) NSUInteger sayfa;
@property (nonatomic) CGPDFDocumentRef pdf;


-(id)initS:(NSUInteger) pn pdfref:(CGPDFDocumentRef) pdfdosya;
-(void)setupView:(CGRect) fr;


@end
