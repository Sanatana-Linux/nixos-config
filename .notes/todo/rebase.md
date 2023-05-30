# Rebase Process


Motivation:
	- improved understanding of terminology (modules was being used incorrectly prior)
	- better isolation of home and system-wide configuration
	- streamline configuration, remove remaining elements from old methodology which prioritized quantity over quality
	- include other dotfiles as flake inputs instead of submodules (still dubious as to utility given frustrations listed below)



Lingering Pain Points
	- included dotfiles repos do not come with their `.git` folders, meaning additional development on them is frozen. These are things I modify often, so I have to comment the inclusion code out before 
