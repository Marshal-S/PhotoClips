//
//  QYLMarco.h
//  DiBaiDanChe
//
//  Created by Marshal on 2017/6/17.
//  Copyright © 2017年 angledog. All rights reserved.
//

#ifndef QYLMarco_h
#define QYLMarco_h


#ifdef DEBUG
#define QYLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,__VA_ARGS__)
#define QYLDealloc - (void)dealloc {NSLog(@"%s 第%d行 \n\n",__func__,__LINE__);}
#else
#define QYLog(...)
#define QYLDealloc
#endif

#define Weakify(type) __weak typeof(type) w##type = type
#define Strongify(type) __strong typeof(w##type) s##type = w##type

#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBTHEME        RGB(0x17,0x8e,0xf0)
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height




#endif /* QYLMarco_h */
