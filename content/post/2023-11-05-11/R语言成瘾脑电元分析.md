---
title: "R语言成瘾脑电元分析"
author: "余巎"
date: "2023-4-14"
categories: ["R"]
tags: ["R Markdown", "plot", "regression"]
output: 
  html_document:
#    <span style="font-size:5px;">字号25px</span>
    #fontsize: 16ptkss
    code_folding: hide
    df_print: paged
    highlight: tango
    toc: yes
    toc_float:
      collapsed: yes
      smooth_scroll: no
    keep_md: true
theme: cerulean

    # toc: yes
    # toc_float: yes #悬停目录
    #   collapsed: no #侧边栏的折叠和动画
    #   smooth_scoll: yes #控制页面滚动时，标题是否会随之变化。
---

<script src="/rmarkdown-libs/kePrint/kePrint.js"></script>
<link href="/rmarkdown-libs/lightable/lightable.css" rel="stylesheet" />
<script src="/rmarkdown-libs/kePrint/kePrint.js"></script>
<link href="/rmarkdown-libs/lightable/lightable.css" rel="stylesheet" />
<script src="/rmarkdown-libs/htmlwidgets/htmlwidgets.js"></script>
<script src="/rmarkdown-libs/viz/viz.js"></script>
<link href="/rmarkdown-libs/DiagrammeR-styles/styles.css" rel="stylesheet" />
<script src="/rmarkdown-libs/grViz-binding/grViz.js"></script>
<script src="/rmarkdown-libs/kePrint/kePrint.js"></script>
<link href="/rmarkdown-libs/lightable/lightable.css" rel="stylesheet" />
<script src="/rmarkdown-libs/htmlwidgets/htmlwidgets.js"></script>
<link href="/rmarkdown-libs/datatables-css/datatables-crosstalk.css" rel="stylesheet" />
<script src="/rmarkdown-libs/datatables-binding/datatables.js"></script>
<script src="/rmarkdown-libs/jquery/jquery-3.6.0.min.js"></script>
<link href="/rmarkdown-libs/dt-core/css/jquery.dataTables.min.css" rel="stylesheet" />
<link href="/rmarkdown-libs/dt-core/css/jquery.dataTables.extra.css" rel="stylesheet" />
<script src="/rmarkdown-libs/dt-core/js/jquery.dataTables.min.js"></script>
<link href="/rmarkdown-libs/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="/rmarkdown-libs/crosstalk/js/crosstalk.min.js"></script>
<style type="text/css">
&#10;body{ /* Normal  */
      font-size: 22px;
  }
td {  /* Table  */
  font-size: 8px;
}
h1.title {
  font-size: 38px;
  color: Dark;
}
h1 { /* Header 1 */
  font-size: 28px;
  color: Dark;
}
h2 { /* Header 2 */
    font-size: 22px;
  color: Dark;
}
h3 { /* Header 3 */
  font-size: 24px;
  font-family: "Times New Roman", Times, serif;
  color: Dark;
}
code.r{ /* Code block */
    font-size: 12px;
}
pre { /* Code block - determines code spacing between lines */
    font-size: 14px;
}
</style>

------------------------------------------------------------------------

本课程初心

- 对自己:源于**以教促学,为毕设开题作准备**.毕设主要为问卷数据、ERP脑电指标相关数据的元分析, 要推进关键的“数据录入、数据转化”阶段, 则必须掌握目标文献涉及的统计量与效应量, 如何确定自己是否掌握? 将自己在R生态系统中数据分析的结果与原文结果核对, 无误则说明掌握.
- 对同学: 抛砖引玉,希望目前粗糙的版本能激发大家对于R语言和脑电元分析的兴趣.
  错误之处,欢迎指正
  \# 元分析简介
  \# `{r setup-pdf, include=FALSE} # pdf.options(family="GB1") #`

元分析可从数据层面分成3类:问卷数据、脑电指标数据ERP, 核磁数据fMRI.

## 元分析流程

### 方案预注册

PROSPERO\[Register\]<https://www.crd.york.ac.uk/PROSPERO/#recordDetails>

### 文献检索

流程图

``` r
library(htmltools)
library(knitr)
library(kableExtra)#not kable
library(readxl)
library(dplyr)

data <- read_excel("D:/桌面/Meta-analysis/Supplementary data/NY_Sup/Suicidal_meta_spreadsheet.xlsx", sheet = "DataBase") %>% 
#C:D:/桌面/Meta-analysis/Supplementary data/NY_Sup
# Paper_search_data <- data %>% 
#   dplyr::select(Database, Boolean, everything()) %>% 
  kable(align = "c",  caption = "文献检索关键词和数据库") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
data
```

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
<caption>
<span id="tab:unnamed-chunk-1"></span>Table 1: 文献检索关键词和数据库
</caption>
<thead>
<tr>
<th style="text-align:center;">
Database
</th>
<th style="text-align:center;">
Boolean
</th>
<th style="text-align:center;">
Date
</th>
<th style="text-align:center;">
\# Hits
</th>
<th style="text-align:center;">
Date2
</th>
<th style="text-align:center;">
\# New
</th>
<th style="text-align:center;">
…7
</th>
<th style="text-align:center;">
…8
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Pubmed
</td>
<td style="text-align:center;">
(“event-related potential”\[Title/Abstract\] OR “event-related potentials”\[Title/Abstract\] OR “electroencephalography”\[Title/Abstract\] OR “EEG”\[Title/Abstract\] OR “evoked potential”\[Title/Abstract\] OR “evoked potentials”\[Title/Abstract\] OR “late positive potential”\[Title/Abstract\] OR “reward positivity”\[Title/Abstract\] OR “P3a”\[Title/Abstract\] OR “P3b”\[Title/Abstract\] OR “error-related negativity”\[Title/Abstract\]) AND (“suicide”\[Title/Abstract\] OR “suicidal”\[Title/Abstract\] OR “self-harm”\[Title/Abstract\] OR “self-injury”\[Title/Abstract\] OR “suicidal ideation”\[Title/Abstract\] OR “suicide ideation”\[Title/Abstract\] OR “parasuicide”\[Title/Abstract\] OR “suicide attempt”\[Title/Abstract\] OR “suicide plan”\[Title/Abstract\] OR “suicidality”\[Title/Abstract\] OR “suicide risk”\[Title/Abstract\] OR “attempter”\[Title/Abstract\] OR “attempters”\[Title/Abstract\] OR “ideators”\[Title/Abstract\]) NOT (epilep\*\[Title/Abstract\] OR qEEG\[Title/Abstract\] OR “quantitative EEG”\[Title/Abstract\] OR “video EEG”\[Title/Abstract\] OR “vEEG”\[Title/Abstract\] OR “case report”\[Title/Abstract\])
</td>
<td style="text-align:center;">
2019-10-29
</td>
<td style="text-align:center;">
142
</td>
<td style="text-align:center;">
2020-10-16
</td>
<td style="text-align:center;">
15
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Psycinfo (Proquest)
</td>
<td style="text-align:center;">
ab(“event-related potential” OR “event-related potentials” OR “electroencephalography” OR “EEG” OR “evoked potential” OR “evoked potentials” OR “late positive potential” OR “reward positivity” OR “P3a” OR “P3b” OR “error-related negativity”) AND ab(“suicide” OR “suicidal” OR “self-harm” OR “self-injury” OR “suicidal ideation” OR “suicide ideation” OR “parasuicide” OR “suicide attempt” OR “suicide plan” OR “suicidality” OR “suicide risk” OR “attempter” OR “attempters” OR “ideators”) NOT ab(epilep\* OR qEEG OR “quantitative EEG” OR “video EEG” OR “vEEG” OR “case report”)
</td>
<td style="text-align:center;">
2019-10-29
</td>
<td style="text-align:center;">
94
</td>
<td style="text-align:center;">
2020-10-20
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Web of Science
</td>
<td style="text-align:center;">
TI =(“event-related potential” OR “event-related potentials” OR “electroencephalography” OR “EEG” OR “evoked potential” OR “evoked potentials” OR “late positive potential” OR “reward positivity” OR “P3a” OR “P3b” OR “error-related negativity”) AND TI= (“suicide” OR “suicidal” OR “self-harm” OR “self-injury” OR “suicidal ideation” OR “suicide ideation” OR “parasuicide” OR “suicide attempt” OR “suicide plan” OR “suicidality” OR “suicide risk” OR “attempter” OR “attempters” OR “ideators”) NOT TI =(epilep\* OR qEEG OR “quantitative EEG” OR “video EEG” OR “vEEG” OR “case report”)
</td>
<td style="text-align:center;">
2019-10-31
</td>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
2020-10-20
</td>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Proquest Dissertations/Theses
</td>
<td style="text-align:center;">
ab(“event-related potential” OR “event-related potentials” OR “electroencephalography” OR “EEG” OR “evoked potential” OR “evoked potentials” OR “late positive potential” OR “reward positivity” OR “P3a” OR “P3b” OR “error-related negativity”) AND ab(“suicide” OR “suicidal” OR “self-harm” OR “self-injury” OR “suicidal ideation” OR “suicide ideation” OR “parasuicide” OR “suicide attempt” OR “suicide plan” OR “suicidality” OR “suicide risk” OR “attempter” OR “attempters” OR “ideators”) NOT ab(epilep\* OR qEEG OR “quantitative EEG” OR “video EEG” OR “vEEG” OR “case report”)
</td>
<td style="text-align:center;">
2019-10-29
</td>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
2020-10-20
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
270
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
28
</td>
<td style="text-align:center;">
298
</td>
<td style="text-align:center;">
TOTAL
</td>
</tr>
</tbody>
</table>

\[Rmarkdown 表格创建\] <https://zhuanlan.zhihu.com/p/36919769>

制定检索策略与筛选标准：确定检索词、数据库以及相关的筛选标准. 比如脑电元分析论文“Suicidal thoughts, behaviors, and event-related potentials: A systematic review and meta-analysis”:

关键词: “event-related potential,” “event-related potentials,” “electroencepha- lography,” “EEG,” “evoked potential,” “evoked poten-tials,” “late positive potential,” “reward positivity,” “P3a,” “P3b,” “error-related negativity,” “suicide,” “suicidal,” “suicidal ideation,” “self-harm,” “self-injury,” “parasu- icide,” “suicide ideation,” “suicide attempt,” “suicide plan,” “suicidality,” “自杀风险,” “attempter,” “attempt- ers,” and “ideators.”

### 系统评价(暂无)

### 数据录入

明确需要纳入的数据类型:需要把*统计量转换为效应量*:
•明确数据提取人员 •设计数据提取表格 •进行预试验 •开始数据提取 •数据核查、修改 •处理意见分歧

*参考已发表的脑电元分析*

- 心理科学进展上: 《EMMN 受偏差−标准刺激对类型和情绪类型影响: 来自元分析的证据\*》,以及医咖会的《11-系统评价与Meta分析的数据提取》. 每篇文献的以下数据将被提取: 第一作者、发表
  年份、被试个数与男女比例、被试均龄和标准差、
  计算效应量的数据(即均值+标准差、t 值、F 值或
  p 值)、实验范式、情绪类型、时间窗、偏差−标准
  刺激对、任务相关性、电极/ROI、面孔类型、单
  试次呈现图片数、图片呈现时间等; 研究中结果不显著的也要录入。

- 效应量effect size: “d-family（difference family）:：如Cohen’s d、Hedges’ g
  r-family（correlation family）：如Pearson r、R²、η²、ω²、f
  OR-family（categorical family）：如odds ratio (OR)、risk ratio (RR)”

### 效应值合并

\[Excel template统计量-效应量转换、不同效应量之间的相互转换\] <https://osf.io/6tfh5/>

### 森林图

``` r
knitr::include_graphics("C:/Users/12570/Desktop/NY/forest.png")
```

<img src="C:/Users/12570/Desktop/NY/forest.png" width="616" />

### 异质性分析

(1)临床基线异质性。即研究样本特征之间的差异。例如，一项研究的被试是老 人，而另一项研究的参与者是青年人。(2)统计异质性。这是效应量的异质性。这种 异质性从临床角度(例如，当我们不知道一种治疗是否非常有效，或者仅仅是因为研 究之间效应差异很大而产生的边际效应)或者从统计学(在统计上它稀释了我们对混 合效应的信心)角度来看，都很重要。(3)其他异质性来源，如与设计相关的异质性。

7.1 异质性思想
7.2 异质性指标
7.2.1 选择异质性指标
7.3 评估混合效应量的异质性
7.3.1 当输出中没有呈现异质性指标
7.4 检测异常值&有影响力的个案
7.4.1 检测极端效应值(异常值)  
7.5 影响力分析  
7.5.1 影响力分析 (Influence Analyses)
7.5.2 Baujat 图
7.5.3“去一”分析 (Leave-One-Out Analyses)
7.6 GOSH PLOT ANALYSIS

### 敏感性分析

看研究结果稳定不稳定,只要是结果方向性一致就可以。例如均提示实验组较对照组有效，且P值都小于0.05. 那么说明你的研究结果是稳定的. 敏感性分析仅对剔除后剩下的研究进行合并分析，并与剔除前的合并效应量进行对比，而不分析剔除的研究 逐一敏感性分析：逐一敏感性分析，就是每次剔除一个研究，把剩余研究进行合并

### 剪补法/留一法

### 亚组分析

- 考察元分析研究中的不同亚组之间的差异，并尝试确定它们在效应大 小方面是否存在差异.比如要根据不同的疾病严重程度、性别进行亚组分析
  每个亚组分析由两部分组成:(1)每个亚组的合并后的效应量大小;(2)比较
  各亚组的效应量大小。
- 使用混合效应模型的亚组分析:为了使用混合效应模型(亚分组内使用随机效应模型，亚分组间使用固定效应模
  型)进行亚组分析，可以使用提前准备好的 subgroup.analysis.mixed effects()函 数

### 元回归

亚组分析实际上就是加了类别变量的元回归分析. 在这种元回归分析中，这些亚组通常是被编码为哑变量(dummy variables)

### 调节变量分析

[调节变量分析](#调节变量分析)<https://zhuanlan.zhihu.com/p/360558511>
用于研究真实效应量是否受调节变量影响,称为协变量分析更恰当，因为下述模型中不考虑变量间的交互作用。

- 若调节变量（Mo）是类别数据（categorical moderator），该分析又称为亚组分析(subgroup analysis; Borenstein et al., 2019)【类似于ANOVA】. 比如(性别, 是否网游成瘾)
- 若调节变量(Mo)是连续数据（continuous moderator），该分析更近似于多重回归分析【multiple regression analysis】. (年龄,成瘾或戒断时间)
  \### 发表偏倚检验{.tabset}

# R语言简介

可进行元分析的其它软件:CMA, Review Manager…; 相比spss, Mplus, Prism, JASP..,个人偏好*R语言生态系统(数据整理、分析、可视化、结果报告)*.

> *“R is for research, python is for production”*.

- 分析语句数量对比
  <img src="C:/Users/12570/Desktop/NY/IMG_5488.JPG" width="100%" height="100%" />

- 运行时间对比
  <img src="C:/Users/12570/Desktop/NY/IMG_5489.JPG" width="100%" height="100%" />

## 基本对象(数据结构)

掌握基础语法(运算符)、基本对象…是为了看懂别人的代码块,然后抄过来,删、改、调试成自己需要的版本.

### 向量

向量中的元素必须是同一种数据类型，简单向量中的元素为原子类型，复杂向量中的元素可以是列表等。

``` r
R <- c(x1=250,x2=250,x3=250)
R
##  x1  x2  x3 
## 250 250 250
```

### 数组

创建矩阵的语法为array(data = NA, dim = length(data), dimnames = NULL)

``` r
array(1:3, c(2,4,2))
## , , 1
## 
##      [,1] [,2] [,3] [,4]
## [1,]    1    3    2    1
## [2,]    2    1    3    2
## 
## , , 2
## 
##      [,1] [,2] [,3] [,4]
## [1,]    3    2    1    3
## [2,]    1    3    2    1
```

### 列表

用list函数创建

``` r
x <- list(a="R语言",b="脑电",c="元分析",d=1:3)
#y <- list(x,5+3i)
x
## $a
## [1] "R语言"
## 
## $b
## [1] "脑电"
## 
## $c
## [1] "元分析"
## 
## $d
## [1] 1 2 3
```

### 数据框

``` r
library(tibble)
df = tibble(
  grammer = c("R语言","脑电","元分析"),
  score = c(6,6,6)
  )
df
## # A tibble: 3 × 2
##   grammer score
##   <chr>   <dbl>
## 1 R语言       6
## 2 脑电        6
## 3 元分析      6
```

### 矩阵

，data参数指定原始向量的数据，nrow参数指定行数，ncol参数指定列数，默认将原有向量按照纵向排成矩阵

``` r
x <- matrix(R,2)
x
##      [,1] [,2]
## [1,]  250  250
## [2,]  250  250
```

#### 矩阵的拼接

矩阵的横向拼接用函数cbind，纵向拼接用函数rbind，被拼接的对象可以是矩阵，也可以是向量。他们在拼接方向需要有相同的维度。当横向拼接向量时，向量被视为行向量；当纵向拼接向量时，其被视为列向量。

``` r
r1 <- matrix(R,2)
r2 <- matrix(R,2)
cbind(r1,r2)
##      [,1] [,2] [,3] [,4]
## [1,]  250  250  250  250
## [2,]  250  250  250  250
```

``` r
rbind(r1,r2)
##      [,1] [,2]
## [1,]  250  250
## [2,]  250  250
## [3,]  250  250
## [4,]  250  250
```

#### 矩阵级运算

### (自定义)函数

- 函数定义:R语言的执行顺序是自上而下每条语句依次执行，所以要使用一个函数，必须在这行代码之前就定义了函数，而不能将函数定义写在函数调用之后

- 函数调用: 其他脚本中的函数，则使用source函数，source的参数为脚本名而非函数名，需要用引号括起来。如果该脚本不在工作路径中，还需要在前面添加路径，如source(“PowScript.R”)或source(“other/path/PowScript.R”)。这样相当于PowScript.R脚本中的所有代码全部复制一遍放在了这一行代码处

``` r
FuncName <- function (arglist) {
  expr
  return(value)
}
```

## 基础语法

对单个表（数据框）的结构进行变换，但不利用单元格进行运算，常见的操作包括：

- 行去重：distinct(.data, …, .keep_all = FALSE)
- 行筛选：filter()
- 列筛选：select()
- 行排序：arrange()
- 长转宽：spread(data, key=键所在列, value=键值所在列)
- 宽转长：gather(data, 需要转换的各列, key = “新建的键名”, value = - “新建的键值名”)
- 列合并：unite(data, col=新列, 需要合并的各列, sep = “\_“, remove = - TRUE)
- 列分裂：separate(data, col, into=c(“列1”,“列2”,…), sep = - “\[^\[:alnum:\]\]+”)
- 嵌套与取消嵌套：nest()、unnest()

## 基本操作

### 表达式

### 对象操作

# **R语言元分析代码应用**

``` r
devtools::session_info() #编译本教程所用的R软件环境：
## ─ Session info ───────────────────────────────────────────────────────────────
##  setting  value
##  version  R version 4.3.2 (2023-10-31 ucrt)
##  os       Windows 11 x64 (build 22621)
##  system   x86_64, mingw32
##  ui       RTerm
##  language (EN)
##  collate  Chinese (Simplified)_China.utf8
##  ctype    Chinese (Simplified)_China.utf8
##  tz       Asia/Shanghai
##  date     2023-11-22
##  pandoc   3.1.1 @ C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/ (via rmarkdown)
## 
## ─ Packages ───────────────────────────────────────────────────────────────────
##  package     * version date (UTC) lib source
##  blogdown      1.18    2023-06-19 [1] CRAN (R 4.3.2)
##  bookdown      0.36    2023-10-16 [1] CRAN (R 4.3.2)
##  bslib         0.5.1   2023-08-11 [1] CRAN (R 4.3.2)
##  cachem        1.0.8   2023-05-01 [1] CRAN (R 4.3.2)
##  callr         3.7.3   2022-11-02 [1] CRAN (R 4.3.2)
##  cellranger    1.1.0   2016-07-27 [1] CRAN (R 4.3.2)
##  cli           3.6.1   2023-03-23 [1] CRAN (R 4.3.2)
##  colorspace    2.1-0   2023-01-23 [1] CRAN (R 4.3.2)
##  crayon        1.5.2   2022-09-29 [1] CRAN (R 4.3.2)
##  devtools      2.4.5   2022-10-11 [1] CRAN (R 4.3.2)
##  digest        0.6.33  2023-07-07 [1] CRAN (R 4.3.2)
##  dplyr       * 1.1.4   2023-11-17 [1] CRAN (R 4.3.2)
##  ellipsis      0.3.2   2021-04-29 [1] CRAN (R 4.3.2)
##  evaluate      0.23    2023-11-01 [1] CRAN (R 4.3.2)
##  fansi         1.0.5   2023-10-08 [1] CRAN (R 4.3.2)
##  fastmap       1.1.1   2023-02-24 [1] CRAN (R 4.3.2)
##  fs            1.6.3   2023-07-20 [1] CRAN (R 4.3.2)
##  generics      0.1.3   2022-07-05 [1] CRAN (R 4.3.2)
##  glue          1.6.2   2022-02-24 [1] CRAN (R 4.3.2)
##  highr         0.10    2022-12-22 [1] CRAN (R 4.3.2)
##  htmltools   * 0.5.7   2023-11-03 [1] CRAN (R 4.3.2)
##  htmlwidgets   1.6.2   2023-03-17 [1] CRAN (R 4.3.2)
##  httpuv        1.6.12  2023-10-23 [1] CRAN (R 4.3.2)
##  httr          1.4.7   2023-08-15 [1] CRAN (R 4.3.2)
##  jquerylib     0.1.4   2021-04-26 [1] CRAN (R 4.3.2)
##  jsonlite      1.8.7   2023-06-29 [1] CRAN (R 4.3.2)
##  kableExtra  * 1.3.4   2021-02-20 [1] CRAN (R 4.3.2)
##  knitr       * 1.45    2023-10-30 [1] CRAN (R 4.3.2)
##  later         1.3.1   2023-05-02 [1] CRAN (R 4.3.2)
##  lifecycle     1.0.4   2023-11-07 [1] CRAN (R 4.3.2)
##  magrittr      2.0.3   2022-03-30 [1] CRAN (R 4.3.2)
##  memoise       2.0.1   2021-11-26 [1] CRAN (R 4.3.2)
##  mime          0.12    2021-09-28 [1] CRAN (R 4.3.1)
##  miniUI        0.1.1.1 2018-05-18 [1] CRAN (R 4.3.2)
##  munsell       0.5.0   2018-06-12 [1] CRAN (R 4.3.2)
##  pillar        1.9.0   2023-03-22 [1] CRAN (R 4.3.2)
##  pkgbuild      1.4.2   2023-06-26 [1] CRAN (R 4.3.2)
##  pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 4.3.2)
##  pkgload       1.3.3   2023-09-22 [1] CRAN (R 4.3.2)
##  png           0.1-8   2022-11-29 [1] CRAN (R 4.3.1)
##  prettyunits   1.2.0   2023-09-24 [1] CRAN (R 4.3.2)
##  processx      3.8.2   2023-06-30 [1] CRAN (R 4.3.2)
##  profvis       0.3.8   2023-05-02 [1] CRAN (R 4.3.2)
##  promises      1.2.1   2023-08-10 [1] CRAN (R 4.3.2)
##  ps            1.7.5   2023-04-18 [1] CRAN (R 4.3.2)
##  purrr         1.0.2   2023-08-10 [1] CRAN (R 4.3.2)
##  R6            2.5.1   2021-08-19 [1] CRAN (R 4.3.2)
##  Rcpp          1.0.11  2023-07-06 [1] CRAN (R 4.3.2)
##  readxl      * 1.4.3   2023-07-06 [1] CRAN (R 4.3.2)
##  remotes       2.4.2.1 2023-07-18 [1] CRAN (R 4.3.2)
##  rlang         1.1.2   2023-11-04 [1] CRAN (R 4.3.2)
##  rmarkdown     2.25    2023-09-18 [1] CRAN (R 4.3.2)
##  rstudioapi    0.15.0  2023-07-07 [1] CRAN (R 4.3.2)
##  rvest         1.0.3   2022-08-19 [1] CRAN (R 4.3.2)
##  sass          0.4.7   2023-07-15 [1] CRAN (R 4.3.2)
##  scales        1.2.1   2022-08-20 [1] CRAN (R 4.3.2)
##  sessioninfo   1.2.2   2021-12-06 [1] CRAN (R 4.3.2)
##  shiny         1.7.5.1 2023-10-14 [1] CRAN (R 4.3.2)
##  stringi       1.8.1   2023-11-13 [1] CRAN (R 4.3.2)
##  stringr       1.5.1   2023-11-14 [1] CRAN (R 4.3.2)
##  svglite       2.1.2   2023-10-11 [1] CRAN (R 4.3.2)
##  systemfonts   1.0.5   2023-10-09 [1] CRAN (R 4.3.2)
##  tibble      * 3.2.1   2023-03-20 [1] CRAN (R 4.3.2)
##  tidyselect    1.2.0   2022-10-10 [1] CRAN (R 4.3.2)
##  urlchecker    1.0.1   2021-11-30 [1] CRAN (R 4.3.2)
##  usethis       2.2.2   2023-07-06 [1] CRAN (R 4.3.2)
##  utf8          1.2.4   2023-10-22 [1] CRAN (R 4.3.2)
##  vctrs         0.6.4   2023-10-12 [1] CRAN (R 4.3.2)
##  viridisLite   0.4.2   2023-05-02 [1] CRAN (R 4.3.2)
##  webshot       0.5.5   2023-06-26 [1] CRAN (R 4.3.2)
##  xfun          0.41    2023-11-01 [1] CRAN (R 4.3.2)
##  xml2          1.3.5   2023-07-06 [1] CRAN (R 4.3.2)
##  xtable        1.8-4   2019-04-21 [1] CRAN (R 4.3.2)
##  yaml          2.3.7   2023-01-23 [1] CRAN (R 4.3.2)
## 
##  [1] C:/Users/12570/AppData/Local/R/win-library/4.3
##  [2] C:/Program Files/R/R-4.3.2/library
## 
## ──────────────────────────────────────────────────────────────────────────────
```

<div class="figure">

<img src="C:/Users/12570/Desktop/NY/sucidal_meta copy.png" alt="参考的脑电元分析" width="100%" />
<p class="caption">
<span id="fig:unnamed-chunk-14"></span>Figure 1: 参考的脑电元分析
</p>

</div>

## **研究问题**

(练习数据来自脑电元分析论文)“Suicidal thoughts, behaviors, and event-related potentials: A systematic review and meta-analysis”): **自杀想法和行为Suicidal thoughts and behaviors (STBs)**:
- suicidal ideation (SI)ideation and suicide attempts自杀尝试 (SA; Schmaal et al., 2019)
问题1:

1.  **Q1:脑电指标能否区分 自杀想法和行为有无的两类人**;provide meta-analytic estimates of whether any ERPs differ between individuals who have and have not engaged in STBs;
2.  **Q2:不同效应量水平下的统计效度**; examine how powered the literature is across a range of effect sizes (sample size, effect size, statistical power)
3.  **Q3:脑电指标能否区分 4类STB**: review the literature to contextualize our meta-analytic findings and examine how various ERPs, including those that did not meet criteria for inclusion in the meta-analysis, are related to STBs.
    Regarding four separate STBs:

- *(a) those with and without suicidal ideation, 自杀想法有无*

- *(b) those with and without suicide attempts history,自杀行为有无*

- *(c) those with varying levels of suicidal risk, and 自杀风险不同的人群*

- *(d) differences between those with suicide attempts versus those with suicidal ideation only 自杀行为和自杀想法两类人对比*

- 单个脑电指标对应的研究问题(文献综述部分): 这个需要对该领域有比较全面和深入的理解, 脑电指标、实验任务、研究问题之间的联系、组合决定了数据录入模版和分析方法. 所以检索词也需要更广泛一些,小领域可能文献数量不足. 可以将同领域/主题的问卷数据和脑电指标数据元分析进行对比,侧重可能不同.

## 加载包

\[“代码段选项”\]<https://yihui.name/knitr/options>
\[R 语言必学的 10 大包\] <https://www.zhihu.com/question/24136262>

R语言是一种语言, 里面所包含的包也可以当成一种小语言,函数也可以当成一种小小语言.
方法就是
- 掌握该语言基本对象和语法,
- 先跑R自带数据集 (R docu, ?meta)
- 再跑自己熟悉的数据

- Data import (readx, readxl, xml2, DBI)
- Data tidying (tibble: Plus data.frame , tidyr, - stringr)
- Data transforming (dplyr, forcats:coping with factor - problems, hms, strings, lubridate)
- Data visualizing (ggplot2)
- Data analysis (Program_purrr: provide funtitons, - magrittr)
- Data modeling (broom)
- R version 4.3.2 (2023-10-31 ucrt).

``` r

packages <- c('tidyverse',     # data handling
              'metafor', #'metaSEM',#'compute.es',#'MAd',
              'readxl',
              'dplyr',
              'metaviz',
              'PRISMAstatement',#流程图
              'meta', 
              #'metameta',
              'ggthemes',
              'cocor',
              'cowplot',
              'kableExtra',#连接成数据框?kable
              'gridExtra',
              'xaringan', 
              'knitr', #Yihui（谢益辉）编写的knitr包:美化表格
              'DT',#交互式数据表
              'dygraphs', #dygraph interactive plot for time series data
              'plotly', #Main interface to plotly
              'ggplot2', 
              'gganimate', 
              'visNetwork',#交互式数据图
              'tibble', #数据框
              'htmltools'
              )
  
# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages], repos = c(CRAN = "https://cran.rstudio.com"))
}
# Packages loading
invisible(lapply(packages, library, character.only = TRUE))
packv <- NULL
for (i in 1:length(packages)) {
  packv = rbind(packv, c(packages[i], as.character(packageVersion(packages[i]))))
}
colnames(packv) <- c("Package", "Version") 
packv %>% 
  as_tibble %>% 
  arrange(Package) %>% 
  kable(align = "l", full_width=T, fixed_thead = T, font_size = 24) %>% #l=左对齐、r=右对齐、c=居中对齐
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
```

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
Package
</th>
<th style="text-align:left;">
Version
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
DT
</td>
<td style="text-align:left;">
0.30
</td>
</tr>
<tr>
<td style="text-align:left;">
PRISMAstatement
</td>
<td style="text-align:left;">
1.1.1
</td>
</tr>
<tr>
<td style="text-align:left;">
cocor
</td>
<td style="text-align:left;">
1.1.4
</td>
</tr>
<tr>
<td style="text-align:left;">
cowplot
</td>
<td style="text-align:left;">
1.1.1
</td>
</tr>
<tr>
<td style="text-align:left;">
dplyr
</td>
<td style="text-align:left;">
1.1.4
</td>
</tr>
<tr>
<td style="text-align:left;">
dygraphs
</td>
<td style="text-align:left;">
1.1.1.6
</td>
</tr>
<tr>
<td style="text-align:left;">
gganimate
</td>
<td style="text-align:left;">
1.0.8
</td>
</tr>
<tr>
<td style="text-align:left;">
ggplot2
</td>
<td style="text-align:left;">
3.4.4
</td>
</tr>
<tr>
<td style="text-align:left;">
ggthemes
</td>
<td style="text-align:left;">
5.0.0
</td>
</tr>
<tr>
<td style="text-align:left;">
gridExtra
</td>
<td style="text-align:left;">
2.3
</td>
</tr>
<tr>
<td style="text-align:left;">
htmltools
</td>
<td style="text-align:left;">
0.5.7
</td>
</tr>
<tr>
<td style="text-align:left;">
kableExtra
</td>
<td style="text-align:left;">
1.3.4
</td>
</tr>
<tr>
<td style="text-align:left;">
knitr
</td>
<td style="text-align:left;">
1.45
</td>
</tr>
<tr>
<td style="text-align:left;">
meta
</td>
<td style="text-align:left;">
6.5.0
</td>
</tr>
<tr>
<td style="text-align:left;">
metafor
</td>
<td style="text-align:left;">
4.4.0
</td>
</tr>
<tr>
<td style="text-align:left;">
metaviz
</td>
<td style="text-align:left;">
0.3.1
</td>
</tr>
<tr>
<td style="text-align:left;">
plotly
</td>
<td style="text-align:left;">
4.10.3
</td>
</tr>
<tr>
<td style="text-align:left;">
readxl
</td>
<td style="text-align:left;">
1.4.3
</td>
</tr>
<tr>
<td style="text-align:left;">
tibble
</td>
<td style="text-align:left;">
3.2.1
</td>
</tr>
<tr>
<td style="text-align:left;">
tidyverse
</td>
<td style="text-align:left;">
2.0.0
</td>
</tr>
<tr>
<td style="text-align:left;">
visNetwork
</td>
<td style="text-align:left;">
2.1.2
</td>
</tr>
<tr>
<td style="text-align:left;">
xaringan
</td>
<td style="text-align:left;">
0.28
</td>
</tr>
</tbody>
</table>

(“kable_styling”)<https://blog.csdn.net/renewallee/article/details/103352505>

## 流程图

PRISMA statement: 文献的纳入标准、结果综合的统计方法等 应该严格要求作者进行清楚地报告，以保证元分析的质量;而对元分析中单个 研究偏倚的评估、数据和分析过程可获得，则可以作为鼓励性的拔高标准。第 二、期刊在对元分析稿件的初步筛选时，可参性照元分析报告标准，对关键条目进 行核对，检查文章中是否包括了这些关键条目，以检查是该元分析是否满足元 分析报告标准的基本要求，决定是否将该稿件送审

``` r
prisma(found = 298,
       found_other = 4,
       no_dupes = 219, 
       screened = 219, 
       screen_exclusions = 163, 
       full_text = 56,
       full_text_exclusions = 29, 
       qualitative = 27, 
       quantitative = 25, height = 800, width = 400)
```

<div class="grViz html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-1" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"diagram":"digraph prisma {\n    node [shape=\"box\", fontsize = 10];\n    graph [splines=ortho, nodesep=1, dpi = 72]\n    a -> nodups;\n    b -> nodups;\n    a [label=\"Records identified through\ndatabase searching\n(n = 298)\"];\n    b [label=\"Additional records identified\nthrough other sources\n(n = 4)\"]\n    nodups -> incex;\n    nodups [label=\"Records after duplicates removed\n(n = 219)\"];\n    incex -> {ex; ft}\n    incex [label=\"Records screened\n(n = 219)\"];\n    ex [label=\"Records excluded\n(n = 163)\"];\n    {rank=same; incex ex}\n    ft -> {qual; ftex};\n    ft [label=\"Full-text articles assessed\nfor eligibility\n(n = 56)\"];\n    {rank=same; ft ftex}\n    ftex [label=\"Full-text articles excluded,\nwith reasons\n(n = 29)\"];\n    qual -> quant\n    qual [label=\"Studies included in qualitative synthesis\n(n = 27)\"];\n    quant [label=\"Studies included in\nquantitative synthesis\n(meta-analysis)\n(n = 25)\"];\n  }","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

## 定义参数

按自己的数据分析版本修改:

``` r
# y = Hedge's g  
# v = variance方差
# m1 = mean of condition 1  
# m2 = mean of condition 2  
# sd1 = sd of condition 1  标准差
# sd2 = sd of condition 2  
# sdi = sd of difference  
# n = number of subjects  
# F = F value  
# t = t value; two-tailed
```

## 定义函数

效应量需要提前计算好, 若效应量已在excel表中计算好,则可直接计算

## 数据导入(分析时)/数据录入(原始文献中的数据)

数据导入(分析时)/数据录入(原始文献中的数据): 或者说数据录入,因为不同的元分析具有相似但不同的**数据分析模版**, 相似在于基础元分析流程一致,不同在进阶分析的侧重点不同. 在数据录入时就必须要最好有明确或者大概的研究问题范围. 可以根据文献所含有的效应量不断调整.

``` r
library(readxl)
library(tidyverse)
library(kableExtra)
data <- read_excel("D:/桌面/Meta-analysis/Supplementary data/NY_Sup/Suicidal_meta_spreadsheet.xlsx", sheet = "effect_size_coding")

data <- read_excel("D:/桌面/Meta-analysis/Supplementary data/NY_Sup/Suicidal_meta_spreadsheet.xlsx", sheet = "effect_size_coding")

meta_data <- data %>%
  dplyr::select(Study_ID, effect_id, Description, type, g, var_g, everything()) %>%  
  mutate("abs_g" = abs(g),  #绝对值和置信区间
         "lbci" = g - (1.96*sqrt(var_g)), 
         "ubci" = g + (1.96*sqrt(var_g)))

meta_data$scoring <- recode_factor(as.factor(meta_data$scoring), raw = 0, 
                                   difference = 1, slope = 1) #数据类型转化

#上面是选择数据,下面是选择数据呈现形式——数据框
meta_data %>%
  dplyr::select(Study_ID, effect_id, Description, type, g, var_g, everything()) %>% 
  kable(align = "c") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
```

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:center;">
Study_ID
</th>
<th style="text-align:center;">
effect_id
</th>
<th style="text-align:center;">
Description
</th>
<th style="text-align:center;">
type
</th>
<th style="text-align:center;">
g
</th>
<th style="text-align:center;">
var_g
</th>
<th style="text-align:center;">
Published
</th>
<th style="text-align:center;">
Authors
</th>
<th style="text-align:center;">
Year
</th>
<th style="text-align:center;">
design
</th>
<th style="text-align:center;">
mean_age
</th>
<th style="text-align:center;">
suicide_measure
</th>
<th style="text-align:center;">
reference
</th>
<th style="text-align:center;">
erp_scoring
</th>
<th style="text-align:center;">
n_suicide
</th>
<th style="text-align:center;">
n_control
</th>
<th style="text-align:center;">
suicide_group
</th>
<th style="text-align:center;">
control_group
</th>
<th style="text-align:center;">
scoring
</th>
<th style="text-align:center;">
erp description
</th>
<th style="text-align:center;">
mean_suicide
</th>
<th style="text-align:center;">
mean_control
</th>
<th style="text-align:center;">
sd_suicide
</th>
<th style="text-align:center;">
sd_control
</th>
<th style="text-align:center;">
N
</th>
<th style="text-align:center;">
r
</th>
<th style="text-align:center;">
t
</th>
<th style="text-align:center;">
F
</th>
<th style="text-align:center;">
OR
</th>
<th style="text-align:center;">
d
</th>
<th style="text-align:center;">
var_d
</th>
<th style="text-align:center;">
J
</th>
<th style="text-align:center;">
abs_g
</th>
<th style="text-align:center;">
lbci
</th>
<th style="text-align:center;">
ubci
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0598161
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Reward View LPP Diff
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.030
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.06
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.0598161
</td>
<td style="text-align:center;">
-0.3361526
</td>
<td style="text-align:center;">
0.2165203
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0598161
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Reward View LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.030
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.06
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.0598161
</td>
<td style="text-align:center;">
-0.3361526
</td>
<td style="text-align:center;">
0.2165203
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.2193258
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Threat/Mutilation View LPP Diff
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.110
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.22
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.2193258
</td>
<td style="text-align:center;">
-0.4956623
</td>
<td style="text-align:center;">
0.0570106
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
4
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.1993871
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Threat/Mutilation View LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.100
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.20
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.1993871
</td>
<td style="text-align:center;">
-0.4757236
</td>
<td style="text-align:center;">
0.0769493
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0199387
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Neutral View LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
0.010
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.02
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.0199387
</td>
<td style="text-align:center;">
-0.2962752
</td>
<td style="text-align:center;">
0.2563978
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Threat/Mutilation Increase LPP Diff
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
0.000
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.00
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
-0.2763365
</td>
<td style="text-align:center;">
0.2763365
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.1196323
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Threat/Mutilation Increase LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.060
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.12
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.1196323
</td>
<td style="text-align:center;">
-0.3959687
</td>
<td style="text-align:center;">
0.1567042
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
8
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0996936
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Threat/Mutilation Decrease LPP Diff
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.050
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.10
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.0996936
</td>
<td style="text-align:center;">
-0.3760300
</td>
<td style="text-align:center;">
0.1766429
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.1794484
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Threat/Mutilation Decrease LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.090
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.18
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.1794484
</td>
<td style="text-align:center;">
-0.4557849
</td>
<td style="text-align:center;">
0.0968880
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.2791420
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Reward Increase LPP Diff
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.140
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.28
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.2791420
</td>
<td style="text-align:center;">
-0.5554784
</td>
<td style="text-align:center;">
-0.0028055
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
11
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.2592033
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Reward Increase LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.130
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.26
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.2592033
</td>
<td style="text-align:center;">
-0.5355397
</td>
<td style="text-align:center;">
0.0171332
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Reward decrease LPP Diff
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
0.000
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.00
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
-0.2763365
</td>
<td style="text-align:center;">
0.2763365
</td>
</tr>
<tr>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
13
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0598161
</td>
<td style="text-align:center;">
0.0198776
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019b
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
35.29
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Reward decrease LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
247
</td>
<td style="text-align:center;">
-0.030
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.06
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9969356
</td>
<td style="text-align:center;">
0.0598161
</td>
<td style="text-align:center;">
-0.3361526
</td>
<td style="text-align:center;">
0.2165203
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
N2
</td>
<td style="text-align:center;">
0.2273764
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Go No-Go N2 Diff
</td>
<td style="text-align:center;">
0.380000
</td>
<td style="text-align:center;">
-0.180000
</td>
<td style="text-align:center;">
1.900000
</td>
<td style="text-align:center;">
2.610000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.23
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.2273764
</td>
<td style="text-align:center;">
-0.2852756
</td>
<td style="text-align:center;">
0.7400285
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
15
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
N2
</td>
<td style="text-align:center;">
0.2076046
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
No-Go N2
</td>
<td style="text-align:center;">
0.680000
</td>
<td style="text-align:center;">
-0.070000
</td>
<td style="text-align:center;">
3.690000
</td>
<td style="text-align:center;">
3.630000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.21
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.2076046
</td>
<td style="text-align:center;">
-0.3050475
</td>
<td style="text-align:center;">
0.7202566
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
16
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
N2
</td>
<td style="text-align:center;">
0.0692015
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Go N2
</td>
<td style="text-align:center;">
0.710000
</td>
<td style="text-align:center;">
0.470000
</td>
<td style="text-align:center;">
3.700000
</td>
<td style="text-align:center;">
3.510000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.0692015
</td>
<td style="text-align:center;">
-0.4434505
</td>
<td style="text-align:center;">
0.5818536
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
17
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.2174905
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Go No-Go P3 Diff
</td>
<td style="text-align:center;">
0.560000
</td>
<td style="text-align:center;">
-0.270000
</td>
<td style="text-align:center;">
4.410000
</td>
<td style="text-align:center;">
3.400000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.22
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.2174905
</td>
<td style="text-align:center;">
-0.2951615
</td>
<td style="text-align:center;">
0.7301425
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
18
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0296578
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
No-Go P3
</td>
<td style="text-align:center;">
9.350000
</td>
<td style="text-align:center;">
9.520000
</td>
<td style="text-align:center;">
5.850000
</td>
<td style="text-align:center;">
6.020000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.03
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.0296578
</td>
<td style="text-align:center;">
-0.5423098
</td>
<td style="text-align:center;">
0.4829942
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
19
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.2174905
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Go P3
</td>
<td style="text-align:center;">
3.510000
</td>
<td style="text-align:center;">
4.460000
</td>
<td style="text-align:center;">
3.770000
</td>
<td style="text-align:center;">
4.640000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.22
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.2174905
</td>
<td style="text-align:center;">
-0.7301425
</td>
<td style="text-align:center;">
0.2951615
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
N2
</td>
<td style="text-align:center;">
0.6425856
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Latent Go No-Go N2 Diff
</td>
<td style="text-align:center;">
0.710000
</td>
<td style="text-align:center;">
-0.340000
</td>
<td style="text-align:center;">
1.300000
</td>
<td style="text-align:center;">
1.730000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.65
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.6425856
</td>
<td style="text-align:center;">
0.1299335
</td>
<td style="text-align:center;">
1.1552376
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
21
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
N2
</td>
<td style="text-align:center;">
0.6623574
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Latent No-Go N2
</td>
<td style="text-align:center;">
1.870000
</td>
<td style="text-align:center;">
0.120000
</td>
<td style="text-align:center;">
2.390000
</td>
<td style="text-align:center;">
2.710000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.67
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.6623574
</td>
<td style="text-align:center;">
0.1497054
</td>
<td style="text-align:center;">
1.1750095
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
N2
</td>
<td style="text-align:center;">
0.3262357
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Latent Go N2
</td>
<td style="text-align:center;">
1.980000
</td>
<td style="text-align:center;">
1.150000
</td>
<td style="text-align:center;">
2.170000
</td>
<td style="text-align:center;">
2.710000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.33
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.3262357
</td>
<td style="text-align:center;">
-0.1864163
</td>
<td style="text-align:center;">
0.8388878
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1977186
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Latent Go No-Go P3 Diff
</td>
<td style="text-align:center;">
0.430000
</td>
<td style="text-align:center;">
-0.200000
</td>
<td style="text-align:center;">
3.180000
</td>
<td style="text-align:center;">
3.250000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.20
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.1977186
</td>
<td style="text-align:center;">
-0.3149334
</td>
<td style="text-align:center;">
0.7103707
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1087452
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Latent No-Go P3
</td>
<td style="text-align:center;">
5.610000
</td>
<td style="text-align:center;">
6.250000
</td>
<td style="text-align:center;">
5.440000
</td>
<td style="text-align:center;">
5.670000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.11
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.1087452
</td>
<td style="text-align:center;">
-0.6213973
</td>
<td style="text-align:center;">
0.4039068
</td>
</tr>
<tr>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.2768061
</td>
<td style="text-align:center;">
0.0684121
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Albanese et al. 
</td>
<td style="text-align:center;">
2019a
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
36.63
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
aop
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Latent Go P3
</td>
<td style="text-align:center;">
1.040000
</td>
<td style="text-align:center;">
2.320000
</td>
<td style="text-align:center;">
3.870000
</td>
<td style="text-align:center;">
4.830000
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.28
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.2768061
</td>
<td style="text-align:center;">
-0.7894581
</td>
<td style="text-align:center;">
0.2358460
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
26
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P2
</td>
<td style="text-align:center;">
-2.9680000
</td>
<td style="text-align:center;">
0.2819634
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
P2 Reward
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.350
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-3.01
</td>
<td style="text-align:center;">
0.29
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
2.9680000
</td>
<td style="text-align:center;">
-4.0087645
</td>
<td style="text-align:center;">
-1.9272355
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P2
</td>
<td style="text-align:center;">
0.6902326
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
P2 Punishment
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.330
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.70
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.6902326
</td>
<td style="text-align:center;">
0.1435963
</td>
<td style="text-align:center;">
1.2368689
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
28
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P2
</td>
<td style="text-align:center;">
0.7395349
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
P2 Neutral
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.350
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.75
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.7395349
</td>
<td style="text-align:center;">
0.1928986
</td>
<td style="text-align:center;">
1.2861712
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
29
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4634419
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cue P3 Reward
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.230
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.47
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.4634419
</td>
<td style="text-align:center;">
-0.0831944
</td>
<td style="text-align:center;">
1.0100782
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.5127442
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cue P3 Punishment
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.250
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.52
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.5127442
</td>
<td style="text-align:center;">
-0.0338921
</td>
<td style="text-align:center;">
1.0593805
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
31
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.5324651
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cue P3 Neutral
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.260
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.54
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.5324651
</td>
<td style="text-align:center;">
-0.0141712
</td>
<td style="text-align:center;">
1.0791014
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
32
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
-0.1774884
</td>
<td style="text-align:center;">
0.0680601
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
CNV Reward
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
-0.090
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.18
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.1774884
</td>
<td style="text-align:center;">
-0.6888198
</td>
<td style="text-align:center;">
0.3338431
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
-0.0394419
</td>
<td style="text-align:center;">
0.0680601
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
CNV Punishment
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
-0.020
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.04
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.0394419
</td>
<td style="text-align:center;">
-0.5507733
</td>
<td style="text-align:center;">
0.4718896
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
34
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
-0.3845581
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
CNV Neutral
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
-0.190
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.39
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.3845581
</td>
<td style="text-align:center;">
-0.9311944
</td>
<td style="text-align:center;">
0.1620782
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
35
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4437209
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Target P3 Reward
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.220
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.45
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.4437209
</td>
<td style="text-align:center;">
-0.1029154
</td>
<td style="text-align:center;">
0.9903572
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
36
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.2760930
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Target P3 Punishment
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
-0.140
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.28
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.2760930
</td>
<td style="text-align:center;">
-0.8227293
</td>
<td style="text-align:center;">
0.2705433
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
37
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.5719070
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Target P3 Neutral
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.280
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.58
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.5719070
</td>
<td style="text-align:center;">
0.0252707
</td>
<td style="text-align:center;">
1.1185433
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
38
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.1577674
</td>
<td style="text-align:center;">
0.0680601
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive Condition Reward RewP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.080
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.16
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.1577674
</td>
<td style="text-align:center;">
-0.3535640
</td>
<td style="text-align:center;">
0.6690989
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
39
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.1577674
</td>
<td style="text-align:center;">
0.0680601
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive Condition Punishment RewP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
-0.080
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.16
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.1577674
</td>
<td style="text-align:center;">
-0.6690989
</td>
<td style="text-align:center;">
0.3535640
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
40
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.1774884
</td>
<td style="text-align:center;">
0.0680601
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive Condition Neutral RewP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
-0.090
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.18
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.1774884
</td>
<td style="text-align:center;">
-0.6888198
</td>
<td style="text-align:center;">
0.3338431
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
41
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
0.0680601
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative Condition Reward RewP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.000
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.00
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
-0.5113314
</td>
<td style="text-align:center;">
0.5113314
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
42
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.0986047
</td>
<td style="text-align:center;">
0.0680601
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative Condition Punishment RewP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
-0.050
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.10
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.0986047
</td>
<td style="text-align:center;">
-0.6099361
</td>
<td style="text-align:center;">
0.4127268
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
43
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.0394419
</td>
<td style="text-align:center;">
0.0680601
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative Condition Neutral RewP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.020
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.0394419
</td>
<td style="text-align:center;">
-0.4718896
</td>
<td style="text-align:center;">
0.5507733
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
44
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.6902326
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive Condition Reward Feedback P3
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.330
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.70
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.6902326
</td>
<td style="text-align:center;">
0.1435963
</td>
<td style="text-align:center;">
1.2368689
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
45
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.8381395
</td>
<td style="text-align:center;">
0.0875059
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive Condition Punishment Feedback P3
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.390
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.85
</td>
<td style="text-align:center;">
0.09
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.8381395
</td>
<td style="text-align:center;">
0.2583442
</td>
<td style="text-align:center;">
1.4179349
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4831628
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive Condition Neutral Feedback P3
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.240
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.49
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.4831628
</td>
<td style="text-align:center;">
-0.0634735
</td>
<td style="text-align:center;">
1.0297991
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
47
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.5719070
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative Condition Reward Feedback P3
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.280
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.58
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.5719070
</td>
<td style="text-align:center;">
0.0252707
</td>
<td style="text-align:center;">
1.1185433
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
48
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4831628
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative Condition Punishment Feedback P3
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.240
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.49
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.4831628
</td>
<td style="text-align:center;">
-0.0634735
</td>
<td style="text-align:center;">
1.0297991
</td>
</tr>
<tr>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
49
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4634419
</td>
<td style="text-align:center;">
0.0777830
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Song et al. 
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
22.73
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative Condition Neutral Feedback P3
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
0.230
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.47
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9860465
</td>
<td style="text-align:center;">
0.4634419
</td>
<td style="text-align:center;">
-0.0831944
</td>
<td style="text-align:center;">
1.0100782
</td>
</tr>
<tr>
<td style="text-align:center;">
4
</td>
<td style="text-align:center;">
50
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.6031461
</td>
<td style="text-align:center;">
0.0684358
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tsypes, Owens, & Gibb
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
9.50
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Difference RewP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
69
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
5.63
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.61
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9887640
</td>
<td style="text-align:center;">
0.6031461
</td>
<td style="text-align:center;">
-1.1158867
</td>
<td style="text-align:center;">
-0.0904054
</td>
</tr>
<tr>
<td style="text-align:center;">
4
</td>
<td style="text-align:center;">
51
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.5438202
</td>
<td style="text-align:center;">
0.0684358
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tsypes, Owens, & Gibb
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
9.50
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Loss RewP
</td>
<td style="text-align:center;">
4.980000
</td>
<td style="text-align:center;">
1.620000
</td>
<td style="text-align:center;">
6.600000
</td>
<td style="text-align:center;">
5.880000
</td>
<td style="text-align:center;">
69
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.55
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9887640
</td>
<td style="text-align:center;">
0.5438202
</td>
<td style="text-align:center;">
0.0310796
</td>
<td style="text-align:center;">
1.0565609
</td>
</tr>
<tr>
<td style="text-align:center;">
4
</td>
<td style="text-align:center;">
52
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
0.0684358
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tsypes, Owens, & Gibb
</td>
<td style="text-align:center;">
2019
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
9.50
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
46
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Win RewP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
69
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.00
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.00
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9887640
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
-0.5127407
</td>
<td style="text-align:center;">
0.5127407
</td>
</tr>
<tr>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
53
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
1.2551724
</td>
<td style="text-align:center;">
0.1864447
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2018
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
14.90
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Environment P3 difference
</td>
<td style="text-align:center;">
4.040000
</td>
<td style="text-align:center;">
1.540000
</td>
<td style="text-align:center;">
2.260000
</td>
<td style="text-align:center;">
1.510000
</td>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
1.30
</td>
<td style="text-align:center;">
0.20
</td>
<td style="text-align:center;">
0.9655172
</td>
<td style="text-align:center;">
1.2551724
</td>
<td style="text-align:center;">
0.4088592
</td>
<td style="text-align:center;">
2.1014856
</td>
</tr>
<tr>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
54
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.5600000
</td>
<td style="text-align:center;">
0.1584780
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2018
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
14.90
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
White Noise P3 difference
</td>
<td style="text-align:center;">
3.320000
</td>
<td style="text-align:center;">
1.820000
</td>
<td style="text-align:center;">
2.910000
</td>
<td style="text-align:center;">
2.200000
</td>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.58
</td>
<td style="text-align:center;">
0.17
</td>
<td style="text-align:center;">
0.9655172
</td>
<td style="text-align:center;">
0.5600000
</td>
<td style="text-align:center;">
-0.2202622
</td>
<td style="text-align:center;">
1.3402622
</td>
</tr>
<tr>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
55
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1834483
</td>
<td style="text-align:center;">
0.1584780
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2018
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
14.90
</td>
<td style="text-align:center;">
h
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Increment P3 difference
</td>
<td style="text-align:center;">
0.020000
</td>
<td style="text-align:center;">
-0.450000
</td>
<td style="text-align:center;">
1.490000
</td>
<td style="text-align:center;">
3.220000
</td>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.19
</td>
<td style="text-align:center;">
0.17
</td>
<td style="text-align:center;">
0.9655172
</td>
<td style="text-align:center;">
0.1834483
</td>
<td style="text-align:center;">
-0.5968139
</td>
<td style="text-align:center;">
0.9637105
</td>
</tr>
<tr>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
56
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3475862
</td>
<td style="text-align:center;">
0.1584780
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2018
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
14.90
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Decrement P3 difference
</td>
<td style="text-align:center;">
0.070000
</td>
<td style="text-align:center;">
-0.550000
</td>
<td style="text-align:center;">
1.880000
</td>
<td style="text-align:center;">
1.590000
</td>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.36
</td>
<td style="text-align:center;">
0.17
</td>
<td style="text-align:center;">
0.9655172
</td>
<td style="text-align:center;">
0.3475862
</td>
<td style="text-align:center;">
-0.4326760
</td>
<td style="text-align:center;">
1.1278484
</td>
</tr>
<tr>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
57
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.7724138
</td>
<td style="text-align:center;">
0.1678002
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2018
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
14.90
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Frequency P3 difference
</td>
<td style="text-align:center;">
0.180000
</td>
<td style="text-align:center;">
-1.340000
</td>
<td style="text-align:center;">
1.140000
</td>
<td style="text-align:center;">
2.450000
</td>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.80
</td>
<td style="text-align:center;">
0.18
</td>
<td style="text-align:center;">
0.9655172
</td>
<td style="text-align:center;">
0.7724138
</td>
<td style="text-align:center;">
-0.0304694
</td>
<td style="text-align:center;">
1.5752970
</td>
</tr>
<tr>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
58
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.5696552
</td>
<td style="text-align:center;">
0.1584780
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2018
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
14.90
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Duration P3 difference
</td>
<td style="text-align:center;">
0.880000
</td>
<td style="text-align:center;">
-0.350000
</td>
<td style="text-align:center;">
1.560000
</td>
<td style="text-align:center;">
2.530000
</td>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.59
</td>
<td style="text-align:center;">
0.17
</td>
<td style="text-align:center;">
0.9655172
</td>
<td style="text-align:center;">
0.5696552
</td>
<td style="text-align:center;">
-0.2106070
</td>
<td style="text-align:center;">
1.3499174
</td>
</tr>
<tr>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
59
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.2093233
</td>
<td style="text-align:center;">
0.0198713
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Weinberg et al. 
</td>
<td style="text-align:center;">
2017
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
41.18
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
83
</td>
<td style="text-align:center;">
152
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive LPP
</td>
<td style="text-align:center;">
2.980000
</td>
<td style="text-align:center;">
3.990000
</td>
<td style="text-align:center;">
4.580000
</td>
<td style="text-align:center;">
4.810000
</td>
<td style="text-align:center;">
235
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.21
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9967777
</td>
<td style="text-align:center;">
0.2093233
</td>
<td style="text-align:center;">
-0.4856160
</td>
<td style="text-align:center;">
0.0669694
</td>
</tr>
<tr>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
60
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.1893878
</td>
<td style="text-align:center;">
0.0198713
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Weinberg et al. 
</td>
<td style="text-align:center;">
2017
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
41.18
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
83
</td>
<td style="text-align:center;">
152
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Neutral LPP
</td>
<td style="text-align:center;">
-0.640000
</td>
<td style="text-align:center;">
0.080000
</td>
<td style="text-align:center;">
3.770000
</td>
<td style="text-align:center;">
3.930000
</td>
<td style="text-align:center;">
235
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.19
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9967777
</td>
<td style="text-align:center;">
0.1893878
</td>
<td style="text-align:center;">
-0.4656804
</td>
<td style="text-align:center;">
0.0869049
</td>
</tr>
<tr>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
61
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.4784533
</td>
<td style="text-align:center;">
0.0198713
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Weinberg et al. 
</td>
<td style="text-align:center;">
2017
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
41.18
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
83
</td>
<td style="text-align:center;">
152
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative LPP
</td>
<td style="text-align:center;">
3.490000
</td>
<td style="text-align:center;">
6.040000
</td>
<td style="text-align:center;">
5.250000
</td>
<td style="text-align:center;">
5.430000
</td>
<td style="text-align:center;">
235
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.48
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9967777
</td>
<td style="text-align:center;">
0.4784533
</td>
<td style="text-align:center;">
-0.7547459
</td>
<td style="text-align:center;">
-0.2021606
</td>
</tr>
<tr>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
62
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.5695808
</td>
<td style="text-align:center;">
0.0964395
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Baik et al. 
</td>
<td style="text-align:center;">
2018
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
42.45
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Invalid suicide-relevant words P3
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
44
</td>
<td style="text-align:center;">
-0.280
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.58
</td>
<td style="text-align:center;">
0.10
</td>
<td style="text-align:center;">
0.9820359
</td>
<td style="text-align:center;">
0.5695808
</td>
<td style="text-align:center;">
-1.1782530
</td>
<td style="text-align:center;">
0.0390913
</td>
</tr>
<tr>
<td style="text-align:center;">
8
</td>
<td style="text-align:center;">
63
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.4281545
</td>
<td style="text-align:center;">
0.0198287
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Weinberg et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
42.93
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
177
</td>
<td style="text-align:center;">
-0.210
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.43
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9957082
</td>
<td style="text-align:center;">
0.4281545
</td>
<td style="text-align:center;">
-0.7041507
</td>
<td style="text-align:center;">
-0.1521583
</td>
</tr>
<tr>
<td style="text-align:center;">
8
</td>
<td style="text-align:center;">
64
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.1991416
</td>
<td style="text-align:center;">
0.0198287
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Weinberg et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
42.93
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Neutral LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
177
</td>
<td style="text-align:center;">
-0.100
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.20
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9957082
</td>
<td style="text-align:center;">
0.1991416
</td>
<td style="text-align:center;">
-0.4751379
</td>
<td style="text-align:center;">
0.0768546
</td>
</tr>
<tr>
<td style="text-align:center;">
8
</td>
<td style="text-align:center;">
65
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.4480687
</td>
<td style="text-align:center;">
0.0198287
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Weinberg et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
42.93
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative LPP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
177
</td>
<td style="text-align:center;">
-0.220
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.45
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9957082
</td>
<td style="text-align:center;">
0.4480687
</td>
<td style="text-align:center;">
-0.7240649
</td>
<td style="text-align:center;">
-0.1720725
</td>
</tr>
<tr>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
66
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.4292683
</td>
<td style="text-align:center;">
0.1427722
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kudinova et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
19.76
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Neutral View LPP
</td>
<td style="text-align:center;">
-1.630000
</td>
<td style="text-align:center;">
1.300000
</td>
<td style="text-align:center;">
5.900000
</td>
<td style="text-align:center;">
6.950000
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.44
</td>
<td style="text-align:center;">
0.15
</td>
<td style="text-align:center;">
0.9756098
</td>
<td style="text-align:center;">
0.4292683
</td>
<td style="text-align:center;">
-1.1698583
</td>
<td style="text-align:center;">
0.3113217
</td>
</tr>
<tr>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
67
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.3317073
</td>
<td style="text-align:center;">
0.1427722
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kudinova et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
19.76
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive View LPP
</td>
<td style="text-align:center;">
6.540000
</td>
<td style="text-align:center;">
3.600000
</td>
<td style="text-align:center;">
11.520000
</td>
<td style="text-align:center;">
7.200000
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.34
</td>
<td style="text-align:center;">
0.15
</td>
<td style="text-align:center;">
0.9756098
</td>
<td style="text-align:center;">
0.3317073
</td>
<td style="text-align:center;">
-0.4088827
</td>
<td style="text-align:center;">
1.0722973
</td>
</tr>
<tr>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.5658537
</td>
<td style="text-align:center;">
0.1427722
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kudinova et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
19.76
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative View LPP
</td>
<td style="text-align:center;">
0.320000
</td>
<td style="text-align:center;">
6.340000
</td>
<td style="text-align:center;">
11.800000
</td>
<td style="text-align:center;">
9.640000
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.58
</td>
<td style="text-align:center;">
0.15
</td>
<td style="text-align:center;">
0.9756098
</td>
<td style="text-align:center;">
0.5658537
</td>
<td style="text-align:center;">
-1.3064436
</td>
<td style="text-align:center;">
0.1747363
</td>
</tr>
<tr>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
69
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.2536585
</td>
<td style="text-align:center;">
0.1332540
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kudinova et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
19.76
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Neutral Increase LPP
</td>
<td style="text-align:center;">
2.400000
</td>
<td style="text-align:center;">
0.650000
</td>
<td style="text-align:center;">
5.140000
</td>
<td style="text-align:center;">
7.130000
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.26
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.9756098
</td>
<td style="text-align:center;">
0.2536585
</td>
<td style="text-align:center;">
-0.4618194
</td>
<td style="text-align:center;">
0.9691364
</td>
</tr>
<tr>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
70
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.1268293
</td>
<td style="text-align:center;">
0.1332540
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kudinova et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
19.76
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive Increase LPP
</td>
<td style="text-align:center;">
7.500000
</td>
<td style="text-align:center;">
8.100000
</td>
<td style="text-align:center;">
7.620000
</td>
<td style="text-align:center;">
2.540000
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.13
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.9756098
</td>
<td style="text-align:center;">
0.1268293
</td>
<td style="text-align:center;">
-0.8423072
</td>
<td style="text-align:center;">
0.5886486
</td>
</tr>
<tr>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
71
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.3024390
</td>
<td style="text-align:center;">
0.1332540
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kudinova et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
19.76
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative Increase LPP
</td>
<td style="text-align:center;">
8.400000
</td>
<td style="text-align:center;">
5.700000
</td>
<td style="text-align:center;">
12.300000
</td>
<td style="text-align:center;">
6.500000
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.31
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.9756098
</td>
<td style="text-align:center;">
0.3024390
</td>
<td style="text-align:center;">
-0.4130389
</td>
<td style="text-align:center;">
1.0179169
</td>
</tr>
<tr>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
72
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.3804878
</td>
<td style="text-align:center;">
0.1427722
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kudinova et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
19.76
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Neutral Decrease LPP
</td>
<td style="text-align:center;">
-1.150000
</td>
<td style="text-align:center;">
2.030000
</td>
<td style="text-align:center;">
12.800000
</td>
<td style="text-align:center;">
5.120000
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.39
</td>
<td style="text-align:center;">
0.15
</td>
<td style="text-align:center;">
0.9756098
</td>
<td style="text-align:center;">
0.3804878
</td>
<td style="text-align:center;">
-1.1210778
</td>
<td style="text-align:center;">
0.3601022
</td>
</tr>
<tr>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
73
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.0097561
</td>
<td style="text-align:center;">
0.1332540
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kudinova et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
19.76
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Positive Decrease LPP
</td>
<td style="text-align:center;">
6.540000
</td>
<td style="text-align:center;">
6.430000
</td>
<td style="text-align:center;">
12.600000
</td>
<td style="text-align:center;">
8.600000
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.01
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.9756098
</td>
<td style="text-align:center;">
0.0097561
</td>
<td style="text-align:center;">
-0.7057218
</td>
<td style="text-align:center;">
0.7252340
</td>
</tr>
<tr>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
74
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.8585366
</td>
<td style="text-align:center;">
0.1522903
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kudinova et al. 
</td>
<td style="text-align:center;">
2016
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
19.76
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Negative Decrease LPP
</td>
<td style="text-align:center;">
11.500000
</td>
<td style="text-align:center;">
2.800000
</td>
<td style="text-align:center;">
11.000000
</td>
<td style="text-align:center;">
9.340000
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.88
</td>
<td style="text-align:center;">
0.16
</td>
<td style="text-align:center;">
0.9756098
</td>
<td style="text-align:center;">
0.8585366
</td>
<td style="text-align:center;">
0.0936585
</td>
<td style="text-align:center;">
1.6234146
</td>
</tr>
<tr>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
75
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
0.6374194
</td>
<td style="text-align:center;">
0.1057831
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Marsic et al. 
</td>
<td style="text-align:center;">
2015
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
20.69
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
41
</td>
<td style="text-align:center;">
0.310
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.65
</td>
<td style="text-align:center;">
0.11
</td>
<td style="text-align:center;">
0.9806452
</td>
<td style="text-align:center;">
0.6374194
</td>
<td style="text-align:center;">
-0.0000573
</td>
<td style="text-align:center;">
1.2748960
</td>
</tr>
<tr>
<td style="text-align:center;">
11
</td>
<td style="text-align:center;">
76
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-0.2254305
</td>
<td style="text-align:center;">
0.0960660
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Graßnickel et al. 
</td>
<td style="text-align:center;">
2015
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
43.20
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
0.268200
</td>
<td style="text-align:center;">
0.328700
</td>
<td style="text-align:center;">
0.280000
</td>
<td style="text-align:center;">
0.240000
</td>
<td style="text-align:center;">
40
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.23
</td>
<td style="text-align:center;">
0.10
</td>
<td style="text-align:center;">
0.9801325
</td>
<td style="text-align:center;">
0.2254305
</td>
<td style="text-align:center;">
-0.8329229
</td>
<td style="text-align:center;">
0.3820619
</td>
</tr>
<tr>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
77
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-0.8275862
</td>
<td style="text-align:center;">
0.0873596
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Lee et al. 
</td>
<td style="text-align:center;">
2014
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
39.55
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
53
</td>
<td style="text-align:center;">
-0.387
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.84
</td>
<td style="text-align:center;">
0.09
</td>
<td style="text-align:center;">
0.9852217
</td>
<td style="text-align:center;">
0.8275862
</td>
<td style="text-align:center;">
-1.4068966
</td>
<td style="text-align:center;">
-0.2482759
</td>
</tr>
<tr>
<td style="text-align:center;">
12
</td>
<td style="text-align:center;">
78
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-0.0098859
</td>
<td style="text-align:center;">
0.0586390
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Lee et al. 
</td>
<td style="text-align:center;">
2014
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
44.18
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
68
</td>
<td style="text-align:center;">
-0.012
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.01
</td>
<td style="text-align:center;">
0.06
</td>
<td style="text-align:center;">
0.9885932
</td>
<td style="text-align:center;">
0.0098859
</td>
<td style="text-align:center;">
-0.4845095
</td>
<td style="text-align:center;">
0.4647376
</td>
</tr>
<tr>
<td style="text-align:center;">
13
</td>
<td style="text-align:center;">
79
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
0.6853147
</td>
<td style="text-align:center;">
0.1054330
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Kim & Park
</td>
<td style="text-align:center;">
2013
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
40.79
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
17
</td>
<td style="text-align:center;">
21
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
1.450000
</td>
<td style="text-align:center;">
0.900000
</td>
<td style="text-align:center;">
0.920000
</td>
<td style="text-align:center;">
0.650000
</td>
<td style="text-align:center;">
38
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.70
</td>
<td style="text-align:center;">
0.11
</td>
<td style="text-align:center;">
0.9790210
</td>
<td style="text-align:center;">
0.6853147
</td>
<td style="text-align:center;">
0.0488938
</td>
<td style="text-align:center;">
1.3217356
</td>
</tr>
<tr>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
80
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
0.1591474
</td>
<td style="text-align:center;">
0.0989371
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Min et al. 
</td>
<td style="text-align:center;">
2012
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
46.13
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
11
</td>
<td style="text-align:center;">
130
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
1.010000
</td>
<td style="text-align:center;">
0.890000
</td>
<td style="text-align:center;">
0.560000
</td>
<td style="text-align:center;">
0.750000
</td>
<td style="text-align:center;">
143
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.16
</td>
<td style="text-align:center;">
0.10
</td>
<td style="text-align:center;">
0.9946714
</td>
<td style="text-align:center;">
0.1591474
</td>
<td style="text-align:center;">
-0.4573563
</td>
<td style="text-align:center;">
0.7756511
</td>
</tr>
<tr>
<td style="text-align:center;">
15
</td>
<td style="text-align:center;">
81
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
0.1372903
</td>
<td style="text-align:center;">
0.0961665
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Marsic
</td>
<td style="text-align:center;">
2012
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
25.15
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
41
</td>
<td style="text-align:center;">
0.070
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.10
</td>
<td style="text-align:center;">
0.9806452
</td>
<td style="text-align:center;">
0.1372903
</td>
<td style="text-align:center;">
-0.4705198
</td>
<td style="text-align:center;">
0.7451005
</td>
</tr>
<tr>
<td style="text-align:center;">
15
</td>
<td style="text-align:center;">
82
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
0.3138065
</td>
<td style="text-align:center;">
0.0961665
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Marsic
</td>
<td style="text-align:center;">
2012
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
25.15
</td>
<td style="text-align:center;">
self-report
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
41
</td>
<td style="text-align:center;">
0.160
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.32
</td>
<td style="text-align:center;">
0.10
</td>
<td style="text-align:center;">
0.9806452
</td>
<td style="text-align:center;">
0.3138065
</td>
<td style="text-align:center;">
-0.2940037
</td>
<td style="text-align:center;">
0.9216166
</td>
</tr>
<tr>
<td style="text-align:center;">
16
</td>
<td style="text-align:center;">
83
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
3.5729843
</td>
<td style="text-align:center;">
0.2131433
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Jandl, Steyer, & Kaschka
</td>
<td style="text-align:center;">
2010
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
48.32
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
average
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
32
</td>
<td style="text-align:center;">
18
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
First half second half P3 diff
</td>
<td style="text-align:center;">
2.000000
</td>
<td style="text-align:center;">
0.197000
</td>
<td style="text-align:center;">
0.510000
</td>
<td style="text-align:center;">
0.470000
</td>
<td style="text-align:center;">
50
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
3.63
</td>
<td style="text-align:center;">
0.22
</td>
<td style="text-align:center;">
0.9842932
</td>
<td style="text-align:center;">
3.5729843
</td>
<td style="text-align:center;">
2.6681024
</td>
<td style="text-align:center;">
4.4778662
</td>
</tr>
<tr>
<td style="text-align:center;">
16
</td>
<td style="text-align:center;">
84
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1476440
</td>
<td style="text-align:center;">
0.0871950
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Jandl, Steyer, & Kaschka
</td>
<td style="text-align:center;">
2010
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
48.32
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
average
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
32
</td>
<td style="text-align:center;">
18
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Novel First half second half P3 diff
</td>
<td style="text-align:center;">
-0.100000
</td>
<td style="text-align:center;">
-0.576000
</td>
<td style="text-align:center;">
3.260000
</td>
<td style="text-align:center;">
3.130000
</td>
<td style="text-align:center;">
50
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.15
</td>
<td style="text-align:center;">
0.09
</td>
<td style="text-align:center;">
0.9842932
</td>
<td style="text-align:center;">
0.1476440
</td>
<td style="text-align:center;">
-0.4311204
</td>
<td style="text-align:center;">
0.7264084
</td>
</tr>
<tr>
<td style="text-align:center;">
16
</td>
<td style="text-align:center;">
85
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1870157
</td>
<td style="text-align:center;">
0.0871950
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Jandl, Steyer, & Kaschka
</td>
<td style="text-align:center;">
2010
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
48.32
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
average
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
32
</td>
<td style="text-align:center;">
18
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Target First Half second half P3 diff
</td>
<td style="text-align:center;">
0.390000
</td>
<td style="text-align:center;">
-0.147000
</td>
<td style="text-align:center;">
3.140000
</td>
<td style="text-align:center;">
2.262000
</td>
<td style="text-align:center;">
50
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.19
</td>
<td style="text-align:center;">
0.09
</td>
<td style="text-align:center;">
0.9842932
</td>
<td style="text-align:center;">
0.1870157
</td>
<td style="text-align:center;">
-0.3917487
</td>
<td style="text-align:center;">
0.7657801
</td>
</tr>
<tr>
<td style="text-align:center;">
17
</td>
<td style="text-align:center;">
86
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
0.6522353
</td>
<td style="text-align:center;">
0.0878948
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Chen et al. 
</td>
<td style="text-align:center;">
2005
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
27.40
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
16
</td>
<td style="text-align:center;">
50
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
1.690000
</td>
<td style="text-align:center;">
0.910000
</td>
<td style="text-align:center;">
1.420000
</td>
<td style="text-align:center;">
1.100000
</td>
<td style="text-align:center;">
66
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.66
</td>
<td style="text-align:center;">
0.09
</td>
<td style="text-align:center;">
0.9882353
</td>
<td style="text-align:center;">
0.6522353
</td>
<td style="text-align:center;">
0.0711529
</td>
<td style="text-align:center;">
1.2333176
</td>
</tr>
<tr>
<td style="text-align:center;">
17
</td>
<td style="text-align:center;">
87
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.8301176
</td>
<td style="text-align:center;">
0.0878948
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Chen et al. 
</td>
<td style="text-align:center;">
2005
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
27.40
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
16
</td>
<td style="text-align:center;">
50
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Fz P3
</td>
<td style="text-align:center;">
6.540000
</td>
<td style="text-align:center;">
4.180000
</td>
<td style="text-align:center;">
3.010000
</td>
<td style="text-align:center;">
2.750000
</td>
<td style="text-align:center;">
66
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.84
</td>
<td style="text-align:center;">
0.09
</td>
<td style="text-align:center;">
0.9882353
</td>
<td style="text-align:center;">
0.8301176
</td>
<td style="text-align:center;">
0.2490353
</td>
<td style="text-align:center;">
1.4112000
</td>
</tr>
<tr>
<td style="text-align:center;">
17
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.5534118
</td>
<td style="text-align:center;">
0.0781287
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Chen et al. 
</td>
<td style="text-align:center;">
2005
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
27.40
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
16
</td>
<td style="text-align:center;">
50
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz P3
</td>
<td style="text-align:center;">
6.390000
</td>
<td style="text-align:center;">
4.710000
</td>
<td style="text-align:center;">
2.680000
</td>
<td style="text-align:center;">
3.070000
</td>
<td style="text-align:center;">
66
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.56
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9882353
</td>
<td style="text-align:center;">
0.5534118
</td>
<td style="text-align:center;">
0.0055621
</td>
<td style="text-align:center;">
1.1012615
</td>
</tr>
<tr>
<td style="text-align:center;">
17
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4150588
</td>
<td style="text-align:center;">
0.0781287
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Chen et al. 
</td>
<td style="text-align:center;">
2005
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
27.40
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
16
</td>
<td style="text-align:center;">
50
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz P3
</td>
<td style="text-align:center;">
5.750000
</td>
<td style="text-align:center;">
4.710000
</td>
<td style="text-align:center;">
2.220000
</td>
<td style="text-align:center;">
2.530000
</td>
<td style="text-align:center;">
66
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.42
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9882353
</td>
<td style="text-align:center;">
0.4150588
</td>
<td style="text-align:center;">
-0.1327909
</td>
<td style="text-align:center;">
0.9629085
</td>
</tr>
<tr>
<td style="text-align:center;">
18
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-1.9729577
</td>
<td style="text-align:center;">
0.2843563
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Hansenne et al. 
</td>
<td style="text-align:center;">
1996
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
39.93
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
5.300000
</td>
<td style="text-align:center;">
17.700000
</td>
<td style="text-align:center;">
4.200000
</td>
<td style="text-align:center;">
7.400000
</td>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-2.06
</td>
<td style="text-align:center;">
0.31
</td>
<td style="text-align:center;">
0.9577465
</td>
<td style="text-align:center;">
1.9729577
</td>
<td style="text-align:center;">
-3.0181291
</td>
<td style="text-align:center;">
-0.9277864
</td>
</tr>
<tr>
<td style="text-align:center;">
18
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
N1
</td>
<td style="text-align:center;">
0.2681690
</td>
<td style="text-align:center;">
0.1834557
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Hansenne et al. 
</td>
<td style="text-align:center;">
1996
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
39.93
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
N1
</td>
<td style="text-align:center;">
-9.700000
</td>
<td style="text-align:center;">
-11.400000
</td>
<td style="text-align:center;">
5.400000
</td>
<td style="text-align:center;">
6.800000
</td>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.28
</td>
<td style="text-align:center;">
0.20
</td>
<td style="text-align:center;">
0.9577465
</td>
<td style="text-align:center;">
0.2681690
</td>
<td style="text-align:center;">
-0.5713328
</td>
<td style="text-align:center;">
1.1076708
</td>
</tr>
<tr>
<td style="text-align:center;">
18
</td>
<td style="text-align:center;">
92
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P2
</td>
<td style="text-align:center;">
-2.3656338
</td>
<td style="text-align:center;">
0.3210474
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Hansenne et al. 
</td>
<td style="text-align:center;">
1996
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
39.93
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
P2
</td>
<td style="text-align:center;">
2.900000
</td>
<td style="text-align:center;">
9.300000
</td>
<td style="text-align:center;">
1.800000
</td>
<td style="text-align:center;">
3.200000
</td>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-2.47
</td>
<td style="text-align:center;">
0.35
</td>
<td style="text-align:center;">
0.9577465
</td>
<td style="text-align:center;">
2.3656338
</td>
<td style="text-align:center;">
-3.4761903
</td>
<td style="text-align:center;">
-1.2550773
</td>
</tr>
<tr>
<td style="text-align:center;">
18
</td>
<td style="text-align:center;">
93
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
1.1301408
</td>
<td style="text-align:center;">
0.2109740
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Hansenne et al. 
</td>
<td style="text-align:center;">
1996
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
39.93
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
-12.900000
</td>
<td style="text-align:center;">
-17.900000
</td>
<td style="text-align:center;">
4.700000
</td>
<td style="text-align:center;">
3.700000
</td>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
1.18
</td>
<td style="text-align:center;">
0.23
</td>
<td style="text-align:center;">
0.9577465
</td>
<td style="text-align:center;">
1.1301408
</td>
<td style="text-align:center;">
0.2298755
</td>
<td style="text-align:center;">
2.0304062
</td>
</tr>
<tr>
<td style="text-align:center;">
19
</td>
<td style="text-align:center;">
94
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
-0.5930502
</td>
<td style="text-align:center;">
0.0586181
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Ashton et al. 
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
31.35
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
40
</td>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
7.180000
</td>
<td style="text-align:center;">
9.630000
</td>
<td style="text-align:center;">
3.630000
</td>
<td style="text-align:center;">
4.700000
</td>
<td style="text-align:center;">
67
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.60
</td>
<td style="text-align:center;">
0.06
</td>
<td style="text-align:center;">
0.9884170
</td>
<td style="text-align:center;">
0.5930502
</td>
<td style="text-align:center;">
-1.0675892
</td>
<td style="text-align:center;">
-0.1185112
</td>
</tr>
<tr>
<td style="text-align:center;">
19
</td>
<td style="text-align:center;">
95
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
PINV
</td>
<td style="text-align:center;">
0.4546718
</td>
<td style="text-align:center;">
0.0586181
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Ashton et al. 
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
31.35
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
40
</td>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
PINV
</td>
<td style="text-align:center;">
3.080000
</td>
<td style="text-align:center;">
2.110000
</td>
<td style="text-align:center;">
2.130000
</td>
<td style="text-align:center;">
2.110000
</td>
<td style="text-align:center;">
67
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.46
</td>
<td style="text-align:center;">
0.06
</td>
<td style="text-align:center;">
0.9884170
</td>
<td style="text-align:center;">
0.4546718
</td>
<td style="text-align:center;">
-0.0198672
</td>
<td style="text-align:center;">
0.9292108
</td>
</tr>
<tr>
<td style="text-align:center;">
19
</td>
<td style="text-align:center;">
96
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-0.5238610
</td>
<td style="text-align:center;">
0.0586181
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Ashton et al. 
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
31.35
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
40
</td>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
19.500000
</td>
<td style="text-align:center;">
26.400000
</td>
<td style="text-align:center;">
7.900000
</td>
<td style="text-align:center;">
18.000000
</td>
<td style="text-align:center;">
67
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.53
</td>
<td style="text-align:center;">
0.06
</td>
<td style="text-align:center;">
0.9884170
</td>
<td style="text-align:center;">
0.5238610
</td>
<td style="text-align:center;">
-0.9984000
</td>
<td style="text-align:center;">
-0.0493220
</td>
</tr>
<tr>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
97
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-0.9186813
</td>
<td style="text-align:center;">
0.1683275
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Juckel & Hegerl
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
15
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
LDAEP tangential
</td>
<td style="text-align:center;">
0.130000
</td>
<td style="text-align:center;">
0.190000
</td>
<td style="text-align:center;">
0.050000
</td>
<td style="text-align:center;">
0.070000
</td>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.95
</td>
<td style="text-align:center;">
0.18
</td>
<td style="text-align:center;">
0.9670330
</td>
<td style="text-align:center;">
0.9186813
</td>
<td style="text-align:center;">
-1.7228249
</td>
<td style="text-align:center;">
-0.1145377
</td>
</tr>
<tr>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
98
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
0.1547253
</td>
<td style="text-align:center;">
0.1589760
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Juckel & Hegerl
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
15
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
LDAEP radial
</td>
<td style="text-align:center;">
0.060000
</td>
<td style="text-align:center;">
0.050000
</td>
<td style="text-align:center;">
0.080000
</td>
<td style="text-align:center;">
0.050000
</td>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.16
</td>
<td style="text-align:center;">
0.17
</td>
<td style="text-align:center;">
0.9670330
</td>
<td style="text-align:center;">
0.1547253
</td>
<td style="text-align:center;">
-0.6267618
</td>
<td style="text-align:center;">
0.9362124
</td>
</tr>
<tr>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
99
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-0.5772152
</td>
<td style="text-align:center;">
0.2036084
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Juckel & Hegerl
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
15
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Cz LDAEP
</td>
<td style="text-align:center;">
1.000000
</td>
<td style="text-align:center;">
1.900000
</td>
<td style="text-align:center;">
0.800000
</td>
<td style="text-align:center;">
1.700000
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.60
</td>
<td style="text-align:center;">
0.22
</td>
<td style="text-align:center;">
0.9620253
</td>
<td style="text-align:center;">
0.5772152
</td>
<td style="text-align:center;">
-1.4616257
</td>
<td style="text-align:center;">
0.3071954
</td>
</tr>
<tr>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
100
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-0.3270886
</td>
<td style="text-align:center;">
0.1943535
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Juckel & Hegerl
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
15
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
C3 LDAEP
</td>
<td style="text-align:center;">
0.900000
</td>
<td style="text-align:center;">
1.200000
</td>
<td style="text-align:center;">
0.500000
</td>
<td style="text-align:center;">
1.000000
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.34
</td>
<td style="text-align:center;">
0.21
</td>
<td style="text-align:center;">
0.9620253
</td>
<td style="text-align:center;">
0.3270886
</td>
<td style="text-align:center;">
-1.1911652
</td>
<td style="text-align:center;">
0.5369879
</td>
</tr>
<tr>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
101
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-0.6637975
</td>
<td style="text-align:center;">
0.2036084
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Juckel & Hegerl
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
15
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
C4 LDAEP
</td>
<td style="text-align:center;">
0.600000
</td>
<td style="text-align:center;">
1.200000
</td>
<td style="text-align:center;">
0.400000
</td>
<td style="text-align:center;">
1.000000
</td>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.69
</td>
<td style="text-align:center;">
0.22
</td>
<td style="text-align:center;">
0.9620253
</td>
<td style="text-align:center;">
0.6637975
</td>
<td style="text-align:center;">
-1.5482080
</td>
<td style="text-align:center;">
0.2206131
</td>
</tr>
<tr>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
102
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-0.9953488
</td>
<td style="text-align:center;">
0.3028664
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Juckel & Hegerl
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Cz LDAEP
</td>
<td style="text-align:center;">
0.700000
</td>
<td style="text-align:center;">
2.100000
</td>
<td style="text-align:center;">
1.000000
</td>
<td style="text-align:center;">
1.600000
</td>
<td style="text-align:center;">
13
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-1.07
</td>
<td style="text-align:center;">
0.35
</td>
<td style="text-align:center;">
0.9302326
</td>
<td style="text-align:center;">
0.9953488
</td>
<td style="text-align:center;">
-2.0740015
</td>
<td style="text-align:center;">
0.0833038
</td>
</tr>
<tr>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
103
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-1.0511628
</td>
<td style="text-align:center;">
0.3115197
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Juckel & Hegerl
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
C3 LDAEP
</td>
<td style="text-align:center;">
0.500000
</td>
<td style="text-align:center;">
1.400000
</td>
<td style="text-align:center;">
0.700000
</td>
<td style="text-align:center;">
0.900000
</td>
<td style="text-align:center;">
13
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-1.13
</td>
<td style="text-align:center;">
0.36
</td>
<td style="text-align:center;">
0.9302326
</td>
<td style="text-align:center;">
1.0511628
</td>
<td style="text-align:center;">
-2.1451163
</td>
<td style="text-align:center;">
0.0427907
</td>
</tr>
<tr>
<td style="text-align:center;">
20
</td>
<td style="text-align:center;">
104
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
LDAEP
</td>
<td style="text-align:center;">
-1.5162791
</td>
<td style="text-align:center;">
0.3547864
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Juckel & Hegerl
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
C4 LDAEP
</td>
<td style="text-align:center;">
0.700000
</td>
<td style="text-align:center;">
1.800000
</td>
<td style="text-align:center;">
0.400000
</td>
<td style="text-align:center;">
0.900000
</td>
<td style="text-align:center;">
13
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-1.63
</td>
<td style="text-align:center;">
0.41
</td>
<td style="text-align:center;">
0.9302326
</td>
<td style="text-align:center;">
1.5162791
</td>
<td style="text-align:center;">
-2.6837324
</td>
<td style="text-align:center;">
-0.3488257
</td>
</tr>
<tr>
<td style="text-align:center;">
21
</td>
<td style="text-align:center;">
105
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-1.3480851
</td>
<td style="text-align:center;">
0.3155093
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Hansenne et al. 
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
maximum
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
6.600000
</td>
<td style="text-align:center;">
16.600000
</td>
<td style="text-align:center;">
5.300000
</td>
<td style="text-align:center;">
8.300000
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-1.44
</td>
<td style="text-align:center;">
0.36
</td>
<td style="text-align:center;">
0.9361702
</td>
<td style="text-align:center;">
1.3480851
</td>
<td style="text-align:center;">
-2.4490213
</td>
<td style="text-align:center;">
-0.2471489
</td>
</tr>
<tr>
<td style="text-align:center;">
21
</td>
<td style="text-align:center;">
106
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
1.2731915
</td>
<td style="text-align:center;">
0.3067451
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Hansenne et al. 
</td>
<td style="text-align:center;">
1994
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
ear
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
-14.700000
</td>
<td style="text-align:center;">
-20.900000
</td>
<td style="text-align:center;">
4.500000
</td>
<td style="text-align:center;">
4.600000
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
1.36
</td>
<td style="text-align:center;">
0.35
</td>
<td style="text-align:center;">
0.9361702
</td>
<td style="text-align:center;">
1.2731915
</td>
<td style="text-align:center;">
0.1876538
</td>
<td style="text-align:center;">
2.3587292
</td>
</tr>
<tr>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
107
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.5428571
</td>
<td style="text-align:center;">
0.0681936
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tsypes et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
24.92
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Cue P3
</td>
<td style="text-align:center;">
0.171600
</td>
<td style="text-align:center;">
2.383500
</td>
<td style="text-align:center;">
2.950250
</td>
<td style="text-align:center;">
4.833240
</td>
<td style="text-align:center;">
60
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.55
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9870130
</td>
<td style="text-align:center;">
0.5428571
</td>
<td style="text-align:center;">
-1.0546898
</td>
<td style="text-align:center;">
-0.0310245
</td>
</tr>
<tr>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
108
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
0.1974026
</td>
<td style="text-align:center;">
0.0681936
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tsypes et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
24.92
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
CNV
</td>
<td style="text-align:center;">
1.183200
</td>
<td style="text-align:center;">
-0.257200
</td>
<td style="text-align:center;">
5.879990
</td>
<td style="text-align:center;">
8.041540
</td>
<td style="text-align:center;">
60
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.20
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9870130
</td>
<td style="text-align:center;">
0.1974026
</td>
<td style="text-align:center;">
-0.3144300
</td>
<td style="text-align:center;">
0.7092352
</td>
</tr>
<tr>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
109
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
SPN
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
0.0681936
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tsypes et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
24.92
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
SPN
</td>
<td style="text-align:center;">
-2.402400
</td>
<td style="text-align:center;">
-2.385100
</td>
<td style="text-align:center;">
5.204460
</td>
<td style="text-align:center;">
5.898110
</td>
<td style="text-align:center;">
60
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.00
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9870130
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
-0.5118326
</td>
<td style="text-align:center;">
0.5118326
</td>
</tr>
<tr>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
110
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.2072727
</td>
<td style="text-align:center;">
0.0681936
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tsypes et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
24.92
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
RewP Doors
</td>
<td style="text-align:center;">
1.233300
</td>
<td style="text-align:center;">
0.312700
</td>
<td style="text-align:center;">
3.852530
</td>
<td style="text-align:center;">
4.707700
</td>
<td style="text-align:center;">
60
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.21
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9870130
</td>
<td style="text-align:center;">
0.2072727
</td>
<td style="text-align:center;">
-0.3045599
</td>
<td style="text-align:center;">
0.7191053
</td>
</tr>
<tr>
<td style="text-align:center;">
22
</td>
<td style="text-align:center;">
111
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.1381818
</td>
<td style="text-align:center;">
0.0681936
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tsypes et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
24.92
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
30
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
RewP to rich stimulus
</td>
<td style="text-align:center;">
9.738500
</td>
<td style="text-align:center;">
10.696600
</td>
<td style="text-align:center;">
5.506170
</td>
<td style="text-align:center;">
8.185590
</td>
<td style="text-align:center;">
60
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.14
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9870130
</td>
<td style="text-align:center;">
0.1381818
</td>
<td style="text-align:center;">
-0.6500144
</td>
<td style="text-align:center;">
0.3736508
</td>
</tr>
<tr>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
112
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.0196923
</td>
<td style="text-align:center;">
0.0775574
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Tsypes & Gibb
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
26
</td>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Loss RewP
</td>
<td style="text-align:center;">
14.458255
</td>
<td style="text-align:center;">
14.654383
</td>
<td style="text-align:center;">
8.072886
</td>
<td style="text-align:center;">
8.082401
</td>
<td style="text-align:center;">
51
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.02
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9846154
</td>
<td style="text-align:center;">
0.0196923
</td>
<td style="text-align:center;">
-0.5655352
</td>
<td style="text-align:center;">
0.5261506
</td>
</tr>
<tr>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
113
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.2363077
</td>
<td style="text-align:center;">
0.0775574
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Tsypes & Gibb
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
26
</td>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gain RewP
</td>
<td style="text-align:center;">
16.544879
</td>
<td style="text-align:center;">
18.925939
</td>
<td style="text-align:center;">
8.761764
</td>
<td style="text-align:center;">
10.838640
</td>
<td style="text-align:center;">
51
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.24
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9846154
</td>
<td style="text-align:center;">
0.2363077
</td>
<td style="text-align:center;">
-0.7821506
</td>
<td style="text-align:center;">
0.3095352
</td>
</tr>
<tr>
<td style="text-align:center;">
23
</td>
<td style="text-align:center;">
114
</td>
<td style="text-align:center;">
attempt
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.4923077
</td>
<td style="text-align:center;">
0.0775574
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Tsypes & Gibb
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
26
</td>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
SA
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
2.086623
</td>
<td style="text-align:center;">
4.271555
</td>
<td style="text-align:center;">
3.762021
</td>
<td style="text-align:center;">
4.884324
</td>
<td style="text-align:center;">
51
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.50
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9846154
</td>
<td style="text-align:center;">
0.4923077
</td>
<td style="text-align:center;">
-1.0381506
</td>
<td style="text-align:center;">
0.0535352
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
115
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early p3 congruent neutral-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
0.000
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.00
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
-0.3886873
</td>
<td style="text-align:center;">
0.3886873
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
116
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1586479
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early P3 congruent threat-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
0.081
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.16
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.1586479
</td>
<td style="text-align:center;">
-0.2300394
</td>
<td style="text-align:center;">
0.5473352
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
117
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1883944
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early p3 incongruent neutral-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
0.095
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.19
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.1883944
</td>
<td style="text-align:center;">
-0.2002930
</td>
<td style="text-align:center;">
0.5770817
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
118
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.0594930
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early p3 incongruent threat-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
0.030
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.06
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.0594930
</td>
<td style="text-align:center;">
-0.3291944
</td>
<td style="text-align:center;">
0.4481803
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
119
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3668376
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early p3 congruent neutral-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
0.183
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.37
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.3668376
</td>
<td style="text-align:center;">
-0.0676858
</td>
<td style="text-align:center;">
0.8013610
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
120
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4659829
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early p3 congruent threat-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
0.230
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.47
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.4659829
</td>
<td style="text-align:center;">
0.0314595
</td>
<td style="text-align:center;">
0.9005063
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
121
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4560684
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early p3 incongruent neutral-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
0.222
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.46
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.4560684
</td>
<td style="text-align:center;">
0.0215449
</td>
<td style="text-align:center;">
0.8905918
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
122
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4758974
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early P3 incongruent threat-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
0.233
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.48
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.4758974
</td>
<td style="text-align:center;">
0.0413740
</td>
<td style="text-align:center;">
0.9104209
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
123
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1982709
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early p3 congruent neutral-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
0.098
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.20
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.1982709
</td>
<td style="text-align:center;">
-0.2362094
</td>
<td style="text-align:center;">
0.6327511
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
124
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3073199
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early p3 congruent threat-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
0.154
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.31
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.3073199
</td>
<td style="text-align:center;">
-0.1271604
</td>
<td style="text-align:center;">
0.7418001
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
125
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1883573
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early p3 incongruent neutral-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
0.096
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.19
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.1883573
</td>
<td style="text-align:center;">
-0.2461229
</td>
<td style="text-align:center;">
0.6228376
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
126
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.2577522
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA early P3 incongruent threat-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
0.131
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.26
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.2577522
</td>
<td style="text-align:center;">
-0.1767281
</td>
<td style="text-align:center;">
0.6922324
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
127
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1288630
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz congruent threat P3-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.063
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.13
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.1288630
</td>
<td style="text-align:center;">
-0.5632990
</td>
<td style="text-align:center;">
0.3055731
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
128
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1288630
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz inconruent threat P3-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.067
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.13
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.1288630
</td>
<td style="text-align:center;">
-0.5632990
</td>
<td style="text-align:center;">
0.3055731
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
129
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.2478134
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz congruent neutral P3-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.125
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.25
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.2478134
</td>
<td style="text-align:center;">
-0.6822495
</td>
<td style="text-align:center;">
0.1866227
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
130
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0991254
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz incongruent neutral P3-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.048
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.10
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.0991254
</td>
<td style="text-align:center;">
-0.5335614
</td>
<td style="text-align:center;">
0.3353107
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
131
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1685131
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz congruent threat P3-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.084
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.17
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.1685131
</td>
<td style="text-align:center;">
-0.6029492
</td>
<td style="text-align:center;">
0.2659229
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
132
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1288630
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz incongruent threat P3-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.066
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.13
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.1288630
</td>
<td style="text-align:center;">
-0.5632990
</td>
<td style="text-align:center;">
0.3055731
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
133
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1883382
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz congruent neutral P3-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.096
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.19
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.1883382
</td>
<td style="text-align:center;">
-0.6227743
</td>
<td style="text-align:center;">
0.2460979
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
134
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0396501
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz incongruent neutral P3-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.018
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.04
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.0396501
</td>
<td style="text-align:center;">
-0.4740862
</td>
<td style="text-align:center;">
0.3947859
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
135
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4261947
</td>
<td style="text-align:center;">
0.0491190
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz congruent threat P3-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
87
</td>
<td style="text-align:center;">
0.208
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.43
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9911504
</td>
<td style="text-align:center;">
0.4261947
</td>
<td style="text-align:center;">
-0.0081961
</td>
<td style="text-align:center;">
0.8605855
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
136
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4559292
</td>
<td style="text-align:center;">
0.0491190
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz inconruent threat P3-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
87
</td>
<td style="text-align:center;">
0.223
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.46
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9911504
</td>
<td style="text-align:center;">
0.4559292
</td>
<td style="text-align:center;">
0.0215384
</td>
<td style="text-align:center;">
0.8903200
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
137
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3270796
</td>
<td style="text-align:center;">
0.0491190
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz congruent neutral P3-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
87
</td>
<td style="text-align:center;">
0.162
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.33
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9911504
</td>
<td style="text-align:center;">
0.3270796
</td>
<td style="text-align:center;">
-0.1073112
</td>
<td style="text-align:center;">
0.7614705
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
138
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3568142
</td>
<td style="text-align:center;">
0.0491190
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz incongruent neutral P3-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
87
</td>
<td style="text-align:center;">
0.175
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.36
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9911504
</td>
<td style="text-align:center;">
0.3568142
</td>
<td style="text-align:center;">
-0.0775767
</td>
<td style="text-align:center;">
0.7912050
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
139
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4559292
</td>
<td style="text-align:center;">
0.0491190
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz congruent threat P3-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
87
</td>
<td style="text-align:center;">
0.225
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.46
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9911504
</td>
<td style="text-align:center;">
0.4559292
</td>
<td style="text-align:center;">
0.0215384
</td>
<td style="text-align:center;">
0.8903200
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
140
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4658407
</td>
<td style="text-align:center;">
0.0491190
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz incongruent threat P3-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
87
</td>
<td style="text-align:center;">
0.229
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.47
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9911504
</td>
<td style="text-align:center;">
0.4658407
</td>
<td style="text-align:center;">
0.0314499
</td>
<td style="text-align:center;">
0.9002315
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
141
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3865487
</td>
<td style="text-align:center;">
0.0491190
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz congruent neutral P3-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
87
</td>
<td style="text-align:center;">
0.192
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.39
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9911504
</td>
<td style="text-align:center;">
0.3865487
</td>
<td style="text-align:center;">
-0.0478422
</td>
<td style="text-align:center;">
0.8209395
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
142
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.4955752
</td>
<td style="text-align:center;">
0.0491190
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz incongruent neutral P3-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
87
</td>
<td style="text-align:center;">
0.241
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.50
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9911504
</td>
<td style="text-align:center;">
0.4955752
</td>
<td style="text-align:center;">
0.0611844
</td>
<td style="text-align:center;">
0.9299661
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
143
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1288358
</td>
<td style="text-align:center;">
0.0491085
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz congruent threat P3-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
86
</td>
<td style="text-align:center;">
0.065
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.13
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9910448
</td>
<td style="text-align:center;">
0.1288358
</td>
<td style="text-align:center;">
-0.3055087
</td>
<td style="text-align:center;">
0.5631803
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
144
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1288358
</td>
<td style="text-align:center;">
0.0491085
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz inconruent threat P3-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
86
</td>
<td style="text-align:center;">
0.067
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.13
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9910448
</td>
<td style="text-align:center;">
0.1288358
</td>
<td style="text-align:center;">
-0.3055087
</td>
<td style="text-align:center;">
0.5631803
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
145
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.0297313
</td>
<td style="text-align:center;">
0.0491085
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz congruent neutral P3-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
86
</td>
<td style="text-align:center;">
0.017
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.03
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9910448
</td>
<td style="text-align:center;">
0.0297313
</td>
<td style="text-align:center;">
-0.4046132
</td>
<td style="text-align:center;">
0.4640759
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
146
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0099104
</td>
<td style="text-align:center;">
0.0491085
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Cz incongruent neutral P3-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
86
</td>
<td style="text-align:center;">
-0.007
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.01
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9910448
</td>
<td style="text-align:center;">
0.0099104
</td>
<td style="text-align:center;">
-0.4442550
</td>
<td style="text-align:center;">
0.4244341
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
147
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3964179
</td>
<td style="text-align:center;">
0.0491085
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz congruent threat P3-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
86
</td>
<td style="text-align:center;">
0.196
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.40
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9910448
</td>
<td style="text-align:center;">
0.3964179
</td>
<td style="text-align:center;">
-0.0379266
</td>
<td style="text-align:center;">
0.8307624
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
148
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3567761
</td>
<td style="text-align:center;">
0.0491085
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz incongruent threat P3-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
86
</td>
<td style="text-align:center;">
0.186
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.36
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9910448
</td>
<td style="text-align:center;">
0.3567761
</td>
<td style="text-align:center;">
-0.0775684
</td>
<td style="text-align:center;">
0.7911206
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
149
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3567761
</td>
<td style="text-align:center;">
0.0491085
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz congruent neutral P3-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
86
</td>
<td style="text-align:center;">
0.188
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.36
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9910448
</td>
<td style="text-align:center;">
0.3567761
</td>
<td style="text-align:center;">
-0.0775684
</td>
<td style="text-align:center;">
0.7911206
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
150
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.3369552
</td>
<td style="text-align:center;">
0.0491085
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Pz incongruent neutral P3-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
86
</td>
<td style="text-align:center;">
0.169
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.34
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9910448
</td>
<td style="text-align:center;">
0.3369552
</td>
<td style="text-align:center;">
-0.0973893
</td>
<td style="text-align:center;">
0.7712997
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
151
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0991549
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA congruent neutral late PSW-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
-0.052
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.10
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.0991549
</td>
<td style="text-align:center;">
-0.4878423
</td>
<td style="text-align:center;">
0.2895324
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
152
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.0099155
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA congruent threat late PSW-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
0.005
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.01
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.0099155
</td>
<td style="text-align:center;">
-0.3787718
</td>
<td style="text-align:center;">
0.3986028
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
153
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1784789
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA incongruent neutral late PSW-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
0.092
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.18
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.1784789
</td>
<td style="text-align:center;">
-0.2102085
</td>
<td style="text-align:center;">
0.5671662
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
154
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.0198310
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA incongruent threat late PSW-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
0.011
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.0198310
</td>
<td style="text-align:center;">
-0.3688563
</td>
<td style="text-align:center;">
0.4085183
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
155
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.2082051
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA congruent neutral late PSW-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
-0.105
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.21
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.2082051
</td>
<td style="text-align:center;">
-0.6427286
</td>
<td style="text-align:center;">
0.2263183
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
156
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1090598
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA congruent threat late PSW-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
-0.053
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.11
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.1090598
</td>
<td style="text-align:center;">
-0.5435833
</td>
<td style="text-align:center;">
0.3254636
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
157
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1487179
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA incongruent neutral late PSW-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
-0.077
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.15
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.1487179
</td>
<td style="text-align:center;">
-0.5832414
</td>
<td style="text-align:center;">
0.2858055
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
158
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0297436
</td>
<td style="text-align:center;">
0.0393192
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA incongruent threat late PSW-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
-0.015
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.03
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.0297436
</td>
<td style="text-align:center;">
-0.4183932
</td>
<td style="text-align:center;">
0.3589060
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
159
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.4659366
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA congruent neutral late PSW-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.230
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.47
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.4659366
</td>
<td style="text-align:center;">
-0.9004169
</td>
<td style="text-align:center;">
-0.0314563
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
160
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.3767147
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA congruent threat late PSW-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.185
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.38
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.3767147
</td>
<td style="text-align:center;">
-0.8111949
</td>
<td style="text-align:center;">
0.0577656
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
161
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.3568876
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA incongruent neutral late PSW-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.176
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.36
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.3568876
</td>
<td style="text-align:center;">
-0.7913679
</td>
<td style="text-align:center;">
0.0775926
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
162
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1487032
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
PCA incongruent threat late PSW-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.073
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.15
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.1487032
</td>
<td style="text-align:center;">
-0.5831834
</td>
<td style="text-align:center;">
0.2857771
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
163
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1289014
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw congruent threat PSW-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
-0.067
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.13
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.1289014
</td>
<td style="text-align:center;">
-0.5175887
</td>
<td style="text-align:center;">
0.2597859
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
164
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1090704
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw incongruent threat PSW-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
-0.053
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.11
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.1090704
</td>
<td style="text-align:center;">
-0.4977577
</td>
<td style="text-align:center;">
0.2796169
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
165
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.2677183
</td>
<td style="text-align:center;">
0.0491585
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw congruent neutral PSW-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
-0.136
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.27
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.2677183
</td>
<td style="text-align:center;">
-0.7022839
</td>
<td style="text-align:center;">
0.1668473
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
166
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0396620
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw incongruent neutral PSW-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
-0.021
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.04
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.0396620
</td>
<td style="text-align:center;">
-0.4283493
</td>
<td style="text-align:center;">
0.3490254
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
167
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0198291
</td>
<td style="text-align:center;">
0.0393192
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw congruent threat PSW-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
-0.010
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.02
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.0198291
</td>
<td style="text-align:center;">
-0.4084786
</td>
<td style="text-align:center;">
0.3688205
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
168
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.0793162
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw incongruent threat PSW-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
0.039
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.0793162
</td>
<td style="text-align:center;">
-0.3552072
</td>
<td style="text-align:center;">
0.5138397
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
169
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.1685470
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw congruent neutral PSW-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
-0.084
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.17
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.1685470
</td>
<td style="text-align:center;">
-0.6030704
</td>
<td style="text-align:center;">
0.2659764
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
170
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0694017
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw incongruent neutral PSW-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
-0.037
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.07
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.0694017
</td>
<td style="text-align:center;">
-0.5039251
</td>
<td style="text-align:center;">
0.3651217
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
171
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.3073199
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw congruent threat PSW-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.154
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.31
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.3073199
</td>
<td style="text-align:center;">
-0.7418001
</td>
<td style="text-align:center;">
0.1271604
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
172
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.0693948
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw incongruent threat PSW-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.035
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.07
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.0693948
</td>
<td style="text-align:center;">
-0.5038751
</td>
<td style="text-align:center;">
0.3650854
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
173
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.3866282
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw congruent neutral PSW-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.191
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.39
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.3866282
</td>
<td style="text-align:center;">
-0.8211085
</td>
<td style="text-align:center;">
0.0478520
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
174
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
-0.3370605
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
raw incongruent neutral PSW-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.167
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.34
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.3370605
</td>
<td style="text-align:center;">
-0.7715408
</td>
<td style="text-align:center;">
0.0974197
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
175
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.0099145
</td>
<td style="text-align:center;">
0.0393192
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
pre threat view and mutilation view-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
0.007
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.01
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.0099145
</td>
<td style="text-align:center;">
-0.3787350
</td>
<td style="text-align:center;">
0.3985641
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
176
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.1388034
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
pre threat view and mutilation regulate-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
0.070
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.1388034
</td>
<td style="text-align:center;">
-0.2957200
</td>
<td style="text-align:center;">
0.5733269
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
177
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0991453
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
pre neutral-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
-0.051
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.10
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.0991453
</td>
<td style="text-align:center;">
-0.5336687
</td>
<td style="text-align:center;">
0.3353781
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
178
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.2776338
</td>
<td style="text-align:center;">
0.0491585
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
post threat view and mutilation view-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
0.140
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.28
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.2776338
</td>
<td style="text-align:center;">
-0.1569318
</td>
<td style="text-align:center;">
0.7121994
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
179
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.1685634
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
post threat and mutilation regulate-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
0.084
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.17
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.1685634
</td>
<td style="text-align:center;">
-0.2201239
</td>
<td style="text-align:center;">
0.5572507
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
180
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0396620
</td>
<td style="text-align:center;">
0.0393268
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
post neutral-bss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
91
</td>
<td style="text-align:center;">
-0.018
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.04
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9915493
</td>
<td style="text-align:center;">
0.0396620
</td>
<td style="text-align:center;">
-0.4283493
</td>
<td style="text-align:center;">
0.3490254
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
181
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0892219
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
pre threat view and mutilation view-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.043
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.09
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.0892219
</td>
<td style="text-align:center;">
-0.5237022
</td>
<td style="text-align:center;">
0.3452583
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
182
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.1685303
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
pre threat view and mutilation regulate-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.087
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.17
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.1685303
</td>
<td style="text-align:center;">
-0.6030105
</td>
<td style="text-align:center;">
0.2659500
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
183
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.1883573
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
pre neutral-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.094
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.19
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.1883573
</td>
<td style="text-align:center;">
-0.6228376
</td>
<td style="text-align:center;">
0.2461229
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
184
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.0793162
</td>
<td style="text-align:center;">
0.0491490
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
post threat view and mutilation view-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
0.042
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.0793162
</td>
<td style="text-align:center;">
-0.3552072
</td>
<td style="text-align:center;">
0.5138397
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
185
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0099145
</td>
<td style="text-align:center;">
0.0393192
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
post threat and mutilation regulate-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
-0.007
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.01
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.0099145
</td>
<td style="text-align:center;">
-0.3985641
</td>
<td style="text-align:center;">
0.3787350
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
186
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
0.0393192
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
post neutral-dsiss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
90
</td>
<td style="text-align:center;">
0.000
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.00
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9914530
</td>
<td style="text-align:center;">
0.0000000
</td>
<td style="text-align:center;">
-0.3886496
</td>
<td style="text-align:center;">
0.3886496
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
187
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.1387755
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
pre threat view and mutilation view-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.071
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.14
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.1387755
</td>
<td style="text-align:center;">
-0.5732116
</td>
<td style="text-align:center;">
0.2956606
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
188
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.2379009
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
pre threat view and mutilation regulate-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.117
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.24
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.2379009
</td>
<td style="text-align:center;">
-0.6723369
</td>
<td style="text-align:center;">
0.1965352
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
189
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.3568513
</td>
<td style="text-align:center;">
0.0491292
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
pre neutral-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
88
</td>
<td style="text-align:center;">
-0.176
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.36
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9912536
</td>
<td style="text-align:center;">
0.3568513
</td>
<td style="text-align:center;">
-0.7912874
</td>
<td style="text-align:center;">
0.0775848
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
190
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.0396542
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
post threat view and mutilation view-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.020
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.04
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.0396542
</td>
<td style="text-align:center;">
-0.4741344
</td>
<td style="text-align:center;">
0.3948261
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
191
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.2874928
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
post threat and mutilation regulate-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.145
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.29
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.2874928
</td>
<td style="text-align:center;">
-0.7219730
</td>
<td style="text-align:center;">
0.1469875
</td>
</tr>
<tr>
<td style="text-align:center;">
24
</td>
<td style="text-align:center;">
192
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
LPP
</td>
<td style="text-align:center;">
-0.2081844
</td>
<td style="text-align:center;">
0.0491392
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Albanese & Schmidt
</td>
<td style="text-align:center;">
unpublished, 2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
post neutral-sbqr
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
89
</td>
<td style="text-align:center;">
-0.102
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.21
</td>
<td style="text-align:center;">
0.05
</td>
<td style="text-align:center;">
0.9913545
</td>
<td style="text-align:center;">
0.2081844
</td>
<td style="text-align:center;">
-0.6426647
</td>
<td style="text-align:center;">
0.2262958
</td>
</tr>
<tr>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
193
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
N2
</td>
<td style="text-align:center;">
-0.6019417
</td>
<td style="text-align:center;">
0.1413894
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
15.70
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Target N2 at Fz
</td>
<td style="text-align:center;">
-1.710000
</td>
<td style="text-align:center;">
0.070000
</td>
<td style="text-align:center;">
3.560000
</td>
<td style="text-align:center;">
1.990000
</td>
<td style="text-align:center;">
28
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.62
</td>
<td style="text-align:center;">
0.15
</td>
<td style="text-align:center;">
0.9708738
</td>
<td style="text-align:center;">
0.6019417
</td>
<td style="text-align:center;">
-1.3389366
</td>
<td style="text-align:center;">
0.1350531
</td>
</tr>
<tr>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
194
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
N2
</td>
<td style="text-align:center;">
-0.5339806
</td>
<td style="text-align:center;">
0.1413894
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
15.70
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Novel N2 at Fz
</td>
<td style="text-align:center;">
-5.360000
</td>
<td style="text-align:center;">
-2.150000
</td>
<td style="text-align:center;">
7.500000
</td>
<td style="text-align:center;">
3.660000
</td>
<td style="text-align:center;">
28
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.55
</td>
<td style="text-align:center;">
0.15
</td>
<td style="text-align:center;">
0.9708738
</td>
<td style="text-align:center;">
0.5339806
</td>
<td style="text-align:center;">
-1.2709755
</td>
<td style="text-align:center;">
0.2030143
</td>
</tr>
<tr>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
195
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.1359223
</td>
<td style="text-align:center;">
0.1319634
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
15.70
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Target P3 at Pz
</td>
<td style="text-align:center;">
14.870000
</td>
<td style="text-align:center;">
13.690000
</td>
<td style="text-align:center;">
7.070000
</td>
<td style="text-align:center;">
9.650000
</td>
<td style="text-align:center;">
28
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.9708738
</td>
<td style="text-align:center;">
0.1359223
</td>
<td style="text-align:center;">
-0.5760824
</td>
<td style="text-align:center;">
0.8479270
</td>
</tr>
<tr>
<td style="text-align:center;">
25
</td>
<td style="text-align:center;">
196
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
P3
</td>
<td style="text-align:center;">
0.2718447
</td>
<td style="text-align:center;">
0.1319634
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Tavakoli et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
15.70
</td>
<td style="text-align:center;">
admission
</td>
<td style="text-align:center;">
nose
</td>
<td style="text-align:center;">
mop
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
14
</td>
<td style="text-align:center;">
S
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
Novel P3 at Cz
</td>
<td style="text-align:center;">
13.170000
</td>
<td style="text-align:center;">
10.980000
</td>
<td style="text-align:center;">
9.500000
</td>
<td style="text-align:center;">
5.870000
</td>
<td style="text-align:center;">
28
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.28
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.9708738
</td>
<td style="text-align:center;">
0.2718447
</td>
<td style="text-align:center;">
-0.4401600
</td>
<td style="text-align:center;">
0.9838494
</td>
</tr>
<tr>
<td style="text-align:center;">
26
</td>
<td style="text-align:center;">
197
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.1381166
</td>
<td style="text-align:center;">
0.0681293
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Pegg et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
15.90
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
RewP Win
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
58
</td>
<td style="text-align:center;">
0.070
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.14
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9865471
</td>
<td style="text-align:center;">
0.1381166
</td>
<td style="text-align:center;">
-0.3734744
</td>
<td style="text-align:center;">
0.6497076
</td>
</tr>
<tr>
<td style="text-align:center;">
26
</td>
<td style="text-align:center;">
198
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.1973094
</td>
<td style="text-align:center;">
0.0681293
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Pegg et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
15.90
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
RewP Loss
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
58
</td>
<td style="text-align:center;">
-0.100
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.20
</td>
<td style="text-align:center;">
0.07
</td>
<td style="text-align:center;">
0.9865471
</td>
<td style="text-align:center;">
0.1973094
</td>
<td style="text-align:center;">
-0.7089004
</td>
<td style="text-align:center;">
0.3142816
</td>
</tr>
<tr>
<td style="text-align:center;">
26
</td>
<td style="text-align:center;">
199
</td>
<td style="text-align:center;">
risk
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.7399103
</td>
<td style="text-align:center;">
0.0778620
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
Pegg et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
corr
</td>
<td style="text-align:center;">
15.90
</td>
<td style="text-align:center;">
interview
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
RewP Diff Score
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
58
</td>
<td style="text-align:center;">
0.350
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.75
</td>
<td style="text-align:center;">
0.08
</td>
<td style="text-align:center;">
0.9865471
</td>
<td style="text-align:center;">
0.7399103
</td>
<td style="text-align:center;">
0.1929965
</td>
<td style="text-align:center;">
1.2868241
</td>
</tr>
<tr>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
200
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.2592550
</td>
<td style="text-align:center;">
0.0397711
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gallyer et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
12.91
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
237
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
RewP Win
</td>
<td style="text-align:center;">
16.090000
</td>
<td style="text-align:center;">
18.200000
</td>
<td style="text-align:center;">
7.910000
</td>
<td style="text-align:center;">
8.180000
</td>
<td style="text-align:center;">
264
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.26
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9971347
</td>
<td style="text-align:center;">
0.2592550
</td>
<td style="text-align:center;">
-0.6501318
</td>
<td style="text-align:center;">
0.1316218
</td>
</tr>
<tr>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
201
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.2293410
</td>
<td style="text-align:center;">
0.0397711
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gallyer et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
12.91
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
237
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
RewP Loss
</td>
<td style="text-align:center;">
12.180000
</td>
<td style="text-align:center;">
13.950000
</td>
<td style="text-align:center;">
7.440000
</td>
<td style="text-align:center;">
7.910000
</td>
<td style="text-align:center;">
264
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.23
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9971347
</td>
<td style="text-align:center;">
0.2293410
</td>
<td style="text-align:center;">
-0.6202178
</td>
<td style="text-align:center;">
0.1615358
</td>
</tr>
<tr>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
202
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.0598281
</td>
<td style="text-align:center;">
0.0397711
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gallyer et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
12.91
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
237
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
RewP Diff Score
</td>
<td style="text-align:center;">
3.910000
</td>
<td style="text-align:center;">
4.260000
</td>
<td style="text-align:center;">
5.200000
</td>
<td style="text-align:center;">
6.030000
</td>
<td style="text-align:center;">
264
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.06
</td>
<td style="text-align:center;">
0.04
</td>
<td style="text-align:center;">
0.9971347
</td>
<td style="text-align:center;">
0.0598281
</td>
<td style="text-align:center;">
-0.4507049
</td>
<td style="text-align:center;">
0.3310487
</td>
</tr>
<tr>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
203
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.0598543
</td>
<td style="text-align:center;">
0.0199030
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gallyer et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
12.42
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
48
</td>
<td style="text-align:center;">
263
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
RewP Win
</td>
<td style="text-align:center;">
3.410000
</td>
<td style="text-align:center;">
3.810000
</td>
<td style="text-align:center;">
5.120000
</td>
<td style="text-align:center;">
6.540000
</td>
<td style="text-align:center;">
311
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.06
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9975709
</td>
<td style="text-align:center;">
0.0598543
</td>
<td style="text-align:center;">
-0.3363668
</td>
<td style="text-align:center;">
0.2166583
</td>
</tr>
<tr>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
204
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.2693441
</td>
<td style="text-align:center;">
0.0199030
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gallyer et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
12.42
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
48
</td>
<td style="text-align:center;">
263
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
RewP Loss
</td>
<td style="text-align:center;">
-1.580000
</td>
<td style="text-align:center;">
-0.210000
</td>
<td style="text-align:center;">
5.400000
</td>
<td style="text-align:center;">
4.990000
</td>
<td style="text-align:center;">
311
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.27
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9975709
</td>
<td style="text-align:center;">
0.2693441
</td>
<td style="text-align:center;">
-0.5458567
</td>
<td style="text-align:center;">
0.0071684
</td>
</tr>
<tr>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
205
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.1596113
</td>
<td style="text-align:center;">
0.0199030
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gallyer et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
12.42
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
48
</td>
<td style="text-align:center;">
263
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
RewP Diff Score
</td>
<td style="text-align:center;">
4.980000
</td>
<td style="text-align:center;">
4.020000
</td>
<td style="text-align:center;">
5.140000
</td>
<td style="text-align:center;">
5.990000
</td>
<td style="text-align:center;">
311
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.16
</td>
<td style="text-align:center;">
0.02
</td>
<td style="text-align:center;">
0.9975709
</td>
<td style="text-align:center;">
0.1596113
</td>
<td style="text-align:center;">
-0.1169012
</td>
<td style="text-align:center;">
0.4361239
</td>
</tr>
<tr>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
206
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.0199407
</td>
<td style="text-align:center;">
0.0298222
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gallyer et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
14.41
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
222
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
RewP Win
</td>
<td style="text-align:center;">
6.550000
</td>
<td style="text-align:center;">
6.640000
</td>
<td style="text-align:center;">
4.520000
</td>
<td style="text-align:center;">
6.140000
</td>
<td style="text-align:center;">
255
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.02
</td>
<td style="text-align:center;">
0.03
</td>
<td style="text-align:center;">
0.9970326
</td>
<td style="text-align:center;">
0.0199407
</td>
<td style="text-align:center;">
-0.3584152
</td>
<td style="text-align:center;">
0.3185339
</td>
</tr>
<tr>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
207
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
-0.0897329
</td>
<td style="text-align:center;">
0.0298222
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gallyer et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
14.41
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
222
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
RewP Loss
</td>
<td style="text-align:center;">
2.200000
</td>
<td style="text-align:center;">
2.700000
</td>
<td style="text-align:center;">
4.430000
</td>
<td style="text-align:center;">
5.690000
</td>
<td style="text-align:center;">
255
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
-0.09
</td>
<td style="text-align:center;">
0.03
</td>
<td style="text-align:center;">
0.9970326
</td>
<td style="text-align:center;">
0.0897329
</td>
<td style="text-align:center;">
-0.4282075
</td>
<td style="text-align:center;">
0.2487417
</td>
</tr>
<tr>
<td style="text-align:center;">
27
</td>
<td style="text-align:center;">
208
</td>
<td style="text-align:center;">
ideation
</td>
<td style="text-align:center;">
RewP
</td>
<td style="text-align:center;">
0.0598220
</td>
<td style="text-align:center;">
0.0298222
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
Gallyer et al. 
</td>
<td style="text-align:center;">
2020
</td>
<td style="text-align:center;">
group
</td>
<td style="text-align:center;">
14.41
</td>
<td style="text-align:center;">
mixed
</td>
<td style="text-align:center;">
mastoid
</td>
<td style="text-align:center;">
mean
</td>
<td style="text-align:center;">
33
</td>
<td style="text-align:center;">
222
</td>
<td style="text-align:center;">
SI
</td>
<td style="text-align:center;">
H
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
RewP Diff Score
</td>
<td style="text-align:center;">
4.360000
</td>
<td style="text-align:center;">
3.940000
</td>
<td style="text-align:center;">
5.320000
</td>
<td style="text-align:center;">
6.750000
</td>
<td style="text-align:center;">
255
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.06
</td>
<td style="text-align:center;">
0.03
</td>
<td style="text-align:center;">
0.9970326
</td>
<td style="text-align:center;">
0.0598220
</td>
<td style="text-align:center;">
-0.2786526
</td>
<td style="text-align:center;">
0.3982966
</td>
</tr>
<tr>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
</tbody>
</table>

``` r
# meta_data$scoring <- recode_factor(as.factor(meta_data$scoring), raw = 0, 
#                                    difference = 1, slope = 1)

datatable(meta_data, options = list(pageLength = 10)) 
```

<div class="datatables html-widget html-fill-item-overflow-hidden html-fill-item" id="htmlwidget-2" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-2">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207","208","209","210"],[1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,5,5,5,5,5,5,6,6,6,7,8,8,8,9,9,9,9,9,9,9,9,9,10,11,12,12,13,14,15,15,16,16,16,17,17,17,17,18,18,18,18,19,19,19,20,20,20,20,20,20,20,20,21,21,22,22,22,22,22,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,26,26,26,27,27,27,27,27,27,27,27,27,null,null],[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,null,null],["ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","risk","risk","risk","risk","risk","risk","attempt","attempt","attempt","ideation","risk","risk","risk","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","risk","risk","ideation","ideation","attempt","attempt","risk","ideation","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","attempt","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","risk","risk","risk","risk","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","risk","risk","risk","risk","risk","risk","risk","risk","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","risk","risk","risk","risk","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","risk","risk","risk","risk","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","risk","risk","risk","risk","risk","risk","risk","risk","risk","risk","risk","risk","risk","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation","ideation",null,null],["LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","N2","N2","N2","P3","P3","P3","N2","N2","N2","P3","P3","P3","P2","P2","P2","P3","P3","P3","CNV","CNV","CNV","P3","P3","P3","RewP","RewP","RewP","RewP","RewP","RewP","P3","P3","P3","P3","P3","P3","RewP","RewP","RewP","P3","P3","P3","P3","P3","P3","LPP","LPP","LPP","P3","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","P3","P3","P3","LDAEP","P3","P3","P3","P3","N1","P2","CNV","CNV","PINV","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","P3","CNV","P3","CNV","SPN","RewP","RewP","RewP","RewP","RewP","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","P3","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","LPP","N2","N2","P3","P3","RewP","RewP","RewP","RewP","RewP","RewP","RewP","RewP","RewP","RewP","RewP","RewP",null,null],[-0.05981613891726251,-0.05981613891726251,-0.2193258426966292,-0.1993871297242084,-0.01993871297242084,0,-0.119632277834525,-0.09969356486210419,-0.1794484167517875,-0.2791419816138918,-0.2592032686414709,0,-0.05981613891726251,0.2273764258555133,0.2076045627376426,0.06920152091254754,0.217490494296578,-0.02965779467680608,-0.217490494296578,0.6425855513307985,0.6623574144486692,0.3262357414448669,0.1977186311787072,-0.108745247148289,-0.2768060836501902,-2.968,0.6902325581395349,0.7395348837209302,0.4634418604651163,0.5127441860465116,0.5324651162790698,-0.1774883720930233,-0.03944186046511628,-0.3845581395348838,0.4437209302325582,-0.276093023255814,0.571906976744186,0.1577674418604651,-0.1577674418604651,-0.1774883720930233,0,-0.09860465116279071,0.03944186046511628,0.6902325581395349,0.8381395348837209,0.4831627906976744,0.571906976744186,0.4831627906976744,0.4634418604651163,-0.6031460674157303,0.5438202247191012,0,1.255172413793104,0.5599999999999999,0.183448275862069,0.3475862068965517,0.7724137931034484,0.569655172413793,-0.2093233082706767,-0.1893877551020408,-0.478453276047261,-0.5695808383233533,-0.4281545064377683,-0.1991416309012876,-0.448068669527897,-0.4292682926829268,0.3317073170731707,-0.5658536585365853,0.2536585365853659,-0.1268292682926829,0.3024390243902439,-0.3804878048780488,0.00975609756097561,0.8585365853658536,0.6374193548387097,-0.225430463576159,-0.8275862068965517,-0.009885931558935362,0.6853146853146853,0.1591474245115453,0.1372903225806452,0.3138064516129032,3.572984293193717,0.1476439790575916,0.1870157068062827,0.6522352941176471,0.8301176470588235,0.5534117647058824,0.4150588235294118,-1.972957746478873,0.2681690140845071,-2.365633802816902,1.130140845070422,-0.593050193050193,0.4546718146718147,-0.5238610038610039,-0.9186813186813186,0.1547252747252747,-0.5772151898734177,-0.3270886075949367,-0.6637974683544303,-0.9953488372093023,-1.051162790697674,-1.516279069767442,-1.348085106382979,1.273191489361702,-0.5428571428571429,0.1974025974025974,0,0.2072727272727273,-0.1381818181818182,-0.01969230769230769,-0.2363076923076923,-0.4923076923076923,0,0.1586478873239437,0.1883943661971831,0.05949295774647887,0.3668376068376069,0.465982905982906,0.4560683760683761,0.4758974358974359,0.1982708933717579,0.3073198847262248,0.18835734870317,0.2577521613832853,-0.1288629737609329,-0.1288629737609329,-0.2478134110787172,-0.0991253644314869,-0.1685131195335277,-0.1288629737609329,-0.1883381924198251,-0.03965014577259476,0.4261946902654867,0.455929203539823,0.3270796460176991,0.3568141592920354,0.455929203539823,0.4658407079646018,0.3865486725663717,0.495575221238938,0.1288358208955224,0.1288358208955224,0.02973134328358209,-0.009910447761194031,0.3964179104477612,0.3567761194029851,0.3567761194029851,0.3369552238805971,-0.0991549295774648,0.009915492957746479,0.1784788732394366,0.01983098591549296,-0.2082051282051282,-0.1090598290598291,-0.1487179487179487,-0.02974358974358974,-0.4659365994236311,-0.3767146974063401,-0.3568876080691643,-0.1487031700288184,-0.1289014084507042,-0.1090704225352113,-0.267718309859155,-0.03966197183098592,-0.01982905982905983,0.07931623931623932,-0.1685470085470086,-0.06940170940170941,-0.3073198847262248,-0.06939481268011528,-0.386628242074928,-0.3370605187319885,0.009914529914529915,0.1388034188034188,-0.09914529914529915,0.2776338028169014,0.1685633802816902,-0.03966197183098592,-0.08922190201729106,-0.1685302593659943,-0.18835734870317,0.07931623931623932,-0.009914529914529915,0,-0.1387755102040817,-0.2379008746355685,-0.3568513119533528,-0.03965417867435159,-0.287492795389049,-0.2081844380403458,-0.601941748,-0.533980583,0.13592233,0.27184466,0.138116592,-0.197309417,0.739910314,-0.2592550143266475,-0.2293409742120344,-0.05982808022922636,-0.05985425101214575,-0.2693441295546559,0.1596113360323887,-0.0199406528189911,-0.08973293768545994,0.05982195845697329,null,null],[0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.01987761374982915,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.06841214995156791,0.2819634396971336,0.07778301784748513,0.07778301784748513,0.07778301784748513,0.07778301784748513,0.07778301784748513,0.0680601406165495,0.0680601406165495,0.07778301784748513,0.07778301784748513,0.07778301784748513,0.07778301784748513,0.0680601406165495,0.0680601406165495,0.0680601406165495,0.0680601406165495,0.0680601406165495,0.0680601406165495,0.07778301784748513,0.08750589507842077,0.07778301784748513,0.07778301784748513,0.07778301784748513,0.07778301784748513,0.06843580356015655,0.06843580356015655,0.06843580356015655,0.1864447086801427,0.1584780023781213,0.1584780023781213,0.1584780023781213,0.1678002378121284,0.1584780023781213,0.0198713140069754,0.0198713140069754,0.0198713140069754,0.09643945641650831,0.01982869457901233,0.01982869457901233,0.01982869457901233,0.1427721594289113,0.1427721594289113,0.1427721594289113,0.1332540154669839,0.1332540154669839,0.1332540154669839,0.1427721594289113,0.1332540154669839,0.1522903033908388,0.1057831425598335,0.09606596201920969,0.08735955737824262,0.05863898567277248,0.1054330285099516,0.09893712003382034,0.09616649323621228,0.09616649323621228,0.2131432800635948,0.08719497820783421,0.08719497820783421,0.08789480968858132,0.08789480968858132,0.0781287197231834,0.0781287197231834,0.2843562785161675,0.1834556635588177,0.321047411227931,0.2109740130926404,0.05861808857947854,0.05861808857947854,0.05861808857947854,0.168327496679145,0.1589759690858592,0.2036083960903702,0.1943534689953533,0.2036083960903702,0.302866414277988,0.3115197404002163,0.3547863710113575,0.3155092802172929,0.3067451335445903,0.06819362455726093,0.06819362455726093,0.06819362455726093,0.06819362455726093,0.06819362455726093,0.07755739644970415,0.07755739644970415,0.07755739644970415,0.03932680023804801,0.03932680023804801,0.03932680023804801,0.03932680023804801,0.04914895171305428,0.04914895171305428,0.04914895171305428,0.04914895171305428,0.04913918394804375,0.04913918394804375,0.04913918394804375,0.04913918394804375,0.04912918936837543,0.04912918936837543,0.04912918936837543,0.04912918936837543,0.04912918936837543,0.04912918936837543,0.04912918936837543,0.04912918936837543,0.04911895998120448,0.04911895998120448,0.04911895998120448,0.04911895998120448,0.04911895998120448,0.04911895998120448,0.04911895998120448,0.04911895998120448,0.04910848741367788,0.04910848741367788,0.04910848741367788,0.04910848741367788,0.04910848741367788,0.04910848741367788,0.04910848741367788,0.04910848741367788,0.03932680023804801,0.03932680023804801,0.03932680023804801,0.03932680023804801,0.04914895171305428,0.04914895171305428,0.04914895171305428,0.03931916137044342,0.04913918394804375,0.04913918394804375,0.04913918394804375,0.04913918394804375,0.03932680023804801,0.03932680023804801,0.04915850029756001,0.03932680023804801,0.03931916137044342,0.04914895171305428,0.04914895171305428,0.04914895171305428,0.04913918394804375,0.04913918394804375,0.04913918394804375,0.04913918394804375,0.03931916137044342,0.04914895171305428,0.04914895171305428,0.04915850029756001,0.03932680023804801,0.03932680023804801,0.04913918394804375,0.04913918394804375,0.04913918394804375,0.04914895171305428,0.03931916137044342,0.03931916137044342,0.04912918936837543,0.04912918936837543,0.04912918936837543,0.04913918394804375,0.04913918394804375,0.04913918394804375,0.141389386,0.141389386,0.131963427,0.131963427,0.068129261,0.068129261,0.07786201199999999,0.03977110204349718,0.03977110204349718,0.03977110204349718,0.01990295202347195,0.01990295202347195,0.01990295202347195,0.02982222261356532,0.02982222261356532,0.02982222261356532,null,null],[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,null,null],["Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Albanese et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Song et al.","Tsypes, Owens, &amp; Gibb","Tsypes, Owens, &amp; Gibb","Tsypes, Owens, &amp; Gibb","Tavakoli et al.","Tavakoli et al.","Tavakoli et al.","Tavakoli et al.","Tavakoli et al.","Tavakoli et al.","Weinberg et al.","Weinberg et al.","Weinberg et al.","Baik et al.","Weinberg et al.","Weinberg et al.","Weinberg et al.","Kudinova et al.","Kudinova et al.","Kudinova et al.","Kudinova et al.","Kudinova et al.","Kudinova et al.","Kudinova et al.","Kudinova et al.","Kudinova et al.","Marsic et al.","Graßnickel et al.","Lee et al.","Lee et al.","Kim &amp; Park","Min et al.","Marsic","Marsic","Jandl, Steyer, &amp; Kaschka","Jandl, Steyer, &amp; Kaschka","Jandl, Steyer, &amp; Kaschka","Chen et al.","Chen et al.","Chen et al.","Chen et al.","Hansenne et al.","Hansenne et al.","Hansenne et al.","Hansenne et al.","Ashton et al.","Ashton et al.","Ashton et al.","Juckel &amp; Hegerl","Juckel &amp; Hegerl","Juckel &amp; Hegerl","Juckel &amp; Hegerl","Juckel &amp; Hegerl","Juckel &amp; Hegerl","Juckel &amp; Hegerl","Juckel &amp; Hegerl","Hansenne et al.","Hansenne et al.","Tsypes et al.","Tsypes et al.","Tsypes et al.","Tsypes et al.","Tsypes et al.","Tsypes &amp; Gibb","Tsypes &amp; Gibb","Tsypes &amp; Gibb","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Albanese &amp; Schmidt","Tavakoli et al.","Tavakoli et al.","Tavakoli et al.","Tavakoli et al.","Pegg et al.","Pegg et al.","Pegg et al.","Gallyer et al.","Gallyer et al.","Gallyer et al.","Gallyer et al.","Gallyer et al.","Gallyer et al.","Gallyer et al.","Gallyer et al.","Gallyer et al.",null,null],["2019b","2019b","2019b","2019b","2019b","2019b","2019b","2019b","2019b","2019b","2019b","2019b","2019b","2019a","2019a","2019a","2019a","2019a","2019a","2019a","2019a","2019a","2019a","2019a","2019a","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2019","2018","2018","2018","2018","2018","2018","2017","2017","2017","2018","2016","2016","2016","2016","2016","2016","2016","2016","2016","2016","2016","2016","2015","2015","2014","2014","2013","2012","2012","2012","2010","2010","2010","2005","2005","2005","2005","1996","1996","1996","1996","1994","1994","1994","1994","1994","1994","1994","1994","1994","1994","1994","1994","1994","2020","2020","2020","2020","2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","unpublished, 2020","2020","2020","2020","2020","2020","2020","2020","2020","2020","2020","2020","2020","2020","2020","2020","2020",null,null],["corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","group","group","group","group","group","group","group","group","group","group","group","group","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","group","group","group","group","group","group","group","group","group","group","group","group","corr","corr","corr","corr","group","group","group","group","group","group","group","group","group","corr","group","corr","corr","group","group","corr","corr","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","group","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","corr","group","group","group","group","corr","corr","corr","group","group","group","group","group","group","group","group","group",null,null],[35.29,35.29,35.29,35.29,35.29,35.29,35.29,35.29,35.29,35.29,35.29,35.29,35.29,36.63,36.63,36.63,36.63,36.63,36.63,36.63,36.63,36.63,36.63,36.63,36.63,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,22.73,9.5,9.5,9.5,14.9,14.9,14.9,14.9,14.9,14.9,41.18,41.18,41.18,42.45,42.93,42.93,42.93,19.76,19.76,19.76,19.76,19.76,19.76,19.76,19.76,19.76,20.69,43.2,39.55,44.18,40.79,46.13,25.15,25.15,48.32,48.32,48.32,27.4,27.4,27.4,27.4,39.93,39.93,39.93,39.93,31.35,31.35,31.35,null,null,null,null,null,null,null,null,null,null,24.92,24.92,24.92,24.92,24.92,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,15.7,15.7,15.7,15.7,15.9,15.9,15.9,12.91,12.91,12.91,12.42,12.42,12.42,14.41,14.41,14.41,null,null],["self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","self-report","mixed","mixed","mixed","admission","admission","h","admission","admission","admission","self-report","self-report","self-report","self-report","interview","interview","interview","interview","interview","interview","interview","interview","interview","interview","interview","interview","self-report","self-report","self-report","self-report",null,"interview","self-report","self-report","interview","interview","interview",null,null,null,null,"admission","admission","admission","admission","admission","admission","admission",null,null,null,null,null,null,null,null,"admission","admission",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"admission","admission","admission","admission","interview","interview","interview","mixed","mixed","mixed","mixed","mixed","mixed","mixed","mixed","mixed",null,null],["mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","nose","nose","nose","nose","nose","nose","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid",null,null,null,null,null,"mastoid","mastoid","average","average","average","ear","ear","ear","ear","ear","ear","ear","ear","mastoid","mastoid","mastoid",null,null,null,null,null,null,null,null,"ear","ear",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"nose","nose","nose","nose","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid","mastoid",null,null],["mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","aop","aop","aop","aop","aop","aop","aop","aop","aop","aop","aop","aop","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mop","mop","mop","mop","mop","mop","mean","mean","mean","maximum","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","maximum","maximum","maximum","maximum","maximum","maximum","mean","mean","maximum","maximum","maximum","maximum","maximum","maximum","maximum","maximum","maximum","maximum","maximum",null,null,null,null,null,null,null,null,null,null,null,"maximum","mean",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"mop","mop","mop","mop","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean","mean",null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,22,22,22,22,22,22,22,22,22,22,22,22,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,23,23,23,12,12,12,12,12,12,83,83,83,null,null,null,null,10,10,10,10,10,10,10,10,10,null,20,null,null,17,11,null,null,32,32,32,16,16,16,16,10,10,10,10,40,40,40,10,10,7,7,7,7,7,7,7,7,30,30,30,30,30,26,26,26,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,14,14,14,14,null,null,null,27,27,27,48,48,48,33,33,33,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,46,46,46,46,46,46,46,46,46,46,46,46,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,46,46,46,12,12,12,12,12,12,152,152,152,null,null,null,null,23,23,23,23,23,23,23,23,23,null,20,null,null,21,130,null,null,18,18,18,50,50,50,50,10,10,10,10,27,27,27,15,15,15,15,15,6,6,6,7,7,30,30,30,30,30,25,25,25,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,14,14,14,14,null,null,null,237,237,237,263,263,263,222,222,222,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,"SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"SI","SI","SI","S","S","S","S","S","S","SA","SA","SA",null,null,null,null,"SI","SI","SI","SI","SI","SI","SI","SI","SI",null,"S",null,null,"SA","SA",null,null,"SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA","SA",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"S","S","S","S",null,null,null,"SI","SI","SI","SI","SI","SI","SI","SI","SI",null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,"SI","SI","SI","SI","SI","SI","SI","SI","SI","SI","SI","SI",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"H","H","H","H","H","H","H","H","H","SI","SI","SI",null,null,null,null,"H","H","H","H","H","H","H","H","H",null,"H",null,null,"SI","SI",null,null,"H","H","H","SI","SI","SI","SI","SI","SI","SI","SI","H","H","H","SI","SI","SI","SI","SI","SI","SI","SI","H","H","H","H","H","H","H","H","H","H",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"H","H","H","H",null,null,null,"H","H","H","H","H","H","H","H","H",null,null],[null,"0",null,"0","0",null,"0",null,"0",null,"0",null,"0",null,"0","0",null,"0","0",null,"0","0",null,"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0",null,"0","0",null,null,null,null,null,null,"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","1","1","1","1","1","1","1","1",null,null,null,"1","0","0","0","0","0","0","0",null,null,"1",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"0","0",null,"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0",null,null,null,null,"0","0",null,"0","0",null,"0","0",null,"0","0",null,null,null],["Reward View LPP Diff","Reward View LPP","Threat/Mutilation View LPP Diff","Threat/Mutilation View LPP","Neutral View LPP","Threat/Mutilation Increase LPP Diff","Threat/Mutilation Increase LPP","Threat/Mutilation Decrease LPP Diff","Threat/Mutilation Decrease LPP","Reward Increase LPP Diff","Reward Increase LPP","Reward decrease LPP Diff","Reward decrease LPP","Go No-Go N2 Diff","No-Go N2","Go N2","Go No-Go P3 Diff","No-Go P3","Go P3","Latent Go No-Go N2 Diff","Latent No-Go N2","Latent Go N2","Latent Go No-Go P3 Diff","Latent No-Go P3","Latent Go P3","P2 Reward","P2 Punishment","P2 Neutral","Cue P3 Reward","Cue P3 Punishment","Cue P3 Neutral","CNV Reward","CNV Punishment","CNV Neutral","Target P3 Reward","Target P3 Punishment","Target P3 Neutral","Positive Condition Reward RewP","Positive Condition Punishment RewP","Positive Condition Neutral RewP","Negative Condition Reward RewP","Negative Condition Punishment RewP","Negative Condition Neutral RewP","Positive Condition Reward Feedback P3","Positive Condition Punishment Feedback P3","Positive Condition Neutral Feedback P3","Negative Condition Reward Feedback P3","Negative Condition Punishment Feedback P3","Negative Condition Neutral Feedback P3","Difference RewP","Loss RewP","Win RewP","Environment P3 difference","White Noise P3 difference","Increment P3 difference","Decrement P3 difference","Frequency P3 difference","Duration P3 difference","Positive LPP","Neutral LPP","Negative LPP","Invalid suicide-relevant words P3","Positive LPP","Neutral LPP","Negative LPP","Neutral View LPP","Positive View LPP","Negative View LPP","Neutral Increase LPP","Positive Increase LPP","Negative Increase LPP","Neutral Decrease LPP","Positive Decrease LPP","Negative Decrease LPP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","LDAEP","First half second half P3 diff","Novel First half second half P3 diff","Target First Half second half P3 diff","LDAEP","Fz P3","Cz P3","Pz P3","P3","N1","P2","CNV","CNV","PINV","LDAEP","LDAEP tangential","LDAEP radial","Cz LDAEP","C3 LDAEP","C4 LDAEP","Cz LDAEP","C3 LDAEP","C4 LDAEP","P3","CNV","Cue P3","CNV","SPN","RewP Doors","RewP to rich stimulus","Loss RewP","Gain RewP","RewP","PCA early p3 congruent neutral-bss","PCA early P3 congruent threat-bss","PCA early p3 incongruent neutral-bss","PCA early p3 incongruent threat-bss","PCA early p3 congruent neutral-dsiss","PCA early p3 congruent threat-dsiss","PCA early p3 incongruent neutral-dsiss","PCA early P3 incongruent threat-dsiss","PCA early p3 congruent neutral-sbqr","PCA early p3 congruent threat-sbqr","PCA early p3 incongruent neutral-sbqr","PCA early P3 incongruent threat-sbqr","Cz congruent threat P3-bss","Cz inconruent threat P3-bss","Cz congruent neutral P3-bss","Cz incongruent neutral P3-bss","Pz congruent threat P3-bss","Pz incongruent threat P3-bss","Pz congruent neutral P3-bss","Pz incongruent neutral P3-bss","Cz congruent threat P3-dsiss","Cz inconruent threat P3-dsiss","Cz congruent neutral P3-dsiss","Cz incongruent neutral P3-dsiss","Pz congruent threat P3-dsiss","Pz incongruent threat P3-dsiss","Pz congruent neutral P3-dsiss","Pz incongruent neutral P3-dsiss","Cz congruent threat P3-sbqr","Cz inconruent threat P3-sbqr","Cz congruent neutral P3-sbqr","Cz incongruent neutral P3-sbqr","Pz congruent threat P3-sbqr","Pz incongruent threat P3-sbqr","Pz congruent neutral P3-sbqr","Pz incongruent neutral P3-sbqr","PCA congruent neutral late PSW-bss","PCA congruent threat late PSW-bss","PCA incongruent neutral late PSW-bss","PCA incongruent threat late PSW-bss","PCA congruent neutral late PSW-dsiss","PCA congruent threat late PSW-dsiss","PCA incongruent neutral late PSW-dsiss","PCA incongruent threat late PSW-dsiss","PCA congruent neutral late PSW-sbqr","PCA congruent threat late PSW-sbqr","PCA incongruent neutral late PSW-sbqr","PCA incongruent threat late PSW-sbqr","raw congruent threat PSW-bss","raw incongruent threat PSW-bss","raw congruent neutral PSW-bss","raw incongruent neutral PSW-bss","raw congruent threat PSW-dsiss","raw incongruent threat PSW-dsiss","raw congruent neutral PSW-dsiss","raw incongruent neutral PSW-dsiss","raw congruent threat PSW-sbqr","raw incongruent threat PSW-sbqr","raw congruent neutral PSW-sbqr","raw incongruent neutral PSW-sbqr","pre threat view and mutilation view-bss","pre threat view and mutilation regulate-bss","pre neutral-bss","post threat view and mutilation view-bss","post threat and mutilation regulate-bss","post neutral-bss","pre threat view and mutilation view-dsiss","pre threat view and mutilation regulate-dsiss","pre neutral-dsiss","post threat view and mutilation view-dsiss","post threat and mutilation regulate-dsiss","post neutral-dsiss","pre threat view and mutilation view-sbqr","pre threat view and mutilation regulate-sbqr","pre neutral-sbqr","post threat view and mutilation view-sbqr","post threat and mutilation regulate-sbqr","post neutral-sbqr","Target N2 at Fz","Novel N2 at Fz","Target P3 at Pz","Novel P3 at Cz","RewP Win","RewP Loss","RewP Diff Score","RewP Win","RewP Loss","RewP Diff Score","RewP Win","RewP Loss","RewP Diff Score","RewP Win","RewP Loss","RewP Diff Score",null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,0.38,0.68,0.71,0.5600000000000001,9.35,3.51,0.71,1.87,1.98,0.43,5.61,1.04,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,4.98,null,4.04,3.32,0.02,0.07000000000000001,0.18,0.88,2.98,-0.64,3.49,null,null,null,null,-1.63,6.54,0.32,2.4,7.5,8.4,-1.15,6.54,11.5,null,0.2682,null,null,1.45,1.01,null,null,2,-0.1,0.39,1.69,6.54,6.39,5.75,5.3,-9.699999999999999,2.9,-12.9,7.18,3.08,19.5,0.13,0.06,1,0.9,0.6,0.7,0.5,0.7,6.6,-14.7,0.1716,1.1832,-2.4024,1.2333,9.7385,14.4582555,16.5448789,2.08662335,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,-1.71,-5.36,14.87,13.17,null,null,null,16.09,12.18,3.91,3.41,-1.58,4.98,6.55,2.2,4.36,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,-0.18,-0.07000000000000001,0.47,-0.27,9.52,4.46,-0.34,0.12,1.15,-0.2,6.25,2.32,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,1.62,null,1.54,1.82,-0.45,-0.55,-1.34,-0.35,3.99,0.08,6.04,null,null,null,null,1.3,3.6,6.34,0.65,8.1,5.7,2.03,6.43,2.8,null,0.3287,null,null,0.9,0.89,null,null,0.197,-0.576,-0.147,0.91,4.18,4.71,4.71,17.7,-11.4,9.300000000000001,-17.9,9.630000000000001,2.11,26.4,0.19,0.05,1.9,1.2,1.2,2.1,1.4,1.8,16.6,-20.9,2.3835,-0.2572,-2.3851,0.3127,10.6966,14.6543833,18.9259385,4.27155519,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,0.07000000000000001,-2.15,13.69,10.98,null,null,null,18.2,13.95,4.26,3.81,-0.21,4.02,6.64,2.7,3.94,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,1.9,3.69,3.7,4.41,5.85,3.77,1.3,2.39,2.17,3.18,5.44,3.87,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,6.6,null,2.26,2.91,1.49,1.88,1.14,1.56,4.58,3.77,5.25,null,null,null,null,5.9,11.52,11.8,5.14,7.62,12.3,12.8,12.6,11,null,0.28,null,null,0.92,0.5600000000000001,null,null,0.51,3.26,3.14,1.42,3.01,2.68,2.22,4.2,5.4,1.8,4.7,3.63,2.13,7.9,0.05,0.08,0.8,0.5,0.4,1,0.7,0.4,5.3,4.5,2.95025,5.87999,5.20446,3.85253,5.50617,8.07288567,8.7617645,3.762021,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,3.56,7.5,7.07,9.5,null,null,null,7.91,7.44,5.2,5.12,5.4,5.14,4.52,4.43,5.32,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,2.61,3.63,3.51,3.4,6.02,4.64,1.73,2.71,2.71,3.25,5.67,4.83,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,5.88,null,1.51,2.2,3.22,1.59,2.45,2.53,4.81,3.93,5.43,null,null,null,null,6.95,7.2,9.640000000000001,7.13,2.54,6.5,5.12,8.6,9.34,null,0.24,null,null,0.65,0.75,null,null,0.47,3.13,2.262,1.1,2.75,3.07,2.53,7.4,6.8,3.2,3.7,4.7,2.11,18,0.07000000000000001,0.05,1.7,1,1,1.6,0.9,0.9,8.300000000000001,4.6,4.83324,8.041539999999999,5.89811,4.7077,8.185589999999999,8.08240123,10.8386401,4.88432437,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,1.99,3.66,9.65,5.87,null,null,null,8.18,7.91,6.03,6.54,4.99,5.99,6.14,5.69,6.75,null,null],[247,247,247,247,247,247,247,247,247,247,247,247,247,68,68,68,68,68,68,68,68,68,68,68,68,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,69,69,69,24,24,24,24,24,24,235,235,235,44,177,177,177,33,33,33,33,33,33,33,33,33,41,40,53,68,38,143,41,41,50,50,50,66,66,66,66,20,20,20,20,67,67,67,25,25,22,22,22,13,13,13,14,14,60,60,60,60,60,51,51,51,91,91,91,91,90,90,90,90,89,89,89,89,88,88,88,88,88,88,88,88,87,87,87,87,87,87,87,87,86,86,86,86,86,86,86,86,91,91,91,91,90,90,90,90,89,89,89,89,91,91,91,91,90,90,90,90,89,89,89,89,90,90,90,91,91,91,89,89,89,90,90,90,88,88,88,89,89,89,28,28,28,28,58,58,58,264,264,264,311,311,311,255,255,255,null,null],[-0.03,-0.03,-0.11,-0.1,0.01,0,-0.06,-0.05,-0.09,-0.14,-0.13,0,-0.03,null,null,null,null,null,null,null,null,null,null,null,null,0.35,0.33,0.35,0.23,0.25,0.26,-0.09,-0.02,-0.19,0.22,-0.14,0.28,0.08,-0.08,-0.09,0,-0.05,0.02,0.33,0.39,0.24,0.28,0.24,0.23,null,null,null,null,null,null,null,null,null,null,null,null,-0.28,-0.21,-0.1,-0.22,null,null,null,null,null,null,null,null,null,0.31,null,-0.387,-0.012,null,null,0.07000000000000001,0.16,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,0,0.081,0.095,0.03,0.183,0.23,0.222,0.233,0.098,0.154,0.096,0.131,-0.063,-0.067,-0.125,-0.048,-0.08400000000000001,-0.066,-0.096,-0.018,0.208,0.223,0.162,0.175,0.225,0.229,0.192,0.241,0.065,0.067,0.017,-0.007,0.196,0.186,0.188,0.169,-0.052,0.005,0.092,0.011,-0.105,-0.053,-0.077,-0.015,-0.23,-0.185,-0.176,-0.073,-0.067,-0.053,-0.136,-0.021,-0.01,0.039,-0.08400000000000001,-0.037,-0.154,-0.035,-0.191,-0.167,0.007,0.07000000000000001,-0.051,0.14,0.08400000000000001,-0.018,-0.043,-0.08699999999999999,-0.094,0.042,-0.007,0,-0.07099999999999999,-0.117,-0.176,-0.02,-0.145,-0.102,null,null,null,null,0.07000000000000001,-0.1,0.35,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,5.63,null,0,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[-0.06,-0.06,-0.22,-0.2,-0.02,0,-0.12,-0.1,-0.18,-0.28,-0.26,0,-0.06,0.23,0.21,0.07000000000000001,0.22,-0.03,-0.22,0.65,0.67,0.33,0.2,-0.11,-0.28,-3.01,0.7,0.75,0.47,0.52,0.54,-0.18,-0.04,-0.39,0.45,-0.28,0.58,0.16,-0.16,-0.18,0,-0.1,0.04,0.7,0.85,0.49,0.58,0.49,0.47,-0.61,0.55,0,1.3,0.58,0.19,0.36,0.8,0.59,-0.21,-0.19,-0.48,-0.58,-0.43,-0.2,-0.45,-0.44,0.34,-0.58,0.26,-0.13,0.31,-0.39,0.01,0.88,0.65,-0.23,-0.84,-0.01,0.7,0.16,0.14,0.32,3.63,0.15,0.19,0.66,0.84,0.5600000000000001,0.42,-2.06,0.28,-2.47,1.18,-0.6,0.46,-0.53,-0.95,0.16,-0.6,-0.34,-0.6899999999999999,-1.07,-1.13,-1.63,-1.44,1.36,-0.55,0.2,0,0.21,-0.14,-0.02,-0.24,-0.5,0,0.16,0.19,0.06,0.37,0.47,0.46,0.48,0.2,0.31,0.19,0.26,-0.13,-0.13,-0.25,-0.1,-0.17,-0.13,-0.19,-0.04,0.43,0.46,0.33,0.36,0.46,0.47,0.39,0.5,0.13,0.13,0.03,-0.01,0.4,0.36,0.36,0.34,-0.1,0.01,0.18,0.02,-0.21,-0.11,-0.15,-0.03,-0.47,-0.38,-0.36,-0.15,-0.13,-0.11,-0.27,-0.04,-0.02,0.08,-0.17,-0.07000000000000001,-0.31,-0.07000000000000001,-0.39,-0.34,0.01,0.14,-0.1,0.28,0.17,-0.04,-0.09,-0.17,-0.19,0.08,-0.01,0,-0.14,-0.24,-0.36,-0.04,-0.29,-0.21,-0.62,-0.55,0.14,0.28,0.14,-0.2,0.75,-0.26,-0.23,-0.06,-0.06,-0.27,0.16,-0.02,-0.09,0.06,null,null],[0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.02,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.29,0.08,0.08,0.08,0.08,0.08,0.07000000000000001,0.07000000000000001,0.08,0.08,0.08,0.08,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.08,0.09,0.08,0.08,0.08,0.08,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.2,0.17,0.17,0.17,0.18,0.17,0.02,0.02,0.02,0.1,0.02,0.02,0.02,0.15,0.15,0.15,0.14,0.14,0.14,0.15,0.14,0.16,0.11,0.1,0.09,0.06,0.11,0.1,0.1,0.1,0.22,0.09,0.09,0.09,0.09,0.08,0.08,0.31,0.2,0.35,0.23,0.06,0.06,0.06,0.18,0.17,0.22,0.21,0.22,0.35,0.36,0.41,0.36,0.35,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.07000000000000001,0.08,0.08,0.08,0.04,0.04,0.04,0.04,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.04,0.04,0.04,0.04,0.05,0.05,0.05,0.04,0.05,0.05,0.05,0.05,0.04,0.04,0.05,0.04,0.04,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.04,0.05,0.05,0.05,0.04,0.04,0.05,0.05,0.05,0.05,0.04,0.04,0.05,0.05,0.05,0.05,0.05,0.05,0.15,0.15,0.14,0.14,0.07000000000000001,0.07000000000000001,0.08,0.04,0.04,0.04,0.02,0.02,0.02,0.03,0.03,0.03,null,null],[0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9969356486210419,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.9885931558935361,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.986046511627907,0.9887640449438202,0.9887640449438202,0.9887640449438202,0.9655172413793104,0.9655172413793104,0.9655172413793104,0.9655172413793104,0.9655172413793104,0.9655172413793104,0.9967776584317938,0.9967776584317938,0.9967776584317938,0.9820359281437125,0.9957081545064378,0.9957081545064378,0.9957081545064378,0.975609756097561,0.975609756097561,0.975609756097561,0.975609756097561,0.975609756097561,0.975609756097561,0.975609756097561,0.975609756097561,0.975609756097561,0.9806451612903225,0.9801324503311258,0.9852216748768473,0.9885931558935361,0.9790209790209791,0.9946714031971581,0.9806451612903225,0.9806451612903225,0.9842931937172775,0.9842931937172775,0.9842931937172775,0.9882352941176471,0.9882352941176471,0.9882352941176471,0.9882352941176471,0.9577464788732395,0.9577464788732395,0.9577464788732395,0.9577464788732395,0.9884169884169884,0.9884169884169884,0.9884169884169884,0.967032967032967,0.967032967032967,0.9620253164556962,0.9620253164556962,0.9620253164556962,0.9302325581395349,0.9302325581395349,0.9302325581395349,0.9361702127659575,0.9361702127659575,0.987012987012987,0.987012987012987,0.987012987012987,0.987012987012987,0.987012987012987,0.9846153846153847,0.9846153846153847,0.9846153846153847,0.9915492957746479,0.9915492957746479,0.9915492957746479,0.9915492957746479,0.9914529914529915,0.9914529914529915,0.9914529914529915,0.9914529914529915,0.9913544668587896,0.9913544668587896,0.9913544668587896,0.9913544668587896,0.9912536443148688,0.9912536443148688,0.9912536443148688,0.9912536443148688,0.9912536443148688,0.9912536443148688,0.9912536443148688,0.9912536443148688,0.9911504424778761,0.9911504424778761,0.9911504424778761,0.9911504424778761,0.9911504424778761,0.9911504424778761,0.9911504424778761,0.9911504424778761,0.991044776119403,0.991044776119403,0.991044776119403,0.991044776119403,0.991044776119403,0.991044776119403,0.991044776119403,0.991044776119403,0.9915492957746479,0.9915492957746479,0.9915492957746479,0.9915492957746479,0.9914529914529915,0.9914529914529915,0.9914529914529915,0.9914529914529915,0.9913544668587896,0.9913544668587896,0.9913544668587896,0.9913544668587896,0.9915492957746479,0.9915492957746479,0.9915492957746479,0.9915492957746479,0.9914529914529915,0.9914529914529915,0.9914529914529915,0.9914529914529915,0.9913544668587896,0.9913544668587896,0.9913544668587896,0.9913544668587896,0.9914529914529915,0.9914529914529915,0.9914529914529915,0.9915492957746479,0.9915492957746479,0.9915492957746479,0.9913544668587896,0.9913544668587896,0.9913544668587896,0.9914529914529915,0.9914529914529915,0.9914529914529915,0.9912536443148688,0.9912536443148688,0.9912536443148688,0.9913544668587896,0.9913544668587896,0.9913544668587896,0.970873786,0.970873786,0.970873786,0.970873786,0.986547085,0.986547085,0.986547085,0.997134670487106,0.997134670487106,0.997134670487106,0.9975708502024292,0.9975708502024292,0.9975708502024292,0.9970326409495549,0.9970326409495549,0.9970326409495549,null,null],[0.05981613891726251,0.05981613891726251,0.2193258426966292,0.1993871297242084,0.01993871297242084,0,0.119632277834525,0.09969356486210419,0.1794484167517875,0.2791419816138918,0.2592032686414709,0,0.05981613891726251,0.2273764258555133,0.2076045627376426,0.06920152091254754,0.217490494296578,0.02965779467680608,0.217490494296578,0.6425855513307985,0.6623574144486692,0.3262357414448669,0.1977186311787072,0.108745247148289,0.2768060836501902,2.968,0.6902325581395349,0.7395348837209302,0.4634418604651163,0.5127441860465116,0.5324651162790698,0.1774883720930233,0.03944186046511628,0.3845581395348838,0.4437209302325582,0.276093023255814,0.571906976744186,0.1577674418604651,0.1577674418604651,0.1774883720930233,0,0.09860465116279071,0.03944186046511628,0.6902325581395349,0.8381395348837209,0.4831627906976744,0.571906976744186,0.4831627906976744,0.4634418604651163,0.6031460674157303,0.5438202247191012,0,1.255172413793104,0.5599999999999999,0.183448275862069,0.3475862068965517,0.7724137931034484,0.569655172413793,0.2093233082706767,0.1893877551020408,0.478453276047261,0.5695808383233533,0.4281545064377683,0.1991416309012876,0.448068669527897,0.4292682926829268,0.3317073170731707,0.5658536585365853,0.2536585365853659,0.1268292682926829,0.3024390243902439,0.3804878048780488,0.00975609756097561,0.8585365853658536,0.6374193548387097,0.225430463576159,0.8275862068965517,0.009885931558935362,0.6853146853146853,0.1591474245115453,0.1372903225806452,0.3138064516129032,3.572984293193717,0.1476439790575916,0.1870157068062827,0.6522352941176471,0.8301176470588235,0.5534117647058824,0.4150588235294118,1.972957746478873,0.2681690140845071,2.365633802816902,1.130140845070422,0.593050193050193,0.4546718146718147,0.5238610038610039,0.9186813186813186,0.1547252747252747,0.5772151898734177,0.3270886075949367,0.6637974683544303,0.9953488372093023,1.051162790697674,1.516279069767442,1.348085106382979,1.273191489361702,0.5428571428571429,0.1974025974025974,0,0.2072727272727273,0.1381818181818182,0.01969230769230769,0.2363076923076923,0.4923076923076923,0,0.1586478873239437,0.1883943661971831,0.05949295774647887,0.3668376068376069,0.465982905982906,0.4560683760683761,0.4758974358974359,0.1982708933717579,0.3073198847262248,0.18835734870317,0.2577521613832853,0.1288629737609329,0.1288629737609329,0.2478134110787172,0.0991253644314869,0.1685131195335277,0.1288629737609329,0.1883381924198251,0.03965014577259476,0.4261946902654867,0.455929203539823,0.3270796460176991,0.3568141592920354,0.455929203539823,0.4658407079646018,0.3865486725663717,0.495575221238938,0.1288358208955224,0.1288358208955224,0.02973134328358209,0.009910447761194031,0.3964179104477612,0.3567761194029851,0.3567761194029851,0.3369552238805971,0.0991549295774648,0.009915492957746479,0.1784788732394366,0.01983098591549296,0.2082051282051282,0.1090598290598291,0.1487179487179487,0.02974358974358974,0.4659365994236311,0.3767146974063401,0.3568876080691643,0.1487031700288184,0.1289014084507042,0.1090704225352113,0.267718309859155,0.03966197183098592,0.01982905982905983,0.07931623931623932,0.1685470085470086,0.06940170940170941,0.3073198847262248,0.06939481268011528,0.386628242074928,0.3370605187319885,0.009914529914529915,0.1388034188034188,0.09914529914529915,0.2776338028169014,0.1685633802816902,0.03966197183098592,0.08922190201729106,0.1685302593659943,0.18835734870317,0.07931623931623932,0.009914529914529915,0,0.1387755102040817,0.2379008746355685,0.3568513119533528,0.03965417867435159,0.287492795389049,0.2081844380403458,0.601941748,0.533980583,0.13592233,0.27184466,0.138116592,0.197309417,0.739910314,0.2592550143266475,0.2293409742120344,0.05982808022922636,0.05985425101214575,0.2693441295546559,0.1596113360323887,0.0199406528189911,0.08973293768545994,0.05982195845697329,null,null],[-0.3361526022755093,-0.3361526022755093,-0.495662306054876,-0.4757235930824552,-0.2962751763306676,-0.2763364633582468,-0.3959687411927718,-0.376030028220351,-0.4557848801100343,-0.5554784449721386,-0.5355397319997177,-0.2763364633582468,-0.3361526022755093,-0.2852756152541884,-0.3050474783720591,-0.4434505201971542,-0.2951615468131238,-0.5423098357865078,-0.7301425354062797,0.1299335102210968,0.1497053733389675,-0.1864162996648348,-0.3149334099309945,-0.6213972882579908,-0.789458124759892,-4.008764502632804,0.1435962609885875,0.1928985865699828,-0.08319443668583115,-0.0338921111044358,-0.01417118087187763,-0.6888198068714226,-0.5507732952435157,-0.9311944366858311,-0.1029153669183893,-0.8227293204067614,0.02527067959323859,-0.3535639929179343,-0.6690988766388645,-0.6888198068714226,-0.5113314347783994,-0.6099360859411901,-0.4718895743132831,0.1435962609885875,0.2583441860465117,-0.06347350645327299,0.02527067959323859,-0.06347350645327299,-0.08319443668583115,-1.115886725991484,0.03107956614334761,-0.5127406585757536,0.4088592372055968,-0.2202621956341284,-0.5968139197720594,-0.4326759887375766,-0.03046938244519426,-0.2106070232203353,-0.4856159789827256,-0.4656804258140897,-0.7547459467593098,-1.178253012625464,-0.7041507257863922,-0.4751378502499115,-0.724064888876521,-1.16985827888454,-0.4088826691284426,-1.306443644738199,-0.4618193637148219,-0.8423071685928707,-0.4130388759099439,-1.121077791079662,-0.7057218027392121,0.09365853658536594,-5.732744689068703e-05,-0.8329228501070487,-1.406896551724138,-0.4845094954077215,0.04889381645208268,-0.4573562983660414,-0.4705198454950733,-0.2940037164628152,2.66810240880642,-0.4311204188481675,-0.3917486910994764,0.07115294117647064,0.249035294117647,0.005562068449161517,-0.1327908727273091,-3.01812906236336,-0.5713327888483717,-3.476190300692278,0.2298754571449023,-1.067589178895323,-0.01986717117331555,-0.9983999897061342,-1.722824907378389,-0.6267618223148725,-1.46162573618139,-1.191165158886863,-1.548208014662403,-2.074001523244209,-2.145116279069767,-2.683732419104036,-2.449021276595745,0.1876537861818919,-1.054689760124911,-0.3144300198651707,-0.5118326172677681,-0.3045598899950408,-0.6500144354495863,-0.5655352285048647,-0.7821506131202494,-1.038150613120249,-0.388687323943662,-0.2300394366197183,-0.2002929577464788,-0.3291943661971831,-0.06768582509773691,0.03145947404756222,0.02154494413303232,0.04137400396209212,-0.236209358256328,-0.1271603669018612,-0.2461229029249159,-0.1767280902448006,-0.5632990379608921,-0.5632990379608921,-0.6822494752786764,-0.5335614286314461,-0.6029491837334868,-0.5632990379608921,-0.6227742566197842,-0.4740862099725539,-0.008196143735180406,0.02153836953915589,-0.107311187982968,-0.07757667470863178,0.02153836953915589,0.03144987396393462,-0.04784216143429543,0.06118438723827091,-0.3055087027816905,-0.3055087027816905,-0.4046131803936308,-0.4442549714384069,-0.03792661322945168,-0.07756840427422779,-0.07756840427422779,-0.09738929979661581,-0.4878422535211268,-0.3787718309859155,-0.2102084507042253,-0.368856338028169,-0.642728560140472,-0.5435832609951728,-0.5832413806532925,-0.4183931623931624,-0.900416851051717,-0.811194949034426,-0.7913678596972502,-0.5831834216569044,-0.5175887323943662,-0.4977577464788732,-0.7022839490244099,-0.4283492957746479,-0.4084786324786325,-0.3552071926191044,-0.6030704404823524,-0.5039251413370531,-0.7418001363543107,-0.5038750643082013,-0.821108493703014,-0.7715407703600745,-0.3787350427350428,-0.295720013131925,-0.5336687310806429,-0.1569318363483535,-0.2201239436619718,-0.4283492957746479,-0.523702153645377,-0.6030105109940802,-0.622837600331256,-0.3552071926191044,-0.3985641025641026,-0.3886495726495727,-0.5732115744040408,-0.6723369388355277,-0.7912873761533119,-0.4741344303024375,-0.7219730470171349,-0.6426646896684318,-1.338936636216737,-1.270975471216736,-0.5760823758574823,-0.4401600458574823,-0.3734744253738392,-0.7089004343738392,0.1929965133886056,-0.6501318051575931,-0.62021776504298,-0.4507048710601719,-0.3363667832658753,-0.5458566618083855,-0.1169011962213409,-0.3584152462411156,-0.4282075311075845,-0.2786526349651512,null,null],[0.2165203244409843,0.2165203244409843,0.05701062066161758,0.07694933363403841,0.256397750385826,0.2763364633582468,0.1567041855237218,0.1766428984961426,0.09688804660645928,-0.002805518255644956,0.01713319471677588,0.2763364633582468,0.2165203244409843,0.7400284669652151,0.7202566038473444,0.5818535620222492,0.7301425354062797,0.4829942464328957,0.2951615468131238,1.1552375924405,1.175009455558371,0.8388877825545686,0.710370672288409,0.4039067939614128,0.2358459574595116,-1.927235497367196,1.236868855290482,1.286171180871878,1.010078157616064,1.059380483197459,1.079101413430017,0.3338430626853761,0.4718895743132831,0.1620781576160636,0.9903572273835055,0.2705432738951334,1.118543273895134,0.6690988766388645,0.3535639929179343,0.3338430626853761,0.5113314347783994,0.4127267836156087,0.5507732952435157,1.236868855290482,1.41793488372093,1.029799087848622,1.118543273895134,1.029799087848622,1.010078157616064,-0.09040540883997672,1.056560883294855,0.5127406585757536,2.10148559038061,1.340262195634128,0.9637104714961973,1.12784840253068,1.575296968652091,1.349917368047922,0.06696936244137219,0.08690491561000807,-0.2021606053352121,0.03909133597875691,-0.1521582870891443,0.07685458844733639,-0.1720724501792731,0.3113216935186865,1.072297303274784,0.174736327665028,0.9691364368855536,0.5886486320075048,1.017916924690432,0.3601021813235645,0.7252339978611634,1.623414634146341,1.27489603712431,0.3820619229547308,-0.2482758620689655,0.4647376322898508,1.321735554177288,0.775651147389132,0.7451004906563636,0.9216166196886216,4.477866177581014,0.7264083769633508,0.7657801047120419,1.233317647058824,1.4112,1.101261460962603,0.9629085197861327,-0.927786430594387,1.107670817017386,-1.255077304941526,2.030406232995943,-0.1185112072050628,0.929210800516945,-0.0493220180158736,-0.1145377299842479,0.936212371765422,0.3071953564345545,0.5369879436969898,0.2206130779535419,0.08330384882560427,0.04279069767441857,-0.3488257204308478,-0.2471489361702126,2.358729192541513,-0.03102452558937485,0.7092352146703655,0.5118326172677681,0.7191053445404954,0.3736507990859499,0.5261506131202494,0.3095352285048647,0.0535352285048647,0.388687323943662,0.5473352112676056,0.5770816901408451,0.4481802816901408,0.8013610387729506,0.9005063379182497,0.8905918080037198,0.9104208678327796,0.6327511449998439,0.7418001363543107,0.622837600331256,0.6922324130113713,0.3055730904390263,0.3055730904390263,0.186622653121242,0.3353106997684723,0.2659229446664315,0.3055730904390263,0.2460978717801341,0.3947859184273644,0.8605855242661539,0.8903200375404902,0.7614704800183663,0.7912049932927026,0.8903200375404902,0.9002315419652689,0.8209395065670388,0.9299660552396052,0.5631803445727352,0.5631803445727352,0.4640758669607949,0.4244340759160188,0.8307624341249741,0.791120643080198,0.791120643080198,0.7712997475578099,0.2895323943661972,0.3986028169014084,0.5671661971830986,0.4085183098591549,0.2263183037302156,0.3254636028755147,0.2858054832173951,0.3589059829059829,-0.03145634779554513,0.0577655542217459,0.0775926435589217,0.2857770815992675,0.2597859154929577,0.2796169014084507,0.1668473293061,0.349025352112676,0.3688205128205129,0.5138396712515831,0.2659764233883352,0.3651217225336343,0.1271603669018612,0.3650854389479707,0.04785200955315799,0.09741973289609746,0.3985641025641026,0.5733268507387626,0.3353781327900446,0.7121994419821563,0.5572507042253521,0.349025352112676,0.3452583496107949,0.2659499922620917,0.2461229029249159,0.5138396712515831,0.3787350427350428,0.3886495726495727,0.2956605539958775,0.1965351895643906,0.07758475224660638,0.3948260729537344,0.146987456239037,0.2262958135877401,0.1350531402167365,0.2030143052167366,0.8479270358574823,0.9838493658574823,0.6497076093738393,0.3142816003738393,1.286824114611394,0.131621776504298,0.1615358166189112,0.3310487106017192,0.2166582812415838,0.00716840269907365,0.4361238682861183,0.3185339406031334,0.2487416557366646,0.3982965518790978,null,null]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Study_ID<\/th>\n      <th>effect_id<\/th>\n      <th>Description<\/th>\n      <th>type<\/th>\n      <th>g<\/th>\n      <th>var_g<\/th>\n      <th>Published<\/th>\n      <th>Authors<\/th>\n      <th>Year<\/th>\n      <th>design<\/th>\n      <th>mean_age<\/th>\n      <th>suicide_measure<\/th>\n      <th>reference<\/th>\n      <th>erp_scoring<\/th>\n      <th>n_suicide<\/th>\n      <th>n_control<\/th>\n      <th>suicide_group<\/th>\n      <th>control_group<\/th>\n      <th>scoring<\/th>\n      <th>erp description<\/th>\n      <th>mean_suicide<\/th>\n      <th>mean_control<\/th>\n      <th>sd_suicide<\/th>\n      <th>sd_control<\/th>\n      <th>N<\/th>\n      <th>r<\/th>\n      <th>t<\/th>\n      <th>F<\/th>\n      <th>OR<\/th>\n      <th>d<\/th>\n      <th>var_d<\/th>\n      <th>J<\/th>\n      <th>abs_g<\/th>\n      <th>lbci<\/th>\n      <th>ubci<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"pageLength":10,"columnDefs":[{"className":"dt-right","targets":[1,2,5,6,7,11,15,16,21,22,23,24,25,26,28,30,31,32,33,34,35]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false},"selection":{"mode":"multiple","selected":null,"target":"row","selectable":null}},"evals":[],"jsHooks":[]}</script>

## 单个脑电指标对应的研究问题

各个自杀类型的数据表

文献综述部分:

### LDAEP

``` r
ldaep_si_data <- meta_data %>%
  filter(type == "LDAEP" & Description == "ideation")# 3 effect sizes 2 studies. Meta analyze

ldaep_sa_data <- meta_data %>%
  filter(type == "LDAEP" & Description == "attempt")# 12 effect sizes, 5 studies. Meta analyze

ldaep_risk_data <- meta_data %>%
  filter(type == "LDAEP" & Description == "risk")# 3 effect sizes, 3 studies. Meta analyze

ldaep_sasi_data <- meta_data %>% 
  filter(type == "LDAEP" & suicide_group == 'SA' & control_group == 'SI')# 11 effect sizes, 4 studies meta analyze
```

#### LDAEP自杀想法分析

通过线性（混合效应）模型拟合多元/多水平固定和随机/混合效应模型的元分析函数
\[Examples\]<https://www.rdocumentation.org/packages/metafor/versions/2.4-0/topics/rma.mv>

``` r
ldaep_estimate <- rma.mv(yi = g ~ 1, #效应大小或结果
                         V = var_g, #方差
                         random = list(~ 1 | effect_id, ~ 1 | Study_ID), #模型的随机效果结构
                         data = ldaep_si_data,
                         method = "REML",  
                         slab = paste(paste(paste(Authors, Year, sep=", ("), ")", #带k结果/研究标签的可选向量
                                                              sep = ""), effect_id, sep = " "))

ldaep_robust <- robust(ldaep_estimate, cluster = ldaep_si_data$Study_ID,
                       adjust = TRUE) 
summary(ldaep_robust)# g = - 0.2720, p = 0.6803
## 
## Multivariate Meta-Analysis Model (k = 3; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -1.7512    3.5024    9.5024    5.5818   33.5024   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.2449  0.4948      3     no  effect_id 
## sigma^2.2  0.0051  0.0716      2     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 2) = 7.8197, p-val = 0.0200
## 
## Number of estimates:   3
## Number of clusters:    2
## Estimates per cluster: 1-2 (mean: 1.50, median: 1.5)
## 
## Model Results:
## 
## estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##  -0.1710  0.3113   -0.5491    1   0.6803   -4.1269   3.7849     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)
```

##### 计算模型异质性

``` r
W <- diag(1/ldaep_si_data$var_g)
X <- model.matrix(ldaep_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(ldaep_robust$sigma2) / (sum(ldaep_robust$sigma2) + (ldaep_robust$k-ldaep_robust$p)/sum(diag(P)))
## [1] 75.9573

#### 森林图
fig2a <- viz_forest(ldaep_robust, type = "study_only", variant = "classic", study_labels = ldaep_estimate[["slab"]], 
                    col = "#1e89c6", 
           text_size = 5, x_limit = c(-5.0, 4), x_breaks = c(-5, -4, -3, -2, -1, 0, 1, 2, 3, 4), 
           xlab = expression("Hedges' " * italic("g"))) + ggtitle("LDAEP")

summarydata <- data.frame("x.diamond" = c(ldaep_robust$ci.lb,
                                         coef(ldaep_robust),
                                         ldaep_robust$ci.ub,
                                          coef(ldaep_robust)),
                          "y.diamond" = c(nrow(ldaep_si_data) + 1,
                                          nrow(ldaep_si_data) + 1.3,
                                          nrow(ldaep_si_data) + 1,
                                          nrow(ldaep_si_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", ldaep_robust$slab)

fig2a <- fig2a + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                     color= "black", fill = "#1e89c6", 
                     size = 0.1) + scale_y_continuous(name = "",
                                                      breaks = c(4, 3, 2, 1), labels = ylabels)
```

#### LDAEP自杀行为分析

``` r
ldaep_estimate <- rma.mv(yi = g ~ 1,
                         V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                         data = ldaep_sa_data,
                         method = "REML", 
                         slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                            sep = ""), effect_id, sep = " "))

ldaep_robust <- robust(ldaep_estimate, cluster = ldaep_sa_data$Study_ID,
                       adjust = TRUE)
summary(ldaep_robust)# g = 0.021, p = 0.946
## 
## Multivariate Meta-Analysis Model (k = 12; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -9.7397   19.4795   25.4795   26.6731   28.9080   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0268  0.1637     12     no  effect_id 
## sigma^2.2  0.3253  0.5704      5     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 11) = 33.7853, p-val = 0.0004
## 
## Number of estimates:   12
## Number of clusters:    5
## Estimates per cluster: 1-8 (mean: 2.40, median: 1)
## 
## Model Results:
## 
## estimate      se¹    tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##   0.0208  0.2894   0.0718    4   0.9462   -0.7826   0.8241     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)
```

##### 计算模型异质性

``` r
W <- diag(1/ldaep_sa_data$var_g)
X <- model.matrix(ldaep_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(ldaep_robust$sigma2) / (sum(ldaep_robust$sigma2) + (ldaep_robust$k-ldaep_robust$p)/sum(diag(P)))
## [1] 70.65086

#### 森林图
fig3a <- viz_forest(ldaep_robust, type = "study_only", variant = "classic", study_labels = ldaep_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5) + ggtitle("LDAEP")

summarydata <- data.frame("x.diamond" = c(ldaep_robust$ci.lb,
                                          coef(ldaep_robust),
                                          ldaep_robust$ci.ub,
                                          coef(ldaep_robust)),
                          "y.diamond" = c(nrow(ldaep_sa_data) + 1,
                                          nrow(ldaep_sa_data) + 1.3,
                                          nrow(ldaep_sa_data) + 1,
                                          nrow(ldaep_sa_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", ldaep_robust$slab)
nrows <- nrow(ldaep_sa_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig3a <- fig3a + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)

fig3a
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/unnamed-chunk-20-1.png" width="672" />

##### LDAEP 发表偏倚

``` r
ldaep_weights <- weights(ldaep_robust)

ldaep_sa_data$weights <- ldaep_weights

ldaep_sa_data <- mutate(ldaep_sa_data, "sqrt_weights" = sqrt(weights))

ldaep_estimate <- rma.mv(yi = abs_g ~ sqrt_weights, 
                         V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID), 
                         data = ldaep_sa_data,
                         method = "REML")

ldaep_eggers <- robust(ldaep_estimate, cluster = ldaep_sa_data$Study_ID, 
                       adjust = TRUE)

summary(ldaep_eggers)# not significant
## 
## Multivariate Meta-Analysis Model (k = 12; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -4.2500    8.4999   16.4999   17.7103   24.4999   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000     12     no  effect_id 
## sigma^2.2  0.0049  0.0699      5     no   Study_ID 
## 
## Test for Residual Heterogeneity:
## QE(df = 10) = 7.8900, p-val = 0.6396
## 
## Number of estimates:   12
## Number of clusters:    5
## Estimates per cluster: 1-8 (mean: 2.40, median: 1)
## 
## Test of Moderators (coefficient 2):¹
## F(df1 = 1, df2 = 3) = 0.1963, p-val = 0.6877
## 
## Model Results:
## 
##               estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
## intrcpt         0.8323  0.6724    1.2377    3   0.3039   -1.3077   2.9722     
## sqrt_weights   -0.0910  0.2055   -0.4431    3   0.6877   -0.7450   0.5629     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t/F-tests and confidence intervals, df: residual method)
```

#### LDAEP自杀风险分析

``` r
ldaep_estimate <- rma.mv(yi = g ~ 1,
                         V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                         data = ldaep_risk_data,
                         method = "REML", 
                         slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                            sep = ""), effect_id, sep = " "))

ldaep_robust <- robust(ldaep_estimate, cluster = ldaep_risk_data$Study_ID,
                       adjust = TRUE)
summary(ldaep_robust)# g = 0.175, p = 0.552
## 
## Multivariate Meta-Analysis Model (k = 3; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -1.1538    2.3077    8.3077    4.3871   32.3077   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0421  0.2052      3     no  effect_id 
## sigma^2.2  0.0421  0.2052      3     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 2) = 3.7041, p-val = 0.1569
## 
## Number of estimates:   3
## Number of clusters:    3
## Estimates per cluster: 1
## 
## Model Results:
## 
## estimate      se¹    tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##   0.1752  0.2473   0.7086    2   0.5520   -0.8887   1.2391     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)
```

##### 计算模型异质性

``` r
W <- diag(1/ldaep_risk_data$var_g)
X <- model.matrix(ldaep_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(ldaep_robust$sigma2) / (sum(ldaep_robust$sigma2) + (ldaep_robust$k-ldaep_robust$p)/sum(diag(P)))
## [1] 45.91443
```

##### 森林图

``` r
fig4a <- viz_forest(ldaep_robust, type = "study_only", variant = "classic", study_labels = ldaep_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5, x_limit = c(-2.0, 2.0)) + ggtitle("LDAEP")

summarydata <- data.frame("x.diamond" = c(ldaep_robust$ci.lb,
                                          coef(ldaep_robust),
                                          ldaep_robust$ci.ub,
                                          coef(ldaep_robust)),
                          "y.diamond" = c(nrow(ldaep_risk_data) + 1,
                                          nrow(ldaep_risk_data) + 1.3,
                                          nrow(ldaep_risk_data) + 1,
                                          nrow(ldaep_risk_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", ldaep_robust$slab)
nrows <- nrow(ldaep_risk_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig4a <- fig4a + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)

fig4a
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/fig4a-1.png" width="672" />

#### LDAEP 自杀行为和自杀想法对比分析SA vs. SI analysis

``` r
ldaep_estimate <- rma.mv(yi = g ~ 1,
                         V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                         data = ldaep_sasi_data,
                         method = "REML",  
                         slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                            sep = ""), effect_id, sep = " "))

ldaep_robust <- robust(ldaep_estimate, cluster = ldaep_sasi_data$Study_ID,
                       adjust = TRUE)
summary(ldaep_robust)# g = 0.168, p = 0.648
## 
## Multivariate Meta-Analysis Model (k = 11; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -8.7345   17.4690   23.4690   24.3768   27.4690   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0189  0.1375     11     no  effect_id 
## sigma^2.2  0.3545  0.5954      4     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 10) = 31.4932, p-val = 0.0005
## 
## Number of estimates:   11
## Number of clusters:    4
## Estimates per cluster: 1-8 (mean: 2.75, median: 1)
## 
## Model Results:
## 
## estimate      se¹    tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##   0.1684  0.3333   0.5053    3   0.6481   -0.8924   1.2292     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)
```

##### 计算模型异质性

``` r
W <- diag(1/ldaep_sasi_data$var_g)
X <- model.matrix(ldaep_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(ldaep_robust$sigma2) / (sum(ldaep_robust$sigma2) + (ldaep_robust$k-ldaep_robust$p)/sum(diag(P)))
## [1] 69.17195
#69.17%
```

##### 森林图

``` r
fig5a <- viz_forest(ldaep_robust, type = "study_only", variant = "classic", study_labels = ldaep_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5) + ggtitle("LDAEP")

summarydata <- data.frame("x.diamond" = c(ldaep_robust$ci.lb,
                                          coef(ldaep_robust),
                                          ldaep_robust$ci.ub,
                                          coef(ldaep_robust)),
                          "y.diamond" = c(nrow(ldaep_sasi_data) + 1,
                                          nrow(ldaep_sasi_data) + 1.3,
                                          nrow(ldaep_sasi_data) + 1,
                                          nrow(ldaep_sasi_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", ldaep_robust$slab)
nrows <- nrow(ldaep_sasi_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig5a <- fig5a + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)



fig5a
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/fig5a-1.png" width="672" />

##### LDAEP 自杀行为和自杀想法发表偏倚

``` r
ldaep_weights <- weights(ldaep_robust)

ldaep_sasi_data$weights <- ldaep_weights

ldaep_sasi_data <- mutate(ldaep_sasi_data, "sqrt_weights" = sqrt(weights))

ldaep_estimate <- rma.mv(yi = abs_g ~ sqrt_weights, 
                         V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID), 
                         data = ldaep_sasi_data,
                         method = "REML")

ldaep_eggers <- robust(ldaep_estimate, cluster = ldaep_sasi_data$Study_ID, 
                       adjust = TRUE)

summary(ldaep_eggers)# not significant
## 
## Multivariate Meta-Analysis Model (k = 11; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -4.4588    8.9177   16.9177   17.7066   26.9177   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000     11     no  effect_id 
## sigma^2.2  0.0830  0.2882      4     no   Study_ID 
## 
## Test for Residual Heterogeneity:
## QE(df = 9) = 7.8005, p-val = 0.5544
## 
## Number of estimates:   11
## Number of clusters:    4
## Estimates per cluster: 1-8 (mean: 2.75, median: 1)
## 
## Test of Moderators (coefficient 2):¹
## F(df1 = 1, df2 = 2) = 2.6015, p-val = 0.2481
## 
## Model Results:
## 
##               estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
## intrcpt         1.4494  0.7603    1.9063    2   0.1969   -1.8220   4.7208     
## sqrt_weights   -0.3228  0.2001   -1.6129    2   0.2481   -1.1840   0.5383     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t/F-tests and confidence intervals, df: residual method)
```

### LPP

``` r
lpp_si_data <- meta_data %>%
  filter(type == "LPP" & Description == "ideation")# 34 effect sizes, 3 studies. Meta analyze

lpp_sa_data <- meta_data %>%
  filter(type == "LPP" & Description == "attempt")# 1 study, 3 effect sizes. Meta analyze

lpp_risk_data <- meta_data %>%
  filter(type == "LPP" & Description == "risk")# 9 effect sizes, 2 studies. Meta analyze

lpp_sasi_data <- meta_data %>% 
  filter(type == "LPP" & suicide_group == 'SA' & control_group == 'SI')# Same effects as SA LPP dataset
```

#### LPP 自杀想法分析

``` r
lpp_estimate <- rma.mv(yi = g ~ 1,
                       V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                       data = lpp_si_data,
                       method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                           sep = ""), effect_id, sep = " "))

lpp_robust <- robust(lpp_estimate, cluster = lpp_si_data$Study_ID,
                     adjust = TRUE)
summary(lpp_robust)# g = -0.053, p = 0.407
## 
## Multivariate Meta-Analysis Model (k = 34; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##   8.7019  -17.4037  -11.4037   -6.9142  -10.5762   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000     34     no  effect_id 
## sigma^2.2  0.0042  0.0647      3     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 33) = 25.4920, p-val = 0.8216
## 
## Number of estimates:   34
## Number of clusters:    3
## Estimates per cluster: 9-13 (mean: 11.33, median: 12)
## 
## Model Results:
## 
## estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##  -0.0528  0.0507   -1.0412    2   0.4071   -0.2708   0.1652     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)
```

##### 计算模型异质性

``` r
W <- diag(1/lpp_si_data$var_g)
X <- model.matrix(lpp_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(lpp_robust$sigma2) / (sum(lpp_robust$sigma2) + (lpp_robust$k-lpp_robust$p)/sum(diag(P)))
## [1] 10.72721
#10.73%
```

##### 森林图

``` r
fig2b <- viz_forest(lpp_robust, type = "study_only", variant = "classic", study_labels = ldaep_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5) + ggtitle("LPP")

summarydata <- data.frame("x.diamond" = c(lpp_robust$ci.lb,
                                          coef(lpp_robust),
                                          lpp_robust$ci.ub,
                                          coef(lpp_robust)),
                          "y.diamond" = c(nrow(lpp_si_data) + 1,
                                          nrow(lpp_si_data) + 1.3,
                                          nrow(lpp_si_data) + 1,
                                          nrow(lpp_si_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", lpp_robust$slab)
nrows <- nrow(lpp_si_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig2b <- fig2b + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "", breaks = ybreaks, labels = ylabels)
fig2b
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/fig2b-1.png" width="672" />

##### LPP 自杀想法发表偏倚

``` r
lpp_weights <- weights(lpp_robust)

lpp_si_data$weights <- lpp_weights

lpp_si_data <- mutate(lpp_si_data, "sqrt_weights" = sqrt(weights))

lpp_estimate <- rma.mv(yi = abs_g ~ sqrt_weights, 
                         V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID), 
                         data = lpp_si_data,
                         method = "REML")

lpp_eggers <- robust(lpp_estimate, cluster = lpp_si_data$Study_ID, 
                       adjust = TRUE)

summary(lpp_eggers)# not significant
## 
## Multivariate Meta-Analysis Model (k = 34; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  14.1673  -28.3345  -20.3345  -14.4716  -18.8530   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000     34     no  effect_id 
## sigma^2.2  0.0089  0.0945      3     no   Study_ID 
## 
## Test for Residual Heterogeneity:
## QE(df = 32) = 13.2074, p-val = 0.9986
## 
## Number of estimates:   34
## Number of clusters:    3
## Estimates per cluster: 9-13 (mean: 11.33, median: 12)
## 
## Test of Moderators (coefficient 2):¹
## F(df1 = 1, df2 = 1) = 2.3959, p-val = 0.3652
## 
## Model Results:
## 
##               estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
## intrcpt         0.4133  0.1839    2.2477    1   0.2665   -1.9231   2.7496     
## sqrt_weights   -0.1492  0.0964   -1.5479    1   0.3652   -1.3742   1.0758     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t/F-tests and confidence intervals, df: residual method)
```

#### LPP 自杀风险分析

``` r
lpp_estimate <- rma.mv(yi = g ~ 1,
                       V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                       data = lpp_risk_data,
                       method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                           sep = ""), effect_id, sep = " "))


lpp_robust <- robust(lpp_estimate, cluster = lpp_risk_data$Study_ID,
                     adjust = TRUE)
summary(lpp_robust)# g = -0.290, p = 0.157
## 
## Multivariate Meta-Analysis Model (k = 9; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##   3.5727   -7.1455   -1.1455   -0.9072    4.8545   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000      9     no  effect_id 
## sigma^2.2  0.0034  0.0583      2     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 8) = 4.6603, p-val = 0.7932
## 
## Number of estimates:   9
## Number of clusters:    2
## Estimates per cluster: 3-6 (mean: 4.50, median: 4.5)
## 
## Model Results:
## 
## estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##  -0.2903  0.0731   -3.9721    1   0.1570   -1.2191   0.6384     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)

W <- diag(1/lpp_risk_data$var_g)
X <- model.matrix(lpp_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(lpp_robust$sigma2) / (sum(lpp_robust$sigma2) + (lpp_robust$k-lpp_robust$p)/sum(diag(P)))
## [1] 9.133936
#9.15%
```

##### 森林图

``` r
fig4b <- viz_forest(lpp_robust, type = "study_only", variant = "classic", study_labels = lpp_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5, x_limit = c(-1.5, 1.0)) + ggtitle("LPP")

summarydata <- data.frame("x.diamond" = c(lpp_robust$ci.lb,
                                          coef(lpp_robust),
                                          lpp_robust$ci.ub,
                                          coef(lpp_robust)),
                          "y.diamond" = c(nrow(lpp_risk_data) + 1,
                                          nrow(lpp_risk_data) + 1.3,
                                          nrow(lpp_risk_data) + 1,
                                          nrow(lpp_risk_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", lpp_robust$slab)
nrows <- nrow(lpp_risk_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig4b <- fig4b + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)



fig4b
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/unnamed-chunk-32-1.png" width="672" />

### P3

``` r
p3_si_data <- meta_data %>%
  filter(type == "P3" & Description == "ideation")# 53 effect sizes, 3 studies. meta analyze

p3_sa_data <- meta_data %>%
  filter(type == "P3" & Description == "attempt")# 15 effect sizes, 6 studies. Meta analyze

p3_risk_data <- meta_data %>%
  filter(type == "P3" & Description == "risk")# 28 effect sizes, 3 studies. meta analyze

p3_sasi_data <- meta_data %>% 
  filter(type == "P3" & suicide_group == 'SA' & control_group == 'SI')# 10 effect sizes, 3 studies. meta analyze
```

#### P3 自杀想法分析

``` r
p3_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = p3_si_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

p3_robust <- robust(p3_estimate, cluster = p3_si_data$Study_ID,
                    adjust = TRUE)
summary(p3_robust)# g = 0.067, p = 0.827
## 
## Multivariate Meta-Analysis Model (k = 53; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -4.9396    9.8793   15.8793   21.7330   16.3793   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0102  0.1008     53     no  effect_id 
## sigma^2.2  0.1901  0.4360      3     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 52) = 86.9560, p-val = 0.0017
## 
## Number of estimates:   53
## Number of clusters:    3
## Estimates per cluster: 1-40 (mean: 17.67, median: 12)
## 
## Model Results:
## 
## estimate      se¹    tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##   0.0668  0.2683   0.2491    2   0.8265   -1.0876   1.2213     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)
```

``` r
W <- diag(1/p3_si_data$var_g)
X <- model.matrix(p3_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(p3_robust$sigma2) / (sum(p3_robust$sigma2) + (p3_robust$k-p3_robust$p)/sum(diag(P)))
## [1] 79.75051
#79.75
```

##### 森林图

``` r
fig2c <- viz_forest(p3_robust, type = "study_only", variant = "classic", study_labels = p3_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 3.5, x_limit = c(-2, 2)) + ggtitle("P300")

summarydata <- data.frame("x.diamond" = c(p3_robust$ci.lb,
                                          coef(p3_robust),
                                          p3_robust$ci.ub,
                                          coef(p3_robust)),
                          "y.diamond" = c(nrow(p3_si_data) + 1,
                                          nrow(p3_si_data) + 1.3,
                                          nrow(p3_si_data) + 1,
                                          nrow(p3_si_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", p3_robust$slab)
nrows <- nrow(p3_si_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig2c <- fig2c + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)



fig2c
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/unnamed-chunk-36-1.png" width="672" />

##### P3 自杀想法发表偏倚

``` r
p3_weights <- weights(p3_robust)

p3_si_data$weights <- p3_weights

p3_si_data <- mutate(p3_si_data, "sqrt_weights" = sqrt(weights))

p3_estimate <- rma.mv(yi = abs_g ~ sqrt_weights, 
                       V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID), 
                       data = p3_si_data,
                       method = "REML")

p3_eggers <- robust(p3_estimate, cluster = p3_si_data$Study_ID, 
                     adjust = TRUE)

summary(p3_eggers)# not significant
## 
## Multivariate Meta-Analysis Model (k = 53; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  19.0048  -38.0096  -30.0096  -22.2823  -29.1401   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000     53     no  effect_id 
## sigma^2.2  0.0000  0.0000      3     no   Study_ID 
## 
## Test for Residual Heterogeneity:
## QE(df = 51) = 18.9016, p-val = 1.0000
## 
## Number of estimates:   53
## Number of clusters:    3
## Estimates per cluster: 1-40 (mean: 17.67, median: 12)
## 
## Test of Moderators (coefficient 2):¹
## F(df1 = 1, df2 = 1) = 12.4001, p-val = 0.1761
## 
## Model Results:
## 
##               estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
## intrcpt         1.5159  0.3666    4.1354    1   0.1510   -3.1418   6.1737     
## sqrt_weights   -0.9029  0.2564   -3.5214    1   0.1761   -4.1610   2.3551     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t/F-tests and confidence intervals, df: residual method)
```

``` r
###P3 SA Analysis
p3_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = p3_sa_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

p3_robust <- robust(p3_estimate, cluster = p3_sa_data$Study_ID,
                    adjust = TRUE)
summary(p3_robust)# g = 0.067, p = 0.827
## 
## Multivariate Meta-Analysis Model (k = 15; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
## -21.1207   42.2414   48.2414   50.1586   50.6414   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.6273  0.7920     15     no  effect_id 
## sigma^2.2  0.7297  0.8542      6     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 14) = 99.2172, p-val < .0001
## 
## Number of estimates:   15
## Number of clusters:    6
## Estimates per cluster: 1-6 (mean: 2.50, median: 2)
## 
## Model Results:
## 
## estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##  -0.1176  0.4376   -0.2688    5   0.7988   -1.2426   1.0073     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)
```

#### P3 自杀行为分析

``` r
W <- diag(1/p3_sa_data$var_g)
X <- model.matrix(p3_robust)
# dim(W)
# dim(X)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W 
100 * sum(p3_robust$sigma2) / (sum(p3_robust$sigma2) + (p3_robust$k-p3_robust$p)/sum(diag(P)))
## [1] 93.96522
#93.97
```

##### 森林图

``` r
fig3b <- viz_forest(p3_robust, type = "study_only", variant = "classic", study_labels = p3_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5) + ggtitle("P300")

summarydata <- data.frame("x.diamond" = c(p3_robust$ci.lb,
                                          coef(p3_robust),
                                          p3_robust$ci.ub,
                                          coef(p3_robust)),
                          "y.diamond" = c(nrow(p3_sa_data) + 1,
                                          nrow(p3_sa_data) + 1.3,
                                          nrow(p3_sa_data) + 1,
                                          nrow(p3_sa_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", p3_robust$slab)
nrows <- nrow(p3_sa_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig3b <- fig3b + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)
fig3b
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/unnamed-chunk-40-1.png" width="672" />

##### P3 自杀行为发表偏倚

``` r
p3_weights <- weights(p3_robust)

p3_sa_data$weights <- p3_weights

p3_sa_data <- mutate(p3_sa_data, "sqrt_weights" = sqrt(weights))

p3_estimate <- rma.mv(yi = abs_g ~ sqrt_weights, 
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID), 
                      data = p3_sa_data,
                      method = "REML")

p3_eggers <- robust(p3_estimate, cluster = p3_sa_data$Study_ID, 
                    adjust = TRUE)

summary(p3_eggers)# not significant
## 
## Multivariate Meta-Analysis Model (k = 15; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
## -14.9962   29.9924   37.9924   40.2522   42.9924   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.3931  0.6270     15     no  effect_id 
## sigma^2.2  0.0000  0.0000      6     no   Study_ID 
## 
## Test for Residual Heterogeneity:
## QE(df = 13) = 50.0195, p-val < .0001
## 
## Number of estimates:   15
## Number of clusters:    6
## Estimates per cluster: 1-6 (mean: 2.50, median: 2)
## 
## Test of Moderators (coefficient 2):¹
## F(df1 = 1, df2 = 4) = 7.1581, p-val = 0.0555
## 
## Model Results:
## 
##               estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
## intrcpt         4.9537  1.7385    2.8494    4   0.0464    0.1269   9.7805   * 
## sqrt_weights   -1.6711  0.6246   -2.6755    4   0.0555   -3.4053   0.0631   . 
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t/F-tests and confidence intervals, df: residual method)
```

#### P3 自杀风险分析

``` r
p3_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = p3_risk_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

p3_robust <- robust(p3_estimate, cluster = p3_risk_data$Study_ID,
                    adjust = TRUE)
summary(p3_robust)# g = 0.2497, p = .3218
## 
## Multivariate Meta-Analysis Model (k = 28; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -8.3112   16.6225   22.6225   26.5100   23.6659   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0325  0.1802     28     no  effect_id 
## sigma^2.2  0.0819  0.2863      3     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 27) = 49.7129, p-val = 0.0049
## 
## Number of estimates:   28
## Number of clusters:    3
## Estimates per cluster: 2-20 (mean: 9.33, median: 6)
## 
## Model Results:
## 
## estimate      se¹    tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##   0.2497  0.1913   1.3052    2   0.3218   -0.5733   1.0727     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)

W <- diag(1/p3_risk_data$var_g)
X <- model.matrix(p3_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(p3_robust$sigma2) / (sum(p3_robust$sigma2) + (p3_robust$k-p3_robust$p)/sum(diag(P)))
## [1] 65.09046
#65.09
```

##### 森林图

``` r
fig4c <- viz_forest(p3_robust, type = "study_only", variant = "classic", study_labels = p3_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5) + ggtitle("P300")

summarydata <- data.frame("x.diamond" = c(p3_robust$ci.lb,
                                          coef(p3_robust),
                                          p3_robust$ci.ub,
                                          coef(p3_robust)),
                          "y.diamond" = c(nrow(p3_risk_data) + 1,
                                          nrow(p3_risk_data) + 1.3,
                                          nrow(p3_risk_data) + 1,
                                          nrow(p3_risk_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", p3_robust$slab)
nrows <- nrow(p3_risk_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig4c <- fig4c + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)



fig4c
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/unnamed-chunk-43-1.png" width="672" />

##### P3 自杀风险发表偏倚

``` r
p3_weights <- weights(p3_robust)

p3_risk_data$weights <- p3_weights

p3_risk_data <- mutate(p3_risk_data, "sqrt_weights" = sqrt(weights))

p3_estimate <- rma.mv(yi = abs_g ~ sqrt_weights, 
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID), 
                      data = p3_risk_data,
                      method = "REML")

p3_eggers <- robust(p3_estimate, cluster = p3_risk_data$Study_ID, 
                    adjust = TRUE)

summary(p3_eggers)# not significant
## 
## Multivariate Meta-Analysis Model (k = 28; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##   5.0604  -10.1208   -2.1208    2.9116   -0.2160   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000     28     no  effect_id 
## sigma^2.2  0.0275  0.1658      3     no   Study_ID 
## 
## Test for Residual Heterogeneity:
## QE(df = 26) = 12.4925, p-val = 0.9880
## 
## Number of estimates:   28
## Number of clusters:    3
## Estimates per cluster: 2-20 (mean: 9.33, median: 6)
## 
## Test of Moderators (coefficient 2):¹
## F(df1 = 1, df2 = 1) = 0.7988, p-val = 0.5357
## 
## Model Results:
## 
##               estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
## intrcpt         0.8278  0.6372    1.2990    1   0.4177   -7.2689   8.9244     
## sqrt_weights   -0.2799  0.3132   -0.8937    1   0.5357   -4.2598   3.6999     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t/F-tests and confidence intervals, df: residual method)
```

#### P3 自杀行为和ideation对比分析SA vs. SI

``` r
p3_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = p3_sasi_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

p3_robust <- robust(p3_estimate, cluster = p3_sasi_data$Study_ID,
                    adjust = TRUE)
summary(p3_robust)# g = -0.40, p = 0.6422
## 
## Multivariate Meta-Analysis Model (k = 10; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -3.5351    7.0703   13.0703   13.6620   17.8703   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000     10     no  effect_id 
## sigma^2.2  1.5104  1.2290      3     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 9) = 29.8420, p-val = 0.0005
## 
## Number of estimates:   10
## Number of clusters:    3
## Estimates per cluster: 1-6 (mean: 3.33, median: 3)
## 
## Model Results:
## 
## estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##  -0.3963  0.7313   -0.5419    2   0.6422   -3.5429   2.7503     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)

W <- diag(1/p3_sasi_data$var_g)
X <- model.matrix(p3_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(p3_robust$sigma2) / (sum(p3_robust$sigma2) + (p3_robust$k-p3_robust$p)/sum(diag(P)))
## [1] 95.05472
#93.06
```

##### 森林图

``` r
fig5b <- viz_forest(p3_robust, type = "study_only", variant = "classic", study_labels = p3_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5, x_limit = c(-4, 3)) + ggtitle("P300")

summarydata <- data.frame("x.diamond" = c(p3_robust$ci.lb,
                                          coef(p3_robust),
                                          p3_robust$ci.ub,
                                          coef(p3_robust)),
                          "y.diamond" = c(nrow(p3_sasi_data) + 1,
                                          nrow(p3_sasi_data) + 1.3,
                                          nrow(p3_sasi_data) + 1,
                                          nrow(p3_sasi_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", p3_robust$slab)
nrows <- nrow(p3_sasi_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))


fig5b <- fig5b + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)



fig5b
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/unnamed-chunk-46-1.png" width="672" />

##### P300 SA vs. SI -only 发表偏倚

``` r
p3_weights <- weights(p3_robust)

p3_sasi_data$weights <- p3_weights

p3_sasi_data <- mutate(p3_sasi_data, "sqrt_weights" = sqrt(weights))

p3_estimate <- rma.mv(yi = abs_g ~ sqrt_weights, 
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID), 
                      data = p3_sasi_data,
                      method = "REML")

p3_eggers <- robust(p3_estimate, cluster = p3_sasi_data$Study_ID, 
                    adjust = TRUE)

summary(p3_eggers)# Significant 发表偏倚
## 
## Multivariate Meta-Analysis Model (k = 10; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##   2.3371   -4.6741    3.3259    3.6437   16.6592   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000     10     no  effect_id 
## sigma^2.2  0.0000  0.0000      3     no   Study_ID 
## 
## Test for Residual Heterogeneity:
## QE(df = 8) = 1.3597, p-val = 0.9948
## 
## Number of estimates:   10
## Number of clusters:    3
## Estimates per cluster: 1-6 (mean: 3.33, median: 3)
## 
## Test of Moderators (coefficient 2):¹
## F(df1 = 1, df2 = 1) = 931.0215, p-val = 0.0209
## 
## Model Results:
## 
##               estimate      se¹      tval¹  df¹    pval¹    ci.lb¹    ci.ub¹    
## intrcpt         2.5049  0.0739    33.9022    1   0.0188    1.5661    3.4437   * 
## sqrt_weights   -0.6621  0.0217   -30.5126    1   0.0209   -0.9379   -0.3864   * 
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t/F-tests and confidence intervals, df: residual method)
```

### RewP

``` r
rewp_si_data <- meta_data %>%
  filter(type == "RewP" & Description == "ideation")# 12 effect sizes, 3 studies. Meta analyze

rewp_sa_data <- meta_data %>%
  filter(type == "RewP" & Description == "attempt")# 5 effect sizes, 2 studies. Meta analyze

rewp_risk_data <- meta_data %>%
  filter(type == "RewP" & Description == "risk")# 3 effect sizes, 1 study. Narrative review only 

rewp_sasi_data <- meta_data %>% 
  filter(type == "RewP" & suicide_group == 'SA' & control_group == 'SI')# 0 effect sizes
```

#### RewP SI Analysis

``` r
rewp_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = rewp_si_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

rewp_robust <- robust(rewp_estimate, cluster = rewp_si_data$Study_ID,
                    adjust = TRUE)
summary(rewp_robust)# g = -0.06, p = .0406
## 
## Multivariate Meta-Analysis Model (k = 18; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##   1.9073   -3.8147    2.1853    4.6850    4.0315   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0018  0.0423     18     no  effect_id 
## sigma^2.2  0.0000  0.0000      3     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 17) = 17.8590, p-val = 0.3978
## 
## Number of estimates:   18
## Number of clusters:    3
## Estimates per cluster: 3-9 (mean: 6.00, median: 6)
## 
## Model Results:
## 
## estimate      se¹     tval¹  df¹    pval¹    ci.lb¹    ci.ub¹    
##  -0.0618  0.0128   -4.8109    2   0.0406   -0.1171   -0.0065   * 
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)

W <- diag(1/rewp_si_data$var_g)
X <- model.matrix(rewp_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(rewp_robust$sigma2) / (sum(rewp_robust$sigma2) + (rewp_robust$k-rewp_robust$p)/sum(diag(P)))
## [1] 4.292889
#4.29%
```

##### 森林图

``` r
fig2d <- viz_forest(rewp_robust, type = "study_only", variant = "classic", study_labels = rewp_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5) + ggtitle("RewP")

summarydata <- data.frame("x.diamond" = c(rewp_robust$ci.lb,
                                          coef(rewp_robust),
                                          rewp_robust$ci.ub,
                                          coef(rewp_robust)),
                          "y.diamond" = c(nrow(rewp_si_data) + 1,
                                          nrow(rewp_si_data) + 1.3,
                                          nrow(rewp_si_data) + 1,
                                          nrow(rewp_si_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", rewp_robust$slab)
nrows <- nrow(rewp_si_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig2d <- fig2d + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)

fig2d
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/unnamed-chunk-50-1.png" width="672" />

##### RewP SI 发表偏倚

``` r
rewp_weights <- weights(rewp_robust)

rewp_si_data$weights <- rewp_weights

rewp_si_data <- mutate(rewp_si_data, "sqrt_weights" = sqrt(weights))

rewp_estimate <- rma.mv(yi = abs_g ~ sqrt_weights, 
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID), 
                      data = rewp_si_data,
                      method = "REML")

rewp_eggers <- robust(rewp_estimate, cluster = rewp_si_data$Study_ID, 
                    adjust = TRUE)

summary(rewp_eggers)# not significant
## 
## Multivariate Meta-Analysis Model (k = 18; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##   5.7299  -11.4597   -3.4597   -0.3694    0.1766   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0002     18     no  effect_id 
## sigma^2.2  0.0045  0.0672      3     no   Study_ID 
## 
## Test for Residual Heterogeneity:
## QE(df = 16) = 8.7320, p-val = 0.9240
## 
## Number of estimates:   18
## Number of clusters:    3
## Estimates per cluster: 3-9 (mean: 6.00, median: 6)
## 
## Test of Moderators (coefficient 2):¹
## F(df1 = 1, df2 = 1) = 0.1164, p-val = 0.7907
## 
## Model Results:
## 
##               estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
## intrcpt         0.2377  0.2787    0.8529    1   0.5504   -3.3034   3.7788     
## sqrt_weights   -0.0297  0.0871   -0.3411    1   0.7907   -1.1360   1.0766     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t/F-tests and confidence intervals, df: residual method)
```

#### RewP SA Analysis

``` r
rewp_estimate <- rma.mv(yi = g ~ 1,
                        V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                        data = rewp_sa_data,
                        method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                            sep = ""), effect_id, sep = " "))

rewp_robust <- robust(rewp_estimate, cluster = rewp_sa_data$Study_ID,
                      adjust = TRUE)
summary(rewp_robust)# g = -0.12, p = .5449
## 
## Multivariate Meta-Analysis Model (k = 5; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -0.2678    0.5356    6.5356    4.6945   30.5356   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.0000  0.0000      5     no  effect_id 
## sigma^2.2  0.0103  0.1017      2     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 4) = 3.6636, p-val = 0.4534
## 
## Number of estimates:   5
## Number of clusters:    2
## Estimates per cluster: 2-3 (mean: 2.50, median: 2.5)
## 
## Model Results:
## 
## estimate      se¹     tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##  -0.1220  0.1405   -0.8680    1   0.5449   -1.9073   1.6633     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)

W <- diag(1/rewp_sa_data$var_g)
X <- model.matrix(rewp_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(rewp_robust$sigma2) / (sum(rewp_robust$sigma2) + (rewp_robust$k-rewp_robust$p)/sum(diag(P)))
## [1] 12.32767
#12.33%
```

##### 森林图

``` r
fig3c <- viz_forest(rewp_robust, type = "study_only", variant = "classic", study_labels = rewp_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5, x_limit = c(-2.25, 2)) + ggtitle("RewP")

summarydata <- data.frame("x.diamond" = c(rewp_robust$ci.lb,
                                          coef(rewp_robust),
                                          rewp_robust$ci.ub,
                                          coef(rewp_robust)),
                          "y.diamond" = c(nrow(rewp_sa_data) + 1,
                                          nrow(rewp_sa_data) + 1.3,
                                          nrow(rewp_sa_data) + 1,
                                          nrow(rewp_sa_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", rewp_robust$slab)
nrows <- nrow(rewp_sa_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig3c <- fig3c + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)



fig3c
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/unnamed-chunk-53-1.png" width="672" />

### CNV

``` r
cnv_si_data <- meta_data %>%
  filter(type == "CNV" & Description == "ideation")# 3 effect sizes, 1 study. review only 

cnv_sa_data <- meta_data %>%
  filter(type == "CNV" & Description == "attempt")# 4 effect sizes, 4 studies. Meta analyze

cnv_risk_data <- meta_data %>%
  filter(type == "CNV" & Description == "risk")# no effects

cnv_sasi_data <- meta_data %>% 
  filter(type == "CNV" & suicide_group == 'SA' & control_group == 'SI')# 1 effect sizes
```

#### CNV SA Analysis

``` r
cnv_estimate <- rma.mv(yi = g ~ 1,
                        V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                        data = cnv_sa_data,
                        method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                            sep = ""), effect_id, sep = " "))

cnv_robust <- robust(cnv_estimate, cluster = cnv_sa_data$Study_ID,
                      adjust = TRUE)
summary(cnv_robust)# g = 0.44, p = 0.4157
## 
## Multivariate Meta-Analysis Model (k = 4; method: REML)
## 
##   logLik  Deviance       AIC       BIC      AICc   
##  -3.8657    7.7314   13.7314   11.0273   37.7314   
## 
## Variance Components:
## 
##             estim    sqrt  nlvls  fixed     factor 
## sigma^2.1  0.3115  0.5582      4     no  effect_id 
## sigma^2.2  0.3115  0.5582      4     no   Study_ID 
## 
## Test for Heterogeneity:
## Q(df = 3) = 17.7785, p-val = 0.0005
## 
## Number of estimates:   4
## Number of clusters:    4
## Estimates per cluster: 1
## 
## Model Results:
## 
## estimate      se¹    tval¹  df¹    pval¹    ci.lb¹   ci.ub¹    
##   0.4125  0.4378   0.9421    3   0.4157   -0.9809   1.8059     
## 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## 1) results based on cluster-robust inference (var-cov estimator: CR1,
##    approx t-test and confidence interval, df: residual method)

W <- diag(1/cnv_sa_data$var_g)
X <- model.matrix(cnv_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(cnv_robust$sigma2) / (sum(cnv_robust$sigma2) + (cnv_robust$k-cnv_robust$p)/sum(diag(P)))
## [1] 84.45113
#84.45%
```

##### 森林图

``` r
fig3d <- viz_forest(cnv_robust, type = "study_only", variant = "classic", study_labels = cnv_estimate[["slab"]], 
                    col = "#1e89c6", xlab = expression("Hedges' " * italic("g")), 
                    text_size = 5) + ggtitle("CNV")

summarydata <- data.frame("x.diamond" = c(cnv_robust$ci.lb,
                                          coef(cnv_robust),
                                          cnv_robust$ci.ub,
                                          coef(cnv_robust)),
                          "y.diamond" = c(nrow(cnv_sa_data) + 1,
                                          nrow(cnv_sa_data) + 1.3,
                                          nrow(cnv_sa_data) + 1,
                                          nrow(cnv_sa_data) + 0.7),
                          "diamond_group" = rep(1, times = 4))

ylabels <- c("Summary", cnv_robust$slab)
nrows <- nrow(cnv_sa_data)
ybreaklim <- nrows + 1
ybreaks <- c(sort(1:ybreaklim, decreasing = TRUE))

fig3d <- fig3d + geom_polygon(data = summarydata, aes(x = x.diamond, y = y.diamond, group = diamond_group), 
                              color= "black", fill = "#1e89c6", 
                              size = 0.1) + scale_y_continuous(name = "",
                                                               breaks = ybreaks, labels = ylabels)



fig3d
```

<img src="/post/2023-11-05-11/R语言成瘾脑电元分析_files/figure-html/unnamed-chunk-56-1.png" width="672" />

### N2

``` r
n2_si_data <- meta_data %>%
  filter(type == "N2" & Description == "ideation")# no effects

n2_sa_data <- meta_data %>%
  filter(type == "N2" & Description == "attempt")# 6 effect sizes, 1 study. narrative review

n2_risk_data <- meta_data %>%
  filter(type == "N2" & Description == "risk")# 2 effects, 1 study. Narrative Review

# P2
p2_si_data <- meta_data %>%
  filter(type == "P2" & Description == "ideation")# 3 effects, 1 study. narrative

p2_sa_data <- meta_data %>%
  filter(type == "P2" & Description == "attempt")# 1 effect, 1 study. Narrative Review

p2_risk_data <- meta_data %>%
  filter(type == "P2" & Description == "risk")# no studies
```

## 统计效度

（1）样本量（sample size）
（2）效应量（effect size）
（3）显著性水平（significance level）
（4）效力（power）
知三得一

Format all studies needed for mapower_ul

``` r
study1_data <- meta_data %>% 
  filter(Study_ID == "1") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)
 
study2_data <- meta_data %>% 
  filter(Study_ID == "2") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study3_data <- meta_data %>% 
  filter(Study_ID == "3") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study4_data <- meta_data %>% 
  filter(Study_ID == "4") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study5_data <- meta_data %>% 
  filter(Study_ID == "5") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)


study6_data <- meta_data %>% 
  filter(Study_ID == "6") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study7_data <- meta_data %>% 
  filter(Study_ID == "7") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study8_data <- meta_data %>% 
  filter(Study_ID == "8") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study9_data <- meta_data %>% 
  filter(Study_ID == "9") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study10_data <- meta_data %>% 
  filter(Study_ID == "10") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study11_data <- meta_data %>% 
  filter(Study_ID == "11") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study12_data <- meta_data %>% 
  filter(Study_ID == "12") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study13_data <- meta_data %>% 
  filter(Study_ID == "13") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study14_data <- meta_data %>% 
  filter(Study_ID == "14") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study15_data <- meta_data %>% 
  filter(Study_ID == "15") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study16_data <- meta_data %>% 
  filter(Study_ID == "16") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study17_data <- meta_data %>% 
  filter(Study_ID == "17") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study18_data <- meta_data %>% 
  filter(Study_ID == "18") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study19_data <- meta_data %>% 
  filter(Study_ID == "19") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study20_data <- meta_data %>% 
  filter(Study_ID == "20") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study21_data <- meta_data %>% 
  filter(Study_ID == "21") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study22_data <- meta_data %>% 
  filter(Study_ID == "22") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study23_data <- meta_data %>% 
  filter(Study_ID == "23") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study24_data <- meta_data %>% 
  filter(Study_ID == "24") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study25_data <- meta_data %>% 
  filter(Study_ID == "25") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study26_data <- meta_data %>% 
  filter(Study_ID == "26") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)

study27_data <- meta_data %>% 
  filter(Study_ID == "27") %>%
  mutate("study" = paste(paste(Authors, Year, sep=", ("), ")", 
                         sep = "")) %>% 
  select(study, "yi" = g, "lower" = lbci, "upper" = ubci)
```

<!-- ## 每个研究结果在对应的效应量之间的统计效度  -->
<!-- ```{r} -->
<!-- power_1 <- mapower_ul(dat = study1_data,  -->
<!--                           observed_es = 0.00,  -->
<!--                           name = study1_data$study[1]) -->
<!-- power1_data <- power_1$power_median_dat -->
<!-- power_2 <- mapower_ul(dat = study2_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study2_data$study[1]) -->
<!-- power2_data <- power_2$power_median_dat -->
<!-- power_3 <- mapower_ul(dat = study3_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study3_data$study[1]) -->
<!-- power3_data <- power_3$power_median_dat -->
<!-- power_4 <- mapower_ul(dat = study4_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study4_data$study[1]) -->
<!-- power4_data <- power_4$power_median_dat -->
<!-- power_5 <- mapower_ul(dat = study5_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study5_data$study[1]) -->
<!-- power5_data <- power_5$power_median_dat -->
<!-- power_6 <- mapower_ul(dat = study6_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study6_data$study[1]) -->
<!-- power6_data <- power_6$power_median_dat -->
<!-- power_7 <- mapower_ul(dat = study7_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study7_data$study[1]) -->
<!-- power7_data <- power_7$power_median_dat -->
<!-- power_8 <- mapower_ul(dat = study8_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study8_data$study[1]) -->
<!-- power8_data <- power_8$power_median_dat -->
<!-- power_9 <- mapower_ul(dat = study9_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study9_data$study[1]) -->
<!-- power9_data <- power_9$power_median_dat -->
<!-- power_10 <- mapower_ul(dat = study10_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study10_data$study[1]) -->
<!-- power10_data <- power_10$power_median_dat -->
<!-- power_11 <- mapower_ul(dat = study11_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study11_data$study[1]) -->
<!-- power11_data <- power_11$power_median_dat -->
<!-- power_12 <- mapower_ul(dat = study12_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study12_data$study[1]) -->
<!-- power12_data <- power_12$power_median_dat -->
<!-- power_13 <- mapower_ul(dat = study13_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study13_data$study[1]) -->
<!-- power13_data <- power_13$power_median_dat -->
<!-- power_14 <- mapower_ul(dat = study14_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study14_data$study[1]) -->
<!-- power14_data <- power_14$power_median_dat -->
<!-- power_15 <- mapower_ul(dat = study15_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study15_data$study[1]) -->
<!-- power15_data <- power_15$power_median_dat -->
<!-- power_16 <- mapower_ul(dat = study16_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study16_data$study[1]) -->
<!-- power16_data <- power_16$power_median_dat -->
<!-- power_17 <- mapower_ul(dat = study17_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study17_data$study[1]) -->
<!-- power17_data <- power_17$power_median_dat -->
<!-- power_18 <- mapower_ul(dat = study18_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study18_data$study[1]) -->
<!-- power18_data <- power_18$power_median_dat -->
<!-- power_19 <- mapower_ul(dat = study19_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study19_data$study[1]) -->
<!-- power19_data <- power_19$power_median_dat -->
<!-- power_20 <- mapower_ul(dat = study20_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study20_data$study[1]) -->
<!-- power20_data <- power_20$power_median_dat -->
<!-- power_21 <- mapower_ul(dat = study21_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study21_data$study[1]) -->
<!-- power21_data <- power_21$power_median_dat -->
<!-- power_22 <- mapower_ul(dat = study22_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study22_data$study[1]) -->
<!-- power22_data <- power_22$power_median_dat -->
<!-- power_23 <- mapower_ul(dat = study23_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study23_data$study[1]) -->
<!-- power23_data <- power_23$power_median_dat -->
<!-- power_24 <- mapower_ul(dat = study24_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study24_data$study[1]) -->
<!-- power24_data <- power_24$power_median_dat -->
<!-- power_25 <- mapower_ul(dat = study25_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study25_data$study[1]) -->
<!-- power25_data <- power_25$power_median_dat -->
<!-- power_26 <- mapower_ul(dat = study26_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study26_data$study[1]) -->
<!-- power26_data <- power_26$power_median_dat -->
<!-- power_27 <- mapower_ul(dat = study27_data,  -->
<!--                       observed_es = 0.00,  -->
<!--                       name = study27_data$study[1]) -->
<!-- power27_data <- power_27$power_median_dat -->
<!-- powerall_data <- rbind(power1_data, power2_data, power3_data, power4_data,  -->
<!--                        power5_data, power6_data, power7_data, power8_data, power9_data, -->
<!--                        power10_data, power11_data, power12_data, power13_data,  -->
<!--                        power14_data, power15_data, power16_data, power17_data,  -->
<!--                        power18_data, power19_data, power20_data, power21_data,  -->
<!--                        power22_data, power23_data, power24_data, power25_data,  -->
<!--                        power26_data, power27_data -->
<!--                        ) -->
<!-- ``` -->
<!-- ```{r} -->
<!-- powerall_data <- powerall_data %>%  -->
<!--   select("study_name" = meta_analysis_name, es01:es1) -->
<!-- min_max_power <- (min(powerall_data[,11])) * 100 -->
<!-- # Calculate maximum observed median effect size power -->
<!-- max_max_power <- (max(powerall_data[,11])) * 100 -->
<!-- # Calculate mean observed median effect size power -->
<!-- mean_max_power <- (mean(powerall_data[,11])) * 100 -->
<!-- # Calculate median observed median effect size power -->
<!-- median_max_power <- (median(powerall_data[,11])) * 100 -->
<!-- long_power_data <- pivot_longer(powerall_data, es01:es1, names_to = "effect_size") -->
<!-- sufficient_power <- long_power_data %>%  -->
<!--   filter(value >= 0.8) -->
<!-- mean(.4, .8, .8, .8, .4, .9, .4, 1.0, .9, .8, 1.0, .9, .9, .9, .9,  -->
<!--        .7, .8, .8, .7, .8, .5)  -->
<!-- ``` -->
<!-- ## 画图表(汇总){.tabset} -->
<!-- ### Figure 2 -->
<!-- ```{r} -->
<!-- figure2 <- plot_grid(fig2a, fig2b, fig2c, fig2d, labels = c('A', 'B', 'C', 'D')) -->
<!-- save_plot("fig2.png", figure2, ncol = 2, base_height = 12, base_width = 6, dpi = 500) -->
<!-- figure2 -->
<!-- ``` -->
<!-- ### Figure 3 -->
<!-- ```{r} -->
<!-- figure3 <- plot_grid(fig3a, fig3b, fig3c, fig3d, labels = c('A', 'B', 'C', 'D')) -->
<!-- save_plot("fig3.png", figure3, ncol = 2, base_height = 12, base_width = 6, dpi = 500) -->
<!-- figure3 -->
<!-- ``` -->
<!-- ### Figure 4 -->
<!-- ```{r} -->
<!-- figure4 <- plot_grid(fig4a, fig4b, fig4c, labels = c('A', 'B', 'C')) -->
<!-- save_plot("fig4.png", figure4, ncol = 2, base_height = 12, base_width = 6, dpi = 500) -->
<!-- figure4 -->
<!-- ``` -->
<!-- ### Figure 5 SA vs SI:LDAER, P300 -->
<!-- ```{r} -->
<!-- figure5 <- plot_grid(fig5a, fig5b, labels = c('A', 'B', 'C')) -->
<!-- save_plot("fig5.png", figure5, ncol = 2, base_height = 12, base_width = 6, dpi = 500) -->
<!-- figure5 -->
<!-- ``` -->
<!-- ### Figure 6 热效应图 -->
<!-- ```{r} -->
<!-- firepower_plot <- ggplot(data = long_power_data) + -->
<!--   geom_tile(aes( -->
<!--     x = effect_size, -->
<!--     y = reorder(study_name, desc(study_name)), -->
<!--     fill = value -->
<!--   )) + -->
<!--   theme(aspect.ratio = 0.3) + -->
<!--   scale_fill_gradient2( -->
<!--     name = "Power", -->
<!--     midpoint = 0.5, -->
<!--     low = "white", -->
<!--     mid = "orange", -->
<!--     high = "red" -->
<!--   )+ theme_tufte(base_family = "Helvetica") -->
<!-- firepower_plot <- -->
<!--   firepower_plot + theme(strip.text.x = element_blank()) -->
<!-- firepower_plot <- firepower_plot + labs(x ="Effect size", y = "") -->
<!-- firepower_plot <- -->
<!--   firepower_plot + scale_x_discrete( -->
<!--     labels = c( -->
<!--       "es01" = "0.1", -->
<!--       "es02" = "0.2", -->
<!--       "es03" = "0.3", -->
<!--       "es04" = "0.4", -->
<!--       "es05" = "0.5", -->
<!--       "es06" = "0.6", -->
<!--       "es07" = "0.7", -->
<!--       "es08" = "0.8", -->
<!--       "es09" = "0.9", -->
<!--       "es1" = "1" -->
<!--     )) -->
<!-- firepower_plot <- firepower_plot + theme(text = element_text(size = 20)) -->
<!-- tiff(file = "figure_6.tiff", width = 12, height = 10, units = "in",  -->
<!--      res = 300, compression = "lzw") -->
<!-- firepower_plot -->
<!-- dev.off() -->
<!-- # Test interaction in Lee et al., 2014 paper -->
<!-- cocor.indep.groups(-0.387, -0.012, 53, 68, test = "zou2007") -->
<!-- ``` -->
<!-- ## 额外分析 -->
<!-- ### (自杀研究问题类型)分组分析——所有脑电指标合并 -->
<!-- ```{r } -->
<!-- ideation_data <- meta_data %>%  -->
<!--   filter(Description == "ideation" & abs_g < 2.9)#One outlier effect size  -->
<!-- ideation_data$type <- recode_factor(as.factor(ideation_data$type), LDAEP = 0,  -->
<!--                                     LPP = 1, RewP = 2, P3 = 3, CNV = 4, P2 = 5) -->
<!-- attempt_data <- meta_data %>%  -->
<!--   filter(Description == "attempt" & abs_g < 1.9)#three outliers  -->
<!-- attempt_data$type <- recode_factor(as.factor(attempt_data$type), LDAEP = 0,  -->
<!--                                    LPP = 1, RewP = 2, P3 = 3, CNV = 4, N2 = 5,  -->
<!--                                    N1 = 6, PINV = 6, SPN = 6) -->
<!-- ``` -->
<!-- ```{r} -->
<!-- risk_data <- meta_data %>%  -->
<!--   filter(Description == "risk") -->
<!-- risk_data$type <- recode_factor(as.factor(risk_data$type), LDAEP = 0, LPP = 1,  -->
<!--                                    RewP = 2, P3 = 3, N2 = 4) -->
<!-- sasi_data <- meta_data %>%  -->
<!--   filter(suicide_group == 'SA' & control_group == 'SI' & abs_g < 1.90)# Two outliers -->
<!-- sasi_data$type <- recode_factor(as.factor(sasi_data$type), LDAEP = 0, LPP = 1,  -->
<!--                  P3 = 2, N2 = 3, CNV = 4, N1 = 4) -->
<!-- ``` -->
<!-- ### 自杀想法元分析(所有脑电指标合并) -->
<!-- ```{r} -->
<!-- ideation_estimate <- rma.mv(yi = abs_g ~ 1,  -->
<!--                     V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),  -->
<!--                     data = ideation_data, -->
<!--                     method = "REML",  -->
<!--                     slab = paste(paste(paste(Authors, Year, sep=", ("), ")",  -->
<!--                                        sep = ""), effect_id, sep = " ")) -->
<!-- robust_ideation <- robust(ideation_estimate, cluster = ideation_data$Study_ID, -->
<!--                           adjust = TRUE) -->
<!-- summary(robust_ideation) -->
<!-- ``` -->
<!-- #### 异质性 -->
<!-- ```{r} -->
<!-- W <- diag(1/ideation_data$var_g) -->
<!-- X <- model.matrix(robust_ideation) -->
<!-- P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W -->
<!-- 100 * sum(robust_ideation$sigma2) / (sum(robust_ideation$sigma2) + (robust_ideation$k-robust_ideation$p)/sum(diag(P))) -->
<!-- # I2 = 18.46% -->
<!-- ``` -->
<!-- ### 漏斗图{.tabset} -->
<!-- 分析结果是否存在偏倚，如发表偏倚或其他偏倚. 一般以单个研究的效应量为横坐标，样本含量为纵坐标做的散点图.样本量小，研究精度低，分布在漏斗图的底部，向周围分散； -->
<!-- 样本量大，研究精度高，分布在漏斗图的顶部，向中间集中 -->
<!-- ```{r} -->
<!-- funnel_1 <- viz_sunset(robust_ideation,  -->
<!--            contours = TRUE, -->
<!--            power_contours = "continuous",  -->
<!--            text_size = 5, power_stats = FALSE,  -->
<!--            x_breaks = c(-1.5, -1.0, -0.5, 0, 0.5, 1, 1.5),  -->
<!--            x_limit = c(-1.75, 1.75),  -->
<!--            xlab = expression("Hedges' " * italic("g"))) + theme(legend.position = "none") -->
<!-- funnel_power <- metafor::funnel(robust_ideation)# Used later to calculate power -->
<!-- #SI 发表偏倚 在后面 -->
<!-- ``` -->
<!-- <http://www.idata8.com/rpackage/meta/forest.meta.html> -->
<!-- - meta包metagen( -->
<!--   参数说明： -->
<!-- TE : 治疗效果的估计，例如对数危险比或风险差。 -->
<!-- seTE : 治疗估计的标准误差。 -->
<!-- studlab : 带有研究标签的可选向量。 -->
<!-- data : 包含研究信息的可选数据框。 -->
<!-- subset : 指定要使用的研究子集的可选向量（请参阅详细信息）。 -->
<!-- exclude : 一个可选的向量，指定从荟萃分析中排除的研究，但是，包括在打印输出和森林图中（见细节）。 -->
<!-- sm : 表示基本摘要度量的字符串，例如“RD”、“RR”、“OR”、“ASD”、“HR”、“MD”、“SMD”或“ROM”。 -->
<!-- method.ci : 一种字符串，表示用哪种方法来计算个别研究的置信区间。 -->
<!-- level : 用于计算单个研究的置信区间的水平。 -->
<!-- level.comb : 用于计算汇总估计的置信区间的水平。 -->
<!-- comb.fixed : 指示是否应进行固定效应元分析的逻辑。 -->
<!-- comb.random : 指示是否应进行随机效应数据分析的逻辑。 -->
<!-- overall : 指示是否应报告总体摘要的逻辑。如果不应报告总体结果，则此参数在具有子组的元分析中很有用。 -->
<!-- - meta包forest( -->
<!-- 参数说明： -->
<!-- x : meta类的对象。 -->
<!-- sortvar : 用于对单个研究进行排序的可选向量（长度必须与x$TE). -->
<!-- studlab : 指示是否应在图表中打印研究标签的逻辑。还可以提供带有研究标签的向量（长度必须与x$TE 然后）。 -->
<!-- layout : 指定森林图布局的字符串（请参阅详细信息）。 -->
<!-- comb.fixed : 指示是否应绘制固定效应估计的逻辑。 -->
<!-- comb.random : 指示是否应绘制random effects estimate的逻辑图。 -->
<!-- overall : 指示是否应绘制总体摘要的逻辑表达式。如果摘要只应绘制在组级别上，则此参数在具有子组的元分析中非常有用。 -->
<!-- text.fixed : 绘图中用于标记组合固定效果估计的字符串。 -->
<!-- text.random : 绘图中用于标记组合随机效果估计的字符串。 -->
<!-- lty.fixed : 线型（合并固定效应估计） -->
<!-- ```{r} -->
<!-- library(metafor) -->
<!-- library(meta) -->
<!-- m.hksj <- metagen(g, var_g, data = p3_sa_data, studlab = paste(Authors), comb.fixed = FALSE,  #P3am_IGD_data -->
<!-- comb.random = TRUE, -->
<!-- method.tau = "SJ", hakn = TRUE, -->
<!-- prediction = TRUE, sm = "SMD") -->
<!-- m.hksj -->
<!-- ``` -->
<!-- 7.5 影响力分析   -->
<!-- 7.5.1 影响力分析 (Influence Analyses)  -->
<!-- 7.5.2 Baujat 图  -->
<!-- 7.5.3“去一”分析 (Leave-One-Out Analyses)  -->
<!-- 7.6 GOSH PLOT ANALYSIS -->
<!-- ```{r} -->
<!-- library(dmetar) -->
<!-- InA <- InfluenceAnalysis(x = m.hksj, random = TRUE)  #x = viz_forest.g,random = TRUE)  # -->
<!-- plot(InA) -->
<!-- plot(InA, "influence") #输出 influence 图  -->
<!-- plot(InA, "Baujat") #Baujat 图 -->
<!-- plot(InA, "I2") #输出按 I^2 排序的图  -->
<!-- plot(InA, "es") #输出按 Effect size 排序的图 -->
<!-- #plot(inf.analysis, "es") #输出按 Effect size 排序的图 -->
<!-- ``` -->
<!-- ```{r} -->
<!-- library(metafor) -->
<!-- m.rma <- rma(yi = m.hksj$TE, #yi = g ~ 1, V = var_g -->
<!--              sei = m.hksj$seTE, -->
<!--              method = m.hksj$method.tau, -->
<!--              test = "knha") -->
<!-- ``` -->
<!-- <!-- # ```{r} -->

–\>
<!-- <!-- # dat.gosh <- gosh(m.rma) --> –\>
<!-- <!-- # plot(dat.gosh, alpha=0.1, col="blue") --> –\>
<!-- <!-- # ``` --> –\>

<!-- <!-- ### 私人订制数据分析仓库(未做完) {.tabset} -->

–\>
<!-- <!-- #### 因素分析 --> –\>
<!-- <!-- #### 中介 --> –\>
<!-- <!-- #### 调节 --> –\>
<!-- <!-- #### 结构方程模型 --> –\>
<!-- <!-- #### 网络分析 --> –\>
<!-- <!-- #### 进阶元分析 --> –\>

# **“元分析R代码错误”复盘**

(中英文批量修改replace)
看模块简的逻辑关系:横向并列,纵向

1.  Question: “\> W \<- diag(1/p3_sa_data\$var_g)
    X \<- model.matrix(p3_robust)
    P \<- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W” —— Error in W %\*% X : non-conformable arguments”

Answer: %\*% 此运算符用于将矩阵与其转置相乘; dim(W),dim(X);发现上面少了段代码

2.  “Error in `check_breaks_labels()`:
    ! `breaks` and `labels` must have the same length”
    A: This leads to annoying warnings. So I should replace size by linewidth if the loaded version of ggplot2 is 3.4.0 or greater.
    labels是图中所显示标注的刻度（主观），breaks是实际中要分成的刻度（客观）

3.  could not find function “weightfunct”, “s_power:  
    个体数据分析思路不同,自定义函数不同.

4.  插入图片/文档
    False: \#![dad](%22./Users/alex/Desktop/R/NY/sucidal_meta%20copy.png%22)
    True: ./sucidal_meta copy.png
    工作目录重要, *因为用setwd()发现工作目录就在”/Users/alex/Desktop/R/NY”, 工作目录重复了*

5.  “载入了名字空间‘htmltools’ 0.5.3，但需要的是＞= 0.5.4;”renv::repair()”
    load the latest package.

”

# 总结

- R语言: **丝滑的逻辑运算——逻辑清晰,环环相扣, 丰富的形式展现–形式丰富,高效缜密**;需要掌握更多:R markdown, shiny APP; 可视化、动态、交互…; html语法,css, LaTex, Quarto….

- *脑电: 研究问题所对应的脑电指标和实验范式/任务、 电极点*

- 元分析:方法差异大, 单从作图数量看, 基础元分析2,3个图, 进阶元分析十多个图; 未报告数据的处理方法

## 致谢老师/参考信息:

- 视频和个人网页: **谢益辉老师**,youtobe的 Martin.. Gregin(热情、专业), <https://www.rdocumentation.org/> 、郭晓老师、李东风老师、万能的谷歌;

- 微信公众号: 荷兰心理统计联盟,统计之都,医咖会..

- 书:《零基础学习R语言》《R语言编程指南》,《R语言编程——基于tidyverse》by 张敬信老师,《R语言编程基础》…

- *最重要的是自学的方法:一个人走得快,一群人走得远,在R生态系统中找到一群志同道合的小伙伴*
