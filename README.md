
<img width="900" alt="image" src="https://github.com/user-attachments/assets/457973b3-ca38-4a89-a00b-24ee04fed961" />

---

**`RChatSF`** is an R package for calling the **Siliconflow** (硅基流动) API, enabling rapid interaction with various LLM models, including **DeepSeek**. 

Once you create a Siliconflow account, you can enjoy efficient analysis workflows in R.


## Installation

You can install the RChatSF from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mumdark/RChatSF")
```

## Examples

You can use the code below to execute the example:

``` r
library("RchatSF")
RchatSF("your api key", 
              model = "deepseek-ai/DeepSeek-R1", 
              max_tokens = 8190, 
              temperature = 0.6, 
              top_k = 50, 
              top_p = 0.7, 
              frequency_penalty = 0)
```

**Note**: When you encounter issues such as 504 errors due to "server congestion", we highly recommend using the `pro` version of the model `Pro/deepseek-ai/DeepSeek-R1`. 

For more model options, please refer to:

- https://siliconflow.cn/zh-cn/
- https://docs.siliconflow.cn/cn/faqs/misc#5-pro-pro


## Copyright

This software is free and open-source, distributed under the MIT License.

