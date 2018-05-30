 <p align="right"><b>Github 点个赞↑👍,感谢您的支持!</b></p>

<div>
<h2>iOS直播项目 && 音乐播放器</h2>
<h3>业余时间编写，正在慢慢完善</h3>
<h3>截图如下</h3>
</div>
<div>
    <img src="https://github.com/AndreHu88/iOS_Live/blob/master/screenshot/IMG_1876.PNG" width="24%">
    <img src="https://github.com/AndreHu88/iOS_Live/blob/master/screenshot/IMG_1877.PNG" width="24%">
    <img src="https://github.com/AndreHu88/iOS_Live/blob/master/screenshot/IMG_1878.PNG" width="24%">
</div>
<div>
    <img src="https://github.com/AndreHu88/iOS_Live/blob/master/screenshot/IMG_1879.PNG" width="24%">
    <img src="https://github.com/AndreHu88/iOS_Live/blob/master/screenshot/IMG_1882.PNG" width="24%">
    <img src="https://github.com/AndreHu88/iOS_Live/blob/master/screenshot/IMG_1883.PNG" width="24%">
</div>

### 直播流媒体介绍
视频流传输使用的是RTMP协议（类似于socket，基于TCP）
RTMP是Real Time Messaging Protocol（实时消息传输协议）的首字母缩写。该协议基于TCP

流媒体开发:网络层(socket或st)负责传输，协议层(rtmp或hls)负责网络打包，封装层(flv、ts)负责编解码数据的封装，编码层(h.264和aac)负责图像，音频压缩。
用于对象,视频,音频的传输.这个协议建立在TCP协议或者轮询HTTP协议之上.

HLS:由Apple公司定义的用于实时流传输的协议,HLS基于HTTP协议实现，传输内容包括两部分，一是M3U8描述文件，二是TS媒体文件。可实现流媒体的直播和点播，主要应用在iOS系统
HLS与RTMP对比:HLS主要是延时比较大，RTMP主要优势在于延时低

### 播放网络视频需要以下几步
- 将数据解协议
- 解封装
- 解码音视频
- 音视频同步

####  播放本地视频不需要解协议，直接解封装

- **解协议**

  解协议就是将流媒体协议上的数据解析为相应的封装格式数据，流媒体一般是RTMP协议传输，这些协议在传输音视频数据的同时也可以传输一些指令数据（播放，停止，暂停，网络状态的描述） ，解协议会去掉信令数据，只保留音视频数据。采用RTMP协议通过解协议后，输入FLV的流

- **解封装**

  将封装的视频数据分离成音频和视频编码数据，常见的封装的格式有MP4，MKV, RMVB, FLV, AVI等。它的作用就是将已压缩的视频数据和音频数据按照一定的格式放在一起。FLV格式经过解封装后，可以得到H.264的视频编码数据和aac的音频编码数据

- **解码音视频**

  解码就是将音视频压缩编码数据解码成非压缩的音视频的原始数据，解码是最复杂最重要的一个环节，通过解码压缩的视频数据被输出成非压缩的颜色数据

- **音视频同步**

  根据解封装处理过程中的一些参数信息，同步解码出来的音频，视频数据，然后同步显卡和声卡播放出来