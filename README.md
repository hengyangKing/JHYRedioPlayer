# JHYRedioPlayer

====================================================
github:@[hengyangKing](https://github.com/hengyangKing)  


JHYRedioPlayer For Iphone6 useAFSoundManager@[AFSoundManager](https://github.com/AlvaroFranco/AFSoundManager)
&doubanAPI@[ampm/Douban-FM-sdk](https://github.com/ampm/Douban-FM-sdk)  
&AFNetworking@[AFNetworking/AFNetworking](https://github.com/AFNetworking/AFNetworking)
&SDWebImage@[SDWebImage](https://github.com/rs/SDWebImage)
&UMSocial_Sdk@[UMSocial_Sdk](https://github.com/yeahugo/UMSocial-iOS-SDK-Demo)


===================================================


###底边播放页面
利用一个一个全局的View,会有网络播放和本地播放两个视图版本，在选择播放模式时做出变化
当前选定的channel通过AFN向douban发送request获取新的playlist
解析playlist得到相应的player，title，image。。。。。。
其中播放歌曲所属专辑的cover 用的是SDWebimage请求确保自动缓存。
播放进度条只会在本地播放音乐模式中产生。
两种播放模式下的各种操作不言而喻，都是对请求下来的数据数组进行操作
   
---   

![](http://fmn.rrfmn.com/fmn080/20150912/1235/original_BwIf_42d2000018a21e83.gif)




###本地化页面
听到喜欢的音乐可以进行本地行本地化保存，可以新建列表，也可保存进现有存在列表，利用AFN进行本地化下载并保存进沙箱中，在播放时可实现本地文件和在线音乐的混播，暂不支持批量下载


   
---   

![](http://fmn.rrfmn.com/fmn080/20150912/1250/original_nu29_84d0000018a81e84.gif)

###对以本地化的列表或本地下载歌曲进行操作选择
当你已经对歌曲本地化之后，进而可以对相应的本地化列表或已下载的曲目进行响应操作


   
---   

![](http://fmn.rrfmn.com/fmn080/20150912/1300/original_1J0f_27bc0000185a1e7f.gif)

###点击进列表，并播放列表中的曲目，可对你提示当前播放曲目及播放列表，你可以对这个列表进行批量删除操作，若是这首歌未本地化，可对其本地化

   
---   

![](http://fmn.rrfmn.com/fmn080/20150912/1310/original_lYA9_8524000019351e84.gif)












