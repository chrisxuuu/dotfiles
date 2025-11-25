# WezTerm terminal graphics
cat("Setting up terminal graphics...\n")

options(device = function(...) {
  f <- tempfile(fileext = ".png")
  png(f, width = 1200, height = 800, res = 120)

  # Store in global env
  assign(".plot_file", f, envir = .GlobalEnv)

  invisible()
})

# Function to manually show plots
show_plot <- function() {
  if (dev.cur() > 1) {
    dev.off()
    if (exists(".plot_file", envir = .GlobalEnv)) {
      f <- get(".plot_file", envir = .GlobalEnv)

      # Use base64 command and WezTerm's iTerm2 protocol
      base64_cmd <- sprintf("base64 < %s | tr -d '\\n'", f)
      img_base64 <- system(base64_cmd, intern = TRUE)

      # Send using iTerm2 image protocol
      cat(sprintf("\033]1337;File=inline=1:%s\a\n", img_base64))

      cat("Plot displayed in terminal\n")
    }
  } else {
    cat("No plot device open\n")
  }
}

cat("Terminal graphics ready. Use show_plot() after creating plots.\n")
