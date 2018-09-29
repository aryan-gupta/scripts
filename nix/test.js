
    var savedTime = 0;
    var errorCount = 0;
    var whereYouAt = 0;
    var useJWPLAYER = false;

    var auto_nexting = false;
    var trackPlayer = "";
    var player_reload = "";
    var current_episode_id = 148120;
    var current_epindex = 0;
    var nextEpisode = [];
    var autoNext = false;

    jQuery(document).ready(function () {
        var next = '', prev = '';
        var opt = $("#selectEpisode option");
        var current = 'https://kissanime.ac/Anime/Boku-no-Hero-Academia-3rd-Season.63295/Episode-023?id=148120';
                opt.each(function () {
                    if (jQuery(this).val() == current) {
                        next = $(this).next().val();
                        prev = $(this).prev().val();
                        if (prev) {
                            jQuery(".nexxt").attr('href', prev);
                        } else {
                            jQuery(".nexxt").hide();
                        }
                        if (next) {
                            jQuery(".preev").attr('href', next);
                        } else {
                            jQuery(".preev").hide();
                        }
                    }
                });
                if (isMobile == true) {
                    var next_ep = $('#next_ep_desk').html();
                    $('#next_ep_mobile').show();
                    $('#next_ep_mobile').html(next_ep);
                    $('#next_ep_desk').remove();
                }
                jQuery("#selectEpisode").change(function () {
                    var link = $(this).val();
                    location.assign(link);
                });
                if (window.check_adblock === undefined) {
                    $("#player_container").html('<div class="error_movie alert alert-warning notice" role="alert"><h4>Please Disable Your AdBlock</h4><p style="color:red;   font-weight: normal;">Video will be visible once you whitelist kissanime.ac on your adblocker.</p></div>');
                } else {
                    request_link(148120);
                }
                if (GetCookie('autoNext') >= 0) {
                    autoNext = true;
                    $("#auto_next").removeClass('off').addClass('on').html('<i class="fa fa-backward fa-flip-horizontal" aria-hidden="true"></i> Auto next (ON)').show();
                } else {
                    $("#auto_next").removeClass('on').addClass('off').html('<i class="fa fa-backward fa-flip-horizontal" aria-hidden="true"></i> Auto next (OFF)').show();
                    autoNext = false;
                }
            });
            function setAutoNext() {
                if (autoNext) {
                    SetCookie('autoNext', -1, 365);
                    $("#auto_next").removeClass('on').addClass('off').html('<i class="fa fa-backward fa-flip-horizontal" aria-hidden="true"></i> Auto next (OFF)').show();
                    autoNext = false;
                } else {
                    SetCookie('autoNext', 1, 365);
                    $("#auto_next").removeClass('off').addClass('on').html('<i class="fa fa-backward fa-flip-horizontal" aria-hidden="true"></i> Auto next (ON)').show();
                    autoNext = true;
                }
            }
            function autoNextEps() {
                if (autoNext) {
                    if (nextEpisode[current_epindex]) {
                        auto_nexting = true;
                        savedTime = 0;
                        errorCount = 0;
                        whereYouAt = 0;
                        //$("#player_container").html('<div id="loading"><img src="/images/loading-bars.svg" /></div>');
                        $("#div_download_link").html('');
                        $("#divQuality").css('display', 'none');
                        $("#selectQuality").html('');

                        var current_episode = 'https://kissanime.ac/Anime/Boku-no-Hero-Academia-3rd-Season.63295/' + nextEpisode[current_epindex].slug + '?id=' + nextEpisode[current_epindex].episode_id;
                        $("#selectEpisode").val(current_episode);
                        var next_episode = '', prev_episode = '';
                        $("#selectEpisode option").each(function () {
                            if (jQuery(this).val() == current_episode) {
                                next_episode = $(this).next().val();
                                prev_episode = $(this).prev().val();
                                if (prev_episode) {
                                    jQuery(".nexxt").attr('href', prev_episode).show();
                                } else {
                                    jQuery(".nexxt").hide();
                                }
                                if (next_episode) {
                                    jQuery(".preev").attr('href', next_episode).show();
                                } else {
                                    jQuery(".preev").hide();
                                }
                            }
                        });
                        history.pushState("Boku no Hero Academia 3rd Season (Sub) " + nextEpisode[current_epindex].name, "Watch Boku no Hero Academia 3rd Season (Sub) " + nextEpisode[current_epindex].name + " Online Free | Anime Online | KissAnime", '/Anime/Boku-no-Hero-Academia-3rd-Season.63295/' + nextEpisode[current_epindex].slug + '?id=' + nextEpisode[current_epindex].episode_id);
                        player_reload = "_" + nextEpisode[current_epindex].episode_id;
                        request_link(nextEpisode[current_epindex].episode_id, nextEpisode[current_epindex].slug);
                        current_epindex++;
                    }
                }
            }

            function changePlayer(ops) {
                if (ops == 'flash') {
                    SetCookie('useJWPLAYER', 1, 365);
                    SetCookie('useHTML5', -1, 365);
                } else {
                    SetCookie('useJWPLAYER', -1, 365);
                    SetCookie('useHTML5', 1, 365);
                }
                document.location.reload(true);
            }
                    var public_player;
                var autoPlayNewUrl = false;
                var audioUrl;
                function setNewUrl(url) {
                    player_reload = Math.floor((Math.random() * 999999) + 1) + Math.floor((Math.random() * 999999) + 1);
                    var html = '<video data-setup=\'{"language":"en"}\' id="player_html5' + player_reload + '" class="video-js vjs-default-skin vjs-big-play-centered" controls data-setup=\'{"nativeControlsForTouch": false}\' preload="auto" width="900" height="552px"></video>';
                    $("#player_container").html(html);
                    autoPlayNewUrl = true;
                    setPlayerHTML5(url);

                    public_player.ready(function () {
                        public_player.currentTime(whereYouAt);

                        const $ = document.querySelector.bind(document);
                        //const aud = $('#audio');
                        //public_player.on('play', aud.play.bind(aud));
                        //public_player.on('pause', aud.pause.bind(aud));
                        let last = public_player.currentTime();
                        public_player.on('timeupdate', e => {
                            let cur = public_player.currentTime();
                            if (Math.abs(cur - last) > 2) {
                                //aud.currentTime = cur
                                last = cur
                            }
                        });
                        public_player.on('volumechange', e => {
                            //aud.volume = public_player.volume();
                        });
                    });


                }
                var current_url = "/Anime/Boku-no-Hero-Academia-3rd-Season.63295/Episode-023?id=148120&amp;s=dlmserver";
                function setPlayerHTML5(url, option = "direct") {
                    //                    var adTagUrl = "https://an.facebook.com/v1/instream/vast.xml?placementid=183461635609504_183462145609453&pageurl=" + thisUrl;
                    //                    if (isMobile) {
                    //                        adTagUrl = "https://an.facebook.com/v1/instream/vast.xml?placementid=183461635609504_183461935609474&pageurl=" + thisUrl;
                    //                    }
                    var adTagUrl = "https://kissanime.ac/ima/ads.php?pageurl=" + encodeURIComponent(thisUrl);
                    var options_ima = {
                        id: 'player_html5' + player_reload,
                        adTagUrl: adTagUrl,
                        skip: 6
                    };
                    $("#autonext-control").html('');

                    var myPlayer = videojs('player_html5' + player_reload);
                    public_player = myPlayer;
                    myPlayer.ima(options_ima);
                    //                        myPlayer.ads();
                    //                        myPlayer.vast({
                    //                            url: adTagUrl
                    //                        });


                    myPlayer.ready(function () {
                        this.hotkeys({
                            volumeStep: 0.1,
                            enableMute: true,
                            enableFullscreen: true,
                            enableNumbers: true
                        });

                        this.progressTips();
                    });
                    myPlayer.on('error', function (e) {
                        try {
                            errorCount++;
                            $('#selectServer option:selected').next().attr('selected', 'selected');
                            var next_url = $("#selectServer").val();
                            if (next_url != current_url) {
                                window.location = next_url;
                            } else {
                                showErrors();
                            }
                        } catch (err) {
                        }
                    });
                    myPlayer.on('readyforpreroll', function () {
                        myPlayer.one('adended', function () {
                            timeUpdate(myPlayer);
                        });
                    });
                    myPlayer.on("ended", function () {
                        //myPlayer.pause().trigger('loadstart');
                        myPlayer.dispose();
                        trackPlayer = myPlayer;
                        autoNextEps();
                        return false;
                    });
                    myPlayer.on("timeupdate", function () {
                        whereYouAt = myPlayer.currentTime();
                        timeUpdate(myPlayer);
                    });
                    // volume
                    myPlayer.on('volumechange', function () {
                        SetCookie('videojsVolume', myPlayer.volume(), 365);
                    });

                    if (option == "direct") {
                        myPlayer.src({type: "video/mp4", src: url});
                    } else {
                        myPlayer.src({src: url, type: 'application/x-mpegURL'});
                    }
                    $('#player_html5' + player_reload).focus();
                    if (autoPlayNewUrl) {
                        myPlayer.play();
                    }
                    myPlayer.on("loadedmetadata", function () {
                        myPlayer.currentTime(whereYouAt);
                    });
                    auto_nexting = false;
                }
                function timeUpdate(myPlayer) {
                    var duration = myPlayer.duration();
                    var currentTime = myPlayer.currentTime();
                    if (duration - currentTime <= 20 && currentTime > 10 && duration >= currentTime) {
                        if (autoNext && nextEpisode[current_epindex]) {
                            $("#autonext-control").html('<p><i style="color: #8de400;" class="fa fa-spinner fa-spin"></i> Auto next to <strong>' + nextEpisode[current_epindex].name + '</strong> in <strong>' + parseInt(duration - currentTime) + 's</strong></p>').show();
                        }
                    }
                }
                var request_number = 0;
                var next_sv = false;
                function request_link(episode_id, slug) {
                    request_number++;
                    if (request_number > 3) {
                        $("#player_container").html('<div class="error_movie alert alert-warning notice" role="alert"><span style="display:block;"><i class="fa fa-exclamation-circle"></i> Initializing the video, please wait ...</span><img src="/images/loading-bars.svg"></div>');
                    }
                    if (!episode_id) {
                        episode_id = '148120';
                    }
                    if (!slug) {
                        slug = 'Episode-023';
                    }
                    var typeQuery = "?s=dlmserver";
                    if (next_sv) {
                        $('#selectServer option:selected').next().attr('selected', 'selected');
                        var next_url = $("#selectServer").val();
                        if (next_url != current_url) {
                            window.location = next_url;
                        } else {
                            showErrors();
                        }
                    } else {
                        $.ajax({
                            url: "https://kissanime.ac/ajax/anime/load_episodes_v2" + typeQuery,
                            type: "POST",
                            cache: false,
                            data: {
                                episode_id: episode_id
                            },
                            dataType: "json",
                            success: function (res) {
                                if (res.status) {
                                    if (res.html5) {
                                        useJWPLAYER = false;
                                    }
                                    load_player(res.value, res.embed, slug, res.type, res.download_get);
                                } else {
                                    try {
                                        if (!isMobile) {
                                            ga('send', 'event', "load_episodes_desktop", "error", "epid-" + episode_id);
                                        } else {
                                            ga('send', 'event', "load_episodes_mobile", "error", "epid-" + episode_id);
                                        }
                                    } catch (e) {
                                    }
                                    showErrors();
                                }
                            }
                        });
                    }
                }
                    function load_player(link_value, embed, slug, type_result, download_get) {
                    var poster_desktop = '';
                            var poster_mobile = '';
                                    if (embed) {
                                        /*$("#info_player").hide();*/
                                        $("#player_container").html(link_value);
                                        if (download_get) {
                                            $.ajax({
                                                url: download_get,
                                                type: "GET",
                                                cache: false,
                                                dataType: "json",
                                                success: function (res) {
                                                    //console.log(res);
                                                    if (!res.hasOwnProperty('status')) {
                                                        if (res.playlist && res !== 'undefined') {
                                                           if (res.hasOwnProperty('tracks')) {
                                                                var url_video = res.playlist[0]['file'];
                                                                html_sources_download = '<div style="font-size: 14px; font-weight: bold; padding-top: 15px" id="divDownload">Download links: <a target="_blank" href="' + res.playlist[0]['file'] + '">Download</a> or <a title="Convert this video to .mp3, .mp4, .avi..." class="btn" style="display: inline-block;float: none;" target="_blank" href="https://videoconvert.co/video-converter/?url=' + encodeURIComponent(res.playlist[0]['file']) + '">Convert To MP3, AVI..</a></div>';
                                                                $("#div_download_link").html(html_sources_download);
                                                            }
                                                        }
                                                    }
                                                }
                                            });
                                        }
                                    } else {
                                        var catch_player = false;
                                        if (!useJWPLAYER) {
                                            player_report = "html5";
                                            $(".note_quality").hide();
                                            if (!isMobile) {
                                                var html = '<video poster="' + poster_desktop + '" data-setup=\'{"language":"en"}\' id="player_html5' + player_reload + '" class="video-js vjs-default-skin vjs-big-play-centered" controls  data-setup=\'{"nativeControlsForTouch": false}\' preload="auto" width="900" height="552px"></video>';
                                            } else {
                                                var html = '<video poster="' + poster_mobile + '" data-setup=\'{"language":"en"}\' id="player_html5' + player_reload + '" class="video-js vjs-default-skin vjs-big-play-centered" controls  data-setup=\'{"nativeControlsForTouch": false}\' preload="auto" width="900" height="552px"></video>';
                                            }
                                            if (type_result == 'mediafire') {
                                                $.get('https://www.mediafire.com/file/' + link_value + '/', function (data) {
                                                    data = data.replace("https://download", "http://download");
                                                    pag = data.split("http://download")[1];
                                                    if (pag) {
                                                        pag = pag.split("\"")[0];
                                                        if (pag) {
                                                            url = pag.split("'")[0];
                                                            if (url == "") {
                                                                // Check link die
                                                                send_report_mediafire(link_value);
                                                                //console.log('mediafire die 1' + link_value);
                                                                request_link();
                                                                return false;
                                                            } else {
                                                                url = "https://download" + url;
                                                                $("#info_player").show();
                                                                $("#player_container").html(html);
                                                                request_number = 0;
                                                                setPlayerHTML5(url);
                                                                html_sources_download = '<div style="font-size: 14px; font-weight: bold; padding-top: 15px" id="divDownload">Download links: <a target="_blank" href="' + url + '">Download</a> or <a title="Convert this video to .mp3, .mp4, .avi..." class="btn" style="display: inline-block;float: none;" target="_blank" href="https://videoconvert.co/video-converter/?url=' + encodeURIComponent(url) + '">Convert To MP3, AVI..</a></div>';
                                                                $("#div_download_link").html(html_sources_download);
                                                            }
                                                        } else {
                                                            // Check link die
                                                            send_report_mediafire(link_value);
                                                            //console.log('mediafire die 1' + link_value);
                                                            request_link();
                                                            return false;
                                                        }
                                                    } else {
                                                        // Check link die
                                                        send_report_mediafire(link_value);
                                                        //console.log('mediafire die 1' + link_value);
                                                        request_link();
                                                        return false;
                                                    }
                                                }).fail(function () {
                                                    send_report_mediafire(link_value);
                                                    //console.log('mediafire die 2' + link_value);
                                                    request_link();
                                                    return false;
                                                });
                                            } else {
                                                $.ajax({
                                                    url: link_value,
                                                    type: "GET",
                                                    cache: false,
                                                    dataType: "json",
                                                    success: function (res) {
                                                        //console.log(res);
                                                        if (!res.hasOwnProperty('status')) {
                                                            if (res.playlist && res !== 'undefined') {
                                                                if (res.playlist[0].hasOwnProperty('sources') && res.playlist[0]['sources']) {
                                                                    var url_video = '';
                                                                    var sources = res.playlist[0]['sources'];
                                                                    var link_html = '';
                                                                    $.each(sources, function (key, value) {
                                                                        value.label = parseInt(value.label) + 'p';
                                                                        if (value.default) {
                                                                            url_video = value.file;
                                                                            $("#selectQuality").append("<option value='" + value.file + "' selected>" + value.label + "</option>");
                                                                        } else {
                                                                            if (url_video == '') {
                                                                                url_video = value.file;
                                                                            }
                                                                            $("#selectQuality").append("<option value='" + value.file + "'>" + value.label + "</option>");
                                                                        }

                                                                        var quality = '';
                                                                        if (value.label == '1080p') {
                                                                            quality = '1280x1080.mp4';
                                                                        } else if (value.label == '720p') {
                                                                            quality = '1280x720.mp4';
                                                                        } else if (value.label == '480p') {
                                                                            quality = '640x480.mp4';
                                                                        } else if (value.label == '360p') {
                                                                            quality = '480x360.mp4';
                                                                        } else if (value.label == '240p') {
                                                                            quality = '360x240.mp4';
                                                                        } else if (value.label == '214p') {
                                                                            quality = '240x214.mp4';
                                                                        } else if (value.label == '0p') {
                                                                            value.label = 'HD';
                                                                            quality = 'HD Quality';
                                                                        }
                                                                        if (value.label != 'HD') {
                                                                            var typeH = "";
                                                                            var filename = value.file;
                                                                            if (filename.indexOf("google") != "-1" || filename.indexOf("sharepoint") != "-1") {
                                                                                typeH = "&";
                                                                            } else {
                                                                                typeH = "?";
                                                                            }
                                                                            var file_download = value.file + typeH + 'type=video/mp4&title=[kissanime.ac]-Boku-no-Hero-Academia-3rd-Season.63295-' + slug;
                                                                        } else {
                                                                            var file_download = value.file;
                                                                        }
                                                                        link_html = link_html + '<a href="' + file_download + '">' + quality + '</a> - ';
                                                                    });

                                                                    link_html = link_html.substr(0, link_html.length - 3);
                                                                    html_sources_download = '<div style="font-size: 14px; font-weight: bold; padding-top: 15px" id="divDownload">Download links: ' + link_html + '</div>';
                                                                    $("#div_download_link").html(html_sources_download);

                                                                    $("#divQuality").css('display', 'inline-block');
                                                                    $("#info_player").show();
                                                                    source_report = url_video;
                                                                    $("#player_container").html(html);
                                                                    request_number = 0;
                                                                    setPlayerHTML5(url_video);
                                                                } else if (res.hasOwnProperty('tracks')) {
                                                                    $("#player_container").html(html);
                                                                    var url_video = res.playlist[0]['file'];
                                                                    if (res.hasOwnProperty('sq')) {
                                                                        audioUrl = res.audio;
                                                                        var html_audio = '<audio preload id="audio"><source src="' + audioUrl + '" type="audio/webm"></audio>';
                                                                        $("#movie-player").append(html_audio);
                                                                        $.each(res.playlist, function (key, value) {
                                                                            if (value.default) {
                                                                                url_video = value.file;
                                                                                $("#selectQuality").append("<option value='" + value.file + "' selected>" + value.label + "</option>");
                                                                            } else {
                                                                                if (url_video == '') {
                                                                                    url_video = value.file;
                                                                                }
                                                                                $("#selectQuality").append("<option value='" + value.file + "'>" + value.label + "</option>");
                                                                            }

                                                                            var typeH = "";
                                                                            var filename = value.file;
                                                                            if (filename.indexOf("google") != "-1" || filename.indexOf("sharepoint") != "-1" || filename.indexOf("fbcdn") != "-1") {
                                                                                typeH = "&";
                                                                            } else {
                                                                                typeH = "?";
                                                                            }
                                                                            var file_download = value.file + typeH + 'dl=1';
                                                                            //link_html = link_html + '<a href="' + file_download + '">' + quality + '</a> - ';
                                                                        });
                                                                        $("#divQuality").css('display', 'inline-block');
                                                                        setNewUrl(url_video);

                                                                        html_sources_download = '<div style="font-size: 14px; font-weight: bold; padding-top: 15px" id="divDownload">Download links: <a target="_blank" href="' + res.playlist[0]['file'] + '">Download</a> or <a title="Convert this video to .mp3, .mp4, .avi..." class="btn" style="display: inline-block;float: none;" target="_blank" href="https://videoconvert.co/video-converter/?url=' + encodeURIComponent(res.playlist[0]['file']) + '">Convert To MP3, AVI..</a></div>';
                                                                        //$("#div_download_link").html(html_sources_download);
                                                                    } else {
                                                                        if (res.playlist[0].hasOwnProperty('label')) {
                                                                            setPlayerHTML5(url_video);

                                                                            html_sources_download = '<div style="font-size: 14px; font-weight: bold; padding-top: 15px" id="divDownload">Download links: <a target="_blank" href="' + res.playlist[0]['file'] + '">Download</a> or <a title="Convert this video to .mp3, .mp4, .avi..." class="btn" style="display: inline-block;float: none;" target="_blank" href="https://videoconvert.co/video-converter/?url=' + encodeURIComponent(res.playlist[0]['file']) + '">Convert To MP3, AVI..</a></div>';
                                                                            $("#div_download_link").html(html_sources_download);
                                                                        } else {
                                                                            setPlayerHTML5(url_video, "blob");
                                                                        }
                                                                    }
                                                                } else {
                                                                    next_sv = true;
                                                                    request_link();
                                                                }
                                                            } else {
                                                                next_sv = true;
                                                                request_link();
                                                            }
                                                        } else {
                                                            if (request_number <= 15) {
                                                                request_link();
                                                            } else {
                                                                showErrors();
                                                            }
                                                        }
                                                    }
                                                });
                                            }
                                        } else {
                                            player_report = "jwplayer";
                                            $("#info_player").show();
                                            $(".note_quality").show();
                                            $("#divQuality").hide();
                                            var count_errors = 0;
                                            var html_sources_download = '';
                                            var playerInstance = jwplayer("player_container");
                                            playerInstance.setup({
                                                playlist: link_value,
                                                autostart: "true",
                                                height: "100%",
                                                width: "100%",
                                                primary: "html5",
                                                preload: "auto",
                                                title: "Watch more @ kissanime.ac",
                                                abouttext: "Watch more @ kissanime.ac", aboutlink: "https://kissanime.ac",
                                                advertising: {
                                                    client: 'vast',
                                                    tag: 'https://an.facebook.com/v1/instream/vast.xml?placementid=183461635609504_183462145609453&pageurl=' + thisUrl
                                                },
                                                events: {
                                                    onComplete: function () {
                                                        autoNextEps();
                                                    }
                                                },
                                            });
                                            playerInstance.addButton(
                                                    "//icons.jwplayer.com/icons/white/download.svg",
                                                    "Download This Video",
                                                    function () {
                                                        var typeH = "";
                                                        var filename = playerInstance.getPlaylistItem()['file'];
                                                        if (filename.indexOf("google") != "-1" || filename.indexOf("sharepoint") != "-1") {
                                                            typeH = "&";
                                                        } else {
                                                            typeH = "?";
                                                        }
                                                        var win = window.open(playerInstance.getPlaylistItem()['file'] + typeH + 'type=video/mp4&title=[kissanime.ac]-Boku-no-Hero-Academia-3rd-Season.63295-' + slug, '_blank');
                                                        win.focus();
                                                    },
                                                    "download"
                                                    );
                                            playerInstance.on('error', function () {
                                                count_errors++;
                                                if (count_errors > 15) {
                                                    if (html_sources_download) {
                                                        $("#player_container").html('<div style="" class="error_movie alert alert-danger notice" role="alert">' + html_sources_download + '</div>');
                                                    } else {
                                                        showErrors();
                                                    }
                                                    return false;
                                                }
                                                if (!isMobile) {
                                                    $("#player_container").html('<div id="loading"><img src="/images/loading-bars.svg" /></div>');
                                                    request_link();
                                                } else {
                                                    if (html_sources_download) {
                                                        $("#player_container").html('<div style="" class="error_movie alert alert-danger notice" role="alert">' + html_sources_download + '</div>');
                                                    }
                                                }
                                            });
                                            playerInstance.on('setupError', function () {
                                                count_errors++;
                                                if (count_errors > 15) {
                                                    if (html_sources_download) {
                                                        $("#player_container").html('<div style="" class="error_movie alert alert-danger notice" role="alert">' + html_sources_download + '</div>');
                                                    } else {
                                                        showErrors();
                                                    }
                                                    return false;
                                                }
                                                if (!isMobile) {
                                                    $("#player_container").html('<div id="loading"><img src="/images/loading-bars.svg" /></div>');
                                                    request_link();
                                                } else {
                                                    //$("#player_container").html('<div id="loading"><a href="' + playerInstance.getPlaylistItem()['file'] + '">Click here to play this Episode - ' + playerInstance.getCurrentQuality() + '</a></div>');
                                                }
                                            });
                                            playerInstance.on('ready', function () {
                                                var link_html = '';
                                                $.each(playerInstance.getPlaylistItem()['allSources'], function (key, value) {
                                                    var quality = '';
                                                    if (value.label == '1080p') {
                                                        quality = '1280x1080.' + value.type;
                                                    } else if (value.label == '720p') {
                                                        quality = '1280x720.' + value.type;
                                                    } else if (value.label == '480p') {
                                                        quality = '640x480.' + value.type;
                                                    } else if (value.label == '360p') {
                                                        quality = '480x360.' + value.type;
                                                    } else if (value.label == '240p') {
                                                        quality = '360x240.' + value.type;
                                                    } else if (value.label == '214p') {
                                                        quality = '240x214.' + value.type;
                                                    }
                                                    var typeH = "";
                                                    var filename = value.file;
                                                    if (filename.indexOf("googlevideo") != "-1" || filename.indexOf("sharepoint") != "-1") {
                                                        typeH = "&";
                                                    } else {
                                                        typeH = "?";
                                                    }
                                                    var file_download = value.file + typeH + 'type=video/mp4&title=[kissanime.ac]-Boku-no-Hero-Academia-3rd-Season.63295-' + slug;
                                                    link_html = link_html + '<a href="' + file_download + '">' + quality + '</a> - ';
                                                });
                                                link_html = link_html.substr(0, link_html.length - 3);
                                                html_sources_download = '<div style="font-size: 14px; font-weight: bold; padding-top: 15px" id="divDownload">Download links: ' + link_html + '</div>';
                                                $("#div_download_link").html(html_sources_download);
                                            });
                                        }
                                    }
                                }
                                function showErrors() {
                                    $("#player_container").html('<div style="" class="error_movie alert alert-danger notice" role="alert"> <i class="fa fa-exclamation-circle"></i> This video is broken and could not be fast forwarded, we will fix it soon.</div>');
                                }
                            function SetCookie(cookieName, cookieValue, nDays) {
                                var today = new Date();
                                var expire = new Date();
                                if (nDays == null || nDays == 0)
                                    nDays = 1;
                                expire.setTime(today.getTime() + 3600000 * 24 * nDays);
                                document.cookie = cookieName + "=" + escape(cookieValue)
                                        + ";expires=" + expire.toGMTString() + ';path=/';
                            }

                            function GetCookie(name) {
                                var value = "; " + document.cookie;
                                var parts = value.split("; " + name + "=");
                                if (parts.length == 2)
                                    return parts.pop().split(";").shift();
                            }

                            function isIE() {
                                var ua = window.navigator.userAgent;

                                var msie = ua.indexOf("MSIE ");
                                var edge = ua.indexOf("Edge/");
                                var baidu = ua.indexOf("baidubrowser");

                                if (msie > 0 || edge > 0 || baidu > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))
                                    return true;
                                else                 // If another browser, return 0
                                    return false;
                            }
                            function send_report_mediafire(link_id) {
                                var episode_id = '148120';
                                $.ajax({
                                    url: "/ajax/movie/report_mediafire",
                                    type: "POST",
                                    cache: false,
                                    data: {
                                        episode_id: episode_id,
                                        link_id: link_id,
                                    },
                                    dataType: "json",
                                    success: function (res) {
                                    }
                                });
                            }
