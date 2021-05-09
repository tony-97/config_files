var playlist = document.getElementsByClassName("yt-simple-endpoint style-scope ytd-playlist-panel-video-renderer");

for (let i = 0; i < playlist.length; ++i)
{
    var video_list = playlist[i].href;
    var index_list = video_list.indexOf("&");
    var only_video = video_list.substr(0, index_list);
    console.log(only_video);
}
