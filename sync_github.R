#!/usr/bin/env Rscript

# --- 1. Configuration ---
repo_path <- "/Users/sethackerman/Documents/GitHub/host"
base_url  <- "https://sethackerman.github.io/host/"
git_path  <- "/usr/bin/git" # Verified path from 'which git'

setwd(repo_path)

# --- 2. Sanitize Filenames (Replace spaces with underscores) ---
# Get all files, excluding hidden/config files
all_files_raw <- list.files(recursive = TRUE)
ignore_files  <- c("sync.R", "index.html", "README.md", "sync_github.sh")
target_files  <- all_files_raw[!(all_files_raw %in% ignore_files) & !grepl("^\\.", all_files_raw)]

# Loop through and rename any file containing a space
for (f in target_files) {
  if (grepl(" ", f)) {
    new_name <- gsub(" ", "_", f)
    file.rename(f, new_name)
    message(paste("Renamed:", f, "->", new_name))
  }
}

# Refresh file list after renaming
final_files <- list.files(recursive = TRUE)
final_files <- final_files[!(final_files %in% ignore_files) & !grepl("^\\.", final_files)]

# --- 3. Generate the HTML Index ---
md_links <- paste0("* [", final_files, "](", base_url, final_files, ")")
md_content <- c("# Hosted Files Index", 
                paste0("_Last updated: ", Sys.time(), "_"), 
                "\n", md_links)

if (!requireNamespace("markdown", quietly = TRUE)) install.packages("markdown")
temp_md <- tempfile(fileext = ".md")
writeLines(md_content, temp_md)
markdown::mark_html(temp_md, output = "index.html")

# --- 4. Git Sync ---
run_git <- function(args) { system2(git_path, args) }

# We use 'add -A' to ensure Git notices the renames (deleting old name, adding new)
run_git(c("add", "-A"))
run_git(c("commit", "-m", paste("Auto-sync & Rename:", Sys.time())))
run_git("push")

message("Sync Complete!")