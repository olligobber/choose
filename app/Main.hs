module Main (main) where

import Control.Applicative ((<**>))
import Data.Foldable (fold)
import qualified Options.Applicative as O
import System.Random (randomRIO)

data MyArgs = MyArgs
	{ fileName :: String -- Location of file, "-" for standard input
	, chars :: Bool --  True to pick a random char, False to pick a random line
	}

getArgs :: O.ParserInfo MyArgs
getArgs = O.info
	(parser <**> O.helper)
	$ fold
		[ O.header "choose"
		, O.progDesc $ fold
			[ "Choose a random line from a file or standard input."
			]
		]
	where
	parser = MyArgs <$> parseFile <*> parseChars
	parseFile = O.strOption $ fold
		[ O.long "file"
		, O.short 'f'
		, O.value "-"
		, O.metavar "FILE"
		, O.help $ fold
			[ "File to choose a random line from. "
			, "If the file name is - then standard input is used."
			]
		]
	parseChars = O.switch $ fold
		[ O.long "char"
		, O.short 'c'
		, O.help "Choose a random character instead of a random line."
		]

main :: IO ()
main = do
	args <- O.execParser getArgs
	let
		fileProcessor =
			if chars args then
				(pure <$>)
			else
				lines
		fileGetter =
			if fileName args == "-" then
				getContents
			else
				readFile $ fileName args
	contents <- fileProcessor <$> fileGetter
	if contents == [] then
		error "Cannot pick random line from empty file."
	else do
		r <- randomRIO (0, length contents - 1)
		putStrLn $ contents !! r
