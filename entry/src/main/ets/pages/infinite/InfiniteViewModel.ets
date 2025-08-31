/**
 * @fileName : InfiniteViewModel.ets
 * @author : @cxy
 * @date : 2025/8/31
 * @description : 无限滚动数据管理
 */

import { RefreshDataSource, RefreshController } from '@cxy/refreshlist'
import { ItemModel } from '../../models/ItemModel'

export class InfiniteViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 25
  private totalPages: number = 100 // 模拟总页数
  private isLoading: boolean = false
  private autoLoading: boolean = false

  refresh(): void {
    this.currentPage = 1
    this.isLoading = true

    setTimeout(() => {
      this.dataSource.deleteAll()
      const data = this.generateInfiniteData(this.pageSize)
      this.dataSource.pushDataArray(data)
      this.controller.finishRefresh()
      this.controller.setHasmore(this.currentPage < this.totalPages)
      this.isLoading = false
    }, 1000)
  }

  loadMore(): void {
    if (this.isLoading || this.currentPage >= this.totalPages) {
      return
    }

    this.currentPage++
    this.isLoading = true

    // 模拟网络延迟
    const delay = this.autoLoading ? 500 : 1200

    setTimeout(() => {
      const data = this.generateInfiniteData(this.pageSize)
      this.dataSource.pushDataArray(data)

      // 检查是否还有更多数据
      const hasMore = this.currentPage < this.totalPages
      this.controller.setHasmore(hasMore)

      this.controller.finishRefresh()
      this.isLoading = false
    }, delay)
  }

  setAutoLoading(auto: boolean): void {
    this.autoLoading = auto
  }

  getCurrentPage(): number {
    return this.currentPage
  }

  hasMore(): boolean {
    return this.currentPage < this.totalPages
  }

  getLoadingStatus(): string {
    if (this.isLoading) {
      return '加载中'
    }
    if (this.currentPage >= this.totalPages) {
      return '已完成'
    }
    return '待加载'
  }

  private generateInfiniteData(count: number): ItemModel[] {
    const categories = [
      '科技资讯', '生活百科', '娱乐八卦', '体育新闻', '财经动态',
      '教育学习', '健康养生', '旅游攻略', '美食推荐', '时尚潮流'
    ]

    const titles = [
      '人工智能的最新发展趋势', '如何提高工作效率', '健康生活的小贴士',
      '最新科技产品评测', '投资理财入门指南', '旅行中的注意事项',
      '美食制作教程分享', '时尚搭配技巧', '运动健身方法',
      '学习新技能的方法', '环保生活理念', '数字化转型趋势'
    ]

    const result: ItemModel[] = []
    for (let index = 0; index < count; index++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + index + 1
      const now = new Date()
      const timestamp = new Date(now.getTime() - Math.random() * 7 * 24 * 60 * 60 * 1000)

      const item = new ItemModel(`infinite_${globalIndex}`, `${titles[globalIndex % titles.length]} ${globalIndex}`)
      item.index = globalIndex
      item.description = `这是第 ${globalIndex} 个无限滚动项目，属于${categories[globalIndex % categories.length]}分类。`
      item.category = categories[globalIndex % categories.length]
      item.timestamp = this.formatTime(timestamp)
      item.views = Math.floor(Math.random() * 10000) + 100
      item.likes = Math.floor(Math.random() * 1000) + 10
      item.isNew = globalIndex > this.dataSource.totalCount() - 5 // 最新的5个标记为新

      result.push(item)
    }
    return result
  }

  private formatTime(date: Date): string {
    const now = new Date()
    const diff = now.getTime() - date.getTime()
    const minutes = Math.floor(diff / (1000 * 60))
    const hours = Math.floor(diff / (1000 * 60 * 60))
    const days = Math.floor(diff / (1000 * 60 * 60 * 24))

    if (minutes < 1) {
      return '刚刚'
    } else if (minutes < 60) {
      return `${minutes}分钟前`
    } else if (hours < 24) {
      return `${hours}小时前`
    } else if (days < 7) {
      return `${days}天前`
    } else {
      return date.toLocaleDateString()
    }
  }
}