// -*- mode:objc -*-
//
// Copyright (c) 2013 MIYOKAWA, Nobuyoshi (http://www.tempus.org/)
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UITextField *requestTextField;
@property (weak, nonatomic) IBOutlet UITextField *resourceTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlreqTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultView;
@property (weak, nonatomic) IBOutlet UIButton *connectionButton;
@property (weak, nonatomic) IBOutlet UIButton *sessionButton;
@property (weak, nonatomic) IBOutlet UIButton *sessionWithURLRequestButton;

@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) NSURLRequest *request;
@property (nonatomic) NSMutableData *d;
@end

@implementation ViewController

- (NSURLRequest *)request
{
  NSURLRequest *req;
  if (![self.urlreqTextField.text length]) {
    req = [[NSURLRequest alloc]
            initWithURL:[NSURL URLWithString:self.urlTextField.text]];
  } else {
    req = [[NSURLRequest alloc]
            initWithURL:[NSURL URLWithString:self.urlTextField.text]
            cachePolicy:NSURLRequestUseProtocolCachePolicy
            timeoutInterval:[self.urlreqTextField.text integerValue]];
  }
  return req;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.urlTextField.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.connectionButton.enabled = YES;
  self.sessionButton.enabled = YES;
  if (![self.urlTextField.text length]) {
    self.connectionButton.enabled = NO;
    self.sessionButton.enabled = NO;
    self.sessionWithURLRequestButton.enabled = NO;
  }
}

- (NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UI events

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  self.connectionButton.enabled = YES;
  self.sessionButton.enabled = YES;
  self.sessionWithURLRequestButton.enabled = YES;
  if (![self.urlTextField.text length]) {
    self.connectionButton.enabled = NO;
    self.sessionButton.enabled = NO;
    self.sessionWithURLRequestButton.enabled = NO;
  }
  return YES;
}

#pragma mark - NSURLConnection

- (IBAction)connectionButtonPressed:(UIButton *)button
{
  NSLog(@"%s", __FUNCTION__);
  self.resultView.text = @"";
  self.d = [NSMutableData new];
  self.connection =
    [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
  NSLog(@"%s", __FUNCTION__);
  [self.d appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
  NSLog(@"%s", __FUNCTION__);
  NSString *s =
    [NSString stringWithFormat:@"connection error:\n%@",
              [error localizedDescription]];
  self.resultView.text = s;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSLog(@"%s", __FUNCTION__);
  NSString *s =
    [NSString stringWithFormat:@"connection response:\n%@",
              [[NSString alloc]
                initWithData:self.d encoding:NSUTF8StringEncoding]];
  self.resultView.text = s;
}

#pragma mark - NSURLSession

- (IBAction)sessionButtonPresses:(UIButton *)button
{
  NSLog(@"%s", __FUNCTION__);
  self.resultView.text = @"";
  NSURLSessionConfiguration *sessionConfig =
    [NSURLSessionConfiguration defaultSessionConfiguration];
  sessionConfig.allowsCellularAccess = YES;
  if ([self.requestTextField.text length]) {
    sessionConfig.timeoutIntervalForRequest =
      [self.requestTextField.text integerValue];
  }
  if ([self.resourceTextField.text length]) {
  sessionConfig.timeoutIntervalForResource =
    [self.resourceTextField.text integerValue];
  }
  sessionConfig.HTTPMaximumConnectionsPerHost = 1;

  void (^handler)(NSData *, NSURLResponse *, NSError *) =
    ^(NSData *data, NSURLResponse *response, NSError *error) {
    NSString *s;
    if (error) {
      s = [NSString stringWithFormat:@"session error:\n%@",
                    [error localizedDescription]];
    } else {
      s = [NSString stringWithFormat:@"session response:\n%@",
                    [[NSString alloc]
                      initWithData:data encoding:NSUTF8StringEncoding]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.resultView.text = s;
      });
  };

  NSURLSession *session =
    [NSURLSession sessionWithConfiguration:sessionConfig
                                  delegate:self
                             delegateQueue:nil];

  NSURLSessionDataTask *task;
  NSURL *url = [NSURL URLWithString:self.urlTextField.text];
  if (button == self.sessionButton) {
    task = [session dataTaskWithURL:url completionHandler:handler];
  } else {
    task = [session dataTaskWithRequest:self.request completionHandler:handler];
  }

  [task resume];
}

@end

// EOF
