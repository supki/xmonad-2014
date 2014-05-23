xmonad-2014
===========

My patches for [XMonad][0]

  - 001-sandboxes-and-custom-compilation-support.patch

    Teaches `xmonad --recompile` about cabal-install sandboxes (requires [recent][1] cabal-install).
    Also any leftover arguments are passed to GHC, e.g. `xmonad --recompile -Wall` with try to
    recompile `xmonad.hs` with all warnings enabled

  - 002-automagical-compilation-on-startup-removed.patch

    By default, `xmonad` tries to recompile itself on `--replace` and `--resume`. This patches
    removes that behavior

  - 003-simplified-compilation-error-handling.patch

    Removes the call to `xmessage` on recompilation error.


Install
-------

(Requires `racket` and `cabal-install` >= 1.20.)

    % git clone https://github.com/supki/xmonad-2014 && cd xmonad-2014 && ./install.rkt

`install.rkt` accepts a bunch of options:

  - `--xmonad`

    `xmonad` package version to install (default: `0.11`)

  - `--sandbox PATH`

    Path to `cabal.sandbox.config` to use

 [0]: http://hackage.haskell.org/package/xmonad
 [1]: http://blog.johantibell.com/2014/04/announcing-cabal-120.html
