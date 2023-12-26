import promptAction from '@ohos.promptAction'
import TaskCategoryData from '../../common/bean/TaskCategoryData'
import CategoryTable from '../../common/database/CategoryTable'
import Logger from '../../common/utils/Logger'
import NewCategoryDialog from './NewCategoryDialog'
@CustomDialog

export default struct CategoryListDialog {
  @Link categoryList: TaskCategoryData[]
  @Link categoryTable: CategoryTable
  @State isEditing: boolean = false
  private deleteTarget: TaskCategoryData[] = []
  controller: CustomDialogController
  safeDeleteCheckID: (id: number) => boolean
  openNewCategoryDialog: () => void
  queryCategory: (id: number) => void

  @Builder Category_ListItem(item: TaskCategoryData) {
    Row() {
      Text(item.name)
        .textOverflow({overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .width('90%')
      if (this.isEditing) {
        Toggle({ type: ToggleType.Checkbox, isOn: false })
          .onChange((isOn: Boolean) => {
            if (isOn) this.deleteTarget.push(item)
            else {
              let this_id_index = this.deleteTarget.indexOf(item)
              this.deleteTarget.splice(this_id_index, 1)
            }
          })
      }
    }.justifyContent(FlexAlign.SpaceBetween)
    .height(56)
    .width('100%')
    .padding({ left: 12, right: 12 })
  }

  aboutToAppear() {
    this.isEditing = false
    this.deleteTarget = []
  }

  build() {
    Column() {
      Row() {
        Text('清单列表')
          .fontSize(20)

        Row() {
          if (!this.isEditing) {
            Button({type: ButtonType.Circle}) {
              Image('../../../resources/base/media/ic_public_select_all.svg')
                .height(24)
            }
            .backgroundColor('#00000000')
            .onClick(() => {
              this.queryCategory(0)
              this.controller.close()
            })
            .margin({right: 16})
            Button({type: ButtonType.Circle}) {
              Image('../../../resources/base/media/ic_files_new_folder.svg')
                .height(24)
            }
            .backgroundColor('#00000000')
            .onClick(() => {
              this.openNewCategoryDialog()
            })
            .margin({right: 16})
          }
          Button({type: ButtonType.Circle}) {
            Image(this.isEditing ? '../../../resources/base/media/ic_public_edit_filled.svg' : '../../../resources/base/media/ic_public_edit.svg')
              .height(24)
          }
          .backgroundColor('#00000000')
          .onClick(() => {
            if (this.isEditing == true) this.deleteTarget = []
            this.isEditing = !this.isEditing
          })
        }
      }.justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .margin({ bottom: 12 })

      List() {
        ForEach(this.categoryList, (item) => {
          ListItem() {
            this.Category_ListItem(item)
          }
          .width('100%')
          .backgroundColor(0xffffff)
          .onClick(() => {
            this.queryCategory(item.id)
            this.controller.close()
          })
        })
      }.borderRadius(20)
      .margin({top: 12, bottom: 24})
      .divider({strokeWidth: 1})

      Row() {
        Button(this.isEditing ? '删除' : '确定')
          .fontColor(this.isEditing ? '#E84026' : '#254ff7')
          .backgroundColor('#00ffffff')
          .onClick(() => {
            if (this.isEditing) {
              if (this.deleteTarget.length == this.categoryList.length) {
                promptAction.showToast({message: `请留下至少一个清单`})
              }
              this.deleteTarget.forEach((value) => {
                if (!this.safeDeleteCheckID(value.id)) {
                  promptAction.showToast({message: `清单“${value.name}”中仍有任务未删除`})
                  return;
                }
                this.categoryTable.deleteData(value, (ret) => {
                  if (ret) this.categoryList.splice(this.categoryList.indexOf(value), 1)
                })
              })
              this.deleteTarget = []
              this.isEditing = false
            } else {
              this.controller.close()
            }
          })
          .width('100%')
      }
    }
    .backgroundColor('#f1f2f3')
    .padding({left: 18, right: 18, top: 24, bottom: 8})
  }
}