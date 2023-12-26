import router from '@ohos.router';
import http from '@ohos.net.http'
import fs from '@ohos.file.fs';
import CommonConstants from '../../common/constants/CommonConsts';
import uri from '@ohos.uri';
import { TaskListItemData } from '../../common/bean/TaskListItemData';
import picker from '@ohos.file.picker';
@Component

export struct Calendars {

  @State message: string = 'Hello World'
  @State cityname: string = ''
  @State citytianqi: string = ''
  @State cityqiwen: string = ''

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
      (_err,data)=> {
        if (data && data.result) {
          console.log('服务器返回的原始数据:', data.result.toString());
          try {
            var weatherString = JSON.parse(data.result.toString());
            this.cityname=weatherString.data.cityName;
            this.citytianqi=weatherString.data.tq;
            this.cityqiwen=weatherString.data.qw;
            // 处理解析后的数据
          } catch (e) {
            console.error('解析JSON时出错:', e);
          }
        } else {
          console.error('网络请求失败或返回了空数据。');
        }
      }
    )
  }

  build() {
    Column() {
      Row() {
        Text("城市名称：")
          .width("128vp")
          .height("60vp")
          .align(Alignment.Start)
          .offset({ x: "10vp", y: "0" })
          .opacity(1)
          .margin({ left: "0vp" })
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
    }
    .width("100%")
    .height("100%")
    .alignItems(HorizontalAlign.Start)
  }
}

function saveFile() {
  const photoSaveOptions = new picker.PhotoSaveOptions(); // 创建文件管理器保存选项实例
  photoSaveOptions.newFileNames = [CommonConstants.BACKUP_FILE]; // 保存文件名（可选）
  photoSaveOptions
}