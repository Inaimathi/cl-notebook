# cl-notebook
###### A notebook-style in-browser editor for Common Lisp.

Quick-ish video demo available [here](https://vimeo.com/97623064).

> Tools, of course, can be the subtlest of traps.
> One day I know I must smash the ~~emerald~~ Emacs.
>
> *with apologies to Neil Gaiman*

## This is now a pre-beta
##### Use it at your own risk, and expect explosions

### Dependencies

`alexandria`, `anaphora`, `cl-fad`, `closer-mop`, `optima`, `local-time`, `fact-base`, `house`

### Usage

**Either**

Download [this](http://173.255.226.138/cl-notebook-binaries/), run it (if you downloaded the tarball instead of the naked binary, unpack it first, obviously)

**Or**

You need to install the [`house` server](https://github.com/Inaimathi/house), the [`fact-base` triple-store](https://github.com/Inaimathi/fact-base) and [this repo](https://github.com/Inaimathi/cl-notebook) by cloning them.

The rest of the dependencies are [quicklispable](http://www.quicklisp.org/beta/), so you should then be able to hop into a lisp and do `(ql:quickload :cl-notebook)`, followed by `(cl-notebook:main)`. That'll start a server listening.

**Then**

Hop into a browser and go to `localhost:4242/` (or whatever port you chose)

### TODO
##### Thoughts
- Cells are now updated if their content is different on a notebook-load. This means that books that contain timestamp-related cells or similar will always be changed when they're opened. Is that what we really want?

##### Bugs

##### Features (not necessarily in priority order)
######## Back-end
- Figure out what to do about packages (thinking about defining a `:cl-notebook-user` that binds everything you need for basics and uses that in the running thread)
	- Maybe a separate cell type? It would contain just a package name change the package context of all cells coming after it (this would keep you from having to declare a new package in each cell, while allowing you to have a notebook span multiple packages)
	- Each book has a package (and system) named after it? (Renaming just got really hard)
	- This just bit again (failed to properly eval a `:cl-who` form because it wasn't being done in `:cl-notebook`). Right decision might be to default to `:cl-notebook`, but allow a system specification cell type that'd let users specify different info.
- Get `quicklisp` working properly with this.
	- Let user configure where to check for a `quicklisp` folder (default to `~/quicklisp`)
	- If `ql` package exists when loading, just use the defaults.
	- Otherwise, try to load from the user-specified `quicklisp` location.
		- If it doesn't exist, start a new install in `~/.cl-notebook/quicklisp`
	- What we want is a workflow where we transparently use the systems' existing `quicklisp` directory, if any, and create our own if one doesn't already exist (If they *have* a quicklisp folder, but re-configured `quicklisp` to store it somewhere other than the default, they'll have to similarly configure `cl-notebook`).
- Add cell dependencies (child cells get evaluated whenever the parent is evaluated)
- Use `make-broadcast-stream` and some buffering-foo to send partial `*standard-output*` results from evaluations as they arrive. Replace them with evaluation results once those are available.
- If there are no existing notebooks, we should write a default scratch book with some initial how-to instructions
- We should go through history rather than just evaluating current cells in order (they may have initially been evaluated in a different order. Doing the general thing might be better all-round)
- Build using buildapp?
- Branching for notebooks

######## Front-end
- When you fork, the only things that really needs to change are
	- The notebook title
	- The history slider and text input
	- The internal ID of the notebook
	so there's no point in re-rendering the screen. Just surgically change those and call it a day (this'll get rid of the jump when forking as part of an eval-to-cell call).
- History entries should be grouped with their parents. Guess you could pull out parent relationships at load-time? Sounds like you're getting closer and closer to sub-classing fact-base into a separate notebook class.
- Really REALLY missing s-expression-based navigation. Look into it.
	- [`subpar`](https://github.com/achengs/subpar) exists, apparently
	- You... may need to roll your own s-exp navigation/deletion stuff here. Useful information:
		- `CodeMirror.runMode(byCellId(10, ".cell-contents").value, "commonlisp", function (token, type) { console.log(token, type)})` effectively tokenizes for you.
		- The CodeMirror matching paren mode might also be a good way to get s-expresison-related stuff happening
	- Things I actually want:
		- kill-sexp (forward/backward)
		- forward-sexp, backward-sexp
		- slurp-sexp (forward/backward)
		- barf-sexp (forward/backward)
- Proper autocompletion (this may qualify as both front-end and back-end)
- Argument hints (again, both front and back-end)
- Better automatic indenting
- Better coloring
- front-end cleanup.
	- Possibly move it into a separate project?
	- Might want to annihilate some syntactic rough edges with a `defpsmacro` or two.

######## Multi-user related
- Move to a thread-per-cell model to make multi-user development easier
- If you join a book in the middle of an already running computation, you currently aren't notified of this. Figure something out.
- Moving cells around isn't propagated to other users
- Editing a cell should be propagated between saves (back-end should probably figure out when to save, and it should run operational transforms on diffs to keep from clobbering any users' input)

### License

[AGPL3](https://www.gnu.org/licenses/agpl-3.0.html) (also found in the included copying.txt)

*Short version:*

Do whatever you like, BUT afford the same freedoms to anyone you give this software or derivative works (yes, this includes the new stuff you do) to, and anyone you expose it to as a service.

### Credits

This project uses:
- [`nativesortable`](https://github.com/bgrins/nativesortable)
- [Code Mirror](http://codemirror.net/)
- [Genericons](http://genericons.com/)
- [Blob.js](https://github.com/eligrey/Blob.js) and [FileSave.js](https://github.com/eligrey/FileSaver.js)
- A spinner generated from [here](http://preloaders.net/en/letters_numbers_words)
- [`anaphora`](http://www.cliki.net/anaphora)
- [`alexandria`](http://common-lisp.net/project/alexandria/)
- [`parenscript`](http://common-lisp.net/project/parenscript/)
- [`cl-who`](http://weitz.de/cl-who/)
- [`quicklisp`](http://www.quicklisp.org/beta/)
- [`buildapp`](http://www.xach.com/lisp/buildapp/)
