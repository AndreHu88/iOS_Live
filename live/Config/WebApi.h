
//
//  WebApi.h
//  DaCongMing
//
//  Created by 胡勇 on 2017/9/15.
//  Copyright © 2017年 胡勇. All rights reserved.
//

#ifndef WebApi_h
#define WebApi_h



/** ------------------------------网络接口------------------------------- */
//接口总域名
#define API_DomainStr           @"http://service.ingkee.com"

/** 热门直播 */
#define API_HotLive             @"http://service.ingkee.com/api/live/recommend"

/** 小视频 */
#define API_SmallVideo             @"http://service.ingkee.com/api/feeds_tab/nearby?limit=20&start=0&uid=268945518"

/** 吃鸡 */
#define API_EatChicken            @"http://service.ingkee.com/api/live/themesearch?keyword=F2BEA36EB1AB0C13"

/** 附近直播 */
#define API_NearLive(lat,lon)     [NSString stringWithFormat:@"http://service.ingkee.com/api/live/near_recommend?uid=268945519&latitude=%@&longitude=%@",lat,lon]

//音乐
#define API_XiaMiMusicList        @"http://music.xiami.com/resource/collect/detail/406549798?auth_key=1528390510-0-0-5cba7a2bccfebbed5fd109cd61079754"

#endif
