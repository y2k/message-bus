build:
	clj -M -m cljs.main --optimizations advanced --output-to ../src/index.js -c worker

nbuild:
	clj -M -m cljs.main -co '{:language-out :ecmascript5}'  --optimizations advanced --output-to ../src/index.js -c worker.main

watch:
	clj -M -m cljs.main -w src --optimizations advanced --output-to ../src/index.js -c worker

# :none, :whitespace, :simple, or :advanced

# debug-build:
# 	clj -M -m cljs.main --target node --output-to ../src/index.js -c worker

# repl:
# 	clj -M --main cljs.main --compile worker --repl

# old-build:
# 	clj -M -m cljs.main --target node --optimizations advanced --output-to index.js -c worker

.PHONE: nbuild watch repl old-build build
