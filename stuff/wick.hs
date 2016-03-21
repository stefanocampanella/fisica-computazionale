import System.Environment
doubleFactorial n = product [n,n-2..1]
wickConnected n = doubleFactorial (2 * n - 1) - sum [ wickConnected (n-k) * doubleFactorial (2 * k - 1) | k <- [1..n-1]]
wickTable n = unlines $ [(show k) ++ [' '] ++ (show $ wickConnected k) | k<-[1..n]]
main = do
        [f, g] <- getArgs
        let n = (read f :: Integer)
        writeFile g (wickTable n)
--        writeFile "data" (wickTable 10)
