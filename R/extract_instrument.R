#' @title 在线获取暴露数据
#'
#' @param outcomes 详细参考extract_instruments函数。
#'
#' @return data
#' @export

extract_instrument <- function(outcomes,
                               p1 = 5e-08,
                               clump = TRUE,
                               p2 = 5e-08,
                               r2 = 0.001,
                               kb = 10000,
                               force_server = FALSE){

  message("\nDr_Hyb_n_n 感谢小伙伴们的使用!\n")

  repeat {
    tryCatch({
      res <- TwoSampleMR::extract_instruments(outcomes,
                                               p1 = p1,
                                               clump = clump,
                                               p2 = p2,
                                               r2 = r2,
                                               kb = kb,
                                               access_token = ieugwasr::check_access_token(),
                                               force_server = force_server)
      break
    }, error = function(e) {
      cat("\nRetrying...\n")
    })
  }
  return(res)
}




