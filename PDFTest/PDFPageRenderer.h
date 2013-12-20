//
//  PDFPageRenderer.h
//  PDFTest
//
//  Created by Geoff Spears on 12/19/2013.
//  Copyright (c) 2013 Geoff Spears. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RendererDelegate <NSObject>

-(void)renderingComplete:(NSString *)filename;

@end

@interface PDFPageRenderer : UIPrintPageRenderer

@property id<RendererDelegate>delegate;

- (void)saveToPDF:(NSString *)filename;

@end
