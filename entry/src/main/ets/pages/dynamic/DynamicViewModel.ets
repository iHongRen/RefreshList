/**
 * @fileName : DynamicViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 动态内容数据管理
 */

import { RefreshDataSource, RefreshController } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'

export class DynamicViewModel {
  @Track dataSource: RefreshDataSource = new RefreshDataSource()
  @Track controller: RefreshController = new RefreshController()
  @Track onlineUsers: number = 1234
  @Track activityLevel: number = 85
  @Track newMessages: number = 12
  @Track isRealTimeMode: boolean = false
  @Track updateCount: number = 0
  private currentPage: number = 1
  private pageSize: number = 20
  private timer: number = -1

  refresh(): void {
    this.requestPage(1)
  }

  loadMore(): void {
    this.requestPage(this.currentPage + 1)
  }

  requestPage(page: number) {
    // 模拟网络请求延迟
    setTimeout(() => {
      this.currentPage = page
      const data = this.generateData(this.pageSize)
      if (page === 1) {
        this.dataSource.deleteAll()
        // 更新统计数据
        this.updateStatistics()
      }
      this.dataSource.pushDataArray(data)

      // 模拟最多5页数据
      const hasMore = page < 5
      this.controller.setHasmore(hasMore)
      this.controller.finishRefresh()
    }, 800)
  }

  performRealTimeUpdate(): void {
    const totalCount = this.dataSource.totalCount()
    if (totalCount === 0) {
      return
    }

    // 随机更新几个项目
    const updateCount = Math.min(3, Math.floor(totalCount * 0.1))

    for (let i = 0; i < updateCount; i++) {
      const randomIndex = Math.floor(Math.random() * totalCount)
      const item = this.dataSource.getData(randomIndex) as ItemModel

      if (item) {
        // 随机更新数据
        this.updateItemData(item)
      }
    }

    // 有时添加新项目
    if (Math.random() > 0.7) {
      const newItem = this.generateNewDynamicItem()
      this.dataSource.insertData(0, newItem)
    }

    // 更新统计数据
    this.updateStatistics()
  }

  getOnlineUsers(): number {
    return this.onlineUsers
  }

  getActivityLevel(): number {
    return this.activityLevel
  }

  getNewMessages(): number {
    return this.newMessages
  }

  toggleRealTimeMode(): void {
    this.isRealTimeMode = !this.isRealTimeMode

    if (this.isRealTimeMode) {
      this.startRealTimeUpdates()
    } else {
      this.stopRealTimeUpdates()
    }
  }

  startRealTimeUpdates(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer)
    }

    this.timer = setInterval(() => {
      if (this.isRealTimeMode) {
        this.performRealTimeUpdate()
        this.updateCount++
      }
    }, 3000) // 每3秒更新一次
  }

  stopRealTimeUpdates(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer)
      this.timer = -1
    }
  }

  private updateItemData(item: ItemModel): void {
    // 随机更新各种数据
    if (Math.random() > 0.5) {
      item.likes = (item.likes || 0) + Math.floor(Math.random() * 5) + 1
      item.likesChanged = true
    }

    if (Math.random() > 0.7) {
      item.views = (item.views || 0) + Math.floor(Math.random() * 20) + 1
    }

    if (Math.random() > 0.8) {
      item.comments = (item.comments || 0) + Math.floor(Math.random() * 3) + 1
    }

    // 更新时间
    item.time = this.getCurrentTime()

    // 随机设置活跃状态
    item.isActive = Math.random() > 0.6

    // 随机设置热门状态
    if ((item.likes || 0) > 50) {
      item.isHot = true
    }
  }

  private updateStatistics(): void {
    // 模拟统计数据变化
    this.onlineUsers += Math.floor(Math.random() * 20) - 10 // -10 到 +10
    this.onlineUsers = Math.max(1000, Math.min(2000, this.onlineUsers))

    this.activityLevel += Math.floor(Math.random() * 10) - 5 // -5 到 +5
    this.activityLevel = Math.max(60, Math.min(100, this.activityLevel))

    this.newMessages += Math.floor(Math.random() * 5)
    if (this.newMessages > 99) {
      this.newMessages = Math.floor(Math.random() * 20) + 1
    }
  }

  private generateNewDynamicItem(): ItemModel {
    const activities = [
      '发布了新动态', '分享了一篇文章', '上传了新照片',
      '发表了评论', '点赞了内容', '加入了讨论'
    ]

    const users = [
      '张三', '李四', '王五', '赵六', '钱七', '孙八'
    ]

    const activity = activities[Math.floor(Math.random() * activities.length)]
    const user = users[Math.floor(Math.random() * users.length)]

    const item = new ItemModel(`dynamic_new_${Date.now()}`, `${user} ${activity}`)
    item.description = '刚刚发生的实时动态内容，展示了系统的实时更新能力。'
    item.time = '刚刚'
    item.isNew = true
    item.isOnline = true
    item.isActive = true
    item.likes = Math.floor(Math.random() * 10)
    item.views = Math.floor(Math.random() * 50)
    item.comments = Math.floor(Math.random() * 5)
    item.avatarColor = this.getRandomColor()
    item.initial = user.charAt(0)
    return item
  }

  private generateData(count: number): ItemModel[] {
    const activities = [
      '实时数据更新演示', '动态内容管理系统', '用户活动监控',
      '实时消息推送', '数据流处理', '状态同步机制',
      '实时统计分析', '动态UI更新', '事件驱动架构',
      '响应式数据绑定', '实时协作功能', '动态加载优化'
    ]

    const descriptions = [
      '展示实时数据更新的强大功能，支持多种数据源的动态同步。',
      '演示动态内容管理的完整流程，包括创建、更新、删除等操作。',
      '实时监控用户活动状态，提供准确的在线状态和活跃度统计。',
      '高效的实时消息推送机制，确保用户及时收到重要信息。',
      '强大的数据流处理能力，支持大规模实时数据的处理和分析。'
    ]

    const colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
      '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
    ]

    const result: ItemModel[] = []
    for (let index = 0; index < count; index++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + index
      const isNew = index < 3 && this.currentPage === 1 // 前3个标记为新

      const item = new ItemModel(`dynamic_${globalIndex}`, activities[globalIndex % activities.length])
      item.description = descriptions[globalIndex % descriptions.length]
      item.time = this.getRandomTime()

      // 动态属性
      item.isNew = isNew
      item.isOnline = Math.random() > 0.3 // 70%在线
      item.isActive = Math.random() > 0.5 // 50%活跃
      item.isHot = Math.random() > 0.8 // 20%热门

      // 数值属性
      item.likes = Math.floor(Math.random() * 100) + 1
      item.views = Math.floor(Math.random() * 1000) + 50
      item.comments = Math.floor(Math.random() * 50) + 1

      // 视觉属性
      item.avatarColor = colors[globalIndex % colors.length]
      item.initial = activities[globalIndex % activities.length].charAt(0)

      // 变化标记
      item.likesChanged = false

      result.push(item)
    }
    return result
  }

  private getCurrentTime(): string {
    const now = new Date()
    return `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`
  }

  private getRandomTime(): string {
    const times = [
      '刚刚', '1分钟前', '3分钟前', '5分钟前', '10分钟前',
      '15分钟前', '30分钟前', '1小时前', '2小时前'
    ]
    return times[Math.floor(Math.random() * times.length)]
  }

  private getRandomColor(): string {
    const colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
      '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
    ]
    return colors[Math.floor(Math.random() * colors.length)]
  }
}