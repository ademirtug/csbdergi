//
//  csbPPVC.h
//  edergi
//
//  Created by Akın Demirtuğ on 8/1/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPVC : UIViewController


@property (assign, nonatomic) NSUInteger sayfa;
@property (nonatomic) CGPDFDocumentRef pdf;


-(id)initS:(NSUInteger) pn pdfref:(CGPDFDocumentRef) pdfdosya;
-(void)setupView:(CGRect) fr;

@end
