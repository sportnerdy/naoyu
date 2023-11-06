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

<style type="text/css">

body{ /* Normal  */
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


```{r setup, include=FALSE}
#'echo = False' hides *all* code chunks below when knitted 
#'message = F' hides *all* messages below when knitted 
#'warning = F' hides *all* warnings messages below when knitted 
knitr::opts_chunk$set(
                      collapse = TRUE,
                      echo = TRUE, 
                      message = F, 
                      warning = F)
options(scipen = 999)
```

---
本课程初心

- 对自己:源于**以教促学,为毕设开题作准备**.毕设主要为问卷数据、ERP脑电指标相关数据的元分析, 要推进关键的“数据录入、数据转化”阶段, 则必须掌握目标文献涉及的统计量与效应量, 如何确定自己是否掌握? 将自己在R生态系统中数据分析的结果与原文结果核对, 无误则说明掌握.
- 对同学: 抛砖引玉,希望目前粗糙的版本能激发大家对于R语言和脑电元分析的兴趣.
错误之处,欢迎指正
# 元分析简介 
# ```{r setup-pdf, include=FALSE}
# pdf.options(family="GB1")
# ```

元分析可从数据层面分成3类:问卷数据、脑电指标数据ERP, 核磁数据fMRI.

## 元分析流程 {.tabset}
### 方案预注册
PROSPERO[Register]<https://www.crd.york.ac.uk/PROSPERO/#recordDetails>

### 文献检索
流程图
```{r}
library(htmltools)
library(knitr)
library(kableExtra)#not kable
library(readxl)
library(dplyr)

data <- read_excel("/Users/12570/Desktop/Meta-analysis/Supplementary data/NY_Sup/Suicidal_meta_spreadsheet.xlsx", sheet = "DataBase") %>% 
#C:/Users/12570/Desktop/Meta-analysis/Supplementary data/NY_Sup
# Paper_search_data <- data %>% 
#   dplyr::select(Database, Boolean, everything()) %>% 
  kable(align = "c",  caption = "文献检索关键词和数据库") %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
data
```
[Rmarkdown 表格创建] <https://zhuanlan.zhihu.com/p/36919769>

制定检索策略与筛选标准：确定检索词、数据库以及相关的筛选标准. 比如脑电元分析论文“Suicidal thoughts, behaviors, and event-related potentials: A systematic review and meta-analysis”: 

 关键词: “event-related potential,” “event-related potentials,” “electroencepha- lography,” “EEG,” “evoked potential,” “evoked poten-tials,” “late positive potential,” “reward positivity,” “P3a,” “P3b,” “error-related negativity,” “suicide,” “suicidal,” “suicidal ideation,” “self-harm,” “self-injury,” “parasu- icide,” “suicide ideation,” “suicide attempt,” “suicide plan,” “suicidality,” “自杀风险,” “attempter,” “attempt- ers,” and “ideators.”
 
### 系统评价(暂无)
### 数据录入
明确需要纳入的数据类型:需要把*统计量转换为效应量*: 
•明确数据提取人员 •设计数据提取表格 •进行预试验 •开始数据提取 •数据核查、修改 •处理意见分歧

_参考已发表的脑电元分析_

- 心理科学进展上: 《EMMN 受偏差−标准刺激对类型和情绪类型影响: 来自元分析的证据*》,以及医咖会的《11-系统评价与Meta分析的数据提取》. 每篇文献的以下数据将被提取: 第一作者、发表 
年份、被试个数与男女比例、被试均龄和标准差、 
计算效应量的数据(即均值+标准差、t 值、F 值或 
p 值)、实验范式、情绪类型、时间窗、偏差−标准 
刺激对、任务相关性、电极/ROI、面孔类型、单 
试次呈现图片数、图片呈现时间等; 研究中结果不显著的也要录入。 

- 效应量effect size: "d-family（difference family）:：如Cohen's d、Hedges' g
r-family（correlation family）：如Pearson r、R²、η²、ω²、f
OR-family（categorical family）：如odds ratio (OR)、risk ratio (RR)"





### 效应值合并
[Excel template统计量-效应量转换、不同效应量之间的相互转换] <https://osf.io/6tfh5/>

### 森林图
```{r, echo=TRUE}
knitr::include_graphics("C:/Users/12570/Desktop/NY/forest.png")
```


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
[调节变量分析]<https://zhuanlan.zhihu.com/p/360558511>
用于研究真实效应量是否受调节变量影响,称为协变量分析更恰当，因为下述模型中不考虑变量间的交互作用。

- 若调节变量（Mo）是类别数据（categorical moderator），该分析又称为亚组分析(subgroup analysis; Borenstein et al., 2019)【类似于ANOVA】. 比如(性别, 是否网游成瘾)
- 若调节变量(Mo)是连续数据（continuous moderator），该分析更近似于多重回归分析【multiple regression analysis】. (年龄,成瘾或戒断时间)
### 发表偏倚检验{.tabset}



# R语言简介{.tabset}

可进行元分析的其它软件:CMA, Review Manager...; 相比spss, Mplus, Prism, JASP..,个人偏好*R语言生态系统(数据整理、分析、可视化、结果报告)*. 

> *"R is for research, python is for production"*. 

- 分析语句数量对比
```{r echo=FALSE, out.width = '100%', out.height = '100%'}
knitr::include_graphics("C:/Users/12570/Desktop/NY/IMG_5488.JPG")

```

- 运行时间对比
```{r echo=FALSE, out.width = '100%', out.height = '100%'}
knitr::include_graphics("C:/Users/12570/Desktop/NY/IMG_5489.JPG")

```

## 基本对象(数据结构) {.tabset}
掌握基础语法(运算符)、基本对象...是为了看懂别人的代码块,然后抄过来,删、改、调试成自己需要的版本.

### 向量
向量中的元素必须是同一种数据类型，简单向量中的元素为原子类型，复杂向量中的元素可以是列表等。
```{r}
R <- c(x1=250,x2=250,x3=250)
R
```


### 数组
创建矩阵的语法为array(data = NA, dim = length(data), dimnames = NULL)
```{r}
array(1:3, c(2,4,2))
```

### 列表
用list函数创建
```{r}
x <- list(a="R语言",b="脑电",c="元分析",d=1:3)
#y <- list(x,5+3i)
x

```

### 数据框
```{r}
library(tibble)
df = tibble(
  grammer = c("R语言","脑电","元分析"),
  score = c(6,6,6)
  )
df
```

### 矩阵 {.tabset}
，data参数指定原始向量的数据，nrow参数指定行数，ncol参数指定列数，默认将原有向量按照纵向排成矩阵
```{r}
x <- matrix(R,2)
x
```
#### 矩阵的拼接
矩阵的横向拼接用函数cbind，纵向拼接用函数rbind，被拼接的对象可以是矩阵，也可以是向量。他们在拼接方向需要有相同的维度。当横向拼接向量时，向量被视为行向量；当纵向拼接向量时，其被视为列向量。
```{r}
r1 <- matrix(R,2)
r2 <- matrix(R,2)
cbind(r1,r2)
```
```{r}
rbind(r1,r2)
```

#### 矩阵级运算

### (自定义)函数
- 函数定义:R语言的执行顺序是自上而下每条语句依次执行，所以要使用一个函数，必须在这行代码之前就定义了函数，而不能将函数定义写在函数调用之后

- 函数调用: 其他脚本中的函数，则使用source函数，source的参数为脚本名而非函数名，需要用引号括起来。如果该脚本不在工作路径中，还需要在前面添加路径，如source("PowScript.R")或source("other/path/PowScript.R")。这样相当于PowScript.R脚本中的所有代码全部复制一遍放在了这一行代码处
```{r}
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
- 列合并：unite(data, col=新列, 需要合并的各列, sep = "_", remove = - TRUE)
- 列分裂：separate(data, col, into=c(“列1”,“列2”,…), sep = - “[^[:alnum:]]+”)
- 嵌套与取消嵌套：nest()、unnest()

## 基本操作 {.tabset}
### 表达式
### 对象操作

# **R语言元分析代码应用**

```{r}
devtools::session_info() #编译本教程所用的R软件环境：
```

```{r echo=FALSE, fig.cap="参考的脑电元分析", out.width = '100%'}
knitr::include_graphics("C:/Users/12570/Desktop/NY/sucidal_meta copy.png") #/Users/alex/Desktop/R/NY/
```

## **研究问题**
(练习数据来自脑电元分析论文)“Suicidal thoughts, behaviors, and event-related potentials: A systematic review and meta-analysis”): **自杀想法和行为Suicidal thoughts and behaviors (STBs)**:
- suicidal ideation (SI)ideation and suicide attempts自杀尝试 (SA; Schmaal et al., 2019)
问题1: 

1. **Q1:脑电指标能否区分 自杀想法和行为有无的两类人**;provide meta-analytic estimates of whether any ERPs differ between individuals who have and have not engaged in STBs; 
2. **Q2:不同效应量水平下的统计效度**;  examine how powered the literature is across a range of effect sizes (sample size, effect size, statistical power)
3. **Q3:脑电指标能否区分 4类STB**: review the literature to contextualize our meta-analytic findings and examine how various ERPs, including those that did not meet criteria for inclusion in the meta-analysis, are related to STBs. 
Regarding four separate STBs:

- *(a) those with and without suicidal ideation, 自杀想法有无*
- *(b) those with and without suicide attempts history,自杀行为有无*
- *(c) those with varying levels of suicidal risk, and 自杀风险不同的人群* 
- *(d) differences between those with suicide attempts versus those with suicidal ideation only 自杀行为和自杀想法两类人对比*

- 单个脑电指标对应的研究问题(文献综述部分): 这个需要对该领域有比较全面和深入的理解, 脑电指标、实验任务、研究问题之间的联系、组合决定了数据录入模版和分析方法. 所以检索词也需要更广泛一些,小领域可能文献数量不足. 可以将同领域/主题的问卷数据和脑电指标数据元分析进行对比,侧重可能不同. 

## 加载包
["代码段选项"]<https://yihui.name/knitr/options>
[R 语言必学的 10 大包] <https://www.zhihu.com/question/24136262>

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
+ `r version[['version.string']]`.

```{r packages}

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
("kable_styling")<https://blog.csdn.net/renewallee/article/details/103352505>

## 流程图
PRISMA statement: 文献的纳入标准、结果综合的统计方法等 应该严格要求作者进行清楚地报告，以保证元分析的质量;而对元分析中单个 研究偏倚的评估、数据和分析过程可获得，则可以作为鼓励性的拔高标准。第 二、期刊在对元分析稿件的初步筛选时，可参性照元分析报告标准，对关键条目进 行核对，检查文章中是否包括了这些关键条目，以检查是该元分析是否满足元 分析报告标准的基本要求，决定是否将该稿件送审
```{r PRISMA}
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

## 定义参数
按自己的数据分析版本修改:
```{r}
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
```{r meta_data}
library(readxl)
library(tidyverse)
library(kableExtra)
data <- read_excel("/Users/12570/Desktop/Meta-analysis/Supplementary data/NY_Sup/Suicidal_meta_spreadsheet.xlsx", sheet = "effect_size_coding")

data <- read_excel("/Users/12570/Desktop/Meta-analysis/Supplementary data/NY_Sup/Suicidal_meta_spreadsheet.xlsx", sheet = "effect_size_coding")

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
# meta_data$scoring <- recode_factor(as.factor(meta_data$scoring), raw = 0, 
#                                    difference = 1, slope = 1)

datatable(meta_data, options = list(pageLength = 10)) 

```

## 单个脑电指标对应的研究问题 {.tabset}
各个自杀类型的数据表


文献综述部分: 

### LDAEP {.tabset}
```{r}
ldaep_si_data <- meta_data %>%
  filter(type == "LDAEP" & Description == "ideation")# 3 effect sizes 2 studies. Meta analyze

ldaep_sa_data <- meta_data %>%
  filter(type == "LDAEP" & Description == "attempt")# 12 effect sizes, 5 studies. Meta analyze

ldaep_risk_data <- meta_data %>%
  filter(type == "LDAEP" & Description == "risk")# 3 effect sizes, 3 studies. Meta analyze

ldaep_sasi_data <- meta_data %>% 
  filter(type == "LDAEP" & suicide_group == 'SA' & control_group == 'SI')# 11 effect sizes, 4 studies meta analyze

```

#### LDAEP自杀想法分析 {.tabset}
通过线性（混合效应）模型拟合多元/多水平固定和随机/混合效应模型的元分析函数
[Examples]<https://www.rdocumentation.org/packages/metafor/versions/2.4-0/topics/rma.mv>

```{r}
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

```



##### 计算模型异质性
```{r}
W <- diag(1/ldaep_si_data$var_g)
X <- model.matrix(ldaep_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(ldaep_robust$sigma2) / (sum(ldaep_robust$sigma2) + (ldaep_robust$k-ldaep_robust$p)/sum(diag(P)))

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


#### LDAEP自杀行为分析 {.tabset}
```{r}
ldaep_estimate <- rma.mv(yi = g ~ 1,
                         V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                         data = ldaep_sa_data,
                         method = "REML", 
                         slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                            sep = ""), effect_id, sep = " "))

ldaep_robust <- robust(ldaep_estimate, cluster = ldaep_sa_data$Study_ID,
                       adjust = TRUE)
summary(ldaep_robust)# g = 0.021, p = 0.946
```



##### 计算模型异质性
```{r}
W <- diag(1/ldaep_sa_data$var_g)
X <- model.matrix(ldaep_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(ldaep_robust$sigma2) / (sum(ldaep_robust$sigma2) + (ldaep_robust$k-ldaep_robust$p)/sum(diag(P)))

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


##### LDAEP 发表偏倚
```{r}
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
```

#### LDAEP自杀风险分析 {.tabset}
```{r}
ldaep_estimate <- rma.mv(yi = g ~ 1,
                         V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                         data = ldaep_risk_data,
                         method = "REML", 
                         slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                            sep = ""), effect_id, sep = " "))

ldaep_robust <- robust(ldaep_estimate, cluster = ldaep_risk_data$Study_ID,
                       adjust = TRUE)
summary(ldaep_robust)# g = 0.175, p = 0.552
```



##### 计算模型异质性
```{r}
W <- diag(1/ldaep_risk_data$var_g)
X <- model.matrix(ldaep_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(ldaep_robust$sigma2) / (sum(ldaep_robust$sigma2) + (ldaep_robust$k-ldaep_robust$p)/sum(diag(P)))

```


##### 森林图
```{r fig4a}
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

#### LDAEP 自杀行为和自杀想法对比分析SA vs. SI analysis {.tabset}
```{r}
ldaep_estimate <- rma.mv(yi = g ~ 1,
                         V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                         data = ldaep_sasi_data,
                         method = "REML",  
                         slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                            sep = ""), effect_id, sep = " "))

ldaep_robust <- robust(ldaep_estimate, cluster = ldaep_sasi_data$Study_ID,
                       adjust = TRUE)
summary(ldaep_robust)# g = 0.168, p = 0.648
```

##### 计算模型异质性
```{r}
W <- diag(1/ldaep_sasi_data$var_g)
X <- model.matrix(ldaep_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(ldaep_robust$sigma2) / (sum(ldaep_robust$sigma2) + (ldaep_robust$k-ldaep_robust$p)/sum(diag(P)))
#69.17%
```


##### 森林图
```{r fig5a}
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



##### LDAEP 自杀行为和自杀想法发表偏倚
```{r}
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
```

###  LPP {.tabset}
```{r}
lpp_si_data <- meta_data %>%
  filter(type == "LPP" & Description == "ideation")# 34 effect sizes, 3 studies. Meta analyze

lpp_sa_data <- meta_data %>%
  filter(type == "LPP" & Description == "attempt")# 1 study, 3 effect sizes. Meta analyze

lpp_risk_data <- meta_data %>%
  filter(type == "LPP" & Description == "risk")# 9 effect sizes, 2 studies. Meta analyze

lpp_sasi_data <- meta_data %>% 
  filter(type == "LPP" & suicide_group == 'SA' & control_group == 'SI')# Same effects as SA LPP dataset

```

#### LPP 自杀想法分析 {.tabset}
```{r}
lpp_estimate <- rma.mv(yi = g ~ 1,
                       V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                       data = lpp_si_data,
                       method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                           sep = ""), effect_id, sep = " "))

lpp_robust <- robust(lpp_estimate, cluster = lpp_si_data$Study_ID,
                     adjust = TRUE)
summary(lpp_robust)# g = -0.053, p = 0.407

```


##### 计算模型异质性
```{r}
W <- diag(1/lpp_si_data$var_g)
X <- model.matrix(lpp_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(lpp_robust$sigma2) / (sum(lpp_robust$sigma2) + (lpp_robust$k-lpp_robust$p)/sum(diag(P)))
#10.73%
```

##### 森林图
```{r fig2b}
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

##### LPP 自杀想法发表偏倚
```{r}
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
```

#### LPP 自杀风险分析 {.tabset}
```{r}
lpp_estimate <- rma.mv(yi = g ~ 1,
                       V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                       data = lpp_risk_data,
                       method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                           sep = ""), effect_id, sep = " "))


lpp_robust <- robust(lpp_estimate, cluster = lpp_risk_data$Study_ID,
                     adjust = TRUE)
summary(lpp_robust)# g = -0.290, p = 0.157

W <- diag(1/lpp_risk_data$var_g)
X <- model.matrix(lpp_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(lpp_robust$sigma2) / (sum(lpp_robust$sigma2) + (lpp_robust$k-lpp_robust$p)/sum(diag(P)))
#9.15%
```

##### 森林图
```{r}
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



###  P3 {.tabset}
```{r}
p3_si_data <- meta_data %>%
  filter(type == "P3" & Description == "ideation")# 53 effect sizes, 3 studies. meta analyze

p3_sa_data <- meta_data %>%
  filter(type == "P3" & Description == "attempt")# 15 effect sizes, 6 studies. Meta analyze

p3_risk_data <- meta_data %>%
  filter(type == "P3" & Description == "risk")# 28 effect sizes, 3 studies. meta analyze

p3_sasi_data <- meta_data %>% 
  filter(type == "P3" & suicide_group == 'SA' & control_group == 'SI')# 10 effect sizes, 3 studies. meta analyze

```

#### P3 自杀想法分析 {.tabset}
```{r}
p3_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = p3_si_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

p3_robust <- robust(p3_estimate, cluster = p3_si_data$Study_ID,
                    adjust = TRUE)
summary(p3_robust)# g = 0.067, p = 0.827
```

```{r}
W <- diag(1/p3_si_data$var_g)
X <- model.matrix(p3_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(p3_robust$sigma2) / (sum(p3_robust$sigma2) + (p3_robust$k-p3_robust$p)/sum(diag(P)))
#79.75
```




##### 森林图
```{r}
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


##### P3 自杀想法发表偏倚
```{r}
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
```

```{r}
###P3 SA Analysis
p3_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = p3_sa_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

p3_robust <- robust(p3_estimate, cluster = p3_sa_data$Study_ID,
                    adjust = TRUE)
summary(p3_robust)# g = 0.067, p = 0.827
```


#### P3 自杀行为分析{.tabset}
```{r}
W <- diag(1/p3_sa_data$var_g)
X <- model.matrix(p3_robust)
# dim(W)
# dim(X)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W 
100 * sum(p3_robust$sigma2) / (sum(p3_robust$sigma2) + (p3_robust$k-p3_robust$p)/sum(diag(P)))
#93.97

```


##### 森林图
```{r}
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



##### P3 自杀行为发表偏倚
```{r}
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
```



#### P3 自杀风险分析 {.tabset}
```{r}
p3_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = p3_risk_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

p3_robust <- robust(p3_estimate, cluster = p3_risk_data$Study_ID,
                    adjust = TRUE)
summary(p3_robust)# g = 0.2497, p = .3218

W <- diag(1/p3_risk_data$var_g)
X <- model.matrix(p3_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(p3_robust$sigma2) / (sum(p3_robust$sigma2) + (p3_robust$k-p3_robust$p)/sum(diag(P)))
#65.09

```


##### 森林图
```{r}
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




##### P3 自杀风险发表偏倚
```{r}
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
```


#### P3 自杀行为和ideation对比分析SA vs. SI{.tabset}
```{r}
p3_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = p3_sasi_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

p3_robust <- robust(p3_estimate, cluster = p3_sasi_data$Study_ID,
                    adjust = TRUE)
summary(p3_robust)# g = -0.40, p = 0.6422

W <- diag(1/p3_sasi_data$var_g)
X <- model.matrix(p3_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(p3_robust$sigma2) / (sum(p3_robust$sigma2) + (p3_robust$k-p3_robust$p)/sum(diag(P)))
#93.06
```

##### 森林图
```{r}
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

##### P300 SA vs. SI -only 发表偏倚
```{r}
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

```

### RewP {.tabset}
```{r}
rewp_si_data <- meta_data %>%
  filter(type == "RewP" & Description == "ideation")# 12 effect sizes, 3 studies. Meta analyze

rewp_sa_data <- meta_data %>%
  filter(type == "RewP" & Description == "attempt")# 5 effect sizes, 2 studies. Meta analyze

rewp_risk_data <- meta_data %>%
  filter(type == "RewP" & Description == "risk")# 3 effect sizes, 1 study. Narrative review only 

rewp_sasi_data <- meta_data %>% 
  filter(type == "RewP" & suicide_group == 'SA' & control_group == 'SI')# 0 effect sizes
```

#### RewP SI Analysis {.tabset}
```{r}
rewp_estimate <- rma.mv(yi = g ~ 1,
                      V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                      data = rewp_si_data,
                      method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                          sep = ""), effect_id, sep = " "))

rewp_robust <- robust(rewp_estimate, cluster = rewp_si_data$Study_ID,
                    adjust = TRUE)
summary(rewp_robust)# g = -0.06, p = .0406

W <- diag(1/rewp_si_data$var_g)
X <- model.matrix(rewp_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(rewp_robust$sigma2) / (sum(rewp_robust$sigma2) + (rewp_robust$k-rewp_robust$p)/sum(diag(P)))
#4.29%

```

##### 森林图
```{r}
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

##### RewP SI 发表偏倚
```{r}
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

```


#### RewP SA Analysis {.tabset}
```{r}
rewp_estimate <- rma.mv(yi = g ~ 1,
                        V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                        data = rewp_sa_data,
                        method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                            sep = ""), effect_id, sep = " "))

rewp_robust <- robust(rewp_estimate, cluster = rewp_sa_data$Study_ID,
                      adjust = TRUE)
summary(rewp_robust)# g = -0.12, p = .5449

W <- diag(1/rewp_sa_data$var_g)
X <- model.matrix(rewp_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(rewp_robust$sigma2) / (sum(rewp_robust$sigma2) + (rewp_robust$k-rewp_robust$p)/sum(diag(P)))
#12.33%
```



##### 森林图
```{r}
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

### CNV
```{r}
cnv_si_data <- meta_data %>%
  filter(type == "CNV" & Description == "ideation")# 3 effect sizes, 1 study. review only 

cnv_sa_data <- meta_data %>%
  filter(type == "CNV" & Description == "attempt")# 4 effect sizes, 4 studies. Meta analyze

cnv_risk_data <- meta_data %>%
  filter(type == "CNV" & Description == "risk")# no effects

cnv_sasi_data <- meta_data %>% 
  filter(type == "CNV" & suicide_group == 'SA' & control_group == 'SI')# 1 effect sizes

```

#### CNV SA Analysis {.tabset}
```{r}
cnv_estimate <- rma.mv(yi = g ~ 1,
                        V = var_g, random = list(~ 1 | effect_id, ~ 1 | Study_ID),
                        data = cnv_sa_data,
                        method = "REML", slab = paste(paste(paste(Authors, Year, sep=", ("), ")", 
                                                            sep = ""), effect_id, sep = " "))

cnv_robust <- robust(cnv_estimate, cluster = cnv_sa_data$Study_ID,
                      adjust = TRUE)
summary(cnv_robust)# g = 0.44, p = 0.4157

W <- diag(1/cnv_sa_data$var_g)
X <- model.matrix(cnv_robust)
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W
100 * sum(cnv_robust$sigma2) / (sum(cnv_robust$sigma2) + (cnv_robust$k-cnv_robust$p)/sum(diag(P)))
#84.45%
```

##### 森林图
```{r}
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


###  N2 
```{r}
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
```{r}
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

<!-- <!-- # ```{r} --> -->
<!-- <!-- # dat.gosh <- gosh(m.rma) --> -->
<!-- <!-- # plot(dat.gosh, alpha=0.1, col="blue") --> -->
<!-- <!-- # ``` --> -->



<!-- <!-- ### 私人订制数据分析仓库(未做完) {.tabset} --> -->
<!-- <!-- #### 因素分析 --> -->
<!-- <!-- #### 中介 --> -->
<!-- <!-- #### 调节 --> -->
<!-- <!-- #### 结构方程模型 --> -->
<!-- <!-- #### 网络分析 --> -->
<!-- <!-- #### 进阶元分析 --> -->

# **“元分析R代码错误”复盘**
(中英文批量修改replace)
看模块简的逻辑关系:横向并列,纵向

1. Question: “> W <- diag(1/p3_sa_data$var_g)
X <- model.matrix(p3_robust) 
P <- W - W %*% X %*% solve(t(X) %*% W %*% X) %*% t(X) %*% W” —— Error in W %*% X : non-conformable arguments”   

Answer:  %*% 此运算符用于将矩阵与其转置相乘; dim(W),dim(X);发现上面少了段代码

2. “Error in `check_breaks_labels()`:
! `breaks` and `labels` must have the same length”
A: This leads to annoying warnings. So I should replace size by linewidth if the loaded version of ggplot2 is 3.4.0 or greater.
labels是图中所显示标注的刻度（主观），breaks是实际中要分成的刻度（客观）

3. could not find function "weightfunct", "s_power:  
个体数据分析思路不同,自定义函数不同.

4. 插入图片/文档
False: #![dad]("./Users/alex/Desktop/R/NY/sucidal_meta copy.png")
True: ./sucidal_meta copy.png 
工作目录重要, *因为用setwd()发现工作目录就在"/Users/alex/Desktop/R/NY", 工作目录重复了*

5. “载入了名字空间‘htmltools’ 0.5.3，但需要的是＞= 0.5.4; "renv::repair()" 
load the latest package.

”

# 总结 
- R语言: **丝滑的逻辑运算——逻辑清晰,环环相扣, 丰富的形式展现--形式丰富,高效缜密**;需要掌握更多:R markdown, shiny APP; 可视化、动态、交互...; html语法,css, LaTex, Quarto....

- *脑电: 研究问题所对应的脑电指标和实验范式/任务、 电极点*

- 元分析:方法差异大, 单从作图数量看, 基础元分析2,3个图, 进阶元分析十多个图; 未报告数据的处理方法

## 致谢老师/参考信息: 

- 视频和个人网页: **谢益辉老师**,youtobe的 Martin.. Gregin(热情、专业), <https://www.rdocumentation.org/> 、郭晓老师、李东风老师、万能的谷歌; 
- 微信公众号: 荷兰心理统计联盟,统计之都,医咖会..
- 书:《零基础学习R语言》《R语言编程指南》,《R语言编程——基于tidyverse》by 张敬信老师,《R语言编程基础》...

- *最重要的是自学的方法:一个人走得快,一群人走得远,在R生态系统中找到一群志同道合的小伙伴*


