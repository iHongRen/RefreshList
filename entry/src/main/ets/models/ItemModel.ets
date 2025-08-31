/**
 * @fileName : ItemModel.ets
 * @author : @cxy
 * @date : 2025/4/15
 * @description : 通用数据模型
 */

export class ItemModel {
  id: string = ''
  title: string = ''
  
  // 基础属性
  subtitle?: string
  description?: string
  content?: string
  category?: string
  
  // 媒体属性
  image?: string
  avatar?: string
  imageHeight?: number
  
  // 用户相关
  author?: string
  name?: string
  
  // 数值属性
  price?: string
  sales?: number
  rating?: number
  likes?: number
  comments?: number
  views?: number
  score?: number
  unreadCount?: number
  index?: number
  
  // 状态属性
  isOnline?: boolean
  isHot?: boolean
  isNew?: boolean
  isPinned?: boolean
  isActive?: boolean
  likesChanged?: boolean
  
  // 时间属性
  time?: string
  timestamp?: string | number
  
  // 消息相关
  lastMessage?: string
  messageType?: string
  
  // 性能相关
  avatarColor?: string
  initial?: string
  renderTime?: number
  memorySize?: number
  priority?: number

  constructor(id: string = '', title: string = '') {
    this.id = id
    this.title = title
  }
}