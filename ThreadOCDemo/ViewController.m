//
//  ViewController.m
//  ThreadOCDemo
//
//  Created by 吕建雄 on 2019/6/18.
//  Copyright © 2019 吕建雄. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //主队列异步
    //[self mainQueueAsynTest];
    
    //主队列同步
    //[self mainQueueSyncTest];
    
    //global队列同步
    //[self globalQueueSyncTest];
    
    //global队列异步
    //[self globalQueueAsynTest];
    
    [self serialQueueSynTest];
}



/**
 添加异步代码块到main队列(不会开辟新线程)
 在主线程添加一个任务，因为是异步，添加后不管任务执行不执行直接返回，main线程继续往下执行
 由于新添加的任务排在队列的末尾，需要等前面的任务执行完，所以需要等start，run，end执行完下能开始执行
 */
- (void)mainQueueAsynTest{
    NSLog(@"start");
    dispatch_async(dispatch_get_main_queue(), ^{
        sleep(2);
        NSLog(@"main queue async sleep 2");
    });
    NSLog(@"run");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"main queue async");
    });
    sleep(2);
    NSLog(@"end");
    /*
     输出：start
     输出：run
     等待2秒，输出：end
     等待2秒，输出：main queue async sleep 2
     输出：main queue async
     */
}


/*
 原因：添加同步代码块到main队列，引起死锁
 在主线程里面添加一个任务，因为是同步，所以会等添加的任务执行完成后才能继续走下去
 但是新添加的任务排在队列的末尾，需要等前面的任务执行完，因此又回到了start，程序卡死
 */
- (void)mainQueueSyncTest{
    NSLog(@"start");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"main queue sync");
    });
    NSLog(@"end");
}



/*
 添加异步代码块到全局队列，由于是添加到全局队列，所以会开辟一个新的现场，
 DispatchQueue.global().async 在新的线程中异步添加对应的代码块，不管block中任务是否执行，直接返回
 主线程继续往下
 因为是多线程，所以DispatchQueue.global().async中的代码，将在新开辟线程执行，于main线程没有关系
 */
- (void)globalQueueSyncTest{
    NSLog(@"start");
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        NSLog(@"global queue sync sleep2");
    });
    NSLog(@"run");
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"global queue sync");
    });
    sleep(2);
    NSLog(@"end");
    /*
     输出：start
     等两秒 输出：global queue async sleep2
     输出：run
     等两秒 输出：end
     */
}



/*
 添加同步代码块到全局队列,不会开辟新线程
 在全局队列添加一个任务，因为同步异步，添加后需要等block中的任务执行完才返回，所以是顺序执行
 */
- (void)globalQueueAsynTest{
    NSLog(@"start");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        NSLog(@"global queue async sleep2");
    });
    NSLog(@"run");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"global queue async");
    });
    sleep(2);
    NSLog(@"end");
    
    /*
     输出：start
     输出：run
     输出：global queue async
     等两秒，输出end
     输出：global queue async sleep2
     */
}

/*
 串行队列与全局队列的区别是，串行队列的任务只会在一个线程中执行（结果与main一致）
 */
- (void)serialQueueAsynTest{
    NSLog(@"start");
    dispatch_queue_t serialQueue = dispatch_queue_create("top.itislatte", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        sleep(2);
        NSLog(@"serialQueue async sleep 2");
    });
    NSLog(@"run");
    dispatch_async(serialQueue, ^{
        NSLog(@"serialQueue async");
    });
    sleep(2);
    NSLog(@"end");
    /*
     输出：start
     输出：run
     等待2秒，输出：end
     等待2秒，输出：serialQueue async sleep 2
     输出：serialQueue async
     */
}

/*
 串行队列与全局队列的区别是，串行队列的任务只会在一个线程中执行（结果与globalSyncTest一致）
 */
- (void)serialQueueSynTest{
    NSLog(@"start");
    dispatch_queue_t serialQueue = dispatch_queue_create("top.itislatte", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue, ^{
        sleep(4);
        NSLog(@"serialQueue sync sleep2");
    });
    NSLog(@"run");
    dispatch_sync(serialQueue, ^{
        NSLog(@"serialQueue sync");
    });
    sleep(2);
    NSLog(@"end");
    
    /*
     输出：start
     等两秒，输出：serialQueue sync sleep2
     输出：run
     输出：serialQueue sync
     等两秒，输出end
     */
}
@end
