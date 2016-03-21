import System.Environment
import Text.Printf

divisions = 1000 :: Int

linspace :: Double -> Double -> Int -> [Double]
linspace a b n = [a + fromIntegral j * (b-a) / fromIntegral n | j <- [0..n]]

trpzsum :: (Double -> Double) -> Double -> Double -> Int -> Double
trpzsum f a b divs =
  let
    h = ( b - a ) / fromIntegral divs
    boundariesValue = - (f a + f b) / 2.0
    insideValue =  sum $ map  f (linspace a b divs)
  in (boundariesValue + insideValue) * h

smpsnsum :: (Double -> Double) -> Double -> Double -> Int -> Double
smpsnsum f a b divs =
  let
    h = ( b - a ) /fromIntegral divs
    x = linspace a b divs
    quad = sum [ ( if odd i then  4 else 2 ) * f (x !! i) | i <- [0..divs] ]
  in (f a + f b + quad) * h / 3.0

besselKernel :: Int -> Double -> Double -> Double
besselKernel j x theta = cos ( fromIntegral j * theta - x * sin theta )

bessel :: Int -> Double -> Double
bessel j x = ( smpsnsum ( besselKernel j x ) 0 pi divisions ) / pi

main =
  do
    args <- getArgs
    let j = read ( args !! 0 ) :: Int
    let x1 = read ( args !! 1 ) :: Double
    let x2 = read ( args !! 2 ) :: Double
    let n  = read ( args !! 3 ) :: Int
    mapM_ ( \x -> printf "%f \t %f \n" x ( bessel j x ) ) ( linspace x1 x2 n )
