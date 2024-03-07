# wave_progress_indicator

Material You 波浪进度条简易实现
![波浪进度条](image.png)

要点：每帧改变sin(ax+b)的b（相位），即可实现波浪效果。
可以使用Ticker，它会在每一帧执行一次。在这里改变相位并通知重绘。
