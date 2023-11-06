# snk
> ~ Sneak a peek at your markdown.

Ever wanted to just spin up a quick markdown session while in your editor,
with livereload?
Or to preview how your markdown file would look like on github or npm?
Well now you can!

This readme was previewed using snk, so you know it works. :)

![Preview](http://i.imgur.com/O4pzMH3.png)

## Install
```
$ npm install snk -g
```

## Usage

It's really simple to get started with snk.
Assuming that you have it installed(see [Install](#install)),
all you have to do to run a file is enter a directory and run the command
with the filename:

```
$ snk myfile.md
```

snk handles running the servers, orchestrating changes, and livereload,
automatically. There is no need to use the livereload extension for your browser.

By default, snk opens your file in the browser automatically.
If you wish to not do this, add the `n`/`nopen` flag:

```
$ snk myfile.md -n
```

## Profiles

snk offers a feature that no other markdown previewer offers — _profiles_.
This means that you can preview your file confident of how it'll look
on whatever website.
Right now, there's two different profiles:

1. __gh__: looks as if the markdown file was on github.
This is the default profile.
2. __npm__: looks as if the markdown file was on npm.

Selecting a profile just requires adding it as an argument to the `-p` flag:

```
$ snk myfile.md -p npm
```

I know that the profiles don't look perfect.
Please add issues and pull requests on specific things that I should fix.
If you want me to add another profile, send a pull request or an issue.
