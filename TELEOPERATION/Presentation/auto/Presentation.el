(TeX-add-style-hook
 "Presentation"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("beamer" "10pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("ccicons" "scale=2")))
   (add-to-list 'LaTeX-verbatim-environments-local "semiverbatim")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
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
    "fancybox"
    "xspace")
   (TeX-add-symbols
    "themename")
   (LaTeX-add-labels
    "hybrid_matrix"
    "H_22"
    "virtParams")
   (LaTeX-add-xcolor-definecolors
    "Orange"
    "LightBlue"
    "Purple"
    "White"
    "Black"
    "Gray"
    "Sapienza"
    "BlueTOL"))
 :latex)

