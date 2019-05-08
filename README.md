# RedMineApp

### 找到预授权参数authenticity_token

> 请求地址：http://192.168.1.241:30001/login

```
   <form onsubmit="return keepAnchorOnSignIn(this);" action="/login" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="authenticity_token" value="Qu+iZAo1/dhn6CUTo/QpN6gMnGRw3o3JRapPW/DCH6Jllw8tvkYj1aumRda0F5x9PSplH4xXLmuCKCRbaYyRuA==" />
  <input type="hidden" name="back_url" value="http://192.168.1.241:30001/" />
  
  <meta name="csrf-token" content="6VY1L24AiklFjYUHvHplj6Nn7cgO0B9kj6VAc4GVSr/OLphm2nNURInD5cKrmdDFNkEUs/JZvMZIJytzGNvEpQ==" />
  
```



### 请求登录

> 请求地址：http://192.168.1.241:30001/login

```
header:
	GET /login?login=%E7%99%BB%E5%BD%95&utf8=%E2%9C%93&authenticity_token=HyggwWAAqpvpijeDhh9fwU5VMVL+i1VAMro4CnjDgUB2c/pere3HkVakHUqaPMEppRzcQ5gbIjeqqKlPyumZWg%3D%3D&username=fumi_liusong&back_url=http://192.168.1.241:30001/&password=12345678 HTTP/1.1
Host	192.168.1.241:30001
Accept	*/*
Cookie	_redmine_session=bjBkTllyczBOWFAvVWZDWDkxbmk4NzE4WWtGM0pLMWRoS2NqOE55bm1UMzIzYlhQNmFzSXRDdnRpcUs0YXloQ1h2d2dlWllobThEQjhZeW13U04raTloT1locXl2UGdJbHdleitNRUtuOUdFbWw4cU5uRTdkODNQQklISmJEVm80aWpqMXJ1eFQrS0VkRUxGTk50UE1aWkk1MnJLcVdsdVYvQkpIQUtXUi9DN0h5RlRZMm82cEVRU0tCTnlzTjZzLS0rb0liN1FrZDFnK0pXQmRVRVI0NDZ3PT0%3D--e3396e92cfcc522da5619840292cbcc878f6282b; path=/; HttpOnly
User-Agent	RedMineProject/1 CFNetwork/978.0.7 Darwin/18.5.0 (x86_64)
Accept-Language	zh-cn
Accept-Encoding	gzip, deflate
Connection	keep-alive




utf8	✓
authenticity_token	6VY1L24AiklFjYUHvHplj6Nn7cgO0B9kj6VAc4GVSr/OLphm2nNURInD5cKrmdDFNkEUs/JZvMZIJytzGNvEpQ==
back_url	http://192.168.1.241:30001/
username	fumi_liusong
password	12345678
login	登录




login	登录
back_url	http://192.168.1.241:30001/
utf8	✓
authenticity_token	lz2lkIEMZvtfqT393sJdaqr89qlJgTPp5BU6tFgX4JklylbvqJ2jsJY9wuo8 1OFUlw93GVp72uw1uU8taqj8g==
username	liusong
password	12345678
```



登录成功后会获取到  `redmine_session`

将获取到的信息放到cookie中进行配置





### 记录验证是否未登录

通过调用主接口，判断是否包含登录为字眼判断登录



### 通知

UNUserNotificationCenter

### 计时器刷新

计时器使用OK



### 后续操作



control+command + F 全屏取消全屏

command + W 关闭当前窗[会保存]

command + M 最小化

