{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
module Servant.JuicyPixels where

import Servant.API
import GHC.TypeLits
import qualified Network.HTTP.Media as M
import Codec.Picture
import Codec.Picture.Saving
import Data.Proxy
import qualified Data.ByteString.Lazy as BL

data BMP

instance Accept BMP where
    contentType _ = "image" M.// "bmp"

instance MimeRender BMP DynamicImage where
    mimeRender _ = imageToBitmap

instance MimeUnrender BMP DynamicImage where
    mimeUnrender _ = decodeBitmap . BL.toStrict



data GIF

instance Accept GIF where
    contentType _ = "image" M.// "gif"

instance MimeRender GIF DynamicImage where
    mimeRender _ = either error id . imageToGif

instance MimeUnrender GIF DynamicImage where
    mimeUnrender _ = decodeGif . BL.toStrict



data JPEG (quality :: Nat)

instance (KnownNat quality, quality <= 100) => Accept (JPEG quality) where
    contentType _ = "image" M.// "jpeg"

instance (KnownNat quality, quality <= 100) => MimeRender (JPEG quality) DynamicImage where
    mimeRender _ img =
      let quality = fromInteger $ natVal (Proxy :: Proxy quality)
      in imageToJpg quality img

instance (KnownNat quality, quality <= 100) => MimeUnrender (JPEG quality) DynamicImage where
    mimeUnrender _ = decodeJpeg . BL.toStrict



instance Accept JPEG where
    contentType _ = "image" M.// "jpeg"

instance MimeRender JPEG DynamicImage where
    mimeRender _ img = imageToJpg 50 img

instance MimeUnrender JPEG DynamicImage where
    mimeUnrender _ = decodeJpeg . BL.toStrict



data PNG

instance Accept PNG where
    contentType _ = "image" M.// "png"

instance MimeRender PNG DynamicImage where
    mimeRender _ = imageToPng

instance MimeUnrender PNG DynamicImage where
    mimeUnrender _ = decodePng . BL.toStrict



data TIFF

instance Accept TIFF where
    contentType _ = "image" M.// "tiff"

instance MimeRender TIFF DynamicImage where
    mimeRender _ = imageToTiff

instance MimeUnrender TIFF DynamicImage where
    mimeUnrender _ = decodeTiff . BL.toStrict
