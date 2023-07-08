#' @title 对Twosample包暴露格式数据进行去除连锁不平衡
#'
#' @param dat Twosample包暴露格式数据。
#' @param clump_kb clump窗口大小,默认为10000。
#' @param clump_r2 r2  clump阈值,默认为0.001。
#' @param clump_p1 Clumping sig level for index SNPs, default is `1`.
#' @param clump_p2 Clumping sig level for secondary SNPs, default is `1`.
#' @param pop 人群种族,默认为"EUR"。
#' @param bfile 如使用本地方式去除连锁不平衡，则需要提供1000人类基因组参考文件路径；如果在线方式，调用API则默认为NULL。
#' @param plink_bin 如使用本地方式去除连锁不平衡，则需要提供plink软件的路径；如果在线方式，调用API则默认为NULL。
#'
#' @return data
#' @export

clump_dat <- function(dat,
                      clump_kb = 10000,
                      clump_r2 = 0.001,
                      clump_p1 = 1,
                      clump_p2 = 1,
                      pop = "EUR",
                      bfile = NULL,
                      plink_bin = NULL){

  message("Dr_Hyb_n_n 感谢小伙伴们的使用!\n")

  if (is.null(bfile)&is.null(plink_bin)) {
    ids <- unique(dat[["id.exposure"]])
    res <- list()
    for (i in 1:length(ids)) {
      x <- subset(dat, dat[["id.exposure"]] == ids[i])
      if (nrow(x) == 1) {
        message("Only one SNP for ", ids[i])
        res[[i]] <- x
      }
      repeat {
        tryCatch({
          res[[i]] <- TwoSampleMR::clump_data(x,
                                              clump_kb = clump_kb,
                                              clump_r2 = clump_r2,
                                              clump_p1 = clump_p1,
                                              clump_p2 = clump_p2,
                                              pop = pop)
          cat("\n")
          break
        }, error = function(e) {
          cat("\nRetrying...\n")
        })
      }
    }
    res <- dplyr::bind_rows(res)
    return(res)
  } else {
    ids <- unique(dat[["id.exposure"]])
    res <- list()
    for (i in 1:length(ids)) {
      x <- subset(dat, dat[["id.exposure"]] == ids[i])
      if (nrow(x) == 1) {
        message("Only one SNP for ", ids[i])
        res[[i]] <- x
      } else {
        message("\nClumping ", ids[i], ", ", nrow(x), " variants, using ", pop, " population reference\n")
        res[[i]] <- tryCatch({
          dplyr::rename(x, c("rsid" = "SNP", "pval" = "pval.exposure")) %>%
            ieugwasr::ld_clump_local(.,
                                     clump_kb = clump_kb,
                                     clump_r2 = clump_r2,
                                     clump_p = clump_p2,
                                     bfile = bfile,
                                     plink_bin = plink_bin) %>%
            dplyr::rename(., c("SNP" = "rsid", "pval.exposure" = "pval")) %>%
            dplyr::arrange(pval.exposure)
        }, error = function(e) {
          message("Error occurred:", conditionMessage(e))
          NULL})
        if (is.null(res[[i]])) {res[[i]] <- x}
      }
    }
    res <- dplyr::bind_rows(res)
    return(res)
  }
}
