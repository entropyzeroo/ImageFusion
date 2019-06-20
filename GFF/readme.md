# Guide Filter Fusion(GFF)

​		本文提出了一种基于导向滤波的图像融合方法。融合的对象可以是**多光谱图像**，**多焦点的图像**，**不同曝光的图像**等。论文的创新点就是提出了一种多幅图像的权重计算方法，引入了像素显著性和图像空间连续性的概念。并且使用了引导滤波来重建权重，最终得到了高效和不错的融合效果。

[学习记录](https://blog.csdn.net/weixin_43194305/article/details/90678312)

效果：![](https://img-blog.csdnimg.cn/2019053011355770.jpg)

![lena](https://img-blog.csdnimg.cn/20190603171823631.jpg)