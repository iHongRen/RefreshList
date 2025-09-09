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

interface ICardItem {
  title: string,
  value: string,
  color: string
}

@Component
struct DynamicListPage {
  @State title: string = ''
  @State viewModel: DynamicViewModel = new DynamicViewModel()

  aboutToAppear() {
    // 启动实时更新
    this.viewModel.startRealTimeUpdates()
  }

  aboutToDisappear() {
    // 清理定时器
    this.viewModel.stopRealTimeUpdates()
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

        Button(this.viewModel.isRealTimeMode ? '停止实时' : '开启实时')
          .fontSize(12)
          .backgroundColor(this.viewModel.isRealTimeMode ? '#ff4444' : '#00C851')
          .onClick(() => {
            this.viewModel.toggleRealTimeMode()
          })
      }
      .width('100%')
      .padding(15)

      Row() {
        Text(`数据项: ${this.viewModel.dataSource.totalCount()}`)
          .fontSize(14)
          .fontColor('#666')

        Text(`更新次数: ${this.viewModel.updateCount}`)
          .fontSize(14)
          .fontColor('#666')

        Text(`状态: ${this.viewModel.isRealTimeMode ? '实时更新' : '手动更新'}`)
          .fontSize(14)
          .fontColor(this.viewModel.isRealTimeMode ? '#00C851' : '#666')
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
        this.statisticCard({ title: '在线用户', value: this.viewModel.getOnlineUsers().toString(), color: '#00C851' })
        this.statisticCard({ title: '活跃度', value: `${this.viewModel.getActivityLevel()}%`, color: '#007AFF' })
        this.statisticCard({ title: '新消息', value: this.viewModel.getNewMessages().toString(), color: '#ff6b6b' })
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
  statisticCard(item: ICardItem): void {
    Column() {
      Text(item.value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(item.color)

      Text(item.title)
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
  dynamicItemLayout(item: ItemModel, index: number): void {
    DynamicCell({ model: item })
  }
}

@Reusable
@Component
struct DynamicCell {
  @ObjectLink model: ItemModel

  build() {
    ListItem() {
      Row() {
        // 动态状态指示器
        Stack() {
          Circle({ width: 50, height: 50 })
            .fill(this.model.avatarColor || '#007AFF')
            .overlay(
              this.overlyBuilder(this.model.initial || 'D'),
              {
                align: Alignment.Center
              }
            )

          // 实时活动指示器
          if (this.model.isOnline) {
            Circle({ width: 12, height: 12 })
              .fill('#00C851')
              .stroke(Color.White)
              .strokeWidth(2)
              .scale({ x: this.model.isActive ? 1.2 : 1 })
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
            Text(this.model.title)
              .fontSize(16)
              .fontColor('#333')
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)

            // 实时更新时间
            Text(this.model.time || '刚刚')
              .fontSize(12)
              .fontColor('#999')
              .backgroundColor(this.model.isNew ? '#ff6b6b20' : 'transparent')
              .borderRadius(4)
              .padding({
                left: 6,
                right: 6,
                top: 2,
                bottom: 2
              })
          }
          .width('100%')

          if (this.model.description) {
            Text(this.model.description)
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
              Text() {
                SymbolSpan($r('sys.symbol.heart_fill'))
                  .fontWeight(FontWeight.Normal)
                  .fontSize(12)
                  .fontColor(['#ff0000'])
              }


              Text(`${this.model.likes || 0}`)
                .fontSize(12)
                .fontColor('#666')
                .margin({ left: 2 })
                .scale({ x: this.model.likesChanged ? 1.2 : 1 })
                .animation({
                  duration: 300,
                  onFinish: () => {
                    if (this.model.likesChanged) {
                      this.model.likesChanged = false
                    }
                  }
                })
            }

            Row() {
              Text() {
                SymbolSpan($r('sys.symbol.eye'))
                  .fontWeight(FontWeight.Normal)
                  .fontSize(12)
              }

              Text(`${this.model.views || 0}`)
                .fontSize(12)
                .fontColor('#666')
                .margin({ left: 2 })
            }
            .margin({ left: 15 })

            Blank()

            // 动态状态标签
            if (this.model.isHot) {
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

            if (this.model.isNew) {
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
              this.likeItem()
            })

          Button('📤')
            .fontSize(16)
            .width(40)
            .height(30)
            .padding(0)
            .backgroundColor('#f0f0f0')
            .margin({ top: 5 })
            .onClick(() => {
              console.log(`分享: ${this.model.title}`)
            })
        }
      }
      .width('100%')
      .padding(15)
      .alignItems(VerticalAlign.Top)
    }
    .backgroundColor(Color.White)
    .border({
      width: { left: this.model.isNew ? 3 : 0 },
      color: '#00C851'
    })
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

  private likeItem(): void {
    // 增加点赞数
    this.model.likes = (this.model.likes || 0) + 1
    this.model.likesChanged = true
  }
}