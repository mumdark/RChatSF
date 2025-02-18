#' DeepSeek Chat Interface
#'
#' @param api_key DeepSeek API key
#' @param model model name (e.g. "deepseek-ai/DeepSeek-R1")
#' @importFrom httr POST add_headers content status_code timeout
#' @importFrom jsonlite toJSON fromJSON
#' @export
RchatSF <- function(api_key, model = "deepseek-ai/DeepSeek-R1", max_tokens = 8190, temperature = 0.6, top_k = 50, top_p = 0.7, frequency_penalty = 0) {
  .chat_completion <- function(messages, api_key, model, max_tokens, temperature, top_k, top_p, frequency_penalty) {
    API_URL <- "https://api.siliconflow.cn/v1/chat/completions"

    headers <- httr::add_headers(
      "Authorization" = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    )

    payload <- list(
      model = model,
      messages = messages,
      temperature = temperature,
      max_tokens = max_tokens,
      top_k = top_k,
      top_p = top_p,
      frequency_penalty = frequency_penalty,
      response_format = list(type = "text")
    )

    tryCatch({
      response <- httr::POST(
        API_URL,
        headers,
        body = jsonlite::toJSON(payload, auto_unbox = TRUE),
        encode = "json",
        httr::timeout(6000)
      )

      if (httr::status_code(response) != 200) {
        if (httr::status_code(response) %in% c(504, 503)) {
          stop(paste("API请求失败，服务器繁忙"))
          return(NULL)
        }else{
          stop(paste("API请求失败，状态码：", httr::status_code(response)))
          return(NULL)
        }
      }

      content <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))
      content$choices$message$content
    }, error = function(e) {
      message(paste("Error:", e$message))
      return(NULL)
    })
  }
  cat("\033[32m对话已开始，输入 'exit' 结束对话\033[0m\n")
  messages <- list()

  while (TRUE) {
    user_input <- readline("\033[36m你的问题: \033[0m")
    if (tolower(user_input) %in% c("exit", "quit")) break
    if (nchar(trimws(user_input)) == 0) next

    messages <- append(messages, list(list(role = "user", content = user_input)))
    cat("\033[33m思考中...\033[0m\n")

    response <- .chat_completion(messages, api_key, model, max_tokens, temperature, top_k, top_p, frequency_penalty)

    if (is.null(response)) {
      cat("\033[31m请求失败，请检查网络或API密钥\033[0m\n")
      messages <- messages[-length(messages)] # 移除无效的用户输入
      next
    }

    messages <- append(messages, list(list(role = "assistant", content = response)))
    cat("\n\033[35m回答:\033[0m\n", response, "\n", strrep("-", 50), "\n\n")
  }
}

