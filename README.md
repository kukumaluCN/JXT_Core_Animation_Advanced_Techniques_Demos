# JXT_Core_Animation_Advanced_Techniques_Demos
iOS Core Animation Advanced Techniques 学习笔记

感谢[iOS Core Animation: Advanced Techniques中文译本](https://zsisme.gitbooks.io/ios-/content/)

## 工程结构：

### 1.图层树
- CoreAnimationAdvancedTechniques1_3  
使用图层  

### 2.寄宿图
- CoreAnimationAdvancedTechniques2_1  
contents属性（contentsRect图片拼合） 

- CoreAnimationAdvancedTechniques2_2  
Custom Drawing（CALayerDelegate适配）

### 3.图层几何学
- CoreAnimationAdvancedTechniques3_1  
布局（frame与bounds，position，transform的关系）

- CoreAnimationAdvancedTechniques3_2  
锚点（模拟时钟）

- CoreAnimationAdvancedTechniques3_3  
坐标系

- CoreAnimationAdvancedTechniques3_4  
Hit Testing（convertPoint）

### 4.视觉效果
- CoreAnimationAdvancedTechniques4_1  
圆角

- CoreAnimationAdvancedTechniques4_2  
图层边框

- CoreAnimationAdvancedTechniques4_3  
阴影

- CoreAnimationAdvancedTechniques4_4  
图层蒙版（mask）

- CoreAnimationAdvancedTechniques4_5		
拉伸过滤（数字时钟）

- CoreAnimationAdvancedTechniques4_6  
组透明

### 5.变换
- CoreAnimationAdvancedTechniques5_1		
仿射变换（2D矩阵）

- CoreAnimationAdvancedTechniques5_2   
3D变换（3D矩阵，透视旋转，系统3D变换函数自实现）

- CoreAnimationAdvancedTechniques5_3  
固体对象（正方体绘制，OpenGL添加光影）

### 6.专用图层
- CoreAnimationAdvancedTechniques6_1  
CAShapeLayer（火柴人绘制，圆角矩形，CAShapeLayer属性详解）

- CoreAnimationAdvancedTechniques6_2  
CATextLayer（CGFontRef，CTFontRef，LayerLabel）

- CoreAnimationAdvancedTechniques6_3  
CATransformLayer（CATransformLayer构造正方体）  

- CoreAnimationAdvancedTechniques6_4  
CAGradientLayer（CAGradientLayer色彩渐变，渐变环形进度条）  

- CoreAnimationAdvancedTechniques6_5  
CAReplicatorLayer（CAReplicatorLayer图层复制，模仿系统indicatorView，反射效果）  

- CoreAnimationAdvancedTechniques6_6  
CAScrollLayer  

- CoreAnimationAdvancedTechniques6_7  
CATiledLayer（大图小片裁剪加载）  

- CoreAnimationAdvancedTechniques6_8  
CAEmitterLayer（粒子做火焰爆炸效果）  

- CoreAnimationAdvancedTechniques6_9  
CAEAGLLayer（OpenGL绘制三角形）  

- CoreAnimationAdvancedTechniques6_10    
AVPlayerLayer（简单的视频播放）  

### 7.隐式动画
- CoreAnimationAdvancedTechniques7_1    
CATransaction事务（隐式动画，事务）   

- CoreAnimationAdvancedTechniques7_2    
CATransaction完成块（隐式动画结束回调）   

- CoreAnimationAdvancedTechniques7_3  
图层行为 -actionForLayer

- CoreAnimationAdvancedTechniques7_4  
呈现与模型 presentationLayer

### 8.显式动画
- CoreAnimationAdvancedTechniques8_1  
属性动画，关键帧动画，虚拟属性  

- CoreAnimationAdvancedTechniques8_2  
动画组  

- CoreAnimationAdvancedTechniques8_3    
过渡动画  

- CoreAnimationAdvancedTechniques8_4    
在动画过程中取消动画  

### 9.图层时间
- CoreAnimationAdvancedTechniques9_1   
CAMediaTiming协议  
duration、repeatCount、repeatDuration  
autoreverses  
beginTime、timeOffset  
fillMode  

- CoreAnimationAdvancedTechniques9_2  
层级关系时间  
CACurrentMediaTime()、暂停/重启动画  

- CoreAnimationAdvancedTechniques9_3    
手动动画   

### 10.缓冲
- CoreAnimationAdvancedTechniques10_1  
动画速度：CAMediaTimingFunction、UIView的动画缓冲、缓冲和关键帧动画  

- CoreAnimationAdvancedTechniques10_2  
自定义缓冲函数：绘制CAMediaTimingFunction曲线、基于关键帧的缓冲  

### 11.基于定时器的动画  
- CoreAnimationAdvancedTechniques11_1  
定时帧:NSTimer/CADisplayLink  
RunLoop模式  

- CoreAnimationAdvancedTechniques11_2  
Chipmunk2D  

### 13.高效绘图  
- CoreAnimationAdvancedTechniques13_2    
矢量绘图（drawRect/CAShapeLayer画板）  

- CoreAnimationAdvancedTechniques13_3      
脏矩形（setNeedsDisplayInRect、粉笔画板） 
