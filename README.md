# ClumpMR

最近由于TwosampleMR服务器过于拥挤，导致处理数据时经常连接失；

修改下下提取工具变量与去除连锁不平衡两个函数，用于服务器连接失败时，将反复尝试，直到成功为止；

如果想使用本地方式进行去除连锁不平衡，需要自行准备pink软件及1000G文件。

install.packages("devtools")

devtools::install_github("huangyebao/ClumpMR")

#示例

library(ClumpMR)

outcomes <- c("ieu-a-299","ieu-a-300","ieu-a-302")

exposure_dat <- extract_instrument(outcomes,p1 = 5e-08,clump = FALSE)

#在线方式去除连锁不平衡

exposure_dat <- clump_dat(exposure_dat,
                          clump_kb = 10000,
                          clump_r2 = 0.01,
                          clump_p1 = 1,
                          clump_p2 = 1,
                          pop = "EUR")
                          
#或本地方式去除连锁不平衡

exposure_dat <- clump_dat(exposure_dat,
                          clump_kb = 10000,
                          clump_r2 = 0.01,
                          clump_p1 = 1,
                          clump_p2 = 1,
                          pop = "EUR"，
                          bfile = "./clump/Ref/EUR",
                          plink_bin = "./clump/plink/plink.exe")

