{ ... }:

let
  wallpaper = builtins.fetchurl {
    name = "osaragi-wallpaper.jpg";
    url = "https://images.unsplash.com/photo-1529528744093-6f8abeee511d?ixlib=rb-4.0.3&q=85&fm=jpg&crop=fit&cs=srgb&w=2560";
    sha256 = "0qgfz6syn0qbsp6b79j0v5zqjs2dvw2fp5gvnqawzykn0vizjfvy";
  };
in
{
  home.file."Pictures/Wallpapers/osaragi.jpg".source = wallpaper;
}
