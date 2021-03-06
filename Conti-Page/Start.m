//
//  ViewController.m
//  Conti-Page
//
//  Created by Walter Gonzalez Domenzain on 12/05/15.
//  Copyright (c) 2015 Smartplace. All rights reserved.
//

#import "Start.h"
#import "IntroPages.h"
#import "Declarations.h"
#import "AppDelegate.h"
#import "Camera.h"

int             iNumberOfPages  = 3;
NSUInteger      iIndex          = 0;


@interface Start ()

@end

@implementation Start
/**********************************************************************************************/
#pragma mark - Initialization
/**********************************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad Start");
    self.view.tag = 1;
    [self initController];
    [self createPageViews];
}
//-------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-------------------------------------------------------------------------------
- (void)initController
{
    aTeamNames  = [NSMutableArray arrayWithObjects: nInitialTeams];
    aTeamImages = [NSMutableArray arrayWithObjects: nInitialImages];
}
/**********************************************************************************************/
#pragma mark - Buttons functions
/**********************************************************************************************/
- (IBAction)btnBackPressed:(id)sender
{
    iIndex = 0;
    IntroPages *startingViewController  = [self viewControllerAtIndex:iIndex];
    NSArray *viewControllers            = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
//-------------------------------------------------------------------------------
- (IBAction)btnForwardPressed:(id)sender
{
    iIndex = 2;
    IntroPages *startingViewController  = [self viewControllerAtIndex:iIndex];
    NSArray *viewControllers            = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
//-------------------------------------------------------------------------------
- (IBAction)skipIntroPressed:(id)sender
{
    Camera *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Camera"];
    [self presentViewController:viewController animated:YES completion:nil];
}
/**********************************************************************************************/
#pragma mark - Page controller functions and delagates
/**********************************************************************************************/
- (void)createPageViews
{
    // Create page view controller
    self.pageViewController             = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageController"];
    self.pageViewController.dataSource  = self;
    
    IntroPages *startingViewController  = [self viewControllerAtIndex:0];
    NSArray *viewControllers            = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    NSArray *subviews = self.pageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    thisControl.hidden = true;
    
    [self.view bringSubviewToFront:self.btnBack];
    [self.view bringSubviewToFront:self.btnForward];
    [self.view bringSubviewToFront:self.btnSkipIntro];
    
}
//-------------------------------------------------------------------------------
- (IntroPages *)viewControllerAtIndex:(NSUInteger)index
{
    if ((iNumberOfPages == 0) || (index >= iNumberOfPages)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    IntroPages *pageIntro       = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPages"];
    pageIntro.iPageIndex        = index;
    
    NSLog(@"viewControllerAtIndex index = %d", (int)index);
    return pageIntro;
}
//-------------------------------------------------------------------------------
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPages*) viewController).iPageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    iIndex = index;
    return [self viewControllerAtIndex:index];
}
//-------------------------------------------------------------------------------
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPages*) viewController).iPageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }

    index++;
    iIndex = index;
    return [self viewControllerAtIndex:index];
}
//-------------------------------------------------------------------------------
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return iNumberOfPages;
}
//-------------------------------------------------------------------------------
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    NSLog(@"presentationIndexForPageViewController");
    return 0;
}

@end
