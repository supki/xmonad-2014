#!/usr/bin/env racket
#lang racket/base

(require
  racket/cmdline
  racket/file
  racket/list
  racket/system)

(define xmonad-version (make-parameter "0.11"))
(define cabal-sandbox (make-parameter #f))

(define (xmonad-2014/cmd-args)
  (command-line
    #:once-each
    [("--xmonad") xm "xmonad package" (xmonad-version xm)]
    [("-s" "--sandbox") s "cabal sandbox path" (cabal-sandbox s)]))

(define (xmonad-2014/main)
  (with-temporary-directory
    (λ (temp-dir)
       (let*
         [(xmonad (package "xmonad" (xmonad-version)))
          (cabal (find-executable-path "cabal"))
          (patch (find-executable-path "patch"))
          (xmonad-path (build-path temp-dir (string-append xmonad "/")))
          (sandbox (cabal-sandbox))]
         (system*/exit-code/error-out cabal "get" "--destdir" temp-dir xmonad)
         (for-each
           (λ (file)
              (system*/exit-code/error-out patch "-p1" "--directory" temp-dir "--input" file))
           (directory-list (build-path (current-directory) "patch") #:build? #t))
         (apply
           system*/exit-code/error-out
           cabal
           (flatten
             (list
               "--require-sandbox"
               (if sandbox (list "--sandbox-config-file" sandbox) '())
               "install"
               xmonad-path)))))))

(define (package name version)
  (string-append name "-" version))

(define (with-temporary-directory f)
  (let ([dir #f])
    (dynamic-wind
      (λ ()
         (set! dir (make-temporary-file))
         (delete-file dir)
         (make-directory dir))
      (λ ()
         (f dir))
      (λ ()
         (delete-directory/files dir)))))

(define (system*/exit-code/error-out command . args)
  (let ([exit-code (apply system*/exit-code command args)])
    (if (zero? exit-code)
      '()
      (error 'system "command ~a exited with exit code ~s" (cons command args) exit-code))))

(xmonad-2014/cmd-args)
(xmonad-2014/main)
'!
