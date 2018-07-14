(TeX-add-style-hook
 "slidesQuad"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("beamer" "10pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("ccicons" "scale=2")))
   (TeX-run-style-hooks
    "latex2e"
    "gianluca"
    "giuseppe"
    "edoardo"
    "beamer"
    "beamer10"
    "appendixnumberbeamer"
    "booktabs"
    "ccicons"
    "multimedia"
    "wrapfig"
    "tabularx"
    "esint"
    "amsmath"
    "pgfplots"
    "xspace")
   (TeX-add-symbols
    "themename"))
 :latex)

