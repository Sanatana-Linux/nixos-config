# External Repositories

These repositories are far too complex to be built by nix and make sense to have separate version control histories, at least for me, that is independent of the development cycle of
my overall NixOS configuration(s). However I want to have them in included in my overall configurations and the means I had been trying to include the neovim and awesomewm configurations
ineffective while the use of indpendent flake for my userchrome{.js,.css} configuration meant that changes required an update to the flake inputs then a nixos-rebuild to test, which
was exceptionally painful to say the least.

However I saw this [from ryan4yin's Flake Book])(https://nixos-and-flakes.thiscute.world/best-practices/accelerating-dotfiles-debugging) and realized I could use the `mkOutOfStoreSymlink` and git submodules
I could leverage nix to effectively fully provision the system as expected without needing to worry about git cloning the awesomewm and neovim configurations or dealing with the tedious iterative process
coupled with the already onerous process of making firefox optimal for my workflow according to my idiosyncratic and mildly obsessive-compulsive preferences. Now I am free to focus on driving myself mildly 
insane to my hearts content and thus benefit more rapidly from devtools and css snippets from 3rd parties. `Hooraw!`
