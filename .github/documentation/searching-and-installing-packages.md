# Searching For and Installing Packages on NixOS

> [!NOTE]  
> Intended for consumption by Sara, but possibly of use for general readers confused as to how to
> find then install packages.

NixOS is based around a package manager, called Nix, which works with a specific, "functional" (as
opposed to object-oriented) programming language (also called Nix, seen in this repository's `*.nix` files)
that instructs it on how to build and configure packages. This paradigm offers numerous benefits but
means that package management is done **declaratively**, _with files written before one attempts to build and install them_,
instead of **imperatively**, _at runtime using a package manager in your terminal emulator_.

However, this is not always practical or desirable for users, such as in the case of wanting to try
a specific package or more complexly when one needs a specific package only while working on
a specific project. Luckily, NixOS has a sufficiently talented community of users that have solved
these needs in a few different ways, ennumerated in the subsequent paragraphs that you can use.

> [!IMPORTANT]  
> If you find a package you find yourself relying on that you install with one of the below options,
> let me know so I can more permanently add it to the configuration, which also will open up various
> options for configuring it.

## Searching for Packages

Technically, NixOS has a much broader and much better maintained package ecosystem than any other distro and is like Void Linux in the basis of that ecosystem being a very active [GitHub repository](https://github.com/NixOS/nixpkgs). Unfortunately, searching through it and the other potential sources of packages available to NixOS users is not as straightforward as it is using `pacman` or `AUR` helpers on Arch from the terminal. Luckily for you, in the two years I have used NixOS, I have worked out a set of solutions described below that ease this process immensely.

Most of your needs should be solved by the first option, rarely will going to option 2 yield anything new and if the first two lack a package you seek, either it is included in another package named something unrelated (`coreutils`...) or it is just not available in NixOS (which searching the issues attached to the `nixpkgs` repository will probably provide you an explanation as to why, if you are curious). Nonetheless, in the interest of being exhaustive in the techniques I have found success employing, I have included additional options that you may also find helpful when scouting for a specific package.

| Order of Precedence                                                           | Search Option                                                  | Description                                                              |
| ----------------------------------------------------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------ |
| 1                                                                             | `$ om search "[package name]"`                                 | Search for a package by name with my nix command line utility. [^1] [^2] |
| 2                                                                             | [NixOS Package Search Site](https://search.nixos.org/packages) | A website which indexes the                                              |
| nixpkgs repository for packages, make sure to set the "Channel" to "unstable" |
| 3                                                                             | [NUR Packages](https://nur.nix-community.org/)                 | Like AUR, but less exhaustive and not very                               |
| useful [^3] [^4]                                                              |
| 4                                                                             | [Google](https://google.com)                                   | Searching through NixOS configurations you will sometimes find           |
| packages listed no where else, which may or may not be in a useable state ^3  |

[^1] Option 1 is a command line wrapper around the `nix-search-cli` package that is available as
`nix search [query]` after installation. The results are piped into `moar` which is a less replacement
that enables colored output and is intended to be a drop-in replacement for less that just works.

[^2] This means all of the additional search syntax of `nix-search-cli` can be used after `om search`,
which you can read more about by entering `nix search --help` in your terminal emulator or reading
[Nix Search Options](#nix-search-options) below.

[^3]Installing these packages will require telling me first and honestly will rarely even yield
something you may want but by all means feel free to look.

[^4] The NUR's website has a builtin search, but it is not that great in its UX, I would advise
searching the [NUR Combined Repository](https://github.com/nix-community/nur-combined), which
aggregates the NUR repos into a single location, using GitHub's search feature (typing in the search
bar from the repo the query will include `repo:nix-community/nur-combined` meaning it just searches
that repo).

## Installing Packages (Imperatively and Temporarily)

So you want to install a package you found searching but don't want to include it in your
configuration or doing so requires telling me about it if you are Sara. There are options to do
this, some are more `hacky` than others, generally due to the overall evolution of the Nix ecosystem
or intended use cases (like wanting to try something out quickly in a development environment you
may or may not have a use for thus do not know if you want to add it to your configuration.nix or
flake.nix but need it installed to know). Below are some options to do just that and while other
options are known to exist (and likely many more that the author is ignorant of at the time of
writing), these are the least onerous and most practical in the author's humble estimation.

> [!IMPORTANT]  
> These methods temporarily install packages, again if you find you are using something often tell
> me so I can add it to the configuration.

| Method                             | Durability                         |
| ---------------------------------- | ---------------------------------- |
| nix-shell -p [package name]        | For that terminal session only     |
| nix-env -iA nixos.[package name]   | Until garbage collection is run ^1 |
| nix profile install [package name] | Until explicitly removed ^2        |

^1 Most recommended method, despite the revulsion of the nixos community as nix profile doesn't
have all the obscure/random packages in nixpkgs you may want.^2 if you use the method you won't be
able to use `nix-env -iA` until deleting its profile file, which it will indicate to you if you try
to use it. Annoying, I know, I am not the puritan that decided to make one not work if the other is
present. Bad UX design is something that you learn to live with on NixOS.

## Nix Search Options

The `om search` utility wraps the functionality added to `nix` by the `nix-search-cli` package,
meaning whatever follows `om search` is passed to `nix search nixpkgs` and thus any of the search options
that would be available to `nix search` can be used. Below are the search options extracted from the
output of `nix search --help` in an easy to read and refer to Markdown table and adapted to `om search`
specifically to ease your integration of the new package manager wrapper utility.

| Search Option                        | Description                                              |
| ------------------------------------ | -------------------------------------------------------- | --------------------------------------------------------- |
| `om search [package name]`           | Search for a package by name.                            |
| `om search #gnome3 vala`             | search gnome3 packages within nixpkgs for package `vala` |
| `om search "[package1]               | [package2]"`                                             | Search for either package1 or package2                    |
| `om search "git 'frontend            | gui'"`                                                   | Search packages containing git and either frontend or gui |
| `om search "neovim --exclude 'python | gui'"`                                                   | Search for packages containing neovim but hide ones       |
| containing either gui or python      |
