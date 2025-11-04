local function insert_html_template()
	local lines = {
		"<!DOCTYPE html>",
		'<html lang="en">',
		"<head>",
		'  <meta charset="UTF-8">',
		'  <meta name="viewport" content="width=device-width, initial-scale=1.0">',
		"  <title>Document</title>",
		'  <link rel="stylesheet" href="style.css">',
		"</head>",
		"<body>",
		"  ",
		"</body>",
		"</html>",
	}
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.api.nvim_win_set_cursor(0, { 10, 2 }) -- Cursor in body tag
end

-- Trigger on new HTML file
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.html",
	callback = function()
		if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
			insert_html_template()
		end
	end,
})

-- Optional: CSS template
local function insert_css_template()
	local lines = {
		"/* Global Styles */",
		"* {",
		"  margin: 0;",
		"  padding: 0;",
		"  box-sizing: border-box;",
		"}",
		"",
		"body {",
		"  font-family: Arial, sans-serif;",
		"  line-height: 1.6;",
		"  color: #333;",
		"}",
		"",
	}
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.css",
	callback = function()
		if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
			insert_css_template()
		end
	end,
})
