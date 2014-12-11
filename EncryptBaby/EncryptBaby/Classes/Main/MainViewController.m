//
//  ViewController.m
//  EncryptBaby
//
//  Created by TrungBQ on 12/10/14.
//  Copyright (c) 2014 Trung Bui. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtText;
@property (weak, nonatomic) IBOutlet UITextView *encodeText;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int startC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _startC = 1;
    _level = 3;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)encode:(NSString*) text {
    _startC = 1;
    NSArray *array = [text componentsSeparatedByString:@" "];
    NSMutableArray *eString = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *_word in array) {
        NSLog(@"_____________%@", _word);
        
        NSString *sWord = [self swapWord:_word];
        [eString addObject:sWord];
    }
    
    NSString *encodeString = [eString componentsJoinedByString:@" "];
    
    NSLog(@"Encoded %@", encodeString);
    _encodeText.text = encodeString;
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Encoded String" message:encodeString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

- (NSString*) swapWord:(NSString*) word {
    if ([word length] > 3) {
        int ranS = (arc4random() % _level) + 1;
        int length = (int) [word length];
        
        NSString *newWord = @"";
        
        if (ranS > _startC) {
            _startC = ranS;
        }
        if (_level == 1) {
            _startC = 1;
        }
        NSLog(@"==== Start: %d", _startC);
        if (_startC < length - 2) {
            newWord = [NSString stringWithFormat:@"%@", [word substringToIndex:_startC]];
            
            NSString *needSwap = [word substringWithRange:NSMakeRange(_startC, length - 1 - _startC)];
            NSLog(@"Need: %@", needSwap);
            NSMutableArray *swap = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *swapId = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (int i = _startC; i < length - 1;i++) {
                [swapId addObject:[NSNumber numberWithInt:i]];
            }
            
            while ([swapId count] > 0) {
                int random = arc4random() % [swapId count];
                
                NSLog(@"Random: %d", random);
                [swap addObject:[NSString stringWithFormat:@"%c", [word characterAtIndex: [[swapId objectAtIndex:random] intValue]]]];
                 
                [swapId removeObjectAtIndex:random];
            }
            
            newWord = [NSString stringWithFormat:@"%@%@%@", newWord, [swap componentsJoinedByString:@""], [word substringFromIndex:[word length] - 1]];
        } else {
            newWord = word;
        }
        NSLog(@"Encode %@", newWord);
        
        return newWord;
    }
    
    return word;
}

- (IBAction)btnCopyClick:(id)sender {
    
}

- (IBAction)btnEncodeClick:(id)sender {
    NSString *text = _txtText.text;
    
    [self encode:text];
}

- (IBAction)btnPasteClick:(id)sender {
    _txtText.text = @"";
}

- (IBAction)easyClick:(id)sender {
    _level = 3;
}

- (IBAction)mediumClick:(id)sender {
    _level = 2;
}

- (IBAction)hardClick:(id)sender {
    _level = 1;
}

- (IBAction)buyClick:(id)sender {
}

@end
