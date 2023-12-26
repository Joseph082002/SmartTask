import http from '@ohos.net.http'
@Entry
@Component
struct Page2 {
  @State message: string = 'Hello World'
  @State cityname: string = ''
  @State citytianqi: string = ''
  @State cityqiwen: string = ''
  @State refreshtime: string = ''

  aboutToAppear(){
    this.get_weather();
  }
  //通过api获取网络中天气服务器中的相关数据（YY天气为例）
  get_weather(){
    //(1)创建Request请求任务
    let httpRequest=http.createHttp();
    //(2)发起请求
    httpRequest.request(
      "http://api.yytianqi.com/observe",
      {
        method:http.RequestMethod.GET,
        header:{
          "Content-Type":"application/json",
          "charset":"utf-8"
        },
        extraData:{
          "city":"CH020100",  //上海
          "key":"t2e2ar1allovr1mq" //自己的key
        },
        connectTimeout:60000,
        readTimeout:60000
      },
      (_err,data)=>{
        var weatherString=JSON.parse(data.result.toString());
        this.cityname=weatherString.data.cityName;
        this.citytianqi=weatherString.data.tq;
        this.cityqiwen=weatherString.data.qw;
        this.refreshtime=weatherString.data.lastUpdate;
      }
    )
  }
  build() {
    Column() {
      Row() {
        Text("今日天气查询：")
          .width("200vp")
          .height("60vp")
          .align(Alignment.Start)
          .offset({ x: "10vp", y: "0" })
          .opacity(1)
          .margin({ left: "85vp" })
          .textAlign(TextAlign.Start)
          .fontSize("25fp")
      }
      Row() {
        Text("城市名称：")
          .width("128vp")
          .height("60vp")
          .align(Alignment.Start)
          .offset({ x: "10vp", y: "0" })
          .opacity(1)
          .margin({ top: "0vp" })
          .textAlign(TextAlign.Start)
          .fontSize("25fp")
        Text(`${this.cityname}`)
          .width("200vp")
          .height("60vp")
          .offset({ x: "10vp", y: "0" })
          .fontSize("25fp")
      }
      .align(Alignment.Top)
      .margin({ top: "250vp" })
      Row() {
        Text("城市天气：")
          .width("128vp")
          .height("60vp")
          .align(Alignment.Start)
          .offset({ x: "10vp", y: "0" })
          .margin({ top: "0vp", bottom: "0vp", left: "0vp", right: "0vp" })
          .fontSize("25fp")
        Text(`${this.citytianqi}`)
          .width("200vp")
          .height("60vp")
          .offset({ x: "10vp", y: "0" })
          .fontSize("25fp")
      }
      .margin({ top: "20vp" })
      Row() {
        Text("城市温度：")
          .width("128vp")
          .height("60vp")
          .offset({ x: "10vp", y: "0" })
          .margin({ top: "0vp", bottom: "0vp", left: "0vp", right: "0vp" })
          .padding({ top: "0vp" })
          .fontSize("25fp")
        Text(`${this.cityqiwen}`)
          .width("200vp")
          .height("60vp")
          .offset({ x: "10vp", y: "0" })
          .fontSize("25fp")
      }
      .margin({ top: "20vp" })
      Row() {
        Text("更新时间：")
          .width("128vp")
          .height("60vp")
          .offset({ x: "10vp", y: "0" })
          .margin({ top: "0vp", bottom: "0vp", left: "0vp", right: "0vp" })
          .padding({ top: "0vp" })
          .fontSize("25fp")
        Text(`${this.refreshtime}`)
          .width("200vp")
          .height("60vp")
          .offset({ x: "10vp", y: "0" })
          .fontSize("25fp")
      }
      .margin({ top: "20vp" })
    }
    .width("100%")
    .height("100%")
    .alignItems(HorizontalAlign.Start)
    .padding({left:20,right:20})
    .backgroundImage($r("app.media.background"))
    .backgroundImageSize({width:"100%",height:"100%"})
  }
}