//
//  ViewController.m
//  BandLayer
//
//  Created by 能登 要 on 12/11/09.
//  Copyright (c) 2012年 irimasu. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
{
    CALayer* _layerBandLeftEdge;
    CALayer* _layerBandTopEdge;
    CALayer* _layerBandRightEdge;
    CALayer* _layerBandBottomEdge;
    NSValue* _bandRect;
    
}

@property(nonatomic,readonly) CALayer* layerBandLeftEdge;
@property(nonatomic,readonly) CALayer* layerBandTopEdge;
@property(nonatomic,readonly) CALayer* layerBandRightEdge;
@property(nonatomic,readonly) CALayer* layerBandBottomEdge;
@property(nonatomic,strong) NSValue* bandRect;

@end

@implementation ViewController

- (NSValue*) bandRect
{
    return _bandRect;
}

- (void) setBandRect:(NSValue*)bandRect
{
    _bandRect = bandRect;
    
    CGRect rectBand = _bandRect != nil ? [_bandRect CGRectValue] : CGRectZero;
    if( CGRectIsEmpty(rectBand) != YES ){
#define EDGE_STROKE_SIZE 3.0f
        self.layerBandLeftEdge.bounds = CGRectMake(.0f,.0f,EDGE_STROKE_SIZE,rectBand.size.height -EDGE_STROKE_SIZE );
        self.layerBandLeftEdge.position = CGPointMake(rectBand.origin.x + EDGE_STROKE_SIZE *.5f,rectBand.origin.y + (rectBand.size.height-EDGE_STROKE_SIZE) * .5f);
        if( self.layerBandLeftEdge.superlayer != self.view.layer )
            [self.view.layer addSublayer:self.layerBandLeftEdge];
        
        self.layerBandTopEdge.bounds = CGRectMake(.0f,.0f,rectBand.size.width -EDGE_STROKE_SIZE ,EDGE_STROKE_SIZE);
        self.layerBandTopEdge.position = CGPointMake(rectBand.origin.x + (rectBand.size.width+EDGE_STROKE_SIZE) * .5f,rectBand.origin.y +EDGE_STROKE_SIZE *.5f);
        if( self.layerBandTopEdge.superlayer != self.view.layer )
            [self.view.layer addSublayer:self.layerBandTopEdge];
        
        self.layerBandRightEdge.bounds = CGRectMake(.0f,.0f,EDGE_STROKE_SIZE,rectBand.size.height -EDGE_STROKE_SIZE);
        self.layerBandRightEdge.position = CGPointMake(rectBand.origin.x + rectBand.size.width - EDGE_STROKE_SIZE *.5f,rectBand.origin.y + (rectBand.size.height+EDGE_STROKE_SIZE) * .5f);
        if( self.layerBandRightEdge.superlayer != self.view.layer )
            [self.view.layer addSublayer:self.layerBandRightEdge];
        
        self.layerBandBottomEdge.bounds = CGRectMake(.0f,.0f,rectBand.size.width -EDGE_STROKE_SIZE,EDGE_STROKE_SIZE);
        self.layerBandBottomEdge.position = CGPointMake(rectBand.origin.x + (rectBand.size.width-EDGE_STROKE_SIZE) * .5f,rectBand.origin.y + rectBand.size.height - EDGE_STROKE_SIZE *.5f);
        if( self.layerBandBottomEdge.superlayer != self.view.layer )
            [self.view.layer addSublayer:self.layerBandBottomEdge];
        
    }else{
        if( _layerBandLeftEdge.superlayer != nil)
            [_layerBandLeftEdge removeFromSuperlayer];
        
        if( _layerBandTopEdge.superlayer != nil)
            [_layerBandTopEdge removeFromSuperlayer];
        
        if( _layerBandRightEdge.superlayer != nil)
            [_layerBandRightEdge removeFromSuperlayer];
        
        if( _layerBandBottomEdge.superlayer != nil)
            [_layerBandBottomEdge removeFromSuperlayer];
        
    }
}

- (CALayer*) layerBandLeftEdge
{
    if( _layerBandLeftEdge == nil ){
        _layerBandLeftEdge = [[CALayer alloc] init];
#define EDGE_STROKE_COLOR [[UIColor colorWithRed: 0.392 green: 0.588 blue: 0.914 alpha: 1] CGColor]
        _layerBandLeftEdge.backgroundColor = EDGE_STROKE_COLOR;
    }
    return _layerBandLeftEdge;
}

- (CALayer*) layerBandTopEdge
{
    if( _layerBandTopEdge == nil ){
        _layerBandTopEdge = [[CALayer alloc] init];
        _layerBandTopEdge.backgroundColor = EDGE_STROKE_COLOR;
    }
    return _layerBandTopEdge;
}

- (CALayer*) layerBandRightEdge
{
    if( _layerBandRightEdge == nil ){
        _layerBandRightEdge = [[CALayer alloc] init];
        _layerBandRightEdge.backgroundColor = EDGE_STROKE_COLOR;
    }
    return _layerBandRightEdge;
}

- (CALayer*) layerBandBottomEdge
{
    if( _layerBandBottomEdge == nil ){
        _layerBandBottomEdge = [[CALayer alloc] init];
        _layerBandBottomEdge.backgroundColor = EDGE_STROKE_COLOR;
    }
    return _layerBandBottomEdge;
}

- (void) firedTap:(UIPanGestureRecognizer*) panGestureRecognizer
{
    self.bandRect = nil;
}

- (void) firedPan:(UIPanGestureRecognizer*) panGestureRecognizer
{
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [panGestureRecognizer locationInView:self.view];
            CGPoint translation = [panGestureRecognizer translationInView:self.view];
            
            CGRect rect = CGRectMake(location.x - (translation.x > .0f ? translation.x : .0f),location.y - (translation.y > .0f ? translation.y : .0f),fabs(translation.x),fabs(translation.y) );
            
            NSLog(@"rect=%@",[NSValue valueWithCGRect:rect]);
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            
            self.bandRect = [NSValue valueWithCGRect:rect ];
            
            [CATransaction commit];
        }
            break;
        default:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
//            self.bandRect = nil;
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(firedPan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firedTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
