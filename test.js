var twitter = {
    title: 'Twitter',
    author: 'Jack D.',
    imgUrl: 'images/twitter.jpg',
    rating: 4.7,
    numDownloads: 89733992,
    summar: 'Find out what\'s happening right now'
};

var facebook = {
    title: 'FaceBook',
    author: 'Mark Z.',
    imgUrl: 'images/facebook.jpg',
    rating: 4.1,
    numDownloads: 100313781,
    summary: 'Stay connected with the world'
};

var googlePlus = {
    title: 'Google+',
    author: 'Vic G.',
    imgUrl: 'images/googleplus.jpg',
    rating: 4.8,
    numDownloads: 3874021,
    summary: 'Real life sharing made easier'
};

var chromeApps = [];
chromeApps.push(twitter);
chromeApps.push(facebook, googlePlus);
for (var i = 0; i < chromeApps.length; i++) {
    var msg = chromeApps[i].title + ': ' + chromeApps[i].numDownloads;
    console.log(msg)
}
