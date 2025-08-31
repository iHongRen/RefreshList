/**
 * @fileName : ChatListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 聊天列表示例
 */

import { RefreshList } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { ChatViewModel } from './ChatViewModel'

@Builder
function routerBuilder() {
  ChatListPage()
}

@Component
struct ChatListPage {
  @State title: string = ''
  @State viewModel: ChatViewModel = new ChatViewModel()

  build() {
    NavDestination() {
      Column() {
        // 顶部搜索栏
        this.searchHeader()

        // 聊天列表
        RefreshList({
          dataSource: this.viewModel.dataSource,
          controller: this.viewModel.controller,
          onRefresh: () => this.viewModel.refresh(),
          onLoadMore: () => this.viewModel.loadMore(),
          itemLayout: (item: Object, index: number) => this.chatItemLayout(item as ItemModel),

          // 聊天列表配置
          itemSpace: 0,
          divider: {
            strokeWidth: 0.5,
            color: '#f0f0f0',
            startMargin: 70,
            endMargin: 0
          },

          keyGenerator: (item: ItemModel) => item.id
        })
          .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f8f8f8')
    }
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  searchHeader(): void {
    Row() {
      Row() {
        Image($r('sys.media.ohos_app_icon'))
          .width(16)
          .height(16)
          .fillColor('#999')

        Text('搜索聊天记录')
          .fontSize(14)
          .fontColor('#999')
          .margin({ left: 8 })
      }
      .padding({
        left: 12,
        right: 12,
        top: 8,
        bottom: 8
      })
      .backgroundColor('#f0f0f0')
      .borderRadius(20)
      .layoutWeight(1)

      Image($r('sys.media.ohos_ic_public_add'))
        .width(24)
        .height(24)
        .fillColor('#007AFF')
        .margin({ left: 12 })
    }
    .width('100%')
    .padding(15)
    .backgroundColor(Color.White)
  }

  @Builder
  chatItemLayout(item: ItemModel): void {
    ListItem() {
      Row() {
        // 头像
        Stack() {
          Image(item.avatar || $r('app.media.app_icon'))
            .width(50)
            .height(50)
            .borderRadius(25)
            .objectFit(ImageFit.Cover)

          // 在线状态指示器
          if (item.isOnline) {
            Circle({ width: 12, height: 12 })
              .fill('#00C851')
              .stroke(Color.White)
              .strokeWidth(2)
          }
        }
        .alignContent(Alignment.BottomEnd)

        // 聊天信息
        Column() {
          Row() {
            Text(item.name || item.title)
              .fontSize(16)
              .fontColor('#333')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)

            Text(item.time || '刚刚')
              .fontSize(12)
              .fontColor('#999')
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          Row() {
            // 消息类型图标
            if (item.messageType === 'image') {
              Image($r('sys.media.ohos_app_icon'))
                .width(14)
                .height(14)
                .fillColor('#999')
                .margin({ right: 4 })
            } else if (item.messageType === 'voice') {
              Image($r('sys.media.ohos_app_icon'))
                .width(14)
                .height(14)
                .fillColor('#999')
                .margin({ right: 4 })
            }

            Text(item.lastMessage || '暂无消息')
              .fontSize(14)
              .fontColor('#666')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)

            // 未读消息数
            if (item.unreadCount && item.unreadCount > 0) {
              Text(item.unreadCount > 99 ? '99+' : item.unreadCount.toString())
                .fontSize(12)
                .fontColor(Color.White)
                .backgroundColor('#ff4444')
                .borderRadius(10)
                .padding({
                  left: 6,
                  right: 6,
                  top: 2,
                  bottom: 2
                })
                .textAlign(TextAlign.Center)
            }
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({
        left: 15,
        right: 15,
        top: 12,
        bottom: 12
      })
      .alignItems(VerticalAlign.Top)
    }
    .backgroundColor(Color.White)
    .onClick(() => {
      console.log(`打开聊天: ${item.name || item.title}`)
    })
    .gesture(
      // 长按手势
      LongPressGesture({ repeat: false })
        .onAction(() => {
          this.showChatOptions(item)
        })
    )
  }

  private showChatOptions(item: ItemModel): void {
    // 显示聊天选项菜单（置顶、删除、标记已读等）
    console.log(`显示聊天选项: ${item.name || item.title}`)
  }
}