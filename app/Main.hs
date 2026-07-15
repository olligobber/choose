module Main (main) where

import Control.Applicative ((<**>))
import Data.Foldable (fold)
import qualified Options.Applicative as O
import System.Random (randomRIO)

getArgs :: O.ParserInfo String
getArgs = O.info
	(parser <**> O.helper)
	$ fold
		[ O.header "choose"
		, O.progDesc $ fold
			[ "Choose a random line from a file or standard input."
			]
		]
	where
	parser = O.strOption $ fold
		[ O.long "file"
		, O.short 'f'
		, O.value "-"
		, O.metavar "FILE"
		, O.help $ fold
			[ "File to choose a random line from. "
			, "If the file name is - then standard input is used."
			]
		]

main :: IO ()
main = do
	filename <- O.execParser getArgs
	contents <- lines <$>
		if filename == "-" then
			getContents
		else
			readFile filename
	if contents == [] then
		error "Cannot pick random line from empty file."
	else do
		r <- randomRIO (0, length contents - 1)
		putStrLn $ contents !! r
