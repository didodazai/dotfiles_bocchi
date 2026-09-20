{ ... }:

let
  wallpaper = builtins.fetchurl {
    name = "fufexan-wallpaper.jpg";
    url = "https://images.unsplash.com/photo-1529528744093-6f8abeee511d?ixlib=rb-4.0.3&q=85&fm=jpg&crop=fit&cs=srgb&w=2560";
    sha256 = "18r5hmzglifysjmwn5j89gbbk56lbfb3f2jzwp432lr8gb5n7q8v";
  };
in
{
  home.file."Pictures/Wallpapers/fufexan.jpg".source = wallpaper;
}
