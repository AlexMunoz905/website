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

var table = document.getElementById('star_table');
table.innerHTML = '';
for (var y = 0; y < 10; y++) {
    var row = document.createElement('tr');
    table.appendChild(row);
    for (var x = 0; x < 10; x++) {
        var cell = document.createElement('td');
        var img = document.createElement('img');
        <!-- No, this is NOT how to solve the problem.  Use one event handler. -->
            img.addEventListener('mouseover', function() {this.src = 'star_on.gif';}, false);
        row.appendChild(cell);
        cell.appendChild(img);
        img.src = 'star_off.gif';
    }
}
