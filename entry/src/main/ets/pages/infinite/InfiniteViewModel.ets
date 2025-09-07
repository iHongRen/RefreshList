/**
 * @fileName : InfiniteViewModel.ets
 * @author : @cxy
 * @date : 2025/9/5
 * @description : 无限滚动数据管理
 */

import { RefreshController, RefreshDataSource } from "@cxy/refreshlist"
import { ItemModel } from "../../models/ItemModel"

interface ITotal {
  total: number,
  currentPage: number,
  totalPages: number
}

export class InfiniteViewModel {
  dataSource: RefreshDataSource = new RefreshDataSource()
  controller: RefreshController = new RefreshController()
  private currentPage: number = 1
  private pageSize: number = 15
  private isLoading: boolean = false
  private totalPages: number = 20 // 模拟总共20页数据

  refresh(): void {
    if (this.isLoading) {
      return
    }
    this.requestData(1)
  }

  loadMore(): void {
    if (this.isLoading || this.currentPage >= this.totalPages) {
      return
    }
    this.requestData(this.currentPage + 1)
  }

  // 获取当前数据统计
  getDataStats(): ITotal {
    return {
      total: this.dataSource.totalCount(),
      currentPage: this.currentPage,
      totalPages: this.totalPages
    }
  }

  // 检查是否正在加载
  getLoadingState(): boolean {
    return this.isLoading
  }

  private async requestData(page: number): Promise<void> {
    if (this.isLoading) {
      return
    }

    this.isLoading = true

    // 模拟网络请求延迟
    setTimeout(() => {
      this.currentPage = page
      const data = this.generateInfiniteData(this.pageSize)

      if (page === 1) {
        this.dataSource.deleteAll()
      }
      this.dataSource.pushDataArray(data)

      // 设置是否还有更多数据
      const hasMore = page < this.totalPages
      this.controller.setHasmore(hasMore)
      this.controller.finishRefresh()

      this.isLoading = false
    }, page === 1 ? 800 : 500) // 刷新稍慢，加载更多稍快
  }

  private generateInfiniteData(count: number): ItemModel[] {
    const newsCategories = [
      '科技前沿', '人工智能', '移动开发', '云计算', '大数据',
      '区块链', '物联网', '网络安全', '开源项目', '编程语言'
    ]

    const newsTitles = [
      'HarmonyOS NEXT 发布重大更新',
      'AI 技术在移动端的最新应用',
      '跨平台开发框架性能对比',
      '云原生架构设计最佳实践',
      '大数据处理技术新突破',
      '区块链技术在金融领域的应用',
      '5G 时代的物联网发展趋势',
      '网络安全防护策略升级',
      '开源社区贡献指南',
      '新一代编程语言特性解析'
    ]

    const descriptions = [
      '深入解析最新技术动态，为开发者提供前沿资讯和实用指南。',
      '探索创新应用场景，分享实战经验和最佳实践案例。',
      '全面对比分析，帮助开发者做出明智的技术选择。',
      '详细介绍核心概念和实现方法，提升开发效率。',
      '分享行业洞察和趋势预测，把握技术发展方向。'
    ]

    const colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
      '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9'
    ]

    const result: ItemModel[] = []
    for (let i = 0; i < count; i++) {
      const globalIndex = (this.currentPage - 1) * this.pageSize + i
      const categoryIndex = globalIndex % newsCategories.length
      const titleIndex = globalIndex % newsTitles.length

      const item = new ItemModel(`infinite_${globalIndex}`, newsTitles[titleIndex])
      item.description = descriptions[globalIndex % descriptions.length]
      item.category = newsCategories[categoryIndex]
      item.avatarColor = colors[categoryIndex]
      item.initial = newsCategories[categoryIndex].charAt(0)
      item.time = this.getTimeAgo(globalIndex)
      item.views = Math.floor(Math.random() * 10000) + 100
      item.likes = Math.floor(Math.random() * 500) + 10
      item.comments = Math.floor(Math.random() * 100) + 5
      item.isHot = globalIndex % 7 === 0 // 每7个标记为热门
      item.author = this.getRandomAuthor()
      item.index = globalIndex + 1

      result.push(item)
    }
    return result
  }

  private getTimeAgo(index: number): string {
    const minutes = index * 3 + Math.floor(Math.random() * 10)

    if (minutes < 60) {
      return `${minutes}分钟前`
    } else if (minutes < 1440) { // 24小时
      const hours = Math.floor(minutes / 60)
      return `${hours}小时前`
    } else {
      const days = Math.floor(minutes / 1440)
      return `${days}天前`
    }
  }

  private getRandomAuthor(): string {
    const authors = [
      '技术小编', '开发者社区', '科技观察员', '代码工匠', '架构师',
      '产品经理', '设计师', 'AI研究员', '数据分析师', '安全专家'
    ]
    return authors[Math.floor(Math.random() * authors.length)]
  }
}