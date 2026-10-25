{ ... }:

let
  wallpaper = builtins.fetchurl {
    name = "osaragi-wallpaper.jpg";
    url = "https://images.unsplash.com/photo-1529528744093-6f8abeee511d?ixlib=rb-4.0.3&q=85&fm=jpg&crop=fit&cs=srgb&w=2560";
    sha256 = "15hf1lgd5xi71hdlhbbxjfch7hs7zc1ic6qphwhq03qcqfyz8awk";
  };
in
{
  home.file."Pictures/Wallpapers/osaragi.jpg".source = wallpaper;
}
