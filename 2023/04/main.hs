
import System.IO


_split :: String -> Char -> [String] -> [String]
_split "" _ list = list
_split (x:xs) sep [] = _split xs sep [[x]]
_split (x:xs) sep list
  | x == sep = _split xs sep (list ++ [[]])
  | otherwise = init list ++ _split xs sep [last list ++ [x]]

split :: String -> Char -> [String]
split string sep = _split string sep []


getLines :: String -> [String]
getLines text = split text '\n'


_getOnlyNumbers :: [String] -> [String]
_getOnlyNumbers = filter (\word -> word /= " " && word /= "")

_getNumbers :: String -> [Int]
_getNumbers numbersString = do
  let numbersList = split numbersString ' '
  let onlyNumbers = _getOnlyNumbers numbersList
  map (\number -> read number :: Int) onlyNumbers

getNumbersPart :: String -> String
getNumbersPart line = last $ split line ':'

getWinningNumbers :: String -> [Int]
getWinningNumbers numbersStringPart = _getNumbers $ head $ split numbersStringPart '|'

getOwnedNumbers :: String -> [Int]
getOwnedNumbers numbersStringPart = _getNumbers $ last $ split numbersStringPart '|'


getOwnedWinningNumbersAmount :: [Int] -> [Int] -> Int
getOwnedWinningNumbersAmount [] _ = 0
getOwnedWinningNumbersAmount (x:xs) ownedNumbers = (if x `elem` ownedNumbers then 1 else 0)
  + getOwnedWinningNumbersAmount xs ownedNumbers


getCardPoints :: String -> Int
getCardPoints line = do
  let lineNumbers = getNumbersPart line
  let winningNumbers = getWinningNumbers lineNumbers
  let ownedNumbers = getOwnedNumbers lineNumbers
  let winningNumbersAmount = getOwnedWinningNumbersAmount winningNumbers ownedNumbers

  if winningNumbersAmount == 0 then 0 else 2 ^ (winningNumbersAmount - 1)


main = do
  -- text <- readFile "samples/part_one.txt"
  text <- readFile "input.txt"

  let lines = getLines text
  let cardsPoints = map getCardPoints lines

  print $ sum cardsPoints
