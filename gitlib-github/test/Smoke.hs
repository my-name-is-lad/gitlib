{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-unused-do-bind #-}
{-# OPTIONS_GHC -fno-warn-wrong-do-bind #-}
{-# OPTIONS_GHC -fno-warn-name-shadowing #-}

module Main where

import           Control.Applicative
import           Control.Monad
import           Control.Monad.IO.Class (liftIO)
import           Data.Text as T
import           Filesystem.Path.CurrentOS
import qualified Git
import qualified Git.Utils as Git
import qualified Git.GitHub as Gh
import qualified Git.Smoke as Git
import           System.Environment
import           System.Exit
import           Test.HUnit
import           Test.Hspec (Spec, describe, it, hspec)
import           Test.Hspec.Expectations
import           Test.Hspec.HUnit ()
import           Test.Hspec.Runner

ghFactory :: Text -> Maybe Text -> Git.RepositoryFactory Gh.GitHubRepository IO Gh.Repository
ghFactory owner token = Gh.ghFactory (Gh.GitHubUser owner) undefined token

main :: IO ()
main = do
    owner <- T.pack <$> getEnv "GITHUB_OWNER"
    token <- T.pack <$> getEnv "GITHUB_TOKEN"
    summary <- hspecWith (defaultConfig { configVerbose = True })
                        (Git.smokeTestSpec (ghFactory owner (Just token)))
    when (summaryFailures summary > 0) $ exitFailure
    return ()

-- Smoke.hs ends here
