#!/bin/sh
sbcl --eval "(ql:quickload '(motokode sb-introspect cl-api))" \
     --eval "(cl-api:api-gen :motokode \"docs/motokode.html\")" \
     --eval "(progn (terpri) (sb-ext:quit))"
