/**
 * @fileName : ChatViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 聊天列表数据管理
 */

import { RefreshDataSource, RefreshController } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'

export class ChatViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()

  refresh(): void {
    this.requestPage()
  }

  requestPage() {
    // 模拟网络请求延迟
    setTimeout(() => {
      const data = this.generateData()
      this.dataSource.deleteAll()
      this.dataSource.pushDataArray(data)
      this.controller.finishRefresh()
    }, 800)
  }

  private generateData(): ItemModel[] {
    const names = [
      '张三', '李四', '王五', '赵六', '钱七', '孙八', '周九', '吴十',
      '郑十一', '王十二', '冯十三', '陈十四', '褚十五', '卫十六',
      '蒋十七', '沈十八', '韩十九', '杨二十'
    ]

    const lastMessages = [
      '你好，最近怎么样？', '今天天气不错呢', '晚上一起吃饭吧',
      '工作顺利吗？', '周末有什么安排？', '这个项目进展如何？',
      '谢谢你的帮助', '明天见面聊', '发个位置给我',
      '收到，马上过去', '好的，没问题', '辛苦了',
      '[图片]', '[语音]', '[视频通话]',
      '哈哈哈', '👍', '🎉'
    ]

    const messageTypes = ['text', 'image', 'voice', 'video']

    const timeFormats = [
      '刚刚', '1分钟前', '5分钟前', '10分钟前', '30分钟前',
      '1小时前', '2小时前', '昨天', '前天', '周一', '周二'
    ]

    const count = names.length
    const result: ItemModel[] = []
    for (let index = 0; index < count; index++) {
      const globalIndex = index
      const isOnline = Math.random() > 0.3 // 70%在线概率
      const hasUnread = Math.random() > 0.6 // 40%有未读消息
      const unreadCount = hasUnread ? Math.floor(Math.random() * 20) + 1 : 0

      const item = new ItemModel(`chat_${globalIndex}`, names[globalIndex % names.length])
      item.name = names[globalIndex % names.length]
      item.lastMessage = lastMessages[globalIndex % lastMessages.length]
      item.messageType = messageTypes[Math.floor(Math.random() * messageTypes.length)]
      item.time = timeFormats[Math.floor(Math.random() * timeFormats.length)]
      item.isOnline = isOnline
      item.unreadCount = unreadCount
      item.avatar = `https://picsum.photos/100/100?random=${globalIndex}`
      item.isPinned = globalIndex < 3 // 前3个置顶

      result.push(item)
    }
    return result
  }
}