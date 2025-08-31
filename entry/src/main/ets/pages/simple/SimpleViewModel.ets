/**
 * @fileName : SimpleViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 基础刷新和加载更多数据管理
 */

import { RefreshController, RefreshDataSource } from "@cxy/refreshlist"
import { ItemModel } from "../../models/ItemModel"

export class SimpleViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 20

  refresh(): void {
    this.requestData(1)
  }

  loadMore(): void {
    this.requestData(this.currentPage + 1)
  }

  private async requestData(page: number): Promise<void> {
    // 模拟网络请求延迟
    setTimeout(() => {
      this.currentPage = page
      const data = this.generateSimpleData(this.pageSize)

      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(data)

      // 模拟最多5页数据
      const hasMore = page < 5
      this.controller.setHasmore(hasMore)
      this.controller.finishRefresh()

    }, 800)
  }

  private generateSimpleData(count: number): ItemModel[] {
    const categories = [
      '基础功能', '核心特性', '用户体验', '性能优化', '界面设计',
      '数据管理', '网络请求', '状态同步', '组件封装', '工具集成'
    ]

    const descriptions = [
      '展示基础的刷新和加载更多功能，简单易用的列表组件。',
      '提供完整的数据管理能力，支持各种常见的列表操作。',
      '优秀的用户体验设计，流畅的交互和动画效果。',
      '高性能的列表渲染，支持大数据量的流畅滚动。',
      '现代化的界面设计，符合最新的设计规范。'
    ]

    const colors = [
      '#4CAF50', '#2196F3', '#FF9800', '#9C27B0', '#F44336',
      '#00BCD4', '#8BC34A', '#FFC107', '#E91E63', '#607D8B'
    ]

    const result: ItemModel[] = []
    for (let i = 0; i < count; i++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + i
      const categoryIndex = globalIndex % categories.length

      const item = new ItemModel(`simple_${globalIndex}`, `${categories[categoryIndex]} ${globalIndex + 1}`)
      item.description = descriptions[globalIndex % descriptions.length]
      item.category = categories[categoryIndex]
      item.avatarColor = colors[categoryIndex]
      item.initial = categories[categoryIndex].charAt(0)
      item.time = this.getRandomTime()
      item.isNew = i < 3 && this.currentPage === 1 // 第一页前3个标记为新

      result.push(item)
    }
    return result
  }

  private getRandomTime(): string {
    const times = [
      '刚刚', '2分钟前', '5分钟前', '10分钟前', '30分钟前',
      '1小时前', '2小时前', '今天', '昨天'
    ]
    return times[Math.floor(Math.random() * times.length)]
  }
}