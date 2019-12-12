window.onscroll = function () {
    if ($('#infinite-scrolling').length > 0) {
        return $(window).on('scroll', function () {
            var more_posts_url;
            more_posts_url = $('.pagination .next_page a').attr('href');
            if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 500) {
                $('.pagination').html('<img style="margin-left: auto;margin-right: auto" src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
                debugger
                setTimeout(function () {
                    $.getScript(more_posts_url);
                }, 1000);

            }
            return;
        });
    }
};
