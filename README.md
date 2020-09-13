# Pricing-diamonds

## Table of contents
* [General info](#general-info)
* [Technologies](#Loading)
* [Data analysis](#Data-analysis)

## General info
Classic machine learning approaches tested on diamond dataset from [Kaggle](https://www.kaggle.com/shivam2503/diamonds/home), to test the script just download the entire folder and put inside the diamond dataset.
	
## Loading
Data are loaded using [loading.m](https://github.com/Ste29/Pricing-diamonds/blob/master/loading.m), which also checks for NaNs, outliers and outputs dataset and a table with general statistics about data. No NaNs were detected, also every diamond with x*y*z (volume) equal to 0 was discarded.

| stats       | carat       | cut         | color         |    clarity    |     depth       |    table     |    price    |    x        |        y      |        z      |
| :----:      |    :----:   |   :----:    |    :----:     |   :----:      |     :----:      |  :----:      |    :----:   |   :----:    |    :----:     |   :----:      |
| mean        | 0,7979      | 3,9041      | 2,7477        |  4,0488       |    61,7494      |  57,4572     | 3932,7997   |   5,7312    |    5,7345     |    3,5387     |
| max         | 5,01        | 5           |  7            |  8            |     79          |  95          |  18823      |  10,74      |    58,9       |   31,8        |
| min         | 0,20        | 1           |  1            |  1            |     43          |  43          |  326        |  0          |     0         |   0           |
| std         | 0,4740      | 1,1166      |  1,7011       |  1,6471       |     1,4326      |  2,2345      |  3989,4397  |  1,1218     |     1,1421    |   0,7057      |



## Data analysis

The first step is to study features distribution, then how features influence the price. Lastly, it is possible to notice price has a lognormal distribution, this is a common distribution in money-related datasets. Indeed, it is possible to determine 2 types of diamonds, those that are bought by the general public for big occasions (i.e. weddings), therefore they have lower prices, and those bought by the richer one. Given the price distribution, it is useful to consider log10(price) in order to linearize the relations.

- Features distribution 
- Features vs price
![feat](https://github.com/Ste29/Pricing-diamonds/blob/master/img/Feat_vs_price.tif)
- Price distribution
- Categorical features

In [Data_analysis.m](https://github.com/Ste29/Pricing-diamonds/blob/master/scripts/Data_analysis.m) there are also boxplots and scatter matrixes.
