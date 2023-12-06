
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


getCardsAmount :: [Int] -> [Int] -> Int
getCardsAmount counters cardsAmounts = do
  let counters_cardsAmounts = zip counters cardsAmounts
  let valid_counters_cardsAmounts = filter (\ccA -> fst ccA > 0) counters_cardsAmounts
  let valid_cardsAmounts = map snd valid_counters_cardsAmounts

  1 + sum valid_cardsAmounts


processLine :: String -> ([Int], [Int], Int) -> ([Int], [Int], Int)
processLine line (counters, cardsAmounts, totalCardsAmount) = do
  let lineNumbers = getNumbersPart line

  let winningNumbers = getWinningNumbers lineNumbers
  let ownedNumbers = getOwnedNumbers lineNumbers

  let cardsAmount = getCardsAmount counters cardsAmounts
  let winningNumbersAmount = getOwnedWinningNumbersAmount winningNumbers ownedNumbers

  let newCounters = map pred counters ++ [winningNumbersAmount]
  let newCardsAmounts = cardsAmounts ++ [cardsAmount]

  (newCounters, newCardsAmounts, cardsAmount)


getTotalCardsAmount :: [String] -> ([Int], [Int], Int) -> Int
getTotalCardsAmount [] _ = 0
getTotalCardsAmount (line:remainingLines) previousData = do
  let (counters, cardsAmounts, cardsAmount) = processLine line previousData

  cardsAmount + getTotalCardsAmount remainingLines (counters, cardsAmounts, cardsAmount)



main = do
  -- text <- readFile "samples/part_one.txt"
  text <- readFile "input.txt"

  let lines = getLines text
  let cardsPoints = map getCardPoints lines

  print $ sum cardsPoints
  print $ getTotalCardsAmount lines ([], [], 0)
