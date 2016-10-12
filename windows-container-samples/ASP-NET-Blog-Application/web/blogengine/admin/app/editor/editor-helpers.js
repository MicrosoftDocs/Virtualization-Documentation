function load_tags(postTags, allTags) {
    $('#postTags')
    .textext({
        plugins: 'tags autocomplete',
        tagsItems: postTags
    })
    .bind('getSuggestions', function (e, data) {
        var list = allTags,
            textext = $(e.target).textext()[0],
            query = (data ? data.query : '') || '';

        $(this).trigger(
            'setSuggestions',
            { result: textext.itemManager().filter(list, query) }
        );
    });
}

function get_tags() {
    var tags = [];
    var tagList = [];
    $('.post-tags-selector .text-tags .text-label').each(function () { tags.push($(this).text()) });
    for (var i = 0; i < tags.length; i++) {
        tagList[i] = { TagCount: 0, TagName: tags[i] };
    }
    return tagList;
}

function spinOn() {
    $("#spinner").removeClass("loaded");
    $("#spinner").addClass("loading");
}

function spinOff() {
    $("#spinner").removeClass("loading");
    $("#spinner").addClass("loaded");
}

function selectedOption(arr, val) {
    for (var i = 0; i < arr.length; i++) {
        if (typeof val === 'number') {
            if (arr[i].OptionValue === val) return arr[i];
        }
        else {
            if (arr[i].OptionValue.toLowerCase() === val.toLowerCase()) return arr[i];
        }
    }
}

var keys = keys || function (o) { var a = []; for (var k in o) a.push(k); return a; };

var toSlug = function (string) {
    var accents = "\u00C0\u00C1\u00C2\u00C3\u00C4\u00C5\u00C7\u00C8\u00C9\u00CA"
      + "\u00CB\u00CC\u00CD\u00CE\u00CF\u00D0\u00D1\u00D2\u00D3\u00D4"
      + "\u00D5\u00D6\u00D9\u00DA\u00DB\u00DC\u00DD\u00E0\u00E1\u00E2"
      + "\u00E3\u00E4\u00E5\u00E7\u00E8\u00E9\u00EA\u00EB\u00EC\u00ED"
      + "\u00EE\u00EF\u00F0\u00F1\u00F2\u00F3\u00F4\u00F5\u00F6\u00F9"
      + "\u00FA\u00FB\u00FC\u00FD\u00FF\u0100\u0101\u0102\u0103\u0104"
      + "\u0105\u0106\u0107\u0108\u0109\u010A\u010B\u010C\u010D\u010E"
      + "\u010F\u0110\u0111\u0112\u0113\u0114\u0115\u0116\u0117\u0118"
      + "\u0119\u011A\u011B\u011C\u011D\u011E\u011F\u0120\u0121\u0122"
      + "\u0123\u0124\u0125\u0126\u0127\u0128\u0129\u012A\u012B\u012C"
      + "\u012D\u012E\u012F\u0130\u0131\u0134\u0135\u0136\u0137\u0139"
      + "\u013A\u013B\u013C\u013D\u013E\u013F\u0140\u0141\u0142\u0143"
      + "\u0144\u0145\u0146\u0147\u0148\u014C\u014D\u014E\u014F\u0150"
      + "\u0151\u0154\u0155\u0156\u0157\u0158\u0159\u015A\u015B\u015C"
      + "\u015D\u015E\u015F\u0160\u0161\u0162\u0163\u0164\u0165\u0166"
      + "\u0167\u0168\u0169\u016A\u016B\u016C\u016D\u016E\u016F\u0170"
      + "\u0171\u0172\u0173\u0174\u0175\u0176\u0177\u0178\u0179\u017A"
      + "\u017B\u017C\u017D\u017E";

    var without = "AAAAAACEEE"
      + "EIIIIDNOOO"
      + "OOUUUUYaaa"
      + "aaaceeeeii"
      + "iionooooou"
      + "uuuyyAaAaA"
      + "aCcCcCcCcD"
      + "dDdEdEdEdE"
      + "eEeGgGgGgG"
      + "gHhHhIiIiI"
      + "iIiIiJjKkL"
      + "lLlLlLlLlN"
      + "nNnNnOoOoO"
      + "oRrRrRrSsS"
      + "sSsSsTtTtT"
      + "tUuUuUuUuU"
      + "uUuWwYyYZz"
      + "ZzZz";

    var map = {
        '@': ' at ', '\u20ac': ' euro ',
        '$': ' dollar ', '\u00a5': ' yen ',
        '\u0026': ' and ', '\u00e6': 'ae', '\u0153': 'oe'
    };

    return string
      .replace(
        new RegExp('[' + accents + ']', 'g'),
        function (c) { return without.charAt(accents.indexOf(c)); })
      .toLowerCase()
      .replace(
        new RegExp('[' + keys(map).join('') + ']', 'g'),
        function (c) { return map[c]; })
      .replace(/[^a-z0-9]/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '');
};

function IsImage (file) {
    if (file.match(/.png/i)) { return true; }
    if (file.match(/.jpg/i)) { return true; }
    if (file.match(/.jpeg/i)) { return true; }
    if (file.match(/.tiff/i)) { return true; }
    if (file.match(/.gif/i)) { return true; }
    if (file.match(/.bmp/i)) { return true; }
    return false;
}

function webRoot(url) {
    var result = SiteVars.ApplicationRelativeWebRoot;
    if (url.substring(0, 1) === "/") {
        return result + url.substring(1);
    }
    else {
        return result + url;
    }
}

$(document).ready(function () {

    $('[data-role=magic-overlay]').each(function () {
        var overlay = $(this), target = $(overlay.data('target'));
        overlay.css('opacity', 0).css('position', 'absolute').offset(target.offset()).width(target.outerWidth()).height(target.outerHeight());
    });

    $("#txtTitle").focus();
});
