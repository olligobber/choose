exe/choose: app/Main.hs choose.cabal package.yaml Setup.hs stack.yaml
	mkdir -p exe
	stack install . --local-bin-path ./exe/