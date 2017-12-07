module Main where

import Prelude hiding (between)

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Array (find, fromFoldable)
import Data.Either (Either(..), either)
import Data.Foldable (foldl, sum)
import Data.Int (fromNumber)
import Data.List (List(..), catMaybes, filter, length, (:))
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.String (fromCharArray)
import Data.Traversable (traverse)
import Data.Tuple (Tuple(..), snd)
import Global (readInt)
import Node.Encoding (Encoding(..))
import Node.FS (FS)
import Node.FS.Sync (readTextFile)
import Text.Parsing.StringParser (Parser, fail, runParser)
import Text.Parsing.StringParser.Combinators (between, many1, option, sepBy, sepBy1)
import Text.Parsing.StringParser.String (anyDigit, anyLetter, string)

data Tower = Tower String Int (List String)

instance showTower :: Show Tower where
  show (Tower n v ns) = "(Tower " <> n <> " " <> show v <> " " <> show ns <> ")"

instance eqTower :: Eq Tower where
  eq (Tower n _ _) (Tower m _ _) = n == m

nameP :: Parser String
nameP = (fromFoldable >>> fromCharArray) <$> many1 anyLetter

line :: Parser Tower
line = do
  name <- nameP
  _ <- string " "
  num <- (fromFoldable >>> fromCharArray >>> readInt 10 >>> fromNumber) <$> between (string "(") (string ")") (many1 anyDigit)
  n <- case num of
    Just n -> pure n
    _ -> fail "not int"
  names <- option Nil $ do 
    _ <- string " -> "
    sepBy1 nameP (string ", ")
  pure $ Tower name n names

roots :: Map String Tower -> List Tower
roots towers = Map.values $ reduce nonEmpty
  where
    nonEmpty = Map.filter (\(Tower _ _ l) -> l /= Nil) towers
    reduce mappings = if result == mappings then result else reduce result
      where
      remove towers (Tower _ _ children) = foldl (flip Map.delete) towers children
      result = foldl remove mappings mappings 

weight :: Map String Tower -> Tower -> Either (Tuple String Int) (Tuple Tower Int)
weight towers root = w root
  where
  w t@(Tower _ v children) = do
    res <- traverse w $ catMaybes $ (_ `Map.lookup` towers) <$> children
    let sm = sum (map snd res)
    case find (\x -> length (filter (\y -> snd x == snd y) res) == 1) res of 
      Just (Tuple (Tower n v _) vtot) ->
        -- Rather oddly calculate the expected value as the average of the other values
        Left $ Tuple n $  v + ((sm - vtot) / (length res - 1) - vtot)
      _ -> Right $ Tuple t $ v + sm 

main :: forall e. Eff (console :: CONSOLE, exception :: EXCEPTION, fs :: FS | e) Unit
main = do
  input <- readTextFile UTF8 "input.txt"
  either (const $ log "Failed to parse input") (\towers -> do
    let mappings :: Map String Tower
        mappings = Map.fromFoldable $ (\(t@Tower n _ _) -> Tuple n t) <$> towers
    case roots mappings of
      r : Nil -> do 
        logShow r
        logShow $ weight mappings  r
      _ -> log "Didn't find root"
  ) $ runParser (sepBy line (string "\n")) input
