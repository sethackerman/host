# Configuration
repo_url <- "https://sethackerman.github.io/host/"
repo_path <- "~/Documents/GitHub/host" # Path to your local repo

# Get all files in the directory, excluding hidden ones and the README itself
files <- list.files(repo_path, recursive = TRUE)
files <- files[!files %in% c("README.md", "update_readme.R", "sync_github.sh", "index.html")]
files <- files[!grepl("^\\.", files)] # Exclude hidden files like .DS_Store

# Generate Markdown lines
links <- paste0("* [", files, "](", repo_url, files, ")")

# Write the README
header <- "# My Hosted Files\n\nThis list is automatically updated.\n\n"
writeLines(c(header, links), file.path(repo_path, "README.md"))