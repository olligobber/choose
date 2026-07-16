module Main (main) where

import Control.Applicative ((<**>))
import Data.Foldable (fold)
import Data.List (dropWhileEnd)
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
	parseFile = O.strArgument $ fold
		[ O.value "-"
		, O.metavar "File"
		, O.help $ fold
			[ "File to choose a random line from. "
			, "If the file name is - or not present, then standard input is used."
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
				fmap pure . dropWhileEnd (== '\n')
			else
				dropWhileEnd (== []) . lines
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
