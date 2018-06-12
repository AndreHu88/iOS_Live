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
直播，音乐播放demo https://github.com/AndreHu88/iOS_Live
视频流传输使用的是RTMP协议（类似于socket，基于TCP）
RTMP是Real Time Messaging Protocol（实时消息传输协议）的首字母缩写。该协议基于TCP

流媒体开发:网络层(socket或st)负责传输，协议层(rtmp或hls)负责网络打包，封装层(flv、ts)负责编解码数据的封装，编码层(h.264和aac)负责图像，音频压缩。
用于对象,视频,音频的传输.这个协议建立在TCP协议或者轮询HTTP协议之上.

HLS:由Apple公司定义的用于实时流传输的协议,HLS基于HTTP协议实现，传输内容包括两部分，一是M3U8描述文件，二是TS媒体文件。可实现流媒体的直播和点播，主要应用在iOS系统
HLS与RTMP对比:HLS主要是延时比较大，RTMP主要优势在于延时低

下图是直播的完整图解
![image](http://upload-images.jianshu.io/upload_images/4499332-a5920ba5063faae1.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 播放网络视频需要以下几步（依赖FFmpeg框架）
- 将数据解协议
- 解封装
- 解码音视频
- 音视频同步

####  播放本地视频不需要解协议，直接解封装

- **解协议**
解协议就是将流媒体协议上的数据解析为相应的封装格式数据，流媒体一般是RTMP协议传输，这些协议在传输音视频数据的同时也可以传输一些指令数据（播放，停止，暂停，网络状态的描述） ，解协议会去掉信令数据，只保留音视频数据。采用RTMP协议通过解协议后，输入FLV的流

  FFMpeg会根据相关协议的特性，本机与服务器建立连接，获取流数据

- **解封装**

  将封装的视频数据分离成音频和视频编码数据，常见的封装的格式有MP4，MKV, RMVB, FLV, AVI等。它的作用就是将已压缩的视频数据和音频数据按照一定的格式放在一起。FLV格式经过解封装后，可以得到H.264的视频编码数据和aac的音频编码数据，一般称为“packet”

- **解码音视频**

  解码就是将音视频压缩编码数据解码成非压缩的音视频的原始数据，解码是最复杂最重要的一个环节，通过解码压缩的视频数据被输出成非压缩的颜色数据。目前常用的音频编码方式是aac,mp3,视频编码格式是H.264,H.265。分析源数据的音视频信息，分别设置对应的音频解码器，视频编码器。对packet分别进行解码后，音频解码获得的数据是PCM（Pulse Code Modulation，脉冲编码调制）采样数据，一般称为“sample”。视频解码获得的数据是一幅YUV或RGB图像数据，一般称为“picture”


- **音视频同步**

  音视频解码是两个独立的线程，获取到的音视频是分开的。理想情况下，音视频按照自己的固有频率渲染输出能达到音视频同步的效果，但是在现实中，断网、弱网、丢帧、缓冲、音视频不同的解码耗时等情况都会妨碍实现同步，很难达到预期效果。 通过音视频同步调整后，将同步解码出来的音频，视频数据，同步给显卡和声卡播放出来。

####  VideoToolbox.framework(硬编码)
videoToolbox是苹果的一个硬解码的框架，提供实现压缩，解压缩服务，并存储在缓冲区corevideo像素栅格图像格式之中。这些服务以会话对象的形式提供（压缩、解压，和像素传输），应用程序不需要直接访问硬件编码器和解码器相关内容，硬件编解码这块的质量有一定保证，可以优先使用硬编解码，和软解码FFmpeg可以互补

##### H.264的详解
这篇blog详解:http://www.samirchen.com/video-concept/
##### 音视频同步详解
根据解封装处理过程中的一些参数信息，同步解码出来的音频，视频数据，然后同步显卡和声卡播放出来
  解码就是将音视频压缩编码数据解码成非压缩的音视频的原始数据，解码是最复杂最重要的一个环节，通过解码压缩的视频数据被输出成非压缩的颜色数据。目前常用的音频编码方式是aac,mp3,视频编码格式是H.264,H.265。分析源数据的音视频信息，分别设置对应的音频解码器，视频编码器。对packet分别进行解码后，音频解码获得的数据是PCM（Pulse Code Modulation，脉冲编码调制）采样数据，一般称为“sample”。视频解码获得的数据是一幅YUV或RGB图像数据，一般称为“picture”
  
- **音视频同步**

  音视频解码是两个独立的线程，获取到的音视频是分开的。理想情况下，音视频按照自己的固有频率渲染输出能达到音视频同步的效果，但是在现实中，断网、弱网、丢帧、缓冲、音视频不同的解码耗时等情况都会妨碍实现同步，很难达到预期效果。 通过音视频同步调整后，将同步解码出来的音频，视频数据，同步给显卡和声卡播放出来。

####  VideoToolbox.framework(硬编码)
videoToolbox是苹果的一个硬解码的框架，提供实现压缩，解压缩服务，并存储在缓冲区corevideo像素栅格图像格式之中。这些服务以会话对象的形式提供（压缩、解压，和像素传输），应用程序不需要直接访问硬件编码器和解码器相关内容，硬件编解码这块的质量有一定保证，可以优先使用硬编解码，和软解码FFmpeg可以互补

##### H.264的详解
这篇blog详解:http://www.samirchen.com/video-concept/
##### 音视频同步详解

### 声明,如果该demo涉及到侵权,烦请联系下我,我将删除本Demo.谢谢。本项目只做技术学习使用
