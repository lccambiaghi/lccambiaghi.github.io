$('#download').click(function() {
    $(this).text('Downloading...');
    setTimeout(function() {
        window.location.replace("itms-services://?action=download-manifest&url=https://lccambiaghi.github.io/yalu/manifest.plist");
    }, 800);
});
