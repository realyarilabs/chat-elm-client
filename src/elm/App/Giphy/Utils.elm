module App.Giphy.Utils exposing (..)


apiKey =
    "dc6zaTOxFJmzC"


baseGiphyURL =
    "https://media1.giphy.com/media/"


type alias GiphyID =
    String


giphyOriginal : GiphyID -> String
giphyOriginal id =
    id
        |> String.append baseGiphyURL
        |> (\url -> String.append url "/giphy.gif")


giphyFixedWidthSmall : GiphyID -> String
giphyFixedWidthSmall id =
    id
        |> String.append baseGiphyURL
        |> (\url -> String.append url "/100w.gif")


giphyFixedHeightSmall : GiphyID -> String
giphyFixedHeightSmall id =
    id
        |> String.append baseGiphyURL
        |> (\url -> String.append url "/100.gif")
