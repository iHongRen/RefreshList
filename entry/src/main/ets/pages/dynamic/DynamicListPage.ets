/**
 * @fileName : DynamicListPage.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 动态内容示例 - 实时数据更新
 */

import { RefreshList } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'
import { DynamicViewModel } from './DynamicViewModel'

@Builder
function routerBuilder() {
  DynamicListPage()
}

@Component
struct DynamicListPage {
  @State title: string = ''
  @State viewModel: DynamicViewModel = new DynamicViewModel()
  @State isRealTimeMode: boolean = false
  @State updateCount: number = 0
  private timer: number = -1

  aboutToAppear() {
    // 启动实时更新
    this.startRealTimeUpdates()
  }

  aboutToDisappear() {
    // 清理定时器
    this.stopRealTimeUpdates()
  }

  build() {
    NavDestination() {
      Column() {
        // 控制面板
        this.controlPanel()

        // 动态列表
        RefreshList({
          dataSource: this.viewModel.dataSource,
          controller: this.viewModel.controller,
          onRefresh: () => this.viewModel.refresh(),
          onLoadMore: () => this.viewModel.loadMore(),
          itemLayout: (item: Object, index: number) => this.dynamicItemLayout(item as ItemModel, index),

          // 动态头部
          headerLayout: () => this.dynamicHeaderLayout(),

          keyGenerator: (item: ItemModel) => item.id
        })
          .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
    .title(this.title)
    .onReady((ctx) => {
      this.title = ctx.pathInfo.param as string
      this.viewModel.refresh()
    })
  }

  @Builder
  controlPanel(): void {
    Column() {
      Row() {
        Text('动态内容演示')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Button(this.isRealTimeMode ? '停止实时' : '开启实时')
          .fontSize(12)
          .backgroundColor(this.isRealTimeMode ? '#ff4444' : '#00C851')
          .onClick(() => {
            this.toggleRealTimeMode()
          })
      }
      .width('100%')
      .padding(15)

      Row() {
        Text(`数据项: ${this.viewModel.dataSource.totalCount()}`)
          .fontSize(14)
          .fontColor('#666')

        Text(`更新次数: ${this.updateCount}`)
          .fontSize(14)
          .fontColor('#666')

        Text(`状态: ${this.isRealTimeMode ? '实时更新' : '手动更新'}`)
          .fontSize(14)
          .fontColor(this.isRealTimeMode ? '#00C851' : '#666')
      }
      .width('100%')
      .padding({ left: 15, right: 15, bottom: 15 })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .backgroundColor('#f8f8f8')
    .border({ width: { bottom: 1 }, color: '#e0e0e0' })
  }

  @Builder
  dynamicHeaderLayout(): void {
    Column() {
      // 实时统计卡片
      Row() {
        this.statisticCard('在线用户', this.viewModel.getOnlineUsers().toString(), '#00C851')
        this.statisticCard('活跃度', `${this.viewModel.getActivityLevel()}%`, '#007AFF')
        this.statisticCard('新消息', this.viewModel.getNewMessages().toString(), '#ff6b6b')
      }
      .width('100%')
      .padding(15)
      .justifyContent(FlexAlign.SpaceBetween)

      // 趋势图区域（模拟）
      Row() {
        Text('📈 实时趋势')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)

        Blank()

        Text('最近更新: 刚刚')
          .fontSize(12)
          .fontColor('#999')
      }
      .width('100%')
      .padding({ left: 15, right: 15, bottom: 15 })
    }
    .backgroundColor(Color.White)
  }

  @Builder
  statisticCard(title: string, value: string, color: string): void {
    Column() {
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)

      Text(title)
        .fontSize(12)
        .fontColor('#666')
        .margin({ top: 4 })
    }
    .padding(12)
    .backgroundColor('#f8f8f8')
    .borderRadius(8)
    .layoutWeight(1)
    .margin({ left: 4, right: 4 })
  }

  @Builder
  overlyBuilder(text: string) {
    Text(text)
      .fontSize(18)
      .fontColor(Color.White)
      .fontWeight(FontWeight.Bold)
      .width('100%')
      .textAlign(TextAlign.Center)
  }

  @Builder
  dynamicItemLayout(item: ItemModel, index: number): void {
    ListItem() {
      Row() {
        // 动态状态指示器
        Stack() {
          Circle({ width: 50, height: 50 })
            .fill(item.avatarColor || '#007AFF')
            .overlay(
              this.overlyBuilder(item.initial || 'D'),
              {
                align: Alignment.Center
              }
            )

          // 实时活动指示器
          if (item.isOnline) {
            Circle({ width: 12, height: 12 })
              .fill('#00C851')
              .stroke(Color.White)
              .strokeWidth(2)
              .scale({ x: item.isActive ? 1.2 : 1 })
              .animation({
                duration: 1000,
                iterations: -1,
                playMode: PlayMode.Alternate
              })
          }
        }
        .alignContent(Alignment.BottomEnd)

        // 动态内容
        Column() {
          Row() {
            Text(item.title)
              .fontSize(16)
              .fontColor('#333')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)

            // 实时更新时间
            Text(item.time || '刚刚')
              .fontSize(12)
              .fontColor('#999')
              .backgroundColor(item.isNew ? '#ff6b6b20' : 'transparent')
              .borderRadius(4)
              .padding({
                left: 6,
                right: 6,
                top: 2,
                bottom: 2
              })
          }
          .width('100%')

          if (item.description) {
            Text(item.description)
              .fontSize(14)
              .fontColor('#666')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 4 })
          }

          // 动态数据指标
          Row() {
            // 实时数值变化
            Row() {
              Image($r('sys.media.ohos_app_icon'))
                .width(14)
                .height(14)
                .fillColor('#ff4444')

              Text(`${item.likes || 0}`)
                .fontSize(12)
                .fontColor('#666')
                .margin({ left: 2 })
                .scale({ x: item.likesChanged ? 1.2 : 1 })
                .animation({
                  duration: 300,
                  onFinish: () => {
                    if (item.likesChanged) {
                      item.likesChanged = false
                    }
                  }
                })
            }

            Row() {
              Image($r('sys.media.ohos_ic_public_email'))
                .width(14)
                .height(14)
                .fillColor('#007AFF')

              Text(`${item.views || 0}`)
                .fontSize(12)
                .fontColor('#666')
                .margin({ left: 2 })
            }
            .margin({ left: 15 })

            Blank()

            // 动态状态标签
            if (item.isHot) {
              Text('🔥 热门')
                .fontSize(10)
                .fontColor('#ff4444')
                .backgroundColor('#ff444420')
                .borderRadius(8)
                .padding({
                  left: 6,
                  right: 6,
                  top: 2,
                  bottom: 2
                })
            }

            if (item.isNew) {
              Text('✨ 新')
                .fontSize(10)
                .fontColor('#00C851')
                .backgroundColor('#00C85120')
                .borderRadius(8)
                .padding({
                  left: 6,
                  right: 6,
                  top: 2,
                  bottom: 2
                })
                .margin({ left: 4 })
            }
          }
          .width('100%')
          .margin({ top: 8 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)

        // 操作按钮
        Column() {
          Button('👍')
            .fontSize(16)
            .width(40)
            .height(30)
            .padding(0)
            .backgroundColor('#f0f0f0')
            .onClick(() => {
              this.likeItem(item, index)
            })

          Button('📤')
            .fontSize(16)
            .width(40)
            .height(30)
            .padding(0)
            .backgroundColor('#f0f0f0')
            .margin({ top: 5 })
            .onClick(() => {
              console.log(`分享: ${item.title}`)
            })
        }
      }
      .width('100%')
      .padding(15)
      .alignItems(VerticalAlign.Top)
    }
    .backgroundColor(Color.White)
    .border({
      width: { left: item.isNew ? 3 : 0 },
      color: '#00C851'
    })
  }

  private toggleRealTimeMode(): void {
    this.isRealTimeMode = !this.isRealTimeMode

    if (this.isRealTimeMode) {
      this.startRealTimeUpdates()
    } else {
      this.stopRealTimeUpdates()
    }
  }

  private startRealTimeUpdates(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer)
    }

    this.timer = setInterval(() => {
      if (this.isRealTimeMode) {
        this.viewModel.performRealTimeUpdate()
        this.updateCount++
      }
    }, 3000) // 每3秒更新一次
  }

  private stopRealTimeUpdates(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer)
      this.timer = -1
    }
  }

  private likeItem(item: ItemModel, index: number): void {
    // 增加点赞数
    item.likes = (item.likes || 0) + 1
    item.likesChanged = true

    // 更新数据源
    this.viewModel.dataSource.reloadIndex(index)
  }
}