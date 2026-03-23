vim.filetype.add({
	extension = {
		gowork = "gowork",
		gotmpl = "gotmpl",
		mdx = "markdown.mdx",
	},
	pattern = {
		["docker%-compose%.yaml"] = "yaml.docker-compose",
		["docker%-compose%.yml"] = "yaml.docker-compose",
		["gitlab%-ci%.yml"] = "yaml.gitlab",
		["helm%-values%.yaml"] = "yaml.helm-values",
	},
})
