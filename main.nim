proc main(project_dir):
	if (project_dir == NULL):
		# https://nim-lang.org/docs/nims.html
		echo "interactive Jina is not yet implemented"
		return 0
	
	# if a module is imported using gnunet or git, see if they are installed
	# and if not, ask the user to install them first, then exit with error
